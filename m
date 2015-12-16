From: akpm@linux-foundation.org
Subject: + mm-introduce-find_dev_pagemap.patch added to -mm tree
Date: Tue, 15 Dec 2015 16:16:53 -0800
Message-ID: <5670ad75.0wHIYjj6tXhwA2bD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbbLPAQy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:16:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, david@fromorbit.com, hch@lst.de, logang@deltatee.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce find_dev_pagemap()
has been added to the -mm tree.  Its filename is
     mm-introduce-find_dev_pagemap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-find_dev_pagemap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-find_dev_pagemap.patch

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
Subject: mm: introduce find_dev_pagemap()

There are several scenarios where we need to retrieve and update metadata
associated with a given devm_memremap_pages() mapping, and the only lookup
key available is a pfn in the range:

1/ We want to augment vmemmap_populate() (called via arch_add_memory())
   to allocate memmap storage from pre-allocated pages reserved by the
   device driver.  At vmemmap_alloc_block_buf() time it grabs device pages
   rather than page allocator pages.  This is in support of
   devm_memremap_pages() mappings where the memmap is too large to fit in
   main memory (i.e. large persistent memory devices).

2/ Taking a reference against the mapping when inserting device pages
   into the address_space radix of a given inode.  This facilitates
   unmap_mapping_range() and truncate_inode_pages() operations when the
   driver is tearing down the mapping.

3/ get_user_pages() operations on ZONE_DEVICE memory require taking a
   reference against the mapping so that the driver teardown path can
   revoke and drain usage of device pages.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io.h |   15 -------
 include/linux/mm.h |   33 ++++++++++++++++
 kernel/memremap.c  |   84 ++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 109 insertions(+), 23 deletions(-)

diff -puN include/linux/io.h~mm-introduce-find_dev_pagemap include/linux/io.h
--- a/include/linux/io.h~mm-introduce-find_dev_pagemap
+++ a/include/linux/io.h
@@ -89,21 +89,6 @@ void devm_memunmap(struct device *dev, v
 
 void *__devm_memremap_pages(struct device *dev, struct resource *res);
 
-#ifdef CONFIG_ZONE_DEVICE
-void *devm_memremap_pages(struct device *dev, struct resource *res);
-#else
-static inline void *devm_memremap_pages(struct device *dev, struct resource *res)
-{
-	/*
-	 * Fail attempts to call devm_memremap_pages() without
-	 * ZONE_DEVICE support enabled, this requires callers to fall
-	 * back to plain devm_memremap() based on config
-	 */
-	WARN_ON_ONCE(1);
-	return ERR_PTR(-ENXIO);
-}
-#endif
-
 /*
  * Some systems do not have legacy ISA devices.
  * /dev/port is not a valid interface on these systems.
diff -puN include/linux/mm.h~mm-introduce-find_dev_pagemap include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-find_dev_pagemap
+++ a/include/linux/mm.h
@@ -686,6 +686,39 @@ static inline enum zone_type page_zonenu
 	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
 }
 
+struct resource;
+struct device;
+/**
+ * struct dev_pagemap - metadata for ZONE_DEVICE mappings
+ * @dev: host device of the mapping for debug
+ */
+struct dev_pagemap {
+	/* TODO: vmem_altmap and percpu_ref count */
+	struct device *dev;
+};
+
+#ifdef CONFIG_ZONE_DEVICE
+void *devm_memremap_pages(struct device *dev, struct resource *res);
+struct dev_pagemap *find_dev_pagemap(resource_size_t phys);
+#else
+static inline void *devm_memremap_pages(struct device *dev,
+		struct resource *res)
+{
+	/*
+	 * Fail attempts to call devm_memremap_pages() without
+	 * ZONE_DEVICE support enabled, this requires callers to fall
+	 * back to plain devm_memremap() based on config
+	 */
+	WARN_ON_ONCE(1);
+	return ERR_PTR(-ENXIO);
+}
+
+static inline struct dev_pagemap *find_dev_pagemap(resource_size_t phys)
+{
+	return NULL;
+}
+#endif
+
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
 #endif
diff -puN kernel/memremap.c~mm-introduce-find_dev_pagemap kernel/memremap.c
--- a/kernel/memremap.c~mm-introduce-find_dev_pagemap
+++ a/kernel/memremap.c
@@ -10,6 +10,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <linux/radix-tree.h>
 #include <linux/device.h>
 #include <linux/types.h>
 #include <linux/io.h>
@@ -154,22 +155,57 @@ pfn_t phys_to_pfn_t(dma_addr_t addr, uns
 EXPORT_SYMBOL(phys_to_pfn_t);
 
 #ifdef CONFIG_ZONE_DEVICE
+static DEFINE_MUTEX(pgmap_lock);
+static RADIX_TREE(pgmap_radix, GFP_KERNEL);
+#define SECTION_MASK ~((1UL << PA_SECTION_SHIFT) - 1)
+#define SECTION_SIZE (1UL << PA_SECTION_SHIFT)
+
 struct page_map {
 	struct resource res;
+	struct percpu_ref *ref;
+	struct dev_pagemap pgmap;
 };
 
-static void devm_memremap_pages_release(struct device *dev, void *res)
+static void pgmap_radix_release(struct resource *res)
+{
+	resource_size_t key;
+
+	mutex_lock(&pgmap_lock);
+	for (key = res->start; key <= res->end; key += SECTION_SIZE)
+		radix_tree_delete(&pgmap_radix, key >> PA_SECTION_SHIFT);
+	mutex_unlock(&pgmap_lock);
+}
+
+static void devm_memremap_pages_release(struct device *dev, void *data)
 {
-	struct page_map *page_map = res;
+	struct page_map *page_map = data;
+	struct resource *res = &page_map->res;
+	resource_size_t align_start, align_size;
+
+	pgmap_radix_release(res);
 
 	/* pages are dead and unused, undo the arch mapping */
-	arch_remove_memory(page_map->res.start, resource_size(&page_map->res));
+	align_start = res->start & ~(SECTION_SIZE - 1);
+	align_size = ALIGN(resource_size(res), SECTION_SIZE);
+	arch_remove_memory(align_start, align_size);
+}
+
+/* assumes rcu_read_lock() held at entry */
+struct dev_pagemap *find_dev_pagemap(resource_size_t phys)
+{
+	struct page_map *page_map;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	page_map = radix_tree_lookup(&pgmap_radix, phys >> PA_SECTION_SHIFT);
+	return page_map ? &page_map->pgmap : NULL;
 }
 
 void *devm_memremap_pages(struct device *dev, struct resource *res)
 {
 	int is_ram = region_intersects(res->start, resource_size(res),
 			"System RAM");
+	resource_size_t key, align_start, align_size;
 	struct page_map *page_map;
 	int error, nid;
 
@@ -189,18 +225,50 @@ void *devm_memremap_pages(struct device
 
 	memcpy(&page_map->res, res, sizeof(*res));
 
+	page_map->pgmap.dev = dev;
+	mutex_lock(&pgmap_lock);
+	error = 0;
+	for (key = res->start; key <= res->end; key += SECTION_SIZE) {
+		struct dev_pagemap *dup;
+
+		rcu_read_lock();
+		dup = find_dev_pagemap(key);
+		rcu_read_unlock();
+		if (dup) {
+			dev_err(dev, "%s: %pr collides with mapping for %s\n",
+					__func__, res, dev_name(dup->dev));
+			error = -EBUSY;
+			break;
+		}
+		error = radix_tree_insert(&pgmap_radix, key >> PA_SECTION_SHIFT,
+				page_map);
+		if (error) {
+			dev_err(dev, "%s: failed: %d\n", __func__, error);
+			break;
+		}
+	}
+	mutex_unlock(&pgmap_lock);
+	if (error)
+		goto err_radix;
+
 	nid = dev_to_node(dev);
 	if (nid < 0)
 		nid = numa_mem_id();
 
-	error = arch_add_memory(nid, res->start, resource_size(res), true);
-	if (error) {
-		devres_free(page_map);
-		return ERR_PTR(error);
-	}
+	align_start = res->start & ~(SECTION_SIZE - 1);
+	align_size = ALIGN(resource_size(res), SECTION_SIZE);
+	error = arch_add_memory(nid, align_start, align_size, true);
+	if (error)
+		goto err_add_memory;
 
 	devres_add(dev, page_map);
 	return __va(res->start);
+
+ err_add_memory:
+ err_radix:
+	pgmap_radix_release(res);
+	devres_free(page_map);
+	return ERR_PTR(error);
 }
 EXPORT_SYMBOL(devm_memremap_pages);
 #endif /* CONFIG_ZONE_DEVICE */
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

