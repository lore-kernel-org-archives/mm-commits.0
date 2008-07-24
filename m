From: akpm@linux-foundation.org
Subject: - linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 24 Jul 2008 15:19:28 -0700
Message-ID: <200807242219.m6OMJSuk008089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbYGXWTi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 18:19:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dca/dca-sysfs.c       |    5 -
 drivers/ide/arm/palm_bk3710.c |    3 -
 drivers/ide/ide-generic.c     |   12 ----
 drivers/ide/ide-iops.c        |    8 ---
 drivers/ide/ide-probe.c       |   34 -------------
 drivers/ide/ide-tape.c        |    4 -
 drivers/ide/ide-taskfile.c    |   11 ----
 drivers/ide/legacy/gayle.c    |    8 ---
 drivers/ide/pci/cs5520.c      |   19 -------
 drivers/ide/pci/ns87415.c     |    8 ---
 drivers/ide/setup-pci.c       |   46 -----------------
 drivers/mmc/card/mmc_test.c   |   83 --------------------------------
 drivers/scsi/ide-scsi.c       |    6 --
 include/linux/ide.h           |    6 --
 14 files changed, 253 deletions(-)

diff -puN Makefile~linux-next-git-rejects Makefile
diff -puN drivers/dca/dca-sysfs.c~linux-next-git-rejects drivers/dca/dca-sysfs.c
--- a/drivers/dca/dca-sysfs.c~linux-next-git-rejects
+++ a/drivers/dca/dca-sysfs.c
@@ -15,14 +15,9 @@ int dca_sysfs_add_req(struct dca_provide
 	struct device *cd;
 	static int req_count;
 
-<<<<<<< HEAD:drivers/dca/dca-sysfs.c
 	cd = device_create_drvdata(dca_class, dca->cd,
 				   MKDEV(0, slot + 1), NULL,
 				   "requester%d", req_count++);
-=======
-	cd = device_create(dca_class, dca->cd, MKDEV(0, slot + 1), NULL,
-			   "requester%d", slot);
->>>>>>> FETCH_HEAD:drivers/dca/dca-sysfs.c
 	if (IS_ERR(cd))
 		return PTR_ERR(cd);
 	return 0;
diff -puN drivers/ide/arm/palm_bk3710.c~linux-next-git-rejects drivers/ide/arm/palm_bk3710.c
--- a/drivers/ide/arm/palm_bk3710.c~linux-next-git-rejects
+++ a/drivers/ide/arm/palm_bk3710.c
@@ -392,12 +392,9 @@ static int __devinit palm_bk3710_probe(s
 	hw.irq = irq->start;
 	hw.chipset = ide_palm3710;
 
-<<<<<<< HEAD:drivers/ide/arm/palm_bk3710.c
-=======
 	palm_bk3710_port_info.udma_mask = rate < 100000000 ? ATA_UDMA4 :
 							     ATA_UDMA5;
 
->>>>>>> FETCH_HEAD:drivers/ide/arm/palm_bk3710.c
 	rc = ide_host_add(&palm_bk3710_port_info, hws, NULL);
 	if (rc)
 		goto out;
diff -puN drivers/ide/ide-generic.c~linux-next-git-rejects drivers/ide/ide-generic.c
--- a/drivers/ide/ide-generic.c~linux-next-git-rejects
+++ a/drivers/ide/ide-generic.c
@@ -107,13 +107,6 @@ static int __init ide_generic_init(void)
 	unsigned long io_addr;
 	int i, rc;
 
-<<<<<<< HEAD:drivers/ide/ide-generic.c
-	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
-			 "parameter for probing all legacy ISA IDE ports\n");
-
-	for (i = 0; i < MAX_HWIFS; i++) {
-		io_addr = ide_default_io_base(i);
-=======
 #ifdef CONFIG_MIPS
 	if (!ide_probe_legacy())
 		return -ENODEV;
@@ -125,7 +118,6 @@ static int __init ide_generic_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(legacy_bases); i++) {
 		io_addr = legacy_bases[i];
->>>>>>> FETCH_HEAD:drivers/ide/ide-generic.c
 
 		hws[i] = NULL;
 
@@ -147,15 +139,11 @@ static int __init ide_generic_init(void)
 
 			memset(&hw[i], 0, sizeof(hw[i]));
 			ide_std_init_ports(&hw[i], io_addr, io_addr + 0x206);
-<<<<<<< HEAD:drivers/ide/ide-generic.c
-			hw[i].irq = ide_default_irq(io_addr);
-=======
 #ifdef CONFIG_IA64
 			hw[i].irq = isa_irq_to_vector(legacy_irqs[i]);
 #else
 			hw[i].irq = legacy_irqs[i];
 #endif
->>>>>>> FETCH_HEAD:drivers/ide/ide-generic.c
 			hw[i].chipset = ide_generic;
 
 			hws[i] = &hw[i];
diff -puN drivers/ide/ide-iops.c~linux-next-git-rejects drivers/ide/ide-iops.c
--- a/drivers/ide/ide-iops.c~linux-next-git-rejects
+++ a/drivers/ide/ide-iops.c
@@ -373,19 +373,11 @@ EXPORT_SYMBOL_GPL(ide_read_error);
 void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
 {
 	ide_task_t task;
-<<<<<<< HEAD:drivers/ide/ide-iops.c
 
 	memset(&task, 0, sizeof(task));
 	task.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
 			IDE_TFLAG_IN_NSECT;
 
-=======
-
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
-			IDE_TFLAG_IN_NSECT;
-
->>>>>>> FETCH_HEAD:drivers/ide/ide-iops.c
 	drive->hwif->tp_ops->tf_read(drive, &task);
 
 	*bcount = (task.tf.lbah << 8) | task.tf.lbam;
diff -puN drivers/ide/ide-probe.c~linux-next-git-rejects drivers/ide/ide-probe.c
--- a/drivers/ide/ide-probe.c~linux-next-git-rejects
+++ a/drivers/ide/ide-probe.c
@@ -1588,11 +1588,8 @@ struct ide_host *ide_host_alloc_all(cons
 
 		ide_init_port_data(hwif, idx);
 
-<<<<<<< HEAD:drivers/ide/ide-probe.c
-=======
 		hwif->host = host;
 
->>>>>>> FETCH_HEAD:drivers/ide/ide-probe.c
 		host->ports[i] = hwif;
 		host->n_ports++;
 	}
@@ -1602,24 +1599,6 @@ struct ide_host *ide_host_alloc_all(cons
 		return NULL;
 	}
 
-<<<<<<< HEAD:drivers/ide/ide-probe.c
-	return host;
-}
-EXPORT_SYMBOL_GPL(ide_host_alloc_all);
-
-struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
-{
-	hw_regs_t *hws_all[MAX_HWIFS];
-	int i;
-
-	for (i = 0; i < MAX_HWIFS; i++)
-		hws_all[i] = (i < 4) ? hws[i] : NULL;
-
-	return ide_host_alloc_all(d, hws_all);
-}
-EXPORT_SYMBOL_GPL(ide_host_alloc);
-
-=======
 	if (hws[0])
 		host->dev[0] = hws[0]->dev;
 
@@ -1642,7 +1621,6 @@ struct ide_host *ide_host_alloc(const st
 }
 EXPORT_SYMBOL_GPL(ide_host_alloc);
 
->>>>>>> FETCH_HEAD:drivers/ide/ide-probe.c
 int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 		      hw_regs_t **hws)
 {
@@ -1778,17 +1756,6 @@ void ide_host_free(struct ide_host *host
 
 	for (i = 0; i < MAX_HWIFS; i++) {
 		hwif = host->ports[i];
-<<<<<<< HEAD:drivers/ide/ide-probe.c
-
-		if (hwif == NULL)
-			continue;
-
-		ide_free_port_slot(hwif->index);
-		kfree(hwif);
-	}
-
-=======
-
 		if (hwif == NULL)
 			continue;
 
@@ -1796,7 +1763,6 @@ void ide_host_free(struct ide_host *host
 		kfree(hwif);
 	}
 
->>>>>>> FETCH_HEAD:drivers/ide/ide-probe.c
 	kfree(host);
 }
 EXPORT_SYMBOL_GPL(ide_host_free);
diff -puN drivers/ide/ide-tape.c~linux-next-git-rejects drivers/ide/ide-tape.c
--- a/drivers/ide/ide-tape.c~linux-next-git-rejects
+++ a/drivers/ide/ide-tape.c
@@ -658,11 +658,7 @@ static void ide_tape_callback(ide_drive_
 					be32_to_cpup((__be32 *)&readpos[4]));
 
 			tape->partition = readpos[1];
-<<<<<<< HEAD:drivers/ide/ide-tape.c
-			tape->first_frame = be32_to_cpu(*(u32 *)&readpos[4]);
-=======
 			tape->first_frame = be32_to_cpup((__be32 *)&readpos[4]);
->>>>>>> FETCH_HEAD:drivers/ide/ide-tape.c
 			set_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
 		}
 	}
diff -puN drivers/ide/ide-taskfile.c~linux-next-git-rejects drivers/ide/ide-taskfile.c
--- a/drivers/ide/ide-taskfile.c~linux-next-git-rejects
+++ a/drivers/ide/ide-taskfile.c
@@ -126,14 +126,10 @@ EXPORT_SYMBOL_GPL(do_rw_taskfile);
 static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-<<<<<<< HEAD:drivers/ide/ide-taskfile.c
-	u8 stat = hwif->tp_ops->read_status(hwif);
-=======
 	u8 stat;
 
 	local_irq_enable_in_hardirq();
 	stat = hwif->tp_ops->read_status(hwif);
->>>>>>> FETCH_HEAD:drivers/ide/ide-taskfile.c
 
 	if (OK_STAT(stat, READY_STAT, BAD_STAT))
 		drive->mult_count = drive->mult_req;
@@ -154,11 +150,8 @@ static ide_startstop_t set_geometry_intr
 	int retries = 5;
 	u8 stat;
 
-<<<<<<< HEAD:drivers/ide/ide-taskfile.c
-=======
 	local_irq_enable_in_hardirq();
 
->>>>>>> FETCH_HEAD:drivers/ide/ide-taskfile.c
 	while (1) {
 		stat = hwif->tp_ops->read_status(hwif);
 		if ((stat & BUSY_STAT) == 0 || retries-- == 0)
@@ -182,14 +175,10 @@ static ide_startstop_t set_geometry_intr
 static ide_startstop_t recal_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-<<<<<<< HEAD:drivers/ide/ide-taskfile.c
-	u8 stat = hwif->tp_ops->read_status(hwif);
-=======
 	u8 stat;
 
 	local_irq_enable_in_hardirq();
 	stat = hwif->tp_ops->read_status(hwif);
->>>>>>> FETCH_HEAD:drivers/ide/ide-taskfile.c
 
 	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "recal_intr", stat);
diff -puN drivers/ide/legacy/gayle.c~linux-next-git-rejects drivers/ide/legacy/gayle.c
--- a/drivers/ide/legacy/gayle.c~linux-next-git-rejects
+++ a/drivers/ide/legacy/gayle.c
@@ -127,11 +127,7 @@ static int __init gayle_init(void)
     unsigned long phys_base, res_start, res_n;
     unsigned long base, ctrlport, irqport;
     ide_ack_intr_t *ack_intr;
-<<<<<<< HEAD:drivers/ide/legacy/gayle.c
-    int a4000, i;
-=======
     int a4000, i, rc;
->>>>>>> FETCH_HEAD:drivers/ide/legacy/gayle.c
     hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
 
     if (!MACH_IS_AMIGA)
@@ -183,15 +179,11 @@ found:
 	hws[i] = &hw[i];
     }
 
-<<<<<<< HEAD:drivers/ide/legacy/gayle.c
-    return ide_host_add(NULL, hws, NULL);
-=======
     rc = ide_host_add(NULL, hws, NULL);
     if (rc)
 	release_mem_region(res_start, res_n);
 
     return rc;
->>>>>>> FETCH_HEAD:drivers/ide/legacy/gayle.c
 }
 
 module_init(gayle_init);
diff -puN drivers/ide/pci/cs5520.c~linux-next-git-rejects drivers/ide/pci/cs5520.c
--- a/drivers/ide/pci/cs5520.c~linux-next-git-rejects
+++ a/drivers/ide/pci/cs5520.c
@@ -94,26 +94,11 @@ static const struct ide_port_ops cs5520_
 	.set_dma_mode		= cs5520_set_dma_mode,
 };
 
-<<<<<<< HEAD:drivers/ide/pci/cs5520.c
-#define DECLARE_CS_DEV(name_str)				\
-	{							\
-		.name		= name_str,			\
-		.port_ops	= &cs5520_port_ops,		\
-		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
-				  IDE_HFLAG_CS5520,		\
-		.pio_mask	= ATA_PIO4,			\
-	}
-
-static const struct ide_port_info cyrix_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_CS_DEV("Cyrix 5510"),
-	/* 1 */ DECLARE_CS_DEV("Cyrix 5520")
-=======
 static const struct ide_port_info cyrix_chipset __devinitdata = {
 	.name		= DRV_NAME,
 	.port_ops	= &cs5520_port_ops,
 	.host_flags	= IDE_HFLAG_ISA_PORTS | IDE_HFLAG_CS5520,
 	.pio_mask	= ATA_PIO4,
->>>>>>> FETCH_HEAD:drivers/ide/pci/cs5520.c
 };
 
 /*
@@ -124,11 +109,7 @@ static const struct ide_port_info cyrix_
  
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-<<<<<<< HEAD:drivers/ide/pci/cs5520.c
-	const struct ide_port_info *d = &cyrix_chipsets[id->driver_data];
-=======
 	const struct ide_port_info *d = &cyrix_chipset;
->>>>>>> FETCH_HEAD:drivers/ide/pci/cs5520.c
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 
 	ide_setup_pci_noise(dev, d);
diff -puN drivers/ide/pci/ns87415.c~linux-next-git-rejects drivers/ide/pci/ns87415.c
--- a/drivers/ide/pci/ns87415.c~linux-next-git-rejects
+++ a/drivers/ide/pci/ns87415.c
@@ -307,11 +307,7 @@ static const struct ide_dma_ops ns87415_
 };
 
 static const struct ide_port_info ns87415_chipset __devinitdata = {
-<<<<<<< HEAD:drivers/ide/pci/ns87415.c
-	.name		= "NS87415",
-=======
 	.name		= DRV_NAME,
->>>>>>> FETCH_HEAD:drivers/ide/pci/ns87415.c
 	.init_hwif	= init_hwif_ns87415,
 	.port_ops	= &ns87415_port_ops,
 	.dma_ops	= &ns87415_dma_ops,
@@ -330,11 +326,7 @@ static int __devinit ns87415_init_one(st
 		d.tp_ops = &superio_tp_ops;
 	}
 #endif
-<<<<<<< HEAD:drivers/ide/pci/ns87415.c
-	return ide_setup_pci_device(dev, &d);
-=======
 	return ide_pci_init_one(dev, &d, NULL);
->>>>>>> FETCH_HEAD:drivers/ide/pci/ns87415.c
 }
 
 static const struct pci_device_id ns87415_pci_tbl[] = {
diff -puN drivers/ide/setup-pci.c~linux-next-git-rejects drivers/ide/setup-pci.c
--- a/drivers/ide/setup-pci.c~linux-next-git-rejects
+++ a/drivers/ide/setup-pci.c
@@ -107,23 +107,16 @@ EXPORT_SYMBOL_GPL(ide_pci_dma_base);
 
 int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
-<<<<<<< HEAD:drivers/ide/setup-pci.c
-=======
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
->>>>>>> FETCH_HEAD:drivers/ide/setup-pci.c
 	u8 dma_stat;
 
 	if (d->host_flags & (IDE_HFLAG_MMIO | IDE_HFLAG_CS5520))
 		goto out;
 
 	if (d->host_flags & IDE_HFLAG_CLEAR_SIMPLEX) {
-<<<<<<< HEAD:drivers/ide/setup-pci.c
-		ide_pci_clear_simplex(hwif->dma_base, d->name);
-=======
 		if (ide_pci_clear_simplex(hwif->dma_base, d->name))
 			printk(KERN_INFO "%s %s: simplex device: DMA forced\n",
 				d->name, pci_name(dev));
->>>>>>> FETCH_HEAD:drivers/ide/setup-pci.c
 		goto out;
 	}
 
@@ -139,12 +132,8 @@ int ide_pci_check_simplex(ide_hwif_t *hw
 	 */
 	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 	if ((dma_stat & 0x80) && hwif->mate && hwif->mate->dma_base) {
-<<<<<<< HEAD:drivers/ide/setup-pci.c
-		printk(KERN_INFO "%s: simplex device: DMA disabled\n", d->name);
-=======
 		printk(KERN_INFO "%s %s: simplex device: DMA disabled\n",
 			d->name, pci_name(dev));
->>>>>>> FETCH_HEAD:drivers/ide/setup-pci.c
 		return -1;
 	}
 out:
@@ -334,14 +323,9 @@ static int ide_hw_configure(struct pci_d
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
 		if (ide_pci_check_iomem(dev, d, 2 * port) ||
 		    ide_pci_check_iomem(dev, d, 2 * port + 1)) {
-<<<<<<< HEAD:drivers/ide/setup-pci.c
-			printk(KERN_ERR "%s: I/O baseregs (BIOS) are reported "
-					"as MEM for port %d!\n", d->name, port);
-=======
 			printk(KERN_ERR "%s %s: I/O baseregs (BIOS) are "
 				"reported as MEM for port %d!\n",
 				d->name, pci_name(dev), port);
->>>>>>> FETCH_HEAD:drivers/ide/setup-pci.c
 			return -EINVAL;
 		}
 
@@ -354,13 +338,8 @@ static int ide_hw_configure(struct pci_d
 	}
 
 	if (!base || !ctl) {
-<<<<<<< HEAD:drivers/ide/setup-pci.c
-		printk(KERN_ERR "%s: bad PCI BARs for port %d, skipping\n",
-				d->name, port);
-=======
 		printk(KERN_ERR "%s %s: bad PCI BARs for port %d, skipping\n",
 			d->name, pci_name(dev), port);
->>>>>>> FETCH_HEAD:drivers/ide/setup-pci.c
 		return -EINVAL;
 	}
 
@@ -562,19 +541,6 @@ out:
 int ide_pci_init_one(struct pci_dev *dev, const struct ide_port_info *d,
 		     void *priv)
 {
-<<<<<<< HEAD:drivers/ide/setup-pci.c
-	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
-	int ret;
-
-	ret = do_ide_setup_pci_device(dev, d, 1);
-
-	if (ret >= 0) {
-		/* FIXME: silent failure can happen */
-		ide_pci_setup_ports(dev, d, ret, &hw[0], &hws[0]);
-
-		ret = ide_host_add(d, hws, NULL);
-	}
-=======
 	struct ide_host *host;
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 	int ret;
@@ -603,7 +569,6 @@ int ide_pci_init_one(struct pci_dev *dev
 
 	/* fixup IRQ */
 	hw[1].irq = hw[0].irq = ret;
->>>>>>> FETCH_HEAD:drivers/ide/setup-pci.c
 
 	ret = ide_host_register(host, d, hws);
 	if (ret)
@@ -620,8 +585,6 @@ int ide_pci_init_two(struct pci_dev *dev
 	struct ide_host *host;
 	int ret, i;
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
-<<<<<<< HEAD:drivers/ide/setup-pci.c
-=======
 
 	for (i = 0; i < 2; i++) {
 		ret = ide_setup_pci_controller(pdev[i], d, !i);
@@ -644,7 +607,6 @@ int ide_pci_init_two(struct pci_dev *dev
 
 	pci_set_drvdata(pdev[0], host);
 	pci_set_drvdata(pdev[1], host);
->>>>>>> FETCH_HEAD:drivers/ide/setup-pci.c
 
 	for (i = 0; i < 2; i++) {
 		ret = do_ide_setup_pci_device(pdev[i], d, !i);
@@ -656,13 +618,6 @@ int ide_pci_init_two(struct pci_dev *dev
 		if (ret < 0)
 			goto out;
 
-<<<<<<< HEAD:drivers/ide/setup-pci.c
-		/* FIXME: silent failure can happen */
-		ide_pci_setup_ports(pdev[i], d, ret, &hw[i*2], &hws[i*2]);
-	}
-
-	ret = ide_host_add(d, hws, NULL);
-=======
 		/* fixup IRQ */
 		hw[i*2 + 1].irq = hw[i*2].irq = ret;
 	}
@@ -670,7 +625,6 @@ int ide_pci_init_two(struct pci_dev *dev
 	ret = ide_host_register(host, d, hws);
 	if (ret)
 		ide_host_free(host);
->>>>>>> FETCH_HEAD:drivers/ide/setup-pci.c
 out:
 	return ret;
 }
diff -puN drivers/mmc/card/mmc_test.c~linux-next-git-rejects drivers/mmc/card/mmc_test.c
--- a/drivers/mmc/card/mmc_test.c~linux-next-git-rejects
+++ a/drivers/mmc/card/mmc_test.c
@@ -805,72 +805,6 @@ static int mmc_test_multi_xfersize_read(
 	return 0;
 }
 
-<<<<<<< HEAD:drivers/mmc/card/mmc_test.c
-static int mmc_test_bigsg_write(struct mmc_test_card *test)
-{
-	int ret;
-	unsigned int size;
-	struct scatterlist sg;
-
-	if (test->card->host->max_blk_count == 1)
-		return RESULT_UNSUP_HOST;
-
-	size = PAGE_SIZE * 2;
-	size = min(size, test->card->host->max_req_size);
-	size = min(size, test->card->host->max_seg_size);
-	size = min(size, test->card->host->max_blk_count * 512);
-
-	memset(test->buffer, 0, BUFFER_SIZE);
-
-	if (size < 1024)
-		return RESULT_UNSUP_HOST;
-
-	sg_init_table(&sg, 1);
-	sg_init_one(&sg, test->buffer, BUFFER_SIZE);
-
-	ret = mmc_test_transfer(test, &sg, 1, 0, size/512, 512, 1);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-static int mmc_test_bigsg_read(struct mmc_test_card *test)
-{
-	int ret, i;
-	unsigned int size;
-	struct scatterlist sg;
-
-	if (test->card->host->max_blk_count == 1)
-		return RESULT_UNSUP_HOST;
-
-	size = PAGE_SIZE * 2;
-	size = min(size, test->card->host->max_req_size);
-	size = min(size, test->card->host->max_seg_size);
-	size = min(size, test->card->host->max_blk_count * 512);
-
-	if (size < 1024)
-		return RESULT_UNSUP_HOST;
-
-	memset(test->buffer, 0xCD, BUFFER_SIZE);
-
-	sg_init_table(&sg, 1);
-	sg_init_one(&sg, test->buffer, BUFFER_SIZE);
-	ret = mmc_test_transfer(test, &sg, 1, 0, size/512, 512, 0);
-	if (ret)
-		return ret;
-
-	/* mmc_test_transfer() doesn't check for read overflows */
-	for (i = size;i < BUFFER_SIZE;i++) {
-		if (test->buffer[i] != 0xCD)
-			return RESULT_FAIL;
-	}
-
-	return 0;
-}
-
-=======
->>>>>>> FETCH_HEAD:drivers/mmc/card/mmc_test.c
 #ifdef CONFIG_HIGHMEM
 
 static int mmc_test_write_high(struct mmc_test_card *test)
@@ -1074,23 +1008,6 @@ static const struct mmc_test_case mmc_te
 		.run = mmc_test_multi_xfersize_read,
 	},
 
-<<<<<<< HEAD:drivers/mmc/card/mmc_test.c
-	{
-		.name = "Over-sized SG list write",
-		.prepare = mmc_test_prepare_write,
-		.run = mmc_test_bigsg_write,
-		.cleanup = mmc_test_cleanup,
-	},
-
-	{
-		.name = "Over-sized SG list read",
-		.prepare = mmc_test_prepare_read,
-		.run = mmc_test_bigsg_read,
-		.cleanup = mmc_test_cleanup,
-	},
-
-=======
->>>>>>> FETCH_HEAD:drivers/mmc/card/mmc_test.c
 #ifdef CONFIG_HIGHMEM
 
 	{
diff -puN drivers/scsi/ide-scsi.c~linux-next-git-rejects drivers/scsi/ide-scsi.c
--- a/drivers/scsi/ide-scsi.c~linux-next-git-rejects
+++ a/drivers/scsi/ide-scsi.c
@@ -232,10 +232,7 @@ static int idescsi_check_condition(ide_d
 		ide_scsi_hex_dump(pc->c, 6);
 	}
 	rq->rq_disk = scsi->disk;
-<<<<<<< HEAD:drivers/scsi/ide-scsi.c
-=======
 	rq->ref_count++;
->>>>>>> FETCH_HEAD:drivers/scsi/ide-scsi.c
 	memcpy(rq->cmd, pc->c, 12);
 	ide_do_drive_cmd(drive, rq);
 	return 0;
@@ -628,10 +625,7 @@ static int idescsi_queue (struct scsi_cm
 	rq->special = (char *) pc;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	spin_unlock_irq(host->host_lock);
-<<<<<<< HEAD:drivers/scsi/ide-scsi.c
-=======
 	rq->ref_count++;
->>>>>>> FETCH_HEAD:drivers/scsi/ide-scsi.c
 	memcpy(rq->cmd, pc->c, 12);
 	blk_execute_rq_nowait(drive->queue, scsi->disk, rq, 0, NULL);
 	spin_lock_irq(host->host_lock);
diff -puN include/linux/ide.h~linux-next-git-rejects include/linux/ide.h
--- a/include/linux/ide.h~linux-next-git-rejects
+++ a/include/linux/ide.h
@@ -546,11 +546,8 @@ struct ide_dma_ops {
 	void	(*dma_timeout)(struct ide_drive_s *);
 };
 
-<<<<<<< HEAD:include/linux/ide.h
-=======
 struct ide_host;
 
->>>>>>> FETCH_HEAD:include/linux/ide.h
 typedef struct hwif_s {
 	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
@@ -647,12 +644,9 @@ typedef struct hwif_s {
 struct ide_host {
 	ide_hwif_t	*ports[MAX_HWIFS];
 	unsigned int	n_ports;
-<<<<<<< HEAD:include/linux/ide.h
-=======
 	struct device	*dev[2];
 	unsigned long	host_flags;
 	void		*host_priv;
->>>>>>> FETCH_HEAD:include/linux/ide.h
 };
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
kill-generic_file_direct_io.patch
use-generic_access_phys-for-dev-mem-mappings.patch
spufs-use-the-new-vm_ops-access.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
page-flags-record-page-flag-overlays-explicitly.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups.patch
vma-page-offset-has-no-callees-drop-it.patch
sync_file_range_write-may-and-will-block-document-that.patch
vmallocinfo-add-numa-information.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
bootmem-add-debugging-framework.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
flag-parameters-paccept.patch
flag-parameters-anon_inode_getfd-extension.patch
flag-parameters-signalfd.patch
flag-parameters-eventfd.patch
flag-parameters-inotify_init.patch
flag-parameters-check-magic-constants.patch
spi-au1550_spi-improve-pio-transfer-mode.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts.patch
rtc-cmos-improve-hpet-irq-glue.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed.patch
atmel_lcdfb-avoid-division-by-zero.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant.patch
lcd-add-platform_lcd-driver.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons.patch
arm-fix-fls-for-64-bit-arguments.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-fixup.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
drivers-mfd-tc6393xbc-doesnt-compile-on-i386.patch
arch-mips-kernel-stacktracec-heiko-cant-type.patch
git-acpi.patch
x86-pci-replace-dbg-with-pr_debug-fix.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
arch-x86-pci-i386c-fix-printk-warnings.patch
arch-x86-kernel-genx2apic_uv_xc-warning-fix.patch
git-arm-master.patch
git-cifs.patch
drm-fix-sparc64-build.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-input.patch
git-jg-misc.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kvm.patch
git-leds.patch
git-mtd.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
git-nfsd.patch
git-pci-current.patch
git-sh.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-net-wireless-iwlwifi-iwl-ledc-printk-fix.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing-fix.patch
exec-remove-some-includes-fix.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
drivers-misc-hpiloc-needs-config_pci.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
eink_apollofb-new-driver-for-apollo-eink-controller-cleanup.patch
eink_apollofb-new-driver-for-apollo-eink-controller-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller-fix-fix-2.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
devcgroup-code-cleanup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-limit-change-shrink-usage-checkpatch-fixes.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sdhci-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-infiniband.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-more-sparc.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-ibmvscsi.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-cleanup.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
introduce-__get_user_pages-fix.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

