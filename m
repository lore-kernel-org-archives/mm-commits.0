Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD4E2119
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 03:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723000775; cv=none; b=Q+yYK1ZI3UC/VQkP4+6HgnX44IKg2xg9Z9X5KNjrRghWbeLCtgP99iqfYxM19dTb95ppZCfxsVwzgndneSZlceuAHESi1oW3jjxzPwd6Qqv2gDTRLNVmRSr/AeMnkDsJRns1rmXCXL2IA+pJ+2a9ijy05gl4DJ2q50EUW5UJajQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723000775; c=relaxed/simple;
	bh=QFdwtGIGD9+Oky+sPr2v1WIgiOYoZdynV4B57T9Omdc=;
	h=Date:To:From:Subject:Message-Id; b=Au/nv7BfkgxJadMjknpYRGWAlRDq0TQfk2fC9Jh7UQDk+q2vsuY+5ElEtkEHRUocE6rl1ATXwLBQoUlzxt6rkkaMqvjmQRXk1jCE3rXtrKppk3+f9RJiRQQw343ATv1guRbS6ds9oHUgE7anl7eK7h+rSCMM26i2gK/CN3P80VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LRsqlkl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LRsqlkl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906C6C4AF0C;
	Wed,  7 Aug 2024 03:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723000774;
	bh=QFdwtGIGD9+Oky+sPr2v1WIgiOYoZdynV4B57T9Omdc=;
	h=Date:To:From:Subject:From;
	b=LRsqlkl0g5JH3HSRLtoEa/y40hsj2LpC9QoEJKRiOVq1w1mSo6P/UJgNE+MurrQDh
	 ZBOwn6hRkFV1t8/yAKn9QzbG5vLxi/bzWKKRiSXf4ftiXZlmvaqZrlXTAROjEUxN29
	 OOwDLNxPHpxW7Ke5zcrnB2+0ZC+AWQq/PMYtPEfw=
Date: Tue, 06 Aug 2024 20:19:33 -0700
To: mm-commits@vger.kernel.org,yi.zhang@redhat.com,will@kernel.org,tzimmermann@suse.de,tglx@linutronix.de,svens@linux.ibm.com,souravpanda@google.com,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,rdunlap@infradead.org,philmd@linaro.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,npiggin@gmail.com,naveen@kernel.org,namcao@linutronix.de,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,mcgrof@kernel.org,mark.rutland@arm.com,luto@kernel.org,kernel@xen0n.name,kent.overstreet@linux.dev,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dawei.li@shingroup.cn,david@redhat.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,chenjiahao16@huawei.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,bjorn@rivosinc.com,bhe@redhat.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,alison.schofield@intel.com,alexghiti@rivosinc.com,agordeev@linux.ibm.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-keep-nid-around-during-hot-remove.patch added to mm-hotfixes-unstable branch
Message-Id: <20240807031934.906C6C4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: keep nid around during hot-remove
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-keep-nid-around-during-hot-remove.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-keep-nid-around-during-hot-remove.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm: keep nid around during hot-remove
Date: Tue, 6 Aug 2024 22:14:54 +0000

nid is needed during memory hot-remove in order to account the information
about the memmap overhead that is being removed.

In addition, we cannot use page_pgdat(pfn_to_page(pfn)) during hotremove
after remove_pfn_range_from_zone().

We also cannot determine nid from walking through memblocks after
remove_memory_block_devices() is called.

Therefore, pass nid down from the beginning of hotremove to where it is
used for the accounting purposes.

Link: https://lkml.kernel.org/r/20240806221454.1971755-2-pasha.tatashin@soleen.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-cxl/CAHj4cs9Ax1=CoJkgBGP_+sNu6-6=6v=_L-ZBZY0bVLD3wUWZQg@mail.gmail.com
Reported-by: Alison Schofield <alison.schofield@intel.com>
Closes: https://lore.kernel.org/linux-mm/Zq0tPd2h6alFz8XF@aschofie-mobl2/#t
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dawei Li <dawei.li@shingroup.cn>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Philippe Mathieu-Daudé <philmd@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c            |    5 +++--
 arch/loongarch/mm/init.c       |    5 +++--
 arch/powerpc/mm/mem.c          |    5 +++--
 arch/riscv/mm/init.c           |    5 +++--
 arch/s390/mm/init.c            |    5 +++--
 arch/x86/mm/init_64.c          |    5 +++--
 include/linux/memory_hotplug.h |    7 ++++---
 mm/memory_hotplug.c            |   18 +++++++++---------
 mm/memremap.c                  |    6 ++++--
 mm/sparse-vmemmap.c            |   14 ++++++++------
 mm/sparse.c                    |   20 +++++++++++---------
 11 files changed, 54 insertions(+), 41 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-keep-nid-around-during-hot-remove
+++ a/arch/arm64/mm/mmu.c
@@ -1363,12 +1363,13 @@ int arch_add_memory(int nid, u64 start,
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			int nid)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, nid);
 	__remove_pgd_mapping(swapper_pg_dir, __phys_to_virt(start), size);
 }
 
--- a/arch/loongarch/mm/init.c~mm-keep-nid-around-during-hot-remove
+++ a/arch/loongarch/mm/init.c
@@ -106,7 +106,8 @@ int arch_add_memory(int nid, u64 start,
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			int nid)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -115,7 +116,7 @@ void arch_remove_memory(u64 start, u64 s
 	/* With altmap the first mapped page is offset from @start */
 	if (altmap)
 		page += vmem_altmap_offset(altmap);
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, nid);
 }
 
 #ifdef CONFIG_NUMA
--- a/arch/powerpc/mm/mem.c~mm-keep-nid-around-during-hot-remove
+++ a/arch/powerpc/mm/mem.c
@@ -157,12 +157,13 @@ int __ref arch_add_memory(int nid, u64 s
 	return rc;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      int nid)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, nid);
 	arch_remove_linear_mapping(start, size);
 }
 #endif
--- a/arch/riscv/mm/init.c~mm-keep-nid-around-during-hot-remove
+++ a/arch/riscv/mm/init.c
@@ -1789,9 +1789,10 @@ int __ref arch_add_memory(int nid, u64 s
 	return ret;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      int nid)
 {
-	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap);
+	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap, nid);
 	remove_linear_mapping(start, size);
 	flush_tlb_all();
 }
--- a/arch/s390/mm/init.c~mm-keep-nid-around-during-hot-remove
+++ a/arch/s390/mm/init.c
@@ -295,12 +295,13 @@ int arch_add_memory(int nid, u64 start,
 	return rc;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			int nid)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, nid);
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/arch/x86/mm/init_64.c~mm-keep-nid-around-during-hot-remove
+++ a/arch/x86/mm/init_64.c
@@ -1262,12 +1262,13 @@ kernel_physical_mapping_remove(unsigned
 	remove_pagetable(start, end, true, NULL);
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      int nid)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, nid);
 	kernel_physical_mapping_remove(start, start + size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/include/linux/memory_hotplug.h~mm-keep-nid-around-during-hot-remove
+++ a/include/linux/memory_hotplug.h
@@ -201,9 +201,10 @@ static inline bool movable_node_is_enabl
 	return movable_node_enabled;
 }
 
-extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap);
+extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			       int nid);
 extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap);
+			   struct vmem_altmap *altmap, int nid);
 
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
@@ -369,7 +370,7 @@ extern int sparse_add_section(int nid, u
 		unsigned long nr_pages, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-				  struct vmem_altmap *altmap);
+				  struct vmem_altmap *altmap, int nid);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
 extern struct zone *zone_for_pfn_range(int online_type, int nid,
--- a/mm/memory_hotplug.c~mm-keep-nid-around-during-hot-remove
+++ a/mm/memory_hotplug.c
@@ -571,7 +571,7 @@ void __ref remove_pfn_range_from_zone(st
  * calling offline_pages().
  */
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
-		    struct vmem_altmap *altmap)
+		    struct vmem_altmap *altmap, int nid)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
@@ -586,7 +586,7 @@ void __remove_pages(unsigned long pfn, u
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		sparse_remove_section(pfn, cur_nr_pages, altmap);
+		sparse_remove_section(pfn, cur_nr_pages, altmap, nid);
 	}
 }
 
@@ -1386,7 +1386,7 @@ bool mhp_supports_memmap_on_memory(void)
 }
 EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
-static void __ref remove_memory_blocks_and_altmaps(u64 start, u64 size)
+static void __ref remove_memory_blocks_and_altmaps(u64 start, u64 size, int nid)
 {
 	unsigned long memblock_size = memory_block_size_bytes();
 	u64 cur_start;
@@ -1409,7 +1409,7 @@ static void __ref remove_memory_blocks_a
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
-		arch_remove_memory(cur_start, memblock_size, altmap);
+		arch_remove_memory(cur_start, memblock_size, altmap, nid);
 
 		/* Verify that all vmemmap pages have actually been freed. */
 		WARN(altmap->alloc, "Altmap not fully unmapped");
@@ -1454,7 +1454,7 @@ static int create_altmaps_and_memory_blo
 		ret = create_memory_block_devices(cur_start, memblock_size,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, NULL);
+			arch_remove_memory(cur_start, memblock_size, NULL, nid);
 			kfree(params.altmap);
 			goto out;
 		}
@@ -1463,7 +1463,7 @@ static int create_altmaps_and_memory_blo
 	return 0;
 out:
 	if (ret && cur_start != start)
-		remove_memory_blocks_and_altmaps(start, cur_start - start);
+		remove_memory_blocks_and_altmaps(start, cur_start - start, nid);
 	return ret;
 }
 
@@ -1532,7 +1532,7 @@ int __ref add_memory_resource(int nid, s
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap);
+			arch_remove_memory(start, size, params.altmap, nid);
 			goto error;
 		}
 	}
@@ -2275,10 +2275,10 @@ static int __ref try_remove_memory(u64 s
 		 * No altmaps present, do the removal directly
 		 */
 		remove_memory_block_devices(start, size);
-		arch_remove_memory(start, size, NULL);
+		arch_remove_memory(start, size, NULL, nid);
 	} else {
 		/* all memblocks in the range have altmaps */
-		remove_memory_blocks_and_altmaps(start, size);
+		remove_memory_blocks_and_altmaps(start, size, nid);
 	}
 
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
--- a/mm/memremap.c~mm-keep-nid-around-during-hot-remove
+++ a/mm/memremap.c
@@ -112,9 +112,11 @@ static void pageunmap_range(struct dev_p
 {
 	struct range *range = &pgmap->ranges[range_id];
 	struct page *first_page;
+	int nid;
 
 	/* make sure to access a memmap that was actually initialized */
 	first_page = pfn_to_page(pfn_first(pgmap, range_id));
+	nid = page_to_nid(first_page);
 
 	/* pages are dead and unused, undo the arch mapping */
 	mem_hotplug_begin();
@@ -122,10 +124,10 @@ static void pageunmap_range(struct dev_p
 				   PHYS_PFN(range_len(range)));
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		__remove_pages(PHYS_PFN(range->start),
-			       PHYS_PFN(range_len(range)), NULL);
+			       PHYS_PFN(range_len(range)), NULL, nid);
 	} else {
 		arch_remove_memory(range->start, range_len(range),
-				pgmap_altmap(pgmap));
+				   pgmap_altmap(pgmap), nid);
 		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 	}
 	mem_hotplug_done();
--- a/mm/sparse.c~mm-keep-nid-around-during-hot-remove
+++ a/mm/sparse.c
@@ -638,13 +638,15 @@ static struct page * __meminit populate_
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, int nid)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	mod_node_page_state(page_pgdat(pfn_to_page(pfn)), NR_MEMMAP,
-			    -1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
+	if (nid != NUMA_NO_NODE) {
+		mod_node_page_state(NODE_DATA(nid), NR_MEMMAP,
+				    -1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
+	}
 	vmemmap_free(start, end, altmap);
 }
 static void free_map_bootmem(struct page *memmap)
@@ -713,7 +715,7 @@ static struct page * __meminit populate_
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, int nid)
 {
 	kvfree(pfn_to_page(pfn));
 }
@@ -781,7 +783,7 @@ static int fill_subsection_map(unsigned
  * For 2 and 3, the SPARSEMEM_VMEMMAP={y,n} cases are unified
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, int nid)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -821,7 +823,7 @@ static void section_deactivate(unsigned
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early)
-		depopulate_section_memmap(pfn, nr_pages, altmap);
+		depopulate_section_memmap(pfn, nr_pages, altmap, nid);
 	else if (memmap)
 		free_map_bootmem(memmap);
 
@@ -865,7 +867,7 @@ static struct page * __meminit section_a
 
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap);
+		section_deactivate(pfn, nr_pages, altmap, nid);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -928,13 +930,13 @@ int __meminit sparse_add_section(int nid
 }
 
 void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap)
+			   struct vmem_altmap *altmap, int nid)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 
 	if (WARN_ON_ONCE(!valid_section(ms)))
 		return;
 
-	section_deactivate(pfn, nr_pages, altmap);
+	section_deactivate(pfn, nr_pages, altmap, nid);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/mm/sparse-vmemmap.c~mm-keep-nid-around-during-hot-remove
+++ a/mm/sparse-vmemmap.c
@@ -469,12 +469,14 @@ struct page * __meminit __populate_secti
 	if (r < 0)
 		return NULL;
 
-	if (system_state == SYSTEM_BOOTING) {
-		mod_node_early_perpage_metadata(nid, DIV_ROUND_UP(end - start,
-								  PAGE_SIZE));
-	} else {
-		mod_node_page_state(NODE_DATA(nid), NR_MEMMAP,
-				    DIV_ROUND_UP(end - start, PAGE_SIZE));
+	if (nid != NUMA_NO_NODE) {
+		if (system_state == SYSTEM_BOOTING) {
+			mod_node_early_perpage_metadata(nid, DIV_ROUND_UP(end - start,
+									  PAGE_SIZE));
+		} else {
+			mod_node_page_state(NODE_DATA(nid), NR_MEMMAP,
+					    DIV_ROUND_UP(end - start, PAGE_SIZE));
+		}
 	}
 
 	return pfn_to_page(pfn);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-update-the-memmap-stat-before-page-is-freed.patch
mm-keep-nid-around-during-hot-remove.patch
memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch
vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

