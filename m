Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5900584D25
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 21:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723066912; cv=none; b=HvFvALhKzGfFn9Vt36jl4n0vCncHO8wb1NEvDziQeH1Rg1newTW2i5zXu4gAxzKnzYuk3wvfB0vP25xVlc78h7wmp/HKft8uWubd2Tp+7uhnc1Jew0FZqnqVoeH7ywcssaLBAykB2t6IlegDEkzfVV92UzEFA6S6ijT+uqANDMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723066912; c=relaxed/simple;
	bh=jTZa9+aag5aZviU7kRf0wkoIrXq7qDiG+ghs2PRQ6AE=;
	h=Date:To:From:Subject:Message-Id; b=FAoj95QejAqErBhQpLqjG5irRGievKeWxfAty5Q3VAf+agfRpFHWtDeF05C/+T6qET4AjIYOM5R65M3mqibFpCOCr3yS2pPoR/XRcRWvovJ8V9X/aMDWYMedj/6k6C8EhrMgpH880PnMPI7YQZ97ci5zUGxgY/YAdypvjRMebr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xVxI82R0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xVxI82R0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0166C32781;
	Wed,  7 Aug 2024 21:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723066912;
	bh=jTZa9+aag5aZviU7kRf0wkoIrXq7qDiG+ghs2PRQ6AE=;
	h=Date:To:From:Subject:From;
	b=xVxI82R0CHP/HlQt5Dk1bFP3yEySNWoY2SV0nyg46Jd41+OnNL4A3frBY/wCpelqT
	 GGH92qZ2YMscP0cfik6iq81Mk6kEHk/DfHicnf9Ghy7RAgnJBtK52wE5TIY6sn+Lxf
	 +2LunUh6v9i9pf9SFqCXlqMSvlqz0MNX5HLMSG7M=
Date: Wed, 07 Aug 2024 14:41:51 -0700
To: mm-commits@vger.kernel.org,yi.zhang@redhat.com,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,rppt@kernel.org,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,lizhijian@fujitsu.com,j.granados@samsung.com,hannes@cmpxchg.org,david@redhat.com,cerasuolodomenico@gmail.com,alison.schofield@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-account-memmap-per-node.patch added to mm-hotfixes-unstable branch
Message-Id: <20240807214151.F0166C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: don't account memmap per node
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-dont-account-memmap-per-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-account-memmap-per-node.patch

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
Subject: mm: don't account memmap per node
Date: Wed, 7 Aug 2024 21:19:29 +0000

Currently, when memory is hot-plugged or hot-removed the accounting is
done based on the assumption that memmap is allocated from the same node
as the hot-plugged/hot-removed memory, which is not always the case.

In addition, there are challenges with keeping the node id of the memory
that is being remove to the time when memmap accounting is actually
performed: since this is done after remove_pfn_range_from_zone(), and also
after remove_memory_block_devices().  Meaning that we cannot use pgdat nor
walking though memblocks to get the nid.

Given all of that, account the memmap overhead system wide instead.

Link: https://lkml.kernel.org/r/20240807211929.3433304-4-pasha.tatashin@soleen.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-cxl/CAHj4cs9Ax1=CoJkgBGP_+sNu6-6=6v=_L-ZBZY0bVLD3wUWZQg@mail.gmail.com
Reported-by: Alison Schofield <alison.schofield@intel.com>
Closes: https://lore.kernel.org/linux-mm/Zq0tPd2h6alFz8XF@aschofie-mobl2/#t
Cc: David Rientjes <rientjes@google.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h        |    2 -
 include/linux/vm_event_item.h |    2 +
 include/linux/vmstat.h        |    7 +++-
 mm/hugetlb_vmemmap.c          |    8 ++---
 mm/mm_init.c                  |    3 --
 mm/page_alloc.c               |    1 
 mm/page_ext.c                 |   15 +++-------
 mm/sparse-vmemmap.c           |   11 ++-----
 mm/sparse.c                   |    5 +--
 mm/vmstat.c                   |   45 ++++++++++++++------------------
 10 files changed, 44 insertions(+), 55 deletions(-)

--- a/include/linux/mmzone.h~mm-dont-account-memmap-per-node
+++ a/include/linux/mmzone.h
@@ -220,8 +220,6 @@ enum node_stat_item {
 	PGDEMOTE_KSWAPD,
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
-	NR_MEMMAP, /* page metadata allocated through buddy allocator */
-	NR_MEMMAP_BOOT, /* page metadata allocated through boot allocator */
 	NR_VM_NODE_STAT_ITEMS
 };
 
--- a/include/linux/vm_event_item.h~mm-dont-account-memmap-per-node
+++ a/include/linux/vm_event_item.h
@@ -154,6 +154,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		VMA_LOCK_RETRY,
 		VMA_LOCK_MISS,
 #endif
+		NR_MEMMAP, /* page metadata allocated through buddy allocator */
+		NR_MEMMAP_BOOT, /* page metadata allocated through boot allocator */
 		NR_VM_EVENT_ITEMS
 };
 
--- a/include/linux/vmstat.h~mm-dont-account-memmap-per-node
+++ a/include/linux/vmstat.h
@@ -625,7 +625,10 @@ static inline void lruvec_stat_sub_folio
 	lruvec_stat_mod_folio(folio, idx, -folio_nr_pages(folio));
 }
 
-void __meminit mod_node_early_perpage_metadata(int nid, long delta);
-void __meminit store_early_perpage_metadata(void);
+void mod_memmap_boot(long delta);
+static inline void mod_memmap(long delta)
+{
+	count_vm_events(NR_MEMMAP, delta);
+}
 
 #endif /* _LINUX_VMSTAT_H */
--- a/mm/hugetlb_vmemmap.c~mm-dont-account-memmap-per-node
+++ a/mm/hugetlb_vmemmap.c
@@ -185,10 +185,10 @@ static int vmemmap_remap_range(unsigned
 static inline void free_vmemmap_page(struct page *page)
 {
 	if (PageReserved(page)) {
-		mod_node_page_state(page_pgdat(page), NR_MEMMAP_BOOT, -1);
+		mod_memmap_boot(-1);
 		free_bootmem_page(page);
 	} else {
-		mod_node_page_state(page_pgdat(page), NR_MEMMAP, -1);
+		mod_memmap(-1);
 		__free_page(page);
 	}
 }
@@ -341,7 +341,7 @@ static int vmemmap_remap_free(unsigned l
 		copy_page(page_to_virt(walk.reuse_page),
 			  (void *)walk.reuse_addr);
 		list_add(&walk.reuse_page->lru, vmemmap_pages);
-		mod_node_page_state(NODE_DATA(nid), NR_MEMMAP, 1);
+		mod_memmap(1);
 	}
 
 	/*
@@ -396,7 +396,7 @@ static int alloc_vmemmap_page_list(unsig
 			goto out;
 		list_add(&page->lru, list);
 	}
-	mod_node_page_state(NODE_DATA(nid), NR_MEMMAP, nr_pages);
+	mod_memmap(nr_pages);
 
 	return 0;
 out:
--- a/mm/mm_init.c~mm-dont-account-memmap-per-node
+++ a/mm/mm_init.c
@@ -1623,8 +1623,7 @@ static void __init alloc_node_mem_map(st
 		panic("Failed to allocate %ld bytes for node %d memory map\n",
 		      size, pgdat->node_id);
 	pgdat->node_mem_map = map + offset;
-	mod_node_early_perpage_metadata(pgdat->node_id,
-					DIV_ROUND_UP(size, PAGE_SIZE));
+	mod_memmap_boot(DIV_ROUND_UP(size, PAGE_SIZE));
 	pr_debug("%s: node %d, pgdat %08lx, node_mem_map %08lx\n",
 		 __func__, pgdat->node_id, (unsigned long)pgdat,
 		 (unsigned long)pgdat->node_mem_map);
--- a/mm/page_alloc.c~mm-dont-account-memmap-per-node
+++ a/mm/page_alloc.c
@@ -5755,7 +5755,6 @@ void __init setup_per_cpu_pageset(void)
 	for_each_online_pgdat(pgdat)
 		pgdat->per_cpu_nodestats =
 			alloc_percpu(struct per_cpu_nodestat);
-	store_early_perpage_metadata();
 }
 
 __meminit void zone_pcp_init(struct zone *zone)
--- a/mm/page_ext.c~mm-dont-account-memmap-per-node
+++ a/mm/page_ext.c
@@ -214,8 +214,7 @@ static int __init alloc_node_page_ext(in
 		return -ENOMEM;
 	NODE_DATA(nid)->node_page_ext = base;
 	total_usage += table_size;
-	mod_node_page_state(NODE_DATA(nid), NR_MEMMAP_BOOT,
-			    DIV_ROUND_UP(table_size, PAGE_SIZE));
+	mod_memmap_boot(DIV_ROUND_UP(table_size, PAGE_SIZE));
 	return 0;
 }
 
@@ -275,10 +274,8 @@ static void *__meminit alloc_page_ext(si
 	else
 		addr = vzalloc_node(size, nid);
 
-	if (addr) {
-		mod_node_page_state(NODE_DATA(nid), NR_MEMMAP,
-				    DIV_ROUND_UP(size, PAGE_SIZE));
-	}
+	if (addr)
+		mod_memmap(DIV_ROUND_UP(size, PAGE_SIZE));
 
 	return addr;
 }
@@ -330,14 +327,12 @@ static void free_page_ext(void *addr)
 	if (is_vmalloc_addr(addr)) {
 		page = vmalloc_to_page(addr);
 		pgdat = page_pgdat(page);
-		mod_node_page_state(pgdat, NR_MEMMAP,
-				    -1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
+		mod_memmap(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
 		vfree(addr);
 	} else {
 		page = virt_to_page(addr);
 		pgdat = page_pgdat(page);
-		mod_node_page_state(pgdat, NR_MEMMAP,
-				    -1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
+		mod_memmap(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
 		BUG_ON(PageReserved(page));
 		kmemleak_free(addr);
 		free_pages_exact(addr, table_size);
--- a/mm/sparse.c~mm-dont-account-memmap-per-node
+++ a/mm/sparse.c
@@ -463,7 +463,7 @@ static void __init sparse_buffer_init(un
 	sparsemap_buf = memmap_alloc(size, section_map_size(), addr, nid, true);
 	sparsemap_buf_end = sparsemap_buf + size;
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
-	mod_node_early_perpage_metadata(nid, DIV_ROUND_UP(size, PAGE_SIZE));
+	mod_memmap_boot(DIV_ROUND_UP(size, PAGE_SIZE));
 #endif
 }
 
@@ -643,8 +643,7 @@ static void depopulate_section_memmap(un
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	mod_node_page_state(page_pgdat(pfn_to_page(pfn)), NR_MEMMAP,
-			    -1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
+	mod_memmap(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
 static void free_map_bootmem(struct page *memmap)
--- a/mm/sparse-vmemmap.c~mm-dont-account-memmap-per-node
+++ a/mm/sparse-vmemmap.c
@@ -469,13 +469,10 @@ struct page * __meminit __populate_secti
 	if (r < 0)
 		return NULL;
 
-	if (system_state == SYSTEM_BOOTING) {
-		mod_node_early_perpage_metadata(nid, DIV_ROUND_UP(end - start,
-								  PAGE_SIZE));
-	} else {
-		mod_node_page_state(NODE_DATA(nid), NR_MEMMAP,
-				    DIV_ROUND_UP(end - start, PAGE_SIZE));
-	}
+	if (system_state == SYSTEM_BOOTING)
+		mod_memmap_boot(DIV_ROUND_UP(end - start, PAGE_SIZE));
+	else
+		mod_memmap(DIV_ROUND_UP(end - start, PAGE_SIZE));
 
 	return pfn_to_page(pfn);
 }
--- a/mm/vmstat.c~mm-dont-account-memmap-per-node
+++ a/mm/vmstat.c
@@ -1255,8 +1255,6 @@ const char * const vmstat_text[] = {
 	"pgdemote_kswapd",
 	"pgdemote_direct",
 	"pgdemote_khugepaged",
-	"nr_memmap",
-	"nr_memmap_boot",
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
@@ -1417,6 +1415,8 @@ const char * const vmstat_text[] = {
 	"vma_lock_retry",
 	"vma_lock_miss",
 #endif
+	"nr_memmap",
+	"nr_memmap_boot",
 #endif /* CONFIG_VM_EVENT_COUNTERS || CONFIG_MEMCG */
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA || CONFIG_MEMCG */
@@ -2117,6 +2117,24 @@ static int vmstat_cpu_dead(unsigned int
 
 #endif
 
+/* nr_memmap_boot that is used prior to setup_per_cpu_areas() call */
+static atomic_long_t early_memmap_boot;
+static bool early_memmap_boot_finished;
+
+void mod_memmap_boot(long delta)
+{
+	if (early_memmap_boot_finished)
+		count_vm_events(NR_MEMMAP_BOOT, delta);
+	else
+		atomic_long_add(delta, &early_memmap_boot);
+}
+
+static void __init finish_early_memmap_boot(void)
+{
+	early_memmap_boot_finished = true;
+	mod_memmap_boot(atomic_long_read(&early_memmap_boot));
+}
+
 struct workqueue_struct *mm_percpu_wq;
 
 void __init init_mm_internals(void)
@@ -2149,6 +2167,7 @@ void __init init_mm_internals(void)
 	proc_create_seq("vmstat", 0444, NULL, &vmstat_op);
 	proc_create_seq("zoneinfo", 0444, NULL, &zoneinfo_op);
 #endif
+	finish_early_memmap_boot();
 }
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_COMPACTION)
@@ -2285,25 +2304,3 @@ static int __init extfrag_debug_init(voi
 module_init(extfrag_debug_init);
 
 #endif
-
-/*
- * Page metadata size (struct page and page_ext) in pages
- */
-static unsigned long early_perpage_metadata[MAX_NUMNODES] __meminitdata;
-
-void __meminit mod_node_early_perpage_metadata(int nid, long delta)
-{
-	early_perpage_metadata[nid] += delta;
-}
-
-void __meminit store_early_perpage_metadata(void)
-{
-	int nid;
-	struct pglist_data *pgdat;
-
-	for_each_online_pgdat(pgdat) {
-		nid = pgdat->node_id;
-		mod_node_page_state(NODE_DATA(nid), NR_MEMMAP_BOOT,
-				    early_perpage_metadata[nid]);
-	}
-}
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-update-the-memmap-stat-before-page-is-freed.patch
mm-dont-account-memmap-on-failure.patch
mm-dont-account-memmap-per-node.patch
memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch
vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

