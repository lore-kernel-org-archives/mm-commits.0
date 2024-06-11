Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B859B1553A1
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 22:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718145010; cv=none; b=qVqnh7Fmwj1gt9nbDdipbxqvrKvAVZ7Cddcvh6DF9dXC0z/L+2gbXxxPYd43Jv72cW5n4HbqeWxAJ4eyM0nUSll+IWvWgimf1nh6zghR9Tvu7hgY0PCoUE+1hpRUEAygiRqyBKNBEIQ2xuTHchygek5cYpKgISs+F0RM5NEKzUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718145010; c=relaxed/simple;
	bh=Fps0BHL3NZWLRcn48J6Pqyiws5O8uD3r0ElynjvO86M=;
	h=Date:To:From:Subject:Message-Id; b=YCMDBunmG7tCUW93T2dKdDxzbQlAhtBbyzTxPgKJIGMmtD7BhMtVnmzBQDTqLIyVpCYeTPae/fKOLtrE6bmzUk/2uBnoFGXbuAKPfe2vfwQ/lZQsy/JXq9SiqX8hroeYXcJV4JXguhHIFhAX5TBPorr7cmM4dlu3LI3RwOhUWMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ttmlOD94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ttmlOD94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33827C2BD10;
	Tue, 11 Jun 2024 22:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718145010;
	bh=Fps0BHL3NZWLRcn48J6Pqyiws5O8uD3r0ElynjvO86M=;
	h=Date:To:From:Subject:From;
	b=ttmlOD94jjYJAyw3PvLBKlK3XT7S35zXW1K2POgj+t1GsVE04PxChKxdCBTMmKwu0
	 oPJHlTYjj1kpbeYiPH/S/LwCYqySxUaklIFisW9NfkC5e8S5zGPZPwcJmLPy9jq3I8
	 XEH+6gKpOPXjWwceK6EP67e5+H2A5cj/aMBLdqHY=
Date: Tue, 11 Jun 2024 15:30:09 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,yang.yang29@zte.com.cn,weixugc@google.com,wangkefeng.wang@huawei.com,vbabka@suse.cz,tomas.mudrunka@gmail.com,surenb@google.com,shakeelb@google.com,rppt@kernel.org,rientjes@google.com,rdunlap@infradead.org,rafael@kernel.org,pasha.tatashin@soleen.com,muchun.song@linux.dev,mike.kravetz@oracle.com,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,ivan@cloudflare.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,david@redhat.com,corbet@lwn.net,chenlinxuan@uniontech.com,bhelgaas@google.com,adobriyan@gmail.com,souravpanda@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-report-per-page-metadata-information.patch added to mm-unstable branch
Message-Id: <20240611223010.33827C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: report per-page metadata information
has been added to the -mm mm-unstable branch.  Its filename is
     mm-report-per-page-metadata-information.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-report-per-page-metadata-information.patch

This patch will later appear in the mm-unstable branch at
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
From: Sourav Panda <souravpanda@google.com>
Subject: mm: report per-page metadata information
Date: Wed, 5 Jun 2024 22:27:51 +0000

Today, we do not have any observability of per-page metadata and how much
it takes away from the machine capacity.  Thus, we want to describe the
amount of memory that is going towards per-page metadata, which can vary
depending on build configuration, machine architecture, and system use.

This patch adds 2 fields to /proc/vmstat that can used as shown below:

Accounting per-page metadata allocated by boot-allocator:
	/proc/vmstat:nr_memmap_boot * PAGE_SIZE

Accounting per-page metadata allocated by buddy-allocator:
	/proc/vmstat:nr_memmap * PAGE_SIZE

Accounting total Perpage metadata allocated on the machine:
	(/proc/vmstat:nr_memmap_boot +
	 /proc/vmstat:nr_memmap) * PAGE_SIZE

Utility for userspace:

Observability: Describe the amount of memory overhead that is going to
per-page metadata on the system at any given time since this overhead is
not currently observable.

Debugging: Tracking the changes or absolute value in struct pages can help
detect anomalies as they can be correlated with other metrics in the
machine (e.g., memtotal, number of huge pages, etc).

page_ext overheads: Some kernel features such as page_owner
page_table_check that use page_ext can be optionally enabled via kernel
parameters.  Having the total per-page metadata information helps users
precisely measure impact.  Furthermore, page-metadata metrics will reflect
the amount of struct pages reliquished (or overhead reduced) when
hugetlbfs pages are reserved which will vary depending on whether hugetlb
vmemmap optimization is enabled or not.

For background and results see:
lore.kernel.org/all/20240220214558.3377482-1-souravpanda@google.com

Link: https://lkml.kernel.org/r/20240605222751.1406125-1-souravpanda@google.com
Signed-off-by: Sourav Panda <souravpanda@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Chen Linxuan <chenlinxuan@uniontech.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tomas Mudrunka <tomas.mudrunka@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 include/linux/vmstat.h |    4 ++++
 mm/hugetlb_vmemmap.c   |   17 +++++++++++++----
 mm/mm_init.c           |    3 +++
 mm/page_alloc.c        |    1 +
 mm/page_ext.c          |   32 +++++++++++++++++++++++---------
 mm/sparse-vmemmap.c    |    8 ++++++++
 mm/sparse.c            |    7 ++++++-
 mm/vmstat.c            |   26 +++++++++++++++++++++++++-
 9 files changed, 85 insertions(+), 15 deletions(-)

--- a/include/linux/mmzone.h~mm-report-per-page-metadata-information
+++ a/include/linux/mmzone.h
@@ -220,6 +220,8 @@ enum node_stat_item {
 	PGDEMOTE_KSWAPD,
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
+	NR_MEMMAP, /* page metadata allocated through buddy allocator */
+	NR_MEMMAP_BOOT, /* page metadata allocated through boot allocator */
 	NR_VM_NODE_STAT_ITEMS
 };
 
--- a/include/linux/vmstat.h~mm-report-per-page-metadata-information
+++ a/include/linux/vmstat.h
@@ -608,4 +608,8 @@ static inline void lruvec_stat_sub_folio
 {
 	lruvec_stat_mod_folio(folio, idx, -folio_nr_pages(folio));
 }
+
+void __meminit mod_node_early_perpage_metadata(int nid, long delta);
+void __meminit store_early_perpage_metadata(void);
+
 #endif /* _LINUX_VMSTAT_H */
--- a/mm/hugetlb_vmemmap.c~mm-report-per-page-metadata-information
+++ a/mm/hugetlb_vmemmap.c
@@ -184,10 +184,13 @@ static int vmemmap_remap_range(unsigned
  */
 static inline void free_vmemmap_page(struct page *page)
 {
-	if (PageReserved(page))
+	if (PageReserved(page)) {
 		free_bootmem_page(page);
-	else
+		mod_node_page_state(page_pgdat(page), NR_MEMMAP_BOOT, -1);
+	} else {
 		__free_page(page);
+		mod_node_page_state(page_pgdat(page), NR_MEMMAP, -1);
+	}
 }
 
 /* Free a list of the vmemmap pages */
@@ -338,6 +341,7 @@ static int vmemmap_remap_free(unsigned l
 		copy_page(page_to_virt(walk.reuse_page),
 			  (void *)walk.reuse_addr);
 		list_add(&walk.reuse_page->lru, vmemmap_pages);
+		mod_node_page_state(NODE_DATA(nid), NR_MEMMAP, 1);
 	}
 
 	/*
@@ -384,14 +388,19 @@ static int alloc_vmemmap_page_list(unsig
 	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
 	int nid = page_to_nid((struct page *)start);
 	struct page *page, *next;
+	int i;
 
-	while (nr_pages--) {
+	for (i = 0; i < nr_pages; i++) {
 		page = alloc_pages_node(nid, gfp_mask, 0);
-		if (!page)
+		if (!page) {
+			mod_node_page_state(NODE_DATA(nid), NR_MEMMAP, i);
 			goto out;
+		}
 		list_add(&page->lru, list);
 	}
 
+	mod_node_page_state(NODE_DATA(nid), NR_MEMMAP, nr_pages);
+
 	return 0;
 out:
 	list_for_each_entry_safe(page, next, list, lru)
--- a/mm/mm_init.c~mm-report-per-page-metadata-information
+++ a/mm/mm_init.c
@@ -29,6 +29,7 @@
 #include <linux/cma.h>
 #include <linux/crash_dump.h>
 #include <linux/execmem.h>
+#include <linux/vmstat.h>
 #include "internal.h"
 #include "slab.h"
 #include "shuffle.h"
@@ -1624,6 +1625,8 @@ static void __init alloc_node_mem_map(st
 		panic("Failed to allocate %ld bytes for node %d memory map\n",
 		      size, pgdat->node_id);
 	pgdat->node_mem_map = map + offset;
+	mod_node_early_perpage_metadata(pgdat->node_id,
+					DIV_ROUND_UP(size, PAGE_SIZE));
 	pr_debug("%s: node %d, pgdat %08lx, node_mem_map %08lx\n",
 		 __func__, pgdat->node_id, (unsigned long)pgdat,
 		 (unsigned long)pgdat->node_mem_map);
--- a/mm/page_alloc.c~mm-report-per-page-metadata-information
+++ a/mm/page_alloc.c
@@ -5761,6 +5761,7 @@ void __init setup_per_cpu_pageset(void)
 	for_each_online_pgdat(pgdat)
 		pgdat->per_cpu_nodestats =
 			alloc_percpu(struct per_cpu_nodestat);
+	store_early_perpage_metadata();
 }
 
 __meminit void zone_pcp_init(struct zone *zone)
--- a/mm/page_ext.c~mm-report-per-page-metadata-information
+++ a/mm/page_ext.c
@@ -214,6 +214,8 @@ static int __init alloc_node_page_ext(in
 		return -ENOMEM;
 	NODE_DATA(nid)->node_page_ext = base;
 	total_usage += table_size;
+	mod_node_page_state(NODE_DATA(nid), NR_MEMMAP_BOOT,
+			    DIV_ROUND_UP(table_size, PAGE_SIZE));
 	return 0;
 }
 
@@ -268,12 +270,15 @@ static void *__meminit alloc_page_ext(si
 	void *addr = NULL;
 
 	addr = alloc_pages_exact_nid(nid, size, flags);
-	if (addr) {
+	if (addr)
 		kmemleak_alloc(addr, size, 1, flags);
-		return addr;
-	}
+	else
+		addr = vzalloc_node(size, nid);
 
-	addr = vzalloc_node(size, nid);
+	if (addr) {
+		mod_node_page_state(NODE_DATA(nid), NR_MEMMAP,
+				    DIV_ROUND_UP(size, PAGE_SIZE));
+	}
 
 	return addr;
 }
@@ -316,18 +321,27 @@ static int __meminit init_section_page_e
 
 static void free_page_ext(void *addr)
 {
+	size_t table_size;
+	struct page *page;
+	struct pglist_data *pgdat;
+
+	table_size = page_ext_size * PAGES_PER_SECTION;
+
 	if (is_vmalloc_addr(addr)) {
+		page = vmalloc_to_page(addr);
+		pgdat = page_pgdat(page);
 		vfree(addr);
 	} else {
-		struct page *page = virt_to_page(addr);
-		size_t table_size;
-
-		table_size = page_ext_size * PAGES_PER_SECTION;
-
+		page = virt_to_page(addr);
+		pgdat = page_pgdat(page);
 		BUG_ON(PageReserved(page));
 		kmemleak_free(addr);
 		free_pages_exact(addr, table_size);
 	}
+
+	mod_node_page_state(pgdat, NR_MEMMAP,
+			    -1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
+
 }
 
 static void __free_page_ext(unsigned long pfn)
--- a/mm/sparse.c~mm-report-per-page-metadata-information
+++ a/mm/sparse.c
@@ -14,7 +14,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/bootmem_info.h>
-
+#include <linux/vmstat.h>
 #include "internal.h"
 #include <asm/dma.h>
 
@@ -465,6 +465,9 @@ static void __init sparse_buffer_init(un
 	 */
 	sparsemap_buf = memmap_alloc(size, section_map_size(), addr, nid, true);
 	sparsemap_buf_end = sparsemap_buf + size;
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
+	mod_node_early_perpage_metadata(nid, DIV_ROUND_UP(size, PAGE_SIZE));
+#endif
 }
 
 static void __init sparse_buffer_fini(void)
@@ -643,6 +646,8 @@ static void depopulate_section_memmap(un
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
+	mod_node_page_state(page_pgdat(pfn_to_page(pfn)), NR_MEMMAP,
+			    -1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
 static void free_map_bootmem(struct page *memmap)
--- a/mm/sparse-vmemmap.c~mm-report-per-page-metadata-information
+++ a/mm/sparse-vmemmap.c
@@ -469,5 +469,13 @@ struct page * __meminit __populate_secti
 	if (r < 0)
 		return NULL;
 
+	if (system_state == SYSTEM_BOOTING) {
+		mod_node_early_perpage_metadata(nid, DIV_ROUND_UP(end - start,
+								  PAGE_SIZE));
+	} else {
+		mod_node_page_state(NODE_DATA(nid), NR_MEMMAP,
+				    DIV_ROUND_UP(end - start, PAGE_SIZE));
+	}
+
 	return pfn_to_page(pfn);
 }
--- a/mm/vmstat.c~mm-report-per-page-metadata-information
+++ a/mm/vmstat.c
@@ -1255,7 +1255,8 @@ const char * const vmstat_text[] = {
 	"pgdemote_kswapd",
 	"pgdemote_direct",
 	"pgdemote_khugepaged",
-
+	"nr_memmap",
+	"nr_memmap_boot",
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
@@ -2306,4 +2307,27 @@ static int __init extfrag_debug_init(voi
 }
 
 module_init(extfrag_debug_init);
+
 #endif
+
+/*
+ * Page metadata size (struct page and page_ext) in pages
+ */
+static unsigned long early_perpage_metadata[MAX_NUMNODES] __meminitdata;
+
+void __meminit mod_node_early_perpage_metadata(int nid, long delta)
+{
+	early_perpage_metadata[nid] += delta;
+}
+
+void __meminit store_early_perpage_metadata(void)
+{
+	int nid;
+	struct pglist_data *pgdat;
+
+	for_each_online_pgdat(pgdat) {
+		nid = pgdat->node_id;
+		mod_node_page_state(NODE_DATA(nid), NR_MEMMAP_BOOT,
+				    early_perpage_metadata[nid]);
+	}
+}
_

Patches currently in -mm which might be from souravpanda@google.com are

mm-report-per-page-metadata-information.patch

