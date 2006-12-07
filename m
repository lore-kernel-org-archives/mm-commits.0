From: akpm@osdl.org
Subject: - new-scheme-to-preempt-swap-token.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:26 -0800
Message-ID: <200612072256.kB7MuQa6029199@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50424 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163596AbWLGW4j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ashwin.chaugule@celunite.com, a.p.zijlstra@chello.nl, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     new scheme to preempt swap token
has been removed from the -mm tree.  Its filename was
     new-scheme-to-preempt-swap-token.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: new scheme to preempt swap token
From: Ashwin Chaugule <ashwin.chaugule@celunite.com>

The new swap token patches replace the current token traversal algo.  The old
algo had a crude timeout parameter that was used to handover the token from
one task to another.  This algo, transfers the token to the tasks that are in
need of the token.  The urgency for the token is based on the number of times
a task is required to swap-in pages.  Accordingly, the priority of a task is
incremented if it has been badly affected due to swap-outs.  To ensure that
the token doesnt bounce around rapidly, the token holders are given a priority
boost.  The priority of tasks is also decremented, if their rate of swap-in's
keeps reducing.  This way, the condition to check whether to pre-empt the swap
token, is a matter of comparing two task's priority fields.

[akpm@osdl.org: cleanups]
Signed-off-by: Ashwin Chaugule <ashwin.chaugule@celunite.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h |   13 +++-
 include/linux/swap.h  |    1 
 kernel/fork.c         |    8 ++
 kernel/sysctl.c       |   11 ---
 mm/thrash.c           |  116 +++++++++++++++-------------------------
 5 files changed, 63 insertions(+), 86 deletions(-)

diff -puN include/linux/sched.h~new-scheme-to-preempt-swap-token include/linux/sched.h
--- a/include/linux/sched.h~new-scheme-to-preempt-swap-token
+++ a/include/linux/sched.h
@@ -344,9 +344,16 @@ struct mm_struct {
 	/* Architecture-specific MM context */
 	mm_context_t context;
 
-	/* Token based thrashing protection. */
-	unsigned long swap_token_time;
-	char recent_pagein;
+	/* Swap token stuff */
+	/*
+	 * Last value of global fault stamp as seen by this process.
+	 * In other words, this value gives an indication of how long
+	 * it has been since this task got the token.
+	 * Look at mm/thrash.c
+	 */
+	unsigned int faultstamp;
+	unsigned int token_priority;
+	unsigned int last_interval;
 
 	/* coredumping support */
 	int core_waiters;
diff -puN include/linux/swap.h~new-scheme-to-preempt-swap-token include/linux/swap.h
--- a/include/linux/swap.h~new-scheme-to-preempt-swap-token
+++ a/include/linux/swap.h
@@ -259,7 +259,6 @@ extern spinlock_t swap_lock;
 
 /* linux/mm/thrash.c */
 extern struct mm_struct * swap_token_mm;
-extern unsigned long swap_token_default_timeout;
 extern void grab_swap_token(void);
 extern void __put_swap_token(struct mm_struct *);
 
diff -puN kernel/fork.c~new-scheme-to-preempt-swap-token kernel/fork.c
--- a/kernel/fork.c~new-scheme-to-preempt-swap-token
+++ a/kernel/fork.c
@@ -479,6 +479,10 @@ static struct mm_struct *dup_mm(struct t
 
 	memcpy(mm, oldmm, sizeof(*mm));
 
+	/* Initializing for Swap token stuff */
+	mm->token_priority = 0;
+	mm->last_interval = 0;
+
 	if (!mm_init(mm))
 		goto fail_nomem;
 
@@ -542,6 +546,10 @@ static int copy_mm(unsigned long clone_f
 		goto fail_nomem;
 
 good_mm:
+	/* Initializing for Swap token stuff */
+	mm->token_priority = 0;
+	mm->last_interval = 0;
+
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	return 0;
diff -puN kernel/sysctl.c~new-scheme-to-preempt-swap-token kernel/sysctl.c
--- a/kernel/sysctl.c~new-scheme-to-preempt-swap-token
+++ a/kernel/sysctl.c
@@ -977,17 +977,6 @@ static ctl_table vm_table[] = {
 		.extra1		= &zero,
 	},
 #endif
-#ifdef CONFIG_SWAP
-	{
-		.ctl_name	= VM_SWAP_TOKEN_TIMEOUT,
-		.procname	= "swap_token_timeout",
-		.data		= &swap_token_default_timeout,
-		.maxlen		= sizeof(swap_token_default_timeout),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-		.strategy	= &sysctl_jiffies,
-	},
-#endif
 #ifdef CONFIG_NUMA
 	{
 		.ctl_name	= VM_ZONE_RECLAIM_MODE,
diff -puN mm/thrash.c~new-scheme-to-preempt-swap-token mm/thrash.c
--- a/mm/thrash.c~new-scheme-to-preempt-swap-token
+++ a/mm/thrash.c
@@ -7,100 +7,74 @@
  *
  * Simple token based thrashing protection, using the algorithm
  * described in:  http://www.cs.wm.edu/~sjiang/token.pdf
+ *
+ * Sep 2006, Ashwin Chaugule <ashwin.chaugule@celunite.com>
+ * Improved algorithm to pass token:
+ * Each task has a priority which is incremented if it contended
+ * for the token in an interval less than its previous attempt.
+ * If the token is acquired, that task's priority is boosted to prevent
+ * the token from bouncing around too often and to let the task make
+ * some progress in its execution.
  */
+
 #include <linux/jiffies.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/swap.h>
 
 static DEFINE_SPINLOCK(swap_token_lock);
-static unsigned long swap_token_timeout;
-static unsigned long swap_token_check;
-struct mm_struct * swap_token_mm = &init_mm;
-
-#define SWAP_TOKEN_CHECK_INTERVAL (HZ * 2)
-#define SWAP_TOKEN_TIMEOUT	(300 * HZ)
-/*
- * Currently disabled; Needs further code to work at HZ * 300.
- */
-unsigned long swap_token_default_timeout = SWAP_TOKEN_TIMEOUT;
-
-/*
- * Take the token away if the process had no page faults
- * in the last interval, or if it has held the token for
- * too long.
- */
-#define SWAP_TOKEN_ENOUGH_RSS 1
-#define SWAP_TOKEN_TIMED_OUT 2
-static int should_release_swap_token(struct mm_struct *mm)
-{
-	int ret = 0;
-	if (!mm->recent_pagein)
-		ret = SWAP_TOKEN_ENOUGH_RSS;
-	else if (time_after(jiffies, swap_token_timeout))
-		ret = SWAP_TOKEN_TIMED_OUT;
-	mm->recent_pagein = 0;
-	return ret;
-}
+struct mm_struct *swap_token_mm;
+unsigned int global_faults;
 
-/*
- * Try to grab the swapout protection token.  We only try to
- * grab it once every TOKEN_CHECK_INTERVAL, both to prevent
- * SMP lock contention and to check that the process that held
- * the token before is no longer thrashing.
- */
 void grab_swap_token(void)
 {
-	struct mm_struct *mm;
-	int reason;
+	int current_interval;
 
-	/* We have the token. Let others know we still need it. */
-	if (has_swap_token(current->mm)) {
-		current->mm->recent_pagein = 1;
-		if (unlikely(!swap_token_default_timeout))
-			disable_swap_token();
+	global_faults++;
+
+	current_interval = global_faults - current->mm->faultstamp;
+
+	if (!spin_trylock(&swap_token_lock))
 		return;
-	}
 
-	if (time_after(jiffies, swap_token_check)) {
+	/* First come first served */
+	if (swap_token_mm == NULL) {
+		current->mm->token_priority = current->mm->token_priority + 2;
+		swap_token_mm = current->mm;
+		goto out;
+	}
 
-		if (!swap_token_default_timeout) {
-			swap_token_check = jiffies + SWAP_TOKEN_CHECK_INTERVAL;
-			return;
+	if (current->mm != swap_token_mm) {
+		if (current_interval < current->mm->last_interval)
+			current->mm->token_priority++;
+		else {
+			current->mm->token_priority--;
+			if (unlikely(current->mm->token_priority < 0))
+				current->mm->token_priority = 0;
 		}
-
-		/* ... or if we recently held the token. */
-		if (time_before(jiffies, current->mm->swap_token_time))
-			return;
-
-		if (!spin_trylock(&swap_token_lock))
-			return;
-
-		swap_token_check = jiffies + SWAP_TOKEN_CHECK_INTERVAL;
-
-		mm = swap_token_mm;
-		if ((reason = should_release_swap_token(mm))) {
-			unsigned long eligible = jiffies;
-			if (reason == SWAP_TOKEN_TIMED_OUT) {
-				eligible += swap_token_default_timeout;
-			}
-			mm->swap_token_time = eligible;
-			swap_token_timeout = jiffies + swap_token_default_timeout;
+		/* Check if we deserve the token */
+		if (current->mm->token_priority >
+				swap_token_mm->token_priority) {
+			current->mm->token_priority += 2;
 			swap_token_mm = current->mm;
 		}
-		spin_unlock(&swap_token_lock);
+	} else {
+		/* Token holder came in again! */
+		current->mm->token_priority += 2;
 	}
-	return;
+
+out:
+	current->mm->faultstamp = global_faults;
+	current->mm->last_interval = current_interval;
+	spin_unlock(&swap_token_lock);
+return;
 }
 
 /* Called on process exit. */
 void __put_swap_token(struct mm_struct *mm)
 {
 	spin_lock(&swap_token_lock);
-	if (likely(mm == swap_token_mm)) {
-		mm->swap_token_time = jiffies + SWAP_TOKEN_CHECK_INTERVAL;
-		swap_token_mm = &init_mm;
-		swap_token_check = jiffies;
-	}
+	if (likely(mm == swap_token_mm))
+		swap_token_mm = NULL;
 	spin_unlock(&swap_token_lock);
 }
_

Patches currently in -mm which might be from ashwin.chaugule@celunite.com are

origin.patch

