Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FAEC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECCCB221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781445;
	bh=L3xLOuHZeWx4tiuxNjnHRMHchQP0icitgOp8pj30imc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=KiIhSWapkhtbP4LmKABZOLEteFZaj+LDCDXaCCnfuY77u67wyQzHER6EVMVIjt7Y4
	 xA55RejkT7dz78y/JWd23wzb24rC7oY0PoYzJFgtQrtbxLahgY4EL58OI4TeYxpfX5
	 lZ0EmEP68yOg2JCEl7I/mOZKDqlPRw2R6euIUAPA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgHGGYE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGGYE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0171C22CAF;
        Fri,  7 Aug 2020 06:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781443;
        bh=L3xLOuHZeWx4tiuxNjnHRMHchQP0icitgOp8pj30imc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1ndFTeAroPX0zxYgELw33LLJWxA/CHaMZ2yUDaXGEWUlopHfwE912xUuNLOqeIDWd
         nBe9IeecKpKPZAuKdhsh13t7YDsJ8C7SOhCWdSv4ywrVTH1GbbM3hnvg1RZlqERCK7
         YISiyYuCrTGZ30BD6mkVQntSup5Vh/U9RsNApd90=
Date:   Thu, 06 Aug 2020 23:24:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 120/163] mm/sparse: cleanup the code surrounding
 memory_present()
Message-ID: <20200807062402.6iY5419QD%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm/sparse: cleanup the code surrounding memory_present()

After removal of CONFIG_HAVE_MEMBLOCK_NODE_MAP we have two equivalent
functions that call memory_present() for each region in memblock.memory:
sparse_memory_present_with_active_regions() and membocks_present().

Moreover, all architectures have a call to either of these functions
preceding the call to sparse_init() and in the most cases they are called
one after the other.

Mark the regions from memblock.memory as present during sparce_init() by
making sparse_init() call memblocks_present(), make memblocks_present()
and memory_present() functions static and remove redundant
sparse_memory_present_with_active_regions() function.

Also remove no longer required HAVE_MEMORY_PRESENT configuration option.

Link: http://lkml.kernel.org/r/20200712083130.22919-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/memory-model.rst |    7 ++-----
 arch/arm/mm/init.c                |    9 ++-------
 arch/arm64/mm/init.c              |    6 ++----
 arch/ia64/mm/discontig.c          |    1 -
 arch/microblaze/mm/init.c         |    3 ---
 arch/mips/kernel/setup.c          |    8 --------
 arch/mips/loongson64/numa.c       |    1 -
 arch/mips/sgi-ip27/ip27-memory.c  |    2 --
 arch/parisc/mm/init.c             |    5 -----
 arch/powerpc/mm/mem.c             |    2 --
 arch/powerpc/mm/numa.c            |    1 -
 arch/riscv/mm/init.c              |    1 -
 arch/s390/mm/init.c               |    1 -
 arch/sh/mm/init.c                 |    6 ------
 arch/sh/mm/numa.c                 |    3 ---
 arch/sparc/mm/init_64.c           |    1 -
 arch/x86/mm/init_32.c             |    2 --
 arch/x86/mm/init_64.c             |    1 -
 include/linux/mm.h                |    4 ----
 include/linux/mmzone.h            |   14 --------------
 mm/Kconfig                        |    6 +-----
 mm/page_alloc.c                   |   16 ----------------
 mm/sparse.c                       |   20 ++++++++++++--------
 23 files changed, 19 insertions(+), 101 deletions(-)

--- a/arch/arm64/mm/init.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/arm64/mm/init.c
@@ -430,11 +430,9 @@ void __init bootmem_init(void)
 #endif
 
 	/*
-	 * Sparsemem tries to allocate bootmem in memory_present(), so must be
-	 * done after the fixed reservations.
+	 * sparse_init() tries to allocate memory from memblock, so must be
+	 * done after the fixed reservations
 	 */
-	memblocks_present();
-
 	sparse_init();
 	zone_sizes_init(min, max);
 
--- a/arch/arm/mm/init.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/arm/mm/init.c
@@ -243,13 +243,8 @@ void __init bootmem_init(void)
 		      (phys_addr_t)max_low_pfn << PAGE_SHIFT);
 
 	/*
-	 * Sparsemem tries to allocate bootmem in memory_present(),
-	 * so must be done after the fixed reservations
-	 */
-	memblocks_present();
-
-	/*
-	 * sparse_init() needs the bootmem allocator up and running.
+	 * sparse_init() tries to allocate memory from memblock, so must be
+	 * done after the fixed reservations
 	 */
 	sparse_init();
 
--- a/arch/ia64/mm/discontig.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/ia64/mm/discontig.c
@@ -600,7 +600,6 @@ void __init paging_init(void)
 
 	max_dma = virt_to_phys((void *) MAX_DMA_ADDRESS) >> PAGE_SHIFT;
 
-	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 
 #ifdef CONFIG_VIRTUAL_MEM_MAP
--- a/arch/microblaze/mm/init.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/microblaze/mm/init.c
@@ -172,9 +172,6 @@ void __init setup_memory(void)
 				  &memblock.memory, 0);
 	}
 
-	/* XXX need to clip this if using highmem? */
-	sparse_memory_present_with_active_regions(0);
-
 	paging_init();
 }
 
--- a/arch/mips/kernel/setup.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/mips/kernel/setup.c
@@ -371,14 +371,6 @@ static void __init bootmem_init(void)
 #endif
 	}
 
-
-	/*
-	 * In any case the added to the memblock memory regions
-	 * (highmem/lowmem, available/reserved, etc) are considered
-	 * as present, so inform sparsemem about them.
-	 */
-	memblocks_present();
-
 	/*
 	 * Reserve initrd memory if needed.
 	 */
--- a/arch/mips/loongson64/numa.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/mips/loongson64/numa.c
@@ -220,7 +220,6 @@ static __init void prom_meminit(void)
 			cpumask_clear(&__node_cpumask[node]);
 		}
 	}
-	memblocks_present();
 	max_low_pfn = PHYS_PFN(memblock_end_of_DRAM());
 
 	for (cpu = 0; cpu < loongson_sysconf.nr_cpus; cpu++) {
--- a/arch/mips/sgi-ip27/ip27-memory.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -402,8 +402,6 @@ void __init prom_meminit(void)
 		}
 		__node_data[node] = &null_node;
 	}
-
-	memblocks_present();
 }
 
 void __init prom_free_prom_memory(void)
--- a/arch/parisc/mm/init.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/parisc/mm/init.c
@@ -689,11 +689,6 @@ void __init paging_init(void)
 	flush_cache_all_local(); /* start with known state */
 	flush_tlb_all_local(NULL);
 
-	/*
-	 * Mark all memblocks as present for sparsemem using
-	 * memory_present() and then initialize sparsemem.
-	 */
-	memblocks_present();
 	sparse_init();
 	parisc_bootmem_free();
 }
--- a/arch/powerpc/mm/mem.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/powerpc/mm/mem.c
@@ -183,8 +183,6 @@ void __init mem_topology_setup(void)
 
 void __init initmem_init(void)
 {
-	/* XXX need to clip this if using highmem? */
-	sparse_memory_present_with_active_regions(0);
 	sparse_init();
 }
 
--- a/arch/powerpc/mm/numa.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/powerpc/mm/numa.c
@@ -949,7 +949,6 @@ void __init initmem_init(void)
 
 		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 		setup_node_data(nid, start_pfn, end_pfn);
-		sparse_memory_present_with_active_regions(nid);
 	}
 
 	sparse_init();
--- a/arch/riscv/mm/init.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/riscv/mm/init.c
@@ -544,7 +544,6 @@ void mark_rodata_ro(void)
 void __init paging_init(void)
 {
 	setup_vm_final();
-	memblocks_present();
 	sparse_init();
 	setup_zero_page();
 	zone_sizes_init();
--- a/arch/s390/mm/init.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/s390/mm/init.c
@@ -115,7 +115,6 @@ void __init paging_init(void)
 	__load_psw_mask(psw.mask);
 	kasan_free_early_identity();
 
-	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 	zone_dma_bits = 31;
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
--- a/arch/sh/mm/init.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/sh/mm/init.c
@@ -241,12 +241,6 @@ static void __init do_init_bootmem(void)
 
 	plat_mem_setup();
 
-	for_each_memblock(memory, reg) {
-		int nid = memblock_get_region_node(reg);
-
-		memory_present(nid, memblock_region_memory_base_pfn(reg),
-			memblock_region_memory_end_pfn(reg));
-	}
 	sparse_init();
 }
 
--- a/arch/sh/mm/numa.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/sh/mm/numa.c
@@ -53,7 +53,4 @@ void __init setup_bootmem_node(int nid,
 
 	/* It's up */
 	node_set_online(nid);
-
-	/* Kick sparsemem */
-	sparse_memory_present_with_active_regions(nid);
 }
--- a/arch/sparc/mm/init_64.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/sparc/mm/init_64.c
@@ -1610,7 +1610,6 @@ static unsigned long __init bootmem_init
 
 	/* XXX cpu notifier XXX */
 
-	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 
 	return end_pfn;
--- a/arch/x86/mm/init_32.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/x86/mm/init_32.c
@@ -678,7 +678,6 @@ void __init initmem_init(void)
 #endif
 
 	memblock_set_node(0, PHYS_ADDR_MAX, &memblock.memory, 0);
-	sparse_memory_present_with_active_regions(0);
 
 #ifdef CONFIG_FLATMEM
 	max_mapnr = IS_ENABLED(CONFIG_HIGHMEM) ? highend_pfn : max_low_pfn;
@@ -718,7 +717,6 @@ void __init paging_init(void)
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
 	olpc_dt_build_devicetree();
-	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 	zone_sizes_init();
 }
--- a/arch/x86/mm/init_64.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/arch/x86/mm/init_64.c
@@ -817,7 +817,6 @@ void __init initmem_init(void)
 
 void __init paging_init(void)
 {
-	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 
 	/*
--- a/Documentation/vm/memory-model.rst~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/Documentation/vm/memory-model.rst
@@ -141,11 +141,8 @@ sections:
   `mem_section` objects and the number of rows is calculated to fit
   all the memory sections.
 
-The architecture setup code should call :c:func:`memory_present` for
-each active memory range or use :c:func:`memblocks_present` or
-:c:func:`sparse_memory_present_with_active_regions` wrappers to
-initialize the memory sections. Next, the actual memory maps should be
-set up using :c:func:`sparse_init`.
+The architecture setup code should call sparse_init() to
+initialize the memory sections and the memory maps.
 
 With SPARSEMEM there are two possible ways to convert a PFN to the
 corresponding `struct page` - a "classic sparse" and "sparse
--- a/include/linux/mm.h~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/include/linux/mm.h
@@ -2382,9 +2382,6 @@ static inline unsigned long get_num_phys
  * for_each_valid_physical_page_range()
  * 	memblock_add_node(base, size, nid)
  * free_area_init(max_zone_pfns);
- *
- * sparse_memory_present_with_active_regions() calls memory_present() for
- * each range when SPARSEMEM is enabled.
  */
 void free_area_init(unsigned long *max_zone_pfn);
 unsigned long node_map_pfn_alignment(void);
@@ -2395,7 +2392,6 @@ extern unsigned long absent_pages_in_ran
 extern void get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn);
 extern unsigned long find_min_pfn_with_active_regions(void);
-extern void sparse_memory_present_with_active_regions(int nid);
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 static inline int early_pfn_to_nid(unsigned long pfn)
--- a/include/linux/mmzone.h~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/include/linux/mmzone.h
@@ -839,18 +839,6 @@ static inline struct pglist_data *lruvec
 
 extern unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
 
-#ifdef CONFIG_HAVE_MEMORY_PRESENT
-void memory_present(int nid, unsigned long start, unsigned long end);
-#else
-static inline void memory_present(int nid, unsigned long start, unsigned long end) {}
-#endif
-
-#if defined(CONFIG_SPARSEMEM)
-void memblocks_present(void);
-#else
-static inline void memblocks_present(void) {}
-#endif
-
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
 int local_memory_node(int node_id);
 #else
@@ -1407,8 +1395,6 @@ struct mminit_pfnnid_cache {
 #define early_pfn_valid(pfn)	(1)
 #endif
 
-void memory_present(int nid, unsigned long start, unsigned long end);
-
 /*
  * If it is possible to have holes within a MAX_ORDER_NR_PAGES, then we
  * need to check pfn validity within that MAX_ORDER_NR_PAGES block.
--- a/mm/Kconfig~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/mm/Kconfig
@@ -88,13 +88,9 @@ config NEED_MULTIPLE_NODES
 	def_bool y
 	depends on DISCONTIGMEM || NUMA
 
-config HAVE_MEMORY_PRESENT
-	def_bool y
-	depends on ARCH_HAVE_MEMORY_PRESENT || SPARSEMEM
-
 #
 # SPARSEMEM_EXTREME (which is the default) does some bootmem
-# allocations when memory_present() is called.  If this cannot
+# allocations when sparse_init() is called.  If this cannot
 # be done on your architecture, select this option.  However,
 # statically allocating the mem_section[] array can potentially
 # consume vast quantities of .bss, so be careful.
--- a/mm/page_alloc.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/mm/page_alloc.c
@@ -6325,22 +6325,6 @@ void __meminit init_currently_empty_zone
 }
 
 /**
- * sparse_memory_present_with_active_regions - Call memory_present for each active range
- * @nid: The node to call memory_present for. If MAX_NUMNODES, all nodes will be used.
- *
- * If an architecture guarantees that all ranges registered contain no holes and may
- * be freed, this function may be used instead of calling memory_present() manually.
- */
-void __init sparse_memory_present_with_active_regions(int nid)
-{
-	unsigned long start_pfn, end_pfn;
-	int i, this_nid;
-
-	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, &this_nid)
-		memory_present(this_nid, start_pfn, end_pfn);
-}
-
-/**
  * get_pfn_range_for_nid - Return the start and end page frames for a node
  * @nid: The nid to return the range for. If MAX_NUMNODES, the min and max PFN are returned.
  * @start_pfn: Passed by reference. On return, it will have the node start_pfn.
--- a/mm/sparse.c~mm-sparse-cleanup-the-code-surrounding-memory_present
+++ a/mm/sparse.c
@@ -249,7 +249,7 @@ void __init subsection_map_init(unsigned
 #endif
 
 /* Record a memory area against a node. */
-void __init memory_present(int nid, unsigned long start, unsigned long end)
+static void __init memory_present(int nid, unsigned long start, unsigned long end)
 {
 	unsigned long pfn;
 
@@ -285,11 +285,11 @@ void __init memory_present(int nid, unsi
 }
 
 /*
- * Mark all memblocks as present using memory_present(). This is a
- * convenience function that is useful for a number of arches
- * to mark all of the systems memory as present during initialization.
+ * Mark all memblocks as present using memory_present().
+ * This is a convenience function that is useful to mark all of the systems
+ * memory as present during initialization.
  */
-void __init memblocks_present(void)
+static void __init memblocks_present(void)
 {
 	struct memblock_region *reg;
 
@@ -574,9 +574,13 @@ failed:
  */
 void __init sparse_init(void)
 {
-	unsigned long pnum_begin = first_present_section_nr();
-	int nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
-	unsigned long pnum_end, map_count = 1;
+	unsigned long pnum_end, pnum_begin, map_count = 1;
+	int nid_begin;
+
+	memblocks_present();
+
+	pnum_begin = first_present_section_nr();
+	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
 	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
 	set_pageblock_order();
_
