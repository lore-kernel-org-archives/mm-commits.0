From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-unify-type-of-key-arguments-in-bmap-interface.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:45 -0700
Message-ID: <55355115.tXwwhRjIvtleer9Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbbDTTMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: unify type of key arguments in bmap interface
has been removed from the -mm tree.  Its filename was
     nilfs2-unify-type-of-key-arguments-in-bmap-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: unify type of key arguments in bmap interface

The type of key arguments in block mapping interface varies depending
on function.  For instance, nilfs_bmap_lookup_at_level() takes "__u64"
for its key argument whereas nilfs_bmap_lookup() takes "unsigned
long".

This fits them to "__u64" to eliminate the variation.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |    5 +++--
 fs/nilfs2/bmap.c  |   17 ++++++-----------
 fs/nilfs2/bmap.h  |    8 ++++----
 fs/nilfs2/inode.c |    6 +++---
 4 files changed, 16 insertions(+), 20 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-unify-type-of-key-arguments-in-bmap-interface fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-unify-type-of-key-arguments-in-bmap-interface
+++ a/fs/nilfs2/alloc.c
@@ -405,13 +405,14 @@ nilfs_palloc_rest_groups_in_desc_block(c
 static int nilfs_palloc_count_desc_blocks(struct inode *inode,
 					    unsigned long *desc_blocks)
 {
-	unsigned long blknum;
+	__u64 blknum;
 	int ret;
 
 	ret = nilfs_bmap_last_key(NILFS_I(inode)->i_bmap, &blknum);
 	if (likely(!ret))
 		*desc_blocks = DIV_ROUND_UP(
-			blknum, NILFS_MDT(inode)->mi_blocks_per_desc_block);
+			(unsigned long)blknum,
+			NILFS_MDT(inode)->mi_blocks_per_desc_block);
 	return ret;
 }
 
diff -puN fs/nilfs2/bmap.c~nilfs2-unify-type-of-key-arguments-in-bmap-interface fs/nilfs2/bmap.c
--- a/fs/nilfs2/bmap.c~nilfs2-unify-type-of-key-arguments-in-bmap-interface
+++ a/fs/nilfs2/bmap.c
@@ -152,9 +152,7 @@ static int nilfs_bmap_do_insert(struct n
  *
  * %-EEXIST - A record associated with @key already exist.
  */
-int nilfs_bmap_insert(struct nilfs_bmap *bmap,
-		      unsigned long key,
-		      unsigned long rec)
+int nilfs_bmap_insert(struct nilfs_bmap *bmap, __u64 key, unsigned long rec)
 {
 	int ret;
 
@@ -191,19 +189,16 @@ static int nilfs_bmap_do_delete(struct n
 	return bmap->b_ops->bop_delete(bmap, key);
 }
 
-int nilfs_bmap_last_key(struct nilfs_bmap *bmap, unsigned long *key)
+int nilfs_bmap_last_key(struct nilfs_bmap *bmap, __u64 *keyp)
 {
-	__u64 lastkey;
 	int ret;
 
 	down_read(&bmap->b_sem);
-	ret = bmap->b_ops->bop_last_key(bmap, &lastkey);
+	ret = bmap->b_ops->bop_last_key(bmap, keyp);
 	up_read(&bmap->b_sem);
 
 	if (ret < 0)
 		ret = nilfs_bmap_convert_error(bmap, __func__, ret);
-	else
-		*key = lastkey;
 	return ret;
 }
 
@@ -224,7 +219,7 @@ int nilfs_bmap_last_key(struct nilfs_bma
  *
  * %-ENOENT - A record associated with @key does not exist.
  */
-int nilfs_bmap_delete(struct nilfs_bmap *bmap, unsigned long key)
+int nilfs_bmap_delete(struct nilfs_bmap *bmap, __u64 key)
 {
 	int ret;
 
@@ -235,7 +230,7 @@ int nilfs_bmap_delete(struct nilfs_bmap
 	return nilfs_bmap_convert_error(bmap, __func__, ret);
 }
 
-static int nilfs_bmap_do_truncate(struct nilfs_bmap *bmap, unsigned long key)
+static int nilfs_bmap_do_truncate(struct nilfs_bmap *bmap, __u64 key)
 {
 	__u64 lastkey;
 	int ret;
@@ -276,7 +271,7 @@ static int nilfs_bmap_do_truncate(struct
  *
  * %-ENOMEM - Insufficient amount of memory available.
  */
-int nilfs_bmap_truncate(struct nilfs_bmap *bmap, unsigned long key)
+int nilfs_bmap_truncate(struct nilfs_bmap *bmap, __u64 key)
 {
 	int ret;
 
diff -puN fs/nilfs2/bmap.h~nilfs2-unify-type-of-key-arguments-in-bmap-interface fs/nilfs2/bmap.h
--- a/fs/nilfs2/bmap.h~nilfs2-unify-type-of-key-arguments-in-bmap-interface
+++ a/fs/nilfs2/bmap.h
@@ -153,10 +153,10 @@ int nilfs_bmap_test_and_clear_dirty(stru
 int nilfs_bmap_read(struct nilfs_bmap *, struct nilfs_inode *);
 void nilfs_bmap_write(struct nilfs_bmap *, struct nilfs_inode *);
 int nilfs_bmap_lookup_contig(struct nilfs_bmap *, __u64, __u64 *, unsigned);
-int nilfs_bmap_insert(struct nilfs_bmap *, unsigned long, unsigned long);
-int nilfs_bmap_delete(struct nilfs_bmap *, unsigned long);
-int nilfs_bmap_last_key(struct nilfs_bmap *, unsigned long *);
-int nilfs_bmap_truncate(struct nilfs_bmap *, unsigned long);
+int nilfs_bmap_insert(struct nilfs_bmap *bmap, __u64 key, unsigned long rec);
+int nilfs_bmap_delete(struct nilfs_bmap *bmap, __u64 key);
+int nilfs_bmap_last_key(struct nilfs_bmap *bmap, __u64 *keyp);
+int nilfs_bmap_truncate(struct nilfs_bmap *bmap, __u64 key);
 void nilfs_bmap_clear(struct nilfs_bmap *);
 int nilfs_bmap_propagate(struct nilfs_bmap *, struct buffer_head *);
 void nilfs_bmap_lookup_dirty_buffers(struct nilfs_bmap *, struct list_head *);
diff -puN fs/nilfs2/inode.c~nilfs2-unify-type-of-key-arguments-in-bmap-interface fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-unify-type-of-key-arguments-in-bmap-interface
+++ a/fs/nilfs2/inode.c
@@ -106,7 +106,7 @@ int nilfs_get_block(struct inode *inode,
 		err = nilfs_transaction_begin(inode->i_sb, &ti, 1);
 		if (unlikely(err))
 			goto out;
-		err = nilfs_bmap_insert(ii->i_bmap, (unsigned long)blkoff,
+		err = nilfs_bmap_insert(ii->i_bmap, blkoff,
 					(unsigned long)bh_result);
 		if (unlikely(err != 0)) {
 			if (err == -EEXIST) {
@@ -714,7 +714,7 @@ void nilfs_update_inode(struct inode *in
 static void nilfs_truncate_bmap(struct nilfs_inode_info *ii,
 				unsigned long from)
 {
-	unsigned long b;
+	__u64 b;
 	int ret;
 
 	if (!test_bit(NILFS_I_BMAP, &ii->i_state))
@@ -729,7 +729,7 @@ repeat:
 	if (b < from)
 		return;
 
-	b -= min_t(unsigned long, NILFS_MAX_TRUNCATE_BLOCKS, b - from);
+	b -= min_t(__u64, NILFS_MAX_TRUNCATE_BLOCKS, b - from);
 	ret = nilfs_bmap_truncate(ii->i_bmap, b);
 	nilfs_relax_pressure_in_lock(ii->vfs_inode.i_sb);
 	if (!ret || (ret == -ENOMEM &&
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

