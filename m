Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49138C25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjJYXs2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjJYXsQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD20182
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978CDC433C7;
        Wed, 25 Oct 2023 23:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277685;
        bh=D1J0x8eOpLsgi8INsOHlO6X6mPhOt88RC76KNstprZw=;
        h=Date:To:From:Subject:From;
        b=l1wweIRu8Sa9XIdg2nP8IUmkcHA5MYGgoVRGxkgM/BFX4faHFIhHrTiTQe18y13fH
         /mPabHZoyhQQQbAJWPMHLqcQrJEF0MLCtecYcQV/ctecJ2ZV9Cxo9WKvaM7BHCn9Xx
         YGuGpmtStAftfCHfkKneimkGufg0lJxRuB7LPhcg=
Date:   Wed, 25 Oct 2023 16:48:05 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ntfs-convert-ntfs_prepare_pages_for_non_resident_write-to-folios.patch removed from -mm tree
Message-Id: <20231025234805.978CDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ntfs: convert ntfs_prepare_pages_for_non_resident_write() to folios
has been removed from the -mm tree.  Its filename was
     ntfs-convert-ntfs_prepare_pages_for_non_resident_write-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ntfs: convert ntfs_prepare_pages_for_non_resident_write() to folios
Date: Mon, 16 Oct 2023 21:11:06 +0100

Convert each element of the pages array to a folio before using it.  This
in no way renders the function large-folio safe, but it does remove a lot
of hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231016201114.1928083-20-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/file.c |   89 +++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 48 deletions(-)

--- a/fs/ntfs/file.c~ntfs-convert-ntfs_prepare_pages_for_non_resident_write-to-folios
+++ a/fs/ntfs/file.c
@@ -567,7 +567,7 @@ static int ntfs_prepare_pages_for_non_re
 	LCN lcn;
 	s64 bh_pos, vcn_len, end, initialized_size;
 	sector_t lcn_block;
-	struct page *page;
+	struct folio *folio;
 	struct inode *vi;
 	ntfs_inode *ni, *base_ni = NULL;
 	ntfs_volume *vol;
@@ -601,20 +601,6 @@ static int ntfs_prepare_pages_for_non_re
 			(long long)pos, bytes);
 	blocksize = vol->sb->s_blocksize;
 	blocksize_bits = vol->sb->s_blocksize_bits;
-	u = 0;
-	do {
-		page = pages[u];
-		BUG_ON(!page);
-		/*
-		 * create_empty_buffers() will create uptodate/dirty buffers if
-		 * the page is uptodate/dirty.
-		 */
-		if (!page_has_buffers(page)) {
-			create_empty_buffers(page, blocksize, 0);
-			if (unlikely(!page_has_buffers(page)))
-				return -ENOMEM;
-		}
-	} while (++u < nr_pages);
 	rl_write_locked = false;
 	rl = NULL;
 	err = 0;
@@ -626,14 +612,21 @@ static int ntfs_prepare_pages_for_non_re
 	end = pos + bytes;
 	cend = (end + vol->cluster_size - 1) >> vol->cluster_size_bits;
 	/*
-	 * Loop over each page and for each page over each buffer.  Use goto to
+	 * Loop over each buffer in each folio.  Use goto to
 	 * reduce indentation.
 	 */
 	u = 0;
-do_next_page:
-	page = pages[u];
-	bh_pos = (s64)page->index << PAGE_SHIFT;
-	bh = head = page_buffers(page);
+do_next_folio:
+	folio = page_folio(pages[u]);
+	bh_pos = folio_pos(folio);
+	head = folio_buffers(folio);
+	if (!head)
+		/*
+		 * create_empty_buffers() will create uptodate/dirty
+		 * buffers if the folio is uptodate/dirty.
+		 */
+		head = folio_create_empty_buffers(folio, blocksize, 0);
+	bh = head;
 	do {
 		VCN cdelta;
 		s64 bh_end;
@@ -653,15 +646,15 @@ do_next_page:
 			if (buffer_uptodate(bh))
 				continue;
 			/*
-			 * The buffer is not uptodate.  If the page is uptodate
+			 * The buffer is not uptodate.  If the folio is uptodate
 			 * set the buffer uptodate and otherwise ignore it.
 			 */
-			if (PageUptodate(page)) {
+			if (folio_test_uptodate(folio)) {
 				set_buffer_uptodate(bh);
 				continue;
 			}
 			/*
-			 * Neither the page nor the buffer are uptodate.  If
+			 * Neither the folio nor the buffer are uptodate.  If
 			 * the buffer is only partially being written to, we
 			 * need to read it in before the write, i.e. now.
 			 */
@@ -679,7 +672,7 @@ do_next_page:
 					ntfs_submit_bh_for_read(bh);
 					*wait_bh++ = bh;
 				} else {
-					zero_user(page, bh_offset(bh),
+					folio_zero_range(folio, bh_offset(bh),
 							blocksize);
 					set_buffer_uptodate(bh);
 				}
@@ -706,7 +699,7 @@ map_buffer_cached:
 					(bh_cofs >> blocksize_bits);
 			set_buffer_mapped(bh);
 			/*
-			 * If the page is uptodate so is the buffer.  If the
+			 * If the folio is uptodate so is the buffer.  If the
 			 * buffer is fully outside the write, we ignore it if
 			 * it was already allocated and we mark it dirty so it
 			 * gets written out if we allocated it.  On the other
@@ -714,7 +707,7 @@ map_buffer_cached:
 			 * marking it dirty we set buffer_new so we can do
 			 * error recovery.
 			 */
-			if (PageUptodate(page)) {
+			if (folio_test_uptodate(folio)) {
 				if (!buffer_uptodate(bh))
 					set_buffer_uptodate(bh);
 				if (unlikely(was_hole)) {
@@ -754,7 +747,8 @@ map_buffer_cached:
 						ntfs_submit_bh_for_read(bh);
 						*wait_bh++ = bh;
 					} else {
-						zero_user(page, bh_offset(bh),
+						folio_zero_range(folio,
+								bh_offset(bh),
 								blocksize);
 						set_buffer_uptodate(bh);
 					}
@@ -773,7 +767,7 @@ map_buffer_cached:
 			 */
 			if (bh_end <= pos || bh_pos >= end) {
 				if (!buffer_uptodate(bh)) {
-					zero_user(page, bh_offset(bh),
+					folio_zero_range(folio, bh_offset(bh),
 							blocksize);
 					set_buffer_uptodate(bh);
 				}
@@ -786,7 +780,7 @@ map_buffer_cached:
 				u8 *kaddr;
 				unsigned pofs;
 					
-				kaddr = kmap_atomic(page);
+				kaddr = kmap_local_folio(folio, 0);
 				if (bh_pos < pos) {
 					pofs = bh_pos & ~PAGE_MASK;
 					memset(kaddr + pofs, 0, pos - bh_pos);
@@ -795,8 +789,8 @@ map_buffer_cached:
 					pofs = end & ~PAGE_MASK;
 					memset(kaddr + pofs, 0, bh_end - end);
 				}
-				kunmap_atomic(kaddr);
-				flush_dcache_page(page);
+				kunmap_local(kaddr);
+				flush_dcache_folio(folio);
 			}
 			continue;
 		}
@@ -809,11 +803,12 @@ map_buffer_cached:
 		initialized_size = ni->allocated_size;
 		read_unlock_irqrestore(&ni->size_lock, flags);
 		if (bh_pos > initialized_size) {
-			if (PageUptodate(page)) {
+			if (folio_test_uptodate(folio)) {
 				if (!buffer_uptodate(bh))
 					set_buffer_uptodate(bh);
 			} else if (!buffer_uptodate(bh)) {
-				zero_user(page, bh_offset(bh), blocksize);
+				folio_zero_range(folio, bh_offset(bh),
+						blocksize);
 				set_buffer_uptodate(bh);
 			}
 			continue;
@@ -927,17 +922,17 @@ rl_not_mapped_enoent:
 				bh->b_blocknr = -1;
 				/*
 				 * If the buffer is uptodate we skip it.  If it
-				 * is not but the page is uptodate, we can set
-				 * the buffer uptodate.  If the page is not
+				 * is not but the folio is uptodate, we can set
+				 * the buffer uptodate.  If the folio is not
 				 * uptodate, we can clear the buffer and set it
 				 * uptodate.  Whether this is worthwhile is
 				 * debatable and this could be removed.
 				 */
-				if (PageUptodate(page)) {
+				if (folio_test_uptodate(folio)) {
 					if (!buffer_uptodate(bh))
 						set_buffer_uptodate(bh);
 				} else if (!buffer_uptodate(bh)) {
-					zero_user(page, bh_offset(bh),
+					folio_zero_range(folio, bh_offset(bh),
 						blocksize);
 					set_buffer_uptodate(bh);
 				}
@@ -1167,7 +1162,7 @@ rl_not_mapped_enoent:
 	} while (bh_pos += blocksize, (bh = bh->b_this_page) != head);
 	/* If there are no errors, do the next page. */
 	if (likely(!err && ++u < nr_pages))
-		goto do_next_page;
+		goto do_next_folio;
 	/* If there are no errors, release the runlist lock if we took it. */
 	if (likely(!err)) {
 		if (unlikely(rl_write_locked)) {
@@ -1185,9 +1180,8 @@ rl_not_mapped_enoent:
 		bh = *--wait_bh;
 		wait_on_buffer(bh);
 		if (likely(buffer_uptodate(bh))) {
-			page = bh->b_page;
-			bh_pos = ((s64)page->index << PAGE_SHIFT) +
-					bh_offset(bh);
+			folio = bh->b_folio;
+			bh_pos = folio_pos(folio) + bh_offset(bh);
 			/*
 			 * If the buffer overflows the initialized size, need
 			 * to zero the overflowing region.
@@ -1197,7 +1191,7 @@ rl_not_mapped_enoent:
 
 				if (likely(bh_pos < initialized_size))
 					ofs = initialized_size - bh_pos;
-				zero_user_segment(page, bh_offset(bh) + ofs,
+				folio_zero_segment(folio, bh_offset(bh) + ofs,
 						blocksize);
 			}
 		} else /* if (unlikely(!buffer_uptodate(bh))) */
@@ -1324,21 +1318,20 @@ rl_not_mapped_enoent:
 	u = 0;
 	end = bh_cpos << vol->cluster_size_bits;
 	do {
-		page = pages[u];
-		bh = head = page_buffers(page);
+		folio = page_folio(pages[u]);
+		bh = head = folio_buffers(folio);
 		do {
 			if (u == nr_pages &&
-					((s64)page->index << PAGE_SHIFT) +
-					bh_offset(bh) >= end)
+			    folio_pos(folio) + bh_offset(bh) >= end)
 				break;
 			if (!buffer_new(bh))
 				continue;
 			clear_buffer_new(bh);
 			if (!buffer_uptodate(bh)) {
-				if (PageUptodate(page))
+				if (folio_test_uptodate(folio))
 					set_buffer_uptodate(bh);
 				else {
-					zero_user(page, bh_offset(bh),
+					folio_zero_range(folio, bh_offset(bh),
 							blocksize);
 					set_buffer_uptodate(bh);
 				}
_

Patches currently in -mm which might be from willy@infradead.org are


