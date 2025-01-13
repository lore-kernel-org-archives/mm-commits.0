Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ADF158DAC
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742213; cv=none; b=L1hLcWQCjIfhXxefaUypX7ek5nwuaikr2gx2JN60boPQjW4+QvrV2u5EspcwcMcdb3AbVQwK0TRrGYonFtd+gShGn+nHgRg0oOYwMfXp5aO2c8mcQ1JKU/Tf5VRVigcLGNaP8KgqoMpzuioWmYjB2lANgTKHVInOo5Mh4qt0Vnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742213; c=relaxed/simple;
	bh=3iC+tdnfYEBZeC/MeYDa/lTGAiqM5LKfLiTKAekxPRk=;
	h=Date:To:From:Subject:Message-Id; b=n/uaTVuMtXEgLXAxQBVXZPuUPKpVBoHdBudd3f85dI8u6TQbmk85D6pQtRiiAucmzEiutDeHhuy30C+r9pa58QCOX8IZHksAhDmB7WIIObbIyjhbQn6VewAyamytii1I2H0PHZe94RYZiASpoGgqz9iiT2sgXAJMD/8xotWrgPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tpaXibJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tpaXibJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8BFC4CED6;
	Mon, 13 Jan 2025 04:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742213;
	bh=3iC+tdnfYEBZeC/MeYDa/lTGAiqM5LKfLiTKAekxPRk=;
	h=Date:To:From:Subject:From;
	b=tpaXibJtyLtaTMRMcPAI/noD9XmeIg7gFhIgjQTgy7YGcDbAT/zdAm+wkVYy49eKX
	 +DRowFVqwNxLWDQIL8pSzq+0/BmaRVlV3uM+IlbKrLReHXUxkCFRvGWpgO/MYwtZpv
	 XwGPbM9MCKYM0fqIQDJQ1SVbw61dBXH48Q6cRzDQ=
Date: Sun, 12 Jan 2025 20:23:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-convert-w_pages-to-w_folios.patch removed from -mm tree
Message-Id: <20250113042333.6C8BFC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: convert w_pages to w_folios
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-w_pages-to-w_folios.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: convert w_pages to w_folios
Date: Thu, 5 Dec 2024 17:16:37 +0000

Pass around an array of folios instead of an array of pages.  Removes a
few calls to compound_head().

Link: https://lkml.kernel.org/r/20241205171653.3179945-10-willy@infradead.org
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

 fs/ocfs2/aops.c |  118 ++++++++++++++++++++++++----------------------
 fs/ocfs2/aops.h |    1 
 2 files changed, 65 insertions(+), 54 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-convert-w_pages-to-w_folios
+++ a/fs/ocfs2/aops.c
@@ -729,19 +729,19 @@ struct ocfs2_write_ctxt {
 	unsigned int			w_large_pages;
 
 	/*
-	 * Pages involved in this write.
+	 * Folios involved in this write.
 	 *
 	 * w_target_folio is the folio being written to by the user.
 	 *
-	 * w_pages is an array of pages which always contains
+	 * w_folios is an array of folios which always contains
 	 * w_target_folio, and in the case of an allocating write with
 	 * page_size < cluster size, it will contain zero'd and mapped
 	 * pages adjacent to w_target_folio which need to be written
 	 * out in so that future reads from that region will get
 	 * zero's.
 	 */
-	unsigned int			w_num_pages;
-	struct page			*w_pages[OCFS2_MAX_CTXT_PAGES];
+	unsigned int			w_num_folios;
+	struct folio			*w_folios[OCFS2_MAX_CTXT_PAGES];
 	struct folio			*w_target_folio;
 
 	/*
@@ -771,6 +771,19 @@ struct ocfs2_write_ctxt {
 	unsigned int			w_unwritten_count;
 };
 
+void ocfs2_unlock_and_free_folios(struct folio **folios, int num_folios)
+{
+	int i;
+
+	for(i = 0; i < num_folios; i++) {
+		if (!folios[i])
+			continue;
+		folio_unlock(folios[i]);
+		folio_mark_accessed(folios[i]);
+		folio_put(folios[i]);
+	}
+}
+
 void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
 {
 	int i;
@@ -784,7 +797,7 @@ void ocfs2_unlock_and_free_pages(struct
 	}
 }
 
-static void ocfs2_unlock_pages(struct ocfs2_write_ctxt *wc)
+static void ocfs2_unlock_folios(struct ocfs2_write_ctxt *wc)
 {
 	int i;
 
@@ -795,16 +808,16 @@ static void ocfs2_unlock_pages(struct oc
 	 */
 	if (wc->w_target_locked) {
 		BUG_ON(!wc->w_target_folio);
-		for (i = 0; i < wc->w_num_pages; i++) {
-			if (&wc->w_target_folio->page == wc->w_pages[i]) {
-				wc->w_pages[i] = NULL;
+		for (i = 0; i < wc->w_num_folios; i++) {
+			if (wc->w_target_folio == wc->w_folios[i]) {
+				wc->w_folios[i] = NULL;
 				break;
 			}
 		}
 		folio_mark_accessed(wc->w_target_folio);
 		folio_put(wc->w_target_folio);
 	}
-	ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
+	ocfs2_unlock_and_free_folios(wc->w_folios, wc->w_num_folios);
 }
 
 static void ocfs2_free_unwritten_list(struct inode *inode,
@@ -826,7 +839,7 @@ static void ocfs2_free_write_ctxt(struct
 				  struct ocfs2_write_ctxt *wc)
 {
 	ocfs2_free_unwritten_list(inode, &wc->w_unwritten_list);
-	ocfs2_unlock_pages(wc);
+	ocfs2_unlock_folios(wc);
 	brelse(wc->w_di_bh);
 	kfree(wc);
 }
@@ -922,8 +935,8 @@ static void ocfs2_write_failure(struct i
 	if (wc->w_target_folio)
 		ocfs2_zero_new_buffers(wc->w_target_folio, from, to);
 
-	for(i = 0; i < wc->w_num_pages; i++) {
-		tmppage = wc->w_pages[i];
+	for (i = 0; i < wc->w_num_folios; i++) {
+		tmppage = &wc->w_folios[i]->page;
 
 		if (tmppage && page_has_buffers(tmppage)) {
 			if (ocfs2_should_order_data(inode))
@@ -935,12 +948,11 @@ static void ocfs2_write_failure(struct i
 	}
 }
 
-static int ocfs2_prepare_page_for_write(struct inode *inode, u64 *p_blkno,
-					struct ocfs2_write_ctxt *wc,
-					struct page *page, u32 cpos,
-					loff_t user_pos, unsigned user_len,
-					int new)
+static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
+		struct ocfs2_write_ctxt *wc, struct folio *folio, u32 cpos,
+		loff_t user_pos, unsigned user_len, int new)
 {
+	struct page *page = &folio->page;
 	int ret;
 	unsigned int map_from = 0, map_to = 0;
 	unsigned int cluster_start, cluster_end;
@@ -1019,11 +1031,9 @@ out:
 /*
  * This function will only grab one clusters worth of pages.
  */
-static int ocfs2_grab_pages_for_write(struct address_space *mapping,
-				      struct ocfs2_write_ctxt *wc,
-				      u32 cpos, loff_t user_pos,
-				      unsigned user_len, int new,
-				      struct folio *mmap_folio)
+static int ocfs2_grab_folios_for_write(struct address_space *mapping,
+		struct ocfs2_write_ctxt *wc, u32 cpos, loff_t user_pos,
+		unsigned user_len, int new, struct folio *mmap_folio)
 {
 	int ret = 0, i;
 	unsigned long start, target_index, end_index, index;
@@ -1040,7 +1050,7 @@ static int ocfs2_grab_pages_for_write(st
 	 * last page of the write.
 	 */
 	if (new) {
-		wc->w_num_pages = ocfs2_pages_per_cluster(inode->i_sb);
+		wc->w_num_folios = ocfs2_pages_per_cluster(inode->i_sb);
 		start = ocfs2_align_clusters_to_page_index(inode->i_sb, cpos);
 		/*
 		 * We need the index *past* the last page we could possibly
@@ -1050,15 +1060,15 @@ static int ocfs2_grab_pages_for_write(st
 		last_byte = max(user_pos + user_len, i_size_read(inode));
 		BUG_ON(last_byte < 1);
 		end_index = ((last_byte - 1) >> PAGE_SHIFT) + 1;
-		if ((start + wc->w_num_pages) > end_index)
-			wc->w_num_pages = end_index - start;
+		if ((start + wc->w_num_folios) > end_index)
+			wc->w_num_folios = end_index - start;
 	} else {
-		wc->w_num_pages = 1;
+		wc->w_num_folios = 1;
 		start = target_index;
 	}
 	end_index = (user_pos + user_len - 1) >> PAGE_SHIFT;
 
-	for(i = 0; i < wc->w_num_pages; i++) {
+	for(i = 0; i < wc->w_num_folios; i++) {
 		index = start + i;
 
 		if (index >= target_index && index <= end_index &&
@@ -1079,26 +1089,27 @@ static int ocfs2_grab_pages_for_write(st
 			}
 
 			folio_get(mmap_folio);
-			wc->w_pages[i] = &mmap_folio->page;
+			wc->w_folios[i] = mmap_folio;
 			wc->w_target_locked = true;
 		} else if (index >= target_index && index <= end_index &&
 			   wc->w_type == OCFS2_WRITE_DIRECT) {
 			/* Direct write has no mapping page. */
-			wc->w_pages[i] = NULL;
+			wc->w_folios[i] = NULL;
 			continue;
 		} else {
-			wc->w_pages[i] = find_or_create_page(mapping, index,
-							     GFP_NOFS);
-			if (!wc->w_pages[i]) {
-				ret = -ENOMEM;
+			wc->w_folios[i] = __filemap_get_folio(mapping, index,
+					FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+					GFP_NOFS);
+			if (IS_ERR(wc->w_folios[i])) {
+				ret = PTR_ERR(wc->w_folios[i]);
 				mlog_errno(ret);
 				goto out;
 			}
 		}
-		wait_for_stable_page(wc->w_pages[i]);
+		folio_wait_stable(wc->w_folios[i]);
 
 		if (index == target_index)
-			wc->w_target_folio = page_folio(wc->w_pages[i]);
+			wc->w_target_folio = wc->w_folios[i];
 	}
 out:
 	if (ret)
@@ -1182,19 +1193,18 @@ static int ocfs2_write_cluster(struct ad
 	if (!should_zero)
 		p_blkno += (user_pos >> inode->i_sb->s_blocksize_bits) & (u64)(bpc - 1);
 
-	for(i = 0; i < wc->w_num_pages; i++) {
+	for (i = 0; i < wc->w_num_folios; i++) {
 		int tmpret;
 
 		/* This is the direct io target page. */
-		if (wc->w_pages[i] == NULL) {
+		if (wc->w_folios[i] == NULL) {
 			p_blkno += (1 << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits));
 			continue;
 		}
 
-		tmpret = ocfs2_prepare_page_for_write(inode, &p_blkno, wc,
-						      wc->w_pages[i], cpos,
-						      user_pos, user_len,
-						      should_zero);
+		tmpret = ocfs2_prepare_folio_for_write(inode, &p_blkno, wc,
+				wc->w_folios[i], cpos, user_pos, user_len,
+				should_zero);
 		if (tmpret) {
 			mlog_errno(tmpret);
 			if (ret == 0)
@@ -1493,12 +1503,12 @@ static int ocfs2_write_begin_inline(stru
 		goto out;
 	}
 	/*
-	 * If we don't set w_num_pages then this folio won't get unlocked
+	 * If we don't set w_num_folios then this folio won't get unlocked
 	 * and freed on cleanup of the write context.
 	 */
 	wc->w_target_folio = folio;
-	wc->w_pages[0] = &folio->page;
-	wc->w_num_pages = 1;
+	wc->w_folios[0] = folio;
+	wc->w_num_folios = 1;
 
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1791,18 +1801,18 @@ try_again:
 	}
 
 	/*
-	 * Fill our page array first. That way we've grabbed enough so
+	 * Fill our folio array first. That way we've grabbed enough so
 	 * that we can zero and flush if we error after adding the
 	 * extent.
 	 */
-	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
-					 cluster_of_pages, mmap_folio);
+	ret = ocfs2_grab_folios_for_write(mapping, wc, wc->w_cpos, pos, len,
+			cluster_of_pages, mmap_folio);
 	if (ret) {
 		/*
-		 * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
-		 * the target page. In this case, we exit with no error and no target
-		 * page. This will trigger the caller, page_mkwrite(), to re-try
-		 * the operation.
+		 * ocfs2_grab_folios_for_write() returns -EAGAIN if it
+		 * could not lock the target folio. In this case, we exit
+		 * with no error and no target folio. This will trigger
+		 * the caller, page_mkwrite(), to re-try the operation.
 		 */
 		if (type == OCFS2_WRITE_MMAP && ret == -EAGAIN) {
 			BUG_ON(wc->w_target_folio);
@@ -1997,8 +2007,8 @@ int ocfs2_write_end_nolock(struct addres
 	if (wc->w_target_folio)
 		flush_dcache_folio(wc->w_target_folio);
 
-	for(i = 0; i < wc->w_num_pages; i++) {
-		tmppage = wc->w_pages[i];
+	for (i = 0; i < wc->w_num_folios; i++) {
+		tmppage = &wc->w_folios[i]->page;
 
 		/* This is the direct io target page. */
 		if (tmppage == NULL)
@@ -2059,7 +2069,7 @@ out:
 	 * this lock and will ask for the page lock when flushing the data.
 	 * put it here to preserve the unlock order.
 	 */
-	ocfs2_unlock_pages(wc);
+	ocfs2_unlock_folios(wc);
 
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
--- a/fs/ocfs2/aops.h~ocfs2-convert-w_pages-to-w_folios
+++ a/fs/ocfs2/aops.h
@@ -17,6 +17,7 @@ int ocfs2_map_page_blocks(struct page *p
 			  struct inode *inode, unsigned int from,
 			  unsigned int to, int new);
 
+void ocfs2_unlock_and_free_folios(struct folio **folios, int num_folios);
 void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages);
 
 int walk_page_buffers(	handle_t *handle,
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are


