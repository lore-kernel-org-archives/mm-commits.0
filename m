From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-write-count-for-file_update_time.patch removed from -mm tree
Date: Mon, 05 Nov 2007 15:07:07 -0800
Message-ID: <200711052307.lA5N77MI024326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53928 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbXKEXMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:12:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate write count for file_update_time()
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-write-count-for-file_update_time.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r/o bind mounts: elevate write count for file_update_time()
From: Dave Hansen <haveblue@us.ibm.com>

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/inode.c~r-o-bind-mounts-elevate-write-count-for-file_update_time fs/inode.c
--- a/fs/inode.c~r-o-bind-mounts-elevate-write-count-for-file_update_time
+++ a/fs/inode.c
@@ -1259,10 +1259,19 @@ void file_update_time(struct file *file)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct timespec now;
 	int sync_it = 0;
+	int err = 0;
 
 	if (IS_NOCMTIME(inode))
 		return;
-	if (IS_RDONLY(inode))
+	/*
+	 * Ideally, we want to guarantee that 'f_vfsmnt'
+	 * is non-NULL here.  But, NFS exports need to
+	 * be fixed up before we can do that.  So, check
+	 * it for now. - Dave Hansen
+	 */
+	if (file->f_vfsmnt)
+		err = mnt_want_write(file->f_vfsmnt);
+	if (err)
 		return;
 
 	now = current_fs_time(inode->i_sb);
@@ -1278,6 +1287,8 @@ void file_update_time(struct file *file)
 
 	if (sync_it)
 		mark_inode_dirty_sync(inode);
+	if (file->f_vfsmnt)
+		mnt_drop_write(file->f_vfsmnt);
 }
 
 EXPORT_SYMBOL(file_update_time);
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
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
