From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 05 Sep 2017 12:51:02 -0700
Message-ID: <20170905195102.CQKmuOf8Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37724 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752292AbdIETvE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 15:51:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/acpi/arm64/iort.c~linux-next-git-rejects drivers/acpi/arm64/iort.c
--- a/drivers/acpi/arm64/iort.c~linux-next-git-rejects
+++ a/drivers/acpi/arm64/iort.c
@@ -673,26 +673,6 @@ static int iort_iommu_xlate(struct devic
 	if (!ops)
 		return iort_iommu_driver_enabled(node->type) ?
 		       -EPROBE_DEFER : -ENODEV;
-<<<<<<< HEAD
-
-	return arm_smmu_iort_xlate(dev, streamid, iort_fwnode, ops);
-}
-
-struct iort_pci_alias_info {
-	struct device *dev;
-	struct acpi_iort_node *node;
-};
-
-static int iort_pci_iommu_init(struct pci_dev *pdev, u16 alias, void *data)
-{
-	struct iort_pci_alias_info *info = data;
-	struct acpi_iort_node *parent;
-	u32 streamid;
-
-	parent = iort_node_map_id(info->node, alias, &streamid,
-				  IORT_IOMMU_TYPE);
-	return iort_iommu_xlate(info->dev, parent, streamid);
-=======
 
 	return arm_smmu_iort_xlate(dev, streamid, iort_fwnode, ops);
 }
@@ -729,7 +709,6 @@ static int nc_dma_get_range(struct devic
 			1ULL<<ncomp->memory_address_limit;
 
 	return 0;
->>>>>>> linux-next/akpm-base
 }
 
 /**
diff -puN drivers/firmware/efi/libstub/arm64-stub.c~linux-next-git-rejects drivers/firmware/efi/libstub/arm64-stub.c
--- a/drivers/firmware/efi/libstub/arm64-stub.c~linux-next-git-rejects
+++ a/drivers/firmware/efi/libstub/arm64-stub.c
@@ -21,10 +21,7 @@
 #include <linux/efi.h>
 #include <asm/efi.h>
 #include <asm/memory.h>
-<<<<<<< HEAD
 #include <asm/sections.h>
-=======
->>>>>>> linux-next/akpm-base
 #include <asm/sysreg.h>
 
 #include "efistub.h"
diff -puN drivers/hwtracing/coresight/coresight-tmc.c~linux-next-git-rejects drivers/hwtracing/coresight/coresight-tmc.c
--- a/drivers/hwtracing/coresight/coresight-tmc.c~linux-next-git-rejects
+++ a/drivers/hwtracing/coresight/coresight-tmc.c
@@ -438,8 +438,6 @@ out:
 }
 
 static const struct amba_id tmc_ids[] = {
-<<<<<<< HEAD
-=======
 	{
 		.id     = 0x000bb961,
 		.mask   = 0x000fffff,
@@ -455,7 +453,6 @@ static const struct amba_id tmc_ids[] =
 		.id	= 0x000bb9e9,
 		.mask	= 0x000fffff,
 	},
->>>>>>> linux-next/akpm-base
 	{
 		/* Coresight SoC 600 TMC-ETF */
 		.id	= 0x000bb9ea,
diff -puN drivers/input/misc/axp20x-pek.c~linux-next-git-rejects drivers/input/misc/axp20x-pek.c
--- a/drivers/input/misc/axp20x-pek.c~linux-next-git-rejects
+++ a/drivers/input/misc/axp20x-pek.c
@@ -354,15 +354,6 @@ static int axp20x_pek_probe(struct platf
 			return error;
 	}
 
-<<<<<<< HEAD
-	error = devm_device_add_group(&pdev->dev, &axp20x_attribute_group);
-	if (error) {
-		dev_err(&pdev->dev, "Failed to create sysfs attributes: %d\n",
-			error);
-		return error;
-	}
-
-=======
 	axp20x_pek->info = (struct axp20x_info *)match->driver_data;
 
 	error = devm_device_add_group(&pdev->dev, &axp20x_attribute_group);
@@ -372,7 +363,6 @@ static int axp20x_pek_probe(struct platf
 		return error;
 	}
 
->>>>>>> linux-next/akpm-base
 	platform_set_drvdata(pdev, axp20x_pek);
 
 	return 0;
diff -puN drivers/irqchip/irq-mips-gic.c~linux-next-git-rejects drivers/irqchip/irq-mips-gic.c
--- a/drivers/irqchip/irq-mips-gic.c~linux-next-git-rejects
+++ a/drivers/irqchip/irq-mips-gic.c
@@ -250,14 +250,8 @@ static int gic_set_affinity(struct irq_d
 			    bool force)
 {
 	unsigned int irq = GIC_HWIRQ_TO_SHARED(d->hwirq);
-<<<<<<< HEAD
-	cpumask_t	tmp = CPU_MASK_NONE;
-	unsigned long	flags;
-	int		i, cpu;
-=======
 	unsigned long flags;
 	unsigned int cpu;
->>>>>>> linux-next/akpm-base
 
 	cpu = cpumask_first_and(cpumask, cpu_online_mask);
 	if (cpu >= NR_CPUS)
@@ -269,16 +263,6 @@ static int gic_set_affinity(struct irq_d
 	spin_lock_irqsave(&gic_lock, flags);
 
 	/* Re-route this IRQ */
-<<<<<<< HEAD
-	gic_map_to_vpe(irq, mips_cm_vp_id(cpu));
-
-	/* Update the pcpu_masks */
-	for (i = 0; i < min(gic_vpes, NR_CPUS); i++)
-		clear_bit(irq, pcpu_masks[i].pcpu_mask);
-	set_bit(irq, pcpu_masks[cpu].pcpu_mask);
-
-	cpumask_copy(irq_data_get_affinity_mask(d), cpumask);
-=======
 	write_gic_map_vp(irq, BIT(mips_cm_vp_id(cpu)));
 
 	/* Update the pcpu_masks */
@@ -286,7 +270,6 @@ static int gic_set_affinity(struct irq_d
 	if (read_gic_mask(irq))
 		set_bit(irq, per_cpu_ptr(pcpu_masks, cpu));
 
->>>>>>> linux-next/akpm-base
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
 	spin_unlock_irqrestore(&gic_lock, flags);
 
diff -puN drivers/phy/Makefile~linux-next-git-rejects drivers/phy/Makefile
--- a/drivers/phy/Makefile~linux-next-git-rejects
+++ a/drivers/phy/Makefile
@@ -8,10 +8,7 @@ obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
 obj-$(CONFIG_PHY_PISTACHIO_USB)		+= phy-pistachio-usb.o
 obj-$(CONFIG_ARCH_SUNXI)		+= allwinner/
 obj-$(CONFIG_ARCH_MESON)		+= amlogic/
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_LANTIQ)			+= lantiq/
->>>>>>> linux-next/akpm-base
 obj-$(CONFIG_ARCH_MEDIATEK)		+= mediatek/
 obj-$(CONFIG_ARCH_RENESAS)		+= renesas/
 obj-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip/
diff -puN drivers/spi/spi.c~linux-next-git-rejects drivers/spi/spi.c
--- a/drivers/spi/spi.c~linux-next-git-rejects
+++ a/drivers/spi/spi.c
@@ -40,10 +40,7 @@
 #include <linux/ioport.h>
 #include <linux/acpi.h>
 #include <linux/highmem.h>
-<<<<<<< HEAD
-=======
 #include <linux/platform_data/x86/apple.h>
->>>>>>> linux-next/akpm-base
 #include <linux/idr.h>
 
 #define CREATE_TRACE_POINTS
diff -puN drivers/staging/unisys/visorhba/visorhba_main.c~linux-next-git-rejects drivers/staging/unisys/visorhba/visorhba_main.c
--- a/drivers/staging/unisys/visorhba/visorhba_main.c~linux-next-git-rejects
+++ a/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -49,11 +49,6 @@ MODULE_ALIAS("visorbus:" VISOR_VHBA_CHAN
 struct visordisk_info {
 	struct scsi_device *sdev;
 	u32 valid;
-<<<<<<< HEAD
-	/* Disk Path */
-	u32 channel, id, lun;
-=======
->>>>>>> linux-next/akpm-base
 	atomic_t ios_threshold;
 	atomic_t error_count;
 	struct visordisk_info *next;
@@ -483,7 +478,6 @@ static const char *visorhba_get_info(str
  * dma_data_dir_linux_to_spar - convert dma_data_direction value to
  *				Unisys-specific equivalent
  * @d: dma direction value to convert
-<<<<<<< HEAD
  *
  * Returns the Unisys-specific dma direction value corresponding to @d
  */
@@ -511,35 +505,6 @@ static u32 dma_data_dir_linux_to_spar(en
  * Queues to scsicmd to the ServicePartition after converting it to a
  * uiscmdrsp structure.
  *
-=======
- *
- * Returns the Unisys-specific dma direction value corresponding to @d
- */
-static u32 dma_data_dir_linux_to_spar(enum dma_data_direction d)
-{
-	switch (d) {
-	case DMA_BIDIRECTIONAL:
-		return UIS_DMA_BIDIRECTIONAL;
-	case DMA_TO_DEVICE:
-		return UIS_DMA_TO_DEVICE;
-	case DMA_FROM_DEVICE:
-		return UIS_DMA_FROM_DEVICE;
-	case DMA_NONE:
-		return UIS_DMA_NONE;
-	default:
-		return UIS_DMA_NONE;
-	}
-}
-
-/*
- * visorhba_queue_command_lck - Queues command to the Service Partition
- * @scsicmd:		Command to be queued
- * @vsiorhba_cmnd_done: Done command to call when scsicmd is returned
- *
- * Queues to scsicmd to the ServicePartition after converting it to a
- * uiscmdrsp structure.
- *
->>>>>>> linux-next/akpm-base
  * Return: 0 if successfully queued to the Service Partition, otherwise
  *	   error code
  */
@@ -639,24 +604,14 @@ static int visorhba_slave_alloc(struct s
 	struct visorhba_devdata *devdata;
 	struct Scsi_Host *scsihost = (struct Scsi_Host *)scsidev->host;
 
-<<<<<<< HEAD
-=======
 	/* already allocated return success */
 	if (scsidev->hostdata)
 		return 0;
 
->>>>>>> linux-next/akpm-base
 	/* even though we errored, treat as success */
 	devdata = (struct visorhba_devdata *)scsihost->hostdata;
 	if (!devdata)
 		return 0;
-<<<<<<< HEAD
-
-	/* already allocated return success */
-	for_each_vdisk_match(vdisk, devdata, scsidev)
-		return 0;
-=======
->>>>>>> linux-next/akpm-base
 
 	vdisk = kzalloc(sizeof(*vdisk), GFP_ATOMIC);
 	if (!vdisk)
@@ -829,17 +784,10 @@ static void visorhba_serverdown_complete
 /*
  * visorhba_serverdown - Got notified that the IOVM is down
  * @devdata: Visorhba that is being serviced by downed IOVM
-<<<<<<< HEAD
- *
- * Something happened to the IOVM, return immediately and
- * schedule cleanup work.
- *
-=======
  *
  * Something happened to the IOVM, return immediately and
  * schedule cleanup work.
  *
->>>>>>> linux-next/akpm-base
  * Return: 0 on success, -EINVAL on failure
  */
 static int visorhba_serverdown(struct visorhba_devdata *devdata)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
mm-page_owner-make-init_pages_in_zone-faster-fix-checkpatch-fixes.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes.patch
add-testcases-for-memset16-32-64-fix.patch
vga-optimise-console-scrolling-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
zram-mm-vs-block.patch
drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

