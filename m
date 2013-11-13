From: akpm@linux-foundation.org
Subject: [merged]
 fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:37:08 -0800
Message-ID: <5283e2f4.winRnR7n/FMv90mC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3KMUhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: [merged] fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits.patch removed from -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:08 -0800


The patch titled
     Subject: fs/ocfs2: remove unnecessary variable bits_wanted from ocfs2_calc_extend_credits
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: fs/ocfs2: remove unnecessary variable bits_wanted from ocfs2_calc_extend_credits

Code cleanup to remove unnecessary variable passed but never used
to ocfs2_calc_extend_credits.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c         |    3 +--
 fs/ocfs2/dir.c          |    4 ++--
 fs/ocfs2/file.c         |    3 +--
 fs/ocfs2/journal.h      |    3 +--
 fs/ocfs2/move_extents.c |    3 +--
 fs/ocfs2/refcounttree.c |    9 +++------
 fs/ocfs2/xattr.c        |   20 +++++++-------------
 7 files changed, 16 insertions(+), 29 deletions(-)

diff -puN fs/ocfs2/aops.c~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits
+++ a/fs/ocfs2/aops.c
@@ -1802,8 +1802,7 @@ try_again:
 			data_ac->ac_resv = &OCFS2_I(inode)->ip_la_data_resv;
 
 		credits = ocfs2_calc_extend_credits(inode->i_sb,
-						    &di->id2.i_list,
-						    clusters_to_alloc);
+						    &di->id2.i_list);
 
 	}
 
diff -puN fs/ocfs2/dir.c~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits
+++ a/fs/ocfs2/dir.c
@@ -3284,7 +3284,7 @@ static int ocfs2_extend_dir(struct ocfs2
 		if (ocfs2_dir_resv_allowed(osb))
 			data_ac->ac_resv = &OCFS2_I(dir)->ip_la_data_resv;
 
-		credits = ocfs2_calc_extend_credits(sb, el, 1);
+		credits = ocfs2_calc_extend_credits(sb, el);
 	} else {
 		spin_unlock(&OCFS2_I(dir)->ip_lock);
 		credits = OCFS2_SIMPLE_DIR_EXTEND_CREDITS;
@@ -3716,7 +3716,7 @@ static int ocfs2_dx_dir_rebalance_credit
 {
 	int credits = ocfs2_clusters_to_blocks(osb->sb, 2);
 
-	credits += ocfs2_calc_extend_credits(osb->sb, &dx_root->dr_list, 1);
+	credits += ocfs2_calc_extend_credits(osb->sb, &dx_root->dr_list);
 	credits += ocfs2_quota_trans_credits(osb->sb);
 	return credits;
 }
diff -puN fs/ocfs2/file.c~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits
+++ a/fs/ocfs2/file.c
@@ -603,8 +603,7 @@ restart_all:
 		goto leave;
 	}
 
-	credits = ocfs2_calc_extend_credits(osb->sb, &fe->id2.i_list,
-					    clusters_to_add);
+	credits = ocfs2_calc_extend_credits(osb->sb, &fe->id2.i_list);
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
diff -puN fs/ocfs2/journal.h~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits fs/ocfs2/journal.h
--- a/fs/ocfs2/journal.h~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits
+++ a/fs/ocfs2/journal.h
@@ -524,8 +524,7 @@ static inline int ocfs2_calc_dxi_expand_
  * the result may be wrong.
  */
 static inline int ocfs2_calc_extend_credits(struct super_block *sb,
-					    struct ocfs2_extent_list *root_el,
-					    u32 bits_wanted)
+					    struct ocfs2_extent_list *root_el)
 {
 	int bitmap_blocks, sysfile_bitmap_blocks, extent_blocks;
 
diff -puN fs/ocfs2/move_extents.c~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits
+++ a/fs/ocfs2/move_extents.c
@@ -201,8 +201,7 @@ static int ocfs2_lock_allocators_move_ex
 		}
 	}
 
-	*credits += ocfs2_calc_extend_credits(osb->sb, et->et_root_el,
-					      clusters_to_move + 2);
+	*credits += ocfs2_calc_extend_credits(osb->sb, et->et_root_el);
 
 	mlog(0, "reserve metadata_blocks: %d, data_clusters: %u, credits: %d\n",
 	     extra_blocks, clusters_to_move, *credits);
diff -puN fs/ocfs2/refcounttree.c~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits
+++ a/fs/ocfs2/refcounttree.c
@@ -2502,8 +2502,7 @@ static int ocfs2_calc_refcount_meta_cred
 		ocfs2_init_refcount_extent_tree(&et, ci, ref_root_bh);
 		*meta_add += ocfs2_extend_meta_needed(et.et_root_el);
 		*credits += ocfs2_calc_extend_credits(sb,
-						      et.et_root_el,
-						      ref_blocks);
+						      et.et_root_el);
 	} else {
 		*credits += OCFS2_EXPAND_REFCOUNT_TREE_CREDITS;
 		*meta_add += 1;
@@ -2874,8 +2873,7 @@ static int ocfs2_lock_refcount_allocator
 		meta_add =
 			ocfs2_extend_meta_needed(et->et_root_el);
 
-	*credits += ocfs2_calc_extend_credits(sb, et->et_root_el,
-					      num_clusters + 2);
+	*credits += ocfs2_calc_extend_credits(sb, et->et_root_el);
 
 	ret = ocfs2_calc_refcount_meta_credits(sb, ref_ci, ref_root_bh,
 					       p_cluster, num_clusters,
@@ -3625,8 +3623,7 @@ int ocfs2_refcounted_xattr_delete_need(s
 
 		ocfs2_init_refcount_extent_tree(&et, ref_ci, ref_root_bh);
 		*credits += ocfs2_calc_extend_credits(inode->i_sb,
-						      et.et_root_el,
-						      ref_blocks);
+						      et.et_root_el);
 	}
 
 out:
diff -puN fs/ocfs2/xattr.c~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits
+++ a/fs/ocfs2/xattr.c
@@ -754,8 +754,7 @@ static int ocfs2_xattr_extend_allocation
 			BUG_ON(why == RESTART_META);
 
 			credits = ocfs2_calc_extend_credits(inode->i_sb,
-							    &vb->vb_xv->xr_list,
-							    clusters_to_add);
+							    &vb->vb_xv->xr_list);
 			status = ocfs2_extend_trans(handle, credits);
 			if (status < 0) {
 				status = -ENOMEM;
@@ -3040,8 +3039,7 @@ static int ocfs2_calc_xattr_set_need(str
 		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
 			clusters_add += new_clusters;
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
-							&def_xv.xv.xr_list,
-							new_clusters);
+							&def_xv.xv.xr_list);
 		}
 
 		goto meta_guess;
@@ -3106,8 +3104,7 @@ static int ocfs2_calc_xattr_set_need(str
 			if (!ocfs2_xattr_is_local(xe))
 				credits += ocfs2_calc_extend_credits(
 							inode->i_sb,
-							&def_xv.xv.xr_list,
-							new_clusters);
+							&def_xv.xv.xr_list);
 			goto out;
 		}
 	}
@@ -3132,9 +3129,7 @@ static int ocfs2_calc_xattr_set_need(str
 			meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
 			clusters_add += new_clusters - old_clusters;
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
-							     &xv->xr_list,
-							     new_clusters -
-							     old_clusters);
+							     &xv->xr_list);
 			if (value_size >= OCFS2_XATTR_ROOT_SIZE)
 				goto out;
 		}
@@ -3180,7 +3175,7 @@ meta_guess:
 				 &xb->xb_attrs.xb_root.xt_list;
 			meta_add += ocfs2_extend_meta_needed(el);
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
-							     el, 1);
+							     el);
 		} else
 			credits += OCFS2_SUBALLOC_ALLOC + 1;
 
@@ -6216,8 +6211,7 @@ static int ocfs2_value_metas_in_xattr_he
 			  le16_to_cpu(xv->xr_list.l_next_free_rec);
 
 		*credits += ocfs2_calc_extend_credits(sb,
-						&def_xv.xv.xr_list,
-						le32_to_cpu(xv->xr_clusters));
+						&def_xv.xv.xr_list);
 
 		/*
 		 * If the value is a tree with depth > 1, We don't go deep
@@ -6782,7 +6776,7 @@ static int ocfs2_lock_reflink_xattr_rec_
 		metas.num_metas += ocfs2_extend_meta_needed(xt_et->et_root_el);
 
 	*credits += ocfs2_calc_extend_credits(osb->sb,
-					      xt_et->et_root_el, len);
+					      xt_et->et_root_el);
 
 	if (metas.num_metas) {
 		ret = ocfs2_reserve_new_metadata_blocks(osb, metas.num_metas,
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

origin.patch
add-clustername-to-cluster-connection.patch
add-dlm-recovery-callbacks.patch
shift-allocation-ocfs2_live_connection-to-user_connect.patch
pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch
framework-for-version-lvb.patch
use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

