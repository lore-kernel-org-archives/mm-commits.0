Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85CD1BD9F6
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327665; cv=none; b=ox8OolFzyNesHsUsIt9qPlFDB1qlasRRH+wzTEIIrPnV4rbFsZyIsUG/XkSusnf/GKrlXf/y0yOn9gJEDtPpGmG3ZH3JRhT5j+WtJqqhTNvf0fbwT9vEA7sTrX0E0UrbUmej3J6eJ7ebq3MgZzqn7KbQHWLZ1rmP2m0XtUkavd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327665; c=relaxed/simple;
	bh=xM43pb67NSKfNepJPjlaKwSZrTKq082OyBgYzjUNV7s=;
	h=Date:To:From:Subject:Message-Id; b=L4zLeFdWriXLUemC78ePWj6udgkuHi7i6D0nix8VuQN1GW5/4gFeiF3BtwotJy3fGGXuhcNvdqAcaiUO0od595TgwmfSL6+s3ThaqmpgKA4td9hypraGsTrxfiBcEGCRk+uU0y1iJ0VgSVvfNrt+PVW43GGDyiavX+hYYfj38UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D7ngFLxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D7ngFLxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADC2C4CED0;
	Mon, 16 Dec 2024 05:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327665;
	bh=xM43pb67NSKfNepJPjlaKwSZrTKq082OyBgYzjUNV7s=;
	h=Date:To:From:Subject:From;
	b=D7ngFLxoyFVkpqu8kn0+ipYEZm6wGaEnc5lvxf1mB7d2gnN91dTfhw13tYCw/FhsH
	 Fa41cZjl0vMEILirL4fTsYF7qMiJ6P4XxG+PUbMM5R0t+X20tBP0cXM9p5RN78pvFF
	 ezq6kQBzxIx+vC5l871DFl81T7t78wAU524uxxbc=
Date: Sun, 15 Dec 2024 21:41:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-a-folio-in-ocfs2_write_end_nolock.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054105.7ADC2C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use a folio in ocfs2_write_end_nolock()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-a-folio-in-ocfs2_write_end_nolock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-a-folio-in-ocfs2_write_end_nolock.patch

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
Subject: ocfs2: use a folio in ocfs2_write_end_nolock()
Date: Thu, 5 Dec 2024 17:16:39 +0000

Remove an access to page->index.  Remove some PAGE_SIZE assumptions.

Link: https://lkml.kernel.org/r/20241205171653.3179945-12-willy@infradead.org
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

 fs/ocfs2/aops.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-use-a-folio-in-ocfs2_write_end_nolock
+++ a/fs/ocfs2/aops.c
@@ -1952,17 +1952,16 @@ static void ocfs2_write_end_inline(struc
 	     le16_to_cpu(di->i_dyn_features));
 }
 
-int ocfs2_write_end_nolock(struct address_space *mapping,
-			   loff_t pos, unsigned len, unsigned copied, void *fsdata)
+int ocfs2_write_end_nolock(struct address_space *mapping, loff_t pos,
+		unsigned len, unsigned copied, void *fsdata)
 {
 	int i, ret;
-	unsigned from, to, start = pos & (PAGE_SIZE - 1);
+	size_t from, to, start = pos & (PAGE_SIZE - 1);
 	struct inode *inode = mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_write_ctxt *wc = fsdata;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
 	handle_t *handle = wc->w_handle;
-	struct page *tmppage;
 
 	BUG_ON(!list_empty(&wc->w_unwritten_list));
 
@@ -1993,32 +1992,32 @@ int ocfs2_write_end_nolock(struct addres
 					       start+len);
 		else {
 			/*
-			 * When page is fully beyond new isize (data copy
-			 * failed), do not bother zeroing the page. Invalidate
+			 * When folio is fully beyond new isize (data copy
+			 * failed), do not bother zeroing the folio. Invalidate
 			 * it instead so that writeback does not get confused
 			 * put page & buffer dirty bits into inconsistent
 			 * state.
 			 */
-			block_invalidate_folio(wc->w_target_folio,
-						0, PAGE_SIZE);
+			block_invalidate_folio(wc->w_target_folio, 0,
+					folio_size(wc->w_target_folio));
 		}
 	}
 	if (wc->w_target_folio)
 		flush_dcache_folio(wc->w_target_folio);
 
 	for (i = 0; i < wc->w_num_folios; i++) {
-		tmppage = &wc->w_folios[i]->page;
+		struct folio *folio = wc->w_folios[i];
 
-		/* This is the direct io target page. */
-		if (tmppage == NULL)
+		/* This is the direct io target folio */
+		if (folio == NULL)
 			continue;
 
-		if (tmppage == &wc->w_target_folio->page) {
+		if (folio == wc->w_target_folio) {
 			from = wc->w_target_from;
 			to = wc->w_target_to;
 
-			BUG_ON(from > PAGE_SIZE ||
-			       to > PAGE_SIZE ||
+			BUG_ON(from > folio_size(folio) ||
+			       to > folio_size(folio) ||
 			       to < from);
 		} else {
 			/*
@@ -2027,19 +2026,17 @@ int ocfs2_write_end_nolock(struct addres
 			 * to flush their entire range.
 			 */
 			from = 0;
-			to = PAGE_SIZE;
+			to = folio_size(folio);
 		}
 
-		if (page_has_buffers(tmppage)) {
+		if (folio_buffers(folio)) {
 			if (handle && ocfs2_should_order_data(inode)) {
-				loff_t start_byte =
-					((loff_t)tmppage->index << PAGE_SHIFT) +
-					from;
+				loff_t start_byte = folio_pos(folio) + from;
 				loff_t length = to - from;
 				ocfs2_jbd2_inode_add_write(handle, inode,
 							   start_byte, length);
 			}
-			block_commit_write(tmppage, from, to);
+			block_commit_write(&folio->page, from, to);
 		}
 	}
 
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

