Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB55EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjGJXbq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjGJXbm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:31:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF9798
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CAA360C39
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B5CC433C7;
        Mon, 10 Jul 2023 23:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031900;
        bh=krL/SH6/oGyC9h2RtGd1zAb1Oe4/1jvGO1WWrUVhENo=;
        h=Date:To:From:Subject:From;
        b=Tnn97OLx+EiofbRedbydTHe8B+GSawtzB5/QRxRcIqalx9GshybEHpfjTLBANzVkw
         4lsxyRWCTb7ySfA4uWkmJoyn3fHWyerclCe0DX2M8oC1aXJ887VawRkcnwlORYeVJi
         u2Kvh0ta3oOlE2GT62QK7ypATqWFCkn9VSrgz0PA=
Date:   Mon, 10 Jul 2023 16:31:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-do_set_pte-to-set_pte_range.patch added to mm-unstable branch
Message-Id: <20230710233140.74B5CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert do_set_pte() to set_pte_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-do_set_pte-to-set_pte_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-do_set_pte-to-set_pte_range.patch

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
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: mm: convert do_set_pte() to set_pte_range()
Date: Mon, 10 Jul 2023 21:43:37 +0100

set_pte_range() allows to setup page table entries for a specific range. 
It takes advantage of batched rmap update for large folio.  It now takes
care of calling update_mmu_cache_range().

Link: https://lkml.kernel.org/r/20230710204339.3554919-37-willy@infradead.org
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/locking.rst |    2 -
 include/linux/mm.h                    |    3 +
 mm/filemap.c                          |    3 -
 mm/memory.c                           |   37 +++++++++++++++---------
 4 files changed, 28 insertions(+), 17 deletions(-)

--- a/Documentation/filesystems/locking.rst~mm-convert-do_set_pte-to-set_pte_range
+++ a/Documentation/filesystems/locking.rst
@@ -661,7 +661,7 @@ locked. The VM will unlock the page.
 Filesystem should find and map pages associated with offsets from "start_pgoff"
 till "end_pgoff". ->map_pages() is called with the RCU lock held and must
 not block.  If it's not possible to reach a page without blocking,
-filesystem should skip it. Filesystem should use do_set_pte() to setup
+filesystem should skip it. Filesystem should use set_pte_range() to setup
 page table entry. Pointer to entry associated with the page is passed in
 "pte" field in vm_fault structure. Pointers to entries for other offsets
 should be calculated relative to "pte".
--- a/include/linux/mm.h~mm-convert-do_set_pte-to-set_pte_range
+++ a/include/linux/mm.h
@@ -1314,7 +1314,8 @@ static inline pte_t maybe_mkwrite(pte_t
 }
 
 vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page);
-void do_set_pte(struct vm_fault *vmf, struct page *page, unsigned long addr);
+void set_pte_range(struct vm_fault *vmf, struct folio *folio,
+		struct page *page, unsigned int nr, unsigned long addr);
 
 vm_fault_t finish_fault(struct vm_fault *vmf);
 vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf);
--- a/mm/filemap.c~mm-convert-do_set_pte-to-set_pte_range
+++ a/mm/filemap.c
@@ -3501,8 +3501,7 @@ static vm_fault_t filemap_map_folio_rang
 			ret = VM_FAULT_NOPAGE;
 
 		ref_count++;
-		do_set_pte(vmf, page, addr);
-		update_mmu_cache(vma, addr, vmf->pte);
+		set_pte_range(vmf, folio, page, 1, addr);
 	} while (vmf->pte++, page++, addr += PAGE_SIZE, ++count < nr_pages);
 
 	/* Restore the vmf->pte */
--- a/mm/memory.c~mm-convert-do_set_pte-to-set_pte_range
+++ a/mm/memory.c
@@ -4323,15 +4323,24 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 }
 #endif
 
-void do_set_pte(struct vm_fault *vmf, struct page *page, unsigned long addr)
+/**
+ * set_pte_range - Set a range of PTEs to point to pages in a folio.
+ * @vmf: Fault decription.
+ * @folio: The folio that contains @page.
+ * @page: The first page to create a PTE for.
+ * @nr: The number of PTEs to create.
+ * @addr: The first address to create a PTE for.
+ */
+void set_pte_range(struct vm_fault *vmf, struct folio *folio,
+		struct page *page, unsigned int nr, unsigned long addr)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	bool uffd_wp = vmf_orig_pte_uffd_wp(vmf);
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
-	bool prefault = vmf->address != addr;
+	bool prefault = in_range(vmf->address, addr, nr * PAGE_SIZE);
 	pte_t entry;
 
-	flush_icache_page(vma, page);
+	flush_icache_pages(vma, page, nr);
 	entry = mk_pte(page, vma->vm_page_prot);
 
 	if (prefault && arch_wants_old_prefaulted_pte())
@@ -4345,14 +4354,18 @@ void do_set_pte(struct vm_fault *vmf, st
 		entry = pte_mkuffd_wp(entry);
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
-		inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
-		page_add_new_anon_rmap(page, vma, addr);
-		lru_cache_add_inactive_or_unevictable(page, vma);
+		add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr);
+		VM_BUG_ON_FOLIO(nr != 1, folio);
+		folio_add_new_anon_rmap(folio, vma, addr);
+		folio_add_lru_vma(folio, vma);
 	} else {
-		inc_mm_counter(vma->vm_mm, mm_counter_file(page));
-		page_add_file_rmap(page, vma, false);
+		add_mm_counter(vma->vm_mm, mm_counter_file(page), nr);
+		folio_add_file_rmap_range(folio, page, nr, vma, false);
 	}
-	set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
+	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr);
+
+	/* no need to invalidate: a not-present page won't be cached */
+	update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr);
 }
 
 static bool vmf_pte_changed(struct vm_fault *vmf)
@@ -4420,11 +4433,9 @@ vm_fault_t finish_fault(struct vm_fault
 
 	/* Re-check under ptl */
 	if (likely(!vmf_pte_changed(vmf))) {
-		do_set_pte(vmf, page, vmf->address);
-
-		/* no need to invalidate: a not-present page won't be cached */
-		update_mmu_cache(vma, vmf->address, vmf->pte);
+		struct folio *folio = page_folio(page);
 
+		set_pte_range(vmf, folio, page, 1, vmf->address);
 		ret = 0;
 	} else {
 		update_mmu_tlb(vma, vmf->address, vmf->pte);
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

filemap-add-filemap_map_folio_range.patch
rmap-add-folio_add_file_rmap_range.patch
mm-convert-do_set_pte-to-set_pte_range.patch
filemap-batch-pte-mappings.patch

