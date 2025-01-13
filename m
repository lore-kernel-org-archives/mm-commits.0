Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D443C25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742206; cv=none; b=ZJx5F5Mqwgn1L4QbXMmLK3DF+Sqpmp7rfgMT5wEaVDsysMfal+yur8dN/GII8TEpVV/xvcq+0SyIkqVSCZVfHd/iqtqBzX+RtVxIyaSQc7iHlWHrPDdJK3cdkIRLDEsS53sEqfayUdvzrP2003iwBpTeW3dfFCtiTaulow4hyr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742206; c=relaxed/simple;
	bh=97uadFpqwhVFoOjV4Mn5MtKY9wR9Fx5xxdPylksac5M=;
	h=Date:To:From:Subject:Message-Id; b=c4y1MY81AuXOtOHluRTZvCfd2VLv83Ha+nTQWH10lmbIt4LZBvV7vhiCdo9onx0oLFv68wRdgYc6Qbchx1M74paFYmg/qU8s8eUT3Veo2YVUpgkmHHyRntyhxP8ZV130uyTG+xw/ebAnjhPhV81y5zF8e4lNkR+W6VZ4gGlvzpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G6M4lYJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G6M4lYJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA577C4CED6;
	Mon, 13 Jan 2025 04:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742206;
	bh=97uadFpqwhVFoOjV4Mn5MtKY9wR9Fx5xxdPylksac5M=;
	h=Date:To:From:Subject:From;
	b=G6M4lYJAdd0dMjR8T2WlDsDTKvJVUa7chVAtYyrUZ5+J9vNwp4o2UXWIa2Xx9s+dj
	 nmF0rhsPUzZJoltOek4+6QqxbmgIULEpoJ+vfZvKBy/vSyly7SksgTwu7UGov8+B2I
	 TPbnQxo4z89I4axwzwEXY1nmmkrmHGt5kRkiQbag=
Date: Sun, 12 Jan 2025 20:23:26 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-convert-w_target_page-to-w_target_folio.patch removed from -mm tree
Message-Id: <20250113042326.AA577C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: convert w_target_page to w_target_folio
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-w_target_page-to-w_target_folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: convert w_target_page to w_target_folio
Date: Thu, 5 Dec 2024 17:16:31 +0000

Pass a folio around instead of a page.  Saves a few hidden calls to
compound_head() and removes a call to kmap_atomic().

Link: https://lkml.kernel.org/r/20241205171653.3179945-4-willy@infradead.org
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

 fs/ocfs2/aops.c |   63 ++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-convert-w_target_page-to-w_target_folio
+++ a/fs/ocfs2/aops.c
@@ -731,22 +731,22 @@ struct ocfs2_write_ctxt {
 	/*
 	 * Pages involved in this write.
 	 *
-	 * w_target_page is the page being written to by the user.
+	 * w_target_folio is the folio being written to by the user.
 	 *
 	 * w_pages is an array of pages which always contains
-	 * w_target_page, and in the case of an allocating write with
+	 * w_target_folio, and in the case of an allocating write with
 	 * page_size < cluster size, it will contain zero'd and mapped
-	 * pages adjacent to w_target_page which need to be written
+	 * pages adjacent to w_target_folio which need to be written
 	 * out in so that future reads from that region will get
 	 * zero's.
 	 */
 	unsigned int			w_num_pages;
 	struct page			*w_pages[OCFS2_MAX_CTXT_PAGES];
-	struct page			*w_target_page;
+	struct folio			*w_target_folio;
 
 	/*
 	 * w_target_locked is used for page_mkwrite path indicating no unlocking
-	 * against w_target_page in ocfs2_write_end_nolock.
+	 * against w_target_folio in ocfs2_write_end_nolock.
 	 */
 	unsigned int			w_target_locked:1;
 
@@ -791,18 +791,18 @@ static void ocfs2_unlock_pages(struct oc
 	/*
 	 * w_target_locked is only set to true in the page_mkwrite() case.
 	 * The intent is to allow us to lock the target page from write_begin()
-	 * to write_end(). The caller must hold a ref on w_target_page.
+	 * to write_end(). The caller must hold a ref on w_target_folio.
 	 */
 	if (wc->w_target_locked) {
-		BUG_ON(!wc->w_target_page);
+		BUG_ON(!wc->w_target_folio);
 		for (i = 0; i < wc->w_num_pages; i++) {
-			if (wc->w_target_page == wc->w_pages[i]) {
+			if (&wc->w_target_folio->page == wc->w_pages[i]) {
 				wc->w_pages[i] = NULL;
 				break;
 			}
 		}
-		mark_page_accessed(wc->w_target_page);
-		put_page(wc->w_target_page);
+		folio_mark_accessed(wc->w_target_folio);
+		folio_put(wc->w_target_folio);
 	}
 	ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
 }
@@ -869,8 +869,9 @@ static int ocfs2_alloc_write_ctxt(struct
  * and dirty so they'll be written out (in order to prevent uninitialised
  * block data from leaking). And clear the new bit.
  */
-static void ocfs2_zero_new_buffers(struct page *page, unsigned from, unsigned to)
+static void ocfs2_zero_new_buffers(struct folio *folio, unsigned from, unsigned to)
 {
+	struct page *page = &folio->page;
 	unsigned int block_start, block_end;
 	struct buffer_head *head, *bh;
 
@@ -918,8 +919,8 @@ static void ocfs2_write_failure(struct i
 		to = user_pos + user_len;
 	struct page *tmppage;
 
-	if (wc->w_target_page)
-		ocfs2_zero_new_buffers(wc->w_target_page, from, to);
+	if (wc->w_target_folio)
+		ocfs2_zero_new_buffers(wc->w_target_folio, from, to);
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		tmppage = wc->w_pages[i];
@@ -954,7 +955,7 @@ static int ocfs2_prepare_page_for_write(
 	new = new | ((i_size_read(inode) <= page_offset(page)) &&
 			(page_offset(page) <= user_pos));
 
-	if (page == wc->w_target_page) {
+	if (page == &wc->w_target_folio->page) {
 		map_from = user_pos & (PAGE_SIZE - 1);
 		map_to = map_from + user_len;
 
@@ -1097,7 +1098,7 @@ static int ocfs2_grab_pages_for_write(st
 		wait_for_stable_page(wc->w_pages[i]);
 
 		if (index == target_index)
-			wc->w_target_page = wc->w_pages[i];
+			wc->w_target_folio = page_folio(wc->w_pages[i]);
 	}
 out:
 	if (ret)
@@ -1494,7 +1495,8 @@ static int ocfs2_write_begin_inline(stru
 	 * If we don't set w_num_pages then this page won't get unlocked
 	 * and freed on cleanup of the write context.
 	 */
-	wc->w_pages[0] = wc->w_target_page = page;
+	wc->w_target_folio = page_folio(page);
+	wc->w_pages[0] = page;
 	wc->w_num_pages = 1;
 
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
@@ -1803,7 +1805,7 @@ try_again:
 		 * the operation.
 		 */
 		if (type == OCFS2_WRITE_MMAP && ret == -EAGAIN) {
-			BUG_ON(wc->w_target_page);
+			BUG_ON(wc->w_target_folio);
 			ret = 0;
 			goto out_quota;
 		}
@@ -1826,7 +1828,7 @@ try_again:
 
 success:
 	if (foliop)
-		*foliop = page_folio(wc->w_target_page);
+		*foliop = wc->w_target_folio;
 	*fsdata = wc;
 	return 0;
 out_quota:
@@ -1924,18 +1926,15 @@ static void ocfs2_write_end_inline(struc
 				   struct ocfs2_dinode *di,
 				   struct ocfs2_write_ctxt *wc)
 {
-	void *kaddr;
-
 	if (unlikely(*copied < len)) {
-		if (!PageUptodate(wc->w_target_page)) {
+		if (!folio_test_uptodate(wc->w_target_folio)) {
 			*copied = 0;
 			return;
 		}
 	}
 
-	kaddr = kmap_atomic(wc->w_target_page);
-	memcpy(di->id2.i_data.id_data + pos, kaddr + pos, *copied);
-	kunmap_atomic(kaddr);
+	memcpy_from_folio(di->id2.i_data.id_data + pos, wc->w_target_folio,
+			pos, *copied);
 
 	trace_ocfs2_write_end_inline(
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -1973,15 +1972,15 @@ int ocfs2_write_end_nolock(struct addres
 		goto out_write_size;
 	}
 
-	if (unlikely(copied < len) && wc->w_target_page) {
+	if (unlikely(copied < len) && wc->w_target_folio) {
 		loff_t new_isize;
 
-		if (!PageUptodate(wc->w_target_page))
+		if (!folio_test_uptodate(wc->w_target_folio))
 			copied = 0;
 
 		new_isize = max_t(loff_t, i_size_read(inode), pos + copied);
-		if (new_isize > page_offset(wc->w_target_page))
-			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
+		if (new_isize > folio_pos(wc->w_target_folio))
+			ocfs2_zero_new_buffers(wc->w_target_folio, start+copied,
 					       start+len);
 		else {
 			/*
@@ -1991,12 +1990,12 @@ int ocfs2_write_end_nolock(struct addres
 			 * put page & buffer dirty bits into inconsistent
 			 * state.
 			 */
-			block_invalidate_folio(page_folio(wc->w_target_page),
+			block_invalidate_folio(wc->w_target_folio,
 						0, PAGE_SIZE);
 		}
 	}
-	if (wc->w_target_page)
-		flush_dcache_page(wc->w_target_page);
+	if (wc->w_target_folio)
+		flush_dcache_folio(wc->w_target_folio);
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		tmppage = wc->w_pages[i];
@@ -2005,7 +2004,7 @@ int ocfs2_write_end_nolock(struct addres
 		if (tmppage == NULL)
 			continue;
 
-		if (tmppage == wc->w_target_page) {
+		if (tmppage == &wc->w_target_folio->page) {
 			from = wc->w_target_from;
 			to = wc->w_target_to;
 
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are


