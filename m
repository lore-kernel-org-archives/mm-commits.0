From: akpm@linux-foundation.org
Subject: [merged] reiserfs-expand-i_mutex-to-enclose-lookup_one_len.patch removed from -mm tree
Date: Tue, 05 May 2009 11:48:35 -0700
Message-ID: <200905051848.n45ImZWJ015525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbZEESwR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 14:52:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, a.beregalov@gmail.com, david@unsolicited.net, viro@ftp.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     reiserfs: expand i_mutex to enclose lookup_one_len
has been removed from the -mm tree.  Its filename was
     reiserfs-expand-i_mutex-to-enclose-lookup_one_len.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: expand i_mutex to enclose lookup_one_len
From: Jeff Mahoney <jeffm@suse.com>

2.6.30-rc3 introduced some sanity checks in the VFS code to avoid NFS bugs
by ensuring that lookup_one_len is always called under i_mutex.

This patch expands the i_mutex locking to enclose lookup_one_len.  This
was always required, but not not enforced in the reiserfs code since it
does locking around the xattr interactions with the xattr_sem.

This is obvious enough, and it survived an overnight 50 thread ACL test.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Al Viro <viro@ftp.linux.org.uk>
Tested-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: David <david@unsolicited.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff -puN fs/reiserfs/xattr.c~reiserfs-expand-i_mutex-to-enclose-lookup_one_len fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~reiserfs-expand-i_mutex-to-enclose-lookup_one_len
+++ a/fs/reiserfs/xattr.c
@@ -120,25 +120,20 @@ static struct dentry *lookup_or_create_d
 	struct dentry *dentry;
 	BUG_ON(!parent);
 
+	mutex_lock_nested(&parent->d_inode->i_mutex, I_MUTEX_XATTR);
 	dentry = lookup_one_len(name, parent, strlen(name));
-	if (IS_ERR(dentry))
-		return dentry;
-	else if (!dentry->d_inode) {
+	if (!IS_ERR(dentry) && !dentry->d_inode) {
 		int err = -ENODATA;
 
-		if (xattr_may_create(flags)) {
-			mutex_lock_nested(&parent->d_inode->i_mutex,
-					  I_MUTEX_XATTR);
+		if (xattr_may_create(flags))
 			err = xattr_mkdir(parent->d_inode, dentry, 0700);
-			mutex_unlock(&parent->d_inode->i_mutex);
-		}
 
 		if (err) {
 			dput(dentry);
 			dentry = ERR_PTR(err);
 		}
 	}
-
+	mutex_unlock(&parent->d_inode->i_mutex);
 	return dentry;
 }
 
@@ -184,6 +179,7 @@ fill_with_dentries(void *buf, const char
 {
 	struct reiserfs_dentry_buf *dbuf = buf;
 	struct dentry *dentry;
+	WARN_ON_ONCE(!mutex_is_locked(&dbuf->xadir->d_inode->i_mutex));
 
 	if (dbuf->count == ARRAY_SIZE(dbuf->dentries))
 		return -ENOSPC;
@@ -349,6 +345,7 @@ static struct dentry *xattr_lookup(struc
 	if (IS_ERR(xadir))
 		return ERR_CAST(xadir);
 
+	mutex_lock_nested(&xadir->d_inode->i_mutex, I_MUTEX_XATTR);
 	xafile = lookup_one_len(name, xadir, strlen(name));
 	if (IS_ERR(xafile)) {
 		err = PTR_ERR(xafile);
@@ -360,18 +357,15 @@ static struct dentry *xattr_lookup(struc
 
 	if (!xafile->d_inode) {
 		err = -ENODATA;
-		if (xattr_may_create(flags)) {
-			mutex_lock_nested(&xadir->d_inode->i_mutex,
-					  I_MUTEX_XATTR);
+		if (xattr_may_create(flags))
 			err = xattr_create(xadir->d_inode, xafile,
 					      0700|S_IFREG);
-			mutex_unlock(&xadir->d_inode->i_mutex);
-		}
 	}
 
 	if (err)
 		dput(xafile);
 out:
+	mutex_unlock(&xadir->d_inode->i_mutex);
 	dput(xadir);
 	if (err)
 		return ERR_PTR(err);
@@ -435,6 +429,7 @@ static int lookup_and_delete_xattr(struc
 	if (IS_ERR(xadir))
 		return PTR_ERR(xadir);
 
+	mutex_lock_nested(&xadir->d_inode->i_mutex, I_MUTEX_XATTR);
 	dentry = lookup_one_len(name, xadir, strlen(name));
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
@@ -442,14 +437,13 @@ static int lookup_and_delete_xattr(struc
 	}
 
 	if (dentry->d_inode) {
-		mutex_lock_nested(&xadir->d_inode->i_mutex, I_MUTEX_XATTR);
 		err = xattr_unlink(xadir->d_inode, dentry);
-		mutex_unlock(&xadir->d_inode->i_mutex);
 		update_ctime(inode);
 	}
 
 	dput(dentry);
 out_dput:
+	mutex_unlock(&xadir->d_inode->i_mutex);
 	dput(xadir);
 	return err;
 }
@@ -906,9 +900,9 @@ static int create_privroot(struct dentry
 {
 	int err;
 	struct inode *inode = dentry->d_parent->d_inode;
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_XATTR);
+	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
+
 	err = xattr_mkdir(inode, dentry, 0700);
-	mutex_unlock(&inode->i_mutex);
 	if (err) {
 		dput(dentry);
 		dentry = NULL;
@@ -980,6 +974,7 @@ int reiserfs_xattr_init(struct super_blo
 	/* If we don't have the privroot located yet - go find it */
 	if (!REISERFS_SB(s)->priv_root) {
 		struct dentry *dentry;
+		mutex_lock_nested(&s->s_root->d_inode->i_mutex, I_MUTEX_CHILD);
 		dentry = lookup_one_len(PRIVROOT_NAME, s->s_root,
 					strlen(PRIVROOT_NAME));
 		if (!IS_ERR(dentry)) {
@@ -993,6 +988,7 @@ int reiserfs_xattr_init(struct super_blo
 			}
 		} else
 			err = PTR_ERR(dentry);
+		mutex_unlock(&s->s_root->d_inode->i_mutex);
 
 		if (!err && dentry) {
 			s->s_root->d_op = &xattr_lookup_poison_ops;
_

Patches currently in -mm which might be from jeffm@suse.com are

linux-next.patch

