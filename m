Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4240010F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327676; cv=none; b=QNuygG5xTUQQ2G6zm9n0y2oWakxIBtSvayF2IzKTDKO8XY+Qdplpw7jQukCBNVpjzM9VG1DISvWw36F/hu1ITjoRmWcrv2fbIQwxXC6TW58F7ekkzwamTT4BTUpViH5gsxch6rI6YLowDhu7wIiVVRahl2YRF8Ar4m7Lk7MBNc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327676; c=relaxed/simple;
	bh=e7PMljtczxBabM20kMY+dIJqCiJvUymJ8AviAEDGC4E=;
	h=Date:To:From:Subject:Message-Id; b=dSbSxhtUog8NHaPWfum+J8VZA3rKFOnoATCsyMyTg7nITJ9YuuIs1bOKqcdVnWLzv9HafK1wF3q7N0YOl5mB35kGITF79f8i4hQvRq7oLZS5Oi8z1HEkHaaXfkym9C3ofFuuw9LykYH2ZTLQLEe0bY21AWLDTyg6l14mXN6jk+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=crRLE2+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="crRLE2+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E25C4CED0;
	Mon, 16 Dec 2024 05:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327676;
	bh=e7PMljtczxBabM20kMY+dIJqCiJvUymJ8AviAEDGC4E=;
	h=Date:To:From:Subject:From;
	b=crRLE2+cki60Z8aRfA9l7NaN7obQaxP/fmEScC7k56mCCWBD8CYgGweYxqotSs0Gz
	 P+LlrICCJOq+jFTQSKc362d4ZyGe+7TFYe7+x29nAPFtBTBQcWFl0zZyttyfEcJ6T4
	 4wbX54dCOYg+FGKLHI4h0+WUtkQgCJ8UfqReeSfk=
Date: Sun, 15 Dec 2024 21:41:15 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-an-array-of-folios-instead-of-an-array-of-pages.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054116.14E25C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use an array of folios instead of an array of pages
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-an-array-of-folios-instead-of-an-array-of-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-an-array-of-folios-instead-of-an-array-of-pages.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: use an array of folios instead of an array of pages
Date: Thu, 5 Dec 2024 17:16:44 +0000

The ocfs2_zero_cluster_folios() / ocfs2_grab_folios() /
ocfs2_grab_eof_folios() family of functions pass around an array of pages.
Convert them to pass around an array of folios.  This removes the last
caller of ocfs2_unlock_and_free_pages(), so delete it.

Link: https://lkml.kernel.org/r/20241205171653.3179945-17-willy@infradead.org
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   98 ++++++++++++++++++++++-----------------------
 fs/ocfs2/alloc.h |    2 
 fs/ocfs2/aops.c  |   13 -----
 fs/ocfs2/aops.h  |    1 
 4 files changed, 49 insertions(+), 65 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-use-an-array-of-folios-instead-of-an-array-of-pages
+++ a/fs/ocfs2/alloc.c
@@ -6847,87 +6847,87 @@ void ocfs2_map_and_dirty_page(struct ino
 	flush_dcache_folio(folio);
 }
 
-static void ocfs2_zero_cluster_pages(struct inode *inode, loff_t start,
-				     loff_t end, struct page **pages,
-				     int numpages, u64 phys, handle_t *handle)
+static void ocfs2_zero_cluster_folios(struct inode *inode, loff_t start,
+		loff_t end, struct folio **folios, int numfolios,
+		u64 phys, handle_t *handle)
 {
 	int i;
-	struct page *page;
 	unsigned int from, to = PAGE_SIZE;
 	struct super_block *sb = inode->i_sb;
 
 	BUG_ON(!ocfs2_sparse_alloc(OCFS2_SB(sb)));
 
-	if (numpages == 0)
+	if (numfolios == 0)
 		goto out;
 
 	to = PAGE_SIZE;
-	for(i = 0; i < numpages; i++) {
-		page = pages[i];
+	for (i = 0; i < numfolios; i++) {
+		struct folio *folio = folios[i];
 
 		from = start & (PAGE_SIZE - 1);
-		if ((end >> PAGE_SHIFT) == page->index)
+		if ((end >> PAGE_SHIFT) == folio->index)
 			to = end & (PAGE_SIZE - 1);
 
 		BUG_ON(from > PAGE_SIZE);
 		BUG_ON(to > PAGE_SIZE);
 
-		ocfs2_map_and_dirty_page(inode, handle, from, to, page, 1,
+		ocfs2_map_and_dirty_page(inode, handle, from, to, &folio->page, 1,
 					 &phys);
 
-		start = (page->index + 1) << PAGE_SHIFT;
+		start = (folio->index + 1) << PAGE_SHIFT;
 	}
 out:
-	if (pages)
-		ocfs2_unlock_and_free_pages(pages, numpages);
+	if (folios)
+		ocfs2_unlock_and_free_folios(folios, numfolios);
 }
 
-int ocfs2_grab_pages(struct inode *inode, loff_t start, loff_t end,
-		     struct page **pages, int *num)
+static int ocfs2_grab_folios(struct inode *inode, loff_t start, loff_t end,
+		struct folio **folios, int *num)
 {
-	int numpages, ret = 0;
+	int numfolios, ret = 0;
 	struct address_space *mapping = inode->i_mapping;
 	unsigned long index;
 	loff_t last_page_bytes;
 
 	BUG_ON(start > end);
 
-	numpages = 0;
+	numfolios = 0;
 	last_page_bytes = PAGE_ALIGN(end);
 	index = start >> PAGE_SHIFT;
 	do {
-		pages[numpages] = find_or_create_page(mapping, index, GFP_NOFS);
-		if (!pages[numpages]) {
-			ret = -ENOMEM;
+		folios[numfolios] = __filemap_get_folio(mapping, index,
+				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_NOFS);
+		if (IS_ERR(folios[numfolios])) {
+			ret = PTR_ERR(folios[numfolios]);
 			mlog_errno(ret);
 			goto out;
 		}
 
-		numpages++;
-		index++;
+		index = folio_next_index(folios[numfolios]);
+		numfolios++;
 	} while (index < (last_page_bytes >> PAGE_SHIFT));
 
 out:
 	if (ret != 0) {
-		if (pages)
-			ocfs2_unlock_and_free_pages(pages, numpages);
-		numpages = 0;
+		if (folios)
+			ocfs2_unlock_and_free_folios(folios, numfolios);
+		numfolios = 0;
 	}
 
-	*num = numpages;
+	*num = numfolios;
 
 	return ret;
 }
 
-static int ocfs2_grab_eof_pages(struct inode *inode, loff_t start, loff_t end,
-				struct page **pages, int *num)
+static int ocfs2_grab_eof_folios(struct inode *inode, loff_t start, loff_t end,
+				struct folio **folios, int *num)
 {
 	struct super_block *sb = inode->i_sb;
 
 	BUG_ON(start >> OCFS2_SB(sb)->s_clustersize_bits !=
 	       (end - 1) >> OCFS2_SB(sb)->s_clustersize_bits);
 
-	return ocfs2_grab_pages(inode, start, end, pages, num);
+	return ocfs2_grab_folios(inode, start, end, folios, num);
 }
 
 /*
@@ -6941,8 +6941,8 @@ static int ocfs2_grab_eof_pages(struct i
 int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 				  u64 range_start, u64 range_end)
 {
-	int ret = 0, numpages;
-	struct page **pages = NULL;
+	int ret = 0, numfolios;
+	struct folio **folios = NULL;
 	u64 phys;
 	unsigned int ext_flags;
 	struct super_block *sb = inode->i_sb;
@@ -6955,17 +6955,17 @@ int ocfs2_zero_range_for_truncate(struct
 		return 0;
 
 	/*
-	 * Avoid zeroing pages fully beyond current i_size. It is pointless as
-	 * underlying blocks of those pages should be already zeroed out and
+	 * Avoid zeroing folios fully beyond current i_size. It is pointless as
+	 * underlying blocks of those folios should be already zeroed out and
 	 * page writeback will skip them anyway.
 	 */
 	range_end = min_t(u64, range_end, i_size_read(inode));
 	if (range_start >= range_end)
 		return 0;
 
-	pages = kcalloc(ocfs2_pages_per_cluster(sb),
-			sizeof(struct page *), GFP_NOFS);
-	if (pages == NULL) {
+	folios = kcalloc(ocfs2_pages_per_cluster(sb),
+			sizeof(struct folio *), GFP_NOFS);
+	if (folios == NULL) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
@@ -6986,18 +6986,18 @@ int ocfs2_zero_range_for_truncate(struct
 	if (phys == 0 || ext_flags & OCFS2_EXT_UNWRITTEN)
 		goto out;
 
-	ret = ocfs2_grab_eof_pages(inode, range_start, range_end, pages,
-				   &numpages);
+	ret = ocfs2_grab_eof_folios(inode, range_start, range_end, folios,
+				   &numfolios);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ocfs2_zero_cluster_pages(inode, range_start, range_end, pages,
-				 numpages, phys, handle);
+	ocfs2_zero_cluster_folios(inode, range_start, range_end, folios,
+				 numfolios, phys, handle);
 
 	/*
-	 * Initiate writeout of the pages we zero'd here. We don't
+	 * Initiate writeout of the folios we zero'd here. We don't
 	 * wait on them - the truncate_inode_pages() call later will
 	 * do that for us.
 	 */
@@ -7007,7 +7007,7 @@ int ocfs2_zero_range_for_truncate(struct
 		mlog_errno(ret);
 
 out:
-	kfree(pages);
+	kfree(folios);
 
 	return ret;
 }
@@ -7060,7 +7060,7 @@ void ocfs2_set_inode_data_inline(struct
 int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 					 struct buffer_head *di_bh)
 {
-	int ret, has_data, num_pages = 0;
+	int ret, has_data, num_folios = 0;
 	int need_free = 0;
 	u32 bit_off, num;
 	handle_t *handle;
@@ -7069,7 +7069,7 @@ int ocfs2_convert_inline_data_to_extents
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_alloc_context *data_ac = NULL;
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct ocfs2_extent_tree et;
 	int did_quota = 0;
 
@@ -7124,8 +7124,8 @@ int ocfs2_convert_inline_data_to_extents
 		 */
 		block = phys = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
 
-		ret = ocfs2_grab_eof_pages(inode, 0, page_end, &page,
-					   &num_pages);
+		ret = ocfs2_grab_eof_folios(inode, 0, page_end, &folio,
+					   &num_folios);
 		if (ret) {
 			mlog_errno(ret);
 			need_free = 1;
@@ -7136,14 +7136,14 @@ int ocfs2_convert_inline_data_to_extents
 		 * This should populate the 1st page for us and mark
 		 * it up to date.
 		 */
-		ret = ocfs2_read_inline_data(inode, page, di_bh);
+		ret = ocfs2_read_inline_data(inode, &folio->page, di_bh);
 		if (ret) {
 			mlog_errno(ret);
 			need_free = 1;
 			goto out_unlock;
 		}
 
-		ocfs2_map_and_dirty_page(inode, handle, 0, page_end, page, 0,
+		ocfs2_map_and_dirty_page(inode, handle, 0, page_end, &folio->page, 0,
 					 &phys);
 	}
 
@@ -7175,8 +7175,8 @@ int ocfs2_convert_inline_data_to_extents
 	}
 
 out_unlock:
-	if (page)
-		ocfs2_unlock_and_free_pages(&page, num_pages);
+	if (folio)
+		ocfs2_unlock_and_free_folios(&folio, num_folios);
 
 out_commit:
 	if (ret < 0 && did_quota)
--- a/fs/ocfs2/alloc.h~ocfs2-use-an-array-of-folios-instead-of-an-array-of-pages
+++ a/fs/ocfs2/alloc.h
@@ -254,8 +254,6 @@ static inline int ocfs2_is_empty_extent(
 	return !rec->e_leaf_clusters;
 }
 
-int ocfs2_grab_pages(struct inode *inode, loff_t start, loff_t end,
-		     struct page **pages, int *num);
 void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
 			      unsigned int from, unsigned int to,
 			      struct page *page, int zero, u64 *phys);
--- a/fs/ocfs2/aops.c~ocfs2-use-an-array-of-folios-instead-of-an-array-of-pages
+++ a/fs/ocfs2/aops.c
@@ -783,19 +783,6 @@ void ocfs2_unlock_and_free_folios(struct
 	}
 }
 
-void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
-{
-	int i;
-
-	for(i = 0; i < num_pages; i++) {
-		if (pages[i]) {
-			unlock_page(pages[i]);
-			mark_page_accessed(pages[i]);
-			put_page(pages[i]);
-		}
-	}
-}
-
 static void ocfs2_unlock_folios(struct ocfs2_write_ctxt *wc)
 {
 	int i;
--- a/fs/ocfs2/aops.h~ocfs2-use-an-array-of-folios-instead-of-an-array-of-pages
+++ a/fs/ocfs2/aops.h
@@ -18,7 +18,6 @@ int ocfs2_map_folio_blocks(struct folio
 			  unsigned int to, int new);
 
 void ocfs2_unlock_and_free_folios(struct folio **folios, int num_folios);
-void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages);
 
 int walk_page_buffers(	handle_t *handle,
 			struct buffer_head *head,
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are

ocfs2-convert-w_target_page-to-w_target_folio.patch
ocfs2-use-a-folio-in-ocfs2_zero_new_buffers.patch
ocfs2-use-a-folio-in-ocfs2_write_begin_inline.patch
ocfs2-convert-ocfs2_readpage_inline-to-take-a-folio.patch
ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio.patch
ocfs2-convert-w_pages-to-w_folios.patch
ocfs2-convert-ocfs2_write_failure-to-use-a-folio.patch
ocfs2-use-a-folio-in-ocfs2_write_end_nolock.patch
ocfs2-use-a-folio-in-ocfs2_prepare_page_for_write.patch
ocfs2-use-a-folio-in-ocfs2_map_and_dirty_page.patch
ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks.patch
ocfs2-convert-ocfs2_clear_page_regions-to-ocfs2_clear_folio_regions.patch
ocfs2-use-an-array-of-folios-instead-of-an-array-of-pages.patch
ocfs2-convert-ocfs2_duplicate_clusters_by_page-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio.patch
ocfs2-support-large-folios-in-ocfs2_zero_cluster_folios.patch
ocfs2-support-large-folios-in-ocfs2_write_zero_page.patch

