From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch removed from -mm tree
Date: Mon, 05 Nov 2007 15:07:15 -0800
Message-ID: <200711052307.lA5N7FeY024338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53617 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbXKEXH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:07:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: nfs: check mnt instead of superblock directly
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r/o bind mounts: nfs: check mnt instead of superblock directly
From: Dave Hansen <haveblue@us.ibm.com>

If we depend on the inodes for writeability, we will not catch the r/o mounts
when implemented.

This patches uses __mnt_want_write().  It does not guarantee that the mount
will stay writeable after the check.  But, this is OK for one of the checks
because it is just for a printk().

The other two are probably unnecessary and duplicate existing checks in the
VFS.  This won't make them better checks than before, but it will make them
detect r/o mounts.

Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/dir.c  |    3 ++-
 fs/nfsd/vfs.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/nfs/dir.c~r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly fs/nfs/dir.c
--- a/fs/nfs/dir.c~r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly
+++ a/fs/nfs/dir.c
@@ -949,7 +949,8 @@ static int is_atomic_open(struct inode *
 	if (nd->flags & LOOKUP_DIRECTORY)
 		return 0;
 	/* Are we trying to write to a read only partition? */
-	if (IS_RDONLY(dir) && (nd->intent.open.flags & (O_CREAT|O_TRUNC|FMODE_WRITE)))
+	if (__mnt_is_readonly(nd->mnt) &&
+	    (nd->intent.open.flags & (O_CREAT|O_TRUNC|FMODE_WRITE)))
 		return 0;
 	return 1;
 }
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly
+++ a/fs/nfsd/vfs.c
@@ -1862,7 +1862,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 		inode->i_mode,
 		IS_IMMUTABLE(inode)?	" immut" : "",
 		IS_APPEND(inode)?	" append" : "",
-		IS_RDONLY(inode)?	" ro" : "");
+		__mnt_is_readonly(exp->ex_mnt)?	" ro" : "");
 	dprintk("      owner %d/%d user %d/%d\n",
 		inode->i_uid, inode->i_gid, current->fsuid, current->fsgid);
 #endif
@@ -1873,7 +1873,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	 */
 	if (!(acc & MAY_LOCAL_ACCESS))
 		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
-			if (exp_rdonly(rqstp, exp) || IS_RDONLY(inode))
+			if (exp_rdonly(rqstp, exp) || __mnt_is_readonly(exp->ex_mnt))
 				return nfserr_rofs;
 			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
 				return nfserr_perm;
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
