From: akpm@osdl.org
Subject: - oom-less-memdie.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:19 -0800
Message-ID: <200612072256.kB7MuJTE029190@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50290 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163579AbWLGW4W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     oom: less memdie
has been removed from the -mm tree.  Its filename was
     oom-less-memdie.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: less memdie
From: Nick Piggin <npiggin@suse.de>

Don't cause all threads in all other thread groups to gain TIF_MEMDIE
otherwise we'll get a thundering herd eating our memory reserve.  This may not
be the optimal scheme, but it fits our policy of allowing just one TIF_MEMDIE
in the system at once.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/oom_kill.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~oom-less-memdie mm/oom_kill.c
--- a/mm/oom_kill.c~oom-less-memdie
+++ a/mm/oom_kill.c
@@ -323,11 +323,12 @@ static int oom_kill_task(struct task_str
 
 	/*
 	 * kill all processes that share the ->mm (i.e. all threads),
-	 * but are in a different thread group.
+	 * but are in a different thread group. Don't let them have access
+	 * to memory reserves though, otherwise we might deplete all memory.
 	 */
 	do_each_thread(g, q) {
 		if (q->mm == mm && q->tgid != p->tgid)
-			__oom_kill_task(q, 1);
+			force_sig(SIGKILL, p);
 	} while_each_thread(g, q);
 
 	return 0;
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

