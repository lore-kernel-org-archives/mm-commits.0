From: akpm@linux-foundation.org
Subject: + memory-hotplug-hot-add-with-sparsemem-vmemmap.patch added to -mm tree
Date: Fri, 17 Aug 2007 13:59:28 -0700
Message-ID: <200708172059.l7HKxSWS029133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755618AbXHQVAV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 17:00:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, apw@shadowen.org, clameter@sgi.com, mel@csn.ul.ie


The patch titled
     memory hotplug: Hot-add with sparsemem-vmemmap
has been added to the -mm tree.  Its filename is
     memory-hotplug-hot-add-with-sparsemem-vmemmap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory hotplug: Hot-add with sparsemem-vmemmap
From: Yasunori Goto <y-goto@jp.fujitsu.com>

This patch is to avoid panic when memory hot-add is executed with
sparsemem-vmemmap.  Current vmemmap-sparsemem code doesn't support memory
hot-add.  Vmemmap must be populated when hot-add.  This is for
2.6.23-rc2-mm2.

Todo: # Even if this patch is applied, the message "[xxxx-xxxx] potential
        offnode page_structs" is displayed. To allocate memmap on its node,
        memmap (and pgdat) must be initialized itself like chicken and
        egg relationship.

      # vmemmap_unpopulate will be necessary for followings.
         - For cancel hot-add due to error.
         - For unplug.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    2 +-
 mm/sparse-vmemmap.c |    2 +-
 mm/sparse.c         |   24 +++++++++++++++++++++---
 3 files changed, 23 insertions(+), 5 deletions(-)

diff -puN include/linux/mm.h~memory-hotplug-hot-add-with-sparsemem-vmemmap include/linux/mm.h
--- a/include/linux/mm.h~memory-hotplug-hot-add-with-sparsemem-vmemmap
+++ a/include/linux/mm.h
@@ -1159,7 +1159,7 @@ extern int randomize_va_space;
 
 const char * arch_vma_name(struct vm_area_struct *vma);
 
-struct page *sparse_early_mem_map_populate(unsigned long pnum, int nid);
+struct page *sparse_mem_map_populate(unsigned long pnum, int nid);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(pgd_t *pgd, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
diff -puN mm/sparse-vmemmap.c~memory-hotplug-hot-add-with-sparsemem-vmemmap mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~memory-hotplug-hot-add-with-sparsemem-vmemmap
+++ a/mm/sparse-vmemmap.c
@@ -137,7 +137,7 @@ int __meminit vmemmap_populate_basepages
 	return 0;
 }
 
-struct page __init *sparse_early_mem_map_populate(unsigned long pnum, int nid)
+struct page *sparse_mem_map_populate(unsigned long pnum, int nid)
 {
 	struct page *map = pfn_to_page(pnum * PAGES_PER_SECTION);
 	int error = vmemmap_populate(map, PAGES_PER_SECTION, nid);
diff -puN mm/sparse.c~memory-hotplug-hot-add-with-sparsemem-vmemmap mm/sparse.c
--- a/mm/sparse.c~memory-hotplug-hot-add-with-sparsemem-vmemmap
+++ a/mm/sparse.c
@@ -259,7 +259,7 @@ static unsigned long *sparse_early_usema
 }
 
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
-struct page __init *sparse_early_mem_map_populate(unsigned long pnum, int nid)
+struct page __init *sparse_mem_map_populate(unsigned long pnum, int nid)
 {
 	struct page *map;
 
@@ -284,7 +284,7 @@ struct page __init *sparse_early_mem_map
 	struct mem_section *ms = __nr_to_section(pnum);
 	int nid = sparse_early_nid(ms);
 
-	map = sparse_early_mem_map_populate(pnum, nid);
+	map = sparse_mem_map_populate(pnum, nid);
 	if (map)
 		return map;
 
@@ -322,6 +322,17 @@ void __init sparse_init(void)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+static inline struct page *kmalloc_section_memmap(unsigned long pnum, int nid,
+						 unsigned long nr_pages)
+{
+	return sparse_mem_map_populate(pnum, nid);
+}
+static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
+{
+	return; /* XXX: Not implemented yet */
+}
+#else
 static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
 {
 	struct page *page, *ret;
@@ -344,6 +355,12 @@ got_map_ptr:
 	return ret;
 }
 
+static inline struct page *kmalloc_section_memmap(unsigned long pnum, int nid,
+						  unsigned long nr_pages)
+{
+	return __kmalloc_section_memmap(nr_pages);
+}
+
 static int vaddr_in_vmalloc_area(void *addr)
 {
 	if (addr >= (void *)VMALLOC_START &&
@@ -360,6 +377,7 @@ static void __kfree_section_memmap(struc
 		free_pages((unsigned long)memmap,
 			   get_order(sizeof(struct page) * nr_pages));
 }
+#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 /*
  * returns the number of sections whose mem_maps were properly
@@ -382,7 +400,7 @@ int sparse_add_one_section(struct zone *
 	 * plus, it does a kmalloc
 	 */
 	sparse_index_init(section_nr, pgdat->node_id);
-	memmap = __kmalloc_section_memmap(nr_pages);
+	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id, nr_pages);
 	usemap = __kmalloc_section_usemap();
 
 	pgdat_resize_lock(pgdat, &flags);
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
move-free-pages-between-lists-on-steal.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
