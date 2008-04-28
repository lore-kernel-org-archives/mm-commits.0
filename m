From: akpm@linux-foundation.org
Subject: - memory-hotplug-free-memmaps-allocated-by-bootmem.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:01 -0700
Message-ID: <200804282154.m3SLs1Rh017951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936999AbYD1Vyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, pbadari@us.ibm.com, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: free memmaps allocated by bootmem
has been removed from the -mm tree.  Its filename was
     memory-hotplug-free-memmaps-allocated-by-bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: free memmaps allocated by bootmem
From: Yasunori Goto <y-goto@jp.fujitsu.com>

This patch is to free memmaps which is allocated by bootmem.

Freeing usemap is not necessary.  The pages of usemap may be necessary for
other sections.

If removing section is last section on the node, its section is the final user
of usemap page.  (usemaps are allocated on its section by previous patch.) But
it shouldn't be freed too, because the section must be logical offline state
which all pages are isolated against page allocater.  If it is freed, page
alloctor may use it which will be removed physically soon.  It will be
disaster.  So, this patch keeps it as it is.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |    3 --
 mm/memory_hotplug.c |   11 +++++++++
 mm/page_alloc.c     |    2 -
 mm/sparse.c         |   51 ++++++++++++++++++++++++++++++++++++++----
 4 files changed, 60 insertions(+), 7 deletions(-)

diff -puN mm/internal.h~memory-hotplug-free-memmaps-allocated-by-bootmem mm/internal.h
--- a/mm/internal.h~memory-hotplug-free-memmaps-allocated-by-bootmem
+++ a/mm/internal.h
@@ -34,8 +34,7 @@ static inline void __put_page(struct pag
 	atomic_dec(&page->_count);
 }
 
-extern void __init __free_pages_bootmem(struct page *page,
-						unsigned int order);
+extern void __free_pages_bootmem(struct page *page, unsigned int order);
 
 /*
  * function for dealing with page's order in buddy system.
diff -puN mm/memory_hotplug.c~memory-hotplug-free-memmaps-allocated-by-bootmem mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-free-memmaps-allocated-by-bootmem
+++ a/mm/memory_hotplug.c
@@ -198,6 +198,16 @@ static int __add_section(struct zone *zo
 	return register_new_memory(__pfn_to_section(phys_start_pfn));
 }
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+static int __remove_section(struct zone *zone, struct mem_section *ms)
+{
+	/*
+	 * XXX: Freeing memmap with vmemmap is not implement yet.
+	 *      This should be removed later.
+	 */
+	return -EBUSY;
+}
+#else
 static int __remove_section(struct zone *zone, struct mem_section *ms)
 {
 	unsigned long flags;
@@ -216,6 +226,7 @@ static int __remove_section(struct zone 
 	pgdat_resize_unlock(pgdat, &flags);
 	return 0;
 }
+#endif
 
 /*
  * Reasonably generic function for adding memory.  It is
diff -puN mm/page_alloc.c~memory-hotplug-free-memmaps-allocated-by-bootmem mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-free-memmaps-allocated-by-bootmem
+++ a/mm/page_alloc.c
@@ -546,7 +546,7 @@ static void __free_pages_ok(struct page 
 /*
  * permit the bootmem allocator to evade page validation on high-order frees
  */
-void __init __free_pages_bootmem(struct page *page, unsigned int order)
+void __free_pages_bootmem(struct page *page, unsigned int order)
 {
 	if (order == 0) {
 		__ClearPageReserved(page);
diff -puN mm/sparse.c~memory-hotplug-free-memmaps-allocated-by-bootmem mm/sparse.c
--- a/mm/sparse.c~memory-hotplug-free-memmaps-allocated-by-bootmem
+++ a/mm/sparse.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
+#include "internal.h"
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
@@ -376,6 +377,9 @@ static void __kfree_section_memmap(struc
 {
 	return; /* XXX: Not implemented yet */
 }
+static void free_map_bootmem(struct page *page, unsigned long nr_pages)
+{
+}
 #else
 static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
 {
@@ -413,17 +417,47 @@ static void __kfree_section_memmap(struc
 		free_pages((unsigned long)memmap,
 			   get_order(sizeof(struct page) * nr_pages));
 }
+
+static void free_map_bootmem(struct page *page, unsigned long nr_pages)
+{
+	unsigned long maps_section_nr, removing_section_nr, i;
+	int magic;
+
+	for (i = 0; i < nr_pages; i++, page++) {
+		magic = atomic_read(&page->_mapcount);
+
+		BUG_ON(magic == NODE_INFO);
+
+		maps_section_nr = pfn_to_section_nr(page_to_pfn(page));
+		removing_section_nr = page->private;
+
+		/*
+		 * When this function is called, the removing section is
+		 * logical offlined state. This means all pages are isolated
+		 * from page allocator. If removing section's memmap is placed
+		 * on the same section, it must not be freed.
+		 * If it is freed, page allocator may allocate it which will
+		 * be removed physically soon.
+		 */
+		if (maps_section_nr != removing_section_nr)
+			put_page_bootmem(page);
+	}
+}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 static void free_section_usemap(struct page *memmap, unsigned long *usemap)
 {
+	struct page *usemap_page;
+	unsigned long nr_pages;
+
 	if (!usemap)
 		return;
 
+	usemap_page = virt_to_page(usemap);
 	/*
 	 * Check to see if allocation came from hot-plug-add
 	 */
-	if (PageSlab(virt_to_page(usemap))) {
+	if (PageSlab(usemap_page)) {
 		kfree(usemap);
 		if (memmap)
 			__kfree_section_memmap(memmap, PAGES_PER_SECTION);
@@ -431,10 +465,19 @@ static void free_section_usemap(struct p
 	}
 
 	/*
-	 * TODO: Allocations came from bootmem - how do I free up ?
+	 * The usemap came from bootmem. This is packed with other usemaps
+	 * on the section which has pgdat at boot time. Just keep it as is now.
 	 */
-	printk(KERN_WARNING "Not freeing up allocations from bootmem "
-			"- leaking memory\n");
+
+	if (memmap) {
+		struct page *memmap_page;
+		memmap_page = virt_to_page(memmap);
+
+		nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
+			>> PAGE_SHIFT;
+
+		free_map_bootmem(memmap_page, nr_pages);
+	}
 }
 
 /*
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch
powerpc-hotplug-memory-notifications-for-ppc.patch
powerpc-update-lmb-for-hotplug-memory-add-remove.patch
powerpc-provide-walk_memory_resource-for-ppc.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch

