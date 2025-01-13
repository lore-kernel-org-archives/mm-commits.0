Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D838A25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742224; cv=none; b=RwCs2BXYvs9t1XE70ZuTsIkjTbOedyYYYNoogKKcEC9fjtBvyqCTYFXQjB+ydae7JczNlfHWeJrdx1FGLNnsocOAq6s8B2ytmtMutSImGsh6b4F6O8JH3zImTgx4lTa+7mTsy5fWgSpbiboBlqtvQEgwYDM4eqemEOzh2mKxIiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742224; c=relaxed/simple;
	bh=txHAC4K2pNS161MaqwG9BZH15S2Assxc6OrDSz1JhG0=;
	h=Date:To:From:Subject:Message-Id; b=eEgrQyAVNdQ1jID9Os9UqdXPSVwfWAOe5an6im147QPq57aVPsaY1CTdecGLPzaSKftZRkp+sqQmEYinkw9sk9LnEg7VdFxpLEKYfpRAdoeI3tY0yc1hgWsk8Y/lIF1xu16a0I//rYHQYDUlc0pbKcEXpjjD+2Wywg4skl7EgZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pla4k5GM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pla4k5GM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66C2C4CED6;
	Mon, 13 Jan 2025 04:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742224;
	bh=txHAC4K2pNS161MaqwG9BZH15S2Assxc6OrDSz1JhG0=;
	h=Date:To:From:Subject:From;
	b=pla4k5GM9tNfDm5yGzWYwrKUVbe7eXSDz4TT3H8bbUH92h89I6AjraG+WaVyArWbQ
	 YvChcHu3PTgRt2UOeR7c+1Q3cgiM+t8ISzI9E/gvhHDAI7ESsvP3toxlzlnvyq2V0D
	 fpXCzfvrQB0lrHCDfnzp9ypmpo4WqZNuRLtRqT7c=
Date: Sun, 12 Jan 2025 20:23:44 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-convert-ocfs2_read_inline_data-to-take-a-folio.patch removed from -mm tree
Message-Id: <20250113042344.A66C2C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: convert ocfs2_read_inline_data() to take a folio
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-ocfs2_read_inline_data-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ocfs2: convert ocfs2_read_inline_data() to take a folio
Date: Thu, 5 Dec 2024 17:16:47 +0000

All callers now have a folio, so pass it in.  We can use folio_fill_tail()
instead of open-coding it.  Saves a call to compound_head().

Link: https://lkml.kernel.org/r/20241205171653.3179945-20-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 fs/ocfs2/aops.c  |   20 ++++++--------------
 fs/ocfs2/aops.h  |    2 +-
 3 files changed, 8 insertions(+), 16 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-convert-ocfs2_read_inline_data-to-take-a-folio
+++ a/fs/ocfs2/alloc.c
@@ -7135,7 +7135,7 @@ int ocfs2_convert_inline_data_to_extents
 		 * This should populate the 1st page for us and mark
 		 * it up to date.
 		 */
-		ret = ocfs2_read_inline_data(inode, &folio->page, di_bh);
+		ret = ocfs2_read_inline_data(inode, folio, di_bh);
 		if (ret) {
 			mlog_errno(ret);
 			need_free = 1;
--- a/fs/ocfs2/aops.c~ocfs2-convert-ocfs2_read_inline_data-to-take-a-folio
+++ a/fs/ocfs2/aops.c
@@ -215,10 +215,9 @@ bail:
 	return err;
 }
 
-int ocfs2_read_inline_data(struct inode *inode, struct page *page,
+int ocfs2_read_inline_data(struct inode *inode, struct folio *folio,
 			   struct buffer_head *di_bh)
 {
-	void *kaddr;
 	loff_t size;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
@@ -230,7 +229,7 @@ int ocfs2_read_inline_data(struct inode
 
 	size = i_size_read(inode);
 
-	if (size > PAGE_SIZE ||
+	if (size > folio_size(folio) ||
 	    size > ocfs2_max_inline_data_with_xattr(inode->i_sb, di)) {
 		ocfs2_error(inode->i_sb,
 			    "Inode %llu has with inline data has bad size: %Lu\n",
@@ -239,15 +238,8 @@ int ocfs2_read_inline_data(struct inode
 		return -EROFS;
 	}
 
-	kaddr = kmap_atomic(page);
-	if (size)
-		memcpy(kaddr, di->id2.i_data.id_data, size);
-	/* Clear the remaining part of the page */
-	memset(kaddr + size, 0, PAGE_SIZE - size);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr);
-
-	SetPageUptodate(page);
+	folio_fill_tail(folio, 0, di->id2.i_data.id_data, size);
+	folio_mark_uptodate(folio);
 
 	return 0;
 }
@@ -266,7 +258,7 @@ static int ocfs2_readpage_inline(struct
 		goto out;
 	}
 
-	ret = ocfs2_read_inline_data(inode, &folio->page, di_bh);
+	ret = ocfs2_read_inline_data(inode, folio, di_bh);
 out:
 	folio_unlock(folio);
 
@@ -1506,7 +1498,7 @@ static int ocfs2_write_begin_inline(stru
 		ocfs2_set_inode_data_inline(inode, di);
 
 	if (!folio_test_uptodate(folio)) {
-		ret = ocfs2_read_inline_data(inode, &folio->page, wc->w_di_bh);
+		ret = ocfs2_read_inline_data(inode, folio, wc->w_di_bh);
 		if (ret) {
 			ocfs2_commit_trans(osb, handle);
 
--- a/fs/ocfs2/aops.h~ocfs2-convert-ocfs2_read_inline_data-to-take-a-folio
+++ a/fs/ocfs2/aops.h
@@ -41,7 +41,7 @@ int ocfs2_write_begin_nolock(struct addr
 		struct folio **foliop, void **fsdata,
 		struct buffer_head *di_bh, struct folio *mmap_folio);
 
-int ocfs2_read_inline_data(struct inode *inode, struct page *page,
+int ocfs2_read_inline_data(struct inode *inode, struct folio *folio,
 			   struct buffer_head *di_bh);
 int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch
mm-remove-pagetranstail.patch

