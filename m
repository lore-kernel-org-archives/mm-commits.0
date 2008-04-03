From: akpm@linux-foundation.org
Subject: + memory-hotplug-free-memmaps-allocated-by-bootmem.patch added to -mm tree
Date: Thu, 03 Apr 2008 15:53:19 -0700
Message-ID: <200804032253.m33MrK6V026734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbYDCWx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 18:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, clameter@sgi.com, pbadari@us.ibm.com, yhlu.kernel@gmail.com


The patch titled
     memory hotplug: free memmaps allocated by bootmem
has been added to the -mm tree.  Its filename is
     memory-hotplug-free-memmaps-allocated-by-bootmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: free memmaps allocated by bootmem
From: Yasunori Goto <y-goto@jp.fujitsu.com>

This patch is to free memmaps which are allocated frmo bootmem.

Freeing usemap is not necessary.  The pages of usemap may be necessary for
other sections.  If a removed section is the last section on a node, its page
must be isolated from page allocator to remove it.

Then it shouldn't be freed and kept as it is.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    3 --
 mm/page_alloc.c |    2 -
 mm/sparse.c     |   50 ++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 48 insertions(+), 7 deletions(-)

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
@@ -360,6 +361,10 @@ static void __kfree_section_memmap(struc
 {
 	return; /* XXX: Not implemented yet */
 }
+static void free_map_bootmem(struct page *page, unsigned long nr_pages)
+{
+	return; /* XXX: Not implemented yet */
+}
 #else
 static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
 {
@@ -397,17 +402,45 @@ static void __kfree_section_memmap(struc
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
+		 * If removing section's memmap is placed on other section,
+		 * it must be free.
+		 * Else, nothing is necessary. the memmap is already isolated
+		 * against page allocator, and it is not used any more.
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
@@ -415,10 +448,19 @@ static void free_section_usemap(struct p
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

hotplug-memory-remove-generic-__remove_pages-support.patch
powerpc-hotplug-memory-notifications-for-ppc.patch
powerpc-update-lmb-for-hotplug-memory-add-remove.patch
powerpc-provide-walk_memory_resource-for-ppc.patch
block-fix-memory-hotplug-and-bouncing-in-block-layer.patch
mm-make-mem_map-allocation-continuous-v2.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-offset-align-in-alloc_bootmem.patch
mm-make-reserve_bootmem-can-crossed-the-nodes.patch
memory-hotplug-register-section-node-id-to-free.patch
memory-hotplug-align-memmap-to-page-size.patch
memory-hotplug-create-alloc_bootmem_section.patch
memory-hotplug-allocate-usemap-on-the-section-with-pgdat.patch
memory-hotplug-free-memmaps-allocated-by-bootmem.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch

