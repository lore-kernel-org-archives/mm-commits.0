From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:22 -0700
Message-ID: <200803261840.m2QIeMfq028658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759319AbYCZSpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:45:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate write count for callers of vfs_mkdir()
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: elevate write count for callers of vfs_mkdir()
From: Dave Hansen <haveblue@us.ibm.com>

Pretty self-explanatory.  Fits in with the rest of the series.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |    5 +++++
 fs/nfsd/nfs4recover.c |    5 +++++
 2 files changed, 10 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir
+++ a/fs/namei.c
@@ -2083,7 +2083,12 @@ asmlinkage long sys_mkdirat(int dfd, con
 
 	if (!IS_POSIXACL(nd.path.dentry->d_inode))
 		mode &= ~current->fs->umask;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
 	error = vfs_mkdir(nd.path.dentry->d_inode, dentry, mode);
+	mnt_drop_write(nd.path.mnt);
+out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
diff -puN fs/nfsd/nfs4recover.c~r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir fs/nfsd/nfs4recover.c
--- a/fs/nfsd/nfs4recover.c~r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir
+++ a/fs/nfsd/nfs4recover.c
@@ -41,6 +41,7 @@
 #include <linux/nfsd/xdr4.h>
 #include <linux/param.h>
 #include <linux/file.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <asm/uaccess.h>
 #include <linux/scatterlist.h>
@@ -154,7 +155,11 @@ nfsd4_create_clid_dir(struct nfs4_client
 		dprintk("NFSD: nfsd4_create_clid_dir: DIRECTORY EXISTS\n");
 		goto out_put;
 	}
+	status = mnt_want_write(rec_dir.mnt);
+	if (status)
+		goto out_put;
 	status = vfs_mkdir(rec_dir.path.dentry->d_inode, dentry, S_IRWXU);
+	mnt_drop_write(rec_dir.mnt);
 out_put:
 	dput(dentry);
 out_unlock:
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

