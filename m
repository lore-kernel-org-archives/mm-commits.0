From: akpm@osdl.org
Subject: - oom-cleanup-messages.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:17 -0800
Message-ID: <200612072256.kB7MuHIq029183@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50281 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163578AbWLGW4V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     oom: cleanup messages
has been removed from the -mm tree.  Its filename was
     oom-cleanup-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: cleanup messages
From: Nick Piggin <npiggin@suse.de>

Clean up the OOM killer messages to be more consistent.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/oom_kill.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff -puN mm/oom_kill.c~oom-cleanup-messages mm/oom_kill.c
--- a/mm/oom_kill.c~oom-cleanup-messages
+++ a/mm/oom_kill.c
@@ -264,7 +264,7 @@ static struct task_struct *select_bad_pr
  * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
  * set.
  */
-static void __oom_kill_task(struct task_struct *p, const char *message)
+static void __oom_kill_task(struct task_struct *p, int verbose)
 {
 	if (is_init(p)) {
 		WARN_ON(1);
@@ -278,10 +278,8 @@ static void __oom_kill_task(struct task_
 		return;
 	}
 
-	if (message) {
-		printk(KERN_ERR "%s: Killed process %d (%s).\n",
-				message, p->pid, p->comm);
-	}
+	if (verbose)
+		printk(KERN_ERR "Killed process %d (%s)\n", p->pid, p->comm);
 
 	/*
 	 * We give our sacrificial lamb high priority and access to
@@ -294,7 +292,7 @@ static void __oom_kill_task(struct task_
 	force_sig(SIGKILL, p);
 }
 
-static int oom_kill_task(struct task_struct *p, const char *message)
+static int oom_kill_task(struct task_struct *p)
 {
 	struct mm_struct *mm;
 	struct task_struct *g, *q;
@@ -321,15 +319,15 @@ static int oom_kill_task(struct task_str
 			return 1;
 	} while_each_thread(g, q);
 
-	__oom_kill_task(p, message);
+	__oom_kill_task(p, 1);
 
 	/*
 	 * kill all processes that share the ->mm (i.e. all threads),
-	 * but are in a different thread group
+	 * but are in a different thread group.
 	 */
 	do_each_thread(g, q) {
 		if (q->mm == mm && q->tgid != p->tgid)
-			__oom_kill_task(q, message);
+			__oom_kill_task(q, 1);
 	} while_each_thread(g, q);
 
 	return 0;
@@ -346,21 +344,22 @@ static int oom_kill_process(struct task_
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
 	if (p->flags & PF_EXITING) {
-		__oom_kill_task(p, NULL);
+		__oom_kill_task(p, 0);
 		return 0;
 	}
 
-	printk(KERN_ERR "Out of Memory: Kill process %d (%s) score %li"
-			" and children.\n", p->pid, p->comm, points);
+	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
+					message, p->pid, p->comm, points);
+
 	/* Try to kill a child first */
 	list_for_each(tsk, &p->children) {
 		c = list_entry(tsk, struct task_struct, sibling);
 		if (c->mm == p->mm)
 			continue;
-		if (!oom_kill_task(c, message))
+		if (!oom_kill_task(c))
 			return 0;
 	}
-	return oom_kill_task(p, message);
+	return oom_kill_task(p);
 }
 
 static BLOCKING_NOTIFIER_HEAD(oom_notify_list);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-only-mm-debug-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks-comment.patch
mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix.patch
mm-fix-pagecache-write-deadlocks-zerolength-fix.patch
mm-fix-pagecache-write-deadlocks-stale-holes-fix.patch
fs-prepare_write-fixes.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-jffs-fix.patch
fs-prepare_write-fixes-fat-fix.patch
fs-fix-cont-vs-deadlock-patches.patch

