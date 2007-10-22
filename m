From: akpm@linux-foundation.org
Subject: + make-__d_path-to-take-a-struct-path-argument.patch added to -mm tree
Date: Mon, 22 Oct 2007 15:51:07 -0700
Message-ID: <200710222251.l9MMp7eb019957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbXJVWvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 18:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agruen@suse.de, bharata@linux.vnet.ibm.com, hch@lst.de


The patch titled
     Make __d_path() to take a struct path argument
has been added to the -mm tree.  Its filename is
     make-__d_path-to-take-a-struct-path-argument.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make __d_path() to take a struct path argument
From: Andreas Gruenbacher <agruen@suse.de>

One less argument to __d_path.

All callers to __d_path pass the dentry and vfsmount of a struct path to
__d_path.  Pass the struct path directly, instead.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN fs/dcache.c~make-__d_path-to-take-a-struct-path-argument fs/dcache.c
--- a/fs/dcache.c~make-__d_path-to-take-a-struct-path-argument
+++ a/fs/dcache.c
@@ -1766,8 +1766,7 @@ shouldnt_be_hashed:
  * "buflen" should be positive. Caller holds the dcache_lock.
  */
 static char * __d_path( struct dentry *dentry, struct vfsmount *vfsmnt,
-			struct dentry *root, struct vfsmount *rootmnt,
-			char *buffer, int buflen)
+			struct path *root, char *buffer, int buflen)
 {
 	char * end = buffer+buflen;
 	char * retval;
@@ -1792,7 +1791,7 @@ static char * __d_path( struct dentry *d
 	for (;;) {
 		struct dentry * parent;
 
-		if (dentry == root && vfsmnt == rootmnt)
+		if (dentry == root->dentry && vfsmnt == root->mnt)
 			break;
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			/* Global root? */
@@ -1855,7 +1854,7 @@ char * d_path(struct dentry *dentry, str
 	path_get(&current->fs->root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
-	res = __d_path(dentry, vfsmnt, root.dentry, root.mnt, buf, buflen);
+	res = __d_path(dentry, vfsmnt, &root, buf, buflen);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
@@ -1923,8 +1922,7 @@ asmlinkage long sys_getcwd(char __user *
 		unsigned long len;
 		char * cwd;
 
-		cwd = __d_path(pwd.dentry, pwd.mnt, root.dentry, root.mnt,
-			       page, PAGE_SIZE);
+		cwd = __d_path(pwd.dentry, pwd.mnt, &root, page, PAGE_SIZE);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
_

Patches currently in -mm which might be from agruen@suse.de are

origin.patch
dont-touch-fs_struct-in-usermodehelper.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
make-__d_path-to-take-a-struct-path-argument.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
introduce-path_get-unionfs.patch
