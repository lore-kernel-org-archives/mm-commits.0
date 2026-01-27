Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC0331619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486647; cv=none; b=rDzmGPaeu3vWAefIxR2gYM8DZpmGgx4T73NiEqA0GMqzgTzVFMqLyba1B59mBUrrGjmwuORG/+OJoiMf2QorDQvdWPPQEyX7RaxF0QrPQYwXDQN9L9u33Wb4phJkbzR8LYKC4YyWA4QrsiDNnF5QSa07EgVxbwTrH/IrcxE+Zzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486647; c=relaxed/simple;
	bh=V3g4LwrLNDYWVI/FxdY9zfJdSVb+fakPZwjQMWQiRLE=;
	h=Date:To:From:Subject:Message-Id; b=JxqsCBOlQnw1Apy40FsTDtGi7VJA2BXIuXboJMDLK2qBa4e12pgx700q64x2YlyI4rE6I7Adpeb0u8/o7euk+kbLWYMby5ZsGZsHqRJWQ/uAQ9GATNjnZVIFRjSOXf9GBZoqgANYGTnjsWZOEXbN+x0RjLWy6d/Shop5FM5qgCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SNSy6ySH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SNSy6ySH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAF4C116C6;
	Tue, 27 Jan 2026 04:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486647;
	bh=V3g4LwrLNDYWVI/FxdY9zfJdSVb+fakPZwjQMWQiRLE=;
	h=Date:To:From:Subject:From;
	b=SNSy6ySH8TNAaP7HJCd7oxENUHjmXgedmiqGNoM/IWnHOTiuG4Ovq6644v5n+UuIJ
	 +ZhSKWjcuyqzPIi612svldGwLkrvkak1U3PgRr10JYdNVaotNyJRWplpxXoQGDOxrR
	 7UoU+voBNYY+CuKLv3UkBUhw99CHCFqnUZxJoWSQ=
Date: Mon, 26 Jan 2026 20:04:06 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,surenb@google.com,shorne@gmail.com,ritesh.list@gmail.com,richard@nod.at,pratyush@kernel.org,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,linmag7@gmail.com,liam.howlett@oracle.com,klarasmodin@gmail.com,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,david@kernel.org,davem@davemloft.net,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,andreas@gaisler.com,alexs@kernel.org,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-arch-consolidate-hugetlb-cma-reservation.patch removed from -mm tree
Message-Id: <20260127040407.3EAF4C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, arch: consolidate hugetlb CMA reservation
has been removed from the -mm tree.  Its filename was
     mm-arch-consolidate-hugetlb-cma-reservation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm, arch: consolidate hugetlb CMA reservation
Date: Sun, 11 Jan 2026 10:21:01 +0200

Every architecture that supports hugetlb_cma command line parameter
reserves CMA areas for hugetlb during setup_arch().

This obfuscates the ordering of hugetlb CMA initialization with respect to
the rest initialization of the core MM.

Introduce arch_hugetlb_cma_order() callback to allow architectures report
the desired order-per-bit of CMA areas and provide a week implementation
of arch_hugetlb_cma_order() for architectures that don't support hugetlb
with CMA.

Use this callback in hugetlb_cma_reserve() instead if passing the order as
parameter and call hugetlb_cma_reserve() from mm_core_init_early() rather
than have it spread over architecture specific code.

Link: https://lkml.kernel.org/r/20260111082105.290734-28-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/driver-api/cxl/linux/early-boot.rst |    2 -
 arch/arm64/include/asm/hugetlb.h                  |    2 -
 arch/arm64/mm/hugetlbpage.c                       |   10 +-----
 arch/arm64/mm/init.c                              |    9 -----
 arch/powerpc/include/asm/hugetlb.h                |    5 ---
 arch/powerpc/kernel/setup-common.c                |    1 
 arch/powerpc/mm/hugetlbpage.c                     |   11 ++----
 arch/riscv/mm/hugetlbpage.c                       |    8 +++++
 arch/riscv/mm/init.c                              |    2 -
 arch/s390/kernel/setup.c                          |    2 -
 arch/s390/mm/hugetlbpage.c                        |    8 +++++
 arch/x86/kernel/setup.c                           |    4 --
 arch/x86/mm/hugetlbpage.c                         |    8 +++++
 include/linux/hugetlb.h                           |    6 ++-
 mm/hugetlb_cma.c                                  |   19 ++++++++----
 mm/mm_init.c                                      |    1 
 16 files changed, 51 insertions(+), 47 deletions(-)

--- a/arch/arm64/include/asm/hugetlb.h~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -56,8 +56,6 @@ extern void huge_pte_clear(struct mm_str
 #define __HAVE_ARCH_HUGE_PTEP_GET
 extern pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 
-void __init arm64_hugetlb_cma_reserve(void);
-
 #define huge_ptep_modify_prot_start huge_ptep_modify_prot_start
 extern pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma,
 					 unsigned long addr, pte_t *ptep);
--- a/arch/arm64/mm/hugetlbpage.c~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -36,16 +36,12 @@
  * huge pages could still be served from those areas.
  */
 #ifdef CONFIG_CMA
-void __init arm64_hugetlb_cma_reserve(void)
+unsigned int arch_hugetlb_cma_order(void)
 {
-	int order;
-
 	if (pud_sect_supported())
-		order = PUD_SHIFT - PAGE_SHIFT;
-	else
-		order = CONT_PMD_SHIFT - PAGE_SHIFT;
+		return PUD_SHIFT - PAGE_SHIFT;
 
-	hugetlb_cma_reserve(order);
+	return CONT_PMD_SHIFT - PAGE_SHIFT;
 }
 #endif /* CONFIG_CMA */
 
--- a/arch/arm64/mm/init.c~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/arch/arm64/mm/init.c
@@ -311,15 +311,6 @@ void __init bootmem_init(void)
 
 	arch_numa_init();
 
-	/*
-	 * must be done after arch_numa_init() which calls numa_init() to
-	 * initialize node_online_map that gets used in hugetlb_cma_reserve()
-	 * while allocating required CMA size across online nodes.
-	 */
-#if defined(CONFIG_HUGETLB_PAGE) && defined(CONFIG_CMA)
-	arm64_hugetlb_cma_reserve();
-#endif
-
 	kvm_hyp_reserve();
 	dma_limits_init();
 
--- a/arch/powerpc/include/asm/hugetlb.h~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/arch/powerpc/include/asm/hugetlb.h
@@ -68,7 +68,6 @@ int huge_ptep_set_access_flags(struct vm
 			       unsigned long addr, pte_t *ptep,
 			       pte_t pte, int dirty);
 
-void gigantic_hugetlb_cma_reserve(void) __init;
 #include <asm-generic/hugetlb.h>
 
 #else /* ! CONFIG_HUGETLB_PAGE */
@@ -77,10 +76,6 @@ static inline void flush_hugetlb_page(st
 {
 }
 
-static inline void __init gigantic_hugetlb_cma_reserve(void)
-{
-}
-
 static inline void __init hugetlbpage_init_defaultsize(void)
 {
 }
--- a/arch/powerpc/kernel/setup-common.c~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/arch/powerpc/kernel/setup-common.c
@@ -1003,7 +1003,6 @@ void __init setup_arch(char **cmdline_p)
 	fadump_cma_init();
 	kdump_cma_reserve();
 	kvm_cma_reserve();
-	gigantic_hugetlb_cma_reserve();
 
 	early_memtest(min_low_pfn << PAGE_SHIFT, max_low_pfn << PAGE_SHIFT);
 
--- a/arch/powerpc/mm/hugetlbpage.c~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -200,18 +200,15 @@ static int __init hugetlbpage_init(void)
 
 arch_initcall(hugetlbpage_init);
 
-void __init gigantic_hugetlb_cma_reserve(void)
+unsigned int __init arch_hugetlb_cma_order(void)
 {
-	unsigned long order = 0;
-
 	if (radix_enabled())
-		order = PUD_SHIFT - PAGE_SHIFT;
+		return PUD_SHIFT - PAGE_SHIFT;
 	else if (!firmware_has_feature(FW_FEATURE_LPAR) && mmu_psize_defs[MMU_PAGE_16G].shift)
 		/*
 		 * For pseries we do use ibm,expected#pages for reserving 16G pages.
 		 */
-		order = mmu_psize_to_shift(MMU_PAGE_16G) - PAGE_SHIFT;
+		return mmu_psize_to_shift(MMU_PAGE_16G) - PAGE_SHIFT;
 
-	if (order)
-		hugetlb_cma_reserve(order);
+	return 0;
 }
--- a/arch/riscv/mm/hugetlbpage.c~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/arch/riscv/mm/hugetlbpage.c
@@ -447,3 +447,11 @@ static __init int gigantic_pages_init(vo
 }
 arch_initcall(gigantic_pages_init);
 #endif
+
+unsigned int __init arch_hugetlb_cma_order(void)
+{
+	if (IS_ENABLED(CONFIG_64BIT))
+		return PUD_SHIFT - PAGE_SHIFT;
+
+	return 0;
+}
--- a/arch/riscv/mm/init.c~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/arch/riscv/mm/init.c
@@ -311,8 +311,6 @@ static void __init setup_bootmem(void)
 		memblock_reserve(dtb_early_pa, fdt_totalsize(dtb_early_va));
 
 	dma_contiguous_reserve(dma32_phys_limit);
-	if (IS_ENABLED(CONFIG_64BIT))
-		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
 }
 
 #ifdef CONFIG_RELOCATABLE
--- a/arch/s390/kernel/setup.c~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/arch/s390/kernel/setup.c
@@ -963,8 +963,6 @@ void __init setup_arch(char **cmdline_p)
 	setup_uv();
 	dma_contiguous_reserve(ident_map_size);
 	vmcp_cma_reserve();
-	if (cpu_has_edat2())
-		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
 
 	reserve_crashkernel();
 #ifdef CONFIG_CRASH_DUMP
--- a/arch/s390/mm/hugetlbpage.c~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/arch/s390/mm/hugetlbpage.c
@@ -255,3 +255,11 @@ bool __init arch_hugetlb_valid_size(unsi
 	else
 		return false;
 }
+
+unsigned int __init arch_hugetlb_cma_order(void)
+{
+	if (cpu_has_edat2())
+		return PUD_SHIFT - PAGE_SHIFT;
+
+	return 0;
+}
--- a/arch/x86/kernel/setup.c~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/arch/x86/kernel/setup.c
@@ -1189,10 +1189,6 @@ void __init setup_arch(char **cmdline_p)
 	initmem_init();
 	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
 
-	if (boot_cpu_has(X86_FEATURE_GBPAGES)) {
-		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
-	}
-
 	/*
 	 * Reserve memory for crash kernel after SRAT is parsed so that it
 	 * won't consume hotpluggable memory.
--- a/arch/x86/mm/hugetlbpage.c~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/arch/x86/mm/hugetlbpage.c
@@ -42,3 +42,11 @@ static __init int gigantic_pages_init(vo
 arch_initcall(gigantic_pages_init);
 #endif
 #endif
+
+unsigned int __init arch_hugetlb_cma_order(void)
+{
+	if (boot_cpu_has(X86_FEATURE_GBPAGES))
+		return PUD_SHIFT - PAGE_SHIFT;
+
+	return 0;
+}
--- a/Documentation/driver-api/cxl/linux/early-boot.rst~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/Documentation/driver-api/cxl/linux/early-boot.rst
@@ -125,7 +125,7 @@ The contiguous memory allocator (CMA) en
 regions on NUMA nodes during early boot.  However, CMA cannot reserve memory
 on NUMA nodes that are not online during early boot. ::
 
-  void __init hugetlb_cma_reserve(int order) {
+  void __init hugetlb_cma_reserve(void) {
     if (!node_online(nid))
       /* do not allow reservations */
   }
--- a/include/linux/hugetlb.h~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/include/linux/hugetlb.h
@@ -281,6 +281,8 @@ void fixup_hugetlb_reservations(struct v
 void hugetlb_split(struct vm_area_struct *vma, unsigned long addr);
 int hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 
+unsigned int arch_hugetlb_cma_order(void);
+
 #else /* !CONFIG_HUGETLB_PAGE */
 
 static inline void hugetlb_dup_vma_private(struct vm_area_struct *vma)
@@ -1322,9 +1324,9 @@ static inline spinlock_t *huge_pte_lock(
 }
 
 #if defined(CONFIG_HUGETLB_PAGE) && defined(CONFIG_CMA)
-extern void __init hugetlb_cma_reserve(int order);
+extern void __init hugetlb_cma_reserve(void);
 #else
-static inline __init void hugetlb_cma_reserve(int order)
+static inline __init void hugetlb_cma_reserve(void)
 {
 }
 #endif
--- a/mm/hugetlb_cma.c~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/mm/hugetlb_cma.c
@@ -134,12 +134,24 @@ static int __init cmdline_parse_hugetlb_
 
 early_param("hugetlb_cma_only", cmdline_parse_hugetlb_cma_only);
 
-void __init hugetlb_cma_reserve(int order)
+unsigned int __weak arch_hugetlb_cma_order(void)
 {
-	unsigned long size, reserved, per_node;
+	return 0;
+}
+
+void __init hugetlb_cma_reserve(void)
+{
+	unsigned long size, reserved, per_node, order;
 	bool node_specific_cma_alloc = false;
 	int nid;
 
+	if (!hugetlb_cma_size)
+		return;
+
+	order = arch_hugetlb_cma_order();
+	if (!order)
+		return;
+
 	/*
 	 * HugeTLB CMA reservation is required for gigantic
 	 * huge pages which could not be allocated via the
@@ -149,9 +161,6 @@ void __init hugetlb_cma_reserve(int orde
 	VM_WARN_ON(order <= MAX_PAGE_ORDER);
 	cma_reserve_called = true;
 
-	if (!hugetlb_cma_size)
-		return;
-
 	hugetlb_bootmem_set_nodes();
 
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
--- a/mm/mm_init.c~mm-arch-consolidate-hugetlb-cma-reservation
+++ a/mm/mm_init.c
@@ -2677,6 +2677,7 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
+	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
 	free_area_init();
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-cleanup-error-handling-in-kho_populate.patch

