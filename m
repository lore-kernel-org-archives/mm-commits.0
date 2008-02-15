From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:48:53 -0800
Message-ID: <200802152248.m1FMmrfp028144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58463 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762556AbYBOWtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:49:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, akpm@linux-foundation.org, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     r/o bind mounts: elevate write count for callers of vfs_mkdir()
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

enable-hotplug-memory-remove-for-ppc64.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
hppfs-pass-vfsmount-to-dentry_open.patch
check-for-null-vfsmount-in-dentry_open.patch
fix-up-new-filp-allocators.patch
do-namei_flags-calculation-inside-open_namei.patch
merge-open_namei-and-do_filp_open.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-create-helper-to-drop-file-write-access.patch
r-o-bind-mounts-drop-write-during-emergency-remount.patch
r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch
r-o-bind-mounts-elevate-write-count-for-ncp_ioctl.patch
r-o-bind-mounts-write-counts-for-time-functions.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-write-count-for-file_update_time.patch
r-o-bind-mounts-write-counts-for-link-symlink.patch
r-o-bind-mounts-elevate-write-count-for-ioctls.patch
r-o-bind-mounts-elevate-write-count-for-opens.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch
r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch
r-o-bind-mounts-write-counts-for-truncate.patch
r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch
r-o-bind-mounts-make-access-use-new-r-o-helper.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch
r-o-bind-mounts-track-numbers-of-writers-to-mounts.patch
r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch
r-o-bind-mounts-debugging-for-missed-calls.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
