Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E27E34C141
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388573; cv=none; b=bwNM240phfdVXYUq2ys6WNdwbxePbt1hcXTCqIhp7paOutE5EoQ6ws1Fp9Ude/SlcFnZGWWjo4uy4HGVi83FRWlWH5drh372Fe8WNW8vBDf/RLL0QSAWPuMUkY5XeYDtrnLGO8wv4G0sw7yk3K+AwcI4Pp9lvFooPyMJ3wrNu3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388573; c=relaxed/simple;
	bh=dRKH3Ml0LRJFhKuPXBZnQAOQZXTFFn9T5SBiURTAWUE=;
	h=Date:To:From:Subject:Message-Id; b=NlgUuN53uG5UzVD7BfPxXDWG0gHjV+cr7B9Ug3cz7NlwGfVqq7IguCq3wTou9sQ7n6OFvoSmbpsiGwL2lzB0y0d8esDzAc/KWFPNKdlqRzACas+0MurAqe39VQhoNG3LPWcR7VCYOdoeoIj7mk9chs3X5YxEoX04fqLP924aguo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xPvTfmQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xPvTfmQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C51C19424;
	Tue, 24 Mar 2026 21:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388572;
	bh=dRKH3Ml0LRJFhKuPXBZnQAOQZXTFFn9T5SBiURTAWUE=;
	h=Date:To:From:Subject:From;
	b=xPvTfmQU+BQeRL6cSj/HtcbGZT7jbzmN76nnopT3at5Nx52RSkbieTYuXuPFaS0Bo
	 oV7VGmjGxmL9cOEv7jdnyt5AREBVdtxFHbBa177jkwAM2LeR8YF1keKctMH7cORckS
	 rUiiF0IJDKbIyz2ZThwbB58LmuIvl1JDwLJ3aDI8=
Date: Tue, 24 Mar 2026 14:42:52 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,vbabka@suse.cz,surenb@google.com,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,linmag7@gmail.com,Liam.Howlett@oracle.com,johannes@sipsolutions.net,jcmvbkbc@gmail.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,david@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,chleroy@kernel.org,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,andreas@gaisler.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page.patch removed from -mm tree
Message-Id: <20260324214252.D3C51C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cache struct page for empty_zero_page and return it from ZERO_PAGE()
has been removed from the -mm tree.  Its filename was
     mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: cache struct page for empty_zero_page and return it from ZERO_PAGE()
Date: Wed, 11 Feb 2026 12:31:41 +0200

For most architectures every invocation of ZERO_PAGE() does
virt_to_page(empty_zero_page).  But empty_zero_page is in BSS and it is
enough to get its struct page once at initialization time and then use it
whenever a zero page should be accessed.

Add yet another __zero_page variable that will be initialized as
virt_to_page(empty_zero_page) for most architectures in a weak
arch_setup_zero_pages() function.

For architectures that use colored zero pages (MIPS and s390) rename their
setup_zero_pages() to arch_setup_zero_pages() and make it global rather
than static.

For architectures that cannot use virt_to_page() for BSS (arm64 and
sparc64) add override of arch_setup_zero_pages().

Link: https://lkml.kernel.org/r/20260211103141.3215197-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h    |    6 ------
 arch/arm64/mm/init.c                |    5 +++++
 arch/mips/mm/init.c                 |   11 +----------
 arch/s390/mm/init.c                 |    4 +---
 arch/sparc/include/asm/pgtable_64.h |    3 ---
 arch/sparc/mm/init_64.c             |   17 +++++++----------
 include/linux/pgtable.h             |   11 ++++++++---
 mm/mm_init.c                        |   21 +++++++++++++++++----
 8 files changed, 39 insertions(+), 39 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page
+++ a/arch/arm64/include/asm/pgtable.h
@@ -106,12 +106,6 @@ static inline void arch_leave_lazy_mmu_m
 #define flush_tlb_fix_spurious_fault_pmd(vma, address, pmdp)	\
 	local_flush_tlb_page_nonotify(vma, address)
 
-/*
- * ZERO_PAGE is a global shared page that is always zero: used
- * for zero-mapped memory areas etc..
- */
-#define ZERO_PAGE(vaddr)	phys_to_page(__pa_symbol(empty_zero_page))
-
 #define pte_ERROR(e)	\
 	pr_err("%s:%d: bad pte %016llx.\n", __FILE__, __LINE__, pte_val(e))
 
--- a/arch/arm64/mm/init.c~mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page
+++ a/arch/arm64/mm/init.c
@@ -328,6 +328,11 @@ void __init bootmem_init(void)
 	memblock_dump_all();
 }
 
+void __init arch_setup_zero_pages(void)
+{
+	__zero_page = phys_to_page(__pa_symbol(empty_zero_page));
+}
+
 void __init arch_mm_preinit(void)
 {
 	unsigned int flags = SWIOTLB_VERBOSE;
--- a/arch/mips/mm/init.c~mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page
+++ a/arch/mips/mm/init.c
@@ -56,10 +56,7 @@ unsigned long empty_zero_page, zero_page
 EXPORT_SYMBOL_GPL(empty_zero_page);
 EXPORT_SYMBOL(zero_page_mask);
 
-/*
- * Not static inline because used by IP27 special magic initialization code
- */
-static void __init setup_zero_pages(void)
+void __init arch_setup_zero_pages(void)
 {
 	unsigned int order;
 
@@ -450,7 +447,6 @@ void __init arch_mm_preinit(void)
 	BUILD_BUG_ON(IS_ENABLED(CONFIG_32BIT) && (PFN_PTE_SHIFT > PAGE_SHIFT));
 
 	maar_init();
-	setup_zero_pages();	/* Setup zeroed pages.  */
 	highmem_init();
 
 #ifdef CONFIG_64BIT
@@ -461,11 +457,6 @@ void __init arch_mm_preinit(void)
 				0x80000000 - 4, KCORE_TEXT);
 #endif
 }
-#else  /* CONFIG_NUMA */
-void __init arch_mm_preinit(void)
-{
-	setup_zero_pages();	/* This comes from node 0 */
-}
 #endif /* !CONFIG_NUMA */
 
 void free_init_pages(const char *what, unsigned long begin, unsigned long end)
--- a/arch/s390/mm/init.c~mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page
+++ a/arch/s390/mm/init.c
@@ -69,7 +69,7 @@ unsigned long empty_zero_page, zero_page
 EXPORT_SYMBOL(empty_zero_page);
 EXPORT_SYMBOL(zero_page_mask);
 
-static void __init setup_zero_pages(void)
+void __init arch_setup_zero_pages(void)
 {
 	unsigned long total_pages = memblock_estimated_nr_free_pages();
 	unsigned int order;
@@ -159,8 +159,6 @@ void __init arch_mm_preinit(void)
 	cpumask_set_cpu(0, mm_cpumask(&init_mm));
 
 	pv_init();
-
-	setup_zero_pages();	/* Setup zeroed pages. */
 }
 
 unsigned long memory_block_size_bytes(void)
--- a/arch/sparc/include/asm/pgtable_64.h~mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -210,9 +210,6 @@ extern unsigned long _PAGE_CACHE;
 extern unsigned long pg_iobits;
 extern unsigned long _PAGE_ALL_SZ_BITS;
 
-extern struct page *mem_map_zero;
-#define ZERO_PAGE(vaddr)	(mem_map_zero)
-
 /* PFNs are real physical page numbers.  However, mem_map only begins to record
  * per-page information starting at pfn_base.  This is to handle systems where
  * the first physical page in the machine is at some huge physical address,
--- a/arch/sparc/mm/init_64.c~mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page
+++ a/arch/sparc/mm/init_64.c
@@ -177,9 +177,6 @@ extern unsigned long sparc_ramdisk_image
 extern unsigned int sparc_ramdisk_image;
 extern unsigned int sparc_ramdisk_size;
 
-struct page *mem_map_zero __read_mostly;
-EXPORT_SYMBOL(mem_map_zero);
-
 unsigned int sparc64_highest_unlocked_tlb_ent __read_mostly;
 
 unsigned long sparc64_kern_pri_context __read_mostly;
@@ -2490,11 +2487,17 @@ static void __init register_page_bootmem
 			register_page_bootmem_info_node(NODE_DATA(i));
 #endif
 }
-void __init mem_init(void)
+
+void __init arch_setup_zero_pages(void)
 {
 	phys_addr_t zero_page_pa = kern_base +
 		((unsigned long)&empty_zero_page[0] - KERNBASE);
 
+	__zero_page = phys_to_page(zero_page_pa);
+}
+
+void __init mem_init(void)
+{
 	/*
 	 * Must be done after boot memory is put on freelist, because here we
 	 * might set fields in deferred struct pages that have not yet been
@@ -2503,12 +2506,6 @@ void __init mem_init(void)
 	 */
 	register_page_bootmem_info();
 
-	/*
-	 * Set up the zero page, mark it reserved, so that page count
-	 * is not manipulated when freeing the page from user ptes.
-	 */
-	mem_map_zero = pfn_to_page(PHYS_PFN(zero_page_pa));
-
 	if (tlb_type == cheetah || tlb_type == cheetah_plus)
 		cheetah_ecache_flush_init();
 }
--- a/include/linux/pgtable.h~mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page
+++ a/include/linux/pgtable.h
@@ -1929,6 +1929,8 @@ static inline void pfnmap_setup_cachemod
  * For architectures that don't __HAVE_COLOR_ZERO_PAGE the zero page lives in
  * empty_zero_page in BSS.
  */
+void arch_setup_zero_pages(void);
+
 #ifdef __HAVE_COLOR_ZERO_PAGE
 static inline int is_zero_pfn(unsigned long pfn)
 {
@@ -1956,10 +1958,13 @@ static inline unsigned long zero_pfn(uns
 }
 
 extern uint8_t empty_zero_page[PAGE_SIZE];
+extern struct page *__zero_page;
 
-#ifndef ZERO_PAGE
-#define ZERO_PAGE(vaddr) ((void)(vaddr),virt_to_page(empty_zero_page))
-#endif
+static inline struct page *_zero_page(unsigned long addr)
+{
+	return __zero_page;
+}
+#define ZERO_PAGE(vaddr) _zero_page(vaddr)
 
 #endif /* __HAVE_COLOR_ZERO_PAGE */
 
--- a/mm/mm_init.c~mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page
+++ a/mm/mm_init.c
@@ -59,7 +59,10 @@ EXPORT_SYMBOL(zero_page_pfn);
 #ifndef __HAVE_COLOR_ZERO_PAGE
 uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
 EXPORT_SYMBOL(empty_zero_page);
-#endif
+
+struct page *__zero_page __ro_after_init;
+EXPORT_SYMBOL(__zero_page);
+#endif /* __HAVE_COLOR_ZERO_PAGE */
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
@@ -2680,12 +2683,21 @@ static void __init mem_init_print_info(v
 		);
 }
 
-static int __init init_zero_page_pfn(void)
+#ifndef __HAVE_COLOR_ZERO_PAGE
+/*
+ * architectures that __HAVE_COLOR_ZERO_PAGE must define this function
+ */
+void __init __weak arch_setup_zero_pages(void)
+{
+	__zero_page = virt_to_page(empty_zero_page);
+}
+#endif
+
+static void __init init_zero_page_pfn(void)
 {
+	arch_setup_zero_pages();
 	zero_page_pfn = page_to_pfn(ZERO_PAGE(0));
-	return 0;
 }
-early_initcall(init_zero_page_pfn);
 
 void __init __weak arch_mm_preinit(void)
 {
@@ -2709,6 +2721,7 @@ void __init mm_core_init_early(void)
 void __init mm_core_init(void)
 {
 	arch_mm_preinit();
+	init_zero_page_pfn();
 
 	/* Initializations relying on SMP setup */
 	BUILD_BUG_ON(MAX_ZONELISTS > 2);
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_get_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
userfaultfd-introduce-vm_uffd_ops-fix.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch
selftests-mm-pagemap_ioctl-remove-hungarian-notation.patch

