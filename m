From: akpm@osdl.org
Subject: - oom-dont-kill-unkillable-children-or-siblings.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:14 -0800
Message-ID: <200612072256.kB7MuEmq029176@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50267 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163576AbWLGW4S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     oom: don't kill unkillable children or siblings
has been removed from the -mm tree.  Its filename was
     oom-dont-kill-unkillable-children-or-siblings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: don't kill unkillable children or siblings
From: Nick Piggin <npiggin@suse.de>

Abort the kill if any of our threads have OOM_DISABLE set.  Having this
test here also prevents any OOM_DISABLE child of the "selected" process
from being killed.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/oom_kill.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~oom-dont-kill-unkillable-children-or-siblings mm/oom_kill.c
--- a/mm/oom_kill.c~oom-dont-kill-unkillable-children-or-siblings
+++ a/mm/oom_kill.c
@@ -313,15 +313,24 @@ static int oom_kill_task(struct task_str
 	if (mm == NULL)
 		return 1;
 
+	/*
+	 * Don't kill the process if any threads are set to OOM_DISABLE
+	 */
+	do_each_thread(g, q) {
+		if (q->mm == mm && p->oomkilladj == OOM_DISABLE)
+			return 1;
+	} while_each_thread(g, q);
+
 	__oom_kill_task(p, message);
+
 	/*
 	 * kill all processes that share the ->mm (i.e. all threads),
 	 * but are in a different thread group
 	 */
-	do_each_thread(g, q)
+	do_each_thread(g, q) {
 		if (q->mm == mm && q->tgid != p->tgid)
 			__oom_kill_task(q, message);
-	while_each_thread(g, q);
+	} while_each_thread(g, q);
 
 	return 0;
 }
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

