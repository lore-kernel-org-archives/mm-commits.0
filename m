From: akpm@linux-foundation.org
Subject: + reiserfs-fix-xattr-root-locking-refcount-bug.patch added to -mm tree
Date: Sat, 21 Apr 2007 12:38:19 -0700
Message-ID: <200704211938.l3LJcJ7S012486@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975AbXDUTkA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 15:40:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, a.righi@cineca.it, edward@namesys.com, stable@kernel.org, vs@namesys.com, zam@namesys.com


The patch titled
     reiserfs: fix xattr root locking/refcount bug
has been added to the -mm tree.  Its filename is
     reiserfs-fix-xattr-root-locking-refcount-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: fix xattr root locking/refcount bug
From: Jeff Mahoney <jeffm@suse.com>

The listxattr() and getxattr() operations are only protected by a read
lock.  As a result, if either of these operations run in parallel, a race
condition exists where the xattr_root will end up being cached twice, which
results in the leaking of a reference and a BUG() on umount.

This patch refactors get_xa_root(), __get_xa_root(), and create_xa_root(),
into one get_xa_root() function that takes the appropriate locking around
the entire critical section.

Reported, diagnosed and tested by Andrea Righi <a.righi@cineca.it>

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Andrea Righi <a.righi@cineca.it>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: Edward Shishkin <edward@namesys.com>
Cc: Alex Zarochentsev <zam@namesys.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr.c |   92 ++++++++++--------------------------------
 1 file changed, 24 insertions(+), 68 deletions(-)

diff -puN fs/reiserfs/xattr.c~reiserfs-fix-xattr-root-locking-refcount-bug fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~reiserfs-fix-xattr-root-locking-refcount-bug
+++ a/fs/reiserfs/xattr.c
@@ -54,82 +54,48 @@
 static struct reiserfs_xattr_handler *find_xattr_handler_prefix(const char
 								*prefix);
 
-static struct dentry *create_xa_root(struct super_block *sb)
+/* Returns the dentry referring to the root of the extended attribute
+ * directory tree. If it has already been retrieved, it is used. If it
+ * hasn't been created and the flags indicate creation is allowed, we
+ * attempt to create it. On error, we return a pointer-encoded error.
+ */
+static struct dentry *get_xa_root(struct super_block *sb, int flags)
 {
 	struct dentry *privroot = dget(REISERFS_SB(sb)->priv_root);
 	struct dentry *xaroot;
 
 	/* This needs to be created at mount-time */
 	if (!privroot)
-		return ERR_PTR(-EOPNOTSUPP);
+		return ERR_PTR(-ENODATA);
 
-	xaroot = lookup_one_len(XAROOT_NAME, privroot, strlen(XAROOT_NAME));
-	if (IS_ERR(xaroot)) {
+	mutex_lock(&privroot->d_inode->i_mutex);
+	if (REISERFS_SB(sb)->xattr_root) {
+		xaroot = dget(REISERFS_SB(sb)->xattr_root);
 		goto out;
-	} else if (!xaroot->d_inode) {
-		int err;
-		mutex_lock(&privroot->d_inode->i_mutex);
-		err =
-		    privroot->d_inode->i_op->mkdir(privroot->d_inode, xaroot,
-						   0700);
-		mutex_unlock(&privroot->d_inode->i_mutex);
-
-		if (err) {
-			dput(xaroot);
-			dput(privroot);
-			return ERR_PTR(err);
-		}
-		REISERFS_SB(sb)->xattr_root = dget(xaroot);
 	}
 
-      out:
-	dput(privroot);
-	return xaroot;
-}
-
-/* This will return a dentry, or error, refering to the xa root directory.
- * If the xa root doesn't exist yet, the dentry will be returned without
- * an associated inode. This dentry can be used with ->mkdir to create
- * the xa directory. */
-static struct dentry *__get_xa_root(struct super_block *s)
-{
-	struct dentry *privroot = dget(REISERFS_SB(s)->priv_root);
-	struct dentry *xaroot = NULL;
-
-	if (IS_ERR(privroot) || !privroot)
-		return privroot;
-
 	xaroot = lookup_one_len(XAROOT_NAME, privroot, strlen(XAROOT_NAME));
 	if (IS_ERR(xaroot)) {
 		goto out;
 	} else if (!xaroot->d_inode) {
-		dput(xaroot);
-		xaroot = NULL;
-		goto out;
+		int err = -ENODATA;
+		if (flags == 0 || flags & XATTR_CREATE)
+			err = privroot->d_inode->i_op->mkdir(privroot->d_inode,
+			                                     xaroot, 0700);
+		if (err) {
+			dput(xaroot);
+			xaroot = ERR_PTR(err);
+			goto out;
+		}
 	}
-
-	REISERFS_SB(s)->xattr_root = dget(xaroot);
+	REISERFS_SB(sb)->xattr_root = dget(xaroot);
 
       out:
+	mutex_unlock(&privroot->d_inode->i_mutex);
 	dput(privroot);
 	return xaroot;
 }
 
-/* Returns the dentry (or NULL) referring to the root of the extended
- * attribute directory tree. If it has already been retrieved, it is used.
- * Otherwise, we attempt to retrieve it from disk. It may also return
- * a pointer-encoded error.
- */
-static inline struct dentry *get_xa_root(struct super_block *s)
-{
-	struct dentry *dentry = dget(REISERFS_SB(s)->xattr_root);
-
-	if (!dentry)
-		dentry = __get_xa_root(s);
-
-	return dentry;
-}
-
 /* Opens the directory corresponding to the inode's extended attribute store.
  * If flags allow, the tree to the directory may be created. If creation is
  * prohibited, -ENODATA is returned. */
@@ -138,21 +104,11 @@ static struct dentry *open_xa_dir(const 
 	struct dentry *xaroot, *xadir;
 	char namebuf[17];
 
-	xaroot = get_xa_root(inode->i_sb);
-	if (IS_ERR(xaroot)) {
+	xaroot = get_xa_root(inode->i_sb, flags);
+	if (IS_ERR(xaroot))
 		return xaroot;
-	} else if (!xaroot) {
-		if (flags == 0 || flags & XATTR_CREATE) {
-			xaroot = create_xa_root(inode->i_sb);
-			if (IS_ERR(xaroot))
-				return xaroot;
-		}
-		if (!xaroot)
-			return ERR_PTR(-ENODATA);
-	}
 
 	/* ok, we have xaroot open */
-
 	snprintf(namebuf, sizeof(namebuf), "%X.%X",
 		 le32_to_cpu(INODE_PKEY(inode)->k_objectid),
 		 inode->i_generation);
@@ -821,7 +777,7 @@ int reiserfs_delete_xattrs(struct inode 
 
 	/* Leftovers besides . and .. -- that's not good. */
 	if (dir->d_inode->i_nlink <= 2) {
-		root = get_xa_root(inode->i_sb);
+		root = get_xa_root(inode->i_sb, XATTR_REPLACE);
 		reiserfs_write_lock_xattrs(inode->i_sb);
 		err = vfs_rmdir(root->d_inode, dir);
 		reiserfs_write_unlock_xattrs(inode->i_sb);
_

Patches currently in -mm which might be from jeffm@suse.com are

reiserfs-fix-xattr-root-locking-refcount-bug.patch
