From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:39:39 -0800
Message-ID: <200711052339.lA5Nddq7025641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbXKEXtX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:49:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com


The patch titled
     r-o-bind-mounts: track number of mount writers make lockdep happy with r/o bind mounts
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

markers-fix-warnings.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
do-namei_flags-calculation-inside-open_namei.patch
make-open_namei-return-a-filp.patch
kill-do_filp_open.patch
kill-filp_open.patch
kill-filp_open-checkpatch-fixes.patch
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
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
