From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 26 Apr 2016 12:48:06 -0700
Message-ID: <571fc5f6.8HiK8Ye5BzMsLKRO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbcDZTsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2016 15:48:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_ringbuffer.c |    3 -
 drivers/iommu/amd_iommu.c               |   13 -------
 drivers/usb/dwc3/debugfs.c              |   37 ----------------------
 3 files changed, 53 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_ringbuffer.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_ringbuffer.c
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -2101,10 +2101,7 @@ int intel_pin_and_map_ringbuffer_obj(str
 	struct drm_i915_gem_object *obj = ringbuf->obj;
 	/* Ring wraparound at offset 0 sometimes hangs. No idea why. */
 	unsigned flags = PIN_OFFSET_BIAS | 4096;
-<<<<<<< HEAD
-=======
 	void *addr;
->>>>>>> linux-next/akpm-base
 	int ret;
 
 	if (HAS_LLC(dev_priv) && !obj->stolen) {
diff -puN drivers/iommu/amd_iommu.c~linux-next-git-rejects drivers/iommu/amd_iommu.c
--- a/drivers/iommu/amd_iommu.c~linux-next-git-rejects
+++ a/drivers/iommu/amd_iommu.c
@@ -279,10 +279,7 @@ static u16 get_alias(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	u16 devid, ivrs_alias, pci_alias;
 
-<<<<<<< HEAD
-=======
 	/* The callers make sure that get_device_id() does not fail here */
->>>>>>> linux-next/akpm-base
 	devid = get_device_id(dev);
 	ivrs_alias = amd_iommu_alias_table[devid];
 	pci_for_each_dma_alias(pdev, __last_alias, &pci_alias);
@@ -347,8 +344,6 @@ static struct iommu_dev_data *find_dev_d
 }
 
 static struct iommu_dev_data *get_dev_data(struct device *dev)
-<<<<<<< HEAD
-=======
 {
 	return dev->archdata.iommu;
 }
@@ -357,7 +352,6 @@ static struct iommu_dev_data *get_dev_da
 * Find or create an IOMMU group for a acpihid device.
 */
 static struct iommu_group *acpihid_device_group(struct device *dev)
->>>>>>> linux-next/akpm-base
 {
 	struct acpihid_map_entry *p, *entry = NULL;
 	int devid;
@@ -505,11 +499,7 @@ static int iommu_init_device(struct devi
 
 	dev_data->alias = get_alias(dev);
 
-<<<<<<< HEAD
-	if (pci_iommuv2_capable(pdev)) {
-=======
 	if (dev_is_pci(dev) && pci_iommuv2_capable(to_pci_dev(dev))) {
->>>>>>> linux-next/akpm-base
 		struct amd_iommu *iommu;
 
 		iommu = amd_iommu_rlookup_table[dev_data->devid];
@@ -530,12 +520,9 @@ static void iommu_ignore_device(struct d
 	int devid;
 
 	devid = get_device_id(dev);
-<<<<<<< HEAD
-=======
 	if (devid < 0)
 		return;
 
->>>>>>> linux-next/akpm-base
 	alias = get_alias(dev);
 
 	memset(&amd_iommu_dev_table[devid], 0, sizeof(struct dev_table_entry));
diff -puN drivers/usb/dwc3/debugfs.c~linux-next-git-rejects drivers/usb/dwc3/debugfs.c
--- a/drivers/usb/dwc3/debugfs.c~linux-next-git-rejects
+++ a/drivers/usb/dwc3/debugfs.c
@@ -942,62 +942,25 @@ void dwc3_debugfs_init(struct dwc3 *dwc)
 	dwc->regset->base = dwc->regs;
 
 	file = debugfs_create_regset32("regdump", S_IRUGO, root, dwc->regset);
-<<<<<<< HEAD
-	if (!file) {
-		ret = -ENOMEM;
-		goto err2;
-	}
-=======
 	if (!file)
 		dev_dbg(dwc->dev, "Can't create debugfs regdump\n");
->>>>>>> linux-next/akpm-base
 
 	if (IS_ENABLED(CONFIG_USB_DWC3_DUAL_ROLE)) {
 		file = debugfs_create_file("mode", S_IRUGO | S_IWUSR, root,
 				dwc, &dwc3_mode_fops);
-<<<<<<< HEAD
-		if (!file) {
-			ret = -ENOMEM;
-			goto err2;
-		}
-=======
 		if (!file)
 			dev_dbg(dwc->dev, "Can't create debugfs mode\n");
->>>>>>> linux-next/akpm-base
 	}
 
 	if (IS_ENABLED(CONFIG_USB_DWC3_DUAL_ROLE) ||
 			IS_ENABLED(CONFIG_USB_DWC3_GADGET)) {
 		file = debugfs_create_file("testmode", S_IRUGO | S_IWUSR, root,
 				dwc, &dwc3_testmode_fops);
-<<<<<<< HEAD
-		if (!file) {
-			ret = -ENOMEM;
-			goto err2;
-		}
-
-		file = debugfs_create_file("link_state", S_IRUGO | S_IWUSR, root,
-				dwc, &dwc3_link_state_fops);
-		if (!file) {
-			ret = -ENOMEM;
-			goto err2;
-		}
-	}
-
-	return 0;
-
-err2:
-	kfree(dwc->regset);
-
-err1:
-	debugfs_remove_recursive(root);
-=======
 
 		file = debugfs_create_file("link_state", S_IRUGO | S_IWUSR,
 				root, dwc, &dwc3_link_state_fops);
 		if (!file)
 			dev_dbg(dwc->dev, "Can't create debugfs link_state\n");
->>>>>>> linux-next/akpm-base
 
 		dwc3_debugfs_create_endpoint_dirs(dwc, root);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-kasan-initial-memory-quarantine-implementation-v8-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

