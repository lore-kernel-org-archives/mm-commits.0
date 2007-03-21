From: akpm@linux-foundation.org
Subject: + swsusp-fix-error-paths-in-snapshot_open.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:24:50 -0700
Message-ID: <200703212224.l2LMOohN005393@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56565 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965393AbXCUWZX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     swsusp: fix error paths in snapshot_open
has been added to the -mm tree.  Its filename is
     swsusp-fix-error-paths-in-snapshot_open.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: swsusp: fix error paths in snapshot_open
From: Rafael J. Wysocki <rjw@sisk.pl>

We forget to increase device_available if there's an error in snapshot_open(),
so the snapshot device cannot be open at all after snapshot_open() has
returned an error.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

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
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
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
