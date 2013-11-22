From: akpm@linux-foundation.org
Subject: +
 ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters.patch added to -mm tree
Date: Fri, 22 Nov 2013 14:22:43 -0800
Message-ID: <528fd933.VUJxdwiIMD3o/bp/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3KVWWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 17:22:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, lizefan@huawei.com, joseph.qi@huawei.com, jlbec@evilplan.org, wangzongxun@huawei.com

Subject: + ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters.patch added to -mm tree
To: wangzongxun@huawei.com,jlbec@evilplan.org,joseph.qi@huawei.com,lizefan@huawei.com,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 14:22:43 -0800


The patch titled
     Subject: ocfs2: free allocated clusters if error occurs after ocfs2_claim_clusters
has been added to the -mm tree.  Its filename is
     ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zongxun Wang <wangzongxun@huawei.com>
Subject: ocfs2: free allocated clusters if error occurs after ocfs2_claim_clusters

Even if using the same jbd2 handle, we cannot rollback a transaction.  So
once some error occurs after successfully allocating clusters, the
allocated clusters will never be used and it means they are lost.  For
example, call ocfs2_claim_clusters successfully when expanding a file, but
failed in ocfs2_insert_extent.  So we need free the allocated clusters if
they are not used indeed.

Signed-off-by: Zongxun Wang <wangzongxun@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c      |   38 +++++++++++++++++++++++++++++++++++---
 fs/ocfs2/localalloc.c |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/localalloc.h |    6 ++++++
 3 files changed, 81 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters
+++ a/fs/ocfs2/alloc.c
@@ -4742,6 +4742,7 @@ int ocfs2_add_clusters_in_btree(handle_t
 				enum ocfs2_alloc_restarted *reason_ret)
 {
 	int status = 0, err = 0;
+	int need_free = 0;
 	int free_extents;
 	enum ocfs2_alloc_restarted reason = RESTART_NONE;
 	u32 bit_off, num_bits;
@@ -4796,7 +4797,8 @@ int ocfs2_add_clusters_in_btree(handle_t
 					      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		need_free = 1;
+		goto bail;
 	}
 
 	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);
@@ -4807,7 +4809,8 @@ int ocfs2_add_clusters_in_btree(handle_t
 				     num_bits, flags, meta_ac);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		need_free = 1;
+		goto bail;
 	}
 
 	ocfs2_journal_dirty(handle, et->et_root_bh);
@@ -4821,6 +4824,19 @@ int ocfs2_add_clusters_in_btree(handle_t
 		reason = RESTART_TRANS;
 	}
 
+bail:
+	if (need_free) {
+		if (data_ac->ac_which == OCFS2_AC_USE_LOCAL)
+			ocfs2_free_local_alloc_bits(osb, handle, data_ac,
+					bit_off, num_bits);
+		else
+			ocfs2_free_clusters(handle,
+					data_ac->ac_inode,
+					data_ac->ac_bh,
+					ocfs2_clusters_to_blocks(osb->sb, bit_off),
+					num_bits);
+	}
+
 leave:
 	if (reason_ret)
 		*reason_ret = reason;
@@ -6805,6 +6821,8 @@ int ocfs2_convert_inline_data_to_extents
 					 struct buffer_head *di_bh)
 {
 	int ret, i, has_data, num_pages = 0;
+	int need_free = 0;
+	u32 bit_off, num;
 	handle_t *handle;
 	u64 uninitialized_var(block);
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
@@ -6850,7 +6868,6 @@ int ocfs2_convert_inline_data_to_extents
 	}
 
 	if (has_data) {
-		u32 bit_off, num;
 		unsigned int page_end;
 		u64 phys;
 
@@ -6886,6 +6903,7 @@ int ocfs2_convert_inline_data_to_extents
 		ret = ocfs2_grab_eof_pages(inode, 0, end, pages, &num_pages);
 		if (ret) {
 			mlog_errno(ret);
+			need_free = 1;
 			goto out_commit;
 		}
 
@@ -6896,6 +6914,7 @@ int ocfs2_convert_inline_data_to_extents
 		ret = ocfs2_read_inline_data(inode, pages[0], di_bh);
 		if (ret) {
 			mlog_errno(ret);
+			need_free = 1;
 			goto out_commit;
 		}
 
@@ -6927,6 +6946,7 @@ int ocfs2_convert_inline_data_to_extents
 		ret = ocfs2_insert_extent(handle, &et, 0, block, 1, 0, NULL);
 		if (ret) {
 			mlog_errno(ret);
+			need_free = 1;
 			goto out_commit;
 		}
 
@@ -6938,6 +6958,18 @@ out_commit:
 		dquot_free_space_nodirty(inode,
 					  ocfs2_clusters_to_bytes(osb->sb, 1));
 
+	if (need_free) {
+		if (data_ac->ac_which == OCFS2_AC_USE_LOCAL)
+			ocfs2_free_local_alloc_bits(osb, handle, data_ac,
+					bit_off, num);
+		else
+			ocfs2_free_clusters(handle,
+					data_ac->ac_inode,
+					data_ac->ac_bh,
+					ocfs2_clusters_to_blocks(osb->sb, bit_off),
+					num);
+	}
+
 	ocfs2_commit_trans(osb, handle);
 
 out_unlock:
diff -puN fs/ocfs2/localalloc.c~ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters
+++ a/fs/ocfs2/localalloc.c
@@ -781,6 +781,46 @@ bail:
 	return status;
 }
 
+int ocfs2_free_local_alloc_bits(struct ocfs2_super *osb,
+				handle_t *handle,
+				struct ocfs2_alloc_context *ac,
+				u32 bit_off,
+				u32 num_bits)
+{
+	int status, start;
+	struct inode *local_alloc_inode;
+	void *bitmap;
+	struct ocfs2_dinode *alloc;
+	struct ocfs2_local_alloc *la;
+
+	BUG_ON(ac->ac_which != OCFS2_AC_USE_LOCAL);
+
+	local_alloc_inode = ac->ac_inode;
+	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
+	la = OCFS2_LOCAL_ALLOC(alloc);
+
+	bitmap = la->la_bitmap;
+	start = bit_off - le32_to_cpu(la->la_bm_off);
+
+	status = ocfs2_journal_access_di(handle,
+			INODE_CACHE(local_alloc_inode),
+			osb->local_alloc_bh,
+			OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	while (num_bits--)
+		ocfs2_clear_bit(start++, bitmap);
+
+	le32_add_cpu(&alloc->id1.bitmap1.i_used, -num_bits);
+	ocfs2_journal_dirty(handle, osb->local_alloc_bh);
+
+bail:
+	return status;
+}
+
 static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc)
 {
 	u32 count;
diff -puN fs/ocfs2/localalloc.h~ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters fs/ocfs2/localalloc.h
--- a/fs/ocfs2/localalloc.h~ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters
+++ a/fs/ocfs2/localalloc.h
@@ -55,6 +55,12 @@ int ocfs2_claim_local_alloc_bits(struct
 				 u32 *bit_off,
 				 u32 *num_bits);
 
+int ocfs2_free_local_alloc_bits(struct ocfs2_super *osb,
+				handle_t *handle,
+				struct ocfs2_alloc_context *ac,
+				u32 bit_off,
+				u32 num_bits);
+
 void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
 				      unsigned int num_clusters);
 void ocfs2_la_enable_worker(struct work_struct *work);
_

Patches currently in -mm which might be from wangzongxun@huawei.com are

ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters.patch

