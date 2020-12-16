Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F29F0C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B73C233EB
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgLPRHj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgLPRHi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:07:38 -0500
Date:   Wed, 16 Dec 2020 09:06:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138416;
        bh=kOaD6hEIouv8mRQtY1YBlhpKliyJ6SbXP4SQXYPaJP8=;
        h=From:To:Subject:From;
        b=oULV5P4u1Q2N0g2DTwokSviOVApHpLrXvDxioV9C7iTwhShAlWuvWe02LYop+6Qe3
         jMOuvw1lgHs14K1mePF2wHM+SwNf0LlyBrWZvvgFbgI+jbdH8yMEu7q6Bnp8uBq7nj
         AWamv6F0Ob7TyWeIkxXk08gvQL4Z172WlX5Tlc7U=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20201216170655.lqNTLFw0S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    7 
 arch/microblaze/include/asm/mmu_context.h      |    6 
 arch/riscv/Kconfig                             |    3 
 drivers/infiniband/hw/mlx5/main.c              |   46 --
 drivers/input/misc/da7280.c                    |    3 
 drivers/misc/lkdtm/Makefile                    |    4 
 drivers/misc/lkdtm/lkdtm.h                     |    5 
 drivers/usb/cdns3/core.c                       |   70 ---
 drivers/usb/cdns3/core.h                       |    6 
 drivers/usb/cdns3/gadget-export.h              |    8 
 drivers/usb/cdns3/host-export.h                |   16 
 drivers/usb/cdns3/host.c                       |   22 -
 fs/btrfs/btrfs_inode.h                         |    3 
 fs/btrfs/ctree.h                               |    3 
 fs/btrfs/transaction.c                         |    4 
 fs/btrfs/zoned.c                               |   12 
 fs/file.c                                      |   32 -
 fs/nfsd/nfs4xdr.c                              |  329 ---------------
 include/linux/memcontrol.h                     |   34 -
 include/linux/sunrpc/xdr.h                     |   10 
 kernel/bpf/task_iter.c                         |    4 
 lib/Makefile                                   |    4 
 mm/vmscan.c                                    |    3 
 tools/power/cpupower/utils/helpers/misc.c      |    3 
 tools/testing/selftests/lkdtm/tests.txt        |    4 
 25 files changed, 641 deletions(-)

--- a/arch/microblaze/include/asm/mmu_context.h~linux-next-git-rejects
+++ a/arch/microblaze/include/asm/mmu_context.h
@@ -1,8 +1,2 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 # include <asm/mmu_context_mm.h>
-<<<<<<< HEAD
-#else
-# include <asm-generic/nommu_context.h>
-#endif
-=======
->>>>>>> linux-next/akpm-base
--- a/arch/riscv/Kconfig~linux-next-git-rejects
+++ a/arch/riscv/Kconfig
@@ -14,10 +14,7 @@ config RISCV
 	def_bool y
 	select ARCH_CLOCKSOURCE_INIT
 	select ARCH_SUPPORTS_ATOMIC_RMW
-<<<<<<< HEAD
-=======
 	select ARCH_STACKWALK
->>>>>>> linux-next/akpm-base
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC if MMU
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_DEBUG_VM_PGTABLE
--- a/Documentation/admin-guide/cgroup-v1/memory.rst~linux-next-git-rejects
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -672,17 +672,10 @@ In the diagram above, with hierarchical
 usage of e, is accounted to its ancestors up until the root (i.e, c and root).
 If one of the ancestors goes over its limit, the reclaim algorithm reclaims
 from the tasks in the ancestor and the children of the ancestor.
-<<<<<<< HEAD
 
 6.1 Hierarchical accounting and reclaim
 ---------------------------------------
 
-=======
-
-6.1 Hierarchical accounting and reclaim
----------------------------------------
-
->>>>>>> linux-next/akpm-base
 Hierarchical accounting is enabled by default. Disabling the hierarchical
 accounting is deprecated. An attempt to do it will result in a failure
 and a warning printed to dmesg.
--- a/drivers/infiniband/hw/mlx5/main.c~linux-next-git-rejects
+++ a/drivers/infiniband/hw/mlx5/main.c
@@ -4741,7 +4741,6 @@ static int mlx5r_mp_probe(struct auxilia
 
 	dev_set_drvdata(&adev->dev, mpi);
 	return 0;
-<<<<<<< HEAD
 }
 
 static void mlx5r_mp_remove(struct auxiliary_device *adev)
@@ -4760,26 +4759,6 @@ static void mlx5r_mp_remove(struct auxil
 static int mlx5r_probe(struct auxiliary_device *adev,
 		       const struct auxiliary_device_id *id)
 {
-=======
-}
-
-static void mlx5r_mp_remove(struct auxiliary_device *adev)
-{
-	struct mlx5_ib_multiport_info *mpi;
-
-	mpi = dev_get_drvdata(&adev->dev);
-	mutex_lock(&mlx5_ib_multiport_mutex);
-	if (mpi->ibdev)
-		mlx5_ib_unbind_slave_port(mpi->ibdev, mpi);
-	list_del(&mpi->list);
-	mutex_unlock(&mlx5_ib_multiport_mutex);
-	kfree(mpi);
-}
-
-static int mlx5r_probe(struct auxiliary_device *adev,
-		       const struct auxiliary_device_id *id)
-{
->>>>>>> linux-next/akpm-base
 	struct mlx5_adev *idev = container_of(adev, struct mlx5_adev, adev);
 	struct mlx5_core_dev *mdev = idev->mdev;
 	const struct mlx5_ib_profile *profile;
@@ -4832,31 +4811,6 @@ static void mlx5r_remove(struct auxiliar
 static const struct auxiliary_device_id mlx5r_mp_id_table[] = {
 	{ .name = MLX5_ADEV_NAME ".multiport", },
 	{},
-<<<<<<< HEAD
-};
-
-static const struct auxiliary_device_id mlx5r_id_table[] = {
-	{ .name = MLX5_ADEV_NAME ".rdma", },
-	{},
-};
-
-MODULE_DEVICE_TABLE(auxiliary, mlx5r_mp_id_table);
-MODULE_DEVICE_TABLE(auxiliary, mlx5r_id_table);
-
-static struct auxiliary_driver mlx5r_mp_driver = {
-	.name = "multiport",
-	.probe = mlx5r_mp_probe,
-	.remove = mlx5r_mp_remove,
-	.id_table = mlx5r_mp_id_table,
-};
-
-static struct auxiliary_driver mlx5r_driver = {
-	.name = "rdma",
-	.probe = mlx5r_probe,
-	.remove = mlx5r_remove,
-	.id_table = mlx5r_id_table,
-=======
->>>>>>> linux-next/akpm-base
 };
 
 static const struct auxiliary_device_id mlx5r_id_table[] = {
--- a/drivers/input/misc/da7280.c~linux-next-git-rejects
+++ a/drivers/input/misc/da7280.c
@@ -863,10 +863,7 @@ static void da7280_parse_properties(stru
 		gpi_str3[7] = '0' + i;
 		haptics->gpi_ctl[i].polarity = 0;
 		error = device_property_read_string(dev, gpi_str3, &str);
-<<<<<<< HEAD
-=======
 		if (!error)
->>>>>>> linux-next/akpm-base
 			haptics->gpi_ctl[i].polarity =
 				da7280_haptic_of_gpi_pol_str(dev, str);
 	}
--- a/drivers/misc/lkdtm/lkdtm.h~linux-next-git-rejects
+++ a/drivers/misc/lkdtm/lkdtm.h
@@ -104,12 +104,7 @@ void lkdtm_STACKLEAK_ERASING(void);
 /* cfi.c */
 void lkdtm_CFI_FORWARD_PROTO(void);
 
-<<<<<<< HEAD
-/* fortify.c */
-void lkdtm_FORTIFIED_STRSCPY(void);
-=======
 /* powerpc.c */
 void lkdtm_PPC_SLB_MULTIHIT(void);
->>>>>>> linux-next/akpm-base
 
 #endif
--- a/drivers/misc/lkdtm/Makefile~linux-next-git-rejects
+++ a/drivers/misc/lkdtm/Makefile
@@ -10,11 +10,7 @@ lkdtm-$(CONFIG_LKDTM)		+= rodata_objcopy
 lkdtm-$(CONFIG_LKDTM)		+= usercopy.o
 lkdtm-$(CONFIG_LKDTM)		+= stackleak.o
 lkdtm-$(CONFIG_LKDTM)		+= cfi.o
-<<<<<<< HEAD
-lkdtm-$(CONFIG_LKDTM)		+= fortify.o
-=======
 lkdtm-$(CONFIG_PPC_BOOK3S_64)	+= powerpc.o
->>>>>>> linux-next/akpm-base
 
 KASAN_SANITIZE_rodata.o		:= n
 KASAN_SANITIZE_stackleak.o	:= n
--- a/drivers/usb/cdns3/core.c~linux-next-git-rejects
+++ a/drivers/usb/cdns3/core.c
@@ -435,68 +435,6 @@ int cdns_init(struct cdns *cdns)
 		return ret;
 	}
 
-<<<<<<< HEAD
-	cdns = devm_kzalloc(dev, sizeof(*cdns), GFP_KERNEL);
-	if (!cdns)
-		return -ENOMEM;
-
-	cdns->dev = dev;
-	cdns->pdata = dev_get_platdata(dev);
-
-	platform_set_drvdata(pdev, cdns);
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "host");
-	if (!res) {
-		dev_err(dev, "missing host IRQ\n");
-		return -ENODEV;
-	}
-
-	cdns->xhci_res[0] = *res;
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "xhci");
-	if (!res) {
-		dev_err(dev, "couldn't get xhci resource\n");
-		return -ENXIO;
-	}
-
-	cdns->xhci_res[1] = *res;
-
-	cdns->dev_irq = platform_get_irq_byname(pdev, "peripheral");
-	if (cdns->dev_irq < 0)
-		return cdns->dev_irq;
-
-	regs = devm_platform_ioremap_resource_byname(pdev, "dev");
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
-	cdns->dev_regs	= regs;
-
-	cdns->otg_irq = platform_get_irq_byname(pdev, "otg");
-	if (cdns->otg_irq < 0)
-		return cdns->otg_irq;
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "otg");
-	if (!res) {
-		dev_err(dev, "couldn't get otg resource\n");
-		return -ENXIO;
-	}
-
-	cdns->phyrst_a_enable = device_property_read_bool(dev, "cdns,phyrst-a-enable");
-
-	cdns->otg_res = *res;
-
-	cdns->wakeup_irq = platform_get_irq_byname_optional(pdev, "wakeup");
-	if (cdns->wakeup_irq == -EPROBE_DEFER)
-		return cdns->wakeup_irq;
-	else if (cdns->wakeup_irq == 0)
-		return -EINVAL;
-
-	if (cdns->wakeup_irq < 0) {
-		dev_dbg(dev, "couldn't get wakeup irq\n");
-		cdns->wakeup_irq = 0x0;
-	}
-
-=======
->>>>>>> linux-next/akpm-base
 	mutex_init(&cdns->mutex);
 
 	if (device_property_read_bool(dev, "usb-role-switch")) {
@@ -536,14 +474,6 @@ int cdns_init(struct cdns *cdns)
 		goto init_failed;
 
 	spin_lock_init(&cdns->lock);
-<<<<<<< HEAD
-	device_set_wakeup_capable(dev, true);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
-	if (!(cdns->pdata && (cdns->pdata->quirks & CDNS3_DEFAULT_PM_RUNTIME_ALLOW)))
-		pm_runtime_forbid(dev);
-=======
->>>>>>> linux-next/akpm-base
 
 	dev_dbg(dev, "Cadence USB3 core: probe succeed\n");
 
--- a/drivers/usb/cdns3/core.h~linux-next-git-rejects
+++ a/drivers/usb/cdns3/core.h
@@ -78,10 +78,7 @@ struct cdns3_platform_data {
  * @pdata: platform data from glue layer
  * @lock: spinlock structure
  * @xhci_plat_data: xhci private data structure pointer
-<<<<<<< HEAD
-=======
  * @gadget_init: pointer to gadget initialization function
->>>>>>> linux-next/akpm-base
  */
 struct cdns {
 	struct device			*dev;
@@ -119,11 +116,8 @@ struct cdns {
 	struct cdns3_platform_data	*pdata;
 	spinlock_t			lock;
 	struct xhci_plat_priv		*xhci_plat_data;
-<<<<<<< HEAD
-=======
 
 	int (*gadget_init)(struct cdns *cdns);
->>>>>>> linux-next/akpm-base
 };
 
 int cdns_hw_role_switch(struct cdns *cdns);
--- a/drivers/usb/cdns3/gadget-export.h~linux-next-git-rejects
+++ a/drivers/usb/cdns3/gadget-export.h
@@ -12,11 +12,7 @@
 
 #if IS_ENABLED(CONFIG_USB_CDNSP_GADGET)
 
-<<<<<<< HEAD
-int cdns3_gadget_init(struct cdns3 *cdns);
-=======
 int cdnsp_gadget_init(struct cdns *cdns);
->>>>>>> linux-next/akpm-base
 #else
 
 static inline int cdnsp_gadget_init(struct cdns *cdns)
@@ -24,9 +20,6 @@ static inline int cdnsp_gadget_init(stru
 	return -ENXIO;
 }
 
-<<<<<<< HEAD
-#endif
-=======
 #endif /* CONFIG_USB_CDNSP_GADGET */
 
 #if IS_ENABLED(CONFIG_USB_CDNS3_GADGET)
@@ -40,6 +33,5 @@ static inline int cdns3_gadget_init(stru
 }
 
 #endif /* CONFIG_USB_CDNS3_GADGET */
->>>>>>> linux-next/akpm-base
 
 #endif /* __LINUX_CDNS3_GADGET_EXPORT */
--- a/drivers/usb/cdns3/host.c~linux-next-git-rejects
+++ a/drivers/usb/cdns3/host.c
@@ -16,20 +16,6 @@
 #include <linux/usb/hcd.h>
 #include "../host/xhci.h"
 #include "../host/xhci-plat.h"
-<<<<<<< HEAD
-
-#define XECP_PORT_CAP_REG	0x8000
-#define XECP_AUX_CTRL_REG1	0x8120
-
-#define CFG_RXDET_P3_EN		BIT(15)
-#define LPM_2_STB_SWITCH_EN	BIT(25)
-
-static const struct xhci_plat_priv xhci_plat_cdns3_xhci = {
-	.quirks = XHCI_SKIP_PHY_INIT | XHCI_AVOID_BEI,
-	.suspend_quirk = xhci_cdns3_suspend_quirk,
-};
-=======
->>>>>>> linux-next/akpm-base
 
 #define XECP_PORT_CAP_REG	0x8000
 #define XECP_AUX_CTRL_REG1	0x8120
@@ -103,11 +89,7 @@ err1:
 	return ret;
 }
 
-<<<<<<< HEAD
-int xhci_cdns3_suspend_quirk(struct usb_hcd *hcd)
-=======
 static int xhci_cdns3_suspend_quirk(struct usb_hcd *hcd)
->>>>>>> linux-next/akpm-base
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	u32 value;
@@ -133,11 +115,7 @@ static int xhci_cdns3_suspend_quirk(stru
 	return 0;
 }
 
-<<<<<<< HEAD
-static void cdns3_host_exit(struct cdns3 *cdns)
-=======
 static void cdns_host_exit(struct cdns *cdns)
->>>>>>> linux-next/akpm-base
 {
 	kfree(cdns->xhci_plat_data);
 	platform_device_unregister(cdns->host_dev);
--- a/drivers/usb/cdns3/host-export.h~linux-next-git-rejects
+++ a/drivers/usb/cdns3/host-export.h
@@ -9,17 +9,9 @@
 #ifndef __LINUX_CDNS3_HOST_EXPORT
 #define __LINUX_CDNS3_HOST_EXPORT
 
-<<<<<<< HEAD
-struct usb_hcd;
-#ifdef CONFIG_USB_CDNS3_HOST
-
-int cdns3_host_init(struct cdns3 *cdns);
-int xhci_cdns3_suspend_quirk(struct usb_hcd *hcd);
-=======
 #if IS_ENABLED(CONFIG_USB_CDNS_HOST)
 
 int cdns_host_init(struct cdns *cdns);
->>>>>>> linux-next/akpm-base
 
 #else
 
@@ -28,15 +20,7 @@ static inline int cdns_host_init(struct
 	return -ENXIO;
 }
 
-<<<<<<< HEAD
-static inline void cdns3_host_exit(struct cdns3 *cdns) { }
-static inline int xhci_cdns3_suspend_quirk(struct usb_hcd *hcd)
-{
-	return 0;
-}
-=======
 static inline void cdns_host_exit(struct cdns *cdns) { }
->>>>>>> linux-next/akpm-base
 
 #endif /* USB_CDNS_HOST */
 
--- a/fs/btrfs/btrfs_inode.h~linux-next-git-rejects
+++ a/fs/btrfs/btrfs_inode.h
@@ -42,8 +42,6 @@ enum {
 	 * to an inode.
 	 */
 	BTRFS_INODE_NO_XATTRS,
-<<<<<<< HEAD
-=======
 	/*
 	 * Set when we are in a context where we need to start a transaction and
 	 * have dirty pages with the respective file range locked. This is to
@@ -53,7 +51,6 @@ enum {
 	 * the file range, inode's io_tree).
 	 */
 	BTRFS_INODE_NO_DELALLOC_FLUSH,
->>>>>>> linux-next/akpm-base
 };
 
 /* in memory btrfs inode */
--- a/fs/btrfs/ctree.h~linux-next-git-rejects
+++ a/fs/btrfs/ctree.h
@@ -367,15 +367,12 @@ struct btrfs_path {
 	unsigned int search_commit_root:1;
 	unsigned int need_commit_sem:1;
 	unsigned int skip_release_on_error:1;
-<<<<<<< HEAD
-=======
 	/*
 	 * Indicate that new item (btrfs_search_slot) is extending already
 	 * existing item and ins_len contains only the data size and not item
 	 * header (ie. sizeof(struct btrfs_item) is not included).
 	 */
 	unsigned int search_for_extension:1;
->>>>>>> linux-next/akpm-base
 };
 #define BTRFS_MAX_EXTENT_ITEM_SIZE(r) ((BTRFS_LEAF_DATA_SIZE(r->fs_info) >> 4) - \
 					sizeof(struct btrfs_item))
--- a/fs/btrfs/transaction.c~linux-next-git-rejects
+++ a/fs/btrfs/transaction.c
@@ -910,12 +910,8 @@ bool btrfs_should_end_transaction(struct
 	struct btrfs_transaction *cur_trans = trans->transaction;
 
 	if (cur_trans->state >= TRANS_STATE_COMMIT_START ||
-<<<<<<< HEAD
-	    cur_trans->delayed_refs.flushing)
-=======
 	    test_bit(BTRFS_DELAYED_REFS_FLUSHING,
 		     &cur_trans->delayed_refs.flags))
->>>>>>> linux-next/akpm-base
 		return true;
 
 	return should_end_transaction(trans);
--- a/fs/btrfs/zoned.c~linux-next-git-rejects
+++ a/fs/btrfs/zoned.c
@@ -165,11 +165,7 @@ int btrfs_get_dev_zone_info(struct btrfs
 	if (!zone_info)
 		return -ENOMEM;
 
-<<<<<<< HEAD
-	nr_sectors = bdev->bd_part->nr_sects;
-=======
 	nr_sectors = bdev_nr_sectors(bdev);
->>>>>>> linux-next/akpm-base
 	zone_sectors = bdev_zone_sectors(bdev);
 	/* Check if it's power of 2 (see is_power_of_2) */
 	ASSERT(zone_sectors != 0 && (zone_sectors & (zone_sectors - 1)) == 0);
@@ -509,11 +505,7 @@ int btrfs_sb_log_location_bdev(struct bl
 		return -EINVAL;
 	zone_size = zone_sectors << SECTOR_SHIFT;
 	zone_sectors_shift = ilog2(zone_sectors);
-<<<<<<< HEAD
-	nr_sectors = bdev->bd_part->nr_sects;
-=======
 	nr_sectors = bdev_nr_sectors(bdev);
->>>>>>> linux-next/akpm-base
 	nr_zones = nr_sectors >> zone_sectors_shift;
 
 	sb_zone = sb_zone_number(zone_sectors_shift + SECTOR_SHIFT, mirror);
@@ -611,11 +603,7 @@ int btrfs_reset_sb_log_zones(struct bloc
 
 	zone_sectors = bdev_zone_sectors(bdev);
 	zone_sectors_shift = ilog2(zone_sectors);
-<<<<<<< HEAD
-	nr_sectors = bdev->bd_part->nr_sects;
-=======
 	nr_sectors = bdev_nr_sectors(bdev);
->>>>>>> linux-next/akpm-base
 	nr_zones = nr_sectors >> zone_sectors_shift;
 
 	sb_zone = sb_zone_number(zone_sectors_shift + SECTOR_SHIFT, mirror);
--- a/fs/file.c~linux-next-git-rejects
+++ a/fs/file.c
@@ -628,38 +628,6 @@ int close_fd(unsigned fd)
 	return filp_close(file, files);
 }
 EXPORT_SYMBOL(close_fd); /* for ksys_close() */
-<<<<<<< HEAD
-
-static inline void __range_cloexec(struct files_struct *cur_fds,
-				   unsigned int fd, unsigned int max_fd)
-{
-	struct fdtable *fdt;
-
-	if (fd > max_fd)
-		return;
-
-	spin_lock(&cur_fds->file_lock);
-	fdt = files_fdtable(cur_fds);
-	bitmap_set(fdt->close_on_exec, fd, max_fd - fd + 1);
-	spin_unlock(&cur_fds->file_lock);
-}
-
-static inline void __range_close(struct files_struct *cur_fds, unsigned int fd,
-				 unsigned int max_fd)
-{
-	while (fd <= max_fd) {
-		struct file *file;
-
-		file = pick_file(cur_fds, fd++);
-		if (!file)
-			continue;
-
-		filp_close(file, cur_fds);
-		cond_resched();
-	}
-}
-=======
->>>>>>> linux-next/akpm-base
 
 /**
  * __close_range() - Close all file descriptors in a given range.
--- a/fs/nfsd/nfs4xdr.c~linux-next-git-rejects
+++ a/fs/nfsd/nfs4xdr.c
@@ -845,7 +845,6 @@ nfsd4_decode_link(struct nfsd4_compounda
 {
 	return nfsd4_decode_component4(argp, &link->li_name, &link->li_namelen);
 }
-<<<<<<< HEAD
 
 static __be32
 nfsd4_decode_open_to_lock_owner4(struct nfsd4_compoundargs *argp,
@@ -876,38 +875,6 @@ nfsd4_decode_exist_lock_owner4(struct nf
 	if (xdr_stream_decode_u32(argp->xdr, &lock->lk_old_lock_seqid) < 0)
 		return nfserr_bad_xdr;
 
-=======
-
-static __be32
-nfsd4_decode_open_to_lock_owner4(struct nfsd4_compoundargs *argp,
-				 struct nfsd4_lock *lock)
-{
-	__be32 status;
-
-	if (xdr_stream_decode_u32(argp->xdr, &lock->lk_new_open_seqid) < 0)
-		return nfserr_bad_xdr;
-	status = nfsd4_decode_stateid4(argp, &lock->lk_new_open_stateid);
-	if (status)
-		return status;
-	if (xdr_stream_decode_u32(argp->xdr, &lock->lk_new_lock_seqid) < 0)
-		return nfserr_bad_xdr;
-	return nfsd4_decode_state_owner4(argp, &lock->lk_new_clientid,
-					 &lock->lk_new_owner);
-}
-
-static __be32
-nfsd4_decode_exist_lock_owner4(struct nfsd4_compoundargs *argp,
-			       struct nfsd4_lock *lock)
-{
-	__be32 status;
-
-	status = nfsd4_decode_stateid4(argp, &lock->lk_old_lock_stateid);
-	if (status)
-		return status;
-	if (xdr_stream_decode_u32(argp->xdr, &lock->lk_old_lock_seqid) < 0)
-		return nfserr_bad_xdr;
-
->>>>>>> linux-next/akpm-base
 	return nfs_ok;
 }
 
@@ -1018,32 +985,6 @@ nfsd4_decode_createhow4(struct nfsd4_com
 	default:
 		return nfserr_bad_xdr;
 	}
-<<<<<<< HEAD
-
-	return nfs_ok;
-}
-
-static __be32
-nfsd4_decode_openflag4(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
-{
-	__be32 status;
-
-	if (xdr_stream_decode_u32(argp->xdr, &open->op_create) < 0)
-		return nfserr_bad_xdr;
-	switch (open->op_create) {
-	case NFS4_OPEN_NOCREATE:
-		break;
-	case NFS4_OPEN_CREATE:
-		status = nfsd4_decode_createhow4(argp, open);
-		if (status)
-			return status;
-		break;
-	default:
-		return nfserr_bad_xdr;
-	}
-
-	return nfs_ok;
-=======
 
 	return nfs_ok;
 }
@@ -1068,7 +1009,6 @@ nfsd4_decode_openflag4(struct nfsd4_comp
 	}
 
 	return nfs_ok;
->>>>>>> linux-next/akpm-base
 }
 
 static __be32 nfsd4_decode_share_access(struct nfsd4_compoundargs *argp, u32 *share_access, u32 *deleg_want, u32 *deleg_when)
@@ -1372,15 +1312,9 @@ nfsd4_decode_setclientid(struct nfsd4_co
 	if (status)
 		return status;
 	if (xdr_stream_decode_u32(argp->xdr, &setclientid->se_callback_prog) < 0)
-<<<<<<< HEAD
 		return nfserr_bad_xdr;
 	if (xdr_stream_decode_u32(argp->xdr, &setclientid->se_callback_netid_len) < 0)
 		return nfserr_bad_xdr;
-=======
-		return nfserr_bad_xdr;
-	if (xdr_stream_decode_u32(argp->xdr, &setclientid->se_callback_netid_len) < 0)
-		return nfserr_bad_xdr;
->>>>>>> linux-next/akpm-base
 	p = xdr_inline_decode(argp->xdr, setclientid->se_callback_netid_len);
 	if (!p)
 		return nfserr_bad_xdr;
@@ -1488,28 +1422,6 @@ nfsd4_decode_release_lockowner(struct nf
 		return nfserr_inval;
 
 	return nfs_ok;
-<<<<<<< HEAD
-}
-
-static __be32 nfsd4_decode_backchannel_ctl(struct nfsd4_compoundargs *argp, struct nfsd4_backchannel_ctl *bc)
-{
-	if (xdr_stream_decode_u32(argp->xdr, &bc->bc_cb_program) < 0)
-		return nfserr_bad_xdr;
-	return nfsd4_decode_cb_sec(argp, &bc->bc_cb_sec);
-}
-
-static __be32 nfsd4_decode_bind_conn_to_session(struct nfsd4_compoundargs *argp, struct nfsd4_bind_conn_to_session *bcts)
-{
-	u32 use_conn_in_rdma_mode;
-	__be32 status;
-
-	status = nfsd4_decode_sessionid4(argp, &bcts->sessionid);
-	if (status)
-		return status;
-	if (xdr_stream_decode_u32(argp->xdr, &bcts->dir) < 0)
-		return nfserr_bad_xdr;
-	if (xdr_stream_decode_u32(argp->xdr, &use_conn_in_rdma_mode) < 0)
-=======
 }
 
 static __be32 nfsd4_decode_backchannel_ctl(struct nfsd4_compoundargs *argp, struct nfsd4_backchannel_ctl *bc)
@@ -1590,136 +1502,12 @@ nfsd4_decode_ssv_sp_parms(struct nfsd4_c
 	if (xdr_stream_decode_u32(argp->xdr, &window) < 0)
 		return nfserr_bad_xdr;
 	if (xdr_stream_decode_u32(argp->xdr, &num_gss_handles) < 0)
->>>>>>> linux-next/akpm-base
-		return nfserr_bad_xdr;
-
-	return nfs_ok;
-}
-
-static __be32
-<<<<<<< HEAD
-nfsd4_decode_state_protect_ops(struct nfsd4_compoundargs *argp,
-			       struct nfsd4_exchange_id *exid)
-{
-	__be32 status;
-
-	status = nfsd4_decode_bitmap4(argp, exid->spo_must_enforce,
-				      ARRAY_SIZE(exid->spo_must_enforce));
-	if (status)
-		return nfserr_bad_xdr;
-	status = nfsd4_decode_bitmap4(argp, exid->spo_must_allow,
-				      ARRAY_SIZE(exid->spo_must_allow));
-	if (status)
-		return nfserr_bad_xdr;
-=======
-nfsd4_decode_state_protect4_a(struct nfsd4_compoundargs *argp,
-			      struct nfsd4_exchange_id *exid)
-{
-	__be32 status;
-
-	if (xdr_stream_decode_u32(argp->xdr, &exid->spa_how) < 0)
-		return nfserr_bad_xdr;
-	switch (exid->spa_how) {
-	case SP4_NONE:
-		break;
-	case SP4_MACH_CRED:
-		status = nfsd4_decode_state_protect_ops(argp, exid);
-		if (status)
-			return status;
-		break;
-	case SP4_SSV:
-		status = nfsd4_decode_ssv_sp_parms(argp, exid);
-		if (status)
-			return status;
-		break;
-	default:
-		return nfserr_bad_xdr;
-	}
->>>>>>> linux-next/akpm-base
-
-	return nfs_ok;
-}
-
-<<<<<<< HEAD
-/*
- * This implementation currently does not support SP4_SSV.
- * This decoder simply skips over these arguments.
- */
-static noinline __be32
-nfsd4_decode_ssv_sp_parms(struct nfsd4_compoundargs *argp,
-			  struct nfsd4_exchange_id *exid)
-{
-	u32 count, window, num_gss_handles;
-	__be32 status;
-
-	/* ssp_ops */
-	status = nfsd4_decode_state_protect_ops(argp, exid);
-	if (status)
-		return status;
-
-	/* ssp_hash_algs<> */
-	if (xdr_stream_decode_u32(argp->xdr, &count) < 0)
-		return nfserr_bad_xdr;
-	while (count--) {
-		status = nfsd4_decode_ignored_string(argp, 0);
-		if (status)
-			return status;
-	}
-
-	/* ssp_encr_algs<> */
-	if (xdr_stream_decode_u32(argp->xdr, &count) < 0)
-		return nfserr_bad_xdr;
-	while (count--) {
-		status = nfsd4_decode_ignored_string(argp, 0);
-		if (status)
-			return status;
-	}
-
-	if (xdr_stream_decode_u32(argp->xdr, &window) < 0)
-		return nfserr_bad_xdr;
-	if (xdr_stream_decode_u32(argp->xdr, &num_gss_handles) < 0)
-		return nfserr_bad_xdr;
-
-=======
-static __be32
-nfsd4_decode_nfs_impl_id4(struct nfsd4_compoundargs *argp,
-			  struct nfsd4_exchange_id *exid)
-{
-	__be32 status;
-	u32 count;
-
-	if (xdr_stream_decode_u32(argp->xdr, &count) < 0)
-		return nfserr_bad_xdr;
-	switch (count) {
-	case 0:
-		break;
-	case 1:
-		/* Note that RFC 8881 places no length limit on
-		 * nii_domain, but this implementation permits no
-		 * more than NFS4_OPAQUE_LIMIT bytes */
-		status = nfsd4_decode_opaque(argp, &exid->nii_domain);
-		if (status)
-			return status;
-		/* Note that RFC 8881 places no length limit on
-		 * nii_name, but this implementation permits no
-		 * more than NFS4_OPAQUE_LIMIT bytes */
-		status = nfsd4_decode_opaque(argp, &exid->nii_name);
-		if (status)
-			return status;
-		status = nfsd4_decode_nfstime4(argp, &exid->nii_time);
-		if (status)
-			return status;
-		break;
-	default:
 		return nfserr_bad_xdr;
-	}
 
->>>>>>> linux-next/akpm-base
 	return nfs_ok;
 }
 
 static __be32
-<<<<<<< HEAD
 nfsd4_decode_state_protect4_a(struct nfsd4_compoundargs *argp,
 			      struct nfsd4_exchange_id *exid)
 {
@@ -1831,89 +1619,11 @@ nfsd4_decode_channel_attrs4(struct nfsd4
 	default:
 		return nfserr_bad_xdr;
 	}
-=======
-nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
-			 struct nfsd4_exchange_id *exid)
-{
-	__be32 status;
-
-	status = nfsd4_decode_verifier4(argp, &exid->verifier);
-	if (status)
-		return status;
-	status = nfsd4_decode_opaque(argp, &exid->clname);
-	if (status)
-		return status;
-	if (xdr_stream_decode_u32(argp->xdr, &exid->flags) < 0)
-		return nfserr_bad_xdr;
-	status = nfsd4_decode_state_protect4_a(argp, exid);
-	if (status)
-		return status;
-	return nfsd4_decode_nfs_impl_id4(argp, exid);
-}
-
-static __be32
-nfsd4_decode_channel_attrs4(struct nfsd4_compoundargs *argp,
-			    struct nfsd4_channel_attrs *ca)
-{
-	__be32 *p;
-
-	p = xdr_inline_decode(argp->xdr, XDR_UNIT * 7);
-	if (!p)
-		return nfserr_bad_xdr;
-
-	/* headerpadsz is ignored */
-	p++;
-	ca->maxreq_sz = be32_to_cpup(p++);
-	ca->maxresp_sz = be32_to_cpup(p++);
-	ca->maxresp_cached = be32_to_cpup(p++);
-	ca->maxops = be32_to_cpup(p++);
-	ca->maxreqs = be32_to_cpup(p++);
-	ca->nr_rdma_attrs = be32_to_cpup(p);
-	switch (ca->nr_rdma_attrs) {
-	case 0:
-		break;
-	case 1:
-		if (xdr_stream_decode_u32(argp->xdr, &ca->rdma_attrs) < 0)
-			return nfserr_bad_xdr;
-		break;
-	default:
-		return nfserr_bad_xdr;
-	}
-
-	return nfs_ok;
-}
-
-static __be32
-nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
-			    struct nfsd4_create_session *sess)
-{
-	__be32 status;
-
-	status = nfsd4_decode_clientid4(argp, &sess->clientid);
-	if (status)
-		return status;
-	if (xdr_stream_decode_u32(argp->xdr, &sess->seqid) < 0)
-		return nfserr_bad_xdr;
-	if (xdr_stream_decode_u32(argp->xdr, &sess->flags) < 0)
-		return nfserr_bad_xdr;
-	status = nfsd4_decode_channel_attrs4(argp, &sess->fore_channel);
-	if (status)
-		return status;
-	status = nfsd4_decode_channel_attrs4(argp, &sess->back_channel);
-	if (status)
-		return status;
-	if (xdr_stream_decode_u32(argp->xdr, &sess->callback_prog) < 0)
-		return nfserr_bad_xdr;
-	status = nfsd4_decode_cb_sec(argp, &sess->cb_sec);
-	if (status)
-		return status;
->>>>>>> linux-next/akpm-base
 
 	return nfs_ok;
 }
 
 static __be32
-<<<<<<< HEAD
 nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 			    struct nfsd4_create_session *sess)
 {
@@ -1946,11 +1656,6 @@ nfsd4_decode_destroy_session(struct nfsd
 			     struct nfsd4_destroy_session *destroy_session)
 {
 	return nfsd4_decode_sessionid4(argp, &destroy_session->sessionid);
-=======
-nfsd4_decode_destroy_session(struct nfsd4_compoundargs *argp,
-			     struct nfsd4_destroy_session *destroy_session)
-{
-	return nfsd4_decode_sessionid4(argp, &destroy_session->sessionid);
 }
 
 static __be32
@@ -1958,24 +1663,12 @@ nfsd4_decode_free_stateid(struct nfsd4_c
 			  struct nfsd4_free_stateid *free_stateid)
 {
 	return nfsd4_decode_stateid4(argp, &free_stateid->fr_stateid);
->>>>>>> linux-next/akpm-base
 }
 
 static __be32
 nfsd4_decode_free_stateid(struct nfsd4_compoundargs *argp,
 			  struct nfsd4_free_stateid *free_stateid)
 {
-<<<<<<< HEAD
-	return nfsd4_decode_stateid4(argp, &free_stateid->fr_stateid);
-}
-
-#ifdef CONFIG_NFSD_PNFS
-static __be32
-nfsd4_decode_getdeviceinfo(struct nfsd4_compoundargs *argp,
-		struct nfsd4_getdeviceinfo *gdev)
-{
-=======
->>>>>>> linux-next/akpm-base
 	__be32 status;
 
 	status = nfsd4_decode_deviceid4(argp, &gdev->gd_devid);
@@ -2032,27 +1725,6 @@ nfsd4_decode_layoutget(struct nfsd4_comp
 		struct nfsd4_layoutget *lgp)
 {
 	__be32 status;
-<<<<<<< HEAD
-
-	if (xdr_stream_decode_u32(argp->xdr, &lgp->lg_signal) < 0)
-		return nfserr_bad_xdr;
-	if (xdr_stream_decode_u32(argp->xdr, &lgp->lg_layout_type) < 0)
-		return nfserr_bad_xdr;
-	if (xdr_stream_decode_u32(argp->xdr, &lgp->lg_seg.iomode) < 0)
-		return nfserr_bad_xdr;
-	if (xdr_stream_decode_u64(argp->xdr, &lgp->lg_seg.offset) < 0)
-		return nfserr_bad_xdr;
-	if (xdr_stream_decode_u64(argp->xdr, &lgp->lg_seg.length) < 0)
-		return nfserr_bad_xdr;
-	if (xdr_stream_decode_u64(argp->xdr, &lgp->lg_minlength) < 0)
-		return nfserr_bad_xdr;
-	status = nfsd4_decode_stateid4(argp, &lgp->lg_sid);
-	if (status)
-		return status;
-	if (xdr_stream_decode_u32(argp->xdr, &lgp->lg_maxcount) < 0)
-		return nfserr_bad_xdr;
-
-=======
 
 	if (xdr_stream_decode_u32(argp->xdr, &lgp->lg_signal) < 0)
 		return nfserr_bad_xdr;
@@ -2072,7 +1744,6 @@ nfsd4_decode_layoutget(struct nfsd4_comp
 	if (xdr_stream_decode_u32(argp->xdr, &lgp->lg_maxcount) < 0)
 		return nfserr_bad_xdr;
 
->>>>>>> linux-next/akpm-base
 	return nfs_ok;
 }
 
--- a/include/linux/memcontrol.h~linux-next-git-rejects
+++ a/include/linux/memcontrol.h
@@ -1546,40 +1546,6 @@ static inline void dec_memcg_page_state(
 }
 
 static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
-<<<<<<< HEAD
-{
-	struct mem_cgroup *memcg;
-
-	memcg = lruvec_memcg(lruvec);
-	if (!memcg)
-		return NULL;
-	memcg = parent_mem_cgroup(memcg);
-	if (!memcg)
-		return NULL;
-	return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
-}
-
-static inline void unlock_page_lruvec(struct lruvec *lruvec)
-{
-	spin_unlock(&lruvec->lru_lock);
-}
-
-static inline void unlock_page_lruvec_irq(struct lruvec *lruvec)
-{
-	spin_unlock_irq(&lruvec->lru_lock);
-}
-
-static inline void unlock_page_lruvec_irqrestore(struct lruvec *lruvec,
-		unsigned long flags)
-{
-	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
-}
-
-/* Don't lock again iff page's lruvec locked */
-static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
-		struct lruvec *locked_lruvec)
-=======
->>>>>>> linux-next/akpm-base
 {
 	if (locked_lruvec) {
 		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
--- a/include/linux/sunrpc/xdr.h~linux-next-git-rejects
+++ a/include/linux/sunrpc/xdr.h
@@ -182,11 +182,7 @@ xdr_adjust_iovec(struct kvec *iov, __be3
  * XDR buffer helper functions
  */
 extern void xdr_shift_buf(struct xdr_buf *, size_t);
-<<<<<<< HEAD
-extern void xdr_buf_from_iov(struct kvec *, struct xdr_buf *);
-=======
 extern void xdr_buf_from_iov(const struct kvec *, struct xdr_buf *);
->>>>>>> linux-next/akpm-base
 extern int xdr_buf_subsegment(const struct xdr_buf *buf, struct xdr_buf *subbuf,
 			      unsigned int base, unsigned int len);
 extern void xdr_buf_trim(struct xdr_buf *, unsigned int);
@@ -255,15 +251,9 @@ extern void xdr_init_decode_pages(struct
 extern __be32 *xdr_inline_decode(struct xdr_stream *xdr, size_t nbytes);
 extern unsigned int xdr_read_pages(struct xdr_stream *xdr, unsigned int len);
 extern void xdr_enter_page(struct xdr_stream *xdr, unsigned int len);
-<<<<<<< HEAD
-extern int xdr_process_buf(struct xdr_buf *buf, unsigned int offset, unsigned int len, int (*actor)(struct scatterlist *, void *), void *data);
-extern uint64_t xdr_align_data(struct xdr_stream *, uint64_t, uint32_t);
-extern uint64_t xdr_expand_hole(struct xdr_stream *, uint64_t, uint64_t);
-=======
 extern int xdr_process_buf(const struct xdr_buf *buf, unsigned int offset, unsigned int len, int (*actor)(struct scatterlist *, void *), void *data);
 extern unsigned int xdr_align_data(struct xdr_stream *, unsigned int offset, unsigned int length);
 extern unsigned int xdr_expand_hole(struct xdr_stream *, unsigned int offset, unsigned int length);
->>>>>>> linux-next/akpm-base
 extern bool xdr_stream_subsegment(struct xdr_stream *xdr, struct xdr_buf *subbuf,
 				  unsigned int len);
 
--- a/kernel/bpf/task_iter.c~linux-next-git-rejects
+++ a/kernel/bpf/task_iter.c
@@ -157,11 +157,7 @@ again:
 			return NULL;
 		}
 
-<<<<<<< HEAD
-		/* set info->task and info->tid */
-=======
 		/* set *task and info->tid */
->>>>>>> linux-next/akpm-base
 		info->task = curr_task;
 		if (curr_tid == info->tid) {
 			curr_fd = info->fd;
--- a/lib/Makefile~linux-next-git-rejects
+++ a/lib/Makefile
@@ -353,9 +353,5 @@ obj-$(CONFIG_BITFIELD_KUNIT) += bitfield
 obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
 obj-$(CONFIG_BITS_TEST) += test_bits.o
-<<<<<<< HEAD
-obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
-=======
 
 obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
->>>>>>> linux-next/akpm-base
--- a/mm/vmscan.c~linux-next-git-rejects
+++ a/mm/vmscan.c
@@ -1948,11 +1948,8 @@ shrink_inactive_list(unsigned long nr_to
 		return 0;
 
 	nr_reclaimed = shrink_page_list(&page_list, pgdat, sc, &stat, false);
-<<<<<<< HEAD
-=======
 
 	spin_lock_irq(&pgdat->lru_lock);
->>>>>>> linux-next/akpm-base
 
 	spin_lock_irq(&lruvec->lru_lock);
 	move_pages_to_lru(lruvec, &page_list);
--- a/tools/power/cpupower/utils/helpers/misc.c~linux-next-git-rejects
+++ a/tools/power/cpupower/utils/helpers/misc.c
@@ -5,12 +5,9 @@
 #include <stdlib.h>
 
 #include "helpers/helpers.h"
-<<<<<<< HEAD
-=======
 
 #if defined(__i386__) || defined(__x86_64__)
 
->>>>>>> linux-next/akpm-base
 #include "helpers/sysfs.h"
 
 #if defined(__i386__) || defined(__x86_64__)
--- a/tools/testing/selftests/lkdtm/tests.txt~linux-next-git-rejects
+++ a/tools/testing/selftests/lkdtm/tests.txt
@@ -68,8 +68,4 @@ USERCOPY_STACK_BEYOND
 USERCOPY_KERNEL
 STACKLEAK_ERASING OK: the rest of the thread stack is properly erased
 CFI_FORWARD_PROTO
-<<<<<<< HEAD
-FORTIFIED_STRSCPY
-=======
 PPC_SLB_MULTIHIT Recovered
->>>>>>> linux-next/akpm-base
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

