Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C1BC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiJCVFN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJCVEo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D81C57
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 719A3610E7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AE2C433C1;
        Mon,  3 Oct 2022 21:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831081;
        bh=Al3FvUbASkZyxP8NiWPWPLZzI9qHN2sD3K7rgbaEl18=;
        h=Date:To:From:Subject:From;
        b=Gz9oN7o87DKK+1RbJ6SCznd2SyLGm1NGyKz3dL39aVtYcufukp3C/c9LR3MbLxaEy
         TciG8BAweIqL3JW/2qn4NxDjap6YjtNllbm9BhbYqTDRppp+rsel2M+r8SrzNUwiYM
         uZzXw2rmYw13DQRF2EIgBY+DlD1iKxRWry9MHDGk=
Date:   Mon, 03 Oct 2022 14:04:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_add_lru_vma.patch removed from -mm tree
Message-Id: <20221003210441.C4AE2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folio_add_lru_vma()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_add_lru_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add folio_add_lru_vma()
Date: Fri, 2 Sep 2022 20:46:01 +0100

Convert lru_cache_add_inactive_or_unevictable() to folio_add_lru_vma()
and add a compatibility wrapper.

Link: https://lkml.kernel.org/r/20220902194653.1739778-6-willy@infradead.org
Signed-off-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   10 +++++-----
 mm/folio-compat.c    |    6 ++++++
 mm/swap.c            |   19 +++++++++----------
 3 files changed, 20 insertions(+), 15 deletions(-)

--- a/include/linux/swap.h~mm-add-folio_add_lru_vma
+++ a/include/linux/swap.h
@@ -379,11 +379,11 @@ extern unsigned long totalreserve_pages;
 
 
 /* linux/mm/swap.c */
-extern void lru_note_cost(struct lruvec *lruvec, bool file,
-			  unsigned int nr_pages);
-extern void lru_note_cost_folio(struct folio *);
-extern void folio_add_lru(struct folio *);
-extern void lru_cache_add(struct page *);
+void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages);
+void lru_note_cost_folio(struct folio *);
+void folio_add_lru(struct folio *);
+void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
+void lru_cache_add(struct page *);
 void mark_page_accessed(struct page *);
 void folio_mark_accessed(struct folio *);
 
--- a/mm/folio-compat.c~mm-add-folio_add_lru_vma
+++ a/mm/folio-compat.c
@@ -88,6 +88,12 @@ void lru_cache_add(struct page *page)
 }
 EXPORT_SYMBOL(lru_cache_add);
 
+void lru_cache_add_inactive_or_unevictable(struct page *page,
+		struct vm_area_struct *vma)
+{
+	folio_add_lru_vma(page_folio(page), vma);
+}
+
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 		pgoff_t index, gfp_t gfp)
 {
--- a/mm/swap.c~mm-add-folio_add_lru_vma
+++ a/mm/swap.c
@@ -537,22 +537,21 @@ void folio_add_lru(struct folio *folio)
 EXPORT_SYMBOL(folio_add_lru);
 
 /**
- * lru_cache_add_inactive_or_unevictable
- * @page:  the page to be added to LRU
- * @vma:   vma in which page is mapped for determining reclaimability
+ * folio_add_lru_vma() - Add a folio to the appropate LRU list for this VMA.
+ * @folio: The folio to be added to the LRU.
+ * @vma: VMA in which the folio is mapped.
  *
- * Place @page on the inactive or unevictable LRU list, depending on its
- * evictability.
+ * If the VMA is mlocked, @folio is added to the unevictable list.
+ * Otherwise, it is treated the same way as folio_add_lru().
  */
-void lru_cache_add_inactive_or_unevictable(struct page *page,
-					 struct vm_area_struct *vma)
+void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
 {
-	VM_BUG_ON_PAGE(PageLRU(page), page);
+	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
 	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
-		mlock_new_page(page);
+		mlock_new_page(&folio->page);
 	else
-		lru_cache_add(page);
+		folio_add_lru(folio);
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are


