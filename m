Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A44C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbjBCGlw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjBCGke (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFB18F52B
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA44F61D98
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D27EC433D2;
        Fri,  3 Feb 2023 06:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406254;
        bh=3jfko8zWriiw+YVLJqnLEWLoHyOM1dovdLQy8Zp0zuI=;
        h=Date:To:From:Subject:From;
        b=r/ltyIkfxC3rFN4gZ2XpYrm95eg48nSr8BlWj2FTUk16YHnavCODitj4cIWV6kfwu
         ENj23/0HfU3tkbizhqv1GchedLyGV1DgglEExzJmPu2IwU4HCCu1WOe7AkqWsjNRhB
         VMViSwMKxGsM+/fMAz+y6kfjRkdjU+2IYr/MT/I0=
Date:   Thu, 02 Feb 2023 22:37:33 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-a-folio-in-copy_pte_range.patch removed from -mm tree
Message-Id: <20230203063734.3D27EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use a folio in copy_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-use-a-folio-in-copy_pte_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use a folio in copy_pte_range()
Date: Mon, 16 Jan 2023 19:18:12 +0000

Allocate an order-0 folio instead of a page and pass it all the way down
the call chain.  Removes dozens of calls to compound_head().

Link: https://lkml.kernel.org/r/20230116191813.2145215-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-use-a-folio-in-copy_pte_range
+++ a/mm/memory.c
@@ -863,13 +863,13 @@ copy_nonpresent_pte(struct mm_struct *ds
 static inline int
 copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 		  pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
-		  struct page **prealloc, struct page *page)
+		  struct folio **prealloc, struct page *page)
 {
-	struct page *new_page;
+	struct folio *new_folio;
 	pte_t pte;
 
-	new_page = *prealloc;
-	if (!new_page)
+	new_folio = *prealloc;
+	if (!new_folio)
 		return -EAGAIN;
 
 	/*
@@ -877,14 +877,14 @@ copy_present_page(struct vm_area_struct
 	 * over and copy the page & arm it.
 	 */
 	*prealloc = NULL;
-	copy_user_highpage(new_page, page, addr, src_vma);
-	__SetPageUptodate(new_page);
-	page_add_new_anon_rmap(new_page, dst_vma, addr);
-	lru_cache_add_inactive_or_unevictable(new_page, dst_vma);
-	rss[mm_counter(new_page)]++;
+	copy_user_highpage(&new_folio->page, page, addr, src_vma);
+	__folio_mark_uptodate(new_folio);
+	folio_add_new_anon_rmap(new_folio, dst_vma, addr);
+	folio_add_lru_vma(new_folio, dst_vma);
+	rss[MM_ANONPAGES]++;
 
 	/* All done, just insert the new page copy in the child */
-	pte = mk_pte(new_page, dst_vma->vm_page_prot);
+	pte = mk_pte(&new_folio->page, dst_vma->vm_page_prot);
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
 	if (userfaultfd_pte_wp(dst_vma, *src_pte))
 		/* Uffd-wp needs to be delivered to dest pte as well */
@@ -900,7 +900,7 @@ copy_present_page(struct vm_area_struct
 static inline int
 copy_present_pte(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 		 pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
-		 struct page **prealloc)
+		 struct folio **prealloc)
 {
 	struct mm_struct *src_mm = src_vma->vm_mm;
 	unsigned long vm_flags = src_vma->vm_flags;
@@ -922,11 +922,11 @@ copy_present_pte(struct vm_area_struct *
 			return copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
 						 addr, rss, prealloc, page);
 		}
-		rss[mm_counter(page)]++;
+		rss[MM_ANONPAGES]++;
 	} else if (page) {
 		get_page(page);
 		page_dup_file_rmap(page, false);
-		rss[mm_counter(page)]++;
+		rss[mm_counter_file(page)]++;
 	}
 
 	/*
@@ -954,23 +954,22 @@ copy_present_pte(struct vm_area_struct *
 	return 0;
 }
 
-static inline struct page *
-page_copy_prealloc(struct mm_struct *src_mm, struct vm_area_struct *vma,
-		   unsigned long addr)
+static inline struct folio *page_copy_prealloc(struct mm_struct *src_mm,
+		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct page *new_page;
+	struct folio *new_folio;
 
-	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, addr);
-	if (!new_page)
+	new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr, false);
+	if (!new_folio)
 		return NULL;
 
-	if (mem_cgroup_charge(page_folio(new_page), src_mm, GFP_KERNEL)) {
-		put_page(new_page);
+	if (mem_cgroup_charge(new_folio, src_mm, GFP_KERNEL)) {
+		folio_put(new_folio);
 		return NULL;
 	}
-	cgroup_throttle_swaprate(new_page, GFP_KERNEL);
+	cgroup_throttle_swaprate(&new_folio->page, GFP_KERNEL);
 
-	return new_page;
+	return new_folio;
 }
 
 static int
@@ -986,7 +985,7 @@ copy_pte_range(struct vm_area_struct *ds
 	int progress, ret = 0;
 	int rss[NR_MM_COUNTERS];
 	swp_entry_t entry = (swp_entry_t){0};
-	struct page *prealloc = NULL;
+	struct folio *prealloc = NULL;
 
 again:
 	progress = 0;
@@ -1056,7 +1055,7 @@ again:
 			 * will allocate page according to address).  This
 			 * could only happen if one pinned pte changed.
 			 */
-			put_page(prealloc);
+			folio_put(prealloc);
 			prealloc = NULL;
 		}
 		progress += 8;
@@ -1093,7 +1092,7 @@ again:
 		goto again;
 out:
 	if (unlikely(prealloc))
-		put_page(prealloc);
+		folio_put(prealloc);
 	return ret;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


