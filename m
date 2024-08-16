Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC2578C7A
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 05:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785415; cv=none; b=QwYCVBVv092wVmvD67K/m31A50epeSeX8azCQ7MiQIh7MtIhQXR7Nrqt0V9lrZGc3/a4X8V5Z3xYBdbF9kD28D2kUCUwvdAMG2rWHhGyymJp7yR1h8lQEXwfgEWZiQmZVH5BkgD08/61qZolzqfLmyiwqU7HQAAxfX03ykTPznw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785415; c=relaxed/simple;
	bh=iWC8PQ6Qa97zpNXqaZPhAPeYvF4bfQ+xTK3nAo16nj8=;
	h=Date:To:From:Subject:Message-Id; b=WIZ9ixfav8j5l4tTs/8OaFHGiC+Dtxz/eOp4YlQ3TxlPsrrDfXcuuTcU+SjSiMctMpY4QbigV57wnrB7KonZlao3tO/Bnpsnm4lkuDvTlh2X/EOd+NWec92F5zrfBlLgY610tUEQ370RdkqT+PDL7jLN3xJqMxm0C3mE2ajP7fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gk04bsaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gk04bsaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC05C32782;
	Fri, 16 Aug 2024 05:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785414;
	bh=iWC8PQ6Qa97zpNXqaZPhAPeYvF4bfQ+xTK3nAo16nj8=;
	h=Date:To:From:Subject:From;
	b=gk04bsaNbTDGlw/ZwmizpvBaK6kB538ex6rswpkVHgXnlAvRhA96o6hA/MLHHsZOM
	 hDYEdschpctxwTDbKeRaaRAoNlfe29W1gqwYuOadhNxFArnDMTdVBVdQRZ2jrXx8VJ
	 8a8aeeONU8Y129yI8up8FXeYCusTCdb46RBRY/d8=
Date: Thu, 15 Aug 2024 22:16:53 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,yi.zhang@redhat.com,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,rppt@kernel.org,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,lizhijian@fujitsu.com,j.granados@samsung.com,hannes@cmpxchg.org,fan.ni@samsung.com,david@redhat.com,dan.j.williams@intel.com,cerasuolodomenico@gmail.com,alison.schofield@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-dont-account-memmap-per-node.patch removed from -mm tree
Message-Id: <20240816051653.ECC05C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: don't account memmap per-node
has been removed from the -mm tree.  Its filename was
     mm-dont-account-memmap-per-node.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm: don't account memmap per-node
Date: Thu, 8 Aug 2024 21:34:36 +0000

Fix invalid access to pgdat during hot-remove operation:
ndctl users reported a GPF when trying to destroy a namespace:
$ ndctl destroy-namespace all -r all -f
 Segmentation fault
 dmesg:
 Oops: general protection fault, probably for
 non-canonical address 0xdffffc0000005650: 0000 [#1] PREEMPT SMP KASAN
 PTI
 KASAN: probably user-memory-access in range
 [0x000000000002b280-0x000000000002b287]
 CPU: 26 UID: 0 PID: 1868 Comm: ndctl Not tainted 6.11.0-rc1 #1
 Hardware name: Dell Inc. PowerEdge R640/08HT8T, BIOS
 2.20.1 09/13/2023
 RIP: 0010:mod_node_page_state+0x2a/0x110

cxl-test users report a GPF when trying to unload the test module:
$ modrpobe -r cxl-test
 dmesg
 BUG: unable to handle page fault for address: 0000000000004200
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: Oops: 0000 [#1] PREEMPT SMP PTI
 CPU: 0 UID: 0 PID: 1076 Comm: modprobe Tainted: G O N 6.11.0-rc1 #197
 Tainted: [O]=OOT_MODULE, [N]=TEST
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/15
 RIP: 0010:mod_node_page_state+0x6/0x90

Currently, when memory is hot-plugged or hot-removed the accounting is
done based on the assumption that memmap is allocated from the same node
as the hot-plugged/hot-removed memory, which is not always the case.

In addition, there are challenges with keeping the node id of the memory
that is being remove to the time when memmap accounting is actually
performed: since this is done after remove_pfn_range_from_zone(), and
also after remove_memory_block_devices(). Meaning that we cannot use
pgdat nor walking though memblocks to get the nid.

Given all of that, account the memmap overhead system wide instead.

For this we are going to be using global atomic counters, but given that
memmap size is rarely modified, and normally is only modified either
during early boot when there is only one CPU, or under a hotplug global
mutex lock, therefore there is no need for per-cpu optimizations.

Also, while we are here rename nr_memmap to nr_memmap_pages, and
nr_memmap_boot to nr_memmap_boot_pages to be self explanatory that the
units are in page count.

[pasha.tatashin@soleen.com: address a few nits from David Hildenbrand]
  Link: https://lkml.kernel.org/r/20240809191020.1142142-4-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20240809191020.1142142-4-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20240808213437.682006-4-pasha.tatashin@soleen.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-cxl/CAHj4cs9Ax1=CoJkgBGP_+sNu6-6=6v=_L-ZBZY0bVLD3wUWZQg@mail.gmail.com
Reported-by: Alison Schofield <alison.schofield@intel.com>
Closes: https://lore.kernel.org/linux-mm/Zq0tPd2h6alFz8XF@aschofie-mobl2/#t
Tested-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
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
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 -
 include/linux/vmstat.h |    7 +++--
 mm/hugetlb_vmemmap.c   |    8 +++---
 mm/mm_init.c           |    3 --
 mm/page_alloc.c        |    1 
 mm/page_ext.c          |   18 +++------------
 mm/sparse-vmemmap.c    |   11 +++------
 mm/sparse.c            |    5 +---
 mm/vmstat.c            |   46 ++++++++++++++++++---------------------
 9 files changed, 41 insertions(+), 60 deletions(-)

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
 
--- a/include/linux/vmstat.h~mm-dont-account-memmap-per-node
+++ a/include/linux/vmstat.h
@@ -38,6 +38,8 @@ struct reclaim_stat {
 enum vm_stat_item {
 	NR_DIRTY_THRESHOLD,
 	NR_DIRTY_BG_THRESHOLD,
+	NR_MEMMAP_PAGES,	/* page metadata allocated through buddy allocator */
+	NR_MEMMAP_BOOT_PAGES,	/* page metadata allocated through boot allocator */
 	NR_VM_STAT_ITEMS,
 };
 
@@ -618,7 +620,6 @@ static inline void lruvec_stat_sub_folio
 	lruvec_stat_mod_folio(folio, idx, -folio_nr_pages(folio));
 }
 
-void __meminit mod_node_early_perpage_metadata(int nid, long delta);
-void __meminit store_early_perpage_metadata(void);
-
+void memmap_boot_pages_add(long delta);
+void memmap_pages_add(long delta);
 #endif /* _LINUX_VMSTAT_H */
--- a/mm/hugetlb_vmemmap.c~mm-dont-account-memmap-per-node
+++ a/mm/hugetlb_vmemmap.c
@@ -185,11 +185,11 @@ static int vmemmap_remap_range(unsigned
 static inline void free_vmemmap_page(struct page *page)
 {
 	if (PageReserved(page)) {
+		memmap_boot_pages_add(-1);
 		free_bootmem_page(page);
-		mod_node_page_state(page_pgdat(page), NR_MEMMAP_BOOT, -1);
 	} else {
+		memmap_pages_add(-1);
 		__free_page(page);
-		mod_node_page_state(page_pgdat(page), NR_MEMMAP, -1);
 	}
 }
 
@@ -341,7 +341,7 @@ static int vmemmap_remap_free(unsigned l
 		copy_page(page_to_virt(walk.reuse_page),
 			  (void *)walk.reuse_addr);
 		list_add(&walk.reuse_page->lru, vmemmap_pages);
-		mod_node_page_state(NODE_DATA(nid), NR_MEMMAP, 1);
+		memmap_pages_add(1);
 	}
 
 	/*
@@ -396,7 +396,7 @@ static int alloc_vmemmap_page_list(unsig
 			goto out;
 		list_add(&page->lru, list);
 	}
-	mod_node_page_state(NODE_DATA(nid), NR_MEMMAP, nr_pages);
+	memmap_pages_add(nr_pages);
 
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
+	memmap_boot_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
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
+	memmap_boot_pages_add(DIV_ROUND_UP(table_size, PAGE_SIZE));
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
+		memmap_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
 
 	return addr;
 }
@@ -323,25 +320,18 @@ static void free_page_ext(void *addr)
 {
 	size_t table_size;
 	struct page *page;
-	struct pglist_data *pgdat;
 
 	table_size = page_ext_size * PAGES_PER_SECTION;
+	memmap_pages_add(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
 
 	if (is_vmalloc_addr(addr)) {
-		page = vmalloc_to_page(addr);
-		pgdat = page_pgdat(page);
 		vfree(addr);
 	} else {
 		page = virt_to_page(addr);
-		pgdat = page_pgdat(page);
 		BUG_ON(PageReserved(page));
 		kmemleak_free(addr);
 		free_pages_exact(addr, table_size);
 	}
-
-	mod_node_page_state(pgdat, NR_MEMMAP,
-			    -1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
-
 }
 
 static void __free_page_ext(unsigned long pfn)
--- a/mm/sparse.c~mm-dont-account-memmap-per-node
+++ a/mm/sparse.c
@@ -463,7 +463,7 @@ static void __init sparse_buffer_init(un
 	sparsemap_buf = memmap_alloc(size, section_map_size(), addr, nid, true);
 	sparsemap_buf_end = sparsemap_buf + size;
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
-	mod_node_early_perpage_metadata(nid, DIV_ROUND_UP(size, PAGE_SIZE));
+	memmap_boot_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
 #endif
 }
 
@@ -643,8 +643,7 @@ static void depopulate_section_memmap(un
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	mod_node_page_state(page_pgdat(pfn_to_page(pfn)), NR_MEMMAP,
-			    -1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
+	memmap_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
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
+		memmap_boot_pages_add(DIV_ROUND_UP(end - start, PAGE_SIZE));
+	else
+		memmap_pages_add(DIV_ROUND_UP(end - start, PAGE_SIZE));
 
 	return pfn_to_page(pfn);
 }
--- a/mm/vmstat.c~mm-dont-account-memmap-per-node
+++ a/mm/vmstat.c
@@ -1033,6 +1033,24 @@ unsigned long node_page_state(struct pgl
 }
 #endif
 
+/*
+ * Count number of pages "struct page" and "struct page_ext" consume.
+ * nr_memmap_boot_pages: # of pages allocated by boot allocator
+ * nr_memmap_pages: # of pages that were allocated by buddy allocator
+ */
+static atomic_long_t nr_memmap_boot_pages = ATOMIC_LONG_INIT(0);
+static atomic_long_t nr_memmap_pages = ATOMIC_LONG_INIT(0);
+
+void memmap_boot_pages_add(long delta)
+{
+	atomic_long_add(delta, &nr_memmap_boot_pages);
+}
+
+void memmap_pages_add(long delta)
+{
+	atomic_long_add(delta, &nr_memmap_pages);
+}
+
 #ifdef CONFIG_COMPACTION
 
 struct contig_page_info {
@@ -1255,11 +1273,11 @@ const char * const vmstat_text[] = {
 	"pgdemote_kswapd",
 	"pgdemote_direct",
 	"pgdemote_khugepaged",
-	"nr_memmap",
-	"nr_memmap_boot",
 	/* system-wide enum vm_stat_item counters */
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
+	"nr_memmap_pages",
+	"nr_memmap_boot_pages",
 
 #if defined(CONFIG_VM_EVENT_COUNTERS) || defined(CONFIG_MEMCG)
 	/* enum vm_event_item counters */
@@ -1827,6 +1845,8 @@ static void *vmstat_start(struct seq_fil
 
 	global_dirty_limits(v + NR_DIRTY_BG_THRESHOLD,
 			    v + NR_DIRTY_THRESHOLD);
+	v[NR_MEMMAP_PAGES] = atomic_long_read(&nr_memmap_pages);
+	v[NR_MEMMAP_BOOT_PAGES] = atomic_long_read(&nr_memmap_boot_pages);
 	v += NR_VM_STAT_ITEMS;
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
@@ -2285,25 +2305,3 @@ static int __init extfrag_debug_init(voi
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

memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch
vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

