From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch removed from -mm tree
Date: Mon, 05 Nov 2007 15:07:13 -0800
Message-ID: <200711052307.lA5N7DgM024335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483AbXKEXHZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:07:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate write count over calls to vfs_rename()
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r/o bind mounts: elevate write count over calls to vfs_rename()
From: Dave Hansen <haveblue@us.ibm.com>

This also uses the little helper in the NFS code to make an if() a little bit
less ugly.  We introduced the helper at the beginning of the series.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c    |    4 ++++
 fs/nfsd/vfs.c |   15 +++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename
+++ a/fs/namei.c
@@ -2658,8 +2658,12 @@ static int do_rename(int olddfd, const c
 	if (new_dentry == trap)
 		goto exit5;
 
+	error = mnt_want_write(oldnd.mnt);
+	if (error)
+		goto exit5;
 	error = vfs_rename(old_dir->d_inode, old_dentry,
 				   new_dir->d_inode, new_dentry);
+	mnt_drop_write(oldnd.mnt);
 exit5:
 	dput(new_dentry);
 exit4:
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename
+++ a/fs/nfsd/vfs.c
@@ -1668,13 +1668,20 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 	if (ndentry == trap)
 		goto out_dput_new;
 
-#ifdef MSNFS
-	if ((ffhp->fh_export->ex_flags & NFSEXP_MSNFS) &&
+	if (svc_msnfs(ffhp) &&
 		((atomic_read(&odentry->d_count) > 1)
 		 || (atomic_read(&ndentry->d_count) > 1))) {
 			host_err = -EPERM;
-	} else
-#endif
+			goto out_dput_new;
+	}
+
+	host_err = -EXDEV;
+	if (ffhp->fh_export->ex_mnt != tfhp->fh_export->ex_mnt)
+		goto out_dput_new;
+	host_err = mnt_want_write(ffhp->fh_export->ex_mnt);
+	if (host_err)
+		goto out_dput_new;
+
 	host_err = vfs_rename(fdir, odentry, tdir, ndentry);
 	if (!host_err && EX_ISSYNC(tfhp->fh_export)) {
 		host_err = nfsd_sync_dir(tdentry);
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
