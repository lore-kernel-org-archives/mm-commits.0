From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-remove-redundant-ocfs2_alloc_dinode_update_counts-and-ocfs2_block_group_set_bits.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:11:49 -0800
Message-ID: <52e02605.lQSHZohfzmCvHOwn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaAVULt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:11:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, younger.liucn@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, liuyiyang@hisense.com

Subject: [merged] ocfs2-remove-redundant-ocfs2_alloc_dinode_update_counts-and-ocfs2_block_group_set_bits.patch removed from -mm tree
To: liuyiyang@hisense.com,jlbec@evilplan.org,mfasheh@suse.com,younger.liucn@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:11:49 -0800


The patch titled
     Subject: ocfs2: remove redundant ocfs2_alloc_dinode_update_counts() and ocfs2_block_group_set_bits()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-redundant-ocfs2_alloc_dinode_update_counts-and-ocfs2_block_group_set_bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Younger Liu <liuyiyang@hisense.com>
Subject: ocfs2: remove redundant ocfs2_alloc_dinode_update_counts() and ocfs2_block_group_set_bits()

ocfs2_alloc_dinode_update_counts() and ocfs2_block_group_set_bits() are
already provided in suballoc.c.  So, the same functions in move_extents.c
are not needed any more.

Declare the functions in suballoc.h and remove redundant functions in
move_extents.c.

Signed-off-by: Younger Liu <liuyiyang@hisense.com>
Cc: Younger Liu <younger.liucn@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |   77 --------------------------------------
 fs/ocfs2/suballoc.c     |   12 -----
 fs/ocfs2/suballoc.h     |   12 +++++
 3 files changed, 14 insertions(+), 87 deletions(-)

diff -puN fs/ocfs2/move_extents.c~ocfs2-remove-redundant-ocfs2_alloc_dinode_update_counts-and-ocfs2_block_group_set_bits fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-remove-redundant-ocfs2_alloc_dinode_update_counts-and-ocfs2_block_group_set_bits
+++ a/fs/ocfs2/move_extents.c
@@ -561,83 +561,6 @@ static void ocfs2_probe_alloc_group(stru
 	mlog(0, "found phys_cpos: %u to fit the wanted moving.\n", *phys_cpos);
 }
 
-static int ocfs2_alloc_dinode_update_counts(struct inode *inode,
-				       handle_t *handle,
-				       struct buffer_head *di_bh,
-				       u32 num_bits,
-				       u16 chain)
-{
-	int ret;
-	u32 tmp_used;
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
-	struct ocfs2_chain_list *cl =
-				(struct ocfs2_chain_list *) &di->id2.i_chain;
-
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	tmp_used = le32_to_cpu(di->id1.bitmap1.i_used);
-	di->id1.bitmap1.i_used = cpu_to_le32(num_bits + tmp_used);
-	le32_add_cpu(&cl->cl_recs[chain].c_free, -num_bits);
-	ocfs2_journal_dirty(handle, di_bh);
-
-out:
-	return ret;
-}
-
-static inline int ocfs2_block_group_set_bits(handle_t *handle,
-					     struct inode *alloc_inode,
-					     struct ocfs2_group_desc *bg,
-					     struct buffer_head *group_bh,
-					     unsigned int bit_off,
-					     unsigned int num_bits)
-{
-	int status;
-	void *bitmap = bg->bg_bitmap;
-	int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
-
-	/* All callers get the descriptor via
-	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
-	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
-	BUG_ON(le16_to_cpu(bg->bg_free_bits_count) < num_bits);
-
-	mlog(0, "block_group_set_bits: off = %u, num = %u\n", bit_off,
-	     num_bits);
-
-	if (ocfs2_is_cluster_bitmap(alloc_inode))
-		journal_type = OCFS2_JOURNAL_ACCESS_UNDO;
-
-	status = ocfs2_journal_access_gd(handle,
-					 INODE_CACHE(alloc_inode),
-					 group_bh,
-					 journal_type);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	le16_add_cpu(&bg->bg_free_bits_count, -num_bits);
-	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
-		ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
-			    " count %u but claims %u are freed. num_bits %d",
-			    (unsigned long long)le64_to_cpu(bg->bg_blkno),
-			    le16_to_cpu(bg->bg_bits),
-			    le16_to_cpu(bg->bg_free_bits_count), num_bits);
-		return -EROFS;
-	}
-	while (num_bits--)
-		ocfs2_set_bit(bit_off++, bitmap);
-
-	ocfs2_journal_dirty(handle, group_bh);
-
-bail:
-	return status;
-}
-
 static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 			     u32 cpos, u32 phys_cpos, u32 *new_phys_cpos,
 			     u32 len, int ext_flags)
diff -puN fs/ocfs2/suballoc.c~ocfs2-remove-redundant-ocfs2_alloc_dinode_update_counts-and-ocfs2_block_group_set_bits fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-remove-redundant-ocfs2_alloc_dinode_update_counts-and-ocfs2_block_group_set_bits
+++ a/fs/ocfs2/suballoc.c
@@ -113,12 +113,6 @@ static int ocfs2_claim_suballoc_bits(str
 				     struct ocfs2_suballoc_result *res);
 static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 					 int nr);
-static inline int ocfs2_block_group_set_bits(handle_t *handle,
-					     struct inode *alloc_inode,
-					     struct ocfs2_group_desc *bg,
-					     struct buffer_head *group_bh,
-					     unsigned int bit_off,
-					     unsigned int num_bits);
 static int ocfs2_relink_block_group(handle_t *handle,
 				    struct inode *alloc_inode,
 				    struct buffer_head *fe_bh,
@@ -1343,7 +1337,7 @@ static int ocfs2_block_group_find_clear_
 	return status;
 }
 
-static inline int ocfs2_block_group_set_bits(handle_t *handle,
+int ocfs2_block_group_set_bits(handle_t *handle,
 					     struct inode *alloc_inode,
 					     struct ocfs2_group_desc *bg,
 					     struct buffer_head *group_bh,
@@ -1388,8 +1382,6 @@ static inline int ocfs2_block_group_set_
 	ocfs2_journal_dirty(handle, group_bh);
 
 bail:
-	if (status)
-		mlog_errno(status);
 	return status;
 }
 
@@ -1588,7 +1580,7 @@ static int ocfs2_block_group_search(stru
 	return ret;
 }
 
-static int ocfs2_alloc_dinode_update_counts(struct inode *inode,
+int ocfs2_alloc_dinode_update_counts(struct inode *inode,
 				       handle_t *handle,
 				       struct buffer_head *di_bh,
 				       u32 num_bits,
diff -puN fs/ocfs2/suballoc.h~ocfs2-remove-redundant-ocfs2_alloc_dinode_update_counts-and-ocfs2_block_group_set_bits fs/ocfs2/suballoc.h
--- a/fs/ocfs2/suballoc.h~ocfs2-remove-redundant-ocfs2_alloc_dinode_update_counts-and-ocfs2_block_group_set_bits
+++ a/fs/ocfs2/suballoc.h
@@ -86,6 +86,18 @@ int ocfs2_reserve_clusters(struct ocfs2_
 			   u32 bits_wanted,
 			   struct ocfs2_alloc_context **ac);
 
+int ocfs2_alloc_dinode_update_counts(struct inode *inode,
+			 handle_t *handle,
+			 struct buffer_head *di_bh,
+			 u32 num_bits,
+			 u16 chain);
+int ocfs2_block_group_set_bits(handle_t *handle,
+			 struct inode *alloc_inode,
+			 struct ocfs2_group_desc *bg,
+			 struct buffer_head *group_bh,
+			 unsigned int bit_off,
+			 unsigned int num_bits);
+
 int ocfs2_claim_metadata(handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
 			 u32 bits_wanted,
_

Patches currently in -mm which might be from liuyiyang@hisense.com are

origin.patch
logfs-check-for-the-return-value-after-calling-find_or_create_page.patch
linux-next.patch

