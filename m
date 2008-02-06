From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch removed from -mm tree
Date: Wed, 06 Feb 2008 12:37:14 -0800
Message-ID: <200802062037.m16KbFx5029145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755964AbYBFUhm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 15:37:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, ezk@cs.sunysb.edu, hch@lst.de, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: fix buggy loop
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch

This patch was dropped because it was folded into r-o-bind-mounts-track-number-of-mount-writers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: fix buggy loop
From: Dave Hansen <haveblue@us.ibm.com>

The mnt->__mnt_writers can go negative for a time if a pair of
mnt_want_write()/mnt_drop_write() calls is done on a different cpu, but for
the same mount.  This part is expected.

The lock_and_coalesce..() function should make that count positive (or at
least 0).  Hugh Dickins had found a bug in the unionfs code which caused a
permanent imbalance in this code, and eventually underflowed the atomic_t
mnt->__mnt_writers.

It also locked up the while() loop that expects the count to go up after it
is coalesced.

The following patch won't fix such a unionfs bug, but it will keep the loop
from locking up.  It will also warn a lot earlier that something funky is
going on.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |   32 +++++++++++++++++++++++---------
 include/linux/mount.h |    1 +
 2 files changed, 24 insertions(+), 9 deletions(-)

diff -puN fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop
+++ a/fs/namespace.c
@@ -224,16 +224,30 @@ static void lock_and_coalesce_cpu_mnt_wr
  */
 static void handle_write_count_underflow(struct vfsmount *mnt)
 {
-	while (atomic_read(&mnt->__mnt_writers) <
-		MNT_WRITER_UNDERFLOW_LIMIT) {
-		/*
-		 * It isn't necessary to hold all of the locks
-		 * at the same time, but doing it this way makes
-		 * us share a lot more code.
-		 */
-		lock_and_coalesce_cpu_mnt_writer_counts();
-		mnt_unlock_cpus();
+	if (atomic_read(&mnt->__mnt_writers) >=
+	    MNT_WRITER_UNDERFLOW_LIMIT)
+		return;
+	/*
+	 * It isn't necessary to hold all of the locks
+	 * at the same time, but doing it this way makes
+	 * us share a lot more code.
+	 */
+	lock_and_coalesce_cpu_mnt_writer_counts();
+	/*
+	 * If coalescing the per-cpu writer counts did not
+	 * get us back to a positive writer count, we have
+	 * a bug.
+	 */
+	if ((atomic_read(&mnt->__mnt_writers) < 0) &&
+	    !(mnt->mnt_flags & MNT_IMBALANCED_WRITE_COUNT)) {
+		printk(KERN_DEBUG "leak detected on mount(%p) writers "
+				"count: %d\n",
+			mnt, atomic_read(&mnt->__mnt_writers));
+		WARN_ON(1);
+		/* use the flag to keep the dmesg spam down */
+		mnt->mnt_flags |= MNT_IMBALANCED_WRITE_COUNT;
 	}
+	mnt_unlock_cpus();
 }
 
 /**
diff -puN include/linux/mount.h~r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop include/linux/mount.h
--- a/include/linux/mount.h~r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop
+++ a/include/linux/mount.h
@@ -31,6 +31,7 @@ struct mnt_namespace;
 #define MNT_RELATIME	0x20
 
 #define MNT_SHRINKABLE	0x100
+#define MNT_IMBALANCED_WRITE_COUNT	0x200 /* just for debugging */
 
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
do-namei_flags-calculation-inside-open_namei.patch
make-open_namei-return-a-filp.patch
kill-do_filp_open.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on-fix.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
