From: akpm@linux-foundation.org
Subject: + remove-path_release_on_umount.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:01:20 -0800
Message-ID: <200711052101.lA5L1K5P019525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49521 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbXKEVBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:01:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     Remove path_release_on_umount()
has been added to the -mm tree.  Its filename is
     remove-path_release_on_umount.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove path_release_on_umount()
From: Jan Blunck <jblunck@suse.de>

path_release_on_umount() should only be called from sys_umount(). I merged the
function into sys_umount() instead of having in in namei.c.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |   10 ----------
 fs/namespace.c        |    4 +++-
 include/linux/namei.h |    1 -
 3 files changed, 3 insertions(+), 12 deletions(-)

diff -puN fs/namei.c~remove-path_release_on_umount fs/namei.c
--- a/fs/namei.c~remove-path_release_on_umount
+++ a/fs/namei.c
@@ -368,16 +368,6 @@ void path_release(struct nameidata *nd)
 	mntput(nd->mnt);
 }
 
-/*
- * umount() mustn't call path_release()/mntput() as that would clear
- * mnt_expiry_mark
- */
-void path_release_on_umount(struct nameidata *nd)
-{
-	dput(nd->dentry);
-	mntput_no_expire(nd->mnt);
-}
-
 /**
  * release_open_intent - free up open intent resources
  * @nd: pointer to nameidata
diff -puN fs/namespace.c~remove-path_release_on_umount fs/namespace.c
--- a/fs/namespace.c~remove-path_release_on_umount
+++ a/fs/namespace.c
@@ -991,7 +991,9 @@ asmlinkage long sys_umount(char __user *
 
 	retval = do_umount(nd.mnt, flags);
 dput_and_out:
-	path_release_on_umount(&nd);
+	/* we mustn't call path_put() as that would clear mnt_expiry_mark */
+	dput(nd.dentry);
+	mntput_no_expire(nd.mnt);
 out:
 	return retval;
 }
diff -puN include/linux/namei.h~remove-path_release_on_umount include/linux/namei.h
--- a/include/linux/namei.h~remove-path_release_on_umount
+++ a/include/linux/namei.h
@@ -73,7 +73,6 @@ extern int FASTCALL(path_lookup(const ch
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
 extern void path_release(struct nameidata *);
-extern void path_release_on_umount(struct nameidata *);
 
 extern int __user_path_lookup_open(const char __user *, unsigned lookup_flags, struct nameidata *nd, int open_flags);
 extern int path_lookup_open(int dfd, const char *name, unsigned lookup_flags, struct nameidata *, int open_flags);
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
