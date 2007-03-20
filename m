From: akpm@linux-foundation.org
Subject: - swsusp-fix-error-paths-in-snapshot_open.patch removed from -mm tree
Date: Mon, 19 Mar 2007 17:32:13 -0700
Message-ID: <200703200034.l2K0YAHR021967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36593 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030800AbXCTAeR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 20:34:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: fix error paths in snapshot_open
has been removed from the -mm tree.  Its filename was
     swsusp-fix-error-paths-in-snapshot_open.patch

This patch was dropped because it got collaterally broken

------------------------------------------------------
Subject: swsusp: fix error paths in snapshot_open
From: Rafael J. Wysocki <rjw@sisk.pl>

We forget to increase device_available if there's an error in
snapshot_open(), so the snapshot device cannot be open at all after
snapshot_open() has returned an error.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/power/user.c~swsusp-fix-error-paths-in-snapshot_open kernel/power/user.c
--- a/kernel/power/user.c~swsusp-fix-error-paths-in-snapshot_open
+++ a/kernel/power/user.c
@@ -49,12 +49,14 @@ static int snapshot_open(struct inode *i
 	if (!atomic_add_unless(&device_available, -1, 0))
 		return -EBUSY;
 
-	if ((filp->f_flags & O_ACCMODE) == O_RDWR)
+	if ((filp->f_flags & O_ACCMODE) == O_RDWR) {
+		atomic_inc(&device_available);
 		return -ENOSYS;
-
-	if(create_basic_memory_bitmaps())
+	}
+	if(create_basic_memory_bitmaps()) {
+		atomic_inc(&device_available);
 		return -ENOMEM;
-
+	}
 	nonseekable_open(inode, filp);
 	data = &snapshot_state;
 	filp->private_data = data;
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
make-xfs-workqueues-nonfreezable.patch
fix-refrigerator-vs-thaw_process-race.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
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
