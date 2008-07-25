From: akpm@linux-foundation.org
Subject: - cpuset-code-cleanup-for-started_after.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:11 -0700
Message-ID: <200807252259.m6PMxBxB003359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690AbYGYXGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: code-cleanup for started_after
has been removed from the -mm tree.  Its filename was
     cpuset-code-cleanup-for-started_after.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: code-cleanup for started_after
From: Lai Jiangshan <laijs@cn.fujitsu.com>

cgroup(cgroup_scan_tasks) will initialize heap->gt for us.  This patch
removes started_after() and its helper-function.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   37 ++++++-------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff -puN kernel/cpuset.c~cpuset-code-cleanup-for-started_after kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-code-cleanup-for-started_after
+++ a/kernel/cpuset.c
@@ -709,36 +709,6 @@ done:
 	/* Don't kfree(dattr) -- partition_sched_domains() does that. */
 }
 
-static inline int started_after_time(struct task_struct *t1,
-				     struct timespec *time,
-				     struct task_struct *t2)
-{
-	int start_diff = timespec_compare(&t1->start_time, time);
-	if (start_diff > 0) {
-		return 1;
-	} else if (start_diff < 0) {
-		return 0;
-	} else {
-		/*
-		 * Arbitrarily, if two processes started at the same
-		 * time, we'll say that the lower pointer value
-		 * started first. Note that t2 may have exited by now
-		 * so this may not be a valid pointer any longer, but
-		 * that's fine - it still serves to distinguish
-		 * between two tasks started (effectively)
-		 * simultaneously.
-		 */
-		return t1 > t2;
-	}
-}
-
-static inline int started_after(void *p1, void *p2)
-{
-	struct task_struct *t1 = p1;
-	struct task_struct *t2 = p2;
-	return started_after_time(t1, &t2->start_time, t2);
-}
