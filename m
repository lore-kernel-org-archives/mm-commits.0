Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A11636F433
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027641; cv=none; b=RjrgO8/f9mG/zYPX8BEDBY2RSNOfr99cVc75+sOecFDjCmjBEC4J1JLw7HSpMXhCTx3R7SaubpudmKReuFdEC15MNpwaSxju4dk3Nk63VoqT7wkvT/AUowbeggZZtDPFbClN/a0t6CZ4sJjtuxXiraJmfU7sR89QMvYiU/KgO1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027641; c=relaxed/simple;
	bh=vdOB+OTYdGJmwUg/t5mU4xBi7OoJEryz9ZgiQq5YZHg=;
	h=Date:To:From:Subject:Message-Id; b=GIwdHx/mNe2gvX+NMWYL3qL3DHcV4YPHVPM6UwbZwVqnrfOr0zFEJmkPhjDMzS5x9/ZyoSjaRLOlIKr9n2U2F5sZrbCnHIF9po8YXnSHP17RSKb3YImQr/QKhOctXL7CjmhQqnTxFaSnqJQjLKfn44MJDKleoVVddbzhUWJTtn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xOnyg3/D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xOnyg3/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D138A1F00898;
	Fri, 29 May 2026 04:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027634;
	bh=URIzDsc44aK15c/rI62fv1c1zADCJTl1EIN3P1rGEh8=;
	h=Date:To:From:Subject;
	b=xOnyg3/DGoURkD9I4y/1GzLK1Ot6YhSOo8iifSWFoPnTwcP+Jq6tceWgnGJVemnqy
	 ZbIaxRYNO+cuvbSYNWUxFtnNl5g8TGXOVP/0wACzZbtyg1Qmbp7dhw5jIBwm6S65NB
	 5utRTqRlW292yr8P/8WmWIwDVD80wSwDYk69U12E=
Date: Thu, 28 May 2026 21:07:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,joao.m.martins@oracle.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch removed from -mm tree
Message-Id: <20260529040714.D138A1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: pass @pgmap argument to memory deactivation paths
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: pass @pgmap argument to memory deactivation paths
Date: Tue, 28 Apr 2026 16:18:52 +0800

Currently, the memory hot-remove call chain -- arch_remove_memory(),
__remove_pages(), sparse_remove_section() and section_deactivate() -- does
not carry the struct dev_pagemap pointer.  This prevents the lower levels
from knowing whether the section was originally populated with vmemmap
optimizations (e.g., DAX with vmemmap optimization enabled).

Without this information, we cannot call vmemmap_can_optimize() to
determine if the vmemmap pages were optimized.  As a result, the vmemmap
page accounting during teardown will mistakenly assume a non-optimized
allocation, leading to incorrect memmap statistics.

To lay the groundwork for fixing the vmemmap page accounting, we need to
pass the @pgmap pointer down to the deactivation location.  Plumb the
@pgmap argument through the APIs of arch_remove_memory(), __remove_pages()
and sparse_remove_section(), mirroring the corresponding *_activate()
paths.

Link: https://lore.kernel.org/20260428081855.1249045-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Liam R. Howlett <liam@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c            |    5 +++--
 arch/loongarch/mm/init.c       |    5 +++--
 arch/powerpc/mm/mem.c          |    5 +++--
 arch/riscv/mm/init.c           |    5 +++--
 arch/s390/mm/init.c            |    5 +++--
 arch/x86/mm/init_64.c          |    5 +++--
 include/linux/memory_hotplug.h |    8 +++++---
 mm/memory_hotplug.c            |   13 +++++++------
 mm/memremap.c                  |    4 ++--
 mm/sparse-vmemmap.c            |   12 ++++++------
 10 files changed, 38 insertions(+), 29 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths
+++ a/arch/arm64/mm/mmu.c
@@ -2024,12 +2024,13 @@ err:
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	__remove_pgd_mapping(swapper_pg_dir, __phys_to_virt(start), size);
 }
 
--- a/arch/loongarch/mm/init.c~mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths
+++ a/arch/loongarch/mm/init.c
@@ -119,12 +119,13 @@ int arch_add_memory(int nid, u64 start,
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 }
 #endif
 
--- a/arch/powerpc/mm/mem.c~mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths
+++ a/arch/powerpc/mm/mem.c
@@ -158,12 +158,13 @@ int __ref arch_add_memory(int nid, u64 s
 	return rc;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	arch_remove_linear_mapping(start, size);
 }
 #endif
--- a/arch/riscv/mm/init.c~mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths
+++ a/arch/riscv/mm/init.c
@@ -1742,9 +1742,10 @@ int __ref arch_add_memory(int nid, u64 s
 	return ret;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
-	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap);
+	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap, pgmap);
 	remove_linear_mapping(start, size);
 	flush_tlb_all();
 }
--- a/arch/s390/mm/init.c~mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths
+++ a/arch/s390/mm/init.c
@@ -276,12 +276,13 @@ int arch_add_memory(int nid, u64 start,
 	return rc;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/arch/x86/mm/init_64.c~mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths
+++ a/arch/x86/mm/init_64.c
@@ -1288,12 +1288,13 @@ kernel_physical_mapping_remove(unsigned
 	remove_pagetable(start, end, true, NULL);
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	kernel_physical_mapping_remove(start, start + size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/include/linux/memory_hotplug.h~mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths
+++ a/include/linux/memory_hotplug.h
@@ -135,9 +135,10 @@ static inline bool movable_node_is_enabl
 	return movable_node_enabled;
 }
 
-extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap);
+extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap);
 extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap);
+			   struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
@@ -307,7 +308,8 @@ extern int sparse_add_section(int nid, u
 		unsigned long nr_pages, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-				  struct vmem_altmap *altmap);
+				  struct vmem_altmap *altmap,
+				  struct dev_pagemap *pgmap);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
 		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
--- a/mm/memory_hotplug.c~mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths
+++ a/mm/memory_hotplug.c
@@ -576,6 +576,7 @@ void remove_pfn_range_from_zone(struct z
  * @pfn: starting pageframe (must be aligned to start of a section)
  * @nr_pages: number of pages to remove (must be multiple of section size)
  * @altmap: alternative device page map or %NULL if default memmap is used
+ * @pgmap: device page map or %NULL if not ZONE_DEVICE
  *
  * Generic helper function to remove section mappings and sysfs entries
  * for the section of the memory we are removing. Caller needs to make
@@ -583,7 +584,7 @@ void remove_pfn_range_from_zone(struct z
  * calling offline_pages().
  */
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
-		    struct vmem_altmap *altmap)
+		    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
@@ -598,7 +599,7 @@ void __remove_pages(unsigned long pfn, u
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		sparse_remove_section(pfn, cur_nr_pages, altmap);
+		sparse_remove_section(pfn, cur_nr_pages, altmap, pgmap);
 	}
 }
 
@@ -1427,7 +1428,7 @@ static void remove_memory_blocks_and_alt
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
-		arch_remove_memory(cur_start, memblock_size, altmap);
+		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
 
 		/* Verify that all vmemmap pages have actually been freed. */
 		WARN(altmap->alloc, "Altmap not fully unmapped");
@@ -1470,7 +1471,7 @@ static int create_altmaps_and_memory_blo
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, params.altmap);
+			arch_remove_memory(cur_start, memblock_size, params.altmap, NULL);
 			kfree(params.altmap);
 			goto out;
 		}
@@ -1556,7 +1557,7 @@ int add_memory_resource(int nid, struct
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap);
+			arch_remove_memory(start, size, params.altmap, NULL);
 			goto error;
 		}
 	}
@@ -2268,7 +2269,7 @@ static int try_remove_memory(u64 start,
 		 * No altmaps present, do the removal directly
 		 */
 		remove_memory_block_devices(start, size);
-		arch_remove_memory(start, size, NULL);
+		arch_remove_memory(start, size, NULL, NULL);
 	} else {
 		/* all memblocks in the range have altmaps */
 		remove_memory_blocks_and_altmaps(start, size);
--- a/mm/memremap.c~mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths
+++ a/mm/memremap.c
@@ -97,10 +97,10 @@ static void pageunmap_range(struct dev_p
 				   PHYS_PFN(range_len(range)));
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		__remove_pages(PHYS_PFN(range->start),
-			       PHYS_PFN(range_len(range)), NULL);
+			       PHYS_PFN(range_len(range)), NULL, pgmap);
 	} else {
 		arch_remove_memory(range->start, range_len(range),
-				pgmap_altmap(pgmap));
+				pgmap_altmap(pgmap), pgmap);
 		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 	}
 	mem_hotplug_done();
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths
+++ a/mm/sparse-vmemmap.c
@@ -660,7 +660,7 @@ static struct page * __meminit populate_
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -741,7 +741,7 @@ static int fill_subsection_map(unsigned
  * usage map, but still need to free the vmemmap range.
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -779,7 +779,7 @@ static void section_deactivate(unsigned
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early)
-		depopulate_section_memmap(pfn, nr_pages, altmap);
+		depopulate_section_memmap(pfn, nr_pages, altmap, pgmap);
 	else if (memmap)
 		free_map_bootmem(memmap);
 
@@ -823,7 +823,7 @@ static struct page * __meminit section_a
 
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap);
+		section_deactivate(pfn, nr_pages, altmap, pgmap);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -884,13 +884,13 @@ int __meminit sparse_add_section(int nid
 }
 
 void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 
 	if (WARN_ON_ONCE(!valid_section(ms)))
 		return;
 
-	section_deactivate(pfn, nr_pages, altmap);
+	section_deactivate(pfn, nr_pages, altmap, pgmap);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

