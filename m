From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:12:54 -0800
Message-ID: <200702130512.l1D5CsIq022284@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54617 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161020AbXBMFNE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:13:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk


The patch titled
     r/o bind mounts: elevate mnt writers for callers of vfs_mkdir()
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: elevate mnt writers for callers of vfs_mkdir()
From: Dave Hansen <hansendc@us.ibm.com>

elevate mnt writers for callers of vfs_mkdir()

Pretty self-explanatory.  Fits in with the rest of the series.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |    5 +++++
 fs/nfsd/nfs4recover.c |    4 ++++
 2 files changed, 9 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir
+++ a/fs/namei.c
@@ -1959,7 +1959,12 @@ asmlinkage long sys_mkdirat(int dfd, con
 
 	if (!IS_POSIXACL(nd.dentry->d_inode))
 		mode &= ~current->fs->umask;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_dput;
 	error = vfs_mkdir(nd.dentry->d_inode, dentry, mode);
+	mnt_drop_write(nd.mnt);
+out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
diff -puN fs/nfsd/nfs4recover.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir fs/nfsd/nfs4recover.c
--- a/fs/nfsd/nfs4recover.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir
+++ a/fs/nfsd/nfs4recover.c
@@ -156,7 +156,11 @@ nfsd4_create_clid_dir(struct nfs4_client
 		dprintk("NFSD: nfsd4_create_clid_dir: DIRECTORY EXISTS\n");
 		goto out_put;
 	}
+	status = mnt_want_write(rec_dir.mnt);
+	if (status)
+		goto out_put;
 	status = vfs_mkdir(rec_dir.dentry->d_inode, dentry, S_IRWXU);
+	mnt_drop_write(rec_dir.mnt);
 out_put:
 	dput(dentry);
 out_unlock:
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-add-vfsmount-writer-counts.patch
r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-mount_is_safe-add-comment.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-write-count-files-are-opened.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-gfs-check-nlink-count.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch
