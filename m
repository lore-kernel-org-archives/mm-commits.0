Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3013C8827
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 21:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723153909; cv=none; b=YmX6aYiAOcoc+63/20g68bJr8n2Jj2l1iMAzcO8BIQnl19Xz/tUpeUJee0ZMAYOrG9iKtorx6C0zGtcObkrUc1Eg3h2LQr9ljzzuB/4HjE16ltAMiR0U/uYMge/ap8qx+r4ISPiOegQr/jbpX8uA1QWwn5jTCINo9cFEs29vZrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723153909; c=relaxed/simple;
	bh=oexMaeBuv8skb+pxC9RmfCy5vRqioXoMn2I2JeFIf6E=;
	h=Date:To:From:Subject:Message-Id; b=WhCNqsTDbihUlgxYRhQ/wzvXmpm+aBuWXjfK9DriD8buI/OiFTTbV0dxkTovb2CG5a+SEl5IWLeyjW0OqVgasBBmsC2pshRXWcWCiqmkOvWo/Mg/mAcxGZV2ZjripMCeJ/3DW2+kDFyIlR+KscHFZaZoTcv/dWDr7WjI/SeGFj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RhZoI/2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RhZoI/2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA757C4AF09;
	Thu,  8 Aug 2024 21:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723153908;
	bh=oexMaeBuv8skb+pxC9RmfCy5vRqioXoMn2I2JeFIf6E=;
	h=Date:To:From:Subject:From;
	b=RhZoI/2z2lycUkiP/4FE05G2Q5fShuEHBYjc30oJ5HunPAaHOlWrDNF31HjQiqWzo
	 AudA/f/0ZrTGpEnbVK96qoV/HvnlPfg14zxfW20b1obowuK4QLMsOBk9l0pOKsmLJr
	 G0P+52OtSO+SRpi6tWxT3DPuAErtN97yM6JAZkZE=
Date: Thu, 08 Aug 2024 14:51:48 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,yi.zhang@redhat.com,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,rppt@kernel.org,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,lizhijian@fujitsu.com,j.granados@samsung.com,hannes@cmpxchg.org,fan.ni@samsung.com,david@redhat.com,dan.j.williams@intel.com,cerasuolodomenico@gmail.com,alison.schofield@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-account-memmap-per-node.patch added to mm-hotfixes-unstable branch
Message-Id: <20240808215148.CA757C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: don't account memmap per-node
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

Link: https://lkml.kernel.org/r/20240808213437.682006-4-pasha.tatashin@soleen.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-cxl/CAHj4cs9Ax1=CoJkgBGP_+sNu6-6=6v=_L-ZBZY0bVLD3wUWZQg@mail.gmail.com
Reported-by: Alison Schofield <alison.schofield@intel.com>
Closes: https://lore.kernel.org/linux-mm/Zq0tPd2h6alFz8XF@aschofie-mobl2/#t
Tested-by: Dan Williams <dan.j.williams@intel.com>
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
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 -
 include/linux/vmstat.h |    7 +++---
 mm/hugetlb_vmemmap.c   |    8 +++---
 mm/mm_init.c           |    3 --
 mm/page_alloc.c        |    1 
 mm/page_ext.c          |   18 +++------------
 mm/sparse-vmemmap.c    |   11 +++------
 mm/sparse.c            |    5 +---
 mm/vmstat.c            |   45 ++++++++++++++++++---------------------
 9 files changed, 40 insertions(+), 60 deletions(-)

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
+	NR_MEMMAP,	/* page metadata allocated through buddy allocator */
+	NR_MEMMAP_BOOT,	/* page metadata allocated through boot allocator */
 	NR_VM_STAT_ITEMS,
 };
 
@@ -618,7 +620,6 @@ static inline void lruvec_stat_sub_folio
 	lruvec_stat_mod_folio(folio, idx, -folio_nr_pages(folio));
 }
 
-void __meminit mod_node_early_perpage_metadata(int nid, long delta);
-void __meminit store_early_perpage_metadata(void);
-
+void mod_memmap_boot(long delta);
+void mod_memmap(long delta);
 #endif /* _LINUX_VMSTAT_H */
--- a/mm/hugetlb_vmemmap.c~mm-dont-account-memmap-per-node
+++ a/mm/hugetlb_vmemmap.c
@@ -185,11 +185,11 @@ static int vmemmap_remap_range(unsigned
 static inline void free_vmemmap_page(struct page *page)
 {
 	if (PageReserved(page)) {
+		mod_memmap_boot(-1);
 		free_bootmem_page(page);
-		mod_node_page_state(page_pgdat(page), NR_MEMMAP_BOOT, -1);
 	} else {
+		mod_memmap(-1);
 		__free_page(page);
-		mod_node_page_state(page_pgdat(page), NR_MEMMAP, -1);
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
@@ -323,25 +320,18 @@ static void free_page_ext(void *addr)
 {
 	size_t table_size;
 	struct page *page;
-	struct pglist_data *pgdat;
 
 	table_size = page_ext_size * PAGES_PER_SECTION;
+	mod_memmap(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
 
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
@@ -1033,6 +1033,23 @@ unsigned long node_page_state(struct pgl
 }
 #endif
 
+/*
+ * Count number of pages "struct page" and "struct page_ext" consume.
+ * nr_memmap_boot: # of pages allocated by boot allocator & not part of MemTotal
+ * nr_memmap: # of pages that were allocated by buddy allocator
+ */
+static atomic_long_t nr_memmap_boot, nr_memmap;
+
+void mod_memmap_boot(long delta)
+{
+	atomic_long_add(delta, &nr_memmap_boot);
+}
+
+void mod_memmap(long delta)
+{
+	atomic_long_add(delta, &nr_memmap);
+}
+
 #ifdef CONFIG_COMPACTION
 
 struct contig_page_info {
@@ -1255,11 +1272,11 @@ const char * const vmstat_text[] = {
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
@@ -1827,6 +1844,8 @@ static void *vmstat_start(struct seq_fil
 
 	global_dirty_limits(v + NR_DIRTY_BG_THRESHOLD,
 			    v + NR_DIRTY_THRESHOLD);
+	v[NR_MEMMAP_BOOT] = atomic_long_read(&nr_memmap_boot);
+	v[NR_MEMMAP] = atomic_long_read(&nr_memmap);
 	v += NR_VM_STAT_ITEMS;
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
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

mm-dont-account-memmap-on-failure.patch
mm-add-system-wide-stats-items-category.patch
mm-dont-account-memmap-per-node.patch
memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch
vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

