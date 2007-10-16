From: akpm@linux-foundation.org
Subject: - i-oat-add-support-for-msi-and-msi-x.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:28 -0700
Message-ID: <200710162039.l9GKdSUj015548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33917 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965078AbXJPVSn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:18:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shannon.nelson@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     I/OAT: Add support for MSI and MSI-X
has been removed from the -mm tree.  Its filename was
     i-oat-add-support-for-msi-and-msi-x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I/OAT: Add support for MSI and MSI-X
From: Shannon Nelson <shannon.nelson@intel.com>

Add support for MSI and MSI-X interrupt handling, including the ability
to choose the desired interrupt method.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
[bunk@kernel.org: drivers/dma/ioat_dma.c: make 3 functions static]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat_dma.c          |  348 ++++++++++++++++++++++++------
 drivers/dma/ioatdma.h           |   12 +
 drivers/dma/ioatdma_registers.h |    6 
 include/linux/bitops.h          |    6 
 4 files changed, 305 insertions(+), 67 deletions(-)

diff -puN drivers/dma/ioat_dma.c~i-oat-add-support-for-msi-and-msi-x drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-add-support-for-msi-and-msi-x
+++ a/drivers/dma/ioat_dma.c
@@ -47,6 +47,65 @@
 static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
 static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
 
+static struct ioat_dma_chan *ioat_lookup_chan_by_index(struct ioatdma_device *device,
+						       int index)
+{
+	return device->idx[index];
+}
+
+/**
+ * ioat_dma_do_interrupt - handler used for single vector interrupt mode
+ * @irq: interrupt id
+ * @data: interrupt data
+ */
+static irqreturn_t ioat_dma_do_interrupt(int irq, void *data)
+{
+	struct ioatdma_device *instance = data;
+	struct ioat_dma_chan *ioat_chan;
+	unsigned long attnstatus;
+	int bit;
+	u8 intrctrl;
+
+	intrctrl = readb(instance->reg_base + IOAT_INTRCTRL_OFFSET);
+
+	if (!(intrctrl & IOAT_INTRCTRL_MASTER_INT_EN))
+		return IRQ_NONE;
+
+	if (!(intrctrl & IOAT_INTRCTRL_INT_STATUS)) {
+		writeb(intrctrl, instance->reg_base + IOAT_INTRCTRL_OFFSET);
+		return IRQ_NONE;
+	}
+
+	attnstatus = readl(instance->reg_base + IOAT_ATTNSTATUS_OFFSET);
+	for_each_bit(bit, &attnstatus, BITS_PER_LONG) {
+		ioat_chan = ioat_lookup_chan_by_index(instance, bit);
+		tasklet_schedule(&ioat_chan->cleanup_task);
+	}
+
+	writeb(intrctrl, instance->reg_base + IOAT_INTRCTRL_OFFSET);
+	return IRQ_HANDLED;
+}
+
+/**
+ * ioat_dma_do_interrupt_msix - handler used for vector-per-channel interrupt mode
+ * @irq: interrupt id
+ * @data: interrupt data
+ */
+static irqreturn_t ioat_dma_do_interrupt_msix(int irq, void *data)
+{
+	struct ioat_dma_chan *ioat_chan = data;
+
+	tasklet_schedule(&ioat_chan->cleanup_task);
+
+	return IRQ_HANDLED;
+}
+
+static void ioat_dma_cleanup_tasklet(unsigned long data);
+
+/**
+ * ioat_dma_enumerate_channels - find and initialize the device's channels
+ * @device: the device to be enumerated
+ */
 static int ioat_dma_enumerate_channels(struct ioatdma_device *device)
 {
 	u8 xfercap_scale;
@@ -76,6 +135,11 @@ static int ioat_dma_enumerate_channels(s
 		ioat_chan->common.device = &device->common;
 		list_add_tail(&ioat_chan->common.device_node,
 			      &device->common.channels);
+		device->idx[i] = ioat_chan;
+		tasklet_init(&ioat_chan->cleanup_task,
+			     ioat_dma_cleanup_tasklet,
+			     (unsigned long) ioat_chan);
+		tasklet_disable(&ioat_chan->cleanup_task);
 	}
 	return device->common.chancnt;
 }
@@ -234,6 +298,7 @@ static int ioat_dma_alloc_chan_resources
 	writel(((u64) ioat_chan->completion_addr) >> 32,
 	       ioat_chan->reg_base + IOAT_CHANCMP_OFFSET_HIGH);
 
+	tasklet_enable(&ioat_chan->cleanup_task);
 	ioat_dma_start_null_desc(ioat_chan);
 	return i;
 }
@@ -245,9 +310,14 @@ static void ioat_dma_free_chan_resources
 	struct ioat_desc_sw *desc, *_desc;
 	int in_use_descs = 0;
 
+	tasklet_disable(&ioat_chan->cleanup_task);
 	ioat_dma_memcpy_cleanup(ioat_chan);
 
+	/* Delay 100ms after reset to allow internal DMA logic to quiesce
+	 * before removing DMA descriptor resources.
+	 */
 	writeb(IOAT_CHANCMD_RESET, ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
+	mdelay(100);
 
 	spin_lock_bh(&ioat_chan->desc_lock);
 	list_for_each_entry_safe(desc, _desc, &ioat_chan->used_desc, node) {
@@ -276,6 +346,34 @@ static void ioat_dma_free_chan_resources
 			in_use_descs - 1);
 
 	ioat_chan->last_completion = ioat_chan->completion_addr = 0;
+	ioat_chan->pending = 0;
+}
+/**
+ * ioat_dma_get_next_descriptor - return the next available descriptor
+ * @ioat_chan: IOAT DMA channel handle
+ *
+ * Gets the next descriptor from the chain, and must be called with the
+ * channel's desc_lock held.  Allocates more descriptors if the channel
+ * has run out.
+ */
+static struct ioat_desc_sw *ioat_dma_get_next_descriptor(
+						struct ioat_dma_chan *ioat_chan)
+{
+	struct ioat_desc_sw *new = NULL;
+
+	if (!list_empty(&ioat_chan->free_desc)) {
+		new = to_ioat_desc(ioat_chan->free_desc.next);
+		list_del(&new->node);
+	} else {
+		/* try to get another desc */
+		new = ioat_dma_alloc_descriptor(ioat_chan, GFP_ATOMIC);
+		/* will this ever happen? */
+		/* TODO add upper limit on these */
+		BUG_ON(!new);
+	}
+
+	prefetch(new->hw);
+	return new;
 }
 
 static struct dma_async_tx_descriptor *ioat_dma_prep_memcpy(
@@ -300,17 +398,7 @@ static struct dma_async_tx_descriptor *i
 
 	spin_lock_bh(&ioat_chan->desc_lock);
 	while (len) {
-		if (!list_empty(&ioat_chan->free_desc)) {
-			new = to_ioat_desc(ioat_chan->free_desc.next);
-			list_del(&new->node);
-		} else {
-			/* try to get another desc */
-			new = ioat_dma_alloc_descriptor(ioat_chan, GFP_ATOMIC);
-			/* will this ever happen? */
-			/* TODO add upper limit on these */
-			BUG_ON(!new);
-		}
-
+		new = ioat_dma_get_next_descriptor(ioat_chan);
 		copy = min((u32) len, ioat_chan->xfercap);
 
 		new->hw->size = copy;
@@ -360,6 +448,14 @@ static void ioat_dma_memcpy_issue_pendin
 	}
 }
 
+static void ioat_dma_cleanup_tasklet(unsigned long data)
+{
+	struct ioat_dma_chan *chan = (void *)data;
+	ioat_dma_memcpy_cleanup(chan);
+	writew(IOAT_CHANCTRL_INT_DISABLE,
+	       chan->reg_base + IOAT_CHANCTRL_OFFSET);
+}
+
 static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
 {
 	unsigned long phys_complete;
@@ -397,6 +493,7 @@ static void ioat_dma_memcpy_cleanup(stru
 		return;
 	}
 
+	cookie = 0;
 	spin_lock_bh(&ioat_chan->desc_lock);
 	list_for_each_entry_safe(desc, _desc, &ioat_chan->used_desc, node) {
 
@@ -509,48 +606,13 @@ static enum dma_status ioat_dma_is_compl
 
 /* PCI API */
 
-static irqreturn_t ioat_do_interrupt(int irq, void *data)
-{
-	struct ioatdma_device *instance = data;
-	unsigned long attnstatus;
-	u8 intrctrl;
-
-	intrctrl = readb(instance->reg_base + IOAT_INTRCTRL_OFFSET);
-
-	if (!(intrctrl & IOAT_INTRCTRL_MASTER_INT_EN))
-		return IRQ_NONE;
-
-	if (!(intrctrl & IOAT_INTRCTRL_INT_STATUS)) {
-		writeb(intrctrl, instance->reg_base + IOAT_INTRCTRL_OFFSET);
-		return IRQ_NONE;
-	}
-
-	attnstatus = readl(instance->reg_base + IOAT_ATTNSTATUS_OFFSET);
-
-	printk(KERN_ERR "ioatdma: interrupt! status %lx\n", attnstatus);
-
-	writeb(intrctrl, instance->reg_base + IOAT_INTRCTRL_OFFSET);
-	return IRQ_HANDLED;
-}
-
 static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan)
 {
 	struct ioat_desc_sw *desc;
 
 	spin_lock_bh(&ioat_chan->desc_lock);
 
-	if (!list_empty(&ioat_chan->free_desc)) {
-		desc = to_ioat_desc(ioat_chan->free_desc.next);
-		list_del(&desc->node);
-	} else {
-		/* try to get another desc */
-		spin_unlock_bh(&ioat_chan->desc_lock);
-		desc = ioat_dma_alloc_descriptor(ioat_chan, GFP_KERNEL);
-		spin_lock_bh(&ioat_chan->desc_lock);
-		/* will this ever happen? */
-		BUG_ON(!desc);
-	}
-
+	desc = ioat_dma_get_next_descriptor(ioat_chan);
 	desc->hw->ctl = IOAT_DMA_DESCRIPTOR_NUL;
 	desc->hw->next = 0;
 	desc->async_tx.ack = 1;
@@ -571,7 +633,11 @@ static void ioat_dma_start_null_desc(str
  */
 #define IOAT_TEST_SIZE 2000
 
-static int ioat_self_test(struct ioatdma_device *device)
+/**
+ * ioat_dma_self_test - Perform a IOAT transaction to verify the HW works.
+ * @device: device to be tested
+ */
+static int ioat_dma_self_test(struct ioatdma_device *device)
 {
 	int i;
 	u8 *src;
@@ -639,6 +705,161 @@ out:
 	return err;
 }
 
+static char ioat_interrupt_style[32] = "msix";
+module_param_string(ioat_interrupt_style, ioat_interrupt_style,
+		    sizeof(ioat_interrupt_style), 0644);
+MODULE_PARM_DESC(ioat_interrupt_style,
+		 "set ioat interrupt style: msix (default), "
+		 "msix-single-vector, msi, intx)");
+
+/**
+ * ioat_dma_setup_interrupts - setup interrupt handler
+ * @device: ioat device
+ */
+static int ioat_dma_setup_interrupts(struct ioatdma_device *device)
+{
+	struct ioat_dma_chan *ioat_chan;
+	int err, i, j, msixcnt;
+	u8 intrctrl = 0;
+
+	if (!strcmp(ioat_interrupt_style, "msix"))
+		goto msix;
+	if (!strcmp(ioat_interrupt_style, "msix-single-vector"))
+		goto msix_single_vector;
+	if (!strcmp(ioat_interrupt_style, "msi"))
+		goto msi;
+	if (!strcmp(ioat_interrupt_style, "intx"))
+		goto intx;
+
+msix:
+	/* The number of MSI-X vectors should equal the number of channels */
+	msixcnt = device->common.chancnt;
+	for (i = 0; i < msixcnt; i++)
+		device->msix_entries[i].entry = i;
+
+	err = pci_enable_msix(device->pdev, device->msix_entries, msixcnt);
+	if (err < 0)
+		goto msi;
+	if (err > 0)
+		goto msix_single_vector;
+
+	for (i = 0; i < msixcnt; i++) {
+		ioat_chan = ioat_lookup_chan_by_index(device, i);
+		err = request_irq(device->msix_entries[i].vector,
+				  ioat_dma_do_interrupt_msix,
+				  0, "ioat-msix", ioat_chan);
+		if (err) {
+			for (j = 0; j < i; j++) {
+				ioat_chan =
+					ioat_lookup_chan_by_index(device, j);
+				free_irq(device->msix_entries[j].vector,
+					 ioat_chan);
+			}
+			goto msix_single_vector;
+		}
+	}
+	intrctrl |= IOAT_INTRCTRL_MSIX_VECTOR_CONTROL;
+	device->irq_mode = msix_multi_vector;
+	goto done;
+
+msix_single_vector:
+	device->msix_entries[0].entry = 0;
+	err = pci_enable_msix(device->pdev, device->msix_entries, 1);
+	if (err)
+		goto msi;
+
+	err = request_irq(device->msix_entries[0].vector, ioat_dma_do_interrupt,
+			  0, "ioat-msix", device);
+	if (err) {
+		pci_disable_msix(device->pdev);
+		goto msi;
+	}
+	device->irq_mode = msix_single_vector;
+	goto done;
+
+msi:
+	err = pci_enable_msi(device->pdev);
+	if (err)
+		goto intx;
+
+	err = request_irq(device->pdev->irq, ioat_dma_do_interrupt,
+			  0, "ioat-msi", device);
+	if (err) {
+		pci_disable_msi(device->pdev);
+		goto intx;
+	}
+	/*
+	 * CB 1.2 devices need a bit set in configuration space to enable MSI
+	 */
+	if (device->version == IOAT_VER_1_2) {
+		u32 dmactrl;
+		pci_read_config_dword(device->pdev,
+				      IOAT_PCI_DMACTRL_OFFSET, &dmactrl);
+		dmactrl |= IOAT_PCI_DMACTRL_MSI_EN;
+		pci_write_config_dword(device->pdev,
+				       IOAT_PCI_DMACTRL_OFFSET, dmactrl);
+	}
+	device->irq_mode = msi;
+	goto done;
+
+intx:
+	err = request_irq(device->pdev->irq, ioat_dma_do_interrupt,
+			  IRQF_SHARED, "ioat-intx", device);
+	if (err)
+		goto err_no_irq;
+	device->irq_mode = intx;
+
+done:
+	intrctrl |= IOAT_INTRCTRL_MASTER_INT_EN;
+	writeb(intrctrl, device->reg_base + IOAT_INTRCTRL_OFFSET);
+	return 0;
+
+err_no_irq:
+	/* Disable all interrupt generation */
+	writeb(0, device->reg_base + IOAT_INTRCTRL_OFFSET);
+	dev_err(&device->pdev->dev, "no usable interrupts\n");
+	device->irq_mode = none;
+	return -1;
+}
+
+/**
+ * ioat_dma_remove_interrupts - remove whatever interrupts were set
+ * @device: ioat device
+ */
+static void ioat_dma_remove_interrupts(struct ioatdma_device *device)
+{
+	struct ioat_dma_chan *ioat_chan;
+	int i;
+
+	/* Disable all interrupt generation */
+	writeb(0, device->reg_base + IOAT_INTRCTRL_OFFSET);
+
+	switch (device->irq_mode) {
+	case msix_multi_vector:
+		for (i = 0; i < device->common.chancnt; i++) {
+			ioat_chan = ioat_lookup_chan_by_index(device, i);
+			free_irq(device->msix_entries[i].vector, ioat_chan);
+		}
+		pci_disable_msix(device->pdev);
+		break;
+	case msix_single_vector:
+		free_irq(device->msix_entries[0].vector, device);
+		pci_disable_msix(device->pdev);
+		break;
+	case msi:
+		free_irq(device->pdev->irq, device);
+		pci_disable_msi(device->pdev);
+		break;
+	case intx:
+		free_irq(device->pdev->irq, device);
+		break;
+	case none:
+		dev_warn(&device->pdev->dev,
+			 "call to %s without interrupts setup\n", __func__);
+	}
+	device->irq_mode = none;
+}
+
 struct ioatdma_device *ioat_dma_probe(struct pci_dev *pdev,
 				      void __iomem *iobase)
 {
@@ -684,21 +905,16 @@ struct ioatdma_device *ioat_dma_probe(st
 	device->common.device_issue_pending = ioat_dma_memcpy_issue_pending;
 	device->common.device_dependency_added = ioat_dma_dependency_added;
 	device->common.dev = &pdev->dev;
-	printk(KERN_INFO "ioatdma: Intel(R) I/OAT DMA Engine found,"
-	       " %d channels, device version 0x%02x\n",
-	       device->common.chancnt, device->version);
-
-	pci_set_drvdata(pdev, device);
-	err = request_irq(pdev->irq, &ioat_do_interrupt, IRQF_SHARED, "ioat",
-		device);
-	if (err)
-		goto err_irq;
+	dev_err(&device->pdev->dev,
+		"ioatdma: Intel(R) I/OAT DMA Engine found,"
+		" %d channels, device version 0x%02x\n",
+		device->common.chancnt, device->version);
 
-	writeb(IOAT_INTRCTRL_MASTER_INT_EN,
-	       device->reg_base + IOAT_INTRCTRL_OFFSET);
-	pci_set_master(pdev);
+	err = ioat_dma_setup_interrupts(device);
+	if (err)
+		goto err_setup_interrupts;
 
-	err = ioat_self_test(device);
+	err = ioat_dma_self_test(device);
 	if (err)
 		goto err_self_test;
 
@@ -707,8 +923,8 @@ struct ioatdma_device *ioat_dma_probe(st
 	return device;
 
 err_self_test:
-	free_irq(device->pdev->irq, device);
-err_irq:
+	ioat_dma_remove_interrupts(device);
+err_setup_interrupts:
 	pci_pool_destroy(device->completion_pool);
 err_completion_pool:
 	pci_pool_destroy(device->dma_pool);
@@ -716,8 +932,8 @@ err_dma_pool:
 	kfree(device);
 err_kzalloc:
 	iounmap(iobase);
-	printk(KERN_ERR
-	       "ioatdma: Intel(R) I/OAT DMA Engine initialization failed\n");
+	dev_err(&device->pdev->dev,
+		"ioatdma: Intel(R) I/OAT DMA Engine initialization failed\n");
 	return NULL;
 }
 
@@ -728,7 +944,7 @@ void ioat_dma_remove(struct ioatdma_devi
 
 	dma_async_device_unregister(&device->common);
 
-	free_irq(device->pdev->irq, device);
+	ioat_dma_remove_interrupts(device);
 
 	pci_pool_destroy(device->dma_pool);
 	pci_pool_destroy(device->completion_pool);
diff -puN drivers/dma/ioatdma.h~i-oat-add-support-for-msi-and-msi-x drivers/dma/ioatdma.h
--- a/drivers/dma/ioatdma.h~i-oat-add-support-for-msi-and-msi-x
+++ a/drivers/dma/ioatdma.h
@@ -28,6 +28,14 @@
 #include <linux/cache.h>
 #include <linux/pci_ids.h>
 
+enum ioat_interrupt {
+	none = 0,
+	msix_multi_vector = 1,
+	msix_single_vector = 2,
+	msi = 3,
+	intx = 4,
+};
+
 #define IOAT_LOW_COMPLETION_MASK	0xffffffc0
 
 /**
@@ -46,6 +54,9 @@ struct ioatdma_device {
 	struct pci_pool *completion_pool;
 	struct dma_device common;
 	u8 version;
+	enum ioat_interrupt irq_mode;
+	struct msix_entry msix_entries[4];
+	struct ioat_dma_chan *idx[4];
 };
 
 /**
@@ -94,6 +105,7 @@ struct ioat_dma_chan {
 			u32 high;
 		};
 	} *completion_virt;
+	struct tasklet_struct cleanup_task;
 };
 
 /* wrapper around hardware descriptor format + additional software fields */
diff -puN drivers/dma/ioatdma_registers.h~i-oat-add-support-for-msi-and-msi-x drivers/dma/ioatdma_registers.h
--- a/drivers/dma/ioatdma_registers.h~i-oat-add-support-for-msi-and-msi-x
+++ a/drivers/dma/ioatdma_registers.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2004 - 2006 Intel Corporation. All rights reserved.
+ * Copyright(c) 2004 - 2007 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -21,6 +21,9 @@
 #ifndef _IOAT_REGISTERS_H_
 #define _IOAT_REGISTERS_H_
 
+#define IOAT_PCI_DMACTRL_OFFSET			0x48
+#define IOAT_PCI_DMACTRL_DMA_EN			0x00000001
+#define IOAT_PCI_DMACTRL_MSI_EN			0x00000002
 
 /* MMIO Device Registers */
 #define IOAT_CHANCNT_OFFSET			0x00	/*  8-bit */
@@ -39,6 +42,7 @@
 #define IOAT_INTRCTRL_MASTER_INT_EN		0x01	/* Master Interrupt Enable */
 #define IOAT_INTRCTRL_INT_STATUS		0x02	/* ATTNSTATUS -or- Channel Int */
 #define IOAT_INTRCTRL_INT			0x04	/* INT_STATUS -and- MASTER_INT_EN */
+#define IOAT_INTRCTRL_MSIX_VECTOR_CONTROL	0x08    /* Enable all MSI-X vectors */
 
 #define IOAT_ATTNSTATUS_OFFSET			0x04	/* Each bit is a channel */
 
diff -puN include/linux/bitops.h~i-oat-add-support-for-msi-and-msi-x include/linux/bitops.h
--- a/include/linux/bitops.h~i-oat-add-support-for-msi-and-msi-x
+++ a/include/linux/bitops.h
@@ -8,6 +8,12 @@
  */
 #include <asm/bitops.h>
 
+#define for_each_bit(bit, addr, size) \
+	for ((bit) = find_first_bit((addr), (size)); \
+	     (bit) < (size); \
+	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+
+
 static __inline__ int get_bitmask_order(unsigned int count)
 {
 	int order;
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

origin.patch
remove-unsafe-from-module-struct.patch
