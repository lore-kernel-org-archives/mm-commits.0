Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E04C001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 18:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjHBSyF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 14:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbjHBSxc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 14:53:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0AB2129
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 11:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46E5C61AB6
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 18:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971A7C433C8;
        Wed,  2 Aug 2023 18:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691002392;
        bh=ad185qcGiSGY9u+lRx7N6ieo4aVErM/b4NNhYjbh1cw=;
        h=Date:To:From:Subject:From;
        b=a3QvVehlq/4m1N5Y1+gy4WqKJrJr600+MBRhpakFAmme7AptUCsdisP8geKrlHod+
         8Y7oREhvd7mQ7/DfKhWSimqxpsRtgvuYyfUB/Lm7BRV6FbHk3V8I88++WRqn1eKkQG
         u3/sAY8kaJ5PujLwxy6b0vzlMVjeRsx5l3Zmnq+0=
Date:   Wed, 02 Aug 2023 11:53:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rationalise-flush_icache_pages-and-flush_icache_page.patch added to mm-unstable branch
Message-Id: <20230802185312.971A7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rationalise flush_icache_pages() and flush_icache_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rationalise-flush_icache_pages-and-flush_icache_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rationalise-flush_icache_pages-and-flush_icache_page.patch

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
Subject: mm: rationalise flush_icache_pages() and flush_icache_page()
Date: Wed, 2 Aug 2023 16:13:59 +0100

Move the default (no-op) implementation of flush_icache_pages() to
<linux/cacheflush.h> from <asm-generic/cacheflush.h>.  Remove the
flush_icache_page() wrapper from each architecture into
<linux/cacheflush.h>.

Link: https://lkml.kernel.org/r/20230802151406.3735276-32-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/cacheflush.h     |    5 +----
 arch/arc/include/asm/cacheflush.h       |    9 ---------
 arch/arm/include/asm/cacheflush.h       |    7 -------
 arch/csky/abiv1/inc/abi/cacheflush.h    |    1 -
 arch/csky/abiv2/inc/abi/cacheflush.h    |    1 -
 arch/hexagon/include/asm/cacheflush.h   |    2 +-
 arch/loongarch/include/asm/cacheflush.h |    2 --
 arch/m68k/include/asm/cacheflush_mm.h   |    1 -
 arch/mips/include/asm/cacheflush.h      |    6 ------
 arch/nios2/include/asm/cacheflush.h     |    2 +-
 arch/parisc/include/asm/cacheflush.h    |    2 +-
 arch/sh/include/asm/cacheflush.h        |    2 +-
 arch/sparc/include/asm/cacheflush_32.h  |    2 --
 arch/sparc/include/asm/cacheflush_64.h  |    3 ---
 arch/xtensa/include/asm/cacheflush.h    |    4 ----
 include/asm-generic/cacheflush.h        |   12 ------------
 include/linux/cacheflush.h              |    9 +++++++++
 17 files changed, 14 insertions(+), 56 deletions(-)

--- a/arch/alpha/include/asm/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/alpha/include/asm/cacheflush.h
@@ -53,10 +53,6 @@ extern void flush_icache_user_page(struc
 #define flush_icache_user_page flush_icache_user_page
 #endif /* CONFIG_SMP */
 
-/* This is used only in __do_fault and do_swap_page.  */
-#define flush_icache_page(vma, page) \
-	flush_icache_user_page((vma), (page), 0, 0)
-
 /*
  * Both implementations of flush_icache_user_page flush the entire
  * address space, so one call, no matter how many pages.
@@ -66,6 +62,7 @@ static inline void flush_icache_pages(st
 {
 	flush_icache_user_page(vma, page, 0, 0);
 }
+#define flush_icache_pages flush_icache_pages
 
 #include <asm-generic/cacheflush.h>
 
--- a/arch/arc/include/asm/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/arc/include/asm/cacheflush.h
@@ -18,15 +18,6 @@
 #include <linux/mm.h>
 #include <asm/shmparam.h>
 
-/*
- * Semantically we need this because icache doesn't snoop dcache/dma.
- * However ARC Cache flush requires paddr as well as vaddr, latter not available
- * in the flush_icache_page() API. So we no-op it but do the equivalent work
- * in update_mmu_cache()
- */
-#define flush_icache_page(vma, page)
-#define flush_icache_pages(vma, page, nr)
-
 void flush_cache_all(void);
 
 void flush_icache_range(unsigned long kstart, unsigned long kend);
--- a/arch/arm/include/asm/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/arm/include/asm/cacheflush.h
@@ -322,13 +322,6 @@ static inline void flush_anon_page(struc
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages)
 
 /*
- * We don't appear to need to do anything here.  In fact, if we did, we'd
- * duplicate cache flushing elsewhere performed by flush_dcache_page().
- */
-#define flush_icache_page(vma,page)	do { } while (0)
-#define flush_icache_pages(vma, page, nr)	do { } while (0)
-
-/*
  * flush_cache_vmap() is used when creating mappings (eg, via vmap,
  * vmalloc, ioremap etc) in kernel space for pages.  On non-VIPT
  * caches, since the direct-mappings of these pages may contain cached
--- a/arch/csky/abiv1/inc/abi/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/csky/abiv1/inc/abi/cacheflush.h
@@ -45,7 +45,6 @@ extern void flush_cache_range(struct vm_
 #define flush_cache_vmap(start, end)		cache_wbinv_all()
 #define flush_cache_vunmap(start, end)		cache_wbinv_all()
 
-#define flush_icache_page(vma, page)		do {} while (0);
 #define flush_icache_range(start, end)		cache_wbinv_range(start, end)
 #define flush_icache_mm_range(mm, start, end)	cache_wbinv_range(start, end)
 #define flush_icache_deferred(mm)		do {} while (0);
--- a/arch/csky/abiv2/inc/abi/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/csky/abiv2/inc/abi/cacheflush.h
@@ -33,7 +33,6 @@ static inline void flush_dcache_page(str
 
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
-#define flush_icache_page(vma, page)		do { } while (0)
 
 #define flush_icache_range(start, end)		cache_wbinv_range(start, end)
 
--- a/arch/hexagon/include/asm/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/hexagon/include/asm/cacheflush.h
@@ -18,7 +18,7 @@
  *  - flush_cache_range(vma, start, end) flushes a range of pages
  *  - flush_icache_range(start, end) flush a range of instructions
  *  - flush_dcache_page(pg) flushes(wback&invalidates) a page for dcache
- *  - flush_icache_page(vma, pg) flushes(invalidates) a page for icache
+ *  - flush_icache_pages(vma, pg, nr) flushes(invalidates) nr pages for icache
  *
  *  Need to doublecheck which one is really needed for ptrace stuff to work.
  */
--- a/arch/loongarch/include/asm/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/loongarch/include/asm/cacheflush.h
@@ -46,8 +46,6 @@ void local_flush_icache_range(unsigned l
 #define flush_cache_page(vma, vmaddr, pfn)		do { } while (0)
 #define flush_cache_vmap(start, end)			do { } while (0)
 #define flush_cache_vunmap(start, end)			do { } while (0)
-#define flush_icache_page(vma, page)			do { } while (0)
-#define flush_icache_pages(vma, page)			do { } while (0)
 #define flush_icache_user_page(vma, page, addr, len)	do { } while (0)
 #define flush_dcache_page(page)				do { } while (0)
 #define flush_dcache_mmap_lock(mapping)			do { } while (0)
--- a/arch/m68k/include/asm/cacheflush_mm.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/m68k/include/asm/cacheflush_mm.h
@@ -261,7 +261,6 @@ static inline void __flush_pages_to_ram(
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 #define flush_icache_pages(vma, page, nr)	\
 	__flush_pages_to_ram(page_address(page), nr)
-#define flush_icache_page(vma, page) flush_icache_pages(vma, page, 1)
 
 extern void flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 				    unsigned long addr, int len);
--- a/arch/mips/include/asm/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/mips/include/asm/cacheflush.h
@@ -82,12 +82,6 @@ static inline void flush_anon_page(struc
 		__flush_anon_page(page, vmaddr);
 }
 
-static inline void flush_icache_pages(struct vm_area_struct *vma,
-		struct page *page, unsigned int nr)
-{
-}
-#define flush_icache_page(vma, page) flush_icache_pages(vma, page, 1)
-
 extern void (*flush_icache_range)(unsigned long start, unsigned long end);
 extern void (*local_flush_icache_range)(unsigned long start, unsigned long end);
 extern void (*__flush_icache_user_range)(unsigned long start,
--- a/arch/nios2/include/asm/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/nios2/include/asm/cacheflush.h
@@ -35,7 +35,7 @@ void flush_dcache_folio(struct folio *fo
 extern void flush_icache_range(unsigned long start, unsigned long end);
 void flush_icache_pages(struct vm_area_struct *vma, struct page *page,
 		unsigned int nr);
-#define flush_icache_page(vma, page) flush_icache_pages(vma, page, 1);
+#define flush_icache_pages flush_icache_pages
 
 #define flush_cache_vmap(start, end)		flush_dcache_range(start, end)
 #define flush_cache_vunmap(start, end)		flush_dcache_range(start, end)
--- a/arch/parisc/include/asm/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/parisc/include/asm/cacheflush.h
@@ -60,7 +60,7 @@ static inline void flush_dcache_page(str
 
 void flush_icache_pages(struct vm_area_struct *vma, struct page *page,
 		unsigned int nr);
-#define flush_icache_page(vma, page)	flush_icache_pages(vma, page, 1)
+#define flush_icache_pages flush_icache_pages
 
 #define flush_icache_range(s,e)		do { 		\
 	flush_kernel_dcache_range_asm(s,e); 		\
--- a/arch/sh/include/asm/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/sh/include/asm/cacheflush.h
@@ -53,7 +53,7 @@ extern void flush_icache_range(unsigned
 #define flush_icache_user_range flush_icache_range
 void flush_icache_pages(struct vm_area_struct *vma, struct page *page,
 		unsigned int nr);
-#define flush_icache_page(vma, page) flush_icache_pages(vma, page, 1)
+#define flush_icache_pages flush_icache_pages
 extern void flush_cache_sigtramp(unsigned long address);
 
 struct flusher_data {
--- a/arch/sparc/include/asm/cacheflush_32.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/sparc/include/asm/cacheflush_32.h
@@ -16,8 +16,6 @@
 #define flush_cache_page(vma,addr,pfn) \
 	sparc32_cachetlb_ops->cache_page(vma, addr)
 #define flush_icache_range(start, end)		do { } while (0)
-#define flush_icache_page(vma, pg)		do { } while (0)
-#define flush_icache_pages(vma, pg, nr)		do { } while (0)
 
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
 	do {							\
--- a/arch/sparc/include/asm/cacheflush_64.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/sparc/include/asm/cacheflush_64.h
@@ -53,9 +53,6 @@ static inline void flush_dcache_page(str
 	flush_dcache_folio(page_folio(page));
 }
 
-#define flush_icache_page(vma, pg)	do { } while(0)
-#define flush_icache_pages(vma, pg, nr)	do { } while(0)
-
 void flush_ptrace_access(struct vm_area_struct *, struct page *,
 			 unsigned long uaddr, void *kaddr,
 			 unsigned long len, int write);
--- a/arch/xtensa/include/asm/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/arch/xtensa/include/asm/cacheflush.h
@@ -160,10 +160,6 @@ void local_flush_cache_page(struct vm_ar
 		__invalidate_icache_range(start,(end) - (start));	\
 	} while (0)
 
-/* This is not required, see Documentation/core-api/cachetlb.rst */
-#define	flush_icache_page(vma,page)			do { } while (0)
-#define	flush_icache_pages(vma, page, nr)		do { } while (0)
-
 #define flush_dcache_mmap_lock(mapping)			do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)		do { } while (0)
 
--- a/include/asm-generic/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/include/asm-generic/cacheflush.h
@@ -77,18 +77,6 @@ static inline void flush_icache_range(un
 #define flush_icache_user_range flush_icache_range
 #endif
 
-#ifndef flush_icache_page
-static inline void flush_icache_pages(struct vm_area_struct *vma,
-				     struct page *page, unsigned int nr)
-{
-}
-
-static inline void flush_icache_page(struct vm_area_struct *vma,
-				     struct page *page)
-{
-}
-#endif
-
 #ifndef flush_icache_user_page
 static inline void flush_icache_user_page(struct vm_area_struct *vma,
 					   struct page *page,
--- a/include/linux/cacheflush.h~mm-rationalise-flush_icache_pages-and-flush_icache_page
+++ a/include/linux/cacheflush.h
@@ -17,4 +17,13 @@ static inline void flush_dcache_folio(st
 #define flush_dcache_folio flush_dcache_folio
 #endif /* ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE */
 
+#ifndef flush_icache_pages
+static inline void flush_icache_pages(struct vm_area_struct *vma,
+				     struct page *page, unsigned int nr)
+{
+}
+#endif
+
+#define flush_icache_page(vma, page)	flush_icache_pages(vma, page, 1)
+
 #endif /* _LINUX_CACHEFLUSH_H */
_

Patches currently in -mm which might be from willy@infradead.org are

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
rmap-pass-the-folio-to-__page_check_anon_rmap.patch
highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch
affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
affs-convert-data-read-and-write-to-use-folios.patch
migrate-use-folio_set_bh-instead-of-set_bh_page.patch
ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch
jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch
buffer-remove-set_bh_page.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-remove-config_per_vma_lock-ifdefs.patch
mm-allow-per-vma-locks-on-file-backed-vmas.patch
mm-move-fault_flag_vma_lock-check-from-handle_mm_fault.patch
mm-handle-pud-faults-under-the-vma-lock.patch
mm-handle-some-pmd-faults-under-the-vma-lock.patch
mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch
mm-move-fault_flag_vma_lock-check-down-from-do_fault.patch
mm-run-the-fault-around-code-under-the-vma-lock.patch
mm-handle-swap-and-numa-pte-faults-under-the-vma-lock.patch
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock-fix.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

