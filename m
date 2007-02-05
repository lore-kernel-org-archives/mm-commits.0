From: akpm@linux-foundation.org
Subject: + fix-d_path-for-lazy-unmounts.patch added to -mm tree
Date: Mon, 05 Feb 2007 13:05:17 -0800
Message-ID: <200702052105.l15L5HgG031145@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933436AbXBEVF1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 16:05:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agruen@suse.de, hch@lst.de, neilb@suse.de, viro@zeniv.linux.org.uk


The patch titled
     Fix d_path for lazy unmounts
has been added to the -mm tree.  Its filename is
     fix-d_path-for-lazy-unmounts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix d_path for lazy unmounts
From: Andreas Gruenbacher <agruen@suse.de>

Here is a bugfix to d_path.

First, when d_path() hits a lazily unmounted mount point, it tries to
prepend the name of the lazily unmounted dentry to the path name.  It gets
this wrong, and also overwrites the slash that separates the name from the
following pathname component.  This is demonstrated by the attached test
case, which prints "getcwd returned d_path-bugsubdir" with the bug.  The
correct result would be "getcwd returned d_path-bug/subdir".

It could be argued that the name of the root dentry should not be part of
the result of d_path in the first place.  On the other hand, what the
unconnected namespace was once reachable as may provide some useful hints
to users, and so that seems okay.

Second, it isn't always possible to tell from the __d_path result whether
the specified root and rootmnt (i.e., the chroot) was reached: lazy
unmounts of bind mounts will produce a path that does start with a
non-slash so we can tell from that, but other lazy unmounts will produce a
path that starts with a slash, just like "ordinary" paths.

The attached patch cleans up __d_path() to fix the bug with overlapping
pathname components.  It also adds a @fail_deleted argument, which allows
to get rid of some of the mess in sys_getcwd().  Grabbing the dcache_lock
can then also be moved into __d_path().  The patch also makes sure that
paths will only start with a slash for paths which are connected to the
root and rootmnt.

The @fail_deleted argument could be added to d_path() as well: this would
allow callers to recognize deleted files, without having to resort to the
ambiguous check for the " (deleted)" string at the end of the pathnames. 
This is not currently done, but it might be worthwhile.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Cc: Neil Brown <neilb@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/dcache.c |  154 ++++++++++++++++++++++++++------------------------
 1 files changed, 82 insertions(+), 72 deletions(-)

diff -puN fs/dcache.c~fix-d_path-for-lazy-unmounts fs/dcache.c
--- a/fs/dcache.c~fix-d_path-for-lazy-unmounts
+++ a/fs/dcache.c
@@ -1739,45 +1739,41 @@ shouldnt_be_hashed:
  * @rootmnt: vfsmnt to which the root dentry belongs
  * @buffer: buffer to return value in
  * @buflen: buffer length
+ * @fail_deleted: what to return for deleted files
  *
- * Convert a dentry into an ASCII path name. If the entry has been deleted
- * the string " (deleted)" is appended. Note that this is ambiguous.
+ * Convert a dentry into an ASCII path name. If the entry has been deleted,
+ * then if @fail_deleted is true, ERR_PTR(-ENOENT) is returned. Otherwise,
+ * the the string " (deleted)" is appended. Note that this is ambiguous.
  *
- * Returns the buffer or an error code if the path was too long.
- *
- * "buflen" should be positive. Caller holds the dcache_lock.
+ * Returns the buffer or an error code.
  */
-static char * __d_path( struct dentry *dentry, struct vfsmount *vfsmnt,
-			struct dentry *root, struct vfsmount *rootmnt,
-			char *buffer, int buflen)
-{
-	char * end = buffer+buflen;
-	char * retval;
-	int namelen;
+static char *__d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
+		      struct dentry *root, struct vfsmount *rootmnt,
+		      char *buffer, int buflen, int fail_deleted)
+{
+	int namelen, is_slash;
+
+	if (buflen < 2)
+		return ERR_PTR(-ENAMETOOLONG);
+	buffer += --buflen;
+	*buffer = '\0';
 
-	*--end = '\0';
-	buflen--;
+	spin_lock(&dcache_lock);
 	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
-		buflen -= 10;
-		end -= 10;
-		if (buflen < 0)
+		if (fail_deleted) {
+			buffer = ERR_PTR(-ENOENT);
+			goto out;
+		}
+		if (buflen < 10)
 			goto Elong;
-		memcpy(end, " (deleted)", 10);
+		buflen -= 10;
+		buffer -= 10;
+		memcpy(buffer, " (deleted)", 10);
 	}
-
-	if (buflen < 1)
-		goto Elong;
-	/* Get '/' right */
-	retval = end-1;
-	*retval = '/';
-
-	for (;;) {
+	while (dentry != root || vfsmnt != rootmnt) {
 		struct dentry * parent;
 
-		if (dentry == root && vfsmnt == rootmnt)
-			break;
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
-			/* Global root? */
 			spin_lock(&vfsmount_lock);
 			if (vfsmnt->mnt_parent == vfsmnt) {
 				spin_unlock(&vfsmount_lock);
@@ -1791,33 +1787,60 @@ static char * __d_path( struct dentry *d
 		parent = dentry->d_parent;
 		prefetch(parent);
 		namelen = dentry->d_name.len;
-		buflen -= namelen + 1;
-		if (buflen < 0)
+		if (buflen <= namelen)
 			goto Elong;
-		end -= namelen;
-		memcpy(end, dentry->d_name.name, namelen);
-		*--end = '/';
-		retval = end;
+		buflen -= namelen + 1;
+		buffer -= namelen;
+		memcpy(buffer, dentry->d_name.name, namelen);
+		*--buffer = '/';
 		dentry = parent;
 	}
+	/* Get '/' right */
+	if (*buffer != '/')
+		*--buffer = '/';
 
-	return retval;
+out:
+	spin_unlock(&dcache_lock);
+	return buffer;
 
 global_root:
+	/*
+	 * We went past the (vfsmount, dentry) we were looking for and have
+	 * either hit a root dentry, a lazily unmounted dentry, an
+	 * unconnected dentry, or the file is on a pseudo filesystem.
+	 */
 	namelen = dentry->d_name.len;
-	buflen -= namelen;
-	if (buflen < 0)
+	is_slash = (namelen == 1 && *dentry->d_name.name == '/');
+	if (is_slash || (dentry->d_sb->s_flags & MS_NOUSER)) {
+		/*
+		 * Make sure we won't return a pathname starting with '/'.
+		 *
+		 * Historically, we also glue together the root dentry and
+		 * remaining name for pseudo filesystems like pipefs, which
+		 * have the MS_NOUSER flag set. This results in pathnames
+		 * like "pipe:[439336]".
+		 */
+		if (*buffer == '/') {
+			buffer++;
+			buflen++;
+		}
+		if (is_slash)
+			goto out;
+	}
+	if (buflen < namelen)
 		goto Elong;
-	retval -= namelen-1;	/* hit the slash */
-	memcpy(retval, dentry->d_name.name, namelen);
-	return retval;
+	buffer -= namelen;
+	memcpy(buffer, dentry->d_name.name, namelen);
+	goto out;
+
 Elong:
-	return ERR_PTR(-ENAMETOOLONG);
+	buffer = ERR_PTR(-ENAMETOOLONG);
+	goto out;
 }
 
 /* write full pathname into buffer and return start of pathname */
-char * d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
-				char *buf, int buflen)
+char *d_path(struct dentry *dentry, struct vfsmount *vfsmnt, char *buf,
+	     int buflen)
 {
 	char *res;
 	struct vfsmount *rootmnt;
@@ -1827,9 +1850,7 @@ char * d_path(struct dentry *dentry, str
 	rootmnt = mntget(current->fs->rootmnt);
 	root = dget(current->fs->root);
 	read_unlock(&current->fs->lock);
-	spin_lock(&dcache_lock);
-	res = __d_path(dentry, vfsmnt, root, rootmnt, buf, buflen);
-	spin_unlock(&dcache_lock);
+	res = __d_path(dentry, vfsmnt, root, rootmnt, buf, buflen, 0);
 	dput(root);
 	mntput(rootmnt);
 	return res;
@@ -1855,10 +1876,10 @@ char * d_path(struct dentry *dentry, str
  */
 asmlinkage long sys_getcwd(char __user *buf, unsigned long size)
 {
-	int error;
+	int error, len;
 	struct vfsmount *pwdmnt, *rootmnt;
 	struct dentry *pwd, *root;
-	char *page = (char *) __get_free_page(GFP_USER);
+	char *page = (char *) __get_free_page(GFP_USER), *cwd;
 
 	if (!page)
 		return -ENOMEM;
@@ -1870,29 +1891,18 @@ asmlinkage long sys_getcwd(char __user *
 	root = dget(current->fs->root);
 	read_unlock(&current->fs->lock);
 
-	error = -ENOENT;
-	/* Has the current directory has been unlinked? */
-	spin_lock(&dcache_lock);
-	if (pwd->d_parent == pwd || !d_unhashed(pwd)) {
-		unsigned long len;
-		char * cwd;
-
-		cwd = __d_path(pwd, pwdmnt, root, rootmnt, page, PAGE_SIZE);
-		spin_unlock(&dcache_lock);
-
-		error = PTR_ERR(cwd);
-		if (IS_ERR(cwd))
-			goto out;
-
-		error = -ERANGE;
-		len = PAGE_SIZE + page - cwd;
-		if (len <= size) {
-			error = len;
-			if (copy_to_user(buf, cwd, len))
-				error = -EFAULT;
-		}
-	} else
-		spin_unlock(&dcache_lock);
+	cwd = __d_path(pwd, pwdmnt, root, rootmnt, page, PAGE_SIZE, 1);
+	error = PTR_ERR(cwd);
+	if (IS_ERR(cwd))
+		goto out;
+
+	error = -ERANGE;
+	len = PAGE_SIZE + page - cwd;
+	if (len <= size) {
+		error = len;
+		if (copy_to_user(buf, cwd, len))
+			error = -EFAULT;
+	}
 
 out:
 	dput(pwd);
_

Patches currently in -mm which might be from agruen@suse.de are

fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls.patch
fix-d_path-for-lazy-unmounts.patch
