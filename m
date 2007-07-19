From: akpm@linux-foundation.org
Subject: - fs-introduce-vfs_path_lookup.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:51 -0700
Message-ID: <200707192001.l6JK1p0r019599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45333 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760315AbXGSUdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, hch@lst.de, mhalcrow@us.ibm.com, neilb@suse.de, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: introduce vfs_path_lookup
has been removed from the -mm tree.  Its filename was
     fs-introduce-vfs_path_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: introduce vfs_path_lookup
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>

Stackable file systems, among others, frequently need to lookup paths or
path components starting from an arbitrary point in the namespace
(identified by a dentry and a vfsmount).  Currently, such file systems use
lookup_one_len, which is frowned upon [1] as it does not pass the lookup
intent along; not passing a lookup intent, for example, can trigger BUG_ON's
when stacking on top of NFSv4.

The first patch introduces a new lookup function to allow lookup starting
from an arbitrary point in the namespace.  This approach has been suggested
by Christoph Hellwig [2].

The second patch changes sunrpc to use vfs_path_lookup.

The third patch changes nfsctl.c to use vfs_path_lookup.

The fourth patch marks link_path_walk static.

The fifth, and last patch, unexports path_walk because it is no longer
unnecessary to call it directly, and using the new vfs_path_lookup is
cleaner.

For example, the following snippet of code, looks up "some/path/component"
in a directory pointed to by parent_{dentry,vfsmnt}:

err = vfs_path_lookup(parent_dentry, parent_vfsmnt,
		      "some/path/component", 0, &nd);
if (!err) {
	/* exits */

	...

	/* once done, release the references */
	path_release(&nd);
} else if (err == -ENOENT) {
	/* doesn't exist */
} else {
	/* other error */
}

VFS functions such as lookup_create can be used on the nameidata structure
to pass the create intent to the file system.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |   32 ++++++++++++++++++++++++++++++++
 include/linux/namei.h |    2 ++
 2 files changed, 34 insertions(+)

diff -puN fs/namei.c~fs-introduce-vfs_path_lookup fs/namei.c
--- a/fs/namei.c~fs-introduce-vfs_path_lookup
+++ a/fs/namei.c
@@ -1172,6 +1172,37 @@ int fastcall path_lookup(const char *nam
 	return do_path_lookup(AT_FDCWD, name, flags, nd);
 }
 
+/**
+ * vfs_path_lookup - lookup a file path relative to a dentry-vfsmount pair
+ * @dentry:  pointer to dentry of the base directory
+ * @mnt: pointer to vfs mount of the base directory
+ * @name: pointer to file name
+ * @flags: lookup flags
+ * @nd: pointer to nameidata
+ */
+int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
+		    const char *name, unsigned int flags,
+		    struct nameidata *nd)
+{
+	int retval;
+
+	/* same as do_path_lookup */
+	nd->last_type = LAST_ROOT;
+	nd->flags = flags;
+	nd->depth = 0;
+
+	nd->mnt = mntget(mnt);
+	nd->dentry = dget(dentry);
+
+	retval = path_walk(name, nd);
+	if (unlikely(!retval && !audit_dummy_context() && nd->dentry &&
+				nd->dentry->d_inode))
+		audit_inode(name, nd->dentry->d_inode);
+
+	return retval;
+
+}
+
 static int __path_lookup_intent_open(int dfd, const char *name,
 		unsigned int lookup_flags, struct nameidata *nd,
 		int open_flags, int create_mode)
@@ -2774,6 +2805,7 @@ EXPORT_SYMBOL(__page_symlink);
 EXPORT_SYMBOL(page_symlink);
 EXPORT_SYMBOL(page_symlink_inode_operations);
 EXPORT_SYMBOL(path_lookup);
+EXPORT_SYMBOL(vfs_path_lookup);
 EXPORT_SYMBOL(path_release);
 EXPORT_SYMBOL(path_walk);
 EXPORT_SYMBOL(permission);
diff -puN include/linux/namei.h~fs-introduce-vfs_path_lookup include/linux/namei.h
--- a/include/linux/namei.h~fs-introduce-vfs_path_lookup
+++ a/include/linux/namei.h
@@ -69,6 +69,8 @@ extern int FASTCALL(__user_walk_fd(int d
 #define user_path_walk_link(name,nd) \
 	__user_walk_fd(AT_FDCWD, name, 0, nd)
 extern int FASTCALL(path_lookup(const char *, unsigned, struct nameidata *));
+extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
+			   const char *, unsigned int, struct nameidata *);
 extern int FASTCALL(path_walk(const char *, struct nameidata *));
 extern int FASTCALL(link_path_walk(const char *, struct nameidata *));
 extern void path_release(struct nameidata *);
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

origin.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
