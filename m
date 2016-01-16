From: akpm@linux-foundation.org
Subject: [folded-merged] mm-x86-get_user_pages-for-dax-mappings-v5.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 16:33:12 -0800
Message-ID: <56998fc8.MzDeGhHuhXcaM0E3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbcAPAdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:33:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, aarcange@redhat.com, dave@sr71.net, hpa@zytor.com, logang@deltatee.com, mgorman@suse.de, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, x86: get_user_pages() for dax mappings
has been removed from the -mm tree.  Its filename was
     mm-x86-get_user_pages-for-dax-mappings-v5.patch

This patch was dropped because it was folded into mm-x86-get_user_pages-for-dax-mappings.patch

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, x86: get_user_pages() for dax mappings

Changes since v4:

1/ Fix put_page() to drop the zone_device dev_pagemap reference, otherwise
we hang at driver unload due to busy references.

2/ Fix follow_page_pte() to properly handle the dev_pagemap reference
count.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   23 +++++++++++++----------
 kernel/memremap.c  |   12 ++----------
 mm/gup.c           |   13 +++++++++++--
 mm/swap.c          |    2 --
 4 files changed, 26 insertions(+), 24 deletions(-)

diff -puN include/linux/mm.h~mm-x86-get_user_pages-for-dax-mappings-v5 include/linux/mm.h
--- a/include/linux/mm.h~mm-x86-get_user_pages-for-dax-mappings-v5
+++ a/include/linux/mm.h
@@ -484,13 +484,6 @@ static inline void init_page_count(struc
 
 void __put_page(struct page *page);
 
-static inline void put_page(struct page *page)
-{
-	page = compound_head(page);
-	if (put_page_testzero(page))
-		__put_page(page);
-}
-
 void put_pages_list(struct list_head *pages);
 
 void split_page(struct page *page, unsigned int order);
@@ -673,7 +666,7 @@ static inline enum zone_type page_zonenu
 
 #ifdef CONFIG_ZONE_DEVICE
 void get_zone_device_page(struct page *page);
-int release_zone_device_page(struct page *page);
+void put_zone_device_page(struct page *page);
 static inline bool is_zone_device_page(const struct page *page)
 {
 	return page_zonenum(page) == ZONE_DEVICE;
@@ -682,9 +675,8 @@ static inline bool is_zone_device_page(c
 static inline void get_zone_device_page(struct page *page)
 {
 }
-static inline int release_zone_device_page(struct page *page)
+static inline void put_zone_device_page(struct page *page)
 {
-	return 0;
 }
 static inline bool is_zone_device_page(const struct page *page)
 {
@@ -706,6 +698,17 @@ static inline void get_page(struct page
 		get_zone_device_page(page);
 }
 
+static inline void put_page(struct page *page)
+{
+	page = compound_head(page);
+
+	if (put_page_testzero(page))
+		__put_page(page);
+
+	if (unlikely(is_zone_device_page(page)))
+		put_zone_device_page(page);
+}
+
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
 #endif
diff -puN kernel/memremap.c~mm-x86-get_user_pages-for-dax-mappings-v5 kernel/memremap.c
--- a/kernel/memremap.c~mm-x86-get_user_pages-for-dax-mappings-v5
+++ a/kernel/memremap.c
@@ -175,19 +175,11 @@ void get_zone_device_page(struct page *p
 }
 EXPORT_SYMBOL(get_zone_device_page);
 
-int release_zone_device_page(struct page *page)
+void put_zone_device_page(struct page *page)
 {
-	/*
-	 * ZONE_DEVICE pages are never "onlined" so their reference
-	 * counts never reach zero.  They are always owned by a device
-	 * driver, not the mm core.  I.e. the page is 'idle' when the
-	 * count is 1.
-	 */
-	VM_BUG_ON_PAGE(atomic_read(&page->_count) == 1, page);
 	put_dev_pagemap(page->pgmap);
-	return atomic_dec_return(&page->_count) == 1;
 }
-EXPORT_SYMBOL(release_zone_device_page);
+EXPORT_SYMBOL(put_zone_device_page);
 
 static void pgmap_radix_release(struct resource *res)
 {
diff -puN mm/gup.c~mm-x86-get_user_pages-for-dax-mappings-v5 mm/gup.c
--- a/mm/gup.c~mm-x86-get_user_pages-for-dax-mappings-v5
+++ a/mm/gup.c
@@ -63,6 +63,7 @@ static struct page *follow_page_pte(stru
 		unsigned long address, pmd_t *pmd, unsigned int flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	struct dev_pagemap *pgmap = NULL;
 	struct page *page;
 	spinlock_t *ptl;
 	pte_t *ptep, pte;
@@ -104,7 +105,8 @@ retry:
 		 * Only return device mapping pages in the FOLL_GET case since
 		 * they are only valid while holding the pgmap reference.
 		 */
-		if (get_dev_pagemap(pte_pfn(pte), NULL))
+		pgmap = get_dev_pagemap(pte_pfn(pte), NULL);
+		if (pgmap)
 			page = pte_page(pte);
 		else
 			goto no_page;
@@ -139,8 +141,15 @@ retry:
 		goto retry;
 	}
 
-	if (flags & FOLL_GET)
+	if (flags & FOLL_GET) {
 		get_page(page);
+
+		/* drop the pgmap reference now that we hold the page */
+		if (pgmap) {
+			put_dev_pagemap(pgmap);
+			pgmap = NULL;
+		}
+	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
 		    !pte_dirty(pte) && !PageDirty(page))
diff -puN mm/swap.c~mm-x86-get_user_pages-for-dax-mappings-v5 mm/swap.c
--- a/mm/swap.c~mm-x86-get_user_pages-for-dax-mappings-v5
+++ a/mm/swap.c
@@ -95,8 +95,6 @@ void __put_page(struct page *page)
 {
 	if (unlikely(PageCompound(page)))
 		__put_compound_page(page);
-	else if (unlikely(is_zone_device_page(page)))
-		release_zone_device_page(page);
 	else
 		__put_single_page(page);
 }
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-skip-memory-block-registration-for-zone_device.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

