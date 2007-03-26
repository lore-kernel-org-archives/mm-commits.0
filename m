From: akpm@linux-foundation.org
Subject: - make-xfs-workqueues-nonfreezable.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:15 -0800
Message-ID: <200703260105.l2Q15FTS008701@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327AbXCZBFb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:05:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, dgc@sgi.com, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Make XFS workqueues nonfreezable
has been removed from the -mm tree.  Its filename was
     make-xfs-workqueues-nonfreezable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make XFS workqueues nonfreezable
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Since freezable workqueues are broken in 2.6.21-rc
(cf. http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755,
http://marc.theaimsgroup.com/?l=linux-kernel&m=117261312523921&w=2)
it's better to change the only user of them, which is XFS, to use "normal"
nonfreezable workqueues.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_buf.c~make-xfs-workqueues-nonfreezable fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~make-xfs-workqueues-nonfreezable
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -1829,11 +1829,11 @@ xfs_buf_init(void)
 	if (!xfs_buf_zone)
 		goto out_free_trace_buf;
 
-	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
+	xfslogd_workqueue = create_workqueue("xfslogd");
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;
 
-	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
+	xfsdatad_workqueue = create_workqueue("xfsdatad");
 	if (!xfsdatad_workqueue)
 		goto out_destroy_xfslogd_workqueue;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
shrink_slab-handle-bad-shrinkers.patch
