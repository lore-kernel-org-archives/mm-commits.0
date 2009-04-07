From: akpm@linux-foundation.org
Subject: [merged] nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:41 -0700
Message-ID: <200904071909.n37J9fQi012471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760327AbZDGTMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     nilfs2: replace BUG_ON and BUG calls triggerable from ioctl
has been removed from the -mm tree.  Its filename was
     nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: replace BUG_ON and BUG calls triggerable from ioctl
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Pekka Enberg advised me:
> It would be nice if BUG(), BUG_ON(), and panic() calls would be
> converted to proper error handling using WARN_ON() calls. The BUG()
> call in nilfs_cpfile_delete_checkpoints(), for example, looks to be
> triggerable from user-space via the ioctl() system call.

This will follow the comment and keep them to a minimum.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c    |   27 +++++---------
 fs/nilfs2/cpfile.c   |   38 +++++++++++--------
 fs/nilfs2/dat.c      |   15 ++++---
 fs/nilfs2/direct.c   |   13 +++++-
 fs/nilfs2/inode.c    |   19 ++-------
 fs/nilfs2/ioctl.c    |   63 ++++++++++++++++++++++-----------
 fs/nilfs2/mdt.c      |    4 --
 fs/nilfs2/nilfs.h    |    1 
 fs/nilfs2/page.c     |   10 ++---
 fs/nilfs2/recovery.c |    3 -
 fs/nilfs2/segment.c  |   78 ++++++++++++-----------------------------
 fs/nilfs2/sufile.c   |   25 +++++++------
 fs/nilfs2/super.c    |    8 ++--
 13 files changed, 144 insertions(+), 160 deletions(-)

diff -puN fs/nilfs2/btree.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/btree.c
@@ -425,7 +425,6 @@ static int nilfs_btree_node_lookup(const
 		index++;
 
  out:
-	BUG_ON(indexp == NULL);
 	*indexp = index;
 
 	return s == 0;
@@ -477,8 +476,6 @@ static int nilfs_btree_do_lookup(const s
 	__u64 ptr;
 	int level, index, found, ret;
 
-	BUG_ON(minlevel <= NILFS_BTREE_LEVEL_DATA);
-
 	node = nilfs_btree_get_root(btree);
 	level = nilfs_btree_node_get_level(btree, node);
 	if ((level < minlevel) ||
@@ -505,7 +502,7 @@ static int nilfs_btree_do_lookup(const s
 		if (index < nilfs_btree_node_nchildren_max(btree, node))
 			ptr = nilfs_btree_node_get_ptr(btree, node, index);
 		else {
-			BUG_ON(found || level != NILFS_BTREE_LEVEL_NODE_MIN);
+			WARN_ON(found || level != NILFS_BTREE_LEVEL_NODE_MIN);
 			/* insert */
 			ptr = NILFS_BMAP_INVALID_PTR;
 		}
@@ -1366,7 +1363,7 @@ static int nilfs_btree_prepare_delete(st
 		} else {
 			/* no siblings */
 			/* the only child of the root node */
-			BUG_ON(level != nilfs_btree_height(btree) - 2);
+			WARN_ON(level != nilfs_btree_height(btree) - 2);
 			if (nilfs_btree_node_get_nchildren(btree, node) - 1 <=
 			    NILFS_BTREE_ROOT_NCHILDREN_MAX) {
 				path[level].bp_op = nilfs_btree_shrink;
@@ -1543,7 +1540,7 @@ static int nilfs_btree_gather_data(struc
 		break;
 	case 3:
 		nchildren = nilfs_btree_node_get_nchildren(btree, root);
-		BUG_ON(nchildren > 1);
+		WARN_ON(nchildren > 1);
 		ptr = nilfs_btree_node_get_ptr(btree, root, nchildren - 1);
 		ret = nilfs_bmap_get_block(bmap, ptr, &bh);
 		if (ret < 0)
@@ -1552,7 +1549,7 @@ static int nilfs_btree_gather_data(struc
 		break;
 	default:
 		node = NULL;
-		BUG();
+		return -EINVAL;
 	}
 
 	nchildren = nilfs_btree_node_get_nchildren(btree, node);
@@ -1833,14 +1830,13 @@ static int nilfs_btree_prepare_propagate
 	while ((++level < nilfs_btree_height(btree) - 1) &&
 	       !buffer_dirty(path[level].bp_bh)) {
 
-		BUG_ON(buffer_nilfs_volatile(path[level].bp_bh));
+		WARN_ON(buffer_nilfs_volatile(path[level].bp_bh));
 		ret = nilfs_btree_prepare_update_v(btree, path, level);
 		if (ret < 0)
 			goto out;
 	}
 
 	/* success */
-	BUG_ON(maxlevelp == NULL);
 	*maxlevelp = level - 1;
 	return 0;
 
@@ -1909,7 +1905,7 @@ static int nilfs_btree_propagate(const s
 	__u64 key;
 	int level, ret;
 
-	BUG_ON(!buffer_dirty(bh));
+	WARN_ON(!buffer_dirty(bh));
 
 	btree = (struct nilfs_btree *)bmap;
 	path = nilfs_btree_alloc_path(btree);
@@ -1928,12 +1924,9 @@ static int nilfs_btree_propagate(const s
 
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1);
 	if (ret < 0) {
-		/* BUG_ON(ret == -ENOENT); */
-		if (ret == -ENOENT) {
+		if (unlikely(ret == -ENOENT))
 			printk(KERN_CRIT "%s: key = %llu, level == %d\n",
 			       __func__, (unsigned long long)key, level);
-			BUG();
-		}
 		goto out;
 	}
 
@@ -2117,7 +2110,7 @@ static int nilfs_btree_assign(struct nil
 
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1);
 	if (ret < 0) {
-		BUG_ON(ret == -ENOENT);
+		WARN_ON(ret == -ENOENT);
 		goto out;
 	}
 
@@ -2175,12 +2168,12 @@ static int nilfs_btree_mark(struct nilfs
 
 	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level + 1);
 	if (ret < 0) {
-		BUG_ON(ret == -ENOENT);
+		WARN_ON(ret == -ENOENT);
 		goto out;
 	}
 	ret = nilfs_bmap_get_block(&btree->bt_bmap, ptr, &bh);
 	if (ret < 0) {
-		BUG_ON(ret == -ENOENT);
+		WARN_ON(ret == -ENOENT);
 		goto out;
 	}
 
diff -puN fs/nilfs2/cpfile.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/cpfile.c
@@ -40,10 +40,7 @@ nilfs_cpfile_checkpoints_per_block(const
 static unsigned long
 nilfs_cpfile_get_blkoff(const struct inode *cpfile, __u64 cno)
 {
-	__u64 tcno;
-
-	BUG_ON(cno == 0); /* checkpoint number 0 is invalid */
-	tcno = cno + NILFS_MDT(cpfile)->mi_first_entry_offset - 1;
+	__u64 tcno = cno + NILFS_MDT(cpfile)->mi_first_entry_offset - 1;
 	do_div(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
 	return (unsigned long)tcno;
 }
@@ -96,7 +93,7 @@ nilfs_cpfile_block_sub_valid_checkpoints
 	struct nilfs_checkpoint *cp = kaddr + bh_offset(bh);
 	unsigned int count;
 
-	BUG_ON(le32_to_cpu(cp->cp_checkpoints_count) < n);
+	WARN_ON(le32_to_cpu(cp->cp_checkpoints_count) < n);
 	count = le32_to_cpu(cp->cp_checkpoints_count) - n;
 	cp->cp_checkpoints_count = cpu_to_le32(count);
 	return count;
@@ -178,6 +175,8 @@ static inline int nilfs_cpfile_delete_ch
  * %-ENOMEM - Insufficient amount of memory available.
  *
  * %-ENOENT - No such checkpoint.
+ *
+ * %-EINVAL - invalid checkpoint.
  */
 int nilfs_cpfile_get_checkpoint(struct inode *cpfile,
 				__u64 cno,
@@ -191,8 +190,9 @@ int nilfs_cpfile_get_checkpoint(struct i
 	void *kaddr;
 	int ret;
 
-	BUG_ON(cno < 1 || cno > nilfs_mdt_cno(cpfile) ||
-	       (cno < nilfs_mdt_cno(cpfile) && create));
+	if (unlikely(cno < 1 || cno > nilfs_mdt_cno(cpfile) ||
+		     (cno < nilfs_mdt_cno(cpfile) && create)))
+		return -EINVAL;
 
 	down_write(&NILFS_MDT(cpfile)->mi_sem);
 
@@ -288,12 +288,11 @@ int nilfs_cpfile_delete_checkpoints(stru
 	unsigned long tnicps;
 	int ret, ncps, nicps, count, i;
 
-	if ((start == 0) || (start > end)) {
-		printk(KERN_CRIT "%s: start = %llu, end = %llu\n",
-		       __func__,
-		       (unsigned long long)start,
-		       (unsigned long long)end);
-		BUG();
+	if (unlikely(start == 0 || start > end)) {
+		printk(KERN_ERR "%s: invalid range of checkpoint numbers: "
+		       "[%llu, %llu)\n", __func__,
+		       (unsigned long long)start, (unsigned long long)end);
+		return -EINVAL;
 	}
 
 	/* cannot delete the latest checkpoint */
@@ -323,7 +322,7 @@ int nilfs_cpfile_delete_checkpoints(stru
 			cpfile, cno, cp_bh, kaddr);
 		nicps = 0;
 		for (i = 0; i < ncps; i++, cp = (void *)cp + cpsz) {
-			BUG_ON(nilfs_checkpoint_snapshot(cp));
+			WARN_ON(nilfs_checkpoint_snapshot(cp));
 			if (!nilfs_checkpoint_invalid(cp)) {
 				nilfs_checkpoint_set_invalid(cp);
 				nicps++;
@@ -393,6 +392,8 @@ static ssize_t nilfs_cpfile_do_get_cpinf
 	int n, ret;
 	int ncps, i;
 
+	if (cno == 0)
+		return -ENOENT; /* checkpoint number 0 is invalid */
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
 	for (n = 0; cno < cur_cno && n < nci; cno += ncps) {
@@ -532,9 +533,6 @@ int nilfs_cpfile_delete_checkpoint(struc
 	ssize_t nci;
 	int ret;
 
-	/* checkpoint number 0 is invalid */
-	if (cno == 0)
-		return -ENOENT;
 	nci = nilfs_cpfile_do_get_cpinfo(cpfile, &tcno, &ci, 1);
 	if (nci < 0)
 		return nci;
@@ -582,6 +580,8 @@ static int nilfs_cpfile_set_snapshot(str
 	void *kaddr;
 	int ret;
 
+	if (cno == 0)
+		return -ENOENT; /* checkpoint number 0 is invalid */
 	down_write(&NILFS_MDT(cpfile)->mi_sem);
 
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
@@ -698,6 +698,8 @@ static int nilfs_cpfile_clear_snapshot(s
 	void *kaddr;
 	int ret;
 
+	if (cno == 0)
+		return -ENOENT; /* checkpoint number 0 is invalid */
 	down_write(&NILFS_MDT(cpfile)->mi_sem);
 
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
@@ -813,6 +815,8 @@ int nilfs_cpfile_is_snapshot(struct inod
 	void *kaddr;
 	int ret;
 
+	if (cno == 0)
+		return -ENOENT; /* checkpoint number 0 is invalid */
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &bh);
diff -puN fs/nilfs2/dat.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/dat.c
--- a/fs/nilfs2/dat.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/dat.c
@@ -135,7 +135,7 @@ int nilfs_dat_prepare_start(struct inode
 	int ret;
 
 	ret = nilfs_dat_prepare_entry(dat, req, 0);
-	BUG_ON(ret == -ENOENT);
+	WARN_ON(ret == -ENOENT);
 	return ret;
 }
 
@@ -157,7 +157,6 @@ void nilfs_dat_commit_start(struct inode
 		       (unsigned long long)le64_to_cpu(entry->de_start),
 		       (unsigned long long)le64_to_cpu(entry->de_end),
 		       (unsigned long long)le64_to_cpu(entry->de_blocknr));
-		BUG();
 	}
 	entry->de_blocknr = cpu_to_le64(blocknr);
 	kunmap_atomic(kaddr, KM_USER0);
@@ -180,7 +179,7 @@ int nilfs_dat_prepare_end(struct inode *
 
 	ret = nilfs_dat_prepare_entry(dat, req, 0);
 	if (ret < 0) {
-		BUG_ON(ret == -ENOENT);
+		WARN_ON(ret == -ENOENT);
 		return ret;
 	}
 
@@ -216,7 +215,7 @@ void nilfs_dat_commit_end(struct inode *
 	end = start = le64_to_cpu(entry->de_start);
 	if (!dead) {
 		end = nilfs_mdt_cno(dat);
-		BUG_ON(start > end);
+		WARN_ON(start > end);
 	}
 	entry->de_end = cpu_to_le64(end);
 	blocknr = le64_to_cpu(entry->de_blocknr);
@@ -324,14 +323,16 @@ int nilfs_dat_move(struct inode *dat, __
 		return ret;
 	kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
-	if (entry->de_blocknr == cpu_to_le64(0)) {
+	if (unlikely(entry->de_blocknr == cpu_to_le64(0))) {
 		printk(KERN_CRIT "%s: vbn = %llu, [%llu, %llu)\n", __func__,
 		       (unsigned long long)vblocknr,
 		       (unsigned long long)le64_to_cpu(entry->de_start),
 		       (unsigned long long)le64_to_cpu(entry->de_end));
-		BUG();
+		kunmap_atomic(kaddr, KM_USER0);
+		brelse(entry_bh);
+		return -EINVAL;
 	}
-	BUG_ON(blocknr == 0);
+	WARN_ON(blocknr == 0);
 	entry->de_blocknr = cpu_to_le64(blocknr);
 	kunmap_atomic(kaddr, KM_USER0);
 
diff -puN fs/nilfs2/direct.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/direct.c
--- a/fs/nilfs2/direct.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/direct.c
@@ -210,7 +210,6 @@ static int nilfs_direct_last_key(const s
 	if (lastkey == NILFS_DIRECT_KEY_MAX + 1)
 		return -ENOENT;
 
-	BUG_ON(keyp == NULL);
 	*keyp = lastkey;
 
 	return 0;
@@ -366,9 +365,17 @@ static int nilfs_direct_assign(struct ni
 
 	direct = (struct nilfs_direct *)bmap;
 	key = nilfs_bmap_data_get_key(bmap, *bh);
-	BUG_ON(key > NILFS_DIRECT_KEY_MAX);
+	if (unlikely(key > NILFS_DIRECT_KEY_MAX)) {
+		printk(KERN_CRIT "%s: invalid key: %llu\n", __func__,
+		       (unsigned long long)key);
+		return -EINVAL;
+	}
 	ptr = nilfs_direct_get_ptr(direct, key);
-	BUG_ON(ptr == NILFS_BMAP_INVALID_PTR);
+	if (unlikely(ptr == NILFS_BMAP_INVALID_PTR)) {
+		printk(KERN_CRIT "%s: invalid pointer: %llu\n", __func__,
+		       (unsigned long long)ptr);
+		return -EINVAL;
+	}
 
 	return direct->d_ops->dop_assign(direct, key, ptr, bh,
 					 blocknr, binfo);
diff -puN fs/nilfs2/inode.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/inode.c
@@ -61,12 +61,6 @@ int nilfs_get_block(struct inode *inode,
 		map_bh(bh_result, inode->i_sb, blknum);
 		goto out;
 	}
-	if (unlikely(ret == 1)) {
-		printk(KERN_ERR "nilfs_get_block: bmap_lookup returns "
-		       "buffer_head pointer (blkoff=%llu, blknum=%lu)\n",
-		       (unsigned long long)blkoff, blknum);
-		BUG();
-	}
 	/* data block was not found */
 	if (ret == -ENOENT && create) {
 		struct nilfs_transaction_info ti;
@@ -85,14 +79,14 @@ int nilfs_get_block(struct inode *inode,
 				 * However, the page having this block must
 				 * be locked in this case.
 				 */
-				printk(KERN_ERR
+				printk(KERN_WARNING
 				       "nilfs_get_block: a race condition "
 				       "while inserting a data block. "
 				       "(inode number=%lu, file block "
 				       "offset=%llu)\n",
 				       inode->i_ino,
 				       (unsigned long long)blkoff);
-				BUG();
+				err = 0;
 			} else if (err == -EINVAL) {
 				nilfs_error(inode->i_sb, __func__,
 					    "broken bmap (inode=%lu)\n",
@@ -621,7 +615,6 @@ void nilfs_truncate(struct inode *inode)
 	struct nilfs_transaction_info ti;
 	struct super_block *sb = inode->i_sb;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	int ret;
 
 	if (!test_bit(NILFS_I_BMAP, &ii->i_state))
 		return;
@@ -630,8 +623,7 @@ void nilfs_truncate(struct inode *inode)
 
 	blocksize = sb->s_blocksize;
 	blkoff = (inode->i_size + blocksize - 1) >> sb->s_blocksize_bits;
-	ret = nilfs_transaction_begin(sb, &ti, 0);
-	BUG_ON(ret);
+	nilfs_transaction_begin(sb, &ti, 0); /* never fails */
 
 	block_truncate_page(inode->i_mapping, inode->i_size, nilfs_get_block);
 
@@ -652,7 +644,6 @@ void nilfs_delete_inode(struct inode *in
 	struct nilfs_transaction_info ti;
 	struct super_block *sb = inode->i_sb;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	int err;
 
 	if (unlikely(is_bad_inode(inode))) {
 		if (inode->i_data.nrpages)
@@ -660,8 +651,8 @@ void nilfs_delete_inode(struct inode *in
 		clear_inode(inode);
 		return;
 	}
-	err = nilfs_transaction_begin(sb, &ti, 0);
-	BUG_ON(err);
+	nilfs_transaction_begin(sb, &ti, 0); /* never fails */
+
 	if (inode->i_data.nrpages)
 		truncate_inode_pages(&inode->i_data, 0);
 
diff -puN fs/nilfs2/ioctl.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/ioctl.c
@@ -489,14 +489,14 @@ nilfs_ioctl_do_mark_blocks_dirty(struct 
 			ret = nilfs_mdt_mark_block_dirty(dat,
 							 bdescs[i].bd_offset);
 			if (ret < 0) {
-				BUG_ON(ret == -ENOENT);
+				WARN_ON(ret == -ENOENT);
 				return ret;
 			}
 		} else {
 			ret = nilfs_bmap_mark(bmap, bdescs[i].bd_offset,
 					      bdescs[i].bd_level);
 			if (ret < 0) {
-				BUG_ON(ret == -ENOENT);
+				WARN_ON(ret == -ENOENT);
 				return ret;
 			}
 		}
@@ -519,7 +519,8 @@ nilfs_ioctl_do_free_segments(struct the_
 	struct nilfs_sb_info *sbi = nilfs_get_writer(nilfs);
 	int ret;
 
-	BUG_ON(!sbi);
+	if (unlikely(!sbi))
+		return -EROFS;
 	ret = nilfs_segctor_add_segments_to_be_freed(
 		NILFS_SC(sbi), buf, nmembs);
 	nilfs_put_writer(nilfs);
@@ -539,6 +540,7 @@ int nilfs_ioctl_prepare_clean_segments(s
 				       void __user *argp)
 {
 	struct nilfs_argv argv[5];
+	const char *msg;
 	int dir, ret;
 
 	if (copy_from_user(argv, argp, sizeof(argv)))
@@ -546,31 +548,50 @@ int nilfs_ioctl_prepare_clean_segments(s
 
 	dir = _IOC_WRITE;
 	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], dir);
-	if (ret < 0)
-		goto out_move_blks;
+	if (ret < 0) {
+		msg = "cannot read source blocks";
+		goto failed;
+	}
 	ret = nilfs_ioctl_delete_checkpoints(nilfs, &argv[1], dir);
-	if (ret < 0)
-		goto out_del_cps;
+	if (ret < 0) {
+		/*
+		 * can safely abort because checkpoints can be removed
+		 * independently.
+		 */
+		msg = "cannot delete checkpoints";
+		goto failed;
+	}
 	ret = nilfs_ioctl_free_vblocknrs(nilfs, &argv[2], dir);
-	if (ret < 0)
-		goto out_free_vbns;
+	if (ret < 0) {
+		/*
+		 * can safely abort because DAT file is updated atomically
+		 * using a copy-on-write technique.
+		 */
+		msg = "cannot delete virtual blocks from DAT file";
+		goto failed;
+	}
 	ret = nilfs_ioctl_mark_blocks_dirty(nilfs, &argv[3], dir);
-	if (ret < 0)
-		goto out_free_vbns;
+	if (ret < 0) {
+		/*
+		 * can safely abort because the operation is nondestructive.
+		 */
+		msg = "cannot mark copying blocks dirty";
+		goto failed;
+	}
 	ret = nilfs_ioctl_free_segments(nilfs, &argv[4], dir);
-	if (ret < 0)
-		goto out_free_segs;
-
+	if (ret < 0) {
+		/*
+		 * can safely abort because this operation is atomic.
+		 */
+		msg = "cannot set segments to be freed";
+		goto failed;
+	}
 	return 0;
 
- out_free_segs:
-	BUG(); /* XXX: not implemented yet */
- out_free_vbns:
-	BUG();/* XXX: not implemented yet */
- out_del_cps:
-	BUG();/* XXX: not implemented yet */
- out_move_blks:
+ failed:
 	nilfs_remove_all_gcinode(nilfs);
+	printk(KERN_ERR "NILFS: GC failed during preparation: %s: err=%d\n",
+	       msg, ret);
 	return ret;
 }
 
diff -puN fs/nilfs2/mdt.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/mdt.c
@@ -154,10 +154,8 @@ nilfs_mdt_submit_block(struct inode *ino
 			ret = -EBUSY;
 			goto failed_bh;
 		}
-	} else {
-		BUG_ON(mode != READ);
+	} else /* mode == READ */
 		lock_buffer(bh);
-	}
 
 	if (buffer_uptodate(bh)) {
 		unlock_buffer(bh);
diff -puN fs/nilfs2/nilfs.h~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/nilfs.h
@@ -173,7 +173,6 @@ static inline void nilfs_set_transaction
 {
 	struct nilfs_transaction_info *ti = current->journal_info;
 
-	BUG_ON(!ti);
 	ti->ti_flags |= flag;
 }
 
diff -puN fs/nilfs2/page.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/page.c
@@ -417,7 +417,7 @@ repeat:
 		dpage = find_lock_page(dmap, offset);
 		if (dpage) {
 			/* override existing page on the destination cache */
-			BUG_ON(PageDirty(dpage));
+			WARN_ON(PageDirty(dpage));
 			nilfs_copy_page(dpage, page, 0);
 			unlock_page(dpage);
 			page_cache_release(dpage);
@@ -427,17 +427,15 @@ repeat:
 			/* move the page to the destination cache */
 			spin_lock_irq(&smap->tree_lock);
 			page2 = radix_tree_delete(&smap->page_tree, offset);
-			if (unlikely(page2 != page))
-				NILFS_PAGE_BUG(page, "page removal failed "
-					       "(offset=%lu, page2=%p)",
-					       offset, page2);
+			WARN_ON(page2 != page);
+
 			smap->nrpages--;
 			spin_unlock_irq(&smap->tree_lock);
 
 			spin_lock_irq(&dmap->tree_lock);
 			err = radix_tree_insert(&dmap->page_tree, offset, page);
 			if (unlikely(err < 0)) {
-				BUG_ON(err == -EEXIST);
+				WARN_ON(err == -EEXIST);
 				page->mapping = NULL;
 				page_cache_release(page); /* for cache */
 			} else {
diff -puN fs/nilfs2/recovery.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/recovery.c
--- a/fs/nilfs2/recovery.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/recovery.c
@@ -92,9 +92,6 @@ static int nilfs_warn_segment_error(int 
 		printk(KERN_WARNING
 		       "NILFS warning: No super root in the last segment\n");
 		break;
-	case NILFS_SEG_VALID:
-	default:
-		BUG();
 	}
 	return -EINVAL;
 }
diff -puN fs/nilfs2/segment.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/segment.c
@@ -334,8 +334,7 @@ static void nilfs_transaction_lock(struc
 {
 	struct nilfs_transaction_info *cur_ti = current->journal_info;
 
-	BUG_ON(cur_ti);
-	BUG_ON(!ti);
+	WARN_ON(cur_ti);
 	ti->ti_flags = NILFS_TI_WRITER;
 	ti->ti_count = 0;
 	ti->ti_save = cur_ti;
@@ -546,8 +545,6 @@ static int nilfs_collect_file_data(struc
 {
 	int err;
 
-	/* BUG_ON(!buffer_dirty(bh)); */
-	/* excluded by scan_dirty_data_buffers() */
 	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
 	if (unlikely(err < 0))
 		return nilfs_handle_bmap_error(err, __func__, inode,
@@ -566,8 +563,6 @@ static int nilfs_collect_file_node(struc
 {
 	int err;
 
-	/* BUG_ON(!buffer_dirty(bh)); */
-	/* excluded by scan_dirty_node_buffers() */
 	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
 	if (unlikely(err < 0))
 		return nilfs_handle_bmap_error(err, __func__, inode,
@@ -579,7 +574,7 @@ static int nilfs_collect_file_bmap(struc
 				   struct buffer_head *bh,
 				   struct inode *inode)
 {
-	BUG_ON(!buffer_dirty(bh));
+	WARN_ON(!buffer_dirty(bh));
 	return nilfs_segctor_add_file_block(sci, bh, inode, sizeof(__le64));
 }
 
@@ -628,7 +623,7 @@ static int nilfs_collect_dat_data(struct
 static int nilfs_collect_dat_bmap(struct nilfs_sc_info *sci,
 				  struct buffer_head *bh, struct inode *inode)
 {
-	BUG_ON(!buffer_dirty(bh));
+	WARN_ON(!buffer_dirty(bh));
 	return nilfs_segctor_add_file_block(sci, bh, inode,
 					    sizeof(struct nilfs_binfo_dat));
 }
@@ -862,9 +857,9 @@ static int nilfs_segctor_create_checkpoi
 		nilfs_mdt_mark_dirty(nilfs->ns_cpfile);
 		nilfs_cpfile_put_checkpoint(
 			nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
-	} else {
-		BUG_ON(err == -EINVAL || err == -ENOENT);
-	}
+	} else
+		WARN_ON(err == -EINVAL || err == -ENOENT);
+
 	return err;
 }
 
@@ -879,7 +874,7 @@ static int nilfs_segctor_fill_in_checkpo
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 0,
 					  &raw_cp, &bh_cp);
 	if (unlikely(err)) {
-		BUG_ON(err == -EINVAL || err == -ENOENT);
+		WARN_ON(err == -EINVAL || err == -ENOENT);
 		goto failed_ibh;
 	}
 	raw_cp->cp_snapshot_list.ssl_next = 0;
@@ -944,7 +939,6 @@ static void nilfs_fill_in_super_root_crc
 		(struct nilfs_super_root *)bh_sr->b_data;
 	u32 crc;
 
-	BUG_ON(NILFS_SR_BYTES > bh_sr->b_size);
 	crc = crc32_le(seed,
 		       (unsigned char *)raw_sr + sizeof(raw_sr->sr_sum),
 		       NILFS_SR_BYTES - sizeof(raw_sr->sr_sum));
@@ -1022,8 +1016,7 @@ static void nilfs_segctor_cancel_free_se
 		if (!(ent->flags & NILFS_SLH_FREED))
 			break;
 		err = nilfs_sufile_cancel_free(sufile, ent->segnum);
-		BUG_ON(err);
-
+		WARN_ON(err); /* do not happen */
 		ent->flags &= ~NILFS_SLH_FREED;
 	}
 }
@@ -1472,7 +1465,7 @@ static int nilfs_segctor_extend_segments
  failed:
 	list_for_each_entry_safe(segbuf, n, &list, sb_list) {
 		ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
-		BUG_ON(ret);
+		WARN_ON(ret); /* never fails */
 		list_del_init(&segbuf->sb_list);
 		nilfs_segbuf_free(segbuf);
 	}
@@ -1488,7 +1481,7 @@ static void nilfs_segctor_free_incomplet
 	segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
 	if (nilfs->ns_nextnum != segbuf->sb_nextnum) {
 		ret = nilfs_sufile_free(nilfs->ns_sufile, segbuf->sb_nextnum);
-		BUG_ON(ret);
+		WARN_ON(ret); /* never fails */
 	}
 	if (segbuf->sb_io_error) {
 		/* Case 1: The first segment failed */
@@ -1504,7 +1497,7 @@ static void nilfs_segctor_free_incomplet
 
 	list_for_each_entry_continue(segbuf, &sci->sc_segbufs, sb_list) {
 		ret = nilfs_sufile_free(nilfs->ns_sufile, segbuf->sb_nextnum);
-		BUG_ON(ret);
+		WARN_ON(ret); /* never fails */
 		if (!done && segbuf->sb_io_error) {
 			if (segbuf->sb_segnum != nilfs->ns_nextnum)
 				/* Case 2: extended segment (!= next) failed */
@@ -1558,7 +1551,7 @@ static void nilfs_segctor_update_segusag
 	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
 		ret = nilfs_sufile_get_segment_usage(sufile, segbuf->sb_segnum,
 						     &raw_su, &bh_su);
-		BUG_ON(ret); /* always succeed because bh_su is dirty */
+		WARN_ON(ret); /* always succeed because bh_su is dirty */
 		live_blocks = segbuf->sb_sum.nblocks +
 			(segbuf->sb_pseg_start - segbuf->sb_fseg_start);
 		raw_su->su_lastmod = cpu_to_le64(sci->sc_seg_ctime);
@@ -1579,7 +1572,7 @@ static void nilfs_segctor_cancel_segusag
 	segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
 	ret = nilfs_sufile_get_segment_usage(sufile, segbuf->sb_segnum,
 					     &raw_su, &bh_su);
-	BUG_ON(ret); /* always succeed because bh_su is dirty */
+	WARN_ON(ret); /* always succeed because bh_su is dirty */
 	raw_su->su_nblocks = cpu_to_le32(segbuf->sb_pseg_start -
 					 segbuf->sb_fseg_start);
 	nilfs_sufile_put_segment_usage(sufile, segbuf->sb_segnum, bh_su);
@@ -1587,7 +1580,7 @@ static void nilfs_segctor_cancel_segusag
 	list_for_each_entry_continue(segbuf, &sci->sc_segbufs, sb_list) {
 		ret = nilfs_sufile_get_segment_usage(sufile, segbuf->sb_segnum,
 						     &raw_su, &bh_su);
-		BUG_ON(ret); /* always succeed */
+		WARN_ON(ret); /* always succeed */
 		raw_su->su_nblocks = 0;
 		nilfs_sufile_put_segment_usage(sufile, segbuf->sb_segnum,
 					       bh_su);
@@ -1606,7 +1599,7 @@ static void nilfs_segctor_truncate_segme
 		list_del_init(&segbuf->sb_list);
 		sci->sc_segbuf_nblocks -= segbuf->sb_rest_blocks;
 		ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
-		BUG_ON(ret);
+		WARN_ON(ret);
 		nilfs_segbuf_free(segbuf);
 	}
 }
@@ -1923,7 +1916,6 @@ static int nilfs_page_has_uncleared_buff
 
 static void __nilfs_end_page_io(struct page *page, int err)
 {
-	/* BUG_ON(err > 0); */
 	if (!err) {
 		if (!nilfs_page_buffers_clean(page))
 			__set_page_dirty_nobuffers(page);
@@ -2262,7 +2254,7 @@ static int nilfs_segctor_deactivate_segm
 		if (unlikely(err))
 			goto failed;
 		nilfs_segment_usage_clear_active(ent->raw_su);
-		BUG_ON(!buffer_dirty(ent->bh_su));
+		WARN_ON(!buffer_dirty(ent->bh_su));
 	}
 	return 0;
 
@@ -2340,7 +2332,6 @@ static int nilfs_segctor_do_construct(st
 		/* Avoid empty segment */
 		if (sci->sc_stage.scnt == NILFS_ST_DONE &&
 		    NILFS_SEG_EMPTY(&sci->sc_curseg->sb_sum)) {
-			BUG_ON(mode == SC_LSEG_SR);
 			nilfs_segctor_end_construction(sci, nilfs, 1);
 			goto out;
 		}
@@ -2479,9 +2470,8 @@ int nilfs_segctor_add_segments_to_be_fre
 	struct inode *sufile = nilfs->ns_sufile;
 	LIST_HEAD(list);
 	__u64 *pnum;
-	const char *flag_name;
 	size_t i;
-	int err, err2 = 0;
+	int err;
 
 	for (pnum = segnum, i = 0; i < nsegs; pnum++, i++) {
 		ent = nilfs_alloc_segment_entry(*pnum);
@@ -2495,32 +2485,12 @@ int nilfs_segctor_add_segments_to_be_fre
 		if (unlikely(err))
 			goto failed;
 
-		if (unlikely(le32_to_cpu(ent->raw_su->su_flags) !=
-			     (1UL << NILFS_SEGMENT_USAGE_DIRTY))) {
-			if (nilfs_segment_usage_clean(ent->raw_su))
-				flag_name = "clean";
-			else if (nilfs_segment_usage_active(ent->raw_su))
-				flag_name = "active";
-			else if (nilfs_segment_usage_volatile_active(
-					 ent->raw_su))
-				flag_name = "volatile active";
-			else if (!nilfs_segment_usage_dirty(ent->raw_su))
-				flag_name = "non-dirty";
-			else
-				flag_name = "erroneous";
-
-			printk(KERN_ERR
-			       "NILFS: %s segment is requested to be cleaned "
-			       "(segnum=%llu)\n",
-			       flag_name, (unsigned long long)ent->segnum);
-			err2 = -EINVAL;
-		}
+		if (unlikely(!nilfs_segment_usage_dirty(ent->raw_su)))
+			printk(KERN_WARNING "NILFS: unused segment is "
+			       "requested to be cleaned (segnum=%llu)\n",
+			       (unsigned long long)ent->segnum);
 		nilfs_close_segment_entry(ent, sufile);
 	}
-	if (unlikely(err2)) {
-		err = err2;
-		goto failed;
-	}
 	list_splice(&list, sci->sc_cleaning_segments.prev);
 	return 0;
 
@@ -2705,8 +2675,6 @@ struct nilfs_segctor_req {
 static void nilfs_segctor_accept(struct nilfs_sc_info *sci,
 				 struct nilfs_segctor_req *req)
 {
-	BUG_ON(!sci);
-
 	req->sc_err = req->sb_err = 0;
 	spin_lock(&sci->sc_state_lock);
 	req->seq_accepted = sci->sc_seq_request;
@@ -3107,7 +3075,7 @@ static void nilfs_segctor_destroy(struct
 	if (flag || nilfs_segctor_confirm(sci))
 		nilfs_segctor_write_out(sci);
 
-	BUG_ON(!list_empty(&sci->sc_copied_buffers));
+	WARN_ON(!list_empty(&sci->sc_copied_buffers));
 
 	if (!list_empty(&sci->sc_dirty_files)) {
 		nilfs_warning(sbi->s_super, __func__,
@@ -3120,7 +3088,7 @@ static void nilfs_segctor_destroy(struct
 	if (!list_empty(&sci->sc_cleaning_segments))
 		nilfs_dispose_segment_list(&sci->sc_cleaning_segments);
 
-	BUG_ON(!list_empty(&sci->sc_segbufs));
+	WARN_ON(!list_empty(&sci->sc_segbufs));
 
 	if (sci->sc_sketch_inode) {
 		iput(sci->sc_sketch_inode);
diff -puN fs/nilfs2/sufile.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/sufile.c
@@ -231,10 +231,11 @@ int nilfs_sufile_cancel_free(struct inod
 	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
 	su = nilfs_sufile_block_get_segment_usage(
 		sufile, segnum, su_bh, kaddr);
-	if (!nilfs_segment_usage_clean(su)) {
-		printk(KERN_CRIT "%s: segment %llu must be clean\n",
+	if (unlikely(!nilfs_segment_usage_clean(su))) {
+		printk(KERN_WARNING "%s: segment %llu must be clean\n",
 		       __func__, (unsigned long long)segnum);
-		BUG();
+		kunmap_atomic(kaddr, KM_USER0);
+		goto out_su_bh;
 	}
 	nilfs_segment_usage_set_dirty(su);
 	kunmap_atomic(kaddr, KM_USER0);
@@ -249,11 +250,10 @@ int nilfs_sufile_cancel_free(struct inod
 	nilfs_mdt_mark_buffer_dirty(su_bh);
 	nilfs_mdt_mark_dirty(sufile);
 
+ out_su_bh:
 	brelse(su_bh);
-
  out_header:
 	brelse(header_bh);
-
  out_sem:
 	up_write(&NILFS_MDT(sufile)->mi_sem);
 	return ret;
@@ -317,7 +317,7 @@ int nilfs_sufile_freev(struct inode *suf
 		kaddr = kmap_atomic(su_bh[i]->b_page, KM_USER0);
 		su = nilfs_sufile_block_get_segment_usage(
 			sufile, segnum[i], su_bh[i], kaddr);
-		BUG_ON(nilfs_segment_usage_error(su));
+		WARN_ON(nilfs_segment_usage_error(su));
 		nilfs_segment_usage_set_clean(su);
 		kunmap_atomic(kaddr, KM_USER0);
 		nilfs_mdt_mark_buffer_dirty(su_bh[i]);
@@ -385,8 +385,8 @@ int nilfs_sufile_get_segment_usage(struc
 	int ret;
 
 	/* segnum is 0 origin */
-	BUG_ON(segnum >= nilfs_sufile_get_nsegments(sufile));
-
+	if (segnum >= nilfs_sufile_get_nsegments(sufile))
+		return -EINVAL;
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 1, &bh);
 	if (ret < 0)
@@ -515,6 +515,8 @@ int nilfs_sufile_get_ncleansegs(struct i
  * %-EIO - I/O error.
  *
  * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EINVAL - Invalid segment usage number.
  */
 int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
 {
@@ -524,8 +526,11 @@ int nilfs_sufile_set_error(struct inode 
 	void *kaddr;
 	int ret;
 
-	BUG_ON(segnum >= nilfs_sufile_get_nsegments(sufile));
-
+	if (unlikely(segnum >= nilfs_sufile_get_nsegments(sufile))) {
+		printk(KERN_WARNING "%s: invalid segment number: %llu\n",
+		       __func__, (unsigned long long)segnum);
+		return -EINVAL;
+	}
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 
 	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
diff -puN fs/nilfs2/super.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl
+++ a/fs/nilfs2/super.c
@@ -841,8 +841,11 @@ nilfs_fill_super(struct super_block *sb,
 
 	if (sb->s_flags & MS_RDONLY) {
 		if (nilfs_test_opt(sbi, SNAPSHOT)) {
-			if (!nilfs_cpfile_is_snapshot(nilfs->ns_cpfile,
-						      sbi->s_snapshot_cno)) {
+			err = nilfs_cpfile_is_snapshot(nilfs->ns_cpfile,
+						       sbi->s_snapshot_cno);
+			if (err < 0)
+				goto failed_sbi;
+			if (!err) {
 				printk(KERN_ERR
 				       "NILFS: The specified checkpoint is "
 				       "not a snapshot "
@@ -1163,7 +1166,6 @@ nilfs_get_sb(struct file_system_type *fs
 	} else {
 		struct nilfs_sb_info *sbi = NILFS_SB(s);
 
-		BUG_ON(!sbi || !sbi->s_nilfs);
 		/*
 		 * s_umount protects super_block from unmount process;
 		 * It covers pointers of nilfs_sb_info and the_nilfs.
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

