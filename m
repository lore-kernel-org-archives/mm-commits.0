Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC85C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjBCGmB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjBCGkt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205EB8FB49
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0F90B82981
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E2AC433EF;
        Fri,  3 Feb 2023 06:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406259;
        bh=hUgGz6Zs8gCWxuXY5+fqdgU/VCUkdptLUyh0iEHk9U8=;
        h=Date:To:From:Subject:From;
        b=mtQPvC9/WTDm7XbvlCBNJGMnjzFncWvd3RQkWSE7cTHDQGnjFrAozs1YvIhfocLn/
         SMCDnkYLPi7XQSav2fHxDWdky2B5dCvuWU6eQv1mjLuqi73CByTsvpStqHqohRLrVo
         z8aTZRSm9Ocb3/9oMsjVQi75P2YJho6PjfCSoroQ=
Date:   Thu, 02 Feb 2023 22:37:38 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-mlock_vma_page.patch removed from -mm tree
Message-Id: <20230203063739.66E2AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove mlock_vma_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-mlock_vma_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove mlock_vma_page()
Date: Mon, 16 Jan 2023 19:28:25 +0000

All callers now have a folio and can call mlock_vma_folio().  Update the
documentation to refer to mlock_vma_folio().

Link: https://lkml.kernel.org/r/20230116192827.2146732-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/unevictable-lru.rst~mm-remove-mlock_vma_page
+++ a/Documentation/mm/unevictable-lru.rst
@@ -311,7 +311,7 @@ do end up getting faulted into this VM_L
 fault path - which is also how mlock2()'s MLOCK_ONFAULT areas are handled.
 
 For each PTE (or PMD) being faulted into a VMA, the page add rmap function
-calls mlock_vma_page(), which calls mlock_folio() when the VMA is VM_LOCKED
+calls mlock_vma_folio(), which calls mlock_folio() when the VMA is VM_LOCKED
 (unless it is a PTE mapping of a part of a transparent huge page).  Or when
 it is a newly allocated anonymous page, folio_add_lru_vma() calls
 mlock_new_folio() instead: similar to mlock_folio(), but can make better
@@ -413,7 +413,7 @@ However, since mlock_vma_pages_range() s
 before mlocking any pages already present, if one of those pages were migrated
 before mlock_pte_range() reached it, it would get counted twice in mlock_count.
 To prevent that, mlock_vma_pages_range() temporarily marks the VMA as VM_IO,
-so that mlock_vma_page() will skip it.
+so that mlock_vma_folio() will skip it.
 
 To complete page migration, we place the old and new pages back onto the LRU
 afterwards.  The "unneeded" page - old page on success, new page on failure -
@@ -552,6 +552,6 @@ and node unevictable list.
 
 rmap's folio_referenced_one(), called via vmscan's shrink_active_list() or
 shrink_page_list(), and rmap's try_to_unmap_one() called via shrink_page_list(),
-check for (3) pages still mapped into VM_LOCKED VMAs, and call mlock_vma_page()
+check for (3) pages still mapped into VM_LOCKED VMAs, and call mlock_vma_folio()
 to correct them.  Such pages are culled to the unevictable list when released
 by the shrinker.
--- a/mm/internal.h~mm-remove-mlock_vma_page
+++ a/mm/internal.h
@@ -518,7 +518,7 @@ extern long faultin_vma_page_range(struc
 extern int mlock_future_check(struct mm_struct *mm, unsigned long flags,
 			      unsigned long len);
 /*
- * mlock_vma_page() and munlock_vma_page():
+ * mlock_vma_folio() and munlock_vma_folio():
  * should be called with vma's mmap_lock held for read or write,
  * under page table lock for the pte/pmd being added or removed.
  *
@@ -547,12 +547,6 @@ static inline void mlock_vma_folio(struc
 		mlock_folio(folio);
 }
 
-static inline void mlock_vma_page(struct page *page,
-			struct vm_area_struct *vma, bool compound)
-{
-	mlock_vma_folio(page_folio(page), vma, compound);
-}
-
 void munlock_folio(struct folio *folio);
 
 static inline void munlock_vma_folio(struct folio *folio,
@@ -656,8 +650,6 @@ static inline struct file *maybe_unlock_
 }
 #else /* !CONFIG_MMU */
 static inline void unmap_mapping_folio(struct folio *folio) { }
-static inline void mlock_vma_page(struct page *page,
-			struct vm_area_struct *vma, bool compound) { }
 static inline void munlock_vma_page(struct page *page,
 			struct vm_area_struct *vma, bool compound) { }
 static inline void mlock_new_folio(struct folio *folio) { }
--- a/mm/mlock.c~mm-remove-mlock_vma_page
+++ a/mm/mlock.c
@@ -370,9 +370,9 @@ static void mlock_vma_pages_range(struct
 	/*
 	 * There is a slight chance that concurrent page migration,
 	 * or page reclaim finding a page of this now-VM_LOCKED vma,
-	 * will call mlock_vma_page() and raise page's mlock_count:
+	 * will call mlock_vma_folio() and raise page's mlock_count:
 	 * double counting, leaving the page unevictable indefinitely.
-	 * Communicate this danger to mlock_vma_page() with VM_IO,
+	 * Communicate this danger to mlock_vma_folio() with VM_IO,
 	 * which is a VM_SPECIAL flag not allowed on VM_LOCKED vmas.
 	 * mmap_lock is held in write mode here, so this weird
 	 * combination should not be visible to other mmap_lock users;
--- a/mm/rmap.c~mm-remove-mlock_vma_page
+++ a/mm/rmap.c
@@ -1260,7 +1260,7 @@ void page_add_anon_rmap(struct page *pag
 			__page_check_anon_rmap(page, vma, address);
 	}
 
-	mlock_vma_page(page, vma, compound);
+	mlock_vma_folio(folio, vma, compound);
 }
 
 /**
@@ -1351,7 +1351,7 @@ void page_add_file_rmap(struct page *pag
 	if (nr)
 		__lruvec_stat_mod_folio(folio, NR_FILE_MAPPED, nr);
 
-	mlock_vma_page(page, vma, compound);
+	mlock_vma_folio(folio, vma, compound);
 }
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are


