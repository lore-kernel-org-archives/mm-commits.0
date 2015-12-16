From: akpm@linux-foundation.org
Subject: + mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
 added to -mm tree
Date: Tue, 15 Dec 2015 16:17:16 -0800
Message-ID: <5670ad8c.3wQnDhSb4OduzgBZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbbLPARR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:17:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@linux.intel.com, logang@deltatee.com, ross.zwisler@linux.intel.com, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax, pmem: introduce {get|put}_dev_pagemap() for dax-gup
has been added to the -mm tree.  Its filename is
     mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, dax, pmem: introduce {get|put}_dev_pagemap() for dax-gup

get_dev_page() enables paths like get_user_pages() to pin a dynamically
mapped pfn-range (devm_memremap_pages()) while the resulting struct page
objects are in use.  Unlike get_page() it may fail if the device is, or is
in the process of being, disabled.  While the initial lookup of the range
may be an expensive list walk, the result is cached to speed up subsequent
lookups which are likely to be in the same mapped range.

devm_memremap_pages() now requires a reference counter to be specified at
init time.  For pmem this means moving request_queue allocation into
pmem_alloc() so the existing queue usage counter can track "device pages".

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/pmem.c    |    6 ++--
 include/linux/mm.h       |   49 ++++++++++++++++++++++++++++++++--
 include/linux/mm_types.h |    5 +++
 kernel/memremap.c        |   53 ++++++++++++++++++++++++++++++++++---
 4 files changed, 105 insertions(+), 8 deletions(-)

diff -puN drivers/nvdimm/pmem.c~mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup drivers/nvdimm/pmem.c
--- a/drivers/nvdimm/pmem.c~mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup
+++ a/drivers/nvdimm/pmem.c
@@ -149,7 +149,7 @@ static struct pmem_device *pmem_alloc(st
 	pmem->pfn_flags = PFN_DEV;
 	if (pmem_should_map_pages(dev)) {
 		pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, res,
-				NULL);
+				&q->q_usage_counter, NULL);
 		pmem->pfn_flags |= PFN_MAP;
 	} else
 		pmem->virt_addr = (void __pmem *) devm_memremap(dev,
@@ -323,6 +323,7 @@ static int nvdimm_namespace_attach_pfn(s
 	struct vmem_altmap *altmap;
 	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
+	struct request_queue *q;
 	phys_addr_t offset;
 	int rc;
 	struct vmem_altmap __altmap = {
@@ -374,9 +375,10 @@ static int nvdimm_namespace_attach_pfn(s
 
 	/* establish pfn range for lookup, and switch to direct map */
 	pmem = dev_get_drvdata(dev);
+	q = pmem->pmem_queue;
 	devm_memunmap(dev, (void __force *) pmem->virt_addr);
 	pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, &nsio->res,
-			altmap);
+			&q->q_usage_counter, altmap);
 	pmem->pfn_flags |= PFN_MAP;
 	if (IS_ERR(pmem->virt_addr)) {
 		rc = PTR_ERR(pmem->virt_addr);
diff -puN include/linux/mm.h~mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup include/linux/mm.h
--- a/include/linux/mm.h~mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup
+++ a/include/linux/mm.h
@@ -15,12 +15,14 @@
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
 #include <linux/range.h>
+#include <linux/percpu-refcount.h>
 #include <linux/pfn.h>
 #include <linux/bit_spinlock.h>
 #include <linux/shrinker.h>
 #include <linux/resource.h>
 #include <linux/page_ext.h>
 #include <linux/err.h>
+#include <linux/ioport.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -757,21 +759,25 @@ static inline void vmem_altmap_free(stru
 /**
  * struct dev_pagemap - metadata for ZONE_DEVICE mappings
  * @altmap: pre-allocated/reserved memory for vmemmap allocations
+ * @res: physical address range covered by @ref
+ * @ref: reference count that pins the devm_memremap_pages() mapping
  * @dev: host device of the mapping for debug
  */
 struct dev_pagemap {
 	struct vmem_altmap *altmap;
 	const struct resource *res;
+	struct percpu_ref *ref;
 	struct device *dev;
 };
 
 #ifdef CONFIG_ZONE_DEVICE
 void *devm_memremap_pages(struct device *dev, struct resource *res,
-		struct vmem_altmap *altmap);
+		struct percpu_ref *ref, struct vmem_altmap *altmap);
 struct dev_pagemap *find_dev_pagemap(resource_size_t phys);
 #else
 static inline void *devm_memremap_pages(struct device *dev,
-		struct resource *res, struct vmem_altmap *altmap)
+		struct resource *res, struct percpu_ref *ref,
+		struct vmem_altmap *altmap)
 {
 	/*
 	 * Fail attempts to call devm_memremap_pages() without
@@ -797,6 +803,45 @@ static inline struct vmem_altmap *to_vme
 }
 #endif
 
+/**
+ * get_dev_pagemap() - take a new live reference on the dev_pagemap for @pfn
+ * @pfn: page frame number to lookup page_map
+ * @pgmap: optional known pgmap that already has a reference
+ *
+ * @pgmap allows the overhead of a lookup to be bypassed when @pfn lands in the
+ * same mapping.
+ */
+static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
+		struct dev_pagemap *pgmap)
+{
+	const struct resource *res = pgmap ? pgmap->res : NULL;
+	resource_size_t phys = __pfn_to_phys(pfn);
+
+	/*
+	 * In the cached case we're already holding a live reference so
+	 * we can simply do a blind increment
+	 */
+	if (res && phys >= res->start && phys <= res->end) {
+		percpu_ref_get(pgmap->ref);
+		return pgmap;
+	}
+
+	/* fall back to slow path lookup */
+	rcu_read_lock();
+	pgmap = find_dev_pagemap(phys);
+	if (pgmap && !percpu_ref_tryget_live(pgmap->ref))
+		pgmap = NULL;
+	rcu_read_unlock();
+
+	return pgmap;
+}
+
+static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
+{
+	if (pgmap)
+		percpu_ref_put(pgmap->ref);
+}
+
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
 #endif
diff -puN include/linux/mm_types.h~mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup
+++ a/include/linux/mm_types.h
@@ -116,6 +116,11 @@ struct page {
 					 * Can be used as a generic list
 					 * by the page owner.
 					 */
+		struct dev_pagemap *pgmap; /* ZONE_DEVICE pages are never on an
+					    * lru or handled by a slab
+					    * allocator, this points to the
+					    * hosting device page map.
+					    */
 		struct {		/* slub per cpu partial pages */
 			struct page *next;	/* Next partial slab */
 #ifdef CONFIG_64BIT
diff -puN kernel/memremap.c~mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup kernel/memremap.c
--- a/kernel/memremap.c~mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup
+++ a/kernel/memremap.c
@@ -177,6 +177,29 @@ static void pgmap_radix_release(struct r
 	mutex_unlock(&pgmap_lock);
 }
 
+static unsigned long pfn_first(struct page_map *page_map)
+{
+	struct dev_pagemap *pgmap = &page_map->pgmap;
+	const struct resource *res = &page_map->res;
+	struct vmem_altmap *altmap = pgmap->altmap;
+	unsigned long pfn;
+
+	pfn = res->start >> PAGE_SHIFT;
+	if (altmap)
+		pfn += vmem_altmap_offset(altmap);
+	return pfn;
+}
+
+static unsigned long pfn_end(struct page_map *page_map)
+{
+	const struct resource *res = &page_map->res;
+
+	return (res->start + resource_size(res)) >> PAGE_SHIFT;
+}
+
+#define for_each_device_pfn(pfn, map) \
+	for (pfn = pfn_first(map); pfn < pfn_end(map); pfn++)
+
 static void devm_memremap_pages_release(struct device *dev, void *data)
 {
 	struct page_map *page_map = data;
@@ -184,6 +207,11 @@ static void devm_memremap_pages_release(
 	resource_size_t align_start, align_size;
 	struct dev_pagemap *pgmap = &page_map->pgmap;
 
+	if (percpu_ref_tryget_live(pgmap->ref)) {
+		dev_WARN(dev, "%s: page mapping is still live!\n", __func__);
+		percpu_ref_put(pgmap->ref);
+	}
+
 	pgmap_radix_release(res);
 
 	/* pages are dead and unused, undo the arch mapping */
@@ -209,20 +237,26 @@ struct dev_pagemap *find_dev_pagemap(res
  * devm_memremap_pages - remap and provide memmap backing for the given resource
  * @dev: hosting device for @res
  * @res: "host memory" address range
+ * @ref: a live per-cpu reference count
  * @altmap: optional descriptor for allocating the memmap from @res
  *
- * Note, the expectation is that @res is a host memory range that could
- * feasibly be treated as a "System RAM" range, i.e. not a device mmio
- * range, but this is not enforced.
+ * Notes:
+ * 1/ @ref must be 'live' on entry and 'dead' before devm_memunmap_pages() time
+ *    (or devm release event).
+ *
+ * 2/ @res is expected to be a host memory range that could feasibly be
+ *    treated as a "System RAM" range, i.e. not a device mmio range, but
+ *    this is not enforced.
  */
 void *devm_memremap_pages(struct device *dev, struct resource *res,
-		struct vmem_altmap *altmap)
+		struct percpu_ref *ref, struct vmem_altmap *altmap)
 {
 	int is_ram = region_intersects(res->start, resource_size(res),
 			"System RAM");
 	resource_size_t key, align_start, align_size;
 	struct dev_pagemap *pgmap;
 	struct page_map *page_map;
+	unsigned long pfn;
 	int error, nid;
 
 	if (is_ram == REGION_MIXED) {
@@ -240,6 +274,9 @@ void *devm_memremap_pages(struct device
 		return ERR_PTR(-ENXIO);
 	}
 
+	if (!ref)
+		return ERR_PTR(-EINVAL);
+
 	page_map = devres_alloc_node(devm_memremap_pages_release,
 			sizeof(*page_map), GFP_KERNEL, dev_to_node(dev));
 	if (!page_map)
@@ -253,6 +290,7 @@ void *devm_memremap_pages(struct device
 		memcpy(&page_map->altmap, altmap, sizeof(*altmap));
 		pgmap->altmap = &page_map->altmap;
 	}
+	pgmap->ref = ref;
 	pgmap->res = &page_map->res;
 
 	mutex_lock(&pgmap_lock);
@@ -290,6 +328,13 @@ void *devm_memremap_pages(struct device
 	if (error)
 		goto err_add_memory;
 
+	for_each_device_pfn(pfn, page_map) {
+		struct page *page = pfn_to_page(pfn);
+
+		/* ZONE_DEVICE pages never appear on a slab lru */
+		list_del_poison(&page->lru);
+		page->pgmap = pgmap;
+	}
 	devres_add(dev, page_map);
 	return __va(res->start);
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

scatterlist-fix-sg_phys-masking.patch
pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-dax-pmem-introduce-pfn_t-v3.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
list-introduce-list_del_poison.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

