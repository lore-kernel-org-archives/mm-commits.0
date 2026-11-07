Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794034448;
	b=pDiAhPKjpqr/91wN+riFTUZzHvRrSXSHmS7P/9AYFuv2naYiDzPBzjNzH8ZnwZaq3nUL
	 uUgNwUltpCcGbkENpXHvlyAyRCh0ESWa2tEw2WXwj/nEwvDauELj1BasPltECVUCBrtxU
	 6ty2OmpsmDEQLvu1UkRS0l0005K+MhpTybNCF/1bF8syD965CyYik7I/Pi/dDolrvtzFy
	 tG0wSUT1gvSDKLmGzLPMjWGtoirXLM8B5SfkXnz631VWRam3p9EPx0rkSZUU/8oH2DXWi
	 X8HOGQv9ZlLlKAdMLMgPmMI41j6kn7XFc1XMs/AFRcOpp/yiGEFsJXHaeSzZ+M5bNfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794034448;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=QrX9uYZspa2Af83ZjQcRqxOlVOP0yMK6XaLdlTAxTNE=;
	b=W8HEXDRixIswxTG9VmOzrnVQOA51DKk10AbBhy9bu5JMB/foLmrK84wG4N2i80cp/HEC
	 tcJjRaMSITpqSjaDeAtIuaqEzg5ISo55rGHPPGhYk+GFOaJhNhjfT+4rffI9Hjoimdado
	 LGs03wv2lUNNHJLRV7BBJDaGvv5IjpfIuACBaELqtjteU9bzd6b6YRhSFtxC/XxHVhCf/
	 qa5F4SzUWg0gzpxnsZJrgCVgLtuq3bPOJrXSHBbQOyYXOpMoEy1Tpxn0wHWLfy3hdpk2s
	 QSTAOmpV+m6T9va9u0/MKUotUqSpH/URawgqByyMPhYjC0d2IpFwl4FsCxrGFzXoqUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mF6NhrNF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF007606A326
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 06:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mF6NhrNF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8651D1F0089F;
	Sat,  7 Nov 2026 06:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794034447;
	bh=QrX9uYZspa2Af83ZjQcRqxOlVOP0yMK6XaLdlTAxTNE=;
	h=Date:To:From:Subject;
	b=mF6NhrNFzMbEWiNC+klsXSqbCM3PFZjAyQB/gPNcU7xjTVNZ5/vKuB8SFBtLyOmZ4
	 Q/h9KABTmNm347HuctM1Dovmk6DiP2sg4I0SXQTzxAVhtJqT6p6w02KT9Kn8SOSpH3
	 DHcosmTj4hx+8qUgdC6yZWk/QA5wh6vKrkJlhoQw=
Date: Fri, 06 Nov 2026 22:54:07 -0800
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,
	ritesh.list@gmail.com,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,lance.yang@linux.dev,
	kernel@xen0n.name,david@kernel.org,chleroy@kernel.org,chenhuacai@kernel.org,
	muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch added to mm-new branch
Message-Id: <20261107065407.8651D1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/sparse-vmemmap: drop @pgmap from vmemmap population APIs
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: drop @pgmap from vmemmap population APIs
Date: Sat, 07 Nov 2026 12:31:22 +0800

The vmemmap population and memory hotplug paths no longer need @pgmap
to decide whether a mapping can be optimized. That state is now carried
in mem_section, and the architecture-specific population code can make
the remaining decisions internally.

Drop the @pgmap parameter from the vmemmap population helpers and the
related memory hotplug interfaces, and remove the remaining
dev_pagemap-specific coupling from those call chains.

Link: https://lore.kernel.org/20261107043122.25650-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
---

 arch/arm64/mm/mmu.c                        |    5 +---
 arch/loongarch/mm/init.c                   |    5 +---
 arch/powerpc/include/asm/book3s/64/radix.h |    1 
 arch/powerpc/mm/mem.c                      |    5 +---
 arch/riscv/mm/init.c                       |    5 +---
 arch/s390/mm/init.c                        |    5 +---
 arch/x86/mm/init_64.c                      |    5 +---
 include/linux/memory_hotplug.h             |    8 ++----
 include/linux/mm.h                         |    3 --
 mm/memory_hotplug.c                        |   16 +++++--------
 mm/memremap.c                              |    4 +--
 mm/sparse-vmemmap.c                        |   23 ++++++++-----------
 mm/sparse.c                                |    6 +---
 13 files changed, 37 insertions(+), 54 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/arch/arm64/mm/mmu.c
@@ -2038,13 +2038,12 @@ err:
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			struct dev_pagemap *pgmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	__remove_pgd_mapping(swapper_pg_dir, __phys_to_virt(start), size);
 }
 
--- a/arch/loongarch/mm/init.c~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/arch/loongarch/mm/init.c
@@ -120,13 +120,12 @@ int arch_add_memory(int nid, u64 start,
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			struct dev_pagemap *pgmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 }
 #endif
 
--- a/arch/powerpc/include/asm/book3s/64/radix.h~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/arch/powerpc/include/asm/book3s/64/radix.h
@@ -316,7 +316,6 @@ static inline int radix__has_transparent
 #endif
 
 struct vmem_altmap;
-struct dev_pagemap;
 extern int __meminit radix__vmemmap_create_mapping(unsigned long start,
 					     unsigned long page_size,
 					     unsigned long phys);
--- a/arch/powerpc/mm/mem.c~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/arch/powerpc/mm/mem.c
@@ -158,13 +158,12 @@ int __ref arch_add_memory(int nid, u64 s
 	return rc;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			      struct dev_pagemap *pgmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	arch_remove_linear_mapping(start, size);
 }
 #endif
--- a/arch/riscv/mm/init.c~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/arch/riscv/mm/init.c
@@ -1749,10 +1749,9 @@ int __ref arch_add_memory(int nid, u64 s
 	return ret;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			      struct dev_pagemap *pgmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
-	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap, pgmap);
+	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap);
 	remove_linear_mapping(start, size);
 	flush_tlb_all();
 }
--- a/arch/s390/mm/init.c~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/arch/s390/mm/init.c
@@ -293,13 +293,12 @@ int arch_add_memory(int nid, u64 start,
 	return rc;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			struct dev_pagemap *pgmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/arch/x86/mm/init_64.c~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/arch/x86/mm/init_64.c
@@ -1273,13 +1273,12 @@ kernel_physical_mapping_remove(unsigned
 	remove_pagetable(start, end, true, NULL);
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			      struct dev_pagemap *pgmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	kernel_physical_mapping_remove(start, start + size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/include/linux/memory_hotplug.h~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/include/linux/memory_hotplug.h
@@ -136,10 +136,9 @@ static inline bool movable_node_is_enabl
 	return movable_node_enabled;
 }
 
-extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			       struct dev_pagemap *pgmap);
+extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap);
 extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+			   struct vmem_altmap *altmap);
 
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
@@ -320,8 +319,7 @@ extern int sparse_add_section(int nid, u
 		unsigned long nr_pages, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-				  struct vmem_altmap *altmap,
-				  struct dev_pagemap *pgmap);
+				  struct vmem_altmap *altmap);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
 		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
--- a/include/linux/mm.h~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/include/linux/mm.h
@@ -5335,8 +5335,7 @@ static inline void print_vma_addr(char *
 #endif
 
 struct page * __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap);
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
--- a/mm/memory_hotplug.c~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/mm/memory_hotplug.c
@@ -416,8 +416,7 @@ int __add_pages(int nid, unsigned long p
 		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
 					 params->pgmap);
 		if (err) {
-			__remove_pages(start_pfn, pfn - start_pfn, altmap,
-				       params->pgmap);
+			__remove_pages(start_pfn, pfn - start_pfn, altmap);
 			break;
 		}
 		cond_resched();
@@ -565,7 +564,6 @@ void remove_pfn_range_from_zone(struct z
  * @pfn: starting pageframe (must be aligned to start of a section)
  * @nr_pages: number of pages to remove (must be multiple of section size)
  * @altmap: alternative device page map or %NULL if default memmap is used
- * @pgmap: device page map or %NULL if not ZONE_DEVICE
  *
  * Generic helper function to remove section mappings and sysfs entries
  * for the section of the memory we are removing. Caller needs to make
@@ -573,7 +571,7 @@ void remove_pfn_range_from_zone(struct z
  * calling offline_pages().
  */
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
-		    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		    struct vmem_altmap *altmap)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
@@ -588,7 +586,7 @@ void __remove_pages(unsigned long pfn, u
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		sparse_remove_section(pfn, cur_nr_pages, altmap, pgmap);
+		sparse_remove_section(pfn, cur_nr_pages, altmap);
 	}
 }
 
@@ -1421,7 +1419,7 @@ static void remove_memory_blocks_and_alt
 		memory_block_put(mem);
 
 		remove_memory_block_devices(cur_start, memblock_size);
-		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
+		arch_remove_memory(cur_start, memblock_size, altmap);
 		altmap_free(altmap);
 	}
 }
@@ -1461,7 +1459,7 @@ static int create_altmaps_and_memory_blo
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, params.altmap, NULL);
+			arch_remove_memory(cur_start, memblock_size, params.altmap);
 			altmap_free(params.altmap);
 			goto out;
 		}
@@ -1548,7 +1546,7 @@ static int __add_memory_resource(int nid
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap, NULL);
+			arch_remove_memory(start, size, params.altmap);
 			goto error;
 		}
 	}
@@ -2309,7 +2307,7 @@ static int try_remove_memory(u64 start,
 		 * No altmaps present, do the removal directly
 		 */
 		remove_memory_block_devices(start, size);
-		arch_remove_memory(start, size, NULL, NULL);
+		arch_remove_memory(start, size, NULL);
 	} else {
 		/* all memblocks in the range have altmaps */
 		remove_memory_blocks_and_altmaps(start, size);
--- a/mm/memremap.c~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/mm/memremap.c
@@ -97,10 +97,10 @@ static void pageunmap_range(struct dev_p
 				   PHYS_PFN(range_len(range)));
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		__remove_pages(PHYS_PFN(range->start),
-			       PHYS_PFN(range_len(range)), NULL, pgmap);
+			       PHYS_PFN(range_len(range)), NULL);
 	} else {
 		arch_remove_memory(range->start, range_len(range),
-				pgmap_altmap(pgmap), pgmap);
+				pgmap_altmap(pgmap));
 		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 	}
 	mem_hotplug_done();
--- a/mm/sparse.c~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/mm/sparse.c
@@ -204,8 +204,7 @@ void __init sparse_sections_init(void)
 }
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
 	const unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
@@ -236,8 +235,7 @@ static void __init sparse_metadata_init_
 		if (section_nr >= end_section_nr)
 			break;
 
-		mem_map = __populate_section_memmap(pfn, PAGES_PER_SECTION, nid,
-						    NULL, NULL);
+		mem_map = __populate_section_memmap(pfn, PAGES_PER_SECTION, nid, NULL);
 		if (!mem_map)
 			panic("Failed to allocate memmap for section %lu\n",
 			      section_nr);
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis
+++ a/mm/sparse-vmemmap.c
@@ -479,8 +479,7 @@ int __meminit vmemmap_populate_hugepages
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -572,11 +571,9 @@ void offline_mem_sections(unsigned long
 }
 
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
-	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
-						      pgmap);
+	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap);
 
 	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages));
 
@@ -584,7 +581,7 @@ static struct page * __meminit populate_
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -665,7 +662,7 @@ static int fill_subsection_map(unsigned
  * usage map, but still need to free the vmemmap range.
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -703,7 +700,7 @@ static void section_deactivate(unsigned
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early)
-		depopulate_section_memmap(pfn, nr_pages, altmap, pgmap);
+		depopulate_section_memmap(pfn, nr_pages, altmap);
 	else if (memmap)
 		free_map_bootmem(memmap);
 
@@ -752,9 +749,9 @@ static struct page * __meminit section_a
 		return pfn_to_page(pfn);
 
 	section_set_compound_order_range(pfn, nr_pages, order);
-	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap);
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap, pgmap);
+		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -818,13 +815,13 @@ int __meminit sparse_add_section(int nid
 }
 
 void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 
 	if (WARN_ON_ONCE(!valid_section(ms)))
 		return;
 
-	section_deactivate(pfn, nr_pages, altmap, pgmap);
+	section_deactivate(pfn, nr_pages, altmap);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch
powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
loongarch-mm-disable-device-dax-vmemmap-optimization.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch

