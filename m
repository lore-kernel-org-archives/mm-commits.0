From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-prevent-possible-oom_disable-livelock.patch removed from -mm tree
Date: Mon, 11 May 2009 15:17:27 -0700
Message-ID: <200905112217.n4BMHRF8001913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759770AbZEKWVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 18:21:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, a.p.ziljstra@chello.nl, mel@csn.ul.ie, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     oom: prevent possible OOM_DISABLE livelock
has been removed from the -mm tree.  Its filename was
     oom-prevent-possible-oom_disable-livelock.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: prevent possible OOM_DISABLE livelock
From: David Rientjes <rientjes@google.com>

This moves the check for OOM_DISABLE to the badness heuristic while
holding task_lock().  Badness scores of 0 are now explicitly prohibited
from being oom killed and since the oom_adj value is a characteristic of
an mm and not a task, it is no longer necessary to check the oom_adj value
for threads sharing the same memory (except when simply issuing SIGKILLs
for threads in other thread groups).

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Ziljstra <a.p.ziljstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   40 ++++++++++------------------------------
 1 file changed, 10 insertions(+), 30 deletions(-)

diff -puN mm/oom_kill.c~oom-prevent-possible-oom_disable-livelock mm/oom_kill.c
--- a/mm/oom_kill.c~oom-prevent-possible-oom_disable-livelock
+++ a/mm/oom_kill.c
@@ -67,6 +67,10 @@ unsigned long badness(struct task_struct
 		return 0;
 	}
 	oom_adj = mm->oom_adj;
+	if (oom_adj == OOM_DISABLE) {
+		task_unlock(p);
+		return 0;
+	}
 
 	/*
 	 * The memory size of the process is the basis for the badness.
@@ -253,13 +257,8 @@ static struct task_struct *select_bad_pr
 			*ppoints = ULONG_MAX;
 		}
 
-		task_lock(p);
-		if (p->mm && p->mm->oom_adj == OOM_DISABLE)
-			continue;
-		task_unlock(p);
-
 		points = badness(p, uptime.tv_sec);
-		if (points > *ppoints || !chosen) {
+		if (points > *ppoints) {
 			chosen = p;
 			*ppoints = points;
 		}
@@ -352,32 +351,13 @@ static int oom_kill_task(struct task_str
 	struct mm_struct *mm;
 	struct task_struct *g, *q;
 
+	task_lock(p);
 	mm = p->mm;
-
-	/* WARNING: mm may not be dereferenced since we did not obtain its
-	 * value from get_task_mm(p).  This is OK since all we need to do is
-	 * compare mm to q->mm below.
-	 *
-	 * Furthermore, even if mm contains a non-NULL value, p->mm may
-	 * change to NULL at any time since we do not hold task_lock(p).
-	 * However, this is of no concern to us.
-	 */
-
-	if (mm == NULL)
+	if (!mm || mm->oom_adj == OOM_DISABLE) {
+		task_unlock(p);
 		return 1;
-
-	/*
-	 * Don't kill the process if any threads are set to OOM_DISABLE
-	 */
-	do_each_thread(g, q) {
-		task_lock(q);
-		if (q->mm == mm && q->mm && q->mm->oom_adj == OOM_DISABLE) {
-			task_unlock(q);
-			return 1;
-		}
-		task_unlock(q);
-	} while_each_thread(g, q);
