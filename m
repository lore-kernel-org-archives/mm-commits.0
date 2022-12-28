Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA9FC3DA7A
	for <mm-commits@archiver.kernel.org>; Wed, 28 Dec 2022 23:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiL1X3A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Dec 2022 18:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiL1X27 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2022 18:28:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5EC13F55
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 15:28:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C9FF61626
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 23:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F723C433EF;
        Wed, 28 Dec 2022 23:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672270137;
        bh=sknl2uCpXIQBelcGTZRiefIa93VPBfRFPzT2U9SoD1E=;
        h=Date:To:From:Subject:From;
        b=aDbh6lpVwzi93HbFASSlngXSmi/kbOgjID4Jg3pnzFlyYL9/wjerQWU0fQyOCfqwJ
         FdQHRtYNKHiyXS1DduL1m/NOCSI1feq6tDfhmENWgqUdefUiQSDOebv6igsD33p5Vz
         +JztY0eRZXHWkiJjvODBxi95nH9MUlA6k9jXJbQc=
Date:   Wed, 28 Dec 2022 15:28:57 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        Liam.Howlett@oracle.com, joel@joelfernandes.org, hughd@google.com,
        geert@linux-m68k.org, corbet@lwn.net, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-update-the-interface-to-use-folios.patch added to mm-unstable branch
Message-Id: <20221228232857.9F723C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: update the interface to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mlock-update-the-interface-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-update-the-interface-to-use-folios.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: mlock: update the interface to use folios
Date: Mon, 26 Dec 2022 08:44:22 +0000

This patch updates the mlock interface to accept folios rather than pages,
bringing the interface in line with the internal implementation.

munlock_vma_page() still requires a page_folio() conversion, however this
is consistent with the existent mlock_vma_page() implementation and a
product of rmap still dealing in pages rather than folios.

Link: https://lkml.kernel.org/r/c6555463e07cfe6e68c229ed9b8051f98a884388.1672043615.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/internal.h~mm-mlock-update-the-interface-to-use-folios
+++ a/mm/internal.h
@@ -515,10 +515,9 @@ extern int mlock_future_check(struct mm_
  * should be called with vma's mmap_lock held for read or write,
  * under page table lock for the pte/pmd being added or removed.
  *
- * mlock is usually called at the end of page_add_*_rmap(),
- * munlock at the end of page_remove_rmap(); but new anon
- * pages are managed by lru_cache_add_inactive_or_unevictable()
- * calling mlock_new_page().
+ * mlock is usually called at the end of page_add_*_rmap(), munlock at
+ * the end of page_remove_rmap(); but new anon folios are managed by
+ * folio_add_lru_vma() calling mlock_new_folio().
  *
  * @compound is used to include pmd mappings of THPs, but filter out
  * pte mappings of THPs, which cannot be consistently counted: a pte
@@ -547,15 +546,22 @@ static inline void mlock_vma_page(struct
 	mlock_vma_folio(page_folio(page), vma, compound);
 }
 
-void munlock_page(struct page *page);
-static inline void munlock_vma_page(struct page *page,
+void munlock_folio(struct folio *folio);
+
+static inline void munlock_vma_folio(struct folio *folio,
 			struct vm_area_struct *vma, bool compound)
 {
 	if (unlikely(vma->vm_flags & VM_LOCKED) &&
-	    (compound || !PageTransCompound(page)))
-		munlock_page(page);
+	    (compound || !folio_test_large(folio)))
+		munlock_folio(folio);
+}
+
+static inline void munlock_vma_page(struct page *page,
+			struct vm_area_struct *vma, bool compound)
+{
+	munlock_vma_folio(page_folio(page), vma, compound);
 }
-void mlock_new_page(struct page *page);
+void mlock_new_folio(struct folio *folio);
 bool need_mlock_page_drain(int cpu);
 void mlock_page_drain_local(void);
 void mlock_page_drain_remote(int cpu);
@@ -647,7 +653,7 @@ static inline void mlock_vma_page(struct
 			struct vm_area_struct *vma, bool compound) { }
 static inline void munlock_vma_page(struct page *page,
 			struct vm_area_struct *vma, bool compound) { }
-static inline void mlock_new_page(struct page *page) { }
+static inline void mlock_new_folio(struct folio *folio) { }
 static inline bool need_mlock_page_drain(int cpu) { return false; }
 static inline void mlock_page_drain_local(void) { }
 static inline void mlock_page_drain_remote(int cpu) { }
--- a/mm/mlock.c~mm-mlock-update-the-interface-to-use-folios
+++ a/mm/mlock.c
@@ -262,13 +262,12 @@ void mlock_folio(struct folio *folio)
 }
 
 /**
- * mlock_new_page - mlock a newly allocated page not yet on LRU
- * @page: page to be mlocked, either a normal page or a THP head.
+ * mlock_new_folio - mlock a newly allocated folio not yet on LRU
+ * @folio: folio to be mlocked, either normal or a THP head.
  */
-void mlock_new_page(struct page *page)
+void mlock_new_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
-	struct folio *folio = page_folio(page);
 	int nr_pages = folio_nr_pages(folio);
 
 	local_lock(&mlock_fbatch.lock);
@@ -286,13 +285,12 @@ void mlock_new_page(struct page *page)
 }
 
 /**
- * munlock_page - munlock a page
- * @page: page to be munlocked, either a normal page or a THP head.
+ * munlock_folio - munlock a folio
+ * @folio: folio to be munlocked, either normal or a THP head.
  */
-void munlock_page(struct page *page)
+void munlock_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
-	struct folio *folio = page_folio(page);
 
 	local_lock(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
@@ -314,7 +312,7 @@ static int mlock_pte_range(pmd_t *pmd, u
 	struct vm_area_struct *vma = walk->vma;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte;
-	struct page *page;
+	struct folio *folio;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
@@ -322,11 +320,11 @@ static int mlock_pte_range(pmd_t *pmd, u
 			goto out;
 		if (is_huge_zero_pmd(*pmd))
 			goto out;
-		page = pmd_page(*pmd);
+		folio = page_folio(pmd_page(*pmd));
 		if (vma->vm_flags & VM_LOCKED)
-			mlock_folio(page_folio(page));
+			mlock_folio(folio);
 		else
-			munlock_page(page);
+			munlock_folio(folio);
 		goto out;
 	}
 
@@ -334,15 +332,15 @@ static int mlock_pte_range(pmd_t *pmd, u
 	for (pte = start_pte; addr != end; pte++, addr += PAGE_SIZE) {
 		if (!pte_present(*pte))
 			continue;
-		page = vm_normal_page(vma, addr, *pte);
-		if (!page || is_zone_device_page(page))
+		folio = vm_normal_folio(vma, addr, *pte);
+		if (!folio || folio_is_zone_device(folio))
 			continue;
-		if (PageTransCompound(page))
+		if (folio_test_large(folio))
 			continue;
 		if (vma->vm_flags & VM_LOCKED)
-			mlock_folio(page_folio(page));
+			mlock_folio(folio);
 		else
-			munlock_page(page);
+			munlock_folio(folio);
 	}
 	pte_unmap(start_pte);
 out:
--- a/mm/swap.c~mm-mlock-update-the-interface-to-use-folios
+++ a/mm/swap.c
@@ -562,7 +562,7 @@ void folio_add_lru_vma(struct folio *fol
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
 	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
-		mlock_new_page(&folio->page);
+		mlock_new_folio(folio);
 	else
 		folio_add_lru(folio);
 }
_

Patches currently in -mm which might be from lstoakes@gmail.com are

selftest-vm-add-mremap-expand-merge-offset-test.patch
mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch
mm-pagevec-add-folio_batch_reinit.patch
mm-mlock-use-folios-and-a-folio-batch-internally.patch
m68k-mm-motorola-specify-pmd_page-type.patch
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch

