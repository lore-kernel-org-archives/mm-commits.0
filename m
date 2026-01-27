Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5739931619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486641; cv=none; b=NbbcWmc0aUU3PzTZ6YgX9QggcVGb03wiO0Ocrz0rEBi/i5B3Fklo4I4STn9fLR3n1h/5YEhbOsh0514kpvA5bbwLuTitNdtKI1Z4zRz0qJJSK7G7dGIeaGa/u0f/8t6NhaNrDDnBJuKJ7AON/3D+IuFTs1U/QKXS9qJk/fPUuH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486641; c=relaxed/simple;
	bh=KrU7MkZLXMdG78LD/gjoKsg7jpHAWBQDVKeNMgjtFZw=;
	h=Date:To:From:Subject:Message-Id; b=oqkH2uADXe9OGeHwRsBIWQUdWVpiS+yORWQ7gW9U+0E31JrdklmTdlRTBSjlKTPdzzXxkBjzDcvHhDkqhB7wAK+um+x3dLtR+G3OFOtuXXeXrcO8Cb547qpoeAZ27QB0AZxXCecVppq3gIP9JIaZMScdZMudUqm1xaroyma/GkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GhPLVFPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GhPLVFPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B25C116C6;
	Tue, 27 Jan 2026 04:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486641;
	bh=KrU7MkZLXMdG78LD/gjoKsg7jpHAWBQDVKeNMgjtFZw=;
	h=Date:To:From:Subject:From;
	b=GhPLVFPTxjmpR7nI+addu2csMEmh/WpDhtp4yneILXN59r0Aj54T9MkSxh587edWh
	 FJReRBPIswSmifX41JFu5MPeUMSEUqli48iRcIcnSn6wXkNgGtQV4A7dhhoECcPwoc
	 Y//taSRBwHI+nTTHtHGAowPLFG09zBUvihWBjNMU=
Date: Mon, 26 Jan 2026 20:04:00 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,surenb@google.com,shorne@gmail.com,ritesh.list@gmail.com,richard@nod.at,pratyush@kernel.org,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,linmag7@gmail.com,liam.howlett@oracle.com,klarasmodin@gmail.com,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,david@kernel.org,davem@davemloft.net,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,andreas@gaisler.com,alexs@kernel.org,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arch-mm-consolidate-initialization-of-sparse-memory-model.patch removed from -mm tree
Message-Id: <20260127040401.24B25C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch, mm: consolidate initialization of SPARSE memory model
has been removed from the -mm tree.  Its filename was
     arch-mm-consolidate-initialization-of-sparse-memory-model.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: arch, mm: consolidate initialization of SPARSE memory model
Date: Sun, 11 Jan 2026 10:20:58 +0200

Every architecture calls sparse_init() during setup_arch() although the
data structures created by sparse_init() are not used until the
initialization of the core MM.

Beside the code duplication, calling sparse_init() from architecture
specific code causes ordering differences of vmemmap and HVO
initialization on different architectures.

Move the call to sparse_init() from architecture specific code to
free_area_init() to ensure that vmemmap and HVO initialization order is
always the same.

Link: https://lkml.kernel.org/r/20260111082105.290734-25-rppt@kernel.org
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

 Documentation/mm/memory-model.rst                    |    3 --
 Documentation/translations/zh_CN/mm/memory-model.rst |    2 -
 arch/alpha/kernel/setup.c                            |    1 
 arch/arm/mm/init.c                                   |    6 -----
 arch/arm64/mm/init.c                                 |    6 -----
 arch/csky/kernel/setup.c                             |    2 -
 arch/loongarch/kernel/setup.c                        |    8 -------
 arch/mips/kernel/setup.c                             |   11 ----------
 arch/parisc/mm/init.c                                |    2 -
 arch/powerpc/include/asm/setup.h                     |    4 +++
 arch/powerpc/mm/mem.c                                |    5 ----
 arch/powerpc/mm/numa.c                               |    2 -
 arch/riscv/mm/init.c                                 |    1 
 arch/s390/mm/init.c                                  |    1 
 arch/sh/mm/init.c                                    |    2 -
 arch/sparc/mm/init_64.c                              |    2 -
 arch/x86/mm/init_32.c                                |    1 
 arch/x86/mm/init_64.c                                |    2 -
 include/linux/mmzone.h                               |    2 -
 mm/internal.h                                        |    6 +++++
 mm/mm_init.c                                         |    1 
 21 files changed, 11 insertions(+), 59 deletions(-)

--- a/arch/alpha/kernel/setup.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/alpha/kernel/setup.c
@@ -607,7 +607,6 @@ setup_arch(char **cmdline_p)
 	/* Find our memory.  */
 	setup_memory(kernel_end);
 	memblock_set_bottom_up(true);
-	sparse_init();
 
 	/* First guess at cpu cache sizes.  Do this before init_arch.  */
 	determine_cpu_caches(cpu->type);
--- a/arch/arm64/mm/init.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/arm64/mm/init.c
@@ -321,12 +321,6 @@ void __init bootmem_init(void)
 #endif
 
 	kvm_hyp_reserve();
-
-	/*
-	 * sparse_init() tries to allocate memory from memblock, so must be
-	 * done after the fixed reservations
-	 */
-	sparse_init();
 	dma_limits_init();
 
 	/*
--- a/arch/arm/mm/init.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/arm/mm/init.c
@@ -207,12 +207,6 @@ void __init bootmem_init(void)
 
 	early_memtest((phys_addr_t)min_low_pfn << PAGE_SHIFT,
 		      (phys_addr_t)max_low_pfn << PAGE_SHIFT);
-
-	/*
-	 * sparse_init() tries to allocate memory from memblock, so must be
-	 * done after the fixed reservations
-	 */
-	sparse_init();
 }
 
 /*
--- a/arch/csky/kernel/setup.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/csky/kernel/setup.c
@@ -123,8 +123,6 @@ void __init setup_arch(char **cmdline_p)
 	setup_smp();
 #endif
 
-	sparse_init();
-
 	fixaddr_init();
 
 #ifdef CONFIG_HIGHMEM
--- a/arch/loongarch/kernel/setup.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/loongarch/kernel/setup.c
@@ -402,14 +402,6 @@ static void __init arch_mem_init(char **
 
 	check_kernel_sections_mem();
 
-	/*
-	 * In order to reduce the possibility of kernel panic when failed to
-	 * get IO TLB memory under CONFIG_SWIOTLB, it is better to allocate
-	 * low memory as small as possible before swiotlb_init(), so make
-	 * sparse_init() using top-down allocation.
-	 */
-	memblock_set_bottom_up(false);
-	sparse_init();
 	memblock_set_bottom_up(true);
 
 	swiotlb_init(true, SWIOTLB_VERBOSE);
--- a/arch/mips/kernel/setup.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/mips/kernel/setup.c
@@ -614,7 +614,6 @@ static void __init bootcmdline_init(void
  * kernel but generic memory management system is still entirely uninitialized.
  *
  *  o bootmem_init()
- *  o sparse_init()
  *  o paging_init()
  *  o dma_contiguous_reserve()
  *
@@ -665,16 +664,6 @@ static void __init arch_mem_init(char **
 	mips_parse_crashkernel();
 	device_tree_init();
 
-	/*
-	 * In order to reduce the possibility of kernel panic when failed to
-	 * get IO TLB memory under CONFIG_SWIOTLB, it is better to allocate
-	 * low memory as small as possible before plat_swiotlb_setup(), so
-	 * make sparse_init() using top-down allocation.
-	 */
-	memblock_set_bottom_up(false);
-	sparse_init();
-	memblock_set_bottom_up(true);
-
 	plat_swiotlb_setup();
 
 	dma_contiguous_reserve(PFN_PHYS(max_low_pfn));
--- a/arch/parisc/mm/init.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/parisc/mm/init.c
@@ -706,8 +706,6 @@ void __init paging_init(void)
 	fixmap_init();
 	flush_cache_all_local(); /* start with known state */
 	flush_tlb_all_local(NULL);
-
-	sparse_init();
 }
 
 static void alloc_btlb(unsigned long start, unsigned long end, int *slot,
--- a/arch/powerpc/include/asm/setup.h~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/powerpc/include/asm/setup.h
@@ -20,7 +20,11 @@ extern void reloc_got2(unsigned long);
 
 void check_for_initrd(void);
 void mem_topology_setup(void);
+#ifdef CONFIG_NUMA
 void initmem_init(void);
+#else
+static inline void initmem_init(void) {}
+#endif
 void setup_panic(void);
 #define ARCH_PANIC_TIMEOUT 180
 
--- a/arch/powerpc/mm/mem.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/powerpc/mm/mem.c
@@ -182,11 +182,6 @@ void __init mem_topology_setup(void)
 	memblock_set_node(0, PHYS_ADDR_MAX, &memblock.memory, 0);
 }
 
-void __init initmem_init(void)
-{
-	sparse_init();
-}
-
 /* mark pages that don't exist as nosave */
 static int __init mark_nonram_nosave(void)
 {
--- a/arch/powerpc/mm/numa.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/powerpc/mm/numa.c
@@ -1213,8 +1213,6 @@ void __init initmem_init(void)
 		setup_node_data(nid, start_pfn, end_pfn);
 	}
 
-	sparse_init();
-
 	/*
 	 * We need the numa_cpu_lookup_table to be accurate for all CPUs,
 	 * even before we online them, so that we can use cpu_to_{node,mem}
--- a/arch/riscv/mm/init.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/riscv/mm/init.c
@@ -1430,7 +1430,6 @@ void __init misc_mem_init(void)
 {
 	early_memtest(min_low_pfn << PAGE_SHIFT, max_low_pfn << PAGE_SHIFT);
 	arch_numa_init();
-	sparse_init();
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 	/* The entire VMEMMAP region has been populated. Flush TLB for this region */
 	local_flush_tlb_kernel_range(VMEMMAP_START, VMEMMAP_END);
--- a/arch/s390/mm/init.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/s390/mm/init.c
@@ -98,7 +98,6 @@ void __init arch_zone_limits_init(unsign
 void __init paging_init(void)
 {
 	vmem_map_init();
-	sparse_init();
 	zone_dma_limit = DMA_BIT_MASK(31);
 }
 
--- a/arch/sh/mm/init.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/sh/mm/init.c
@@ -227,8 +227,6 @@ static void __init do_init_bootmem(void)
 	node_set_online(0);
 
 	plat_mem_setup();
-
-	sparse_init();
 }
 
 static void __init early_reserve_mem(void)
--- a/arch/sparc/mm/init_64.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/sparc/mm/init_64.c
@@ -1615,8 +1615,6 @@ static unsigned long __init bootmem_init
 
 	/* XXX cpu notifier XXX */
 
-	sparse_init();
-
 	return end_pfn;
 }
 
--- a/arch/x86/mm/init_32.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/x86/mm/init_32.c
@@ -654,7 +654,6 @@ void __init paging_init(void)
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
 	olpc_dt_build_devicetree();
-	sparse_init();
 }
 
 /*
--- a/arch/x86/mm/init_64.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/arch/x86/mm/init_64.c
@@ -833,8 +833,6 @@ void __init initmem_init(void)
 
 void __init paging_init(void)
 {
-	sparse_init();
-
 	/*
 	 * clear the default setting with node 0
 	 * note: don't use nodes_clear here, that is really clearing when
--- a/Documentation/mm/memory-model.rst~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/Documentation/mm/memory-model.rst
@@ -97,9 +97,6 @@ sections:
   `mem_section` objects and the number of rows is calculated to fit
   all the memory sections.
 
-The architecture setup code should call sparse_init() to
-initialize the memory sections and the memory maps.
-
 With SPARSEMEM there are two possible ways to convert a PFN to the
 corresponding `struct page` - a "classic sparse" and "sparse
 vmemmap". The selection is made at build time and it is determined by
--- a/Documentation/translations/zh_CN/mm/memory-model.rst~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/Documentation/translations/zh_CN/mm/memory-model.rst
@@ -83,8 +83,6 @@ 大小和位置取决于 `CONFIG_SPARSEM
   每一行包含价值 `PAGE_SIZE` 的 `mem_section` 对象，行数的计算是为了适应所有的
   内存区。
 
-架构设置代码应该调用sparse_init()来初始化内存区和内存映射。
-
 通过SPARSEMEM，有两种可能的方式将PFN转换为相应的 `struct page` --"classic sparse"和
  "sparse vmemmap"。选择是在构建时进行的，它由 `CONFIG_SPARSEMEM_VMEMMAP` 的
  值决定。
--- a/include/linux/mmzone.h~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/include/linux/mmzone.h
@@ -2286,9 +2286,7 @@ static inline unsigned long next_present
 #define pfn_to_nid(pfn)		(0)
 #endif
 
-void sparse_init(void);
 #else
-#define sparse_init()	do {} while (0)
 #define sparse_index_init(_sec, _nid)  do {} while (0)
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
--- a/mm/internal.h~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/mm/internal.h
@@ -852,6 +852,12 @@ void memmap_init_range(unsigned long, in
 		unsigned long, enum meminit_context, struct vmem_altmap *, int,
 		bool);
 
+#ifdef CONFIG_SPARSEMEM
+void sparse_init(void);
+#else
+static inline void sparse_init(void) {}
+#endif /* CONFIG_SPARSEMEM */
+
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
--- a/mm/mm_init.c~arch-mm-consolidate-initialization-of-sparse-memory-model
+++ a/mm/mm_init.c
@@ -1825,6 +1825,7 @@ static void __init free_area_init(void)
 	bool descending;
 
 	arch_zone_limits_init(max_zone_pfn);
+	sparse_init();
 
 	start_pfn = PHYS_PFN(memblock_start_of_DRAM());
 	descending = arch_has_descending_max_zone_pfns();
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-cleanup-error-handling-in-kho_populate.patch

