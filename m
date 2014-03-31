From: akpm@linux-foundation.org
Subject: +
 ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch added to -mm tree
Date: Mon, 31 Mar 2014 13:57:57 -0700
Message-ID: <5339d6d5.7EYQAyb/PRtwAsZz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaCaU56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Mar 2014 16:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.de, jlbec@evilplan.org, younger.liucn@gmail.com

Subject: + ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch added to -mm tree
To: younger.liucn@gmail.com,jlbec@evilplan.org,mfasheh@suse.de
From: akpm@linux-foundation.org
Date: Mon, 31 Mar 2014 13:57:57 -0700


The patch titled
     Subject: ocfs2: rollback alloc_dinode counts when ocfs2_block_group_set_bits() failed
has been added to the -mm tree.  Its filename is
     ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Younger Liu <younger.liucn@gmail.com>
Subject: ocfs2: rollback alloc_dinode counts when ocfs2_block_group_set_bits() failed

After updating alloc_dinode counts in ocfs2_alloc_dinode_update_counts(),
if ocfs2_alloc_dinode_update_bitmap() failed, there is a rare case that
some space may be lost.

So, roll back alloc_dinode counts when ocfs2_block_group_set_bits()
failed.

Signed-off-by: Younger Liu <younger.liucn@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    5 ++++-
 fs/ocfs2/suballoc.c     |   24 +++++++++++++++++++++++-
 fs/ocfs2/suballoc.h     |    4 ++++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/move_extents.c~ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed
+++ a/fs/ocfs2/move_extents.c
@@ -690,8 +690,11 @@ static int ocfs2_move_extent(struct ocfs
 
 	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
 					 goal_bit, len);
-	if (ret)
+	if (ret) {
+		ocfs2_rollback_alloc_dinode_counts(gb_inode, gb_bh, len,
+					       le16_to_cpu(gd->bg_chain));
 		mlog_errno(ret);
+	}
 
 	/*
 	 * Here we should write the new page out first if we are
diff -puN fs/ocfs2/suballoc.c~ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed
+++ a/fs/ocfs2/suballoc.c
@@ -1607,6 +1607,20 @@ out:
 	return ret;
 }
 
+void ocfs2_rollback_alloc_dinode_counts(struct inode *inode,
+				       struct buffer_head *di_bh,
+				       u32 num_bits,
+				       u16 chain)
+{
+	u32 tmp_used;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
+	struct ocfs2_chain_list *cl = (struct ocfs2_chain_list *) &di->id2.i_chain;
+
+	tmp_used = le32_to_cpu(di->id1.bitmap1.i_used);
+	di->id1.bitmap1.i_used = cpu_to_le32(tmp_used - num_bits);
+	le32_add_cpu(&cl->cl_recs[chain].c_free, num_bits);
+}
+
 static int ocfs2_bg_discontig_fix_by_rec(struct ocfs2_suballoc_result *res,
 					 struct ocfs2_extent_rec *rec,
 					 struct ocfs2_chain_list *cl)
@@ -1707,8 +1721,12 @@ static int ocfs2_search_one_group(struct
 
 	ret = ocfs2_block_group_set_bits(handle, alloc_inode, gd, group_bh,
 					 res->sr_bit_offset, res->sr_bits);
-	if (ret < 0)
+	if (ret < 0) {
+		ocfs2_rollback_alloc_dinode_counts(alloc_inode, ac->ac_bh,
+					       res->sr_bits,
+					       le16_to_cpu(gd->bg_chain));
 		mlog_errno(ret);
+	}
 
 out_loc_only:
 	*bits_left = le16_to_cpu(gd->bg_free_bits_count);
@@ -1838,6 +1856,8 @@ static int ocfs2_search_chain(struct ocf
 					    res->sr_bit_offset,
 					    res->sr_bits);
 	if (status < 0) {
+		ocfs2_rollback_alloc_dinode_counts(alloc_inode,
+					ac->ac_bh, res->sr_bits, chain);
 		mlog_errno(status);
 		goto bail;
 	}
@@ -2149,6 +2169,8 @@ int ocfs2_claim_new_inode_at_loc(handle_
 					 res->sr_bit_offset,
 					 res->sr_bits);
 	if (ret < 0) {
+		ocfs2_rollback_alloc_dinode_counts(ac->ac_inode,
+					       ac->ac_bh, res->sr_bits, chain);
 		mlog_errno(ret);
 		goto out;
 	}
diff -puN fs/ocfs2/suballoc.h~ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed fs/ocfs2/suballoc.h
--- a/fs/ocfs2/suballoc.h~ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed
+++ a/fs/ocfs2/suballoc.h
@@ -91,6 +91,10 @@ int ocfs2_alloc_dinode_update_counts(str
 			 struct buffer_head *di_bh,
 			 u32 num_bits,
 			 u16 chain);
+void ocfs2_rollback_alloc_dinode_counts(struct inode *inode,
+			 struct buffer_head *di_bh,
+			 u32 num_bits,
+			 u16 chain);
 int ocfs2_block_group_set_bits(handle_t *handle,
 			 struct inode *alloc_inode,
 			 struct ocfs2_group_desc *bg,
_

Patches currently in -mm which might be from younger.liucn@gmail.com are

ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch
ocfs2-alloc_dinode-counts-and-group-bitmap-should-be-update-simultaneously.patch

