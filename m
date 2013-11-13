From: akpm@linux-foundation.org
Subject: [merged]
 mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:34 -0800
Message-ID: <5283e34a.zRLTt6D/Wtl64qsB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3KMUif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, y-goto@jp.fujitsu.com, wency@cn.fujitsu.com, toshi.kani@hp.com, tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, apw@shadowen.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,apw@shadowen.org,isimatu.yasuaki@jp.fujitsu.com,tangchen@cn.fujitsu.com,toshi.kani@hp.com,wency@cn.fujitsu.com,y-goto@jp.fujitsu.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:34 -0800


The patch titled
     Subject: mm/sparsemem: use PAGES_PER_SECTION to remove redundant nr_pages parameter
has been removed from the -mm tree.  Its filename was
     mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/sparsemem: use PAGES_PER_SECTION to remove redundant nr_pages parameter

For below functions,

- sparse_add_one_section()
- kmalloc_section_memmap()
- __kmalloc_section_memmap()
- __kfree_section_memmap()

they are always invoked to operate on one memory section, so it is
redundant to always pass a nr_pages parameter, which is the page numbers
in one section.  So we can directly use predefined macro PAGES_PER_SECTION
instead of passing the parameter.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    3 --
 mm/memory_hotplug.c            |    3 --
 mm/sparse.c                    |   33 ++++++++++++++-----------------
 3 files changed, 17 insertions(+), 22 deletions(-)

diff -puN include/linux/memory_hotplug.h~mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter
+++ a/include/linux/memory_hotplug.h
@@ -268,8 +268,7 @@ extern int arch_add_memory(int nid, u64
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern void remove_memory(int nid, u64 start, u64 size);
-extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
-								int nr_pages);
+extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn);
 extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
diff -puN mm/memory_hotplug.c~mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter
+++ a/mm/memory_hotplug.c
@@ -401,13 +401,12 @@ static int __meminit __add_zone(struct z
 static int __meminit __add_section(int nid, struct zone *zone,
 					unsigned long phys_start_pfn)
 {
-	int nr_pages = PAGES_PER_SECTION;
 	int ret;
 
 	if (pfn_valid(phys_start_pfn))
 		return -EEXIST;
 
-	ret = sparse_add_one_section(zone, phys_start_pfn, nr_pages);
+	ret = sparse_add_one_section(zone, phys_start_pfn);
 
 	if (ret < 0)
 		return ret;
diff -puN mm/sparse.c~mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter mm/sparse.c
--- a/mm/sparse.c~mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter
+++ a/mm/sparse.c
@@ -590,16 +590,15 @@ void __init sparse_init(void)
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-static inline struct page *kmalloc_section_memmap(unsigned long pnum, int nid,
-						 unsigned long nr_pages)
+static inline struct page *kmalloc_section_memmap(unsigned long pnum, int nid)
 {
 	/* This will make the necessary allocations eventually. */
 	return sparse_mem_map_populate(pnum, nid);
 }
-static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
+static void __kfree_section_memmap(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
-	unsigned long end = (unsigned long)(memmap + nr_pages);
+	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
 	vmemmap_free(start, end);
 }
@@ -613,10 +612,10 @@ static void free_map_bootmem(struct page
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 #else
-static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
+static struct page *__kmalloc_section_memmap(void)
 {
 	struct page *page, *ret;
-	unsigned long memmap_size = sizeof(struct page) * nr_pages;
+	unsigned long memmap_size = sizeof(struct page) * PAGES_PER_SECTION;
 
 	page = alloc_pages(GFP_KERNEL|__GFP_NOWARN, get_order(memmap_size));
 	if (page)
@@ -634,19 +633,18 @@ got_map_ptr:
 	return ret;
 }
 
-static inline struct page *kmalloc_section_memmap(unsigned long pnum, int nid,
-						  unsigned long nr_pages)
+static inline struct page *kmalloc_section_memmap(unsigned long pnum, int nid)
 {
-	return __kmalloc_section_memmap(nr_pages);
+	return __kmalloc_section_memmap();
 }
 
-static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
+static void __kfree_section_memmap(struct page *memmap)
 {
 	if (is_vmalloc_addr(memmap))
 		vfree(memmap);
 	else
 		free_pages((unsigned long)memmap,
-			   get_order(sizeof(struct page) * nr_pages));
+			   get_order(sizeof(struct page) * PAGES_PER_SECTION));
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
@@ -684,8 +682,7 @@ static void free_map_bootmem(struct page
  * set.  If this is <=0, then that means that the passed-in
  * map was not consumed and must be freed.
  */
-int __meminit sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
-			   int nr_pages)
+int __meminit sparse_add_one_section(struct zone *zone, unsigned long start_pfn)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
 	struct pglist_data *pgdat = zone->zone_pgdat;
@@ -702,12 +699,12 @@ int __meminit sparse_add_one_section(str
 	ret = sparse_index_init(section_nr, pgdat->node_id);
 	if (ret < 0 && ret != -EEXIST)
 		return ret;
-	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id, nr_pages);
+	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id);
 	if (!memmap)
 		return -ENOMEM;
 	usemap = __kmalloc_section_usemap();
 	if (!usemap) {
-		__kfree_section_memmap(memmap, nr_pages);
+		__kfree_section_memmap(memmap);
 		return -ENOMEM;
 	}
 
@@ -719,7 +716,7 @@ int __meminit sparse_add_one_section(str
 		goto out;
 	}
 
-	memset(memmap, 0, sizeof(struct page) * nr_pages);
+	memset(memmap, 0, sizeof(struct page) * PAGES_PER_SECTION);
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 
@@ -729,7 +726,7 @@ out:
 	pgdat_resize_unlock(pgdat, &flags);
 	if (ret <= 0) {
 		kfree(usemap);
-		__kfree_section_memmap(memmap, nr_pages);
+		__kfree_section_memmap(memmap);
 	}
 	return ret;
 }
@@ -771,7 +768,7 @@ static void free_section_usemap(struct p
 	if (PageSlab(usemap_page) || PageCompound(usemap_page)) {
 		kfree(usemap);
 		if (memmap)
-			__kfree_section_memmap(memmap, PAGES_PER_SECTION);
+			__kfree_section_memmap(memmap);
 		return;
 	}
 
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
linux-next.patch

