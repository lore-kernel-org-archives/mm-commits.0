From: akpm@linux-foundation.org
Subject: + nilfs2-reduce-bare-use-of-printk-with-nilfs_msg.patch added to
 -mm tree
Date: Thu, 02 Jun 2016 13:19:55 -0700
Message-ID: <575094eb.IutymcpVb/vN1mSA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593AbcFBUT4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 16:19:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: reduce bare use of printk() with nilfs_msg()
has been added to the -mm tree.  Its filename is
     nilfs2-reduce-bare-use-of-printk-with-nilfs_msg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-reduce-bare-use-of-printk-with-nilfs_msg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-reduce-bare-use-of-printk-with-nilfs_msg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: reduce bare use of printk() with nilfs_msg()

Replace most use of printk() in nilfs2 implementation with nilfs_msg(),
and reduce the following checkpatch.pl warning:

  "WARNING: Prefer [subsystem eg: netdev]_crit([subsystem]dev, ...
   then dev_crit(dev, ... then pr_crit(...  to printk(KERN_CRIT ..."

This patch also fixes a minor checkpatch warning "WARNING: quoted string
split across lines" that often accompanies the prior warning, and amends
message format as needed.

Link: http://lkml.kernel.org/r/1464875891-5443-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c     |   58 ++++++++++--------
 fs/nilfs2/cpfile.c    |   22 +++---
 fs/nilfs2/dat.c       |   19 ++---
 fs/nilfs2/direct.c    |   10 +--
 fs/nilfs2/inode.c     |   11 +--
 fs/nilfs2/ioctl.c     |   47 +++++++-------
 fs/nilfs2/recovery.c  |   72 +++++++++++-----------
 fs/nilfs2/segbuf.c    |    6 +
 fs/nilfs2/segment.c   |   25 +++----
 fs/nilfs2/sufile.c    |   31 +++++----
 fs/nilfs2/super.c     |  100 ++++++++++++++-----------------
 fs/nilfs2/sysfs.c     |   30 +++++----
 fs/nilfs2/the_nilfs.c |  127 +++++++++++++++++++++-------------------
 13 files changed, 283 insertions(+), 275 deletions(-)

diff -puN fs/nilfs2/btree.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/btree.c
@@ -339,12 +339,14 @@ static int nilfs_btree_node_lookup(const
  * nilfs_btree_node_broken - verify consistency of btree node
  * @node: btree node block to be examined
  * @size: node size (in bytes)
+ * @inode: host inode of btree
  * @blocknr: block number
  *
  * Return Value: If node is broken, 1 is returned. Otherwise, 0 is returned.
  */
 static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
-				   size_t size, sector_t blocknr)
+				   size_t size, struct inode *inode,
+				   sector_t blocknr)
 {
 	int level, flags, nchildren;
 	int ret = 0;
@@ -358,9 +360,10 @@ static int nilfs_btree_node_broken(const
 		     (flags & NILFS_BTREE_NODE_ROOT) ||
 		     nchildren < 0 ||
 		     nchildren > NILFS_BTREE_NODE_NCHILDREN_MAX(size))) {
-		printk(KERN_CRIT "NILFS: bad btree node (blocknr=%llu): "
-		       "level = %d, flags = 0x%x, nchildren = %d\n",
-		       (unsigned long long)blocknr, level, flags, nchildren);
+		nilfs_msg(inode->i_sb, KERN_CRIT,
+			  "bad btree node (ino=%lu, blocknr=%llu): level = %d, flags = 0x%x, nchildren = %d",
+			  inode->i_ino, (unsigned long long)blocknr, level,
+			  flags, nchildren);
 		ret = 1;
 	}
 	return ret;
@@ -369,12 +372,12 @@ static int nilfs_btree_node_broken(const
 /**
  * nilfs_btree_root_broken - verify consistency of btree root node
  * @node: btree root node to be examined
- * @ino: inode number
+ * @inode: host inode of btree
  *
  * Return Value: If node is broken, 1 is returned. Otherwise, 0 is returned.
  */
 static int nilfs_btree_root_broken(const struct nilfs_btree_node *node,
-				   unsigned long ino)
+				   struct inode *inode)
 {
 	int level, flags, nchildren;
 	int ret = 0;
@@ -387,8 +390,9 @@ static int nilfs_btree_root_broken(const
 		     level >= NILFS_BTREE_LEVEL_MAX ||
 		     nchildren < 0 ||
 		     nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX)) {
-		pr_crit("NILFS: bad btree root (inode number=%lu): level = %d, flags = 0x%x, nchildren = %d\n",
-			ino, level, flags, nchildren);
+		nilfs_msg(inode->i_sb, KERN_CRIT,
+			  "bad btree root (ino=%lu): level = %d, flags = 0x%x, nchildren = %d",
+			  inode->i_ino, level, flags, nchildren);
 		ret = 1;
 	}
 	return ret;
@@ -396,13 +400,15 @@ static int nilfs_btree_root_broken(const
 
 int nilfs_btree_broken_node_block(struct buffer_head *bh)
 {
+	struct inode *inode;
 	int ret;
 
 	if (buffer_nilfs_checked(bh))
 		return 0;
 
+	inode = bh->b_page->mapping->host;
 	ret = nilfs_btree_node_broken((struct nilfs_btree_node *)bh->b_data,
-				       bh->b_size, bh->b_blocknr);
+				      bh->b_size, inode, bh->b_blocknr);
 	if (likely(!ret))
 		set_buffer_nilfs_checked(bh);
 	return ret;
@@ -448,13 +454,15 @@ nilfs_btree_get_node(const struct nilfs_
 	return node;
 }
 
-static int
-nilfs_btree_bad_node(struct nilfs_btree_node *node, int level)
+static int nilfs_btree_bad_node(const struct nilfs_bmap *btree,
+				struct nilfs_btree_node *node, int level)
 {
 	if (unlikely(nilfs_btree_node_get_level(node) != level)) {
 		dump_stack();
-		printk(KERN_CRIT "NILFS: btree level mismatch: %d != %d\n",
-		       nilfs_btree_node_get_level(node), level);
+		nilfs_msg(btree->b_inode->i_sb, KERN_CRIT,
+			  "btree level mismatch (ino=%lu): %d != %d",
+			  btree->b_inode->i_ino,
+			  nilfs_btree_node_get_level(node), level);
 		return 1;
 	}
 	return 0;
@@ -566,7 +574,7 @@ static int nilfs_btree_do_lookup(const s
 			return ret;
 
 		node = nilfs_btree_get_nonroot_node(path, level);
-		if (nilfs_btree_bad_node(node, level))
+		if (nilfs_btree_bad_node(btree, node, level))
 			return -EINVAL;
 		if (!found)
 			found = nilfs_btree_node_lookup(node, key, &index);
@@ -614,7 +622,7 @@ static int nilfs_btree_do_lookup_last(co
 		if (ret < 0)
 			return ret;
 		node = nilfs_btree_get_nonroot_node(path, level);
-		if (nilfs_btree_bad_node(node, level))
+		if (nilfs_btree_bad_node(btree, node, level))
 			return -EINVAL;
 		index = nilfs_btree_node_get_nchildren(node) - 1;
 		ptr = nilfs_btree_node_get_ptr(node, index, ncmax);
@@ -2070,8 +2078,10 @@ static int nilfs_btree_propagate(struct
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1, 0);
 	if (ret < 0) {
 		if (unlikely(ret == -ENOENT))
-			printk(KERN_CRIT "%s: key = %llu, level == %d\n",
-			       __func__, (unsigned long long)key, level);
+			nilfs_msg(btree->b_inode->i_sb, KERN_CRIT,
+				  "writing node/leaf block does not appear in b-tree (ino=%lu) at key=%llu, level=%d",
+				  btree->b_inode->i_ino,
+				  (unsigned long long)key, level);
 		goto out;
 	}
 
@@ -2108,12 +2118,11 @@ static void nilfs_btree_add_dirty_buffer
 	if (level < NILFS_BTREE_LEVEL_NODE_MIN ||
 	    level >= NILFS_BTREE_LEVEL_MAX) {
 		dump_stack();
-		printk(KERN_WARNING
-		       "%s: invalid btree level: %d (key=%llu, ino=%lu, "
-		       "blocknr=%llu)\n",
-		       __func__, level, (unsigned long long)key,
-		       NILFS_BMAP_I(btree)->vfs_inode.i_ino,
-		       (unsigned long long)bh->b_blocknr);
+		nilfs_msg(btree->b_inode->i_sb, KERN_WARNING,
+			  "invalid btree level: %d (key=%llu, ino=%lu, blocknr=%llu)",
+			  level, (unsigned long long)key,
+			  btree->b_inode->i_ino,
+			  (unsigned long long)bh->b_blocknr);
 		return;
 	}
 
@@ -2392,8 +2401,7 @@ int nilfs_btree_init(struct nilfs_bmap *
 
 	__nilfs_btree_init(bmap);
 
-	if (nilfs_btree_root_broken(nilfs_btree_get_root(bmap),
-				    bmap->b_inode->i_ino))
+	if (nilfs_btree_root_broken(nilfs_btree_get_root(bmap), bmap->b_inode))
 		ret = -EIO;
 	return ret;
 }
diff -puN fs/nilfs2/cpfile.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/cpfile.c
@@ -332,9 +332,9 @@ int nilfs_cpfile_delete_checkpoints(stru
 	int ret, ncps, nicps, nss, count, i;
 
 	if (unlikely(start == 0 || start > end)) {
-		printk(KERN_ERR "%s: invalid range of checkpoint numbers: "
-		       "[%llu, %llu)\n", __func__,
-		       (unsigned long long)start, (unsigned long long)end);
+		nilfs_msg(cpfile->i_sb, KERN_ERR,
+			  "cannot delete checkpoints: invalid range [%llu, %llu)",
+			  (unsigned long long)start, (unsigned long long)end);
 		return -EINVAL;
 	}
 
@@ -386,9 +386,9 @@ int nilfs_cpfile_delete_checkpoints(stru
 								   cpfile, cno);
 					if (ret == 0)
 						continue;
-					printk(KERN_ERR
-					       "%s: cannot delete block\n",
-					       __func__);
+					nilfs_msg(cpfile->i_sb, KERN_ERR,
+						  "error %d deleting checkpoint block",
+						  ret);
 					break;
 				}
 			}
@@ -991,14 +991,12 @@ int nilfs_cpfile_read(struct super_block
 	int err;
 
 	if (cpsize > sb->s_blocksize) {
-		printk(KERN_ERR
-		       "NILFS: too large checkpoint size: %zu bytes.\n",
-		       cpsize);
+		nilfs_msg(sb, KERN_ERR,
+			  "too large checkpoint size: %zu bytes", cpsize);
 		return -EINVAL;
 	} else if (cpsize < NILFS_MIN_CHECKPOINT_SIZE) {
-		printk(KERN_ERR
-		       "NILFS: too small checkpoint size: %zu bytes.\n",
-		       cpsize);
+		nilfs_msg(sb, KERN_ERR,
+			  "too small checkpoint size: %zu bytes", cpsize);
 		return -EINVAL;
 	}
 
diff -puN fs/nilfs2/dat.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/dat.c
--- a/fs/nilfs2/dat.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/dat.c
@@ -349,10 +349,11 @@ int nilfs_dat_move(struct inode *dat, __
 	kaddr = kmap_atomic(entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
 	if (unlikely(entry->de_blocknr == cpu_to_le64(0))) {
-		printk(KERN_CRIT "%s: vbn = %llu, [%llu, %llu)\n", __func__,
-		       (unsigned long long)vblocknr,
-		       (unsigned long long)le64_to_cpu(entry->de_start),
-		       (unsigned long long)le64_to_cpu(entry->de_end));
+		nilfs_msg(dat->i_sb, KERN_CRIT,
+			  "%s: invalid vblocknr = %llu, [%llu, %llu)",
+			  __func__, (unsigned long long)vblocknr,
+			  (unsigned long long)le64_to_cpu(entry->de_start),
+			  (unsigned long long)le64_to_cpu(entry->de_end));
 		kunmap_atomic(kaddr);
 		brelse(entry_bh);
 		return -EINVAL;
@@ -479,14 +480,12 @@ int nilfs_dat_read(struct super_block *s
 	int err;
 
 	if (entry_size > sb->s_blocksize) {
-		printk(KERN_ERR
-		       "NILFS: too large DAT entry size: %zu bytes.\n",
-		       entry_size);
+		nilfs_msg(sb, KERN_ERR, "too large DAT entry size: %zu bytes",
+			  entry_size);
 		return -EINVAL;
 	} else if (entry_size < NILFS_MIN_DAT_ENTRY_SIZE) {
-		printk(KERN_ERR
-		       "NILFS: too small DAT entry size: %zu bytes.\n",
-		       entry_size);
+		nilfs_msg(sb, KERN_ERR, "too small DAT entry size: %zu bytes",
+			  entry_size);
 		return -EINVAL;
 	}
 
diff -puN fs/nilfs2/direct.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/direct.c
--- a/fs/nilfs2/direct.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/direct.c
@@ -337,14 +337,16 @@ static int nilfs_direct_assign(struct ni
 
 	key = nilfs_bmap_data_get_key(bmap, *bh);
 	if (unlikely(key > NILFS_DIRECT_KEY_MAX)) {
-		printk(KERN_CRIT "%s: invalid key: %llu\n", __func__,
-		       (unsigned long long)key);
+		nilfs_msg(bmap->b_inode->i_sb, KERN_CRIT,
+			  "%s (ino=%lu): invalid key: %llu", __func__,
+			  bmap->b_inode->i_ino, (unsigned long long)key);
 		return -EINVAL;
 	}
 	ptr = nilfs_direct_get_ptr(bmap, key);
 	if (unlikely(ptr == NILFS_BMAP_INVALID_PTR)) {
-		printk(KERN_CRIT "%s: invalid pointer: %llu\n", __func__,
-		       (unsigned long long)ptr);
+		nilfs_msg(bmap->b_inode->i_sb, KERN_CRIT,
+			  "%s (ino=%lu): invalid pointer: %llu", __func__,
+			  bmap->b_inode->i_ino, (unsigned long long)ptr);
 		return -EINVAL;
 	}
 
diff -puN fs/nilfs2/inode.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/inode.c
@@ -112,13 +112,10 @@ int nilfs_get_block(struct inode *inode,
 				 * However, the page having this block must
 				 * be locked in this case.
 				 */
-				printk(KERN_WARNING
-				       "nilfs_get_block: a race condition "
-				       "while inserting a data block. "
-				       "(inode number=%lu, file block "
-				       "offset=%llu)\n",
-				       inode->i_ino,
-				       (unsigned long long)blkoff);
+				nilfs_msg(inode->i_sb, KERN_WARNING,
+					  "%s (ino=%lu): a race condition while inserting a data block at offset=%llu",
+					  __func__, inode->i_ino,
+					  (unsigned long long)blkoff);
 				err = 0;
 			}
 			nilfs_transaction_abort(inode->i_sb);
diff -puN fs/nilfs2/ioctl.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/ioctl.c
@@ -584,27 +584,25 @@ static int nilfs_ioctl_move_inode_block(
 
 	if (unlikely(ret < 0)) {
 		if (ret == -ENOENT)
-			printk(KERN_CRIT
-			       "%s: invalid virtual block address (%s): "
-			       "ino=%llu, cno=%llu, offset=%llu, "
-			       "blocknr=%llu, vblocknr=%llu\n",
-			       __func__, vdesc->vd_flags ? "node" : "data",
-			       (unsigned long long)vdesc->vd_ino,
-			       (unsigned long long)vdesc->vd_cno,
-			       (unsigned long long)vdesc->vd_offset,
-			       (unsigned long long)vdesc->vd_blocknr,
-			       (unsigned long long)vdesc->vd_vblocknr);
+			nilfs_msg(inode->i_sb, KERN_CRIT,
+				  "%s: invalid virtual block address (%s): ino=%llu, cno=%llu, offset=%llu, blocknr=%llu, vblocknr=%llu",
+				  __func__, vdesc->vd_flags ? "node" : "data",
+				  (unsigned long long)vdesc->vd_ino,
+				  (unsigned long long)vdesc->vd_cno,
+				  (unsigned long long)vdesc->vd_offset,
+				  (unsigned long long)vdesc->vd_blocknr,
+				  (unsigned long long)vdesc->vd_vblocknr);
 		return ret;
 	}
 	if (unlikely(!list_empty(&bh->b_assoc_buffers))) {
-		printk(KERN_CRIT "%s: conflicting %s buffer: ino=%llu, "
-		       "cno=%llu, offset=%llu, blocknr=%llu, vblocknr=%llu\n",
-		       __func__, vdesc->vd_flags ? "node" : "data",
-		       (unsigned long long)vdesc->vd_ino,
-		       (unsigned long long)vdesc->vd_cno,
-		       (unsigned long long)vdesc->vd_offset,
-		       (unsigned long long)vdesc->vd_blocknr,
-		       (unsigned long long)vdesc->vd_vblocknr);
+		nilfs_msg(inode->i_sb, KERN_CRIT,
+			  "%s: conflicting %s buffer: ino=%llu, cno=%llu, offset=%llu, blocknr=%llu, vblocknr=%llu",
+			  __func__, vdesc->vd_flags ? "node" : "data",
+			  (unsigned long long)vdesc->vd_ino,
+			  (unsigned long long)vdesc->vd_cno,
+			  (unsigned long long)vdesc->vd_offset,
+			  (unsigned long long)vdesc->vd_blocknr,
+			  (unsigned long long)vdesc->vd_vblocknr);
 		brelse(bh);
 		return -EEXIST;
 	}
@@ -854,8 +852,8 @@ int nilfs_ioctl_prepare_clean_segments(s
 	return 0;
 
  failed:
-	printk(KERN_ERR "NILFS: GC failed during preparation: %s: err=%d\n",
-	       msg, ret);
+	nilfs_msg(nilfs->ns_sb, KERN_ERR, "error %d preparing GC: %s", ret,
+		  msg);
 	return ret;
 }
 
@@ -963,10 +961,11 @@ static int nilfs_ioctl_clean_segments(st
 	}
 
 	ret = nilfs_ioctl_move_blocks(inode->i_sb, &argv[0], kbufs[0]);
-	if (ret < 0)
-		printk(KERN_ERR "NILFS: GC failed during preparation: "
-			"cannot read source blocks: err=%d\n", ret);
-	else {
+	if (ret < 0) {
+		nilfs_msg(inode->i_sb, KERN_ERR,
+			  "error %d preparing GC: cannot read source blocks",
+			  ret);
+	} else {
 		if (nilfs_sb_need_update(nilfs))
 			set_nilfs_discontinued(nilfs);
 		ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
diff -puN fs/nilfs2/recovery.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/recovery.c
--- a/fs/nilfs2/recovery.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/recovery.c
@@ -54,38 +54,37 @@ struct nilfs_recovery_block {
 };
 
 
-static int nilfs_warn_segment_error(int err)
+static int nilfs_warn_segment_error(struct super_block *sb, int err)
 {
+	const char *msg = NULL;
+
 	switch (err) {
 	case NILFS_SEG_FAIL_IO:
-		printk(KERN_WARNING
-		       "NILFS warning: I/O error on loading last segment\n");
+		nilfs_msg(sb, KERN_ERR, "I/O error reading segment");
 		return -EIO;
 	case NILFS_SEG_FAIL_MAGIC:
-		printk(KERN_WARNING
-		       "NILFS warning: Segment magic number invalid\n");
+		msg = "Magic number mismatch";
 		break;
 	case NILFS_SEG_FAIL_SEQ:
-		printk(KERN_WARNING
-		       "NILFS warning: Sequence number mismatch\n");
+		msg = "Sequence number mismatch";
 		break;
 	case NILFS_SEG_FAIL_CHECKSUM_SUPER_ROOT:
-		printk(KERN_WARNING
-		       "NILFS warning: Checksum error in super root\n");
+		msg = "Checksum error in super root";
 		break;
 	case NILFS_SEG_FAIL_CHECKSUM_FULL:
-		printk(KERN_WARNING
-		       "NILFS warning: Checksum error in segment payload\n");
+		msg = "Checksum error in segment payload";
 		break;
 	case NILFS_SEG_FAIL_CONSISTENCY:
-		printk(KERN_WARNING
-		       "NILFS warning: Inconsistent segment\n");
+		msg = "Inconsistency found";
 		break;
 	case NILFS_SEG_NO_SUPER_ROOT:
-		printk(KERN_WARNING
-		       "NILFS warning: No super root in the last segment\n");
+		msg = "No super root in the last segment";
 		break;
+	default:
+		nilfs_msg(sb, KERN_ERR, "unrecognized segment error %d", err);
+		return -EINVAL;
 	}
+	nilfs_msg(sb, KERN_WARNING, "invalid segment: %s", msg);
 	return -EINVAL;
 }
 
@@ -178,7 +177,7 @@ int nilfs_read_super_root_block(struct t
 	brelse(bh_sr);
 
  failed:
-	return nilfs_warn_segment_error(ret);
+	return nilfs_warn_segment_error(nilfs->ns_sb, ret);
 }
 
 /**
@@ -553,11 +552,10 @@ static int nilfs_recover_dsync_blocks(st
 		put_page(page);
 
  failed_inode:
-		printk(KERN_WARNING
-		       "NILFS warning: error recovering data block "
-		       "(err=%d, ino=%lu, block-offset=%llu)\n",
-		       err, (unsigned long)rb->ino,
-		       (unsigned long long)rb->blkoff);
+		nilfs_msg(sb, KERN_WARNING,
+			  "error %d recovering data block (ino=%lu, block-offset=%llu)",
+			  err, (unsigned long)rb->ino,
+			  (unsigned long long)rb->blkoff);
 		if (!err2)
 			err2 = err;
  next:
@@ -680,8 +678,8 @@ static int nilfs_do_roll_forward(struct
 	}
 
 	if (nsalvaged_blocks) {
-		printk(KERN_INFO "NILFS (device %s): salvaged %lu blocks\n",
-		       sb->s_id, nsalvaged_blocks);
+		nilfs_msg(sb, KERN_INFO, "salvaged %lu blocks",
+			  nsalvaged_blocks);
 		ri->ri_need_recovery = NILFS_RECOVERY_ROLLFORWARD_DONE;
 	}
  out:
@@ -692,10 +690,9 @@ static int nilfs_do_roll_forward(struct
  confused:
 	err = -EINVAL;
  failed:
-	printk(KERN_ERR
-	       "NILFS (device %s): Error roll-forwarding "
-	       "(err=%d, pseg block=%llu). ",
-	       sb->s_id, err, (unsigned long long)pseg_start);
+	nilfs_msg(sb, KERN_ERR,
+		  "error %d roll-forwarding partial segment at blocknr = %llu",
+		  err, (unsigned long long)pseg_start);
 	goto out;
 }
 
@@ -715,9 +712,8 @@ static void nilfs_finish_roll_forward(st
 	set_buffer_dirty(bh);
 	err = sync_dirty_buffer(bh);
 	if (unlikely(err))
-		printk(KERN_WARNING
-		       "NILFS warning: buffer sync write failed during "
-		       "post-cleaning of recovery.\n");
+		nilfs_msg(nilfs->ns_sb, KERN_WARNING,
+			  "buffer sync write failed during post-cleaning of recovery.");
 	brelse(bh);
 }
 
@@ -752,8 +748,8 @@ int nilfs_salvage_orphan_logs(struct the
 
 	err = nilfs_attach_checkpoint(sb, ri->ri_cno, true, &root);
 	if (unlikely(err)) {
-		printk(KERN_ERR
-		       "NILFS: error loading the latest checkpoint.\n");
+		nilfs_msg(sb, KERN_ERR,
+			  "error %d loading the latest checkpoint", err);
 		return err;
 	}
 
@@ -764,8 +760,9 @@ int nilfs_salvage_orphan_logs(struct the
 	if (ri->ri_need_recovery == NILFS_RECOVERY_ROLLFORWARD_DONE) {
 		err = nilfs_prepare_segment_for_recovery(nilfs, sb, ri);
 		if (unlikely(err)) {
-			printk(KERN_ERR "NILFS: Error preparing segments for "
-			       "recovery.\n");
+			nilfs_msg(sb, KERN_ERR,
+				  "error %d preparing segment for recovery",
+				  err);
 			goto failed;
 		}
 
@@ -778,8 +775,9 @@ int nilfs_salvage_orphan_logs(struct the
 		nilfs_detach_log_writer(sb);
 
 		if (unlikely(err)) {
-			printk(KERN_ERR "NILFS: Oops! recovery failed. "
-			       "(err=%d)\n", err);
+			nilfs_msg(sb, KERN_ERR,
+				  "error %d writing segment for recovery",
+				  err);
 			goto failed;
 		}
 
@@ -961,5 +959,5 @@ int nilfs_search_super_root(struct the_n
  failed:
 	brelse(bh_sum);
 	nilfs_dispose_segment_list(&segments);
-	return (ret < 0) ? ret : nilfs_warn_segment_error(ret);
+	return ret < 0 ? ret : nilfs_warn_segment_error(nilfs->ns_sb, ret);
 }
diff -puN fs/nilfs2/segbuf.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/segbuf.c
--- a/fs/nilfs2/segbuf.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/segbuf.c
@@ -512,7 +512,11 @@ static int nilfs_segbuf_wait(struct nilf
 	} while (--segbuf->sb_nbio > 0);
 
 	if (unlikely(atomic_read(&segbuf->sb_err) > 0)) {
-		printk(KERN_ERR "NILFS: IO error writing segment\n");
+		nilfs_msg(segbuf->sb_super, KERN_ERR,
+			  "I/O error writing log (start-blocknr=%llu, block-count=%lu) in segment %llu",
+			  (unsigned long long)segbuf->sb_pseg_start,
+			  segbuf->sb_sum.nblocks,
+			  (unsigned long long)segbuf->sb_segnum);
 		err = -EIO;
 	}
 	return err;
diff -puN fs/nilfs2/segment.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/segment.c
@@ -150,7 +150,8 @@ static void nilfs_dispose_list(struct th
 #define nilfs_cnt32_lt(a, b)  nilfs_cnt32_gt(b, a)
 #define nilfs_cnt32_le(a, b)  nilfs_cnt32_ge(b, a)
 
-static int nilfs_prepare_segment_lock(struct nilfs_transaction_info *ti)
+static int nilfs_prepare_segment_lock(struct super_block *sb,
+				      struct nilfs_transaction_info *ti)
 {
 	struct nilfs_transaction_info *cur_ti = current->journal_info;
 	void *save = NULL;
@@ -164,8 +165,7 @@ static int nilfs_prepare_segment_lock(st
 		 * it is saved and will be restored on
 		 * nilfs_transaction_commit().
 		 */
-		printk(KERN_WARNING
-		       "NILFS warning: journal info from a different FS\n");
+		nilfs_msg(sb, KERN_WARNING, "journal info from a different FS");
 		save = current->journal_info;
 	}
 	if (!ti) {
@@ -215,7 +215,7 @@ int nilfs_transaction_begin(struct super
 			    int vacancy_check)
 {
 	struct the_nilfs *nilfs;
-	int ret = nilfs_prepare_segment_lock(ti);
+	int ret = nilfs_prepare_segment_lock(sb, ti);
 	struct nilfs_transaction_info *trace_ti;
 
 	if (unlikely(ret < 0))
@@ -2467,9 +2467,9 @@ int nilfs_clean_segments(struct super_bl
 		int ret = nilfs_discard_segments(nilfs, sci->sc_freesegs,
 						 sci->sc_nfreesegs);
 		if (ret) {
-			printk(KERN_WARNING
-			       "NILFS warning: error %d on discard request, "
-			       "turning discards off for the device\n", ret);
+			nilfs_msg(sb, KERN_WARNING,
+				  "error %d on discard request, turning discards off for the device",
+				  ret);
 			nilfs_clear_opt(nilfs, DISCARD);
 		}
 	}
@@ -2551,10 +2551,9 @@ static int nilfs_segctor_thread(void *ar
 	/* start sync. */
 	sci->sc_task = current;
 	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_start_thread() */
-	printk(KERN_INFO
-	       "segctord starting. Construction interval = %lu seconds, "
-	       "CP frequency < %lu seconds\n",
-	       sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
+	nilfs_msg(sci->sc_super, KERN_INFO,
+		  "segctord starting. Construction interval = %lu seconds, CP frequency < %lu seconds",
+		  sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
 
 	spin_lock(&sci->sc_state_lock);
  loop:
@@ -2628,8 +2627,8 @@ static int nilfs_segctor_start_thread(st
 	if (IS_ERR(t)) {
 		int err = PTR_ERR(t);
 
-		printk(KERN_ERR "NILFS: error %d creating segctord thread\n",
-		       err);
+		nilfs_msg(sci->sc_super, KERN_ERR,
+			  "error %d creating segctord thread", err);
 		return err;
 	}
 	wait_event(sci->sc_wait_task, sci->sc_task != NULL);
diff -puN fs/nilfs2/sufile.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/sufile.c
@@ -181,9 +181,9 @@ int nilfs_sufile_updatev(struct inode *s
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 	for (seg = segnumv; seg < segnumv + nsegs; seg++) {
 		if (unlikely(*seg >= nilfs_sufile_get_nsegments(sufile))) {
-			printk(KERN_WARNING
-			       "%s: invalid segment number: %llu\n", __func__,
-			       (unsigned long long)*seg);
+			nilfs_msg(sufile->i_sb, KERN_WARNING,
+				  "%s: invalid segment number: %llu",
+				  __func__, (unsigned long long)*seg);
 			nerr++;
 		}
 	}
@@ -240,8 +240,9 @@ int nilfs_sufile_update(struct inode *su
 	int ret;
 
 	if (unlikely(segnum >= nilfs_sufile_get_nsegments(sufile))) {
-		printk(KERN_WARNING "%s: invalid segment number: %llu\n",
-		       __func__, (unsigned long long)segnum);
+		nilfs_msg(sufile->i_sb, KERN_WARNING,
+			  "%s: invalid segment number: %llu",
+			  __func__, (unsigned long long)segnum);
 		return -EINVAL;
 	}
 	down_write(&NILFS_MDT(sufile)->mi_sem);
@@ -419,8 +420,9 @@ void nilfs_sufile_do_cancel_free(struct
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (unlikely(!nilfs_segment_usage_clean(su))) {
-		printk(KERN_WARNING "%s: segment %llu must be clean\n",
-		       __func__, (unsigned long long)segnum);
+		nilfs_msg(sufile->i_sb, KERN_WARNING,
+			  "%s: segment %llu must be clean", __func__,
+			  (unsigned long long)segnum);
 		kunmap_atomic(kaddr);
 		return;
 	}
@@ -476,8 +478,9 @@ void nilfs_sufile_do_free(struct inode *
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (nilfs_segment_usage_clean(su)) {
-		printk(KERN_WARNING "%s: segment %llu is already clean\n",
-		       __func__, (unsigned long long)segnum);
+		nilfs_msg(sufile->i_sb, KERN_WARNING,
+			  "%s: segment %llu is already clean",
+			  __func__, (unsigned long long)segnum);
 		kunmap_atomic(kaddr);
 		return;
 	}
@@ -1175,14 +1178,12 @@ int nilfs_sufile_read(struct super_block
 	int err;
 
 	if (susize > sb->s_blocksize) {
-		printk(KERN_ERR
-		       "NILFS: too large segment usage size: %zu bytes.\n",
-		       susize);
+		nilfs_msg(sb, KERN_ERR,
+			  "too large segment usage size: %zu bytes", susize);
 		return -EINVAL;
 	} else if (susize < NILFS_MIN_SEGMENT_USAGE_SIZE) {
-		printk(KERN_ERR
-		       "NILFS: too small segment usage size: %zu bytes.\n",
-		       susize);
+		nilfs_msg(sb, KERN_ERR,
+			  "too small segment usage size: %zu bytes", susize);
 		return -EINVAL;
 	}
 
diff -puN fs/nilfs2/super.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/super.c
@@ -214,8 +214,8 @@ static int nilfs_sync_super(struct super
 	}
 
 	if (unlikely(err)) {
-		printk(KERN_ERR
-		       "NILFS: unable to write superblock (err=%d)\n", err);
+		nilfs_msg(sb, KERN_ERR, "unable to write superblock: err=%d",
+			  err);
 		if (err == -EIO && nilfs->ns_sbh[1]) {
 			/*
 			 * sbp[0] points to newer log than sbp[1],
@@ -285,8 +285,7 @@ struct nilfs_super_block **nilfs_prepare
 		    sbp[1]->s_magic == cpu_to_le16(NILFS_SUPER_MAGIC)) {
 			memcpy(sbp[0], sbp[1], nilfs->ns_sbsize);
 		} else {
-			printk(KERN_CRIT "NILFS: superblock broke on dev %s\n",
-			       sb->s_id);
+			nilfs_msg(sb, KERN_CRIT, "superblock broke");
 			return NULL;
 		}
 	} else if (sbp[1] &&
@@ -396,9 +395,9 @@ static int nilfs_move_2nd_super(struct s
 	offset = sb2off & (nilfs->ns_blocksize - 1);
 	nsbh = sb_getblk(sb, newblocknr);
 	if (!nsbh) {
-		printk(KERN_WARNING
-		       "NILFS warning: unable to move secondary superblock "
-		       "to block %llu\n", (unsigned long long)newblocknr);
+		nilfs_msg(sb, KERN_WARNING,
+			  "unable to move secondary superblock to block %llu",
+			  (unsigned long long)newblocknr);
 		ret = -EIO;
 		goto out;
 	}
@@ -561,10 +560,9 @@ int nilfs_attach_checkpoint(struct super
 	up_read(&nilfs->ns_segctor_sem);
 	if (unlikely(err)) {
 		if (err == -ENOENT || err == -EINVAL) {
-			printk(KERN_ERR
-			       "NILFS: Invalid checkpoint "
-			       "(checkpoint number=%llu)\n",
-			       (unsigned long long)cno);
+			nilfs_msg(sb, KERN_ERR,
+				  "Invalid checkpoint (checkpoint number=%llu)",
+				  (unsigned long long)cno);
 			err = -EINVAL;
 		}
 		goto failed;
@@ -660,9 +658,8 @@ static int nilfs_statfs(struct dentry *d
 	err = nilfs_ifile_count_free_inodes(root->ifile,
 					    &nmaxinodes, &nfreeinodes);
 	if (unlikely(err)) {
-		printk(KERN_WARNING
-			"NILFS warning: fail to count free inodes: err %d.\n",
-			err);
+		nilfs_msg(sb, KERN_WARNING,
+			  "failed to count free inodes: err=%d", err);
 		if (err == -ERANGE) {
 			/*
 			 * If nilfs_palloc_count_max_entries() returns
@@ -794,9 +791,9 @@ static int parse_options(char *options,
 			break;
 		case Opt_snapshot:
 			if (is_remount) {
-				printk(KERN_ERR
-				       "NILFS: \"%s\" option is invalid "
-				       "for remount.\n", p);
+				nilfs_msg(sb, KERN_ERR,
+					  "\"%s\" option is invalid for remount",
+					  p);
 				return 0;
 			}
 			break;
@@ -810,8 +807,8 @@ static int parse_options(char *options,
 			nilfs_clear_opt(nilfs, DISCARD);
 			break;
 		default:
-			printk(KERN_ERR
-			       "NILFS: Unrecognized mount option \"%s\"\n", p);
+			nilfs_msg(sb, KERN_ERR,
+				  "unrecognized mount option \"%s\"", p);
 			return 0;
 		}
 	}
@@ -847,12 +844,10 @@ static int nilfs_setup_super(struct supe
 	mnt_count = le16_to_cpu(sbp[0]->s_mnt_count);
 
 	if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
-		printk(KERN_WARNING
-		       "NILFS warning: mounting fs with errors\n");
+		nilfs_msg(sb, KERN_WARNING, "mounting fs with errors");
 #if 0
 	} else if (max_mnt_count >= 0 && mnt_count >= max_mnt_count) {
-		printk(KERN_WARNING
-		       "NILFS warning: maximal mount count reached\n");
+		nilfs_msg(sb, KERN_WARNING, "maximal mount count reached");
 #endif
 	}
 	if (!max_mnt_count)
@@ -915,17 +910,17 @@ int nilfs_check_feature_compatibility(st
 	features = le64_to_cpu(sbp->s_feature_incompat) &
 		~NILFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
-		printk(KERN_ERR "NILFS: couldn't mount because of unsupported "
-		       "optional features (%llx)\n",
-		       (unsigned long long)features);
+		nilfs_msg(sb, KERN_ERR,
+			  "couldn't mount because of unsupported optional features (%llx)",
+			  (unsigned long long)features);
 		return -EINVAL;
 	}
 	features = le64_to_cpu(sbp->s_feature_compat_ro) &
 		~NILFS_FEATURE_COMPAT_RO_SUPP;
 	if (!(sb->s_flags & MS_RDONLY) && features) {
-		printk(KERN_ERR "NILFS: couldn't mount RDWR because of "
-		       "unsupported optional features (%llx)\n",
-		       (unsigned long long)features);
+		nilfs_msg(sb, KERN_ERR,
+			  "couldn't mount RDWR because of unsupported optional features (%llx)",
+			  (unsigned long long)features);
 		return -EINVAL;
 	}
 	return 0;
@@ -941,13 +936,13 @@ static int nilfs_get_root_dentry(struct
 
 	inode = nilfs_iget(sb, root, NILFS_ROOT_INO);
 	if (IS_ERR(inode)) {
-		printk(KERN_ERR "NILFS: get root inode failed\n");
 		ret = PTR_ERR(inode);
+		nilfs_msg(sb, KERN_ERR, "error %d getting root inode", ret);
 		goto out;
 	}
 	if (!S_ISDIR(inode->i_mode) || !inode->i_blocks || !inode->i_size) {
 		iput(inode);
-		printk(KERN_ERR "NILFS: corrupt root inode.\n");
+		nilfs_msg(sb, KERN_ERR, "corrupt root inode");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -975,7 +970,7 @@ static int nilfs_get_root_dentry(struct
 	return ret;
 
  failed_dentry:
-	printk(KERN_ERR "NILFS: get root dentry failed\n");
+	nilfs_msg(sb, KERN_ERR, "error %d getting root dentry", ret);
 	goto out;
 }
 
@@ -995,18 +990,18 @@ static int nilfs_attach_snapshot(struct
 		ret = (ret == -ENOENT) ? -EINVAL : ret;
 		goto out;
 	} else if (!ret) {
-		printk(KERN_ERR "NILFS: The specified checkpoint is "
-		       "not a snapshot (checkpoint number=%llu).\n",
-		       (unsigned long long)cno);
+		nilfs_msg(s, KERN_ERR,
+			  "The specified checkpoint is not a snapshot (checkpoint number=%llu)",
+			  (unsigned long long)cno);
 		ret = -EINVAL;
 		goto out;
 	}
 
 	ret = nilfs_attach_checkpoint(s, cno, false, &root);
 	if (ret) {
-		printk(KERN_ERR "NILFS: error loading snapshot "
-		       "(checkpoint number=%llu).\n",
-	       (unsigned long long)cno);
+		nilfs_msg(s, KERN_ERR,
+			  "error %d while loading snapshot (checkpoint number=%llu)",
+			  ret, (unsigned long long)cno);
 		goto out;
 	}
 	ret = nilfs_get_root_dentry(s, root, root_dentry);
@@ -1101,8 +1096,9 @@ nilfs_fill_super(struct super_block *sb,
 	cno = nilfs_last_cno(nilfs);
 	err = nilfs_attach_checkpoint(sb, cno, true, &fsroot);
 	if (err) {
-		printk(KERN_ERR "NILFS: error loading last checkpoint "
-		       "(checkpoint number=%llu).\n", (unsigned long long)cno);
+		nilfs_msg(sb, KERN_ERR,
+			  "error %d while loading last checkpoint (checkpoint number=%llu)",
+			  err, (unsigned long long)cno);
 		goto failed_unload;
 	}
 
@@ -1162,9 +1158,8 @@ static int nilfs_remount(struct super_bl
 	err = -EINVAL;
 
 	if (!nilfs_valid_fs(nilfs)) {
-		printk(KERN_WARNING "NILFS (device %s): couldn't "
-		       "remount because the filesystem is in an "
-		       "incomplete recovery state.\n", sb->s_id);
+		nilfs_msg(sb, KERN_WARNING,
+			  "couldn't remount because the filesystem is in an incomplete recovery state");
 		goto restore_opts;
 	}
 
@@ -1196,10 +1191,9 @@ static int nilfs_remount(struct super_bl
 			~NILFS_FEATURE_COMPAT_RO_SUPP;
 		up_read(&nilfs->ns_sem);
 		if (features) {
-			printk(KERN_WARNING "NILFS (device %s): couldn't "
-			       "remount RDWR because of unsupported optional "
-			       "features (%llx)\n",
-			       sb->s_id, (unsigned long long)features);
+			nilfs_msg(sb, KERN_WARNING,
+				  "couldn't remount RDWR because of unsupported optional features (%llx)",
+				  (unsigned long long)features);
 			err = -EROFS;
 			goto restore_opts;
 		}
@@ -1262,8 +1256,8 @@ static int nilfs_identify(char *data, st
 				}
 			}
 			if (ret)
-				printk(KERN_ERR
-				       "NILFS: invalid mount option: %s\n", p);
+				nilfs_msg(NULL, KERN_ERR,
+					  "invalid mount option: %s", p);
 		}
 		if (!options)
 			break;
@@ -1344,10 +1338,10 @@ nilfs_mount(struct file_system_type *fs_
 	} else if (!sd.cno) {
 		if (nilfs_tree_is_busy(s->s_root)) {
 			if ((flags ^ s->s_flags) & MS_RDONLY) {
-				printk(KERN_ERR "NILFS: the device already "
-				       "has a %s mount.\n",
-				       (s->s_flags & MS_RDONLY) ?
-				       "read-only" : "read/write");
+				nilfs_msg(s, KERN_ERR,
+					  "the device already has a %s mount.",
+					  (s->s_flags & MS_RDONLY) ?
+					  "read-only" : "read/write");
 				err = -EBUSY;
 				goto failed_super;
 			}
diff -puN fs/nilfs2/sysfs.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/sysfs.c
@@ -272,8 +272,8 @@ nilfs_checkpoints_checkpoints_number_sho
 	err = nilfs_cpfile_get_stat(nilfs->ns_cpfile, &cpstat);
 	up_read(&nilfs->ns_segctor_sem);
 	if (err < 0) {
-		printk(KERN_ERR "NILFS: unable to get checkpoint stat: err=%d\n",
-			err);
+		nilfs_msg(nilfs->ns_sb, KERN_ERR,
+			  "unable to get checkpoint stat: err=%d", err);
 		return err;
 	}
 
@@ -295,8 +295,8 @@ nilfs_checkpoints_snapshots_number_show(
 	err = nilfs_cpfile_get_stat(nilfs->ns_cpfile, &cpstat);
 	up_read(&nilfs->ns_segctor_sem);
 	if (err < 0) {
-		printk(KERN_ERR "NILFS: unable to get checkpoint stat: err=%d\n",
-			err);
+		nilfs_msg(nilfs->ns_sb, KERN_ERR,
+			  "unable to get checkpoint stat: err=%d", err);
 		return err;
 	}
 
@@ -414,8 +414,8 @@ nilfs_segments_dirty_segments_show(struc
 	err = nilfs_sufile_get_stat(nilfs->ns_sufile, &sustat);
 	up_read(&nilfs->ns_segctor_sem);
 	if (err < 0) {
-		printk(KERN_ERR "NILFS: unable to get segment stat: err=%d\n",
-			err);
+		nilfs_msg(nilfs->ns_sb, KERN_ERR,
+			  "unable to get segment stat: err=%d", err);
 		return err;
 	}
 
@@ -789,14 +789,15 @@ nilfs_superblock_sb_update_frequency_sto
 
 	err = kstrtouint(skip_spaces(buf), 0, &val);
 	if (err) {
-		printk(KERN_ERR "NILFS: unable to convert string: err=%d\n",
-			err);
+		nilfs_msg(nilfs->ns_sb, KERN_ERR,
+			  "unable to convert string: err=%d", err);
 		return err;
 	}
 
 	if (val < NILFS_SB_FREQ) {
 		val = NILFS_SB_FREQ;
-		printk(KERN_WARNING "NILFS: superblock update frequency cannot be lesser than 10 seconds\n");
+		nilfs_msg(nilfs->ns_sb, KERN_WARNING,
+			  "superblock update frequency cannot be lesser than 10 seconds");
 	}
 
 	down_write(&nilfs->ns_sem);
@@ -999,7 +1000,8 @@ int nilfs_sysfs_create_device_group(stru
 	nilfs->ns_dev_subgroups = kzalloc(devgrp_size, GFP_KERNEL);
 	if (unlikely(!nilfs->ns_dev_subgroups)) {
 		err = -ENOMEM;
-		printk(KERN_ERR "NILFS: unable to allocate memory for device group\n");
+		nilfs_msg(sb, KERN_ERR,
+			  "unable to allocate memory for device group");
 		goto failed_create_device_group;
 	}
 
@@ -1109,15 +1111,15 @@ int __init nilfs_sysfs_init(void)
 	nilfs_kset = kset_create_and_add(NILFS_ROOT_GROUP_NAME, NULL, fs_kobj);
 	if (!nilfs_kset) {
 		err = -ENOMEM;
-		printk(KERN_ERR "NILFS: unable to create sysfs entry: err %d\n",
-			err);
+		nilfs_msg(NULL, KERN_ERR,
+			  "unable to create sysfs entry: err=%d", err);
 		goto failed_sysfs_init;
 	}
 
 	err = sysfs_create_group(&nilfs_kset->kobj, &nilfs_feature_attr_group);
 	if (unlikely(err)) {
-		printk(KERN_ERR "NILFS: unable to create feature group: err %d\n",
-			err);
+		nilfs_msg(NULL, KERN_ERR,
+			  "unable to create feature group: err=%d", err);
 		goto cleanup_sysfs_init;
 	}
 
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-reduce-bare-use-of-printk-with-nilfs_msg
+++ a/fs/nilfs2/the_nilfs.c
@@ -192,7 +192,10 @@ static int nilfs_store_log_cursor(struct
 		nilfs_get_segnum_of_block(nilfs, nilfs->ns_last_pseg);
 	nilfs->ns_cno = nilfs->ns_last_cno + 1;
 	if (nilfs->ns_segnum >= nilfs->ns_nsegments) {
-		printk(KERN_ERR "NILFS invalid last segment number.\n");
+		nilfs_msg(nilfs->ns_sb, KERN_ERR,
+			  "pointed segment number is out of range: segnum=%llu, nsegments=%lu",
+			  (unsigned long long)nilfs->ns_segnum,
+			  nilfs->ns_nsegments);
 		ret = -EINVAL;
 	}
 	return ret;
@@ -216,12 +219,12 @@ int load_nilfs(struct the_nilfs *nilfs,
 	int err;
 
 	if (!valid_fs) {
-		printk(KERN_WARNING "NILFS warning: mounting unchecked fs\n");
+		nilfs_msg(sb, KERN_WARNING, "mounting unchecked fs");
 		if (s_flags & MS_RDONLY) {
-			printk(KERN_INFO "NILFS: INFO: recovery "
-			       "required for readonly filesystem.\n");
-			printk(KERN_INFO "NILFS: write access will "
-			       "be enabled during recovery.\n");
+			nilfs_msg(sb, KERN_INFO,
+				  "recovery required for readonly filesystem");
+			nilfs_msg(sb, KERN_INFO,
+				  "write access will be enabled during recovery");
 		}
 	}
 
@@ -236,13 +239,12 @@ int load_nilfs(struct the_nilfs *nilfs,
 			goto scan_error;
 
 		if (!nilfs_valid_sb(sbp[1])) {
-			printk(KERN_WARNING
-			       "NILFS warning: unable to fall back to spare"
-			       "super block\n");
+			nilfs_msg(sb, KERN_WARNING,
+				  "unable to fall back to spare super block");
 			goto scan_error;
 		}
-		printk(KERN_INFO
-		       "NILFS: try rollback from an earlier position\n");
+		nilfs_msg(sb, KERN_INFO,
+			  "trying rollback from an earlier position");
 
 		/*
 		 * restore super block with its spare and reconfigure
@@ -255,10 +257,9 @@ int load_nilfs(struct the_nilfs *nilfs,
 		/* verify consistency between two super blocks */
 		blocksize = BLOCK_SIZE << le32_to_cpu(sbp[0]->s_log_block_size);
 		if (blocksize != nilfs->ns_blocksize) {
-			printk(KERN_WARNING
-			       "NILFS warning: blocksize differs between "
-			       "two super blocks (%d != %d)\n",
-			       blocksize, nilfs->ns_blocksize);
+			nilfs_msg(sb, KERN_WARNING,
+				  "blocksize differs between two super blocks (%d != %d)",
+				  blocksize, nilfs->ns_blocksize);
 			goto scan_error;
 		}
 
@@ -277,7 +278,8 @@ int load_nilfs(struct the_nilfs *nilfs,
 
 	err = nilfs_load_super_root(nilfs, sb, ri.ri_super_root);
 	if (unlikely(err)) {
-		printk(KERN_ERR "NILFS: error loading super root.\n");
+		nilfs_msg(sb, KERN_ERR, "error %d while loading super root",
+			  err);
 		goto failed;
 	}
 
@@ -288,30 +290,29 @@ int load_nilfs(struct the_nilfs *nilfs,
 		__u64 features;
 
 		if (nilfs_test_opt(nilfs, NORECOVERY)) {
-			printk(KERN_INFO "NILFS: norecovery option specified. "
-			       "skipping roll-forward recovery\n");
+			nilfs_msg(sb, KERN_INFO,
+				  "norecovery option specified, skipping roll-forward recovery");
 			goto skip_recovery;
 		}
 		features = le64_to_cpu(nilfs->ns_sbp[0]->s_feature_compat_ro) &
 			~NILFS_FEATURE_COMPAT_RO_SUPP;
 		if (features) {
-			printk(KERN_ERR "NILFS: couldn't proceed with "
-			       "recovery because of unsupported optional "
-			       "features (%llx)\n",
-			       (unsigned long long)features);
+			nilfs_msg(sb, KERN_ERR,
+				  "couldn't proceed with recovery because of unsupported optional features (%llx)",
+				  (unsigned long long)features);
 			err = -EROFS;
 			goto failed_unload;
 		}
 		if (really_read_only) {
-			printk(KERN_ERR "NILFS: write access "
-			       "unavailable, cannot proceed.\n");
+			nilfs_msg(sb, KERN_ERR,
+				  "write access unavailable, cannot proceed");
 			err = -EROFS;
 			goto failed_unload;
 		}
 		sb->s_flags &= ~MS_RDONLY;
 	} else if (nilfs_test_opt(nilfs, NORECOVERY)) {
-		printk(KERN_ERR "NILFS: recovery cancelled because norecovery "
-		       "option was specified for a read/write mount\n");
+		nilfs_msg(sb, KERN_ERR,
+			  "recovery cancelled because norecovery option was specified for a read/write mount");
 		err = -EINVAL;
 		goto failed_unload;
 	}
@@ -326,11 +327,12 @@ int load_nilfs(struct the_nilfs *nilfs,
 	up_write(&nilfs->ns_sem);
 
 	if (err) {
-		printk(KERN_ERR "NILFS: failed to update super block. "
-		       "recovery unfinished.\n");
+		nilfs_msg(sb, KERN_ERR,
+			  "error %d updating super block. recovery unfinished.",
+			  err);
 		goto failed_unload;
 	}
-	printk(KERN_INFO "NILFS: recovery complete.\n");
+	nilfs_msg(sb, KERN_INFO, "recovery complete");
 
  skip_recovery:
 	nilfs_clear_recovery_info(&ri);
@@ -338,7 +340,7 @@ int load_nilfs(struct the_nilfs *nilfs,
 	return 0;
 
  scan_error:
-	printk(KERN_ERR "NILFS: error searching super root.\n");
+	nilfs_msg(sb, KERN_ERR, "error %d while searching super root", err);
 	goto failed;
 
  failed_unload:
@@ -385,12 +387,11 @@ static int nilfs_store_disk_layout(struc
 				   struct nilfs_super_block *sbp)
 {
 	if (le32_to_cpu(sbp->s_rev_level) < NILFS_MIN_SUPP_REV) {
-		printk(KERN_ERR "NILFS: unsupported revision "
-		       "(superblock rev.=%d.%d, current rev.=%d.%d). "
-		       "Please check the version of mkfs.nilfs.\n",
-		       le32_to_cpu(sbp->s_rev_level),
-		       le16_to_cpu(sbp->s_minor_rev_level),
-		       NILFS_CURRENT_REV, NILFS_MINOR_REV);
+		nilfs_msg(nilfs->ns_sb, KERN_ERR,
+			  "unsupported revision (superblock rev.=%d.%d, current rev.=%d.%d). Please check the version of mkfs.nilfs(2).",
+			  le32_to_cpu(sbp->s_rev_level),
+			  le16_to_cpu(sbp->s_minor_rev_level),
+			  NILFS_CURRENT_REV, NILFS_MINOR_REV);
 		return -EINVAL;
 	}
 	nilfs->ns_sbsize = le16_to_cpu(sbp->s_bytes);
@@ -399,12 +400,14 @@ static int nilfs_store_disk_layout(struc
 
 	nilfs->ns_inode_size = le16_to_cpu(sbp->s_inode_size);
 	if (nilfs->ns_inode_size > nilfs->ns_blocksize) {
-		printk(KERN_ERR "NILFS: too large inode size: %d bytes.\n",
-		       nilfs->ns_inode_size);
+		nilfs_msg(nilfs->ns_sb, KERN_ERR,
+			  "too large inode size: %d bytes",
+			  nilfs->ns_inode_size);
 		return -EINVAL;
 	} else if (nilfs->ns_inode_size < NILFS_MIN_INODE_SIZE) {
-		printk(KERN_ERR "NILFS: too small inode size: %d bytes.\n",
-		       nilfs->ns_inode_size);
+		nilfs_msg(nilfs->ns_sb, KERN_ERR,
+			  "too small inode size: %d bytes",
+			  nilfs->ns_inode_size);
 		return -EINVAL;
 	}
 
@@ -412,7 +415,9 @@ static int nilfs_store_disk_layout(struc
 
 	nilfs->ns_blocks_per_segment = le32_to_cpu(sbp->s_blocks_per_segment);
 	if (nilfs->ns_blocks_per_segment < NILFS_SEG_MIN_BLOCKS) {
-		printk(KERN_ERR "NILFS: too short segment.\n");
+		nilfs_msg(nilfs->ns_sb, KERN_ERR,
+			  "too short segment: %lu blocks",
+			  nilfs->ns_blocks_per_segment);
 		return -EINVAL;
 	}
 
@@ -421,7 +426,9 @@ static int nilfs_store_disk_layout(struc
 		le32_to_cpu(sbp->s_r_segments_percentage);
 	if (nilfs->ns_r_segments_percentage < 1 ||
 	    nilfs->ns_r_segments_percentage > 99) {
-		printk(KERN_ERR "NILFS: invalid reserved segments percentage.\n");
+		nilfs_msg(nilfs->ns_sb, KERN_ERR,
+			  "invalid reserved segments percentage: %lu",
+			  nilfs->ns_r_segments_percentage);
 		return -EINVAL;
 	}
 
@@ -505,16 +512,16 @@ static int nilfs_load_super_block(struct
 
 	if (!sbp[0]) {
 		if (!sbp[1]) {
-			printk(KERN_ERR "NILFS: unable to read superblock\n");
+			nilfs_msg(sb, KERN_ERR, "unable to read superblock");
 			return -EIO;
 		}
-		printk(KERN_WARNING
-		       "NILFS warning: unable to read primary superblock "
-		       "(blocksize = %d)\n", blocksize);
+		nilfs_msg(sb, KERN_WARNING,
+			  "unable to read primary superblock (blocksize = %d)",
+			  blocksize);
 	} else if (!sbp[1]) {
-		printk(KERN_WARNING
-		       "NILFS warning: unable to read secondary superblock "
-		       "(blocksize = %d)\n", blocksize);
+		nilfs_msg(sb, KERN_WARNING,
+			  "unable to read secondary superblock (blocksize = %d)",
+			  blocksize);
 	}
 
 	/*
@@ -536,14 +543,14 @@ static int nilfs_load_super_block(struct
 	}
 	if (!valid[swp]) {
 		nilfs_release_super_block(nilfs);
-		printk(KERN_ERR "NILFS: Can't find nilfs on dev %s.\n",
-		       sb->s_id);
+		nilfs_msg(sb, KERN_ERR, "couldn't find nilfs on the device");
 		return -EINVAL;
 	}
 
 	if (!valid[!swp])
-		printk(KERN_WARNING "NILFS warning: broken superblock. "
-		       "using spare superblock (blocksize = %d).\n", blocksize);
+		nilfs_msg(sb, KERN_WARNING,
+			  "broken superblock, retrying with spare superblock (blocksize = %d)",
+			  blocksize);
 	if (swp)
 		nilfs_swap_super_block(nilfs);
 
@@ -577,7 +584,7 @@ int init_nilfs(struct the_nilfs *nilfs,
 
 	blocksize = sb_min_blocksize(sb, NILFS_MIN_BLOCK_SIZE);
 	if (!blocksize) {
-		printk(KERN_ERR "NILFS: unable to set blocksize\n");
+		nilfs_msg(sb, KERN_ERR, "unable to set blocksize");
 		err = -EINVAL;
 		goto out;
 	}
@@ -596,8 +603,9 @@ int init_nilfs(struct the_nilfs *nilfs,
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
 	if (blocksize < NILFS_MIN_BLOCK_SIZE ||
 	    blocksize > NILFS_MAX_BLOCK_SIZE) {
-		printk(KERN_ERR "NILFS: couldn't mount because of unsupported "
-		       "filesystem blocksize %d\n", blocksize);
+		nilfs_msg(sb, KERN_ERR,
+			  "couldn't mount because of unsupported filesystem blocksize %d",
+			  blocksize);
 		err = -EINVAL;
 		goto failed_sbh;
 	}
@@ -605,10 +613,9 @@ int init_nilfs(struct the_nilfs *nilfs,
 		int hw_blocksize = bdev_logical_block_size(sb->s_bdev);
 
 		if (blocksize < hw_blocksize) {
-			printk(KERN_ERR
-			       "NILFS: blocksize %d too small for device "
-			       "(sector-size = %d).\n",
-			       blocksize, hw_blocksize);
+			nilfs_msg(sb, KERN_ERR,
+				  "blocksize %d too small for device (sector-size = %d)",
+				  blocksize, hw_blocksize);
 			err = -EINVAL;
 			goto failed_sbh;
 		}
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-hide-function-name-argument-from-nilfs_error.patch
nilfs2-add-nilfs_msg-message-interface.patch
nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object.patch
nilfs2-reduce-bare-use-of-printk-with-nilfs_msg.patch
nilfs2-replace-nilfs_warning-with-nilfs_msg.patch
nilfs2-emit-error-message-when-i-o-error-is-detected.patch
nilfs2-do-not-use-yield.patch
nilfs2-refactor-parser-of-snapshot-mount-option.patch

