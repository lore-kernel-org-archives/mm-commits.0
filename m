From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-find_dev_pagemap.patch removed from -mm
 tree
Date: Tue, 19 Jan 2016 12:13:27 -0800
Message-ID: <569e98e7.H2Ms2ehy4l0ahgvb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133AbcASUN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, david@fromorbit.com, hch@lst.de, logang@deltatee.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce find_dev_pagemap()
has been removed from the -mm tree.  Its filename was
     mm-introduce-find_dev_pagemap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/nvdimm/pmem.c    |    2 
 include/linux/io.h       |   15 ------
 include/linux/memremap.h |   38 ++++++++++++++++
 kernel/memremap.c        |   85 +++++++++++++++++++++++++++++++++----
 4 files changed, 116 insertions(+), 24 deletions(-)

diff -puN drivers/nvdimm/pmem.c~mm-introduce-find_dev_pagemap drivers/nvdimm/pmem.c
--- a/drivers/nvdimm/pmem.c~mm-introduce-find_dev_pagemap
+++ a/drivers/nvdimm/pmem.c
@@ -21,9 +21,9 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
-#include <linux/memory_hotplug.h>
 #include <linux/moduleparam.h>
 #include <linux/badblocks.h>
+#include <linux/memremap.h>
 #include <linux/vmalloc.h>
 #include <linux/pfn_t.h>
 #include <linux/slab.h>
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
diff -puN /dev/null include/linux/memremap.h
--- /dev/null
+++ a/include/linux/memremap.h
@@ -0,0 +1,38 @@
+#ifndef _LINUX_MEMREMAP_H_
+#define _LINUX_MEMREMAP_H_
+#include <linux/mm.h>
+
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
+#endif /* _LINUX_MEMREMAP_H_ */
diff -puN kernel/memremap.c~mm-introduce-find_dev_pagemap kernel/memremap.c
--- a/kernel/memremap.c~mm-introduce-find_dev_pagemap
+++ a/kernel/memremap.c
@@ -10,6 +10,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <linux/radix-tree.h>
+#include <linux/memremap.h>
 #include <linux/device.h>
 #include <linux/types.h>
 #include <linux/pfn_t.h>
@@ -155,22 +157,57 @@ pfn_t phys_to_pfn_t(dma_addr_t addr, uns
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
 
@@ -190,18 +227,50 @@ void *devm_memremap_pages(struct device
 
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

dax-add-support-for-fsync-sync-v6-fix.patch

