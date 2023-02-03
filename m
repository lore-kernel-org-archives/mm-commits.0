Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F337C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbjBCGmK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbjBCGkt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016898FB4D
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4675B82984
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C67C433EF;
        Fri,  3 Feb 2023 06:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406261;
        bh=re+ut2PptpKld7993mR8g/T/DzO/qWmfNsZ/SR0mQmg=;
        h=Date:To:From:Subject:From;
        b=BzvvnMDjJAe90UFVLUn51OAwfJNyKxQSE+TFi7jyJ+fl2QznfYz8jTFSKAlteaqUV
         hh0ZO9WgjZ/k3NXpgY/Labp6iMrJonnaqm8agmLwiZBTatDHGchC+qTfQrVH1R1/Py
         sr5XAwfM7NQk6dRb9jGFCFdA/WcI2UIkZCoFS1ec=
Date:   Thu, 02 Feb 2023 22:37:40 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-clean-up-mlock_page-munlock_page-references-in-comments.patch removed from -mm tree
Message-Id: <20230203063741.57C67C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: clean up mlock_page / munlock_page references in comments
has been removed from the -mm tree.  Its filename was
     mm-clean-up-mlock_page-munlock_page-references-in-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: clean up mlock_page / munlock_page references in comments
Date: Mon, 16 Jan 2023 19:28:27 +0000

Change documentation and comments that refer to now-renamed functions.

Link: https://lkml.kernel.org/r/20230116192827.2146732-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/unevictable-lru.rst~mm-clean-up-mlock_page-munlock_page-references-in-comments
+++ a/Documentation/mm/unevictable-lru.rst
@@ -298,7 +298,7 @@ treated as a no-op and mlock_fixup() sim
 If the VMA passes some filtering as described in "Filtering Special VMAs"
 below, mlock_fixup() will attempt to merge the VMA with its neighbors or split
 off a subset of the VMA if the range does not cover the entire VMA.  Any pages
-already present in the VMA are then marked as mlocked by mlock_page() via
+already present in the VMA are then marked as mlocked by mlock_folio() via
 mlock_pte_range() via walk_page_range() via mlock_vma_pages_range().
 
 Before returning from the system call, do_mlock() or mlockall() will call
@@ -373,20 +373,21 @@ Because of the VMA filtering discussed a
 any "special" VMAs.  So, those VMAs will be ignored for munlock.
 
 If the VMA is VM_LOCKED, mlock_fixup() again attempts to merge or split off the
-specified range.  All pages in the VMA are then munlocked by munlock_page() via
+specified range.  All pages in the VMA are then munlocked by munlock_folio() via
 mlock_pte_range() via walk_page_range() via mlock_vma_pages_range() - the same
 function used when mlocking a VMA range, with new flags for the VMA indicating
 that it is munlock() being performed.
 
-munlock_page() uses the mlock pagevec to batch up work to be done under
-lru_lock by  __munlock_page().  __munlock_page() decrements the page's
-mlock_count, and when that reaches 0 it clears PG_mlocked and clears
-PG_unevictable, moving the page from unevictable state to inactive LRU.
+munlock_folio() uses the mlock pagevec to batch up work to be done
+under lru_lock by  __munlock_folio().  __munlock_folio() decrements the
+folio's mlock_count, and when that reaches 0 it clears the mlocked flag
+and clears the unevictable flag, moving the folio from unevictable state
+to the inactive LRU.
 
-But in practice that may not work ideally: the page may not yet have reached
+But in practice that may not work ideally: the folio may not yet have reached
 "the unevictable LRU", or it may have been temporarily isolated from it.  In
 those cases its mlock_count field is unusable and must be assumed to be 0: so
-that the page will be rescued to an evictable LRU, then perhaps be mlocked
+that the folio will be rescued to an evictable LRU, then perhaps be mlocked
 again later if vmscan finds it in a VM_LOCKED VMA.
 
 
@@ -489,15 +490,16 @@ For each PTE (or PMD) being unmapped fro
 munlock_vma_folio(), which calls munlock_folio() when the VMA is VM_LOCKED
 (unless it was a PTE mapping of a part of a transparent huge page).
 
-munlock_page() uses the mlock pagevec to batch up work to be done under
-lru_lock by  __munlock_page().  __munlock_page() decrements the page's
-mlock_count, and when that reaches 0 it clears PG_mlocked and clears
-PG_unevictable, moving the page from unevictable state to inactive LRU.
+munlock_folio() uses the mlock pagevec to batch up work to be done
+under lru_lock by  __munlock_folio().  __munlock_folio() decrements the
+folio's mlock_count, and when that reaches 0 it clears the mlocked flag
+and clears the unevictable flag, moving the folio from unevictable state
+to the inactive LRU.
 
-But in practice that may not work ideally: the page may not yet have reached
+But in practice that may not work ideally: the folio may not yet have reached
 "the unevictable LRU", or it may have been temporarily isolated from it.  In
 those cases its mlock_count field is unusable and must be assumed to be 0: so
-that the page will be rescued to an evictable LRU, then perhaps be mlocked
+that the folio will be rescued to an evictable LRU, then perhaps be mlocked
 again later if vmscan finds it in a VM_LOCKED VMA.
 
 
--- a/mm/memory-failure.c~mm-clean-up-mlock_page-munlock_page-references-in-comments
+++ a/mm/memory-failure.c
@@ -2167,7 +2167,7 @@ try_again:
 	}
 
 	/*
-	 * __munlock_pagevec may clear a writeback page's LRU flag without
+	 * __munlock_folio() may clear a writeback page's LRU flag without
 	 * page_lock. We need wait writeback completion for this page or it
 	 * may trigger vfs BUG while evict inode.
 	 */
--- a/mm/swap.c~mm-clean-up-mlock_page-munlock_page-references-in-comments
+++ a/mm/swap.c
@@ -201,7 +201,7 @@ static void lru_add_fn(struct lruvec *lr
 	 * Is an smp_mb__after_atomic() still required here, before
 	 * folio_evictable() tests the mlocked flag, to rule out the possibility
 	 * of stranding an evictable folio on an unevictable LRU?  I think
-	 * not, because __munlock_page() only clears the mlocked flag
+	 * not, because __munlock_folio() only clears the mlocked flag
 	 * while the LRU lock is held.
 	 *
 	 * (That is not true of __page_cache_release(), and not necessarily
@@ -216,7 +216,7 @@ static void lru_add_fn(struct lruvec *lr
 		folio_set_unevictable(folio);
 		/*
 		 * folio->mlock_count = !!folio_test_mlocked(folio)?
-		 * But that leaves __mlock_page() in doubt whether another
+		 * But that leaves __mlock_folio() in doubt whether another
 		 * actor has already counted the mlock or not.  Err on the
 		 * safe side, underestimate, let page reclaim fix it, rather
 		 * than leaving a page on the unevictable LRU indefinitely.
_

Patches currently in -mm which might be from willy@infradead.org are


