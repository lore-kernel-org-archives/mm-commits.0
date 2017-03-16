From: akpm@linux-foundation.org
Subject: + mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch
 added to -mm tree
Date: Thu, 16 Mar 2017 13:52:12 -0700
Message-ID: <58cafafc.sBo7K+xgu/gqNocO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52832 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752265AbdCPVDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, ebaskakov@nvidia.com, jhubbard@nvidia.com, mhairgrove@nvidia.com, sgutti@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm/devmem: device memory hotplug using ZONE_DEVICE
has been added to the -mm tree.  Its filename is
     mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/hmm/devmem: device memory hotplug using ZONE_DEVICE

This introduce a simple struct and associated helpers for device driver to
use when hotpluging un-addressable device memory as ZONE_DEVICE.  It will
find a unuse physical address range and trigger memory hotplug for it
which allocates and initialize struct page for the device memory.

Link: http://lkml.kernel.org/r/1489680335-6594-16-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Evgeny Baskakov <ebaskakov@nvidia.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Mark Hairgrove <mhairgrove@nvidia.com>
Signed-off-by: Sherry Cheung <SCheung@nvidia.com>
Signed-off-by: Subhash Gutti <sgutti@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h |  115 ++++++++++++
 mm/Kconfig          |    7 
 mm/hmm.c            |  398 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 520 insertions(+)

diff -puN include/linux/hmm.h~mm-hmm-devmem-device-memory-hotplug-using-zone_device include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-devmem-device-memory-hotplug-using-zone_device
+++ a/include/linux/hmm.h
@@ -79,6 +79,11 @@
 
 #if IS_ENABLED(CONFIG_HMM)
 
+#include <linux/migrate.h>
+#include <linux/memremap.h>
+#include <linux/completion.h>
+
+
 struct hmm;
 
 /*
@@ -321,6 +326,116 @@ int hmm_vma_fault(struct vm_area_struct
 #endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
 
 
+#if IS_ENABLED(CONFIG_HMM_DEVMEM)
+struct hmm_devmem;
+
+struct page *hmm_vma_alloc_locked_page(struct vm_area_struct *vma,
+				       unsigned long addr);
+
+/*
+ * struct hmm_devmem_ops - callback for ZONE_DEVICE memory events
+ *
+ * @free: call when refcount on page reach 1 and thus is no longer use
+ * @fault: call when there is a page fault to unaddressable memory
+ */
+struct hmm_devmem_ops {
+	void (*free)(struct hmm_devmem *devmem, struct page *page);
+	int (*fault)(struct hmm_devmem *devmem,
+		     struct vm_area_struct *vma,
+		     unsigned long addr,
+		     struct page *page,
+		     unsigned flags,
+		     pmd_t *pmdp);
+};
+
+/*
+ * struct hmm_devmem - track device memory
+ *
+ * @completion: completion object for device memory
+ * @pfn_first: first pfn for this resource (set by hmm_devmem_add())
+ * @pfn_last: last pfn for this resource (set by hmm_devmem_add())
+ * @resource: IO resource reserved for this chunk of memory
+ * @pagemap: device page map for that chunk
+ * @device: device to bind resource to
+ * @ops: memory operations callback
+ * @ref: per CPU refcount
+ *
+ * This an helper structure for device drivers that do not wish to implement
+ * the gory details related to hotplugging new memoy and allocating struct
+ * pages.
+ *
+ * Device drivers can directly use ZONE_DEVICE memory on their own if they
+ * wish to do so.
+ */
+struct hmm_devmem {
+	struct completion		completion;
+	unsigned long			pfn_first;
+	unsigned long			pfn_last;
+	struct resource			*resource;
+	struct device			*device;
+	struct dev_pagemap		pagemap;
+	const struct hmm_devmem_ops	*ops;
+	struct percpu_ref		ref;
+};
+
+/*
+ * To add (hotplug) device memory, HMM assumes that there is no real resource
+ * that reserves a range in the physical address space (this is intended to be
+ * use by unaddressable device memory). It will reserve a physical range big
+ * enough and allocate struct page for it.
+ *
+ * Device driver can wrap the hmm_devmem struct inside a private device driver
+ * struct. Device driver must call hmm_devmem_remove() before device goes away
+ * and before freeing the hmm_devmem struct memory.
+ */
+struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
+				  struct device *device,
+				  unsigned long size);
+void hmm_devmem_remove(struct hmm_devmem *devmem);
+
+int hmm_devmem_fault_range(struct hmm_devmem *devmem,
+			   struct vm_area_struct *vma,
+			   const struct migrate_vma_ops *ops,
+			   unsigned long mentry,
+			   unsigned long *src,
+			   unsigned long *dst,
+			   unsigned long start,
+			   unsigned long addr,
+			   unsigned long end,
+			   void *private);
+
+/*
+ * hmm_devmem_page_set_drvdata - set per-page driver data field
+ *
+ * @page: pointer to struct page
+ * @data: driver data value to set
+ *
+ * Because page can not be on lru we have an unsigned long that driver can use
+ * to store a per page field. This just a simple helper to do that.
+ */
+static inline void hmm_devmem_page_set_drvdata(struct page *page,
+					       unsigned long data)
+{
+	unsigned long *drvdata = (unsigned long *)&page->pgmap;
+
+	drvdata[1] = data;
+}
+
+/*
+ * hmm_devmem_page_get_drvdata - get per page driver data field
+ *
+ * @page: pointer to struct page
+ * Return: driver data value
+ */
+static inline unsigned long hmm_devmem_page_get_drvdata(struct page *page)
+{
+	unsigned long *drvdata = (unsigned long *)&page->pgmap;
+
+	return drvdata[1];
+}
+#endif /* IS_ENABLED(CONFIG_HMM_DEVMEM) */
+
+
 /* Below are for HMM internal use only! Not to be used by device driver! */
 void hmm_mm_destroy(struct mm_struct *mm);
 
diff -puN mm/Kconfig~mm-hmm-devmem-device-memory-hotplug-using-zone_device mm/Kconfig
--- a/mm/Kconfig~mm-hmm-devmem-device-memory-hotplug-using-zone_device
+++ a/mm/Kconfig
@@ -308,6 +308,13 @@ config HMM_MIRROR
 	  range of virtual address. This require careful synchronization with
 	  CPU page table update.
 
+config HMM_DEVMEM
+	bool "HMM device memory helpers (to leverage ZONE_DEVICE)"
+	select HMM
+	help
+	  HMM devmem are helpers to leverage new ZONE_DEVICE feature. This is
+	  just to avoid device driver to replicate boiler plate code.
+
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
 
diff -puN mm/hmm.c~mm-hmm-devmem-device-memory-hotplug-using-zone_device mm/hmm.c
--- a/mm/hmm.c~mm-hmm-devmem-device-memory-hotplug-using-zone_device
+++ a/mm/hmm.c
@@ -23,10 +23,15 @@
 #include <linux/swap.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/mmzone.h>
+#include <linux/pagemap.h>
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
+#include <linux/memremap.h>
 #include <linux/mmu_notifier.h>
 
+#define SECTION_SIZE (1UL << PA_SECTION_SHIFT)
+
 
 /*
  * struct hmm - HMM per mm struct
@@ -735,3 +740,396 @@ int hmm_vma_fault(struct vm_area_struct
 }
 EXPORT_SYMBOL(hmm_vma_fault);
 #endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
+
+
+#if IS_ENABLED(CONFIG_HMM_DEVMEM)
+struct page *hmm_vma_alloc_locked_page(struct vm_area_struct *vma,
+				       unsigned long addr)
+{
+	struct page *page;
+
+	page = alloc_page_vma(GFP_HIGHUSER, vma, addr);
+	if (!page)
+		return NULL;
+	lock_page(page);
+	return page;
+}
+EXPORT_SYMBOL(hmm_vma_alloc_locked_page);
+
+
+static void hmm_devmem_ref_release(struct percpu_ref *ref)
+{
+	struct hmm_devmem *devmem;
+
+	devmem = container_of(ref, struct hmm_devmem, ref);
+	complete(&devmem->completion);
+}
+
+static void hmm_devmem_ref_exit(void *data)
+{
+	struct percpu_ref *ref = data;
+	struct hmm_devmem *devmem;
+
+	devmem = container_of(ref, struct hmm_devmem, ref);
+	percpu_ref_exit(ref);
+	devm_remove_action(devmem->device, &hmm_devmem_ref_exit, data);
+}
+
+static void hmm_devmem_ref_kill(void *data)
+{
+	struct percpu_ref *ref = data;
+	struct hmm_devmem *devmem;
+
+	devmem = container_of(ref, struct hmm_devmem, ref);
+	percpu_ref_kill(ref);
+	wait_for_completion(&devmem->completion);
+	devm_remove_action(devmem->device, &hmm_devmem_ref_kill, data);
+}
+
+static int hmm_devmem_fault(struct vm_area_struct *vma,
+			    unsigned long addr,
+			    struct page *page,
+			    unsigned flags,
+			    pmd_t *pmdp)
+{
+	struct hmm_devmem *devmem = page->pgmap->data;
+
+	return devmem->ops->fault(devmem, vma, addr, page, flags, pmdp);
+}
+
+static void hmm_devmem_free(struct page *page, void *data)
+{
+	struct hmm_devmem *devmem = data;
+
+	devmem->ops->free(devmem, page);
+}
+
+static DEFINE_MUTEX(hmm_devmem_lock);
+static RADIX_TREE(hmm_devmem_radix, GFP_KERNEL);
+#define SECTION_SIZE (1UL << PA_SECTION_SHIFT)
+
+static void hmm_devmem_radix_release(struct resource *resource)
+{
+	resource_size_t key, align_start, align_size, align_end;
+
+	align_start = resource->start & ~(SECTION_SIZE - 1);
+	align_size = ALIGN(resource_size(resource), SECTION_SIZE);
+	align_end = align_start + align_size - 1;
+
+	mutex_lock(&hmm_devmem_lock);
+	for (key = resource->start; key <= resource->end; key += SECTION_SIZE)
+		radix_tree_delete(&hmm_devmem_radix, key >> PA_SECTION_SHIFT);
+	mutex_unlock(&hmm_devmem_lock);
+}
+
+static void hmm_devmem_release(struct device *dev, void *data)
+{
+	struct hmm_devmem *devmem = data;
+	resource_size_t align_start, align_size;
+	struct resource *resource = devmem->resource;
+
+	if (percpu_ref_tryget_live(&devmem->ref)) {
+		dev_WARN(dev, "%s: page mapping is still live!\n", __func__);
+		percpu_ref_put(&devmem->ref);
+	}
+
+	/* pages are dead and unused, undo the arch mapping */
+	align_start = resource->start & ~(SECTION_SIZE - 1);
+	align_size = ALIGN(resource_size(resource), SECTION_SIZE);
+	arch_remove_memory(align_start, align_size, devmem->pagemap.flags);
+	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
+	hmm_devmem_radix_release(resource);
+}
+
+static struct hmm_devmem *hmm_devmem_find(resource_size_t phys)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	return radix_tree_lookup(&hmm_devmem_radix, phys >> PA_SECTION_SHIFT);
+}
+
+static int hmm_devmem_pages_create(struct hmm_devmem *devmem)
+{
+	resource_size_t key, align_start, align_size, align_end;
+	struct device *device = devmem->device;
+	pgprot_t pgprot = PAGE_KERNEL;
+	int ret, nid, is_ram;
+	unsigned long pfn;
+
+	align_start = devmem->resource->start & ~(SECTION_SIZE - 1);
+	align_size = ALIGN(devmem->resource->start +
+			   resource_size(devmem->resource),
+			   SECTION_SIZE) - align_start;
+
+	is_ram = region_intersects(align_start, align_size,
+				   IORESOURCE_SYSTEM_RAM,
+				   IORES_DESC_NONE);
+	if (is_ram == REGION_MIXED) {
+		WARN_ONCE(1, "%s attempted on mixed region %pr\n",
+				__func__, devmem->resource);
+		return -ENXIO;
+	}
+	if (is_ram == REGION_INTERSECTS)
+		return -ENXIO;
+
+	devmem->pagemap.flags = MEMORY_DEVICE |
+				MEMORY_DEVICE_ALLOW_MIGRATE |
+				MEMORY_DEVICE_UNADDRESSABLE;
+	devmem->pagemap.res = devmem->resource;
+	devmem->pagemap.page_fault = hmm_devmem_fault;
+	devmem->pagemap.page_free = hmm_devmem_free;
+	devmem->pagemap.dev = devmem->device;
+	devmem->pagemap.ref = &devmem->ref;
+	devmem->pagemap.data = devmem;
+
+	mutex_lock(&hmm_devmem_lock);
+	align_end = align_start + align_size - 1;
+	for (key = align_start; key <= align_end; key += SECTION_SIZE) {
+		struct hmm_devmem *dup;
+
+		rcu_read_lock();
+		dup = hmm_devmem_find(key);
+		rcu_read_unlock();
+		if (dup) {
+			dev_err(device, "%s: collides with mapping for %s\n",
+				__func__, dev_name(dup->device));
+			mutex_unlock(&hmm_devmem_lock);
+			ret = -EBUSY;
+			goto error;
+		}
+		ret = radix_tree_insert(&hmm_devmem_radix,
+					key >> PA_SECTION_SHIFT,
+					devmem);
+		if (ret) {
+			dev_err(device, "%s: failed: %d\n", __func__, ret);
+			mutex_unlock(&hmm_devmem_lock);
+			goto error_radix;
+		}
+	}
+	mutex_unlock(&hmm_devmem_lock);
+
+	nid = dev_to_node(device);
+	if (nid < 0)
+		nid = numa_mem_id();
+
+	ret = track_pfn_remap(NULL, &pgprot, PHYS_PFN(align_start),
+			      0, align_size);
+	if (ret)
+		goto error_radix;
+
+	ret = arch_add_memory(nid, align_start, align_size,
+			      devmem->pagemap.flags);
+	if (ret)
+		goto error_add_memory;
+
+	for (pfn = devmem->pfn_first; pfn < devmem->pfn_last; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		/*
+		 * ZONE_DEVICE pages union ->lru with a ->pgmap back
+		 * pointer.  It is a bug if a ZONE_DEVICE page is ever
+		 * freed or placed on a driver-private list.  Seed the
+		 * storage with LIST_POISON* values.
+		 */
+		list_del(&page->lru);
+		page->pgmap = &devmem->pagemap;
+	}
+	return 0;
+
+error_add_memory:
+	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
+error_radix:
+	hmm_devmem_radix_release(devmem->resource);
+error:
+	return ret;
+}
+
+static int hmm_devmem_match(struct device *dev, void *data, void *match_data)
+{
+	struct hmm_devmem *devmem = data;
+
+	return devmem->resource == match_data;
+}
+
+static void hmm_devmem_pages_remove(struct hmm_devmem *devmem)
+{
+	devres_release(devmem->device, &hmm_devmem_release,
+		       &hmm_devmem_match, devmem->resource);
+}
+
+/*
+ * hmm_devmem_add() - hotplug fake ZONE_DEVICE memory for device memory
+ *
+ * @ops: memory event device driver callback (see struct hmm_devmem_ops)
+ * @device: device struct to bind the resource too
+ * @size: size in bytes of the device memory to add
+ * Returns: pointer to new hmm_devmem struct ERR_PTR otherwise
+ *
+ * This first find an empty range of physical address big enough to for the new
+ * resource and then hotplug it as ZONE_DEVICE memory allocating struct page.
+ * It does not do anything beside that, all events affecting the memory will go
+ * through the various callback provided by hmm_devmem_ops struct.
+ */
+struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
+				  struct device *device,
+				  unsigned long size)
+{
+	struct hmm_devmem *devmem;
+	resource_size_t addr;
+	int ret;
+
+	devmem = devres_alloc_node(&hmm_devmem_release, sizeof(*devmem),
+				   GFP_KERNEL, dev_to_node(device));
+	if (!devmem)
+		return ERR_PTR(-ENOMEM);
+
+	init_completion(&devmem->completion);
+	devmem->pfn_first = -1UL;
+	devmem->pfn_last = -1UL;
+	devmem->resource = NULL;
+	devmem->device = device;
+	devmem->ops = ops;
+
+	ret = percpu_ref_init(&devmem->ref, &hmm_devmem_ref_release,
+			      0, GFP_KERNEL);
+	if (ret)
+		goto error_percpu_ref;
+
+	ret = devm_add_action(device, hmm_devmem_ref_exit, &devmem->ref);
+	if (ret)
+		goto error_devm_add_action;
+
+	size = ALIGN(size, SECTION_SIZE);
+	addr = (iomem_resource.end + 1ULL) - size;
+
+	/*
+	 * FIXME add a new helper to quickly walk resource tree and find free
+	 * range
+	 *
+	 * FIXME what about ioport_resource resource ?
+	 */
+	for (; addr > size && addr >= iomem_resource.start; addr -= size) {
+		ret = region_intersects(addr, size, 0, IORES_DESC_NONE);
+		if (ret != REGION_DISJOINT)
+			continue;
+
+		devmem->resource = devm_request_mem_region(device, addr, size,
+							   dev_name(device));
+		if (!devmem->resource) {
+			ret = -ENOMEM;
+			goto error_no_resource;
+		}
+		devmem->resource->desc = IORES_DESC_UNADDRESSABLE_MEMORY;
+		break;
+	}
+	if (!devmem->resource) {
+		ret = -ERANGE;
+		goto error_no_resource;
+	}
+
+	devmem->pfn_first = devmem->resource->start >> PAGE_SHIFT;
+	devmem->pfn_last = devmem->pfn_first +
+			   (resource_size(devmem->resource) >> PAGE_SHIFT);
+
+	ret = hmm_devmem_pages_create(devmem);
+	if (ret)
+		goto error_pages;
+
+	devres_add(device, devmem);
+
+	ret = devm_add_action(device, hmm_devmem_ref_kill, &devmem->ref);
+	if (ret) {
+		hmm_devmem_remove(devmem);
+		return ERR_PTR(ret);
+	}
+
+	return devmem;
+
+error_pages:
+	devm_release_mem_region(device, devmem->resource->start,
+				resource_size(devmem->resource));
+error_no_resource:
+error_devm_add_action:
+	hmm_devmem_ref_kill(&devmem->ref);
+	hmm_devmem_ref_exit(&devmem->ref);
+error_percpu_ref:
+	devres_free(devmem);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(hmm_devmem_add);
+
+/*
+ * hmm_devmem_remove() - remove device memory (kill and free ZONE_DEVICE)
+ *
+ * @devmem: hmm_devmem struct use to track and manage the ZONE_DEVICE memory
+ *
+ * This will hot-unplug memory that was hotplugged by hmm_devmem_add on behalf
+ * of the device driver. It will free struct page and remove the resource that
+ * reserve the physical address range for this device memory.
+ */
+void hmm_devmem_remove(struct hmm_devmem *devmem)
+{
+	resource_size_t start, size;
+	struct device *device;
+
+	if (!devmem)
+		return;
+
+	device = devmem->device;
+	start = devmem->resource->start;
+	size = resource_size(devmem->resource);
+
+	hmm_devmem_ref_kill(&devmem->ref);
+	hmm_devmem_ref_exit(&devmem->ref);
+	hmm_devmem_pages_remove(devmem);
+
+	devm_release_mem_region(device, start, size);
+}
+EXPORT_SYMBOL(hmm_devmem_remove);
+
+/*
+ * hmm_devmem_fault_range() - migrate back a virtual range of memory
+ *
+ * @devmem: hmm_devmem struct use to track and manage the ZONE_DEVICE memory
+ * @vma: virtual memory area containing the range to be migrated
+ * @ops: migration callback for allocating destination memory and copying
+ * @mentry: maximum number of entries in src or dst array
+ * @src: array of unsigned long containing source pfns
+ * @dst: array of unsigned long containing destination pfns
+ * @start: start address of the range to migrate (inclusive)
+ * @addr: fault address (must be inside the range)
+ * @end: end address of the range to migrate (exclusive)
+ * @private: pointer passed back to each of the callback
+ * Returns: 0 on success, VM_FAULT_SIGBUS on error
+ *
+ * This is a wrapper around migrate_vma() which check the migration status
+ * for a given fault address and return corresponding page fault handler status
+ * ie 0 on success or VM_FAULT_SIGBUS if migration failed for fault address.
+ *
+ * This is a helper intendend to be used by ZONE_DEVICE fault handler.
+ */
+int hmm_devmem_fault_range(struct hmm_devmem *devmem,
+			   struct vm_area_struct *vma,
+			   const struct migrate_vma_ops *ops,
+			   unsigned long mentry,
+			   unsigned long *src,
+			   unsigned long *dst,
+			   unsigned long start,
+			   unsigned long addr,
+			   unsigned long end,
+			   void *private)
+{
+	unsigned long i, size, tmp;
+	if (migrate_vma(ops, vma, mentry, start, end, src, dst, private))
+		return VM_FAULT_SIGBUS;
+
+	for (i = 0, tmp = start; tmp < addr; i++, tmp += size) {
+		size = migrate_pfn_size(src[i]);
+	}
+	if (dst[i] & MIGRATE_PFN_ERROR)
+		return VM_FAULT_SIGBUS;
+
+	return 0;
+}
+EXPORT_SYMBOL(hmm_devmem_fault_range);
+#endif /* IS_ENABLED(CONFIG_HMM_DEVMEM) */
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3.patch
mm-put_page-move-ref-decrement-to-put_zone_device_page.patch
mm-zone_device-free-page-callback-when-page-is-freed-v3.patch
mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3.patch
mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch
mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch

