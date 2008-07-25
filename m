From: akpm@linux-foundation.org
Subject: - fuse-nfs-export-special-lookups.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:42 -0700
Message-ID: <200807252303.m6PN3g4Q003974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754104AbYGYXFM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:05:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, bfields@fieldses.org, hch@lst.de, matthew@wil.cx, teigland@redhat.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     fuse: nfs export special lookups
has been removed from the -mm tree.  Its filename was
     fuse-nfs-export-special-lookups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: nfs export special lookups
From: Miklos Szeredi <mszeredi@suse.cz>

Implement the get_parent export operation by sending a LOOKUP request with
".." as the name.

Implement looking up an inode by node ID after it has been evicted from
the cache.  This is done by seding a LOOKUP request with "." as the name
(for all file types, not just directories).

The filesystem can set the FUSE_EXPORT_SUPPORT flag in the INIT reply, to
indicate that it supports these special lookups.

Thanks to John Muir for the original implementation of this feature.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: David Teigland <teigland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/fuse_i.h     |    6 +++
 fs/fuse/inode.c      |   66 +++++++++++++++++++++++++++++++++++++++--
 include/linux/fuse.h |    3 +
 3 files changed, 72 insertions(+), 3 deletions(-)

diff -puN fs/fuse/fuse_i.h~fuse-nfs-export-special-lookups fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-nfs-export-special-lookups
+++ a/fs/fuse/fuse_i.h
@@ -363,6 +363,9 @@ struct fuse_conn {
 	/** Do not send separate SETATTR request before open(O_TRUNC)  */
 	unsigned atomic_o_trunc : 1;
 
+	/** Filesystem supports NFS exporting.  Only set in INIT */
+	unsigned export_support : 1;
+
 	/*
 	 * The following bitfields are only for optimization purposes
 	 * and hence races in setting them will not cause malfunction
@@ -473,6 +476,9 @@ struct inode *fuse_iget(struct super_blo
 			int generation, struct fuse_attr *attr,
 			u64 attr_valid, u64 attr_version);
 
+int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
+		     struct fuse_entry_out *outarg, struct inode **inode);
+
 /**
  * Send FORGET command
  */
diff -puN fs/fuse/inode.c~fuse-nfs-export-special-lookups fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-nfs-export-special-lookups
+++ a/fs/fuse/inode.c
@@ -562,6 +562,7 @@ struct fuse_inode_handle
 static struct dentry *fuse_get_dentry(struct super_block *sb,
 				      struct fuse_inode_handle *handle)
 {
+	struct fuse_conn *fc = get_fuse_conn_super(sb);
 	struct inode *inode;
 	struct dentry *entry;
 	int err = -ESTALE;
@@ -570,8 +571,27 @@ static struct dentry *fuse_get_dentry(st
 		goto out_err;
 
 	inode = ilookup5(sb, handle->nodeid, fuse_inode_eq, &handle->nodeid);
-	if (!inode)
-		goto out_err;
+	if (!inode) {
+		struct fuse_entry_out outarg;
+		struct qstr name;
+
+		if (!fc->export_support)
+			goto out_err;
+
+		name.len = 1;
+		name.name = ".";
+		err = fuse_lookup_name(sb, handle->nodeid, &name, &outarg,
+				       &inode);
+		if (err && err != -ENOENT)
+			goto out_err;
+		if (err || !inode) {
+			err = -ESTALE;
+			goto out_err;
+		}
+		err = -EIO;
+		if (get_node_id(inode) != handle->nodeid)
+			goto out_iput;
+	}
 	err = -ESTALE;
 	if (inode->i_generation != handle->generation)
 		goto out_iput;
@@ -659,11 +679,46 @@ static struct dentry *fuse_fh_to_parent(
 	return fuse_get_dentry(sb, &parent);
 }
 
+static struct dentry *fuse_get_parent(struct dentry *child)
+{
+	struct inode *child_inode = child->d_inode;
+	struct fuse_conn *fc = get_fuse_conn(child_inode);
+	struct inode *inode;
+	struct dentry *parent;
+	struct fuse_entry_out outarg;
+	struct qstr name;
+	int err;
+
+	if (!fc->export_support)
+		return ERR_PTR(-ESTALE);
+
+	name.len = 2;
+	name.name = "..";
+	err = fuse_lookup_name(child_inode->i_sb, get_node_id(child_inode),
+			       &name, &outarg, &inode);
+	if (err && err != -ENOENT)
+		return ERR_PTR(err);
+	if (err || !inode)
+		return ERR_PTR(-ESTALE);
+
+	parent = d_alloc_anon(inode);
+	if (!parent) {
+		iput(inode);
+		return ERR_PTR(-ENOMEM);
+	}
+	if (get_node_id(inode) != FUSE_ROOT_ID) {
+		parent->d_op = &fuse_dentry_operations;
+		fuse_invalidate_entry_cache(parent);
+	}
+
+	return parent;
+}
 
 static const struct export_operations fuse_export_operations = {
 	.fh_to_dentry	= fuse_fh_to_dentry,
 	.fh_to_parent	= fuse_fh_to_parent,
 	.encode_fh	= fuse_encode_fh,
+	.get_parent	= fuse_get_parent,
 };
 
 static const struct super_operations fuse_super_operations = {
@@ -695,6 +750,11 @@ static void process_init_reply(struct fu
 				fc->no_lock = 1;
 			if (arg->flags & FUSE_ATOMIC_O_TRUNC)
 				fc->atomic_o_trunc = 1;
+			if (arg->minor >= 9) {
+				/* LOOKUP has dependency on proto version */
+				if (arg->flags & FUSE_EXPORT_SUPPORT)
+					fc->export_support = 1;
+			}
 			if (arg->flags & FUSE_BIG_WRITES)
 				fc->big_writes = 1;
 		} else {
@@ -721,7 +781,7 @@ static void fuse_send_init(struct fuse_c
 	arg->minor = FUSE_KERNEL_MINOR_VERSION;
 	arg->max_readahead = fc->bdi.ra_pages * PAGE_CACHE_SIZE;
 	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_ATOMIC_O_TRUNC |
-		FUSE_BIG_WRITES;
+		FUSE_EXPORT_SUPPORT | FUSE_BIG_WRITES;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
diff -puN include/linux/fuse.h~fuse-nfs-export-special-lookups include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-nfs-export-special-lookups
+++ a/include/linux/fuse.h
@@ -104,11 +104,14 @@ struct fuse_file_lock {
 
 /**
  * INIT request/reply flags
+ *
+ * FUSE_EXPORT_SUPPORT: filesystem handles lookups of "." and ".."
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
 #define FUSE_FILE_OPS		(1 << 2)
 #define FUSE_ATOMIC_O_TRUNC	(1 << 3)
+#define FUSE_EXPORT_SUPPORT	(1 << 4)
 #define FUSE_BIG_WRITES		(1 << 5)
 
 /**
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
linux-next.patch
git-unprivileged-mounts.patch

