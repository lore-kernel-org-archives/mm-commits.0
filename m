Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83F1C54EBE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjAPUFq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjAPUFp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:05:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115F623311
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:05:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98E13B810A4
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42718C433EF;
        Mon, 16 Jan 2023 20:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673899540;
        bh=IKuZdhMX2pBJFOhrvi535wvLIG8agmA+ConMh11qoMg=;
        h=Date:To:From:Subject:From;
        b=pNuH11wmDCkDwHRyJ00g9JARKpWsVGSiH2Xnvi0GoNmuVrBiqf7anzoY0G8b1gGjM
         sPMT+DNtN1YHBCHNiEqGkQq01KI8UEQGLC8BAZKndExP1S0PL3ZxV73q+yC682uqfg
         3VYT3NLvt7Y2gWauMZBpabIkY5TgCKl9bp4KI+hA=
Date:   Mon, 16 Jan 2023 12:05:39 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-vma_alloc_zeroed_movable_folio.patch added to mm-unstable branch
Message-Id: <20230116200540.42718C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add vma_alloc_zeroed_movable_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-vma_alloc_zeroed_movable_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-vma_alloc_zeroed_movable_folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add vma_alloc_zeroed_movable_folio()
Date: Mon, 16 Jan 2023 19:18:09 +0000

Patch series "Convert various functions in memory.c to use folios".


This patch (of 5):

Replace alloc_zeroed_user_highpage_movable().  The main difference is
returning a folio containing a single page instead of returning the page,
but take the opportunity to rename the function to match other allocation
functions a little better and rewrite the documentation to place more
emphasis on the zeroing rather than the highmem aspect.

Link: https://lkml.kernel.org/r/20230116191813.2145215-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230116191813.2145215-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/alpha/include/asm/page.h~mm-add-vma_alloc_zeroed_movable_folio
+++ a/arch/alpha/include/asm/page.h
@@ -17,9 +17,8 @@
 extern void clear_page(void *page);
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 
-#define alloc_zeroed_user_highpage_movable(vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
+#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
+	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr, false)
 
 extern void copy_page(void * _to, void * _from);
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
--- a/arch/arm64/include/asm/page.h~mm-add-vma_alloc_zeroed_movable_folio
+++ a/arch/arm64/include/asm/page.h
@@ -29,9 +29,9 @@ void copy_user_highpage(struct page *to,
 void copy_highpage(struct page *to, struct page *from);
 #define __HAVE_ARCH_COPY_HIGHPAGE
 
-struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
+struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 						unsigned long vaddr);
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
+#define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
 
 void tag_clear_highpage(struct page *to);
 #define __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
--- a/arch/arm64/mm/fault.c~mm-add-vma_alloc_zeroed_movable_folio
+++ a/arch/arm64/mm/fault.c
@@ -925,7 +925,7 @@ NOKPROBE_SYMBOL(do_debug_exception);
 /*
  * Used during anonymous page fault handling.
  */
-struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
+struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 						unsigned long vaddr)
 {
 	gfp_t flags = GFP_HIGHUSER_MOVABLE | __GFP_ZERO;
@@ -938,7 +938,7 @@ struct page *alloc_zeroed_user_highpage_
 	if (vma->vm_flags & VM_MTE)
 		flags |= __GFP_ZEROTAGS;
 
-	return alloc_page_vma(flags, vma, vaddr);
+	return vma_alloc_folio(flags, 0, vma, vaddr, false);
 }
 
 void tag_clear_highpage(struct page *page)
--- a/arch/ia64/include/asm/page.h~mm-add-vma_alloc_zeroed_movable_folio
+++ a/arch/ia64/include/asm/page.h
@@ -82,17 +82,15 @@ do {						\
 } while (0)
 
 
-#define alloc_zeroed_user_highpage_movable(vma, vaddr)			\
+#define vma_alloc_zeroed_movable_folio(vma, vaddr)			\
 ({									\
-	struct page *page = alloc_page_vma(				\
-		GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr);		\
-	if (page)							\
- 		flush_dcache_page(page);				\
-	page;								\
+	struct folio *folio = vma_alloc_folio(				\
+		GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr, false); \
+	if (folio)							\
+		flush_dcache_folio(folio);				\
+	folio;								\
 })
 
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
-
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 
 #include <asm-generic/memory_model.h>
--- a/arch/m68k/include/asm/page_no.h~mm-add-vma_alloc_zeroed_movable_folio
+++ a/arch/m68k/include/asm/page_no.h
@@ -13,9 +13,8 @@ extern unsigned long memory_end;
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define alloc_zeroed_user_highpage_movable(vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
+#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
+	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr, false)
 
 #define __pa(vaddr)		((unsigned long)(vaddr))
 #define __va(paddr)		((void *)((unsigned long)(paddr)))
--- a/arch/s390/include/asm/page.h~mm-add-vma_alloc_zeroed_movable_folio
+++ a/arch/s390/include/asm/page.h
@@ -73,9 +73,8 @@ static inline void copy_page(void *to, v
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define alloc_zeroed_user_highpage_movable(vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
+#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
+	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr, false)
 
 /*
  * These are used to make use of C type-checking..
--- a/arch/x86/include/asm/page.h~mm-add-vma_alloc_zeroed_movable_folio
+++ a/arch/x86/include/asm/page.h
@@ -34,9 +34,8 @@ static inline void copy_user_page(void *
 	copy_page(to, from);
 }
 
-#define alloc_zeroed_user_highpage_movable(vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
+#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
+	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr, false)
 
 #ifndef __pa
 #define __pa(x)		__phys_addr((unsigned long)(x))
--- a/include/linux/highmem.h~mm-add-vma_alloc_zeroed_movable_folio
+++ a/include/linux/highmem.h
@@ -208,31 +208,30 @@ static inline void clear_user_highpage(s
 }
 #endif
 
-#ifndef __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
+#ifndef vma_alloc_zeroed_movable_folio
 /**
- * alloc_zeroed_user_highpage_movable - Allocate a zeroed HIGHMEM page for a VMA that the caller knows can move
- * @vma: The VMA the page is to be allocated for
- * @vaddr: The virtual address the page will be inserted into
+ * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.
+ * @vma: The VMA the page is to be allocated for.
+ * @vaddr: The virtual address the page will be inserted into.
  *
- * Returns: The allocated and zeroed HIGHMEM page
+ * This function will allocate a page suitable for inserting into this
+ * VMA at this virtual address.  It may be allocated from highmem or
+ * the movable zone.  An architecture may provide its own implementation.
  *
- * This function will allocate a page for a VMA that the caller knows will
- * be able to migrate in the future using move_pages() or reclaimed
- *
- * An architecture may override this function by defining
- * __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE and providing their own
- * implementation.
+ * Return: A folio containing one allocated and zeroed page or NULL if
+ * we are out of memory.
  */
-static inline struct page *
-alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
+static inline
+struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
-	struct page *page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
+	struct folio *folio;
 
-	if (page)
-		clear_user_highpage(page, vaddr);
+	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr, false);
+	if (folio)
+		clear_user_highpage(&folio->page, vaddr);
 
-	return page;
+	return folio;
 }
 #endif
 
--- a/mm/memory.c~mm-add-vma_alloc_zeroed_movable_folio
+++ a/mm/memory.c
@@ -3056,10 +3056,12 @@ static vm_fault_t wp_page_copy(struct vm
 		goto oom;
 
 	if (is_zero_pfn(pte_pfn(vmf->orig_pte))) {
-		new_page = alloc_zeroed_user_highpage_movable(vma,
-							      vmf->address);
-		if (!new_page)
+		struct folio *new_folio;
+
+		new_folio = vma_alloc_zeroed_movable_folio(vma, vmf->address);
+		if (!new_folio)
 			goto oom;
+		new_page = &new_folio->page;
 	} else {
 		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
 				vmf->address);
@@ -3998,6 +4000,7 @@ static vm_fault_t do_anonymous_page(stru
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page;
+	struct folio *folio;
 	vm_fault_t ret = 0;
 	pte_t entry;
 
@@ -4047,11 +4050,12 @@ static vm_fault_t do_anonymous_page(stru
 	/* Allocate our own private page. */
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
-	page = alloc_zeroed_user_highpage_movable(vma, vmf->address);
-	if (!page)
+	folio = vma_alloc_zeroed_movable_folio(vma, vmf->address);
+	if (!folio)
 		goto oom;
 
-	if (mem_cgroup_charge(page_folio(page), vma->vm_mm, GFP_KERNEL))
+	page = &folio->page;
+	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL))
 		goto oom_free_page;
 	cgroup_throttle_swaprate(page, GFP_KERNEL);
 
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch
mm-memcg-add-folio_memcg_check.patch
mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
mm-add-folio_add_new_anon_rmap-fix-2.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-reimplement-compound_nr-fix.patch
mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch
mm-convert-is_transparent_hugepage-to-use-a-folio.patch
mm-convert-destroy_large_folio-to-use-folio_dtor.patch
hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch
mm-remove-first-tail-page-members-from-struct-page.patch
doc-correct-struct-folio-kernel-doc.patch
mm-move-page-deferred_list-to-folio-_deferred_list.patch
mm-huge_memory-remove-page_deferred_list.patch
mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch
mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch
shmem-convert-shmem_write_end-to-use-a-folio.patch
mm-add-vma_alloc_zeroed_movable_folio.patch
mm-convert-do_anonymous_page-to-use-a-folio.patch
mm-convert-wp_page_copy-to-use-folios.patch
mm-use-a-folio-in-copy_pte_range.patch
mm-use-a-folio-in-copy_present_pte.patch
mm-fs-convert-inode_attach_wb-to-take-a-folio.patch
mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch
mm-remove-page_evictable.patch
mm-remove-mlock_vma_page.patch
mm-remove-munlock_vma_page.patch
mm-clean-up-mlock_page-munlock_page-references-in-comments.patch

