Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E574EC63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbjBCGku (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjBCGjp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:39:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BEB8F24F
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99568B82982
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A8AC433EF;
        Fri,  3 Feb 2023 06:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406226;
        bh=bTcSdP/W0SeV9vadgfRK7PF+69NXPRFJz8dx4RMnh+8=;
        h=Date:To:From:Subject:From;
        b=gyaZG/riLqRxmQmt2kgxBsJvg/+qmdl+BounxlhxlyU0PRBwSlHaqYgaT/18x1DUx
         6GVhtAPKvXvld/5Bb8WosEyQcEx+dEoAkbVCbffhNX6Ufg5tDw35YsjG9LdLTgluqD
         Ihp1evIPy9i1nxTOHNFQS/JLLZ2R2BTgPLuphQPo=
Date:   Thu, 02 Feb 2023 22:37:05 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] page-writeback-convert-write_cache_pages-to-use-filemap_get_folios_tag.patch removed from -mm tree
Message-Id: <20230203063706.40A8AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: page-writeback: convert write_cache_pages() to use filemap_get_folios_tag()
has been removed from the -mm tree.  Its filename was
     page-writeback-convert-write_cache_pages-to-use-filemap_get_folios_tag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: page-writeback: convert write_cache_pages() to use filemap_get_folios_tag()
Date: Wed, 4 Jan 2023 13:14:29 -0800

Convert function to use folios throughout.  This is in preparation for the
removal of find_get_pages_range_tag().  This change removes 8 calls to
compound_head(), and the function now supports large folios.

Link: https://lkml.kernel.org/r/20230104211448.4804-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcow (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page-writeback.c~page-writeback-convert-write_cache_pages-to-use-filemap_get_folios_tag
+++ a/mm/page-writeback.c
@@ -2398,15 +2398,15 @@ int write_cache_pages(struct address_spa
 	int ret = 0;
 	int done = 0;
 	int error;
-	struct pagevec pvec;
-	int nr_pages;
+	struct folio_batch fbatch;
+	int nr_folios;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
 	int range_whole = 0;
 	xa_mark_t tag;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* prev offset */
 		end = -1;
@@ -2426,17 +2426,18 @@ int write_cache_pages(struct address_spa
 	while (!done && (index <= end)) {
 		int i;
 
-		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
-				tag);
-		if (nr_pages == 0)
+		nr_folios = filemap_get_folios_tag(mapping, &index, end,
+				tag, &fbatch);
+
+		if (nr_folios == 0)
 			break;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct folio *folio = fbatch.folios[i];
 
-			done_index = page->index;
+			done_index = folio->index;
 
-			lock_page(page);
+			folio_lock(folio);
 
 			/*
 			 * Page truncated or invalidated. We can freely skip it
@@ -2446,30 +2447,30 @@ int write_cache_pages(struct address_spa
 			 * even if there is now a new, dirty page at the same
 			 * pagecache address.
 			 */
-			if (unlikely(page->mapping != mapping)) {
+			if (unlikely(folio->mapping != mapping)) {
 continue_unlock:
-				unlock_page(page);
+				folio_unlock(folio);
 				continue;
 			}
 
-			if (!PageDirty(page)) {
+			if (!folio_test_dirty(folio)) {
 				/* someone wrote it for us */
 				goto continue_unlock;
 			}
 
-			if (PageWriteback(page)) {
+			if (folio_test_writeback(folio)) {
 				if (wbc->sync_mode != WB_SYNC_NONE)
-					wait_on_page_writeback(page);
+					folio_wait_writeback(folio);
 				else
 					goto continue_unlock;
 			}
 
-			BUG_ON(PageWriteback(page));
-			if (!clear_page_dirty_for_io(page))
+			BUG_ON(folio_test_writeback(folio));
+			if (!folio_clear_dirty_for_io(folio))
 				goto continue_unlock;
 
 			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
-			error = (*writepage)(page, wbc, data);
+			error = writepage(&folio->page, wbc, data);
 			if (unlikely(error)) {
 				/*
 				 * Handle errors according to the type of
@@ -2484,11 +2485,12 @@ continue_unlock:
 				 * the first error.
 				 */
 				if (error == AOP_WRITEPAGE_ACTIVATE) {
-					unlock_page(page);
+					folio_unlock(folio);
 					error = 0;
 				} else if (wbc->sync_mode != WB_SYNC_ALL) {
 					ret = error;
-					done_index = page->index + 1;
+					done_index = folio->index +
+						folio_nr_pages(folio);
 					done = 1;
 					break;
 				}
@@ -2508,7 +2510,7 @@ continue_unlock:
 				break;
 			}
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-add-folio_estimated_sharers.patch
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch
mm-add-folio_get_nontail_page.patch
mm-migrate-add-folio_movable_ops.patch
mm-migrate-convert-isolate_movable_page-to-use-folios.patch
mm-migrate-convert-putback_movable_pages-to-use-folios.patch

