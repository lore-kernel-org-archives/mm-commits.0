Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AD9A48
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 00:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723250655; cv=none; b=cbo2ztO8V7G2i6PbDQU3tbdGZbaR9tNqFX+QrnPgzpYjEkAqvY+3xD08Q5nQ1et429n1UtaO3pgD4WaA7bynrxKhF2m504Zwv/JSF2DMo4mPsOeUlsEJcbxrx1kI2V9fwkd2fyVxUsMqOrMFTvQ6Catj9vsVjtk6a7tFcF9FXko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723250655; c=relaxed/simple;
	bh=Ai8RYyHO1V3pxEmb/2dKaDa6qSotAwzxzTEaB444SAI=;
	h=Date:To:From:Subject:Message-Id; b=Tmx117Uelz3Am93jl2WuE68YmnkLrV27Rf4uFXg/m0ZECoFgSIc5e/x2//yz7OB5VqhYuAZog37LH/eT7dVQtQrS85+E/QinPGXZ4UqYWSsAJyTVzDTuVI1K/g/PuCcrgL9awdRRudUZJBIM+vgNZ3wOSt0OO861qx04x6uGv2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eU2Gt0wT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eU2Gt0wT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD64C32782;
	Sat, 10 Aug 2024 00:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723250654;
	bh=Ai8RYyHO1V3pxEmb/2dKaDa6qSotAwzxzTEaB444SAI=;
	h=Date:To:From:Subject:From;
	b=eU2Gt0wTEgpMbLcA79TKPmGRapm3TFBDnPaHSW8Kq0L5imYijhROwO9A038DEvNJe
	 2XsDvQf8JHiyQ0lmofnLUXkaZKwf610RpK2YNKqUMW6pT1Iqk7e4MF/kRN3Q1yMmX9
	 L3ZZfiJs0hWql6hhvlANBLVVCzPmTDd3bTppBi30=
Date: Fri, 09 Aug 2024 17:44:13 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,yi.zhang@redhat.com,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,rppt@kernel.org,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,lizhijian@fujitsu.com,j.granados@samsung.com,hannes@cmpxchg.org,fan.ni@samsung.com,david@redhat.com,dan.j.williams@intel.com,cerasuolodomenico@gmail.com,alison.schofield@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-account-memmap-per-node-v5.patch added to mm-hotfixes-unstable branch
Message-Id: <20240810004414.6AD64C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-dont-account-memmap-per-node-v5
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-dont-account-memmap-per-node-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-account-memmap-per-node-v5.patch

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
Subject: mm-dont-account-memmap-per-node-v5
Date: Fri, 9 Aug 2024 19:10:20 +0000

address a few nits from David Hildenbrand

Link: https://lkml.kernel.org/r/20240809191020.1142142-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Fan Ni <fan.ni@samsung.com>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yi Zhang <yi.zhang@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    8 ++++----
 mm/hugetlb_vmemmap.c   |    8 ++++----
 mm/mm_init.c           |    2 +-
 mm/page_ext.c          |    6 +++---
 mm/sparse-vmemmap.c    |    4 ++--
 mm/sparse.c            |    4 ++--
 mm/vmstat.c            |   19 ++++++++++---------
 7 files changed, 26 insertions(+), 25 deletions(-)

--- a/include/linux/vmstat.h~mm-dont-account-memmap-per-node-v5
+++ a/include/linux/vmstat.h
@@ -38,8 +38,8 @@ struct reclaim_stat {
 enum vm_stat_item {
 	NR_DIRTY_THRESHOLD,
 	NR_DIRTY_BG_THRESHOLD,
-	NR_MEMMAP,	/* page metadata allocated through buddy allocator */
-	NR_MEMMAP_BOOT,	/* page metadata allocated through boot allocator */
+	NR_MEMMAP_PAGES,	/* page metadata allocated through buddy allocator */
+	NR_MEMMAP_BOOT_PAGES,	/* page metadata allocated through boot allocator */
 	NR_VM_STAT_ITEMS,
 };
 
@@ -620,6 +620,6 @@ static inline void lruvec_stat_sub_folio
 	lruvec_stat_mod_folio(folio, idx, -folio_nr_pages(folio));
 }
 
-void mod_memmap_boot(long delta);
-void mod_memmap(long delta);
+void memmap_boot_pages_add(long delta);
+void memmap_pages_add(long delta);
 #endif /* _LINUX_VMSTAT_H */
--- a/mm/hugetlb_vmemmap.c~mm-dont-account-memmap-per-node-v5
+++ a/mm/hugetlb_vmemmap.c
@@ -185,10 +185,10 @@ static int vmemmap_remap_range(unsigned
 static inline void free_vmemmap_page(struct page *page)
 {
 	if (PageReserved(page)) {
-		mod_memmap_boot(-1);
+		memmap_boot_pages_add(-1);
 		free_bootmem_page(page);
 	} else {
-		mod_memmap(-1);
+		memmap_pages_add(-1);
 		__free_page(page);
 	}
 }
@@ -341,7 +341,7 @@ static int vmemmap_remap_free(unsigned l
 		copy_page(page_to_virt(walk.reuse_page),
 			  (void *)walk.reuse_addr);
 		list_add(&walk.reuse_page->lru, vmemmap_pages);
-		mod_memmap(1);
+		memmap_pages_add(1);
 	}
 
 	/*
@@ -396,7 +396,7 @@ static int alloc_vmemmap_page_list(unsig
 			goto out;
 		list_add(&page->lru, list);
 	}
-	mod_memmap(nr_pages);
+	memmap_pages_add(nr_pages);
 
 	return 0;
 out:
--- a/mm/mm_init.c~mm-dont-account-memmap-per-node-v5
+++ a/mm/mm_init.c
@@ -1623,7 +1623,7 @@ static void __init alloc_node_mem_map(st
 		panic("Failed to allocate %ld bytes for node %d memory map\n",
 		      size, pgdat->node_id);
 	pgdat->node_mem_map = map + offset;
-	mod_memmap_boot(DIV_ROUND_UP(size, PAGE_SIZE));
+	memmap_boot_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
 	pr_debug("%s: node %d, pgdat %08lx, node_mem_map %08lx\n",
 		 __func__, pgdat->node_id, (unsigned long)pgdat,
 		 (unsigned long)pgdat->node_mem_map);
--- a/mm/page_ext.c~mm-dont-account-memmap-per-node-v5
+++ a/mm/page_ext.c
@@ -214,7 +214,7 @@ static int __init alloc_node_page_ext(in
 		return -ENOMEM;
 	NODE_DATA(nid)->node_page_ext = base;
 	total_usage += table_size;
-	mod_memmap_boot(DIV_ROUND_UP(table_size, PAGE_SIZE));
+	memmap_boot_pages_add(DIV_ROUND_UP(table_size, PAGE_SIZE));
 	return 0;
 }
 
@@ -275,7 +275,7 @@ static void *__meminit alloc_page_ext(si
 		addr = vzalloc_node(size, nid);
 
 	if (addr)
-		mod_memmap(DIV_ROUND_UP(size, PAGE_SIZE));
+		memmap_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
 
 	return addr;
 }
@@ -322,7 +322,7 @@ static void free_page_ext(void *addr)
 	struct page *page;
 
 	table_size = page_ext_size * PAGES_PER_SECTION;
-	mod_memmap(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
+	memmap_pages_add(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
 
 	if (is_vmalloc_addr(addr)) {
 		vfree(addr);
--- a/mm/sparse.c~mm-dont-account-memmap-per-node-v5
+++ a/mm/sparse.c
@@ -463,7 +463,7 @@ static void __init sparse_buffer_init(un
 	sparsemap_buf = memmap_alloc(size, section_map_size(), addr, nid, true);
 	sparsemap_buf_end = sparsemap_buf + size;
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
-	mod_memmap_boot(DIV_ROUND_UP(size, PAGE_SIZE));
+	memmap_boot_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
 #endif
 }
 
@@ -643,7 +643,7 @@ static void depopulate_section_memmap(un
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	mod_memmap(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
+	memmap_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
 static void free_map_bootmem(struct page *memmap)
--- a/mm/sparse-vmemmap.c~mm-dont-account-memmap-per-node-v5
+++ a/mm/sparse-vmemmap.c
@@ -470,9 +470,9 @@ struct page * __meminit __populate_secti
 		return NULL;
 
 	if (system_state == SYSTEM_BOOTING)
-		mod_memmap_boot(DIV_ROUND_UP(end - start, PAGE_SIZE));
+		memmap_boot_pages_add(DIV_ROUND_UP(end - start, PAGE_SIZE));
 	else
-		mod_memmap(DIV_ROUND_UP(end - start, PAGE_SIZE));
+		memmap_pages_add(DIV_ROUND_UP(end - start, PAGE_SIZE));
 
 	return pfn_to_page(pfn);
 }
--- a/mm/vmstat.c~mm-dont-account-memmap-per-node-v5
+++ a/mm/vmstat.c
@@ -1035,19 +1035,20 @@ unsigned long node_page_state(struct pgl
 
 /*
  * Count number of pages "struct page" and "struct page_ext" consume.
- * nr_memmap_boot: # of pages allocated by boot allocator & not part of MemTotal
- * nr_memmap: # of pages that were allocated by buddy allocator
+ * nr_memmap_boot_pages: # of pages allocated by boot allocator
+ * nr_memmap_pages: # of pages that were allocated by buddy allocator
  */
-static atomic_long_t nr_memmap_boot, nr_memmap;
+static atomic_long_t nr_memmap_boot_pages = ATOMIC_LONG_INIT(0);
+static atomic_long_t nr_memmap_pages = ATOMIC_LONG_INIT(0);
 
-void mod_memmap_boot(long delta)
+void memmap_boot_pages_add(long delta)
 {
-	atomic_long_add(delta, &nr_memmap_boot);
+	atomic_long_add(delta, &nr_memmap_boot_pages);
 }
 
-void mod_memmap(long delta)
+void memmap_pages_add(long delta)
 {
-	atomic_long_add(delta, &nr_memmap);
+	atomic_long_add(delta, &nr_memmap_pages);
 }
 
 #ifdef CONFIG_COMPACTION
@@ -1844,8 +1845,8 @@ static void *vmstat_start(struct seq_fil
 
 	global_dirty_limits(v + NR_DIRTY_BG_THRESHOLD,
 			    v + NR_DIRTY_THRESHOLD);
-	v[NR_MEMMAP_BOOT] = atomic_long_read(&nr_memmap_boot);
-	v[NR_MEMMAP] = atomic_long_read(&nr_memmap);
+	v[NR_MEMMAP_PAGES] = atomic_long_read(&nr_memmap_pages);
+	v[NR_MEMMAP_BOOT_PAGES] = atomic_long_read(&nr_memmap_boot_pages);
 	v += NR_VM_STAT_ITEMS;
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-dont-account-memmap-on-failure.patch
mm-add-system-wide-stats-items-category.patch
mm-dont-account-memmap-per-node.patch
mm-dont-account-memmap-per-node-v5.patch
memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch
vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

