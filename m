From: akpm@linux-foundation.org
Subject: [merged] hfsplus-fix-unused-node-is-not-erased-error.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:32:12 -0700
Message-ID: <53960bbc.3We4Crumwykvymlh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFITcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:32:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, slava@dubeyko.com, kalaracey@gmail.com, htl10@users.sourceforge.net, hch@infradead.org, aia21@cam.ac.uk, saproj@gmail.com

Subject: [merged] hfsplus-fix-unused-node-is-not-erased-error.patch removed from -mm tree
To: saproj@gmail.com,aia21@cam.ac.uk,hch@infradead.org,htl10@users.sourceforge.net,kalaracey@gmail.com,slava@dubeyko.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:32:12 -0700


The patch titled
     Subject: hfsplus: fix "unused node is not erased" error
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-unused-node-is-not-erased-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergei Antonov <saproj@gmail.com>
Subject: hfsplus: fix "unused node is not erased" error

Zero newly allocated extents in the catalog tree if volume attributes tell
us to.  Not doing so we risk getting the "unused node is not erased"
error.  See kHFSUnusedNodeFix flag in Apple's source code for reference.

There was a previous commit clearing the node when it is freed:
  commit 899bed05e9f6bbb21776f9ebd88f5631987f987a
  Author: Vyacheslav Dubeyko <slava@dubeyko.com>
  Date:   Wed Feb 27 17:03:06 2013 -0800
  hfsplus: fix issue with unzeroed unused b-tree nodes
It did not handle newly allocated extents (this patch fixes it). And it zeroed
nodes in all trees unconditionally which is an overkill. This patch adds a
condition and also switches to 'tree->node_size' as a simpler method of getting
the length to zero.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Kyle Laracey <kalaracey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bnode.c       |   17 +++++++++++++++--
 fs/hfsplus/btree.c       |    2 +-
 fs/hfsplus/extents.c     |   10 ++++++++--
 fs/hfsplus/hfsplus_fs.h  |    3 ++-
 fs/hfsplus/hfsplus_raw.h |    1 +
 fs/hfsplus/xattr.c       |    2 +-
 6 files changed, 28 insertions(+), 7 deletions(-)

diff -puN fs/hfsplus/bnode.c~hfsplus-fix-unused-node-is-not-erased-error fs/hfsplus/bnode.c
--- a/fs/hfsplus/bnode.c~hfsplus-fix-unused-node-is-not-erased-error
+++ a/fs/hfsplus/bnode.c
@@ -646,8 +646,8 @@ void hfs_bnode_put(struct hfs_bnode *nod
 		if (test_bit(HFS_BNODE_DELETED, &node->flags)) {
 			hfs_bnode_unhash(node);
 			spin_unlock(&tree->hash_lock);
-			hfs_bnode_clear(node, 0,
-				PAGE_CACHE_SIZE * tree->pages_per_bnode);
+			if (hfs_bnode_need_zeroout(tree))
+				hfs_bnode_clear(node, 0, tree->node_size);
 			hfs_bmap_free(node);
 			hfs_bnode_free(node);
 			return;
@@ -656,3 +656,16 @@ void hfs_bnode_put(struct hfs_bnode *nod
 	}
 }
 
+/*
+ * Unused nodes have to be zeroed if this is the catalog tree and
+ * a corresponding flag in the volume header is set.
+ */
+bool hfs_bnode_need_zeroout(struct hfs_btree *tree)
+{
+	struct super_block *sb = tree->inode->i_sb;
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
+	const u32 volume_attr = be32_to_cpu(sbi->s_vhdr->attributes);
+
+	return tree->cnid == HFSPLUS_CAT_CNID &&
+		volume_attr & HFSPLUS_VOL_UNUSED_NODE_FIX;
+}
diff -puN fs/hfsplus/btree.c~hfsplus-fix-unused-node-is-not-erased-error fs/hfsplus/btree.c
--- a/fs/hfsplus/btree.c~hfsplus-fix-unused-node-is-not-erased-error
+++ a/fs/hfsplus/btree.c
@@ -358,7 +358,7 @@ struct hfs_bnode *hfs_bmap_alloc(struct
 		u32 count;
 		int res;
 
-		res = hfsplus_file_extend(inode);
+		res = hfsplus_file_extend(inode, hfs_bnode_need_zeroout(tree));
 		if (res)
 			return ERR_PTR(res);
 		hip->phys_size = inode->i_size =
diff -puN fs/hfsplus/extents.c~hfsplus-fix-unused-node-is-not-erased-error fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-fix-unused-node-is-not-erased-error
+++ a/fs/hfsplus/extents.c
@@ -235,7 +235,7 @@ int hfsplus_get_block(struct inode *inod
 		if (iblock > hip->fs_blocks || !create)
 			return -EIO;
 		if (ablock >= hip->alloc_blocks) {
-			res = hfsplus_file_extend(inode);
+			res = hfsplus_file_extend(inode, false);
 			if (res)
 				return res;
 		}
@@ -425,7 +425,7 @@ int hfsplus_free_fork(struct super_block
 	return res;
 }
 
-int hfsplus_file_extend(struct inode *inode)
+int hfsplus_file_extend(struct inode *inode, bool zeroout)
 {
 	struct super_block *sb = inode->i_sb;
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
@@ -463,6 +463,12 @@ int hfsplus_file_extend(struct inode *in
 		}
 	}
 
+	if (zeroout) {
+		res = sb_issue_zeroout(sb, start, len, GFP_NOFS);
+		if (res)
+			goto out;
+	}
+
 	hfs_dbg(EXTENT, "extend %lu: %u,%u\n", inode->i_ino, start, len);
 
 	if (hip->alloc_blocks <= hip->first_blocks) {
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-fix-unused-node-is-not-erased-error fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-fix-unused-node-is-not-erased-error
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -414,6 +414,7 @@ void hfs_bnode_free(struct hfs_bnode *);
 struct hfs_bnode *hfs_bnode_create(struct hfs_btree *, u32);
 void hfs_bnode_get(struct hfs_bnode *);
 void hfs_bnode_put(struct hfs_bnode *);
+bool hfs_bnode_need_zeroout(struct hfs_btree *);
 
 /* brec.c */
 u16 hfs_brec_lenoff(struct hfs_bnode *, u16, u16 *);
@@ -460,7 +461,7 @@ int hfsplus_ext_write_extent(struct inod
 int hfsplus_get_block(struct inode *, sector_t, struct buffer_head *, int);
 int hfsplus_free_fork(struct super_block *, u32,
 		struct hfsplus_fork_raw *, int);
-int hfsplus_file_extend(struct inode *);
+int hfsplus_file_extend(struct inode *, bool zeroout);
 void hfsplus_file_truncate(struct inode *);
 
 /* inode.c */
diff -puN fs/hfsplus/hfsplus_raw.h~hfsplus-fix-unused-node-is-not-erased-error fs/hfsplus/hfsplus_raw.h
--- a/fs/hfsplus/hfsplus_raw.h~hfsplus-fix-unused-node-is-not-erased-error
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -144,6 +144,7 @@ struct hfsplus_vh {
 #define HFSPLUS_VOL_NODEID_REUSED	(1 << 12)
 #define HFSPLUS_VOL_JOURNALED		(1 << 13)
 #define HFSPLUS_VOL_SOFTLOCK		(1 << 15)
+#define HFSPLUS_VOL_UNUSED_NODE_FIX	(1 << 31)
 
 /* HFS+ BTree node descriptor */
 struct hfs_bnode_desc {
diff -puN fs/hfsplus/xattr.c~hfsplus-fix-unused-node-is-not-erased-error fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-fix-unused-node-is-not-erased-error
+++ a/fs/hfsplus/xattr.c
@@ -196,7 +196,7 @@ check_attr_tree_state_again:
 	}
 
 	while (hip->alloc_blocks < hip->clump_blocks) {
-		err = hfsplus_file_extend(attr_file);
+		err = hfsplus_file_extend(attr_file, false);
 		if (unlikely(err)) {
 			pr_err("failed to extend attributes file\n");
 			goto end_attr_file_creation;
_

Patches currently in -mm which might be from saproj@gmail.com are

origin.patch

