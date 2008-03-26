From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:48 -0700
Message-ID: <200803261840.m2QIemoI028702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758149AbYCZSlT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:41:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: get write access for vfs_rename() callers
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: get write access for vfs_rename() callers
From: Dave Hansen <haveblue@us.ibm.com>

This also uses the little helper in the NFS code to make an if() a little bit
less ugly.  We introduced the helper at the beginning of the series.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c    |    4 ++++
 fs/nfsd/vfs.c |   17 +++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-get-write-access-for-vfs_rename-callers fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-get-write-access-for-vfs_rename-callers
+++ a/fs/namei.c
@@ -2752,8 +2752,12 @@ static int do_rename(int olddfd, const c
 	if (new_dentry == trap)
 		goto exit5;
 
+	error = mnt_want_write(oldnd.path.mnt);
+	if (error)
+		goto exit5;
 	error = vfs_rename(old_dir->d_inode, old_dentry,
 				   new_dir->d_inode, new_dentry);
+	mnt_drop_write(oldnd.path.mnt);
 exit5:
 	dput(new_dentry);
 exit4:
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-get-write-access-for-vfs_rename-callers fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~r-o-bind-mounts-get-write-access-for-vfs_rename-callers
+++ a/fs/nfsd/vfs.c
@@ -1678,13 +1678,20 @@ nfsd_rename(struct svc_rqst *rqstp, stru
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
@@ -1692,6 +1699,8 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 			host_err = nfsd_sync_dir(fdentry);
 	}
 
+	mnt_drop_write(ffhp->fh_export->ex_mnt);
+
  out_dput_new:
 	dput(ndentry);
  out_dput_old:
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

git-vfs.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch

