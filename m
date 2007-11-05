From: akpm@linux-foundation.org
Subject: + one-less-parameter-to-__d_path.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:03:32 -0800
Message-ID: <200711052103.lA5L3WQN019616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37727 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbXKEVDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:03:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, agruen@suse.de, bfields@fieldses.org, hch@infradead.org, neilb@suse.de, viro@zeniv.linux.org.uk


The patch titled
     One less parameter to __d_path
has been added to the -mm tree.  Its filename is
     one-less-parameter-to-__d_path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: One less parameter to __d_path
From: Jan Blunck <jblunck@suse.de>

All callers to __d_path pass the dentry and vfsmount of a struct path to
__d_path.  Pass the struct path directly, instead.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN fs/dcache.c~one-less-parameter-to-__d_path fs/dcache.c
--- a/fs/dcache.c~one-less-parameter-to-__d_path
+++ a/fs/dcache.c
@@ -1779,9 +1779,8 @@ shouldnt_be_hashed:
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
  */
-static char * __d_path( struct dentry *dentry, struct vfsmount *vfsmnt,
-			struct dentry *root, struct vfsmount *rootmnt,
-			char *buffer, int buflen)
+static char * __d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
+		       struct path *root, char *buffer, int buflen)
 {
 	char * end = buffer+buflen;
 	char * retval;
@@ -1806,7 +1805,7 @@ static char * __d_path( struct dentry *d
 	for (;;) {
 		struct dentry * parent;
 
-		if (dentry == root && vfsmnt == rootmnt)
+		if (dentry == root->dentry && vfsmnt == root->mnt)
 			break;
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			/* Global root? */
@@ -1869,7 +1868,7 @@ char * d_path(struct dentry *dentry, str
 	path_get(&current->fs->root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
-	res = __d_path(dentry, vfsmnt, root.dentry, root.mnt, buf, buflen);
+	res = __d_path(dentry, vfsmnt, &root, buf, buflen);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
@@ -1937,8 +1936,7 @@ asmlinkage long sys_getcwd(char __user *
 		unsigned long len;
 		char * cwd;
 
-		cwd = __d_path(pwd.dentry, pwd.mnt, root.dentry, root.mnt,
-			       page, PAGE_SIZE);
+		cwd = __d_path(pwd.dentry, pwd.mnt, &root, page, PAGE_SIZE);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
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
