From: akpm@osdl.org
Subject: + reiser4-improve-estimation-for-number-of-nodes-occupied.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:45:06 -0800
Message-ID: <200701250545.l0P5j6Ao007159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48069 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965353AbXAYFpL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:45:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com


The patch titled
     reiser4: improve estimation for number of nodes occupied  by disk cluster
has been added to the -mm tree.  Its filename is
     reiser4-improve-estimation-for-number-of-nodes-occupied.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4: improve estimation for number of nodes occupied  by disk cluster
From: Edward Shishkin <edward@namesys.com>

Improved estimation for amount of dirty nodes occupied by a disk cluster (old
estimation means 256M of dead space on a partition).

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/estimate.c                  |   15 +++++++++++----
 fs/reiser4/plugin/cluster.h            |   16 ++++++++++++++++
 fs/reiser4/plugin/file/cryptcompress.c |   20 +++++++++++++++++++-
 fs/reiser4/plugin/item/ctail.h         |   23 ++++++++++++++---------
 4 files changed, 60 insertions(+), 14 deletions(-)

diff -puN fs/reiser4/estimate.c~reiser4-improve-estimation-for-number-of-nodes-occupied fs/reiser4/estimate.c
--- a/fs/reiser4/estimate.c~reiser4-improve-estimation-for-number-of-nodes-occupied
+++ a/fs/reiser4/estimate.c
@@ -93,12 +93,19 @@ reiser4_block_nr estimate_update_cluster
 	return estimate_cluster(inode, 0); /* 44, for 64K-cluster */
 }
 
-/* how many nodes occupied by a disk cluster might get dirty
-   FIXME-EDWARD: This estimation is pretty bad (65536 nodes for
-   64K-cluster, it means 256M of dead space on the partition) */
+/* How many nodes occupied by a disk cluster might get dirty.
+   Note that this estimation is not precise (i.e. disk cluster
+   can occupy more nodes).
+   Q: Why we don't use precise estimation?
+   A: 1.Because precise estimation is fairly bad: 65536 nodes
+        for 64K logical cluster, it means 256M of dead space on
+	a partition
+      2.It is a very rare case when disk cluster occupies more
+        nodes then this estimation returns.
+*/
 reiser4_block_nr estimate_dirty_cluster(struct inode * inode)
 {
-	return inode_cluster_size(inode);
+	return cluster_nrpages(inode) + 4;
 }
 
 /* Make Linus happy.
diff -puN fs/reiser4/plugin/cluster.h~reiser4-improve-estimation-for-number-of-nodes-occupied fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~reiser4-improve-estimation-for-number-of-nodes-occupied
+++ a/fs/reiser4/plugin/cluster.h
@@ -226,6 +226,22 @@ static inline int dclust_get_extension_s
 	return hint->ext_coord.extension.ctail.shift;
 }
 
+static inline int dclust_get_extension_ncount(hint_t * hint)
+{
+	return hint->ext_coord.extension.ctail.ncount;
+}
+
+static inline void dclust_inc_extension_ncount(hint_t * hint)
+{
+	hint->ext_coord.extension.ctail.ncount ++;
+}
+
+static inline void dclust_init_extension(hint_t * hint)
+{
+	memset(&hint->ext_coord.extension.ctail, 0,
+	       sizeof(hint->ext_coord.extension.ctail));
+}
+
 static inline int hint_is_unprepped_dclust(hint_t * hint)
 {
 	assert("edward-1451", hint_is_valid(hint));
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-improve-estimation-for-number-of-nodes-occupied fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-improve-estimation-for-number-of-nodes-occupied
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -742,6 +742,7 @@ static int find_cluster_item(hint_t * hi
 {
 	int result;
 	reiser4_key ikey;
+	int went_right = 0;
 	coord_t *coord = &hint->ext_coord.coord;
 	coord_t orig = *coord;
 
@@ -771,6 +772,7 @@ static int find_cluster_item(hint_t * hi
 		if (result)
 			return result;
 		assert("edward-1218", equal_to_ldk(coord->node, key));
+		went_right = 1;
 	} else {
 		coord->item_pos++;
 		coord->unit_pos = 0;
@@ -789,6 +791,9 @@ static int find_cluster_item(hint_t * hi
 	zrelse(coord->node);
 	if (!keyeq(key, &ikey))
 		goto not_found;
+	/* Ok, item is found, update node counts */
+	if (went_right)
+		dclust_inc_extension_ncount(hint);
 	return CBK_COORD_FOUND;
 
       not_found:
@@ -804,12 +809,15 @@ static int find_cluster_item(hint_t * hi
 	assert("edward-714", reiser4_schedulable());
 
 	reiser4_unset_hint(hint);
+	dclust_init_extension(hint);
 	coord_init_zero(coord);
 	result = coord_by_key(current_tree, key, coord, &hint->lh,
 			      lock_mode, bias, LEAF_LEVEL, LEAF_LEVEL,
 			      CBK_UNIQUE | flags, ra_info);
 	if (cbk_errored(result))
 		return result;
+	if(result == CBK_COORD_FOUND)
+		dclust_inc_extension_ncount(hint);
 	hint_set_valid(hint);
 	return result;
 }
@@ -2017,6 +2025,8 @@ int find_disk_cluster(reiser4_cluster_t 
 	assert("edward-462", !tfm_cluster_is_uptodate(tc));
 	assert("edward-461", ergo(read, tfm_stream_is_set(tc, INPUT_STREAM)));
 
+	dclust_init_extension(hint);
+
 	/* set key of the first disk cluster item */
 	fplug->flow_by_inode(inode,
 			     (read ? (char __user *)tfm_stream_data(tc, INPUT_STREAM) : NULL),
@@ -2078,7 +2088,15 @@ int find_disk_cluster(reiser4_cluster_t 
 				goto out;
 			}
 			if (mode == ZNODE_WRITE_LOCK) {
-				znode_make_dirty(hint->ext_coord.coord.node);
+				/* Don't make dirty more nodes then it was
+				   estimated (see comments before
+				   estimate_dirty_cluster). Missed nodes will be
+				   read up in flush time if they are evicted from
+				   memory */
+				if (dclust_get_extension_ncount(hint) <=
+				    estimate_dirty_cluster(inode))
+				   znode_make_dirty(hint->ext_coord.coord.node);
+
 				znode_set_convertible(hint->ext_coord.coord.
 						      node);
 			}
diff -puN fs/reiser4/plugin/item/ctail.h~reiser4-improve-estimation-for-number-of-nodes-occupied fs/reiser4/plugin/item/ctail.h
--- a/fs/reiser4/plugin/item/ctail.h~reiser4-improve-estimation-for-number-of-nodes-occupied
+++ a/fs/reiser4/plugin/item/ctail.h
@@ -3,20 +3,22 @@
 #if !defined( __FS_REISER4_CTAIL_H__ )
 #define __FS_REISER4_CTAIL_H__
 
-/* cryptcompress object item. See ctail.c for description. */
-
-/* number of units and cluster_shift of ctail item
-   that represents unprepped disk cluster */
-#define UCTAIL_NR_UNITS 1
-#define UCTAIL_SHIFT 0xff
-
+/* Disk format of ctail item */
 typedef struct ctail_item_format {
-	/* cluster shift */
+	/* packed shift; size of (prepped) disk cluster
+	   is calculated as (1 << cluster_shift) */
 	d8 cluster_shift;
 	/* ctail body */
 	d8 body[0];
 } __attribute__ ((packed)) ctail_item_format;
 
+/* Unprepped disk cluster is represented by a single ctail item
+   with the following "magic" attributes: */
+/* "magic" cluster_shift */
+#define UCTAIL_SHIFT 0xff
+/* How many units unprepped ctail item has */
+#define UCTAIL_NR_UNITS 1
+
 /* The following is a set of various item states in a disk cluster.
    Disk cluster is a set of items whose keys belong to the interval
    [dc_key , dc_key + disk_cluster_size - 1] */
@@ -27,11 +29,14 @@ typedef enum {
 	DC_AFTER_CLUSTER = 3
 } dc_item_stat;
 
+/* ctail-specific extension.
+   In particular this describes parameters of disk cluster an item belongs to */
 typedef struct {
 	int shift; /* this contains cluster_shift extracted from
 		      ctail_item_format (above), or UCTAIL_SHIFT
-		      (the last one is for unprepped disk clusters) */
+		      (the last one is the "magic" of unprepped disk clusters)*/
 	int dsize; /* size of a prepped disk cluster */
+	int ncount; /* count of nodes occupied by a disk cluster */
 } ctail_coord_extension_t;
 
 struct cut_list;
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4-vs-streamline-generic_file_-interfaces-and-filemap-fix.patch
reiser4-rename-generic_sounding_globalspatch.patch
reiser4-use-generic-file-read-fix-readpages-unix-file.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
reiser4-cleanups-in-lzo-compression-library.patch
reiser4-get-rid-of-deprecated-crypto-api.patch
reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch
reiser4-fix-missed-unlock-and-exit_context.patch
reiser4-use-list_head-instead-of-struct-blocknr.patch
reiser4-use-list_empty-instead-of-list_empty_careful-for.patch
reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
reiser4-temp-fix.patch
reiser4-fix-write_extent-1.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
