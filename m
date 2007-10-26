From: akpm@linux-foundation.org
Subject: - remove-path_release_on_umount.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:58:20 -0700
Message-ID: <200710261858.l9QIwKpi009524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45697 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbXJZS66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, bharata@linux.vnet.ibm.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Remove path_release_on_umount()
has been removed from the -mm tree.  Its filename was
     remove-path_release_on_umount.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Remove path_release_on_umount()
From: Jan Blunck <jblunck@suse.de>

path_release_on_umount() should only be called from sys_umount().  I merged
the function into sys_umount() instead of having in in namei.c.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: Christoph Hellwig <hch@lst.de>
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
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
introduce-path_get-unionfs.patch
