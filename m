From: akpm@linux-foundation.org
Subject: + ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch added
 to -mm tree
Date: Fri, 27 Mar 2015 15:07:03 -0700
Message-ID: <5515d487.7c3JDzqXCZRW5GIF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbbC0WHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 18:07:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: neaten do_error, ocfs2_error and ocfs2_abort
has been added to the -mm tree.  Its filename is
     ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ocfs2: neaten do_error, ocfs2_error and ocfs2_abort

These uses sometimes do and sometimes don't have '\n' terminations.  Make
the uses consistently use '\n' terminations and remove the newline from
the functions.

Miscellanea:

o Coalesce formats
o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c       |   70 +++++++++++++--------------------------
 fs/ocfs2/aops.c        |    4 +-
 fs/ocfs2/extent_map.c  |   22 ++++++------
 fs/ocfs2/journal.c     |    2 -
 fs/ocfs2/localalloc.c  |    3 -
 fs/ocfs2/quota_local.c |    3 -
 fs/ocfs2/suballoc.c    |    7 +--
 fs/ocfs2/super.c       |    2 -
 fs/ocfs2/super.h       |    6 ++-
 9 files changed, 50 insertions(+), 69 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort
+++ a/fs/ocfs2/alloc.c
@@ -1446,8 +1446,7 @@ static int ocfs2_find_branch_target(stru
 	while(le16_to_cpu(el->l_tree_depth) > 1) {
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-				    "Owner %llu has empty "
-				    "extent list (next_free_rec == 0)",
+				    "Owner %llu has empty extent list (next_free_rec == 0)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
 			status = -EIO;
 			goto bail;
@@ -1456,9 +1455,7 @@ static int ocfs2_find_branch_target(stru
 		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
 		if (!blkno) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-				    "Owner %llu has extent "
-				    "list where extent # %d has no physical "
-				    "block start",
+				    "Owner %llu has extent list where extent # %d has no physical block start\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci), i);
 			status = -EIO;
 			goto bail;
@@ -1788,8 +1785,7 @@ static int __ocfs2_find_path(struct ocfs
 	while (el->l_tree_depth) {
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has empty extent list at "
-				    "depth %u\n",
+				    "Owner %llu has empty extent list at depth %u\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
 				    le16_to_cpu(el->l_tree_depth));
 			ret = -EROFS;
@@ -1814,8 +1810,7 @@ static int __ocfs2_find_path(struct ocfs
 		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
 		if (blkno == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has bad blkno in extent list "
-				    "at depth %u (index %d)\n",
+				    "Owner %llu has bad blkno in extent list at depth %u (index %d)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
 				    le16_to_cpu(el->l_tree_depth), i);
 			ret = -EROFS;
@@ -1836,8 +1831,7 @@ static int __ocfs2_find_path(struct ocfs
 		if (le16_to_cpu(el->l_next_free_rec) >
 		    le16_to_cpu(el->l_count)) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has bad count in extent list "
-				    "at block %llu (next free=%u, count=%u)\n",
+				    "Owner %llu has bad count in extent list at block %llu (next free=%u, count=%u)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
 				    (unsigned long long)bh->b_blocknr,
 				    le16_to_cpu(el->l_next_free_rec),
@@ -2116,8 +2110,7 @@ static int ocfs2_rotate_subtree_right(ha
 
 	if (left_el->l_next_free_rec != left_el->l_count) {
 		ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-			    "Inode %llu has non-full interior leaf node %llu"
-			    "(next free = %u)",
+			    "Inode %llu has non-full interior leaf node %llu (next free = %u)\n",
 			    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 			    (unsigned long long)left_leaf_bh->b_blocknr,
 			    le16_to_cpu(left_el->l_next_free_rec));
@@ -2256,8 +2249,7 @@ int ocfs2_find_cpos_for_left_leaf(struct
 		 * If we got here, we never found a valid node where
 		 * the tree indicated one should be.
 		 */
-		ocfs2_error(sb,
-			    "Invalid extent tree at extent block %llu\n",
+		ocfs2_error(sb, "Invalid extent tree at extent block %llu\n",
 			    (unsigned long long)blkno);
 		ret = -EROFS;
 		goto out;
@@ -2872,8 +2864,7 @@ int ocfs2_find_cpos_for_right_leaf(struc
 		 * If we got here, we never found a valid node where
 		 * the tree indicated one should be.
 		 */
-		ocfs2_error(sb,
-			    "Invalid extent tree at extent block %llu\n",
+		ocfs2_error(sb, "Invalid extent tree at extent block %llu\n",
 			    (unsigned long long)blkno);
 		ret = -EROFS;
 		goto out;
@@ -3199,7 +3190,7 @@ rightmost_no_delete:
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
 			ret = -EIO;
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-				    "Owner %llu has empty extent block at %llu",
+				    "Owner %llu has empty extent block at %llu\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 				    (unsigned long long)le64_to_cpu(eb->h_blkno));
 			goto out;
@@ -3929,7 +3920,7 @@ static void ocfs2_adjust_rightmost_recor
 		next_free = le16_to_cpu(el->l_next_free_rec);
 		if (next_free == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-				    "Owner %llu has a bad extent list",
+				    "Owner %llu has a bad extent list\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
 			ret = -EIO;
 			return;
@@ -4351,10 +4342,7 @@ ocfs2_figure_merge_contig_type(struct oc
 				bh = path_leaf_bh(left_path);
 				eb = (struct ocfs2_extent_block *)bh->b_data;
 				ocfs2_error(sb,
-					    "Extent block #%llu has an "
-					    "invalid l_next_free_rec of "
-					    "%d.  It should have "
-					    "matched the l_count of %d",
+					    "Extent block #%llu has an invalid l_next_free_rec of %d.  It should have matched the l_count of %d\n",
 					    (unsigned long long)le64_to_cpu(eb->h_blkno),
 					    le16_to_cpu(new_el->l_next_free_rec),
 					    le16_to_cpu(new_el->l_count));
@@ -4406,8 +4394,7 @@ ocfs2_figure_merge_contig_type(struct oc
 				bh = path_leaf_bh(right_path);
 				eb = (struct ocfs2_extent_block *)bh->b_data;
 				ocfs2_error(sb,
-					    "Extent block #%llu has an "
-					    "invalid l_next_free_rec of %d",
+					    "Extent block #%llu has an invalid l_next_free_rec of %d\n",
 					    (unsigned long long)le64_to_cpu(eb->h_blkno),
 					    le16_to_cpu(new_el->l_next_free_rec));
 				status = -EINVAL;
@@ -4960,10 +4947,9 @@ leftright:
 		split_index = ocfs2_search_extent_list(el, cpos);
 		if (split_index == -1) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-					"Owner %llu has an extent at cpos %u "
-					"which can no longer be found.\n",
-					(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
-					cpos);
+				    "Owner %llu has an extent at cpos %u which can no longer be found\n",
+				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+				    cpos);
 			ret = -EROFS;
 			goto out;
 		}
@@ -5143,10 +5129,9 @@ int ocfs2_change_extent_flag(handle_t *h
 	index = ocfs2_search_extent_list(el, cpos);
 	if (index == -1) {
 		ocfs2_error(sb,
-			    "Owner %llu has an extent at cpos %u which can no "
-			    "longer be found.\n",
-			     (unsigned long long)
-			     ocfs2_metadata_cache_owner(et->et_ci), cpos);
+			    "Owner %llu has an extent at cpos %u which can no longer be found\n",
+			    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+			    cpos);
 		ret = -EROFS;
 		goto out;
 	}
@@ -5213,9 +5198,7 @@ int ocfs2_mark_extent_written(struct ino
 		cpos, len, phys);
 
 	if (!ocfs2_writes_unwritten_extents(OCFS2_SB(inode->i_sb))) {
-		ocfs2_error(inode->i_sb, "Inode %llu has unwritten extents "
-			    "that are being written to, but the feature bit "
-			    "is not set in the super block.",
+		ocfs2_error(inode->i_sb, "Inode %llu has unwritten extents that are being written to, but the feature bit is not set in the super block\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
 		ret = -EROFS;
 		goto out;
@@ -5499,8 +5482,7 @@ int ocfs2_remove_extent(handle_t *handle
 	index = ocfs2_search_extent_list(el, cpos);
 	if (index == -1) {
 		ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-			    "Owner %llu has an extent at cpos %u which can no "
-			    "longer be found.\n",
+			    "Owner %llu has an extent at cpos %u which can no longer be found\n",
 			    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 			    cpos);
 		ret = -EROFS;
@@ -5565,7 +5547,7 @@ int ocfs2_remove_extent(handle_t *handle
 		index = ocfs2_search_extent_list(el, cpos);
 		if (index == -1) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-				    "Owner %llu: split at cpos %u lost record.",
+				    "Owner %llu: split at cpos %u lost record\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 				    cpos);
 			ret = -EROFS;
@@ -5581,8 +5563,7 @@ int ocfs2_remove_extent(handle_t *handle
 			ocfs2_rec_clusters(el, rec);
 		if (rec_range != trunc_range) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
-				    "Owner %llu: error after split at cpos %u"
-				    "trunc len %u, existing record is (%u,%u)",
+				    "Owner %llu: error after split at cpos %u trunc len %u, existing record is (%u,%u)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 				    cpos, len, le32_to_cpu(rec->e_cpos),
 				    ocfs2_rec_clusters(el, rec));
@@ -7093,8 +7074,8 @@ start:
 		 * to check it up here before changing the tree.
 		*/
 		if (root_el->l_tree_depth && rec->e_int_clusters == 0) {
-			ocfs2_error(inode->i_sb, "Inode %lu has an empty "
-				    "extent record, depth %u\n", inode->i_ino,
+			ocfs2_error(inode->i_sb, "Inode %lu has an empty extent record, depth %u\n",
+				    inode->i_ino,
 				    le16_to_cpu(root_el->l_tree_depth));
 			status = -EROFS;
 			goto bail;
@@ -7189,8 +7170,7 @@ int ocfs2_truncate_inline(struct inode *
 	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) ||
 	    !ocfs2_supports_inline_data(osb)) {
 		ocfs2_error(inode->i_sb,
-			    "Inline data flags for inode %llu don't agree! "
-			    "Disk: 0x%x, Memory: 0x%x, Superblock: 0x%x\n",
+			    "Inline data flags for inode %llu don't agree! Disk: 0x%x, Memory: 0x%x, Superblock: 0x%x\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    le16_to_cpu(di->i_dyn_features),
 			    OCFS2_I(inode)->ip_dyn_features,
diff -puN fs/ocfs2/aops.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort
+++ a/fs/ocfs2/aops.c
@@ -226,7 +226,7 @@ int ocfs2_read_inline_data(struct inode
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)) {
-		ocfs2_error(inode->i_sb, "Inode %llu lost inline data flag",
+		ocfs2_error(inode->i_sb, "Inode %llu lost inline data flag\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
 		return -EROFS;
 	}
@@ -236,7 +236,7 @@ int ocfs2_read_inline_data(struct inode
 	if (size > PAGE_CACHE_SIZE ||
 	    size > ocfs2_max_inline_data_with_xattr(inode->i_sb, di)) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %llu has with inline data has bad size: %Lu",
+			    "Inode %llu has with inline data has bad size: %Lu\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    (unsigned long long)size);
 		return -EROFS;
diff -puN fs/ocfs2/extent_map.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort
+++ a/fs/ocfs2/extent_map.c
@@ -305,8 +305,8 @@ static int ocfs2_last_eb_is_empty(struct
 
 	if (el->l_tree_depth) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %lu has non zero tree depth in "
-			    "leaf block %llu\n", inode->i_ino,
+			    "Inode %lu has non zero tree depth in leaf block %llu\n",
+			    inode->i_ino,
 			    (unsigned long long)eb_bh->b_blocknr);
 		ret = -EROFS;
 		goto out;
@@ -441,8 +441,8 @@ static int ocfs2_get_clusters_nocache(st
 
 		if (el->l_tree_depth) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %lu has non zero tree depth in "
-				    "leaf block %llu\n", inode->i_ino,
+				    "Inode %lu has non zero tree depth in leaf block %llu\n",
+				    inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
 			ret = -EROFS;
 			goto out;
@@ -475,8 +475,9 @@ static int ocfs2_get_clusters_nocache(st
 	BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos));
 
 	if (!rec->e_blkno) {
-		ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
-			    "record (%u, %u, 0)", inode->i_ino,
+		ocfs2_error(inode->i_sb,
+			    "Inode %lu has bad extent record (%u, %u, 0)\n",
+			    inode->i_ino,
 			    le32_to_cpu(rec->e_cpos),
 			    ocfs2_rec_clusters(el, rec));
 		ret = -EROFS;
@@ -564,8 +565,8 @@ int ocfs2_xattr_get_clusters(struct inod
 
 		if (el->l_tree_depth) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %lu has non zero tree depth in "
-				    "xattr leaf block %llu\n", inode->i_ino,
+				    "Inode %lu has non zero tree depth in xattr leaf block %llu\n",
+				    inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
 			ret = -EROFS;
 			goto out;
@@ -582,8 +583,9 @@ int ocfs2_xattr_get_clusters(struct inod
 		BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos));
 
 		if (!rec->e_blkno) {
-			ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
-				    "record (%u, %u, 0) in xattr", inode->i_ino,
+			ocfs2_error(inode->i_sb,
+				    "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
+				    inode->i_ino,
 				    le32_to_cpu(rec->e_cpos),
 				    ocfs2_rec_clusters(el, rec));
 			ret = -EROFS;
diff -puN fs/ocfs2/journal.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort
+++ a/fs/ocfs2/journal.c
@@ -374,7 +374,7 @@ handle_t *ocfs2_start_trans(struct ocfs2
 		mlog_errno(PTR_ERR(handle));
 
 		if (is_journal_aborted(journal)) {
-			ocfs2_abort(osb->sb, "Detected aborted journal");
+			ocfs2_abort(osb->sb, "Detected aborted journal\n");
 			handle = ERR_PTR(-EROFS);
 		}
 	} else {
diff -puN fs/ocfs2/localalloc.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort
+++ a/fs/ocfs2/localalloc.c
@@ -665,8 +665,7 @@ int ocfs2_reserve_local_alloc_bits(struc
 #ifdef CONFIG_OCFS2_DEBUG_FS
 	if (le32_to_cpu(alloc->id1.bitmap1.i_used) !=
 	    ocfs2_local_alloc_count_bits(alloc)) {
-		ocfs2_error(osb->sb, "local alloc inode %llu says it has "
-			    "%u used bits, but a count shows %u",
+		ocfs2_error(osb->sb, "local alloc inode %llu says it has %u used bits, but a count shows %u\n",
 			    (unsigned long long)le64_to_cpu(alloc->i_blkno),
 			    le32_to_cpu(alloc->id1.bitmap1.i_used),
 			    ocfs2_local_alloc_count_bits(alloc));
diff -puN fs/ocfs2/quota_local.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort fs/ocfs2/quota_local.c
--- a/fs/ocfs2/quota_local.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort
+++ a/fs/ocfs2/quota_local.c
@@ -138,8 +138,7 @@ static int ocfs2_read_quota_block(struct
 
 	if (i_size_read(inode) >> inode->i_sb->s_blocksize_bits <= v_block) {
 		ocfs2_error(inode->i_sb,
-			    "Quota file %llu is probably corrupted! Requested "
-			    "to read block %Lu but file has size only %Lu\n",
+			    "Quota file %llu is probably corrupted! Requested to read block %Lu but file has size only %Lu\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    (unsigned long long)v_block,
 			    (unsigned long long)i_size_read(inode));
diff -puN fs/ocfs2/suballoc.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort
+++ a/fs/ocfs2/suballoc.c
@@ -233,8 +233,7 @@ static int ocfs2_validate_gd_parent(stru
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
 
 	if (di->i_blkno != gd->bg_parent_dinode) {
-		do_error("Group descriptor #%llu has bad parent "
-			 "pointer (%llu, expected %llu)",
+		do_error("Group descriptor #%llu has bad parent pointer (%llu, expected %llu)\n",
 			 (unsigned long long)bh->b_blocknr,
 			 (unsigned long long)le64_to_cpu(gd->bg_parent_dinode),
 			 (unsigned long long)le64_to_cpu(di->i_blkno));
@@ -243,7 +242,7 @@ static int ocfs2_validate_gd_parent(stru
 
 	max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) * le16_to_cpu(di->id2.i_chain.cl_bpc);
 	if (le16_to_cpu(gd->bg_bits) > max_bits) {
-		do_error("Group descriptor #%llu has bit count of %u",
+		do_error("Group descriptor #%llu has bit count of %u\n",
 			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_bits));
 		return -EINVAL;
@@ -254,7 +253,7 @@ static int ocfs2_validate_gd_parent(stru
 	     le16_to_cpu(di->id2.i_chain.cl_next_free_rec)) ||
 	    ((le16_to_cpu(gd->bg_chain) ==
 	     le16_to_cpu(di->id2.i_chain.cl_next_free_rec)) && !resize)) {
-		do_error("Group descriptor #%llu has bad chain %u",
+		do_error("Group descriptor #%llu has bad chain %u\n",
 			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_chain));
 		return -EINVAL;
diff -puN fs/ocfs2/super.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort
+++ a/fs/ocfs2/super.c
@@ -2598,7 +2598,7 @@ void __ocfs2_abort(struct super_block *s
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk(KERN_CRIT "OCFS2: abort (device %s): %s: %pV\n",
+	printk(KERN_CRIT "OCFS2: abort (device %s): %s: %pV",
 	       sb->s_id, function, &vaf);
 
 	va_end(args);
diff -puN fs/ocfs2/super.h~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort fs/ocfs2/super.h
--- a/fs/ocfs2/super.h~ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort
+++ a/fs/ocfs2/super.h
@@ -35,13 +35,15 @@ __printf(3, 4)
 void __ocfs2_error(struct super_block *sb, const char *function,
 		   const char *fmt, ...);
 
-#define ocfs2_error(sb, fmt, args...) __ocfs2_error(sb, __PRETTY_FUNCTION__, fmt, ##args)
+#define ocfs2_error(sb, fmt, ...)					\
+	__ocfs2_error(sb, __PRETTY_FUNCTION__, fmt, ##__VA_ARGS__)
 
 __printf(3, 4)
 void __ocfs2_abort(struct super_block *sb, const char *function,
 		   const char *fmt, ...);
 
-#define ocfs2_abort(sb, fmt, args...) __ocfs2_abort(sb, __PRETTY_FUNCTION__, fmt, ##args)
+#define ocfs2_abort(sb, fmt, ...)					\
+	__ocfs2_abort(sb, __PRETTY_FUNCTION__, fmt, ##__VA_ARGS__)
 
 /*
  * Void signal blockers, because in-kernel sigprocmask() only fails
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-logging-remove-static-buffer-use-vsprintf-extension-%pv.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
cris-fasttimer-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
adfs-returning-correct-return-values.patch
linux-next.patch

