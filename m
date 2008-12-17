From: akpm@linux-foundation.org
Subject: - pci-uninline-pci_ioremap_bar.patch removed from -mm tree
Date: Wed, 17 Dec 2008 12:48:34 -0800
Message-ID: <200812172048.mBHKmY0E006890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbYLQUtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 15:49:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@linux.intel.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci: uninline pci_ioremap_bar()
has been removed from the -mm tree.  Its filename was
     pci-uninline-pci_ioremap_bar.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: uninline pci_ioremap_bar()
From: Andrew Morton <akpm@linux-foundation.org>

It's too large to be inlined.

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c   |   16 ++++++++++++++++
 include/linux/pci.h |   15 +--------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff -puN drivers/pci/pci.c~pci-uninline-pci_ioremap_bar drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-uninline-pci_ioremap_bar
+++ a/drivers/pci/pci.c
@@ -56,6 +56,22 @@ unsigned char pci_bus_max_busnr(struct p
 }
 EXPORT_SYMBOL_GPL(pci_bus_max_busnr);
 
+#ifdef CONFIG_HAS_IOMEM
+void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
+{
+	/*
+	 * Make sure the BAR is actually a memory resource, not an IO resource
+	 */
+	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
+		WARN_ON(1);
+		return NULL;
+	}
+	return ioremap_nocache(pci_resource_start(pdev, bar),
+				     pci_resource_len(pdev, bar));
+}
+EXPORT_SYMBOL_GPL(pci_ioremap_bar);
+#endif
+
 #if 0
 /**
  * pci_max_busnr - returns maximum PCI bus number
diff -puN include/linux/pci.h~pci-uninline-pci_ioremap_bar include/linux/pci.h
--- a/include/linux/pci.h~pci-uninline-pci_ioremap_bar
+++ a/include/linux/pci.h
@@ -1156,20 +1156,7 @@ static inline void pci_mmcfg_late_init(v
 
 int pci_ext_cfg_avail(struct pci_dev *dev);
 
-#ifdef CONFIG_HAS_IOMEM
-static inline void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
-{
-	/*
-	 * Make sure the BAR is actually a memory resource, not an IO resource
-	 */
-	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
-		WARN_ON(1);
-		return NULL;
-	}
-	return ioremap_nocache(pci_resource_start(pdev, bar),
-				     pci_resource_len(pdev, bar));
-}
-#endif
+void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar);
 
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-hrtimerc-kill-warning.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
edac-x38-use-the-architectures-readq-function-fix-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

