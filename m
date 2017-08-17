From: akpm@linux-foundation.org
Subject: + mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch
 added to -mm tree
Date: Thu, 17 Aug 2017 14:42:34 -0700
Message-ID: <59960dca.o+7a7NBFF0q1nbur%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753283AbdHQVmf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 17:42:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhairgrove@nvidia.com, mhocko@kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, sgutti@nvidia.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm: add new helper to hotplug CDM memory region
has been added to the -mm tree.  Its filename is
     mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch

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
Subject: mm/hmm: add new helper to hotplug CDM memory region

Unlike unaddressable memory, coherent device memory has a real resource
associated with it on the system (as CPU can address it).  Add a new
helper to hotplug such memory within the HMM framework.

Link: http://lkml.kernel.org/r/20170817000548.32038-20-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Reviewed-by: Balbir Singh <bsingharora@gmail.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Evgeny Baskakov <ebaskakov@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mark Hairgrove <mhairgrove@nvidia.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Sherry Cheung <SCheung@nvidia.com>
Cc: Subhash Gutti <sgutti@nvidia.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h |    3 +
 mm/hmm.c            |   88 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 86 insertions(+), 5 deletions(-)

diff -puN include/linux/hmm.h~mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3 include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3
+++ a/include/linux/hmm.h
@@ -443,6 +443,9 @@ struct hmm_devmem {
 struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
 				  struct device *device,
 				  unsigned long size);
+struct hmm_devmem *hmm_devmem_add_resource(const struct hmm_devmem_ops *ops,
+					   struct device *device,
+					   struct resource *res);
 void hmm_devmem_remove(struct hmm_devmem *devmem);
 
 /*
diff -puN mm/hmm.c~mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3 mm/hmm.c
--- a/mm/hmm.c~mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3
+++ a/mm/hmm.c
@@ -854,7 +854,11 @@ static void hmm_devmem_release(struct de
 	zone = page_zone(page);
 
 	mem_hotplug_begin();
-	__remove_pages(zone, start_pfn, npages);
+	if (resource->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY)
+		__remove_pages(zone, start_pfn, npages);
+	else
+		arch_remove_memory(start_pfn << PAGE_SHIFT,
+				   npages << PAGE_SHIFT);
 	mem_hotplug_done();
 
 	hmm_devmem_radix_release(resource);
@@ -890,7 +894,11 @@ static int hmm_devmem_pages_create(struc
 	if (is_ram == REGION_INTERSECTS)
 		return -ENXIO;
 
-	devmem->pagemap.type = MEMORY_DEVICE_PRIVATE;
+	if (devmem->resource->desc == IORES_DESC_DEVICE_PUBLIC_MEMORY)
+		devmem->pagemap.type = MEMORY_DEVICE_PUBLIC;
+	else
+		devmem->pagemap.type = MEMORY_DEVICE_PRIVATE;
+
 	devmem->pagemap.res = devmem->resource;
 	devmem->pagemap.page_fault = hmm_devmem_fault;
 	devmem->pagemap.page_free = hmm_devmem_free;
@@ -935,9 +943,15 @@ static int hmm_devmem_pages_create(struc
 	 * over the device memory is un-accessible thus we do not want to
 	 * create a linear mapping for the memory like arch_add_memory()
 	 * would do.
+	 *
+	 * For device public memory, which is accesible by the CPU, we do
+	 * want the linear mapping and thus use arch_add_memory().
 	 */
-	ret = add_pages(nid, align_start >> PAGE_SHIFT,
-			align_size >> PAGE_SHIFT, false);
+	if (devmem->pagemap.type == MEMORY_DEVICE_PUBLIC)
+		ret = arch_add_memory(nid, align_start, align_size, false);
+	else
+		ret = add_pages(nid, align_start >> PAGE_SHIFT,
+				align_size >> PAGE_SHIFT, false);
 	if (ret) {
 		mem_hotplug_done();
 		goto error_add_memory;
@@ -1084,6 +1098,67 @@ error_percpu_ref:
 }
 EXPORT_SYMBOL(hmm_devmem_add);
 
+struct hmm_devmem *hmm_devmem_add_resource(const struct hmm_devmem_ops *ops,
+					   struct device *device,
+					   struct resource *res)
+{
+	struct hmm_devmem *devmem;
+	int ret;
+
+	if (res->desc != IORES_DESC_DEVICE_PUBLIC_MEMORY)
+		return ERR_PTR(-EINVAL);
+
+	static_branch_enable(&device_private_key);
+
+	devmem = devres_alloc_node(&hmm_devmem_release, sizeof(*devmem),
+				   GFP_KERNEL, dev_to_node(device));
+	if (!devmem)
+		return ERR_PTR(-ENOMEM);
+
+	init_completion(&devmem->completion);
+	devmem->pfn_first = -1UL;
+	devmem->pfn_last = -1UL;
+	devmem->resource = res;
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
+
+	devmem->pfn_first = devmem->resource->start >> PAGE_SHIFT;
+	devmem->pfn_last = devmem->pfn_first +
+			   (resource_size(devmem->resource) >> PAGE_SHIFT);
+
+	ret = hmm_devmem_pages_create(devmem);
+	if (ret)
+		goto error_devm_add_action;
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
+error_devm_add_action:
+	hmm_devmem_ref_kill(&devmem->ref);
+	hmm_devmem_ref_exit(&devmem->ref);
+error_percpu_ref:
+	devres_free(devmem);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(hmm_devmem_add_resource);
+
 /*
  * hmm_devmem_remove() - remove device memory (kill and free ZONE_DEVICE)
  *
@@ -1097,6 +1172,7 @@ void hmm_devmem_remove(struct hmm_devmem
 {
 	resource_size_t start, size;
 	struct device *device;
+	bool cdm = false;
 
 	if (!devmem)
 		return;
@@ -1105,11 +1181,13 @@ void hmm_devmem_remove(struct hmm_devmem
 	start = devmem->resource->start;
 	size = resource_size(devmem->resource);
 
+	cdm = devmem->resource->desc == IORES_DESC_DEVICE_PUBLIC_MEMORY;
 	hmm_devmem_ref_kill(&devmem->ref);
 	hmm_devmem_ref_exit(&devmem->ref);
 	hmm_devmem_pages_remove(devmem);
 
-	devm_release_mem_region(device, start, size);
+	if (!cdm)
+		devm_release_mem_region(device, start, size);
 }
 EXPORT_SYMBOL(hmm_devmem_remove);
 
_

Patches currently in -mm which might be from jglisse@redhat.com are

hmm-heterogeneous-memory-management-documentation-v3.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short-v5.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v4.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-v5.patch
mm-zone_device-special-case-put_page-for-device-private-pages-v4.patch
mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch
mm-memcontrol-support-memory_device_private-v4.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device-v7.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3.patch
mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v5.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-migrate-support-un-addressable-zone_device-page-in-migration-v3.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch
mm-device-public-memory-device-memory-cache-coherent-with-cpu-v5.patch
mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch
lib-interval_tree-fast-overlap-detection-fix.patch

