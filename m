From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block-v3.patch removed
 from -mm tree
Date: Wed, 15 Nov 2017 16:48:18 -0800
Message-ID: <5a0ce052.Y2KMQrGUSC+yFOOf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35178 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753923AbdKPAsT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 19:48:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, ge.changwei@h3c.com, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, piaojun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block-v3
has been removed from the -mm tree.  Its filename was
     ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block-v3.patch

This patch was dropped because it was folded into ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block.patch

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block-v3

The ip_alloc_sem should be taken in ocfs2_get_block() when reading file
in DIRECT mode to prevent concurrent access to extent tree with
ocfs2_dio_end_io_write(), which may cause BUGON in the following situation:

read file 'A'                                  end_io of writing file 'A'
vfs_read
 __vfs_read
  ocfs2_file_read_iter
   generic_file_read_iter
    ocfs2_direct_IO
     __blockdev_direct_IO
      do_blockdev_direct_IO
       do_direct_IO
        get_more_blocks
         ocfs2_get_block
          ocfs2_extent_map_get_blocks
           ocfs2_get_clusters
            ocfs2_get_clusters_nocache()
             ocfs2_search_extent_list
              return the index of record which
              contains the v_cluster, that is
              v_cluster > rec[i]->e_cpos.
                                                ocfs2_dio_end_io
                                                 ocfs2_dio_end_io_write
                                                  down_write(&oi->ip_alloc_sem);
                                                  ocfs2_mark_extent_written
                                                   ocfs2_change_extent_flag
                                                    ocfs2_split_extent
                                                     ...
                                                 --> modify the rec[i]->e_cpos, resulting
                                                     in v_cluster < rec[i]->e_cpos.
             BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos))

Link: http://lkml.kernel.org/r/59EF3614.6050008@huawei.com
Fixes: c15471f79506 ("ocfs2: fix sparse file & data ordering issue in direct io")

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Reviewed-by: Gang He <ghe@suse.com>
Acked-by: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block-v3 fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block-v3
+++ a/fs/ocfs2/aops.c
@@ -134,10 +134,10 @@ bail:
 	return err;
 }
 
-static int ocfs2_get_block_lock(struct inode *inode, sector_t iblock,
+static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create)
 {
-	int ret;
+	int ret = 0;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	down_read(&oi->ip_alloc_sem);
@@ -2141,7 +2141,7 @@ static void ocfs2_dio_free_write_ctx(str
  * called like this: dio->get_blocks(dio->inode, fs_startblk,
  * 					fs_count, map_bh, dio->rw == WRITE);
  */
-static int ocfs2_dio_get_block(struct inode *inode, sector_t iblock,
+static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 			       struct buffer_head *bh_result, int create)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -2167,8 +2167,9 @@ static int ocfs2_dio_get_block(struct in
 	 * while file size will be changed.
 	 */
 	if (pos + total_len <= i_size_read(inode)) {
+
 		/* This is the fast path for re-write. */
-		ret = ocfs2_get_block_lock(inode, iblock, bh_result, create);
+		ret = ocfs2_lock_get_block(inode, iblock, bh_result, create);
 		if (buffer_mapped(bh_result) &&
 		    !buffer_new(bh_result) &&
 		    ret == 0)
@@ -2433,9 +2434,9 @@ static ssize_t ocfs2_direct_IO(struct ki
 		return 0;
 
 	if (iov_iter_rw(iter) == READ)
-		get_block = ocfs2_get_block_lock;
+		get_block = ocfs2_lock_get_block;
 	else
-		get_block = ocfs2_dio_get_block;
+		get_block = ocfs2_dio_wr_get_block;
 
 	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
 				    iter, get_block,
_

Patches currently in -mm which might be from alex.chen@huawei.com are

ocfs2-should-wait-dio-before-inode-lock-in-ocfs2_setattr.patch
ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block.patch
ocfs2-subsystemsu_mutex-is-required-while-accessing-the-item-ci_parent.patch
ocfs2-subsystemsu_mutex-is-required-while-accessing-the-item-ci_parent-v2.patch

