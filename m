From: akpm@linux-foundation.org
Subject: [alternative-merged]
 ocfs2-dont-merge-rightmost-extent-block-if-it-was-locked.patch removed from -mm tree
Date: Thu, 28 Dec 2017 16:14:54 -0800
Message-ID: <5a4588fe.R6LvfsCsWBSkLnMu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44806 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbdL2AO4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Dec 2017 19:14:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, john@nixnuts.net, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: don't merge rightmost extent block if it was locked
has been removed from the -mm tree.  Its filename was
     ocfs2-dont-merge-rightmost-extent-block-if-it-was-locked.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Changwei Ge <ge.changwei@h3c.com>
Subject: ocfs2: don't merge rightmost extent block if it was locked

A crash issue was reported by John.

The call trace follows:
ocfs2_split_extent+0x1ad3/0x1b40 [ocfs2]
ocfs2_change_extent_flag+0x33a/0x470 [ocfs2]
ocfs2_mark_extent_written+0x172/0x220 [ocfs2]
ocfs2_dio_end_io+0x62d/0x910 [ocfs2]
dio_complete+0x19a/0x1a0
do_blockdev_direct_IO+0x19dd/0x1eb0
__blockdev_direct_IO+0x43/0x50
ocfs2_direct_IO+0x8f/0xa0 [ocfs2]
generic_file_direct_write+0xb2/0x170
__generic_file_write_iter+0xc3/0x1b0
ocfs2_file_write_iter+0x4bb/0xca0 [ocfs2]
__vfs_write+0xae/0xf0
vfs_write+0xb8/0x1b0
SyS_write+0x4f/0xb0
system_call_fastpath+0x16/0x75

The BUG code told that extent tree wants to grow but no metadata was
reserved ahead of time.

From my investigation into this issue, the root cause it that although
enough metadata is reserved, rightmost extent is merged into left one due
to a certain times of marking extent written.  Because during marking
extent written, we got many physically continuous extents.  At last, an
empty extent showed up and the rightmost path is removed from extent tree.

In order to solve this issue, introduce a member named ::et_lock for
extent tree.  When ocfs2_lock_allocators is invoked and we indeed need to
reserve metadata, set ::et_lock so that the rightmost path won't be
removed during marking extents written.

Also, this patch address the issue John reported that ::dw_zero_count is
not calculated properly.

After applying this patch, the issue John reported was gone.  Thanks to
the reproducer provided by John.  And this patch has passed ocfs2-test
suite running by New H3C Group.

Link: http://lkml.kernel.org/r/63ADC13FD55D6546B7DECE290D39E373F290800A@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reported-by: John Lightsey <john@nixnuts.net>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c    |    4 +++-
 fs/ocfs2/alloc.h    |    1 +
 fs/ocfs2/aops.c     |    9 ++++++---
 fs/ocfs2/suballoc.c |    3 +++
 4 files changed, 13 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-dont-merge-rightmost-extent-block-if-it-was-locked fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-dont-merge-rightmost-extent-block-if-it-was-locked
+++ a/fs/ocfs2/alloc.c
@@ -444,6 +444,7 @@ static void __ocfs2_init_extent_tree(str
 	et->et_ops = ops;
 	et->et_root_bh = bh;
 	et->et_ci = ci;
+	et->et_lock = 0;
 	et->et_root_journal_access = access;
 	if (!obj)
 		obj = (void *)bh->b_data;
@@ -3606,7 +3607,8 @@ static int ocfs2_merge_rec_left(struct o
 		 * it and we need to delete the right extent block.
 		 */
 		if (le16_to_cpu(right_rec->e_leaf_clusters) == 0 &&
-		    le16_to_cpu(el->l_next_free_rec) == 1) {
+				le16_to_cpu(el->l_next_free_rec) == 1 &&
+				!et->et_lock) {
 			/* extend credit for ocfs2_remove_rightmost_path */
 			ret = ocfs2_extend_rotate_transaction(handle, 0,
 					handle->h_buffer_credits,
diff -puN fs/ocfs2/alloc.h~ocfs2-dont-merge-rightmost-extent-block-if-it-was-locked fs/ocfs2/alloc.h
--- a/fs/ocfs2/alloc.h~ocfs2-dont-merge-rightmost-extent-block-if-it-was-locked
+++ a/fs/ocfs2/alloc.h
@@ -61,6 +61,7 @@ struct ocfs2_extent_tree {
 	ocfs2_journal_access_func		et_root_journal_access;
 	void					*et_object;
 	unsigned int				et_max_leaf_clusters;
+	int					et_lock;
 };
 
 /*
diff -puN fs/ocfs2/aops.c~ocfs2-dont-merge-rightmost-extent-block-if-it-was-locked fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-dont-merge-rightmost-extent-block-if-it-was-locked
+++ a/fs/ocfs2/aops.c
@@ -797,6 +797,8 @@ struct ocfs2_write_ctxt {
 	struct ocfs2_cached_dealloc_ctxt w_dealloc;
 
 	struct list_head		w_unwritten_list;
+
+	unsigned int			w_unwritten_count;
 };
 
 void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
@@ -1386,6 +1388,7 @@ retry:
 	desc->c_clear_unwritten = 0;
 	list_add_tail(&new->ue_ip_node, &oi->ip_unwritten_list);
 	list_add_tail(&new->ue_node, &wc->w_unwritten_list);
+	wc->w_unwritten_count++;
 	new = NULL;
 unlock:
 	spin_unlock(&oi->ip_lock);
@@ -1762,8 +1765,8 @@ try_again:
 		 */
 		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode),
 					      wc->w_di_bh);
-		ret = ocfs2_lock_allocators(inode, &et,
-					    clusters_to_alloc, extents_to_split,
+		ret = ocfs2_lock_allocators(inode, &et, clusters_to_alloc,
+					    2*extents_to_split,
 					    &data_ac, &meta_ac);
 		if (ret) {
 			mlog_errno(ret);
@@ -2256,7 +2259,7 @@ static int ocfs2_dio_wr_get_block(struct
 		ue->ue_phys = desc->c_phys;
 
 		list_splice_tail_init(&wc->w_unwritten_list, &dwc->dw_zero_list);
-		dwc->dw_zero_count++;
+		dwc->dw_zero_count += wc->w_unwritten_count;
 	}
 
 	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, wc);
diff -puN fs/ocfs2/suballoc.c~ocfs2-dont-merge-rightmost-extent-block-if-it-was-locked fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-dont-merge-rightmost-extent-block-if-it-was-locked
+++ a/fs/ocfs2/suballoc.c
@@ -2727,6 +2727,9 @@ int ocfs2_lock_allocators(struct inode *
 		}
 	}
 
+	if (extents_to_split)
+		et->et_lock = 1;
+
 	if (clusters_to_add == 0)
 		goto out;
 
_

Patches currently in -mm which might be from ge.changwei@h3c.com are

ocfs2-dlm-clean-dead-code-up.patch
ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch
ocfs2-clean-dead-code-in-suballocc.patch
ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing.patch

