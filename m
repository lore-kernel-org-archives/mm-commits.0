Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3719FC7619A
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 21:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCWVP0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 17:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCWVPZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 17:15:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35EE2596B
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 14:15:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47070628A1
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 21:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCBFC433D2;
        Thu, 23 Mar 2023 21:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679606123;
        bh=gtpChh7aNFfS4myrMQpP+Z3SmwbDd1ejm+p7lxbBnCc=;
        h=Date:To:From:Subject:From;
        b=DIz0hNnWLy2fiH04BVu54qTrAtxQVXn6M6XAkqPPnMzYISH7ann698DZIQ7ExH7nW
         DloODscqAxwQk/k9d48rCPCQPjM2EHVVzSSYrETY9MnKvtk8KW4DP3cQoNVmZXNqA0
         xVbN/A6hFOwyesuy8jJkQtacNTiMgmTswC+1506M=
Date:   Thu, 23 Mar 2023 14:15:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, peterx@redhat.com, kirill@shutemov.name,
        jiaqiyan@google.com, hughd@google.com, david@redhat.com,
        stevensd@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-maintain-page-cache-uptodate-flag.patch removed from -mm tree
Message-Id: <20230323211523.8DCBFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: maintain page cache uptodate flag
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-maintain-page-cache-uptodate-flag.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: David Stevens <stevensd@chromium.org>
Subject: mm/khugepaged: maintain page cache uptodate flag
Date: Tue, 7 Mar 2023 14:20:36 +0900

Make sure that collapse_file doesn't interfere with checking the uptodate
flag in the page cache by only inserting hpage into the page cache after
it has been updated and marked uptodate.  This is achieved by simply not
replacing present pages with hpage when iterating over the target range. 
The present pages are already locked, so replacing the with the locked
hpage before the collapse is finalized is unnecessary.

This fixes a race where folio_seek_hole_data would mistake hpage for an
fallocated but unwritten page.  This race is visible to userspace via data
temporarily disappearing from SEEK_DATA/SEEK_HOLE.

Link: https://lkml.kernel.org/r/20230307052036.1520708-4-stevensd@google.com
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: David Stevens <stevensd@chromium.org>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/khugepaged.c~mm-khugepaged-maintain-page-cache-uptodate-flag
+++ a/mm/khugepaged.c
@@ -1930,12 +1930,6 @@ static int collapse_file(struct mm_struc
 		}
 	} while (1);
 
-	/*
-	 * At this point the hpage is locked and not up-to-date.
-	 * It's safe to insert it into the page cache, because nobody would
-	 * be able to map it or use it in another way until we unlock it.
-	 */
-
 	xas_set(&xas, start);
 	for (index = start; index < end; index++) {
 		page = xas_next(&xas);
@@ -2104,13 +2098,9 @@ static int collapse_file(struct mm_struc
 		}
 
 		/*
-		 * Add the page to the list to be able to undo the collapse if
-		 * something go wrong.
+		 * Accumulate the pages that are being collapsed.
 		 */
 		list_add_tail(&page->lru, &pagelist);
-
-		/* Finally, replace with the new page. */
-		xas_store(&xas, hpage);
 		continue;
 out_unlock:
 		unlock_page(page);
@@ -2149,8 +2139,7 @@ xa_unlocked:
 		goto rollback;
 
 	/*
-	 * Replacing old pages with new one has succeeded, now we
-	 * attempt to copy the contents.
+	 * The old pages are locked, so they won't change anymore.
 	 */
 	index = start;
 	list_for_each_entry(page, &pagelist, lru) {
@@ -2230,11 +2219,11 @@ immap_locked:
 		/* nr_none is always 0 for non-shmem. */
 		__mod_lruvec_page_state(hpage, NR_SHMEM, nr_none);
 	}
-	/* Join all the small entries into a single multi-index entry. */
-	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
-	xas_store(&xas, hpage);
-	xas_unlock_irq(&xas);
 
+	/*
+	 * Mark hpage as uptodate before inserting it into the page cache so
+	 * that it isn't mistaken for an fallocated but unwritten page.
+	 */
 	folio = page_folio(hpage);
 	folio_mark_uptodate(folio);
 	folio_ref_add(folio, HPAGE_PMD_NR - 1);
@@ -2243,6 +2232,11 @@ immap_locked:
 		folio_mark_dirty(folio);
 	folio_add_lru(folio);
 
+	/* Join all the small entries into a single multi-index entry. */
+	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
+	xas_store(&xas, hpage);
+	xas_unlock_irq(&xas);
+
 	/*
 	 * Remove pte page tables, so we can re-fault the page as huge.
 	 */
@@ -2267,36 +2261,18 @@ immap_locked:
 
 rollback:
 	/* Something went wrong: roll back page cache changes */
-	xas_lock_irq(&xas);
 	if (nr_none) {
 		mapping->nrpages -= nr_none;
 		shmem_uncharge(mapping->host, nr_none);
 	}
 
-	xas_set(&xas, start);
-	end = index;
-	for (index = start; index < end; index++) {
-		xas_next(&xas);
-		page = list_first_entry_or_null(&pagelist,
-				struct page, lru);
-		if (!page || xas.xa_index < page->index) {
-			nr_none--;
-			continue;
-		}
-
-		VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
-
+	list_for_each_entry_safe(page, tmp, &pagelist, lru) {
 		/* Unfreeze the page. */
 		list_del(&page->lru);
 		page_ref_unfreeze(page, 2);
-		xas_store(&xas, page);
-		xas_pause(&xas);
-		xas_unlock_irq(&xas);
 		unlock_page(page);
 		putback_lru_page(page);
-		xas_lock_irq(&xas);
 	}
-	VM_BUG_ON(nr_none);
 	/*
 	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM file only.
 	 * This undo is not needed unless failure is due to SCAN_COPY_MC.
@@ -2304,8 +2280,6 @@ rollback:
 	if (!is_shmem && result == SCAN_COPY_MC)
 		filemap_nr_thps_dec(mapping);
 
-	xas_unlock_irq(&xas);
-
 	hpage->mapping = NULL;
 
 	unlock_page(hpage);
_

Patches currently in -mm which might be from stevensd@chromium.org are


