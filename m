From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch removed from -mm tree
Date: Wed, 06 Feb 2008 12:35:56 -0800
Message-ID: <200802062035.m16KZunP029094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55532 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383AbYBFUgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 15:36:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     r-o-bind-mounts: track number of mount writers make lockdep happy with r/o bind mounts
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch

This patch was dropped because it was folded into r-o-bind-mounts-track-number-of-mount-writers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r-o-bind-mounts: track number of mount writers make lockdep happy with r/o bind mounts
From: Dave Hansen <haveblue@us.ibm.com>

With the r/o bind mount patches, we can have as many spinlocks nested as there
are CPUs on the system.  Lockdep freaks out after 8.

So, create a new lockdep class of locks for the mnt_writer spinlocks, and
initialize each of the cpu locks to be in a different class.

It should shut up warnings like this, while still allowing some of the lockdep
goodness to remain:

=============================================
[ INFO: possible recursive locking detected ]

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts
+++ a/fs/namespace.c
@@ -115,6 +115,7 @@ struct mnt_writer {
 	 * must be ordered by cpu number.
 	 */
 	spinlock_t lock;
+	struct lock_class_key lock_class; /* compiles out with !lockdep */
 	unsigned long count;
 	struct vfsmount *mnt;
 } ____cacheline_aligned_in_smp;
@@ -126,6 +127,7 @@ static int __init init_mnt_writers(void)
 	for_each_possible_cpu(cpu) {
 		struct mnt_writer *writer = &per_cpu(mnt_writers, cpu);
 		spin_lock_init(&writer->lock);
+		lockdep_set_class(&writer->lock, &writer->lock_class);
 		writer->count = 0;
 	}
 	return 0;
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
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on-fix.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
