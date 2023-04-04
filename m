Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85125C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 19:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjDDTsR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 15:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbjDDTsH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 15:48:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9DD421A
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 12:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A0DC63326
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 19:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD469C433EF;
        Tue,  4 Apr 2023 19:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680637680;
        bh=8G/XwwgJjFRcKbqtQqkfRUQiPT7TURPhzEN//+1G08w=;
        h=Date:To:From:Subject:From;
        b=Jkh5C4t41jQ9Z8zGpzi5LwE5FjRnsaow9vgQATa+NjMuGN3C65MxaJthpkmfmfA/r
         rM26jrV/OSjKuflXZoomlu9Y02HvFCIlPNjp55WrUF+VSaM7PveKPrvAnSKZBXo8F+
         zeNiTJzZn3BNpFVR22xBtl+aRIBx9s/V9x7NK1tw=
Date:   Tue, 04 Apr 2023 12:48:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, peterx@redhat.com, kirill@shutemov.name,
        jiaqiyan@google.com, hughd@google.com, david@redhat.com,
        stevensd@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-maintain-page-cache-uptodate-flag.patch added to mm-unstable branch
Message-Id: <20230404194800.CD469C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: maintain page cache uptodate flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-maintain-page-cache-uptodate-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-maintain-page-cache-uptodate-flag.patch

This patch will later appear in the mm-unstable branch at
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
From: David Stevens <stevensd@chromium.org>
Subject: mm/khugepaged: maintain page cache uptodate flag
Date: Tue, 4 Apr 2023 21:01:17 +0900

Make sure that collapse_file doesn't interfere with checking the uptodate
flag in the page cache by only inserting hpage into the page cache after
it has been updated and marked uptodate.  This is achieved by simply not
replacing present pages with hpage when iterating over the target range.

The present pages are already locked, so replacing them with the locked
hpage before the collapse is finalized is unnecessary.  However, it is
necessary to stop freezing the present pages after validating them, since
leaving long-term frozen pages in the page cache can lead to deadlocks. 
Simply checking the reference count is sufficient to ensure that there are
no long-term references hanging around that would the collapse would
break.  Similar to hpage, there is no reason that the present pages
actually need to be frozen in addition to being locked.

This fixes a race where folio_seek_hole_data would mistake hpage for an
fallocated but unwritten page.  This race is visible to userspace via data
temporarily disappearing from SEEK_DATA/SEEK_HOLE.  This also fixes a
similar race where pages could temporarily disappear from mincore.

Link: https://lkml.kernel.org/r/20230404120117.2562166-5-stevensd@google.com
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: David Stevens <stevensd@chromium.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   79 ++++++++++++++++------------------------------
 1 file changed, 29 insertions(+), 50 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-maintain-page-cache-uptodate-flag
+++ a/mm/khugepaged.c
@@ -1855,17 +1855,18 @@ next:
  *
  * Basic scheme is simple, details are more complex:
  *  - allocate and lock a new huge page;
- *  - scan page cache replacing old pages with the new one
+ *  - scan page cache, locking old pages
  *    + swap/gup in pages if necessary;
- *    + keep old pages around in case rollback is required;
+ *  - copy data to new page
+ *  - handle shmem holes
+ *    + re-validate that holes weren't filled by someone else
+ *    + check for userfaultfd
  *  - finalize updates to the page cache;
  *  - if replacing succeeds:
- *    + copy data over;
- *    + free old pages;
  *    + unlock huge page;
+ *    + free old pages;
  *  - if replacing failed;
- *    + put all pages back and unfreeze them;
- *    + restore gaps in the page cache;
+ *    + unlock old pages
  *    + unlock and free huge page;
  */
 static int collapse_file(struct mm_struct *mm, unsigned long addr,
@@ -1913,12 +1914,6 @@ static int collapse_file(struct mm_struc
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
@@ -2076,12 +2071,16 @@ static int collapse_file(struct mm_struc
 		VM_BUG_ON_PAGE(page != xas_load(&xas), page);
 
 		/*
-		 * The page is expected to have page_count() == 3:
+		 * We control three references to the page:
 		 *  - we hold a pin on it;
 		 *  - one reference from page cache;
 		 *  - one from isolate_lru_page;
+		 * If those are the only references, then any new usage of the
+		 * page will have to fetch it from the page cache. That requires
+		 * locking the page to handle truncate, so any new usage will be
+		 * blocked until we unlock page after collapse/during rollback.
 		 */
-		if (!page_ref_freeze(page, 3)) {
+		if (page_count(page) != 3) {
 			result = SCAN_PAGE_COUNT;
 			xas_unlock_irq(&xas);
 			putback_lru_page(page);
@@ -2089,13 +2088,9 @@ static int collapse_file(struct mm_struc
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
@@ -2132,8 +2127,7 @@ xa_unlocked:
 		goto rollback;
 
 	/*
-	 * Replacing old pages with new one has succeeded, now we
-	 * attempt to copy the contents.
+	 * The old pages are locked, so they won't change anymore.
 	 */
 	index = start;
 	list_for_each_entry(page, &pagelist, lru) {
@@ -2222,11 +2216,11 @@ immap_locked:
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
@@ -2235,6 +2229,11 @@ immap_locked:
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
@@ -2248,47 +2247,29 @@ immap_locked:
 	list_for_each_entry_safe(page, tmp, &pagelist, lru) {
 		list_del(&page->lru);
 		page->mapping = NULL;
-		page_ref_unfreeze(page, 1);
 		ClearPageActive(page);
 		ClearPageUnevictable(page);
 		unlock_page(page);
-		put_page(page);
+		folio_put_refs(page_folio(page), 3);
 	}
 
 	goto out;
 
 rollback:
 	/* Something went wrong: roll back page cache changes */
-	xas_lock_irq(&xas);
 	if (nr_none) {
+		xas_lock_irq(&xas);
 		mapping->nrpages -= nr_none;
 		shmem_uncharge(mapping->host, nr_none);
+		xas_unlock_irq(&xas);
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
-		/* Unfreeze the page. */
+	list_for_each_entry_safe(page, tmp, &pagelist, lru) {
 		list_del(&page->lru);
-		page_ref_unfreeze(page, 2);
-		xas_store(&xas, page);
-		xas_pause(&xas);
-		xas_unlock_irq(&xas);
 		unlock_page(page);
 		putback_lru_page(page);
-		xas_lock_irq(&xas);
+		put_page(page);
 	}
-	VM_BUG_ON(nr_none);
 	/*
 	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
 	 * file only. This undo is not needed unless failure is
@@ -2303,8 +2284,6 @@ rollback:
 		smp_mb();
 	}
 
-	xas_unlock_irq(&xas);
-
 	hpage->mapping = NULL;
 
 	unlock_page(hpage);
_

Patches currently in -mm which might be from stevensd@chromium.org are

mm-khugepaged-drain-lru-after-swapping-in-shmem.patch
mm-khugepaged-refactor-collapse_file-control-flow.patch
mm-khugepaged-skip-shmem-with-userfaultfd.patch
mm-khugepaged-maintain-page-cache-uptodate-flag.patch

