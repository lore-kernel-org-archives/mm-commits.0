From: akpm@linux-foundation.org
Subject: [merged] nilfs2-add-bmap-function-to-seek-a-valid-key.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:47 -0700
Message-ID: <55355117.H0CJcRwTZJRc9Gei%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbbDTTM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add bmap function to seek a valid key
has been removed from the -mm tree.  Its filename was
     nilfs2-add-bmap-function-to-seek-a-valid-key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: add bmap function to seek a valid key

Add a new bmap function, nilfs_bmap_seek_key(), which seeks a valid
entry and returns its key starting from a given key.  This function
can be used to skip hole blocks efficiently.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c   |   31 +++++++++++++++++++++
 fs/nilfs2/bmap.h   |    5 ++-
 fs/nilfs2/btree.c  |   63 +++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/direct.c |   17 +++++++++++
 4 files changed, 115 insertions(+), 1 deletion(-)

diff -puN fs/nilfs2/bmap.c~nilfs2-add-bmap-function-to-seek-a-valid-key fs/nilfs2/bmap.c
--- a/fs/nilfs2/bmap.c~nilfs2-add-bmap-function-to-seek-a-valid-key
+++ a/fs/nilfs2/bmap.c
@@ -189,6 +189,37 @@ static int nilfs_bmap_do_delete(struct n
 	return bmap->b_ops->bop_delete(bmap, key);
 }
 
+/**
+ * nilfs_bmap_seek_key - seek a valid entry and return its key
+ * @bmap: bmap struct
+ * @start: start key number
+ * @keyp: place to store valid key
+ *
+ * Description: nilfs_bmap_seek_key() seeks a valid key on @bmap
+ * starting from @start, and stores it to @keyp if found.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - No valid entry was found
+ */
+int nilfs_bmap_seek_key(struct nilfs_bmap *bmap, __u64 start, __u64 *keyp)
+{
+	int ret;
+
+	down_read(&bmap->b_sem);
+	ret = bmap->b_ops->bop_seek_key(bmap, start, keyp);
+	up_read(&bmap->b_sem);
+
+	if (ret < 0)
+		ret = nilfs_bmap_convert_error(bmap, __func__, ret);
+	return ret;
+}
+
 int nilfs_bmap_last_key(struct nilfs_bmap *bmap, __u64 *keyp)
 {
 	int ret;
diff -puN fs/nilfs2/bmap.h~nilfs2-add-bmap-function-to-seek-a-valid-key fs/nilfs2/bmap.h
--- a/fs/nilfs2/bmap.h~nilfs2-add-bmap-function-to-seek-a-valid-key
+++ a/fs/nilfs2/bmap.h
@@ -76,8 +76,10 @@ struct nilfs_bmap_operations {
 			  union nilfs_binfo *);
 	int (*bop_mark)(struct nilfs_bmap *, __u64, int);
 
-	/* The following functions are internal use only. */
+	int (*bop_seek_key)(const struct nilfs_bmap *, __u64, __u64 *);
 	int (*bop_last_key)(const struct nilfs_bmap *, __u64 *);
+
+	/* The following functions are internal use only. */
 	int (*bop_check_insert)(const struct nilfs_bmap *, __u64);
 	int (*bop_check_delete)(struct nilfs_bmap *, __u64);
 	int (*bop_gather_data)(struct nilfs_bmap *, __u64 *, __u64 *, int);
@@ -155,6 +157,7 @@ void nilfs_bmap_write(struct nilfs_bmap
 int nilfs_bmap_lookup_contig(struct nilfs_bmap *, __u64, __u64 *, unsigned);
 int nilfs_bmap_insert(struct nilfs_bmap *bmap, __u64 key, unsigned long rec);
 int nilfs_bmap_delete(struct nilfs_bmap *bmap, __u64 key);
+int nilfs_bmap_seek_key(struct nilfs_bmap *bmap, __u64 start, __u64 *keyp);
 int nilfs_bmap_last_key(struct nilfs_bmap *bmap, __u64 *keyp);
 int nilfs_bmap_truncate(struct nilfs_bmap *bmap, __u64 key);
 void nilfs_bmap_clear(struct nilfs_bmap *);
diff -puN fs/nilfs2/btree.c~nilfs2-add-bmap-function-to-seek-a-valid-key fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-add-bmap-function-to-seek-a-valid-key
+++ a/fs/nilfs2/btree.c
@@ -633,6 +633,44 @@ static int nilfs_btree_do_lookup_last(co
 	return 0;
 }
 
+/**
+ * nilfs_btree_get_next_key - get next valid key from btree path array
+ * @btree: bmap struct of btree
+ * @path: array of nilfs_btree_path struct
+ * @minlevel: start level
+ * @nextkey: place to store the next valid key
+ *
+ * Return Value: If a next key was found, 0 is returned. Otherwise,
+ * -ENOENT is returned.
+ */
+static int nilfs_btree_get_next_key(const struct nilfs_bmap *btree,
+				    const struct nilfs_btree_path *path,
+				    int minlevel, __u64 *nextkey)
+{
+	struct nilfs_btree_node *node;
+	int maxlevel = nilfs_btree_height(btree) - 1;
+	int index, next_adj, level;
+
+	/* Next index is already set to bp_index for leaf nodes. */
+	next_adj = 0;
+	for (level = minlevel; level <= maxlevel; level++) {
+		if (level == maxlevel)
+			node = nilfs_btree_get_root(btree);
+		else
+			node = nilfs_btree_get_nonroot_node(path, level);
+
+		index = path[level].bp_index + next_adj;
+		if (index < nilfs_btree_node_get_nchildren(node)) {
+			/* Next key is in this node */
+			*nextkey = nilfs_btree_node_get_key(node, index);
+			return 0;
+		}
+		/* For non-leaf nodes, next index is stored at bp_index + 1. */
+		next_adj = 1;
+	}
+	return -ENOENT;
+}
+
 static int nilfs_btree_lookup(const struct nilfs_bmap *btree,
 			      __u64 key, int level, __u64 *ptrp)
 {
@@ -1563,6 +1601,27 @@ out:
 	return ret;
 }
 
+static int nilfs_btree_seek_key(const struct nilfs_bmap *btree, __u64 start,
+				__u64 *keyp)
+{
+	struct nilfs_btree_path *path;
+	const int minlevel = NILFS_BTREE_LEVEL_NODE_MIN;
+	int ret;
+
+	path = nilfs_btree_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = nilfs_btree_do_lookup(btree, path, start, NULL, minlevel, 0);
+	if (!ret)
+		*keyp = start;
+	else if (ret == -ENOENT)
+		ret = nilfs_btree_get_next_key(btree, path, minlevel, keyp);
+
+	nilfs_btree_free_path(path);
+	return ret;
+}
+
 static int nilfs_btree_last_key(const struct nilfs_bmap *btree, __u64 *keyp)
 {
 	struct nilfs_btree_path *path;
@@ -2298,7 +2357,9 @@ static const struct nilfs_bmap_operation
 	.bop_assign		=	nilfs_btree_assign,
 	.bop_mark		=	nilfs_btree_mark,
 
+	.bop_seek_key		=	nilfs_btree_seek_key,
 	.bop_last_key		=	nilfs_btree_last_key,
+
 	.bop_check_insert	=	NULL,
 	.bop_check_delete	=	nilfs_btree_check_delete,
 	.bop_gather_data	=	nilfs_btree_gather_data,
@@ -2318,7 +2379,9 @@ static const struct nilfs_bmap_operation
 	.bop_assign		=	nilfs_btree_assign_gc,
 	.bop_mark		=	NULL,
 
+	.bop_seek_key		=	NULL,
 	.bop_last_key		=	NULL,
+
 	.bop_check_insert	=	NULL,
 	.bop_check_delete	=	NULL,
 	.bop_gather_data	=	NULL,
diff -puN fs/nilfs2/direct.c~nilfs2-add-bmap-function-to-seek-a-valid-key fs/nilfs2/direct.c
--- a/fs/nilfs2/direct.c~nilfs2-add-bmap-function-to-seek-a-valid-key
+++ a/fs/nilfs2/direct.c
@@ -173,6 +173,21 @@ static int nilfs_direct_delete(struct ni
 	return ret;
 }
 
+static int nilfs_direct_seek_key(const struct nilfs_bmap *direct, __u64 start,
+				 __u64 *keyp)
+{
+	__u64 key;
+
+	for (key = start; key <= NILFS_DIRECT_KEY_MAX; key++) {
+		if (nilfs_direct_get_ptr(direct, key) !=
+		    NILFS_BMAP_INVALID_PTR) {
+			*keyp = key;
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
 static int nilfs_direct_last_key(const struct nilfs_bmap *direct, __u64 *keyp)
 {
 	__u64 key, lastkey;
@@ -355,7 +370,9 @@ static const struct nilfs_bmap_operation
 	.bop_assign		=	nilfs_direct_assign,
 	.bop_mark		=	NULL,
 
+	.bop_seek_key		=	nilfs_direct_seek_key,
 	.bop_last_key		=	nilfs_direct_last_key,
+
 	.bop_check_insert	=	nilfs_direct_check_insert,
 	.bop_check_delete	=	NULL,
 	.bop_gather_data	=	nilfs_direct_gather_data,
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

