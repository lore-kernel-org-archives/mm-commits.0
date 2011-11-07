From: akpm@linux-foundation.org
Subject: [merged] rapidio-add-mport-driver-for-tsi721-bridge.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:28:33 -0800
Message-ID: <201111072028.pA7KSXPB021981@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:6447 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGUcJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:32:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, chul.kim@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: RapidIO: add mport driver for Tsi721 bridge
has been removed from the -mm tree.  Its filename was
     rapidio-add-mport-driver-for-tsi721-bridge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: RapidIO: add mport driver for Tsi721 bridge

Add RapidIO mport driver for IDT TSI721 PCI Express-to-SRIO bridge device.
 The driver provides full set of callback functions defined for mport
devices in RapidIO subsystem.  It also is compatible with current version
of RIONET driver (Ethernet over RapidIO messaging services).

This patch is applicable to kernel versions starting from 2.6.39.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Chul Kim <chul.kim@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rapidio/tsi721.txt |   49 
 drivers/rapidio/Kconfig          |    6 
 drivers/rapidio/Makefile         |    1 
 drivers/rapidio/devices/Kconfig  |   10 
 drivers/rapidio/devices/Makefile |    5 
 drivers/rapidio/devices/tsi721.c | 2360 +++++++++++++++++++++++++++++
 drivers/rapidio/devices/tsi721.h |  766 +++++++++
 include/linux/rio_ids.h          |    1 
 8 files changed, 3196 insertions(+), 2 deletions(-)

diff -puN /dev/null Documentation/rapidio/tsi721.txt
--- /dev/null
+++ a/Documentation/rapidio/tsi721.txt
@@ -0,0 +1,49 @@
+RapidIO subsystem mport driver for IDT Tsi721 PCI Express-to-SRIO bridge.
+=========================================================================
+
+I. Overview
+
+This driver implements all currently defined RapidIO mport callback functions.
+It supports maintenance read and write operations, inbound and outbound RapidIO
+doorbells, inbound maintenance port-writes and RapidIO messaging.
+
+To generate SRIO maintenance transactions this driver uses one of Tsi721 DMA
+channels. This mechanism provides access to larger range of hop counts and
+destination IDs without need for changes in outbound window translation.
+
+RapidIO messaging support uses dedicated messaging channels for each mailbox.
+For inbound messages this driver uses destination ID matching to forward messages
+into the corresponding message queue. Messaging callbacks are implemented to be
+fully compatible with RIONET driver (Ethernet over RapidIO messaging services).
+
+II. Known problems
+
+  None.
+
+III. To do
+
+ Add DMA data transfers (non-messaging).
+ Add inbound region (SRIO-to-PCIe) mapping.
+
+IV. Version History
+
+  1.0.0 - Initial driver release.
+
+V.  License
+-----------------------------------------------
+
+  Copyright(c) 2011 Integrated Device Technology, Inc. All rights reserved.
+
+  This program is free software; you can redistribute it and/or modify it
+  under the terms of the GNU General Public License as published by the Free
+  Software Foundation; either version 2 of the License, or (at your option)
+  any later version.
+
+  This program is distributed in the hope that it will be useful, but WITHOUT
+  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+  more details.
+
+  You should have received a copy of the GNU General Public License along with
+  this program; if not, write to the Free Software Foundation, Inc.,
+  59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
diff -puN drivers/rapidio/Kconfig~rapidio-add-mport-driver-for-tsi721-bridge drivers/rapidio/Kconfig
--- a/drivers/rapidio/Kconfig~rapidio-add-mport-driver-for-tsi721-bridge
+++ a/drivers/rapidio/Kconfig
@@ -1,6 +1,8 @@
 #
 # RapidIO configuration
 #
+source "drivers/rapidio/devices/Kconfig"
+
 config RAPIDIO_DISC_TIMEOUT
 	int "Discovery timeout duration (seconds)"
 	depends on RAPIDIO
@@ -20,8 +22,6 @@ config RAPIDIO_ENABLE_RX_TX_PORTS
 	  ports for Input/Output direction to allow other traffic
 	  than Maintenance transfers.
 
-source "drivers/rapidio/switches/Kconfig"
-
 config RAPIDIO_DEBUG
 	bool "RapidIO subsystem debug messages"
 	depends on RAPIDIO
@@ -32,3 +32,5 @@ config RAPIDIO_DEBUG
 	  going on.
 
 	  If you are unsure about this, say N here.
+
+source "drivers/rapidio/switches/Kconfig"
diff -puN drivers/rapidio/Makefile~rapidio-add-mport-driver-for-tsi721-bridge drivers/rapidio/Makefile
--- a/drivers/rapidio/Makefile~rapidio-add-mport-driver-for-tsi721-bridge
+++ a/drivers/rapidio/Makefile
@@ -4,5 +4,6 @@
 obj-y += rio.o rio-access.o rio-driver.o rio-scan.o rio-sysfs.o
 
 obj-$(CONFIG_RAPIDIO)		+= switches/
+obj-$(CONFIG_RAPIDIO)		+= devices/
 
 subdir-ccflags-$(CONFIG_RAPIDIO_DEBUG) := -DDEBUG
diff -puN /dev/null drivers/rapidio/devices/Kconfig
--- /dev/null
+++ a/drivers/rapidio/devices/Kconfig
@@ -0,0 +1,10 @@
+#
+# RapidIO master port configuration
+#
+
+config RAPIDIO_TSI721
+	bool "IDT Tsi721 PCI Express SRIO Controller support"
+	depends on RAPIDIO && PCIEPORTBUS
+	default "n"
+	---help---
+	  Include support for IDT Tsi721 PCI Express Serial RapidIO controller.
diff -puN /dev/null drivers/rapidio/devices/Makefile
--- /dev/null
+++ a/drivers/rapidio/devices/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for RapidIO devices
+#
+
+obj-$(CONFIG_RAPIDIO_TSI721)	+= tsi721.o
diff -puN /dev/null drivers/rapidio/devices/tsi721.c
--- /dev/null
+++ a/drivers/rapidio/devices/tsi721.c
@@ -0,0 +1,2360 @@
+/*
+ * RapidIO mport driver for Tsi721 PCIExpress-to-SRIO bridge
+ *
+ * Copyright 2011 Integrated Device Technology, Inc.
+ * Alexandre Bounine <alexandre.bounine@idt.com>
+ * Chul Kim <chul.kim@idt.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/rio.h>
+#include <linux/rio_drv.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/kfifo.h>
+#include <linux/delay.h>
+
+#include "tsi721.h"
+
+#define DEBUG_PW	/* Inbound Port-Write debugging */
+
+static void tsi721_omsg_handler(struct tsi721_device *priv, int ch);
+static void tsi721_imsg_handler(struct tsi721_device *priv, int ch);
+
+/**
+ * tsi721_lcread - read from local SREP config space
+ * @mport: RapidIO master port info
+ * @index: ID of RapdiIO interface
+ * @offset: Offset into configuration space
+ * @len: Length (in bytes) of the maintenance transaction
+ * @data: Value to be read into
+ *
+ * Generates a local SREP space read. Returns %0 on
+ * success or %-EINVAL on failure.
+ */
+static int tsi721_lcread(struct rio_mport *mport, int index, u32 offset,
+			 int len, u32 *data)
+{
+	struct tsi721_device *priv = mport->priv;
+
+	if (len != sizeof(u32))
+		return -EINVAL; /* only 32-bit access is supported */
+
+	*data = ioread32(priv->regs + offset);
+
+	return 0;
+}
+
+/**
+ * tsi721_lcwrite - write into local SREP config space
+ * @mport: RapidIO master port info
+ * @index: ID of RapdiIO interface
+ * @offset: Offset into configuration space
+ * @len: Length (in bytes) of the maintenance transaction
+ * @data: Value to be written
+ *
+ * Generates a local write into SREP configuration space. Returns %0 on
+ * success or %-EINVAL on failure.
+ */
+static int tsi721_lcwrite(struct rio_mport *mport, int index, u32 offset,
+			  int len, u32 data)
+{
+	struct tsi721_device *priv = mport->priv;
+
+	if (len != sizeof(u32))
+		return -EINVAL; /* only 32-bit access is supported */
+
+	iowrite32(data, priv->regs + offset);
+
+	return 0;
+}
+
+/**
+ * tsi721_maint_dma - Helper function to generate RapidIO maintenance
+ *                    transactions using designated Tsi721 DMA channel.
+ * @priv: pointer to tsi721 private data
+ * @sys_size: RapdiIO transport system size
+ * @destid: Destination ID of transaction
+ * @hopcount: Number of hops to target device
+ * @offset: Offset into configuration space
+ * @len: Length (in bytes) of the maintenance transaction
+ * @data: Location to be read from or write into
+ * @do_wr: Operation flag (1 == MAINT_WR)
+ *
+ * Generates a RapidIO maintenance transaction (Read or Write).
+ * Returns %0 on success and %-EINVAL or %-EFAULT on failure.
+ */
+static int tsi721_maint_dma(struct tsi721_device *priv, u32 sys_size,
+			u16 destid, u8 hopcount, u32 offset, int len,
+			u32 *data, int do_wr)
+{
+	struct tsi721_dma_desc *bd_ptr;
+	u32 rd_count, swr_ptr, ch_stat;
+	int i, err = 0;
+	u32 op = do_wr ? MAINT_WR : MAINT_RD;
+
+	if (offset > (RIO_MAINT_SPACE_SZ - len) || (len != sizeof(u32)))
+		return -EINVAL;
+
+	bd_ptr = priv->bdma[TSI721_DMACH_MAINT].bd_base;
+
+	rd_count = ioread32(
+			priv->regs + TSI721_DMAC_DRDCNT(TSI721_DMACH_MAINT));
+
+	/* Initialize DMA descriptor */
+	bd_ptr[0].type_id = cpu_to_le32((DTYPE2 << 29) | (op << 19) | destid);
+	bd_ptr[0].bcount = cpu_to_le32((sys_size << 26) | 0x04);
+	bd_ptr[0].raddr_lo = cpu_to_le32((hopcount << 24) | offset);
+	bd_ptr[0].raddr_hi = 0;
+	if (do_wr)
+		bd_ptr[0].data[0] = cpu_to_be32p(data);
+	else
+		bd_ptr[0].data[0] = 0xffffffff;
+
+	mb();
+
+	/* Start DMA operation */
+	iowrite32(rd_count + 2,
+		priv->regs + TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
+	ioread32(priv->regs + TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
+	i = 0;
+
+	/* Wait until DMA transfer is finished */
+	while ((ch_stat = ioread32(priv->regs +
+		TSI721_DMAC_STS(TSI721_DMACH_MAINT))) & TSI721_DMAC_STS_RUN) {
+		udelay(1);
+		if (++i >= 5000000) {
+			dev_dbg(&priv->pdev->dev,
+				"%s : DMA[%d] read timeout ch_status=%x\n",
+				__func__, TSI721_DMACH_MAINT, ch_stat);
+			if (!do_wr)
+				*data = 0xffffffff;
+			err = -EIO;
+			goto err_out;
+		}
+	}
+
+	if (ch_stat & TSI721_DMAC_STS_ABORT) {
+		/* If DMA operation aborted due to error,
+		 * reinitialize DMA channel
+		 */
+		dev_dbg(&priv->pdev->dev, "%s : DMA ABORT ch_stat=%x\n",
+			__func__, ch_stat);
+		dev_dbg(&priv->pdev->dev, "OP=%d : destid=%x hc=%x off=%x\n",
+			do_wr ? MAINT_WR : MAINT_RD, destid, hopcount, offset);
+		iowrite32(TSI721_DMAC_INT_ALL,
+			priv->regs + TSI721_DMAC_INT(TSI721_DMACH_MAINT));
+		iowrite32(TSI721_DMAC_CTL_INIT,
+			priv->regs + TSI721_DMAC_CTL(TSI721_DMACH_MAINT));
+		udelay(10);
+		iowrite32(0, priv->regs +
+				TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
+		udelay(1);
+		if (!do_wr)
+			*data = 0xffffffff;
+		err = -EIO;
+		goto err_out;
+	}
+
+	if (!do_wr)
+		*data = be32_to_cpu(bd_ptr[0].data[0]);
+
+	/*
+	 * Update descriptor status FIFO RD pointer.
+	 * NOTE: Skipping check and clear FIFO entries because we are waiting
+	 * for transfer to be completed.
+	 */
+	swr_ptr = ioread32(priv->regs + TSI721_DMAC_DSWP(TSI721_DMACH_MAINT));
+	iowrite32(swr_ptr, priv->regs + TSI721_DMAC_DSRP(TSI721_DMACH_MAINT));
+err_out:
+
+	return err;
+}
+
+/**
+ * tsi721_cread_dma - Generate a RapidIO maintenance read transaction
+ *                    using Tsi721 BDMA engine.
+ * @mport: RapidIO master port control structure
+ * @index: ID of RapdiIO interface
+ * @destid: Destination ID of transaction
+ * @hopcount: Number of hops to target device
+ * @offset: Offset into configuration space
+ * @len: Length (in bytes) of the maintenance transaction
+ * @val: Location to be read into
+ *
+ * Generates a RapidIO maintenance read transaction.
+ * Returns %0 on success and %-EINVAL or %-EFAULT on failure.
+ */
+static int tsi721_cread_dma(struct rio_mport *mport, int index, u16 destid,
+			u8 hopcount, u32 offset, int len, u32 *data)
+{
+	struct tsi721_device *priv = mport->priv;
+
+	return tsi721_maint_dma(priv, mport->sys_size, destid, hopcount,
+				offset, len, data, 0);
+}
+
+/**
+ * tsi721_cwrite_dma - Generate a RapidIO maintenance write transaction
+ *                     using Tsi721 BDMA engine
+ * @mport: RapidIO master port control structure
+ * @index: ID of RapdiIO interface
+ * @destid: Destination ID of transaction
+ * @hopcount: Number of hops to target device
+ * @offset: Offset into configuration space
+ * @len: Length (in bytes) of the maintenance transaction
+ * @val: Value to be written
+ *
+ * Generates a RapidIO maintenance write transaction.
+ * Returns %0 on success and %-EINVAL or %-EFAULT on failure.
+ */
+static int tsi721_cwrite_dma(struct rio_mport *mport, int index, u16 destid,
+			 u8 hopcount, u32 offset, int len, u32 data)
+{
+	struct tsi721_device *priv = mport->priv;
+	u32 temp = data;
+
+	return tsi721_maint_dma(priv, mport->sys_size, destid, hopcount,
+				offset, len, &temp, 1);
+}
+
+/**
+ * tsi721_pw_handler - Tsi721 inbound port-write interrupt handler
+ * @mport: RapidIO master port structure
+ *
+ * Handles inbound port-write interrupts. Copies PW message from an internal
+ * buffer into PW message FIFO and schedules deferred routine to process
+ * queued messages.
+ */
+static int
+tsi721_pw_handler(struct rio_mport *mport)
+{
+	struct tsi721_device *priv = mport->priv;
+	u32 pw_stat;
+	u32 pw_buf[TSI721_RIO_PW_MSG_SIZE/sizeof(u32)];
+
+
+	pw_stat = ioread32(priv->regs + TSI721_RIO_PW_RX_STAT);
+
+	if (pw_stat & TSI721_RIO_PW_RX_STAT_PW_VAL) {
+		pw_buf[0] = ioread32(priv->regs + TSI721_RIO_PW_RX_CAPT(0));
+		pw_buf[1] = ioread32(priv->regs + TSI721_RIO_PW_RX_CAPT(1));
+		pw_buf[2] = ioread32(priv->regs + TSI721_RIO_PW_RX_CAPT(2));
+		pw_buf[3] = ioread32(priv->regs + TSI721_RIO_PW_RX_CAPT(3));
+
+		/* Queue PW message (if there is room in FIFO),
+		 * otherwise discard it.
+		 */
+		spin_lock(&priv->pw_fifo_lock);
+		if (kfifo_avail(&priv->pw_fifo) >= TSI721_RIO_PW_MSG_SIZE)
+			kfifo_in(&priv->pw_fifo, pw_buf,
+						TSI721_RIO_PW_MSG_SIZE);
+		else
+			priv->pw_discard_count++;
+		spin_unlock(&priv->pw_fifo_lock);
+	}
+
+	/* Clear pending PW interrupts */
+	iowrite32(TSI721_RIO_PW_RX_STAT_PW_DISC | TSI721_RIO_PW_RX_STAT_PW_VAL,
+		  priv->regs + TSI721_RIO_PW_RX_STAT);
+
+	schedule_work(&priv->pw_work);
+
+	return 0;
+}
+
+static void tsi721_pw_dpc(struct work_struct *work)
+{
+	struct tsi721_device *priv = container_of(work, struct tsi721_device,
+						    pw_work);
+	u32 msg_buffer[RIO_PW_MSG_SIZE/sizeof(u32)]; /* Use full size PW message
+							buffer for RIO layer */
+
+	/*
+	 * Process port-write messages
+	 */
+	while (kfifo_out_spinlocked(&priv->pw_fifo, (unsigned char *)msg_buffer,
+			 TSI721_RIO_PW_MSG_SIZE, &priv->pw_fifo_lock)) {
+		/* Process one message */
+#ifdef DEBUG_PW
+		{
+		u32 i;
+		pr_debug("%s : Port-Write Message:", __func__);
+		for (i = 0; i < RIO_PW_MSG_SIZE/sizeof(u32); ) {
+			pr_debug("0x%02x: %08x %08x %08x %08x", i*4,
+				msg_buffer[i], msg_buffer[i + 1],
+				msg_buffer[i + 2], msg_buffer[i + 3]);
+			i += 4;
+		}
+		pr_debug("\n");
+		}
+#endif
+		/* Pass the port-write message to RIO core for processing */
+		rio_inb_pwrite_handler((union rio_pw_msg *)msg_buffer);
+	}
+}
+
+/**
+ * tsi721_pw_enable - enable/disable port-write interface init
+ * @mport: Master port implementing the port write unit
+ * @enable:    1=enable; 0=disable port-write message handling
+ */
+static int tsi721_pw_enable(struct rio_mport *mport, int enable)
+{
+	struct tsi721_device *priv = mport->priv;
+	u32 rval;
+
+	rval = ioread32(priv->regs + TSI721_RIO_EM_INT_ENABLE);
+
+	if (enable)
+		rval |= TSI721_RIO_EM_INT_ENABLE_PW_RX;
+	else
+		rval &= ~TSI721_RIO_EM_INT_ENABLE_PW_RX;
+
+	/* Clear pending PW interrupts */
+	iowrite32(TSI721_RIO_PW_RX_STAT_PW_DISC | TSI721_RIO_PW_RX_STAT_PW_VAL,
+		  priv->regs + TSI721_RIO_PW_RX_STAT);
+	/* Update enable bits */
+	iowrite32(rval, priv->regs + TSI721_RIO_EM_INT_ENABLE);
+
+	return 0;
+}
+
+/**
+ * tsi721_dsend - Send a RapidIO doorbell
+ * @mport: RapidIO master port info
+ * @index: ID of RapidIO interface
+ * @destid: Destination ID of target device
+ * @data: 16-bit info field of RapidIO doorbell
+ *
+ * Sends a RapidIO doorbell message. Always returns %0.
+ */
+static int tsi721_dsend(struct rio_mport *mport, int index,
+			u16 destid, u16 data)
+{
+	struct tsi721_device *priv = mport->priv;
+	u32 offset;
+
+	offset = (((mport->sys_size) ? RIO_TT_CODE_16 : RIO_TT_CODE_8) << 18) |
+		 (destid << 2);
+
+	dev_dbg(&priv->pdev->dev,
+		"Send Doorbell 0x%04x to destID 0x%x\n", data, destid);
+	iowrite16be(data, priv->odb_base + offset);
+
+	return 0;
+}
+
+/**
+ * tsi721_dbell_handler - Tsi721 doorbell interrupt handler
+ * @mport: RapidIO master port structure
+ *
+ * Handles inbound doorbell interrupts. Copies doorbell entry from an internal
+ * buffer into DB message FIFO and schedules deferred  routine to process
+ * queued DBs.
+ */
+static int
+tsi721_dbell_handler(struct rio_mport *mport)
+{
+	struct tsi721_device *priv = mport->priv;
+	u32 regval;
+
+	/* Disable IDB interrupts */
+	regval = ioread32(priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
+	regval &= ~TSI721_SR_CHINT_IDBQRCV;
+	iowrite32(regval,
+		priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
+
+	schedule_work(&priv->idb_work);
+
+	return 0;
+}
+
+static void tsi721_db_dpc(struct work_struct *work)
+{
+	struct tsi721_device *priv = container_of(work, struct tsi721_device,
+						    idb_work);
+	struct rio_mport *mport;
+	struct rio_dbell *dbell;
+	int found = 0;
+	u32 wr_ptr, rd_ptr;
+	u64 *idb_entry;
+	u32 regval;
+	union {
+		u64 msg;
+		u8  bytes[8];
+	} idb;
+
+	/*
+	 * Process queued inbound doorbells
+	 */
+	mport = priv->mport;
+
+	wr_ptr = ioread32(priv->regs + TSI721_IDQ_WP(IDB_QUEUE));
+	rd_ptr = ioread32(priv->regs + TSI721_IDQ_RP(IDB_QUEUE));
+
+	while (wr_ptr != rd_ptr) {
+		idb_entry = (u64 *)(priv->idb_base +
+					(TSI721_IDB_ENTRY_SIZE * rd_ptr));
+		rd_ptr++;
+		idb.msg = *idb_entry;
+		*idb_entry = 0;
+
+		/* Process one doorbell */
+		list_for_each_entry(dbell, &mport->dbells, node) {
+			if ((dbell->res->start <= DBELL_INF(idb.bytes)) &&
+			    (dbell->res->end >= DBELL_INF(idb.bytes))) {
+				found = 1;
+				break;
+			}
+		}
+
+		if (found) {
+			dbell->dinb(mport, dbell->dev_id, DBELL_SID(idb.bytes),
+				    DBELL_TID(idb.bytes), DBELL_INF(idb.bytes));
+		} else {
+			dev_dbg(&priv->pdev->dev,
+				"spurious inb doorbell, sid %2.2x tid %2.2x"
+				" info %4.4x\n", DBELL_SID(idb.bytes),
+				DBELL_TID(idb.bytes), DBELL_INF(idb.bytes));
+		}
+	}
+
+	iowrite32(rd_ptr & (IDB_QSIZE - 1),
+		priv->regs + TSI721_IDQ_RP(IDB_QUEUE));
+
+	/* Re-enable IDB interrupts */
+	regval = ioread32(priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
+	regval |= TSI721_SR_CHINT_IDBQRCV;
+	iowrite32(regval,
+		priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
+}
+
+/**
+ * tsi721_irqhandler - Tsi721 interrupt handler
+ * @irq: Linux interrupt number
+ * @ptr: Pointer to interrupt-specific data (mport structure)
+ *
+ * Handles Tsi721 interrupts signaled using MSI and INTA. Checks reported
+ * interrupt events and calls an event-specific handler(s).
+ */
+static irqreturn_t tsi721_irqhandler(int irq, void *ptr)
+{
+	struct rio_mport *mport = (struct rio_mport *)ptr;
+	struct tsi721_device *priv = mport->priv;
+	u32 dev_int;
+	u32 dev_ch_int;
+	u32 intval;
+	u32 ch_inte;
+
+	dev_int = ioread32(priv->regs + TSI721_DEV_INT);
+	if (!dev_int)
+		return IRQ_NONE;
+
+	dev_ch_int = ioread32(priv->regs + TSI721_DEV_CHAN_INT);
+
+	if (dev_int & TSI721_DEV_INT_SR2PC_CH) {
+		/* Service SR2PC Channel interrupts */
+		if (dev_ch_int & TSI721_INT_SR2PC_CHAN(IDB_QUEUE)) {
+			/* Service Inbound Doorbell interrupt */
+			intval = ioread32(priv->regs +
+						TSI721_SR_CHINT(IDB_QUEUE));
+			if (intval & TSI721_SR_CHINT_IDBQRCV)
+				tsi721_dbell_handler(mport);
+			else
+				dev_info(&priv->pdev->dev,
+					"Unsupported SR_CH_INT %x\n", intval);
+
+			/* Clear interrupts */
+			iowrite32(intval,
+				priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
+			ioread32(priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
+		}
+	}
+
+	if (dev_int & TSI721_DEV_INT_SMSG_CH) {
+		int ch;
+
+		/*
+		 * Service channel interrupts from Messaging Engine
+		 */
+
+		if (dev_ch_int & TSI721_INT_IMSG_CHAN_M) { /* Inbound Msg */
+			/* Disable signaled OB MSG Channel interrupts */
+			ch_inte = ioread32(priv->regs + TSI721_DEV_CHAN_INTE);
+			ch_inte &= ~(dev_ch_int & TSI721_INT_IMSG_CHAN_M);
+			iowrite32(ch_inte, priv->regs + TSI721_DEV_CHAN_INTE);
+
+			/*
+			 * Process Inbound Message interrupt for each MBOX
+			 */
+			for (ch = 4; ch < RIO_MAX_MBOX + 4; ch++) {
+				if (!(dev_ch_int & TSI721_INT_IMSG_CHAN(ch)))
+					continue;
+				tsi721_imsg_handler(priv, ch);
+			}
+		}
+
+		if (dev_ch_int & TSI721_INT_OMSG_CHAN_M) { /* Outbound Msg */
+			/* Disable signaled OB MSG Channel interrupts */
+			ch_inte = ioread32(priv->regs + TSI721_DEV_CHAN_INTE);
+			ch_inte &= ~(dev_ch_int & TSI721_INT_OMSG_CHAN_M);
+			iowrite32(ch_inte, priv->regs + TSI721_DEV_CHAN_INTE);
+
+			/*
+			 * Process Outbound Message interrupts for each MBOX
+			 */
+
+			for (ch = 0; ch < RIO_MAX_MBOX; ch++) {
+				if (!(dev_ch_int & TSI721_INT_OMSG_CHAN(ch)))
+					continue;
+				tsi721_omsg_handler(priv, ch);
+			}
+		}
+	}
+
+	if (dev_int & TSI721_DEV_INT_SRIO) {
+		/* Service SRIO MAC interrupts */
+		intval = ioread32(priv->regs + TSI721_RIO_EM_INT_STAT);
+		if (intval & TSI721_RIO_EM_INT_STAT_PW_RX)
+			tsi721_pw_handler(mport);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void tsi721_interrupts_init(struct tsi721_device *priv)
+{
+	u32 intr;
+
+	/* Enable IDB interrupts */
+	iowrite32(TSI721_SR_CHINT_ALL,
+		priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
+	iowrite32(TSI721_SR_CHINT_IDBQRCV,
+		priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
+	iowrite32(TSI721_INT_SR2PC_CHAN(IDB_QUEUE),
+		priv->regs + TSI721_DEV_CHAN_INTE);
+
+	/* Enable SRIO MAC interrupts */
+	iowrite32(TSI721_RIO_EM_DEV_INT_EN_INT,
+		priv->regs + TSI721_RIO_EM_DEV_INT_EN);
+
+	if (priv->flags & TSI721_USING_MSIX)
+		intr = TSI721_DEV_INT_SRIO;
+	else
+		intr = TSI721_DEV_INT_SR2PC_CH | TSI721_DEV_INT_SRIO |
+			TSI721_DEV_INT_SMSG_CH;
+
+	iowrite32(intr, priv->regs + TSI721_DEV_INTE);
+	ioread32(priv->regs + TSI721_DEV_INTE);
+}
+
+#ifdef CONFIG_PCI_MSI
+/**
+ * tsi721_omsg_msix - MSI-X interrupt handler for outbound messaging
+ * @irq: Linux interrupt number
+ * @ptr: Pointer to interrupt-specific data (mport structure)
+ *
+ * Handles outbound messaging interrupts signaled using MSI-X.
+ */
+static irqreturn_t tsi721_omsg_msix(int irq, void *ptr)
+{
+	struct tsi721_device *priv = ((struct rio_mport *)ptr)->priv;
+	int mbox;
+
+	mbox = (irq - priv->msix[TSI721_VECT_OMB0_DONE].vector) % RIO_MAX_MBOX;
+	tsi721_omsg_handler(priv, mbox);
+	return IRQ_HANDLED;
+}
+
+/**
+ * tsi721_imsg_msix - MSI-X interrupt handler for inbound messaging
+ * @irq: Linux interrupt number
+ * @ptr: Pointer to interrupt-specific data (mport structure)
+ *
+ * Handles inbound messaging interrupts signaled using MSI-X.
+ */
+static irqreturn_t tsi721_imsg_msix(int irq, void *ptr)
+{
+	struct tsi721_device *priv = ((struct rio_mport *)ptr)->priv;
+	int mbox;
+
+	mbox = (irq - priv->msix[TSI721_VECT_IMB0_RCV].vector) % RIO_MAX_MBOX;
+	tsi721_imsg_handler(priv, mbox + 4);
+	return IRQ_HANDLED;
+}
+
+/**
+ * tsi721_srio_msix - Tsi721 MSI-X SRIO MAC interrupt handler
+ * @irq: Linux interrupt number
+ * @ptr: Pointer to interrupt-specific data (mport structure)
+ *
+ * Handles Tsi721 interrupts from SRIO MAC.
+ */
+static irqreturn_t tsi721_srio_msix(int irq, void *ptr)
+{
+	struct tsi721_device *priv = ((struct rio_mport *)ptr)->priv;
+	u32 srio_int;
+
+	/* Service SRIO MAC interrupts */
+	srio_int = ioread32(priv->regs + TSI721_RIO_EM_INT_STAT);
+	if (srio_int & TSI721_RIO_EM_INT_STAT_PW_RX)
+		tsi721_pw_handler((struct rio_mport *)ptr);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * tsi721_sr2pc_ch_msix - Tsi721 MSI-X SR2PC Channel interrupt handler
+ * @irq: Linux interrupt number
+ * @ptr: Pointer to interrupt-specific data (mport structure)
+ *
+ * Handles Tsi721 interrupts from SR2PC Channel.
+ * NOTE: At this moment services only one SR2PC channel associated with inbound
+ * doorbells.
+ */
+static irqreturn_t tsi721_sr2pc_ch_msix(int irq, void *ptr)
+{
+	struct tsi721_device *priv = ((struct rio_mport *)ptr)->priv;
+	u32 sr_ch_int;
+
+	/* Service Inbound DB interrupt from SR2PC channel */
+	sr_ch_int = ioread32(priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
+	if (sr_ch_int & TSI721_SR_CHINT_IDBQRCV)
+		tsi721_dbell_handler((struct rio_mport *)ptr);
+
+	/* Clear interrupts */
+	iowrite32(sr_ch_int, priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
+	/* Read back to ensure that interrupt was cleared */
+	sr_ch_int = ioread32(priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * tsi721_request_msix - register interrupt service for MSI-X mode.
+ * @mport: RapidIO master port structure
+ *
+ * Registers MSI-X interrupt service routines for interrupts that are active
+ * immediately after mport initialization. Messaging interrupt service routines
+ * should be registered during corresponding open requests.
+ */
+static int tsi721_request_msix(struct rio_mport *mport)
+{
+	struct tsi721_device *priv = mport->priv;
+	int err = 0;
+
+	err = request_irq(priv->msix[TSI721_VECT_IDB].vector,
+			tsi721_sr2pc_ch_msix, 0,
+			priv->msix[TSI721_VECT_IDB].irq_name, (void *)mport);
+	if (err)
+		goto out;
+
+	err = request_irq(priv->msix[TSI721_VECT_PWRX].vector,
+			tsi721_srio_msix, 0,
+			priv->msix[TSI721_VECT_PWRX].irq_name, (void *)mport);
+	if (err)
+		free_irq(
+			priv->msix[TSI721_VECT_IDB].vector,
+			(void *)mport);
+out:
+	return err;
+}
+
+/**
+ * tsi721_enable_msix - Attempts to enable MSI-X support for Tsi721.
+ * @priv: pointer to tsi721 private data
+ *
+ * Configures MSI-X support for Tsi721. Supports only an exact number
+ * of requested vectors.
+ */
+static int tsi721_enable_msix(struct tsi721_device *priv)
+{
+	struct msix_entry entries[TSI721_VECT_MAX];
+	int err;
+	int i;
+
+	entries[TSI721_VECT_IDB].entry = TSI721_MSIX_SR2PC_IDBQ_RCV(IDB_QUEUE);
+	entries[TSI721_VECT_PWRX].entry = TSI721_MSIX_SRIO_MAC_INT;
+
+	/*
+	 * Initialize MSI-X entries for Messaging Engine:
+	 * this driver supports four RIO mailboxes (inbound and outbound)
+	 * NOTE: Inbound message MBOX 0...4 use IB channels 4...7. Therefore
+	 * offset +4 is added to IB MBOX number.
+	 */
+	for (i = 0; i < RIO_MAX_MBOX; i++) {
+		entries[TSI721_VECT_IMB0_RCV + i].entry =
+					TSI721_MSIX_IMSG_DQ_RCV(i + 4);
+		entries[TSI721_VECT_IMB0_INT + i].entry =
+					TSI721_MSIX_IMSG_INT(i + 4);
+		entries[TSI721_VECT_OMB0_DONE + i].entry =
+					TSI721_MSIX_OMSG_DONE(i);
+		entries[TSI721_VECT_OMB0_INT + i].entry =
+					TSI721_MSIX_OMSG_INT(i);
+	}
+
+	err = pci_enable_msix(priv->pdev, entries, ARRAY_SIZE(entries));
+	if (err) {
+		if (err > 0)
+			dev_info(&priv->pdev->dev,
+				 "Only %d MSI-X vectors available, "
+				 "not using MSI-X\n", err);
+		return err;
+	}
+
+	/*
+	 * Copy MSI-X vector information into tsi721 private structure
+	 */
+	priv->msix[TSI721_VECT_IDB].vector = entries[TSI721_VECT_IDB].vector;
+	snprintf(priv->msix[TSI721_VECT_IDB].irq_name, IRQ_DEVICE_NAME_MAX,
+		 DRV_NAME "-idb@pci:%s", pci_name(priv->pdev));
+	priv->msix[TSI721_VECT_PWRX].vector = entries[TSI721_VECT_PWRX].vector;
+	snprintf(priv->msix[TSI721_VECT_PWRX].irq_name, IRQ_DEVICE_NAME_MAX,
+		 DRV_NAME "-pwrx@pci:%s", pci_name(priv->pdev));
+
+	for (i = 0; i < RIO_MAX_MBOX; i++) {
+		priv->msix[TSI721_VECT_IMB0_RCV + i].vector =
+				entries[TSI721_VECT_IMB0_RCV + i].vector;
+		snprintf(priv->msix[TSI721_VECT_IMB0_RCV + i].irq_name,
+			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-imbr%d@pci:%s",
+			 i, pci_name(priv->pdev));
+
+		priv->msix[TSI721_VECT_IMB0_INT + i].vector =
+				entries[TSI721_VECT_IMB0_INT + i].vector;
+		snprintf(priv->msix[TSI721_VECT_IMB0_INT + i].irq_name,
+			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-imbi%d@pci:%s",
+			 i, pci_name(priv->pdev));
+
+		priv->msix[TSI721_VECT_OMB0_DONE + i].vector =
+				entries[TSI721_VECT_OMB0_DONE + i].vector;
+		snprintf(priv->msix[TSI721_VECT_OMB0_DONE + i].irq_name,
+			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-ombd%d@pci:%s",
+			 i, pci_name(priv->pdev));
+
+		priv->msix[TSI721_VECT_OMB0_INT + i].vector =
+				entries[TSI721_VECT_OMB0_INT + i].vector;
+		snprintf(priv->msix[TSI721_VECT_OMB0_INT + i].irq_name,
+			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-ombi%d@pci:%s",
+			 i, pci_name(priv->pdev));
+	}
+
+	return 0;
+}
+#endif /* CONFIG_PCI_MSI */
+
+static int tsi721_request_irq(struct rio_mport *mport)
+{
+	struct tsi721_device *priv = mport->priv;
+	int err;
+
+#ifdef CONFIG_PCI_MSI
+	if (priv->flags & TSI721_USING_MSIX)
+		err = tsi721_request_msix(mport);
+	else
+#endif
+		err = request_irq(priv->pdev->irq, tsi721_irqhandler,
+			  (priv->flags & TSI721_USING_MSI) ? 0 : IRQF_SHARED,
+			  DRV_NAME, (void *)mport);
+
+	if (err)
+		dev_err(&priv->pdev->dev,
+			"Unable to allocate interrupt, Error: %d\n", err);
+
+	return err;
+}
+
+/**
+ * tsi721_init_pc2sr_mapping - initializes outbound (PCIe->SRIO)
+ * translation regions.
+ * @priv: pointer to tsi721 private data
+ *
+ * Disables SREP translation regions.
+ */
+static void tsi721_init_pc2sr_mapping(struct tsi721_device *priv)
+{
+	int i;
+
+	/* Disable all PC2SR translation windows */
+	for (i = 0; i < TSI721_OBWIN_NUM; i++)
+		iowrite32(0, priv->regs + TSI721_OBWINLB(i));
+}
+
+/**
+ * tsi721_init_sr2pc_mapping - initializes inbound (SRIO->PCIe)
+ * translation regions.
+ * @priv: pointer to tsi721 private data
+ *
+ * Disables inbound windows.
+ */
+static void tsi721_init_sr2pc_mapping(struct tsi721_device *priv)
+{
+	int i;
+
+	/* Disable all SR2PC inbound windows */
+	for (i = 0; i < TSI721_IBWIN_NUM; i++)
+		iowrite32(0, priv->regs + TSI721_IBWINLB(i));
+}
+
+/**
+ * tsi721_port_write_init - Inbound port write interface init
+ * @priv: pointer to tsi721 private data
+ *
+ * Initializes inbound port write handler.
+ * Returns %0 on success or %-ENOMEM on failure.
+ */
+static int tsi721_port_write_init(struct tsi721_device *priv)
+{
+	priv->pw_discard_count = 0;
+	INIT_WORK(&priv->pw_work, tsi721_pw_dpc);
+	spin_lock_init(&priv->pw_fifo_lock);
+	if (kfifo_alloc(&priv->pw_fifo,
+			TSI721_RIO_PW_MSG_SIZE * 32, GFP_KERNEL)) {
+		dev_err(&priv->pdev->dev, "PW FIFO allocation failed\n");
+		return -ENOMEM;
+	}
+
+	/* Use reliable port-write capture mode */
+	iowrite32(TSI721_RIO_PW_CTL_PWC_REL, priv->regs + TSI721_RIO_PW_CTL);
+	return 0;
+}
+
+static int tsi721_doorbell_init(struct tsi721_device *priv)
+{
+	/* Outbound Doorbells do not require any setup.
+	 * Tsi721 uses dedicated PCI BAR1 to generate doorbells.
+	 * That BAR1 was mapped during the probe routine.
+	 */
+
+	/* Initialize Inbound Doorbell processing DPC and queue */
+	priv->db_discard_count = 0;
+	INIT_WORK(&priv->idb_work, tsi721_db_dpc);
+
+	/* Allocate buffer for inbound doorbells queue */
+	priv->idb_base = dma_alloc_coherent(&priv->pdev->dev,
+				IDB_QSIZE * TSI721_IDB_ENTRY_SIZE,
+				&priv->idb_dma, GFP_KERNEL);
+	if (!priv->idb_base)
+		return -ENOMEM;
+
+	memset(priv->idb_base, 0, IDB_QSIZE * TSI721_IDB_ENTRY_SIZE);
+
+	dev_dbg(&priv->pdev->dev, "Allocated IDB buffer @ %p (phys = %llx)\n",
+		priv->idb_base, (unsigned long long)priv->idb_dma);
+
+	iowrite32(TSI721_IDQ_SIZE_VAL(IDB_QSIZE),
+		priv->regs + TSI721_IDQ_SIZE(IDB_QUEUE));
+	iowrite32(((u64)priv->idb_dma >> 32),
+		priv->regs + TSI721_IDQ_BASEU(IDB_QUEUE));
+	iowrite32(((u64)priv->idb_dma & TSI721_IDQ_BASEL_ADDR),
+		priv->regs + TSI721_IDQ_BASEL(IDB_QUEUE));
+	/* Enable accepting all inbound doorbells */
+	iowrite32(0, priv->regs + TSI721_IDQ_MASK(IDB_QUEUE));
+
+	iowrite32(TSI721_IDQ_INIT, priv->regs + TSI721_IDQ_CTL(IDB_QUEUE));
+
+	iowrite32(0, priv->regs + TSI721_IDQ_RP(IDB_QUEUE));
+
+	return 0;
+}
+
+static void tsi721_doorbell_free(struct tsi721_device *priv)
+{
+	if (priv->idb_base == NULL)
+		return;
+
+	/* Free buffer allocated for inbound doorbell queue */
+	dma_free_coherent(&priv->pdev->dev, IDB_QSIZE * TSI721_IDB_ENTRY_SIZE,
+			  priv->idb_base, priv->idb_dma);
+	priv->idb_base = NULL;
+}
+
+static int tsi721_bdma_ch_init(struct tsi721_device *priv, int chnum)
+{
+	struct tsi721_dma_desc *bd_ptr;
+	u64		*sts_ptr;
+	dma_addr_t	bd_phys, sts_phys;
+	int		sts_size;
+	int		bd_num = priv->bdma[chnum].bd_num;
+
+	dev_dbg(&priv->pdev->dev, "Init Block DMA Engine, CH%d\n", chnum);
+
+	/*
+	 * Initialize DMA channel for maintenance requests
+	 */
+
+	/* Allocate space for DMA descriptors */
+	bd_ptr = dma_alloc_coherent(&priv->pdev->dev,
+					bd_num * sizeof(struct tsi721_dma_desc),
+					&bd_phys, GFP_KERNEL);
+	if (!bd_ptr)
+		return -ENOMEM;
+
+	priv->bdma[chnum].bd_phys = bd_phys;
+	priv->bdma[chnum].bd_base = bd_ptr;
+
+	memset(bd_ptr, 0, bd_num * sizeof(struct tsi721_dma_desc));
+
+	dev_dbg(&priv->pdev->dev, "DMA descriptors @ %p (phys = %llx)\n",
+		bd_ptr, (unsigned long long)bd_phys);
+
+	/* Allocate space for descriptor status FIFO */
+	sts_size = (bd_num >= TSI721_DMA_MINSTSSZ) ?
+					bd_num : TSI721_DMA_MINSTSSZ;
+	sts_size = roundup_pow_of_two(sts_size);
+	sts_ptr = dma_alloc_coherent(&priv->pdev->dev,
+				     sts_size * sizeof(struct tsi721_dma_sts),
+				     &sts_phys, GFP_KERNEL);
+	if (!sts_ptr) {
+		/* Free space allocated for DMA descriptors */
+		dma_free_coherent(&priv->pdev->dev,
+				  bd_num * sizeof(struct tsi721_dma_desc),
+				  bd_ptr, bd_phys);
+		priv->bdma[chnum].bd_base = NULL;
+		return -ENOMEM;
+	}
+
+	priv->bdma[chnum].sts_phys = sts_phys;
+	priv->bdma[chnum].sts_base = sts_ptr;
+	priv->bdma[chnum].sts_size = sts_size;
+
+	memset(sts_ptr, 0, sts_size);
+
+	dev_dbg(&priv->pdev->dev,
+		"desc status FIFO @ %p (phys = %llx) size=0x%x\n",
+		sts_ptr, (unsigned long long)sts_phys, sts_size);
+
+	/* Initialize DMA descriptors ring */
+	bd_ptr[bd_num - 1].type_id = cpu_to_le32(DTYPE3 << 29);
+	bd_ptr[bd_num - 1].next_lo = cpu_to_le32((u64)bd_phys &
+						 TSI721_DMAC_DPTRL_MASK);
+	bd_ptr[bd_num - 1].next_hi = cpu_to_le32((u64)bd_phys >> 32);
+
+	/* Setup DMA descriptor pointers */
+	iowrite32(((u64)bd_phys >> 32),
+		priv->regs + TSI721_DMAC_DPTRH(chnum));
+	iowrite32(((u64)bd_phys & TSI721_DMAC_DPTRL_MASK),
+		priv->regs + TSI721_DMAC_DPTRL(chnum));
+
+	/* Setup descriptor status FIFO */
+	iowrite32(((u64)sts_phys >> 32),
+		priv->regs + TSI721_DMAC_DSBH(chnum));
+	iowrite32(((u64)sts_phys & TSI721_DMAC_DSBL_MASK),
+		priv->regs + TSI721_DMAC_DSBL(chnum));
+	iowrite32(TSI721_DMAC_DSSZ_SIZE(sts_size),
+		priv->regs + TSI721_DMAC_DSSZ(chnum));
+
+	/* Clear interrupt bits */
+	iowrite32(TSI721_DMAC_INT_ALL,
+		priv->regs + TSI721_DMAC_INT(chnum));
+
+	ioread32(priv->regs + TSI721_DMAC_INT(chnum));
+
+	/* Toggle DMA channel initialization */
+	iowrite32(TSI721_DMAC_CTL_INIT,	priv->regs + TSI721_DMAC_CTL(chnum));
+	ioread32(priv->regs + TSI721_DMAC_CTL(chnum));
+	udelay(10);
+
+	return 0;
+}
+
+static int tsi721_bdma_ch_free(struct tsi721_device *priv, int chnum)
+{
+	u32 ch_stat;
+
+	if (priv->bdma[chnum].bd_base == NULL)
+		return 0;
+
+	/* Check if DMA channel still running */
+	ch_stat = ioread32(priv->regs +	TSI721_DMAC_STS(chnum));
+	if (ch_stat & TSI721_DMAC_STS_RUN)
+		return -EFAULT;
+
+	/* Put DMA channel into init state */
+	iowrite32(TSI721_DMAC_CTL_INIT,
+		priv->regs + TSI721_DMAC_CTL(chnum));
+
+	/* Free space allocated for DMA descriptors */
+	dma_free_coherent(&priv->pdev->dev,
+		priv->bdma[chnum].bd_num * sizeof(struct tsi721_dma_desc),
+		priv->bdma[chnum].bd_base, priv->bdma[chnum].bd_phys);
+	priv->bdma[chnum].bd_base = NULL;
+
+	/* Free space allocated for status FIFO */
+	dma_free_coherent(&priv->pdev->dev,
+		priv->bdma[chnum].sts_size * sizeof(struct tsi721_dma_sts),
+		priv->bdma[chnum].sts_base, priv->bdma[chnum].sts_phys);
+	priv->bdma[chnum].sts_base = NULL;
+	return 0;
+}
+
+static int tsi721_bdma_init(struct tsi721_device *priv)
+{
+	/* Initialize BDMA channel allocated for RapidIO maintenance read/write
+	 * request generation
+	 */
+	priv->bdma[TSI721_DMACH_MAINT].bd_num = 2;
+	if (tsi721_bdma_ch_init(priv, TSI721_DMACH_MAINT)) {
+		dev_err(&priv->pdev->dev, "Unable to initialize maintenance DMA"
+			" channel %d, aborting\n", TSI721_DMACH_MAINT);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void tsi721_bdma_free(struct tsi721_device *priv)
+{
+	tsi721_bdma_ch_free(priv, TSI721_DMACH_MAINT);
+}
+
+/* Enable Inbound Messaging Interrupts */
+static void
+tsi721_imsg_interrupt_enable(struct tsi721_device *priv, int ch,
+				  u32 inte_mask)
+{
+	u32 rval;
+
+	if (!inte_mask)
+		return;
+
+	/* Clear pending Inbound Messaging interrupts */
+	iowrite32(inte_mask, priv->regs + TSI721_IBDMAC_INT(ch));
+
+	/* Enable Inbound Messaging interrupts */
+	rval = ioread32(priv->regs + TSI721_IBDMAC_INTE(ch));
+	iowrite32(rval | inte_mask, priv->regs + TSI721_IBDMAC_INTE(ch));
+
+	if (priv->flags & TSI721_USING_MSIX)
+		return; /* Finished if we are in MSI-X mode */
+
+	/*
+	 * For MSI and INTA interrupt signalling we need to enable next levels
+	 */
+
+	/* Enable Device Channel Interrupt */
+	rval = ioread32(priv->regs + TSI721_DEV_CHAN_INTE);
+	iowrite32(rval | TSI721_INT_IMSG_CHAN(ch),
+		  priv->regs + TSI721_DEV_CHAN_INTE);
+}
+
+/* Disable Inbound Messaging Interrupts */
+static void
+tsi721_imsg_interrupt_disable(struct tsi721_device *priv, int ch,
+				   u32 inte_mask)
+{
+	u32 rval;
+
+	if (!inte_mask)
+		return;
+
+	/* Clear pending Inbound Messaging interrupts */
+	iowrite32(inte_mask, priv->regs + TSI721_IBDMAC_INT(ch));
+
+	/* Disable Inbound Messaging interrupts */
+	rval = ioread32(priv->regs + TSI721_IBDMAC_INTE(ch));
+	rval &= ~inte_mask;
+	iowrite32(rval, priv->regs + TSI721_IBDMAC_INTE(ch));
+
+	if (priv->flags & TSI721_USING_MSIX)
+		return; /* Finished if we are in MSI-X mode */
+
+	/*
+	 * For MSI and INTA interrupt signalling we need to disable next levels
+	 */
+
+	/* Disable Device Channel Interrupt */
+	rval = ioread32(priv->regs + TSI721_DEV_CHAN_INTE);
+	rval &= ~TSI721_INT_IMSG_CHAN(ch);
+	iowrite32(rval, priv->regs + TSI721_DEV_CHAN_INTE);
+}
+
+/* Enable Outbound Messaging interrupts */
+static void
+tsi721_omsg_interrupt_enable(struct tsi721_device *priv, int ch,
+				  u32 inte_mask)
+{
+	u32 rval;
+
+	if (!inte_mask)
+		return;
+
+	/* Clear pending Outbound Messaging interrupts */
+	iowrite32(inte_mask, priv->regs + TSI721_OBDMAC_INT(ch));
+
+	/* Enable Outbound Messaging channel interrupts */
+	rval = ioread32(priv->regs + TSI721_OBDMAC_INTE(ch));
+	iowrite32(rval | inte_mask, priv->regs + TSI721_OBDMAC_INTE(ch));
+
+	if (priv->flags & TSI721_USING_MSIX)
+		return; /* Finished if we are in MSI-X mode */
+
+	/*
+	 * For MSI and INTA interrupt signalling we need to enable next levels
+	 */
+
+	/* Enable Device Channel Interrupt */
+	rval = ioread32(priv->regs + TSI721_DEV_CHAN_INTE);
+	iowrite32(rval | TSI721_INT_OMSG_CHAN(ch),
+		  priv->regs + TSI721_DEV_CHAN_INTE);
+}
+
+/* Disable Outbound Messaging interrupts */
+static void
+tsi721_omsg_interrupt_disable(struct tsi721_device *priv, int ch,
+				   u32 inte_mask)
+{
+	u32 rval;
+
+	if (!inte_mask)
+		return;
+
+	/* Clear pending Outbound Messaging interrupts */
+	iowrite32(inte_mask, priv->regs + TSI721_OBDMAC_INT(ch));
+
+	/* Disable Outbound Messaging interrupts */
+	rval = ioread32(priv->regs + TSI721_OBDMAC_INTE(ch));
+	rval &= ~inte_mask;
+	iowrite32(rval, priv->regs + TSI721_OBDMAC_INTE(ch));
+
+	if (priv->flags & TSI721_USING_MSIX)
+		return; /* Finished if we are in MSI-X mode */
+
+	/*
+	 * For MSI and INTA interrupt signalling we need to disable next levels
+	 */
+
+	/* Disable Device Channel Interrupt */
+	rval = ioread32(priv->regs + TSI721_DEV_CHAN_INTE);
+	rval &= ~TSI721_INT_OMSG_CHAN(ch);
+	iowrite32(rval, priv->regs + TSI721_DEV_CHAN_INTE);
+}
+
+/**
+ * tsi721_add_outb_message - Add message to the Tsi721 outbound message queue
+ * @mport: Master port with outbound message queue
+ * @rdev: Target of outbound message
+ * @mbox: Outbound mailbox
+ * @buffer: Message to add to outbound queue
+ * @len: Length of message
+ */
+static int
+tsi721_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
+			void *buffer, size_t len)
+{
+	struct tsi721_device *priv = mport->priv;
+	struct tsi721_omsg_desc *desc;
+	u32 tx_slot;
+
+	if (!priv->omsg_init[mbox] ||
+	    len > TSI721_MSG_MAX_SIZE || len < 8)
+		return -EINVAL;
+
+	tx_slot = priv->omsg_ring[mbox].tx_slot;
+
+	/* Copy copy message into transfer buffer */
+	memcpy(priv->omsg_ring[mbox].omq_base[tx_slot], buffer, len);
+
+	if (len & 0x7)
+		len += 8;
+
+	/* Build descriptor associated with buffer */
+	desc = priv->omsg_ring[mbox].omd_base;
+	desc[tx_slot].type_id = cpu_to_le32((DTYPE4 << 29) | rdev->destid);
+	if (tx_slot % 4 == 0)
+		desc[tx_slot].type_id |= cpu_to_le32(TSI721_OMD_IOF);
+
+	desc[tx_slot].msg_info =
+		cpu_to_le32((mport->sys_size << 26) | (mbox << 22) |
+			    (0xe << 12) | (len & 0xff8));
+	desc[tx_slot].bufptr_lo =
+		cpu_to_le32((u64)priv->omsg_ring[mbox].omq_phys[tx_slot] &
+			    0xffffffff);
+	desc[tx_slot].bufptr_hi =
+		cpu_to_le32((u64)priv->omsg_ring[mbox].omq_phys[tx_slot] >> 32);
+
+	priv->omsg_ring[mbox].wr_count++;
+
+	/* Go to next descriptor */
+	if (++priv->omsg_ring[mbox].tx_slot == priv->omsg_ring[mbox].size) {
+		priv->omsg_ring[mbox].tx_slot = 0;
+		/* Move through the ring link descriptor at the end */
+		priv->omsg_ring[mbox].wr_count++;
+	}
+
+	mb();
+
+	/* Set new write count value */
+	iowrite32(priv->omsg_ring[mbox].wr_count,
+		priv->regs + TSI721_OBDMAC_DWRCNT(mbox));
+	ioread32(priv->regs + TSI721_OBDMAC_DWRCNT(mbox));
+
+	return 0;
+}
+
+/**
+ * tsi721_omsg_handler - Outbound Message Interrupt Handler
+ * @priv: pointer to tsi721 private data
+ * @ch:   number of OB MSG channel to service
+ *
+ * Services channel interrupts from outbound messaging engine.
+ */
+static void tsi721_omsg_handler(struct tsi721_device *priv, int ch)
+{
+	u32 omsg_int;
+
+	spin_lock(&priv->omsg_ring[ch].lock);
+
+	omsg_int = ioread32(priv->regs + TSI721_OBDMAC_INT(ch));
+
+	if (omsg_int & TSI721_OBDMAC_INT_ST_FULL)
+		dev_info(&priv->pdev->dev,
+			"OB MBOX%d: Status FIFO is full\n", ch);
+
+	if (omsg_int & (TSI721_OBDMAC_INT_DONE | TSI721_OBDMAC_INT_IOF_DONE)) {
+		u32 srd_ptr;
+		u64 *sts_ptr, last_ptr = 0, prev_ptr = 0;
+		int i, j;
+		u32 tx_slot;
+
+		/*
+		 * Find last successfully processed descriptor
+		 */
+
+		/* Check and clear descriptor status FIFO entries */
+		srd_ptr = priv->omsg_ring[ch].sts_rdptr;
+		sts_ptr = priv->omsg_ring[ch].sts_base;
+		j = srd_ptr * 8;
+		while (sts_ptr[j]) {
+			for (i = 0; i < 8 && sts_ptr[j]; i++, j++) {
+				prev_ptr = last_ptr;
+				last_ptr = le64_to_cpu(sts_ptr[j]);
+				sts_ptr[j] = 0;
+			}
+
+			++srd_ptr;
+			srd_ptr %= priv->omsg_ring[ch].sts_size;
+			j = srd_ptr * 8;
+		}
+
+		if (last_ptr == 0)
+			goto no_sts_update;
+
+		priv->omsg_ring[ch].sts_rdptr = srd_ptr;
+		iowrite32(srd_ptr, priv->regs + TSI721_OBDMAC_DSRP(ch));
+
+		if (!priv->mport->outb_msg[ch].mcback)
+			goto no_sts_update;
+
+		/* Inform upper layer about transfer completion */
+
+		tx_slot = (last_ptr - (u64)priv->omsg_ring[ch].omd_phys)/
+						sizeof(struct tsi721_omsg_desc);
+
+		/*
+		 * Check if this is a Link Descriptor (LD).
+		 * If yes, ignore LD and use descriptor processed
+		 * before LD.
+		 */
+		if (tx_slot == priv->omsg_ring[ch].size) {
+			if (prev_ptr)
+				tx_slot = (prev_ptr -
+					(u64)priv->omsg_ring[ch].omd_phys)/
+						sizeof(struct tsi721_omsg_desc);
+			else
+				goto no_sts_update;
+		}
+
+		/* Move slot index to the next message to be sent */
+		++tx_slot;
+		if (tx_slot == priv->omsg_ring[ch].size)
+			tx_slot = 0;
+		BUG_ON(tx_slot >= priv->omsg_ring[ch].size);
+		priv->mport->outb_msg[ch].mcback(priv->mport,
+				priv->omsg_ring[ch].dev_id, ch,
+				tx_slot);
+	}
+
+no_sts_update:
+
+	if (omsg_int & TSI721_OBDMAC_INT_ERROR) {
+		/*
+		* Outbound message operation aborted due to error,
+		* reinitialize OB MSG channel
+		*/
+
+		dev_dbg(&priv->pdev->dev, "OB MSG ABORT ch_stat=%x\n",
+			ioread32(priv->regs + TSI721_OBDMAC_STS(ch)));
+
+		iowrite32(TSI721_OBDMAC_INT_ERROR,
+				priv->regs + TSI721_OBDMAC_INT(ch));
+		iowrite32(TSI721_OBDMAC_CTL_INIT,
+				priv->regs + TSI721_OBDMAC_CTL(ch));
+		ioread32(priv->regs + TSI721_OBDMAC_CTL(ch));
+
+		/* Inform upper level to clear all pending tx slots */
+		if (priv->mport->outb_msg[ch].mcback)
+			priv->mport->outb_msg[ch].mcback(priv->mport,
+					priv->omsg_ring[ch].dev_id, ch,
+					priv->omsg_ring[ch].tx_slot);
+		/* Synch tx_slot tracking */
+		iowrite32(priv->omsg_ring[ch].tx_slot,
+			priv->regs + TSI721_OBDMAC_DRDCNT(ch));
+		ioread32(priv->regs + TSI721_OBDMAC_DRDCNT(ch));
+		priv->omsg_ring[ch].wr_count = priv->omsg_ring[ch].tx_slot;
+		priv->omsg_ring[ch].sts_rdptr = 0;
+	}
+
+	/* Clear channel interrupts */
+	iowrite32(omsg_int, priv->regs + TSI721_OBDMAC_INT(ch));
+
+	if (!(priv->flags & TSI721_USING_MSIX)) {
+		u32 ch_inte;
+
+		/* Re-enable channel interrupts */
+		ch_inte = ioread32(priv->regs + TSI721_DEV_CHAN_INTE);
+		ch_inte |= TSI721_INT_OMSG_CHAN(ch);
+		iowrite32(ch_inte, priv->regs + TSI721_DEV_CHAN_INTE);
+	}
+
+	spin_unlock(&priv->omsg_ring[ch].lock);
+}
+
+/**
+ * tsi721_open_outb_mbox - Initialize Tsi721 outbound mailbox
+ * @mport: Master port implementing Outbound Messaging Engine
+ * @dev_id: Device specific pointer to pass on event
+ * @mbox: Mailbox to open
+ * @entries: Number of entries in the outbound mailbox ring
+ */
+static int tsi721_open_outb_mbox(struct rio_mport *mport, void *dev_id,
+				 int mbox, int entries)
+{
+	struct tsi721_device *priv = mport->priv;
+	struct tsi721_omsg_desc *bd_ptr;
+	int i, rc = 0;
+
+	if ((entries < TSI721_OMSGD_MIN_RING_SIZE) ||
+	    (entries > (TSI721_OMSGD_RING_SIZE)) ||
+	    (!is_power_of_2(entries)) || mbox >= RIO_MAX_MBOX) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	priv->omsg_ring[mbox].dev_id = dev_id;
+	priv->omsg_ring[mbox].size = entries;
+	priv->omsg_ring[mbox].sts_rdptr = 0;
+	spin_lock_init(&priv->omsg_ring[mbox].lock);
+
+	/* Outbound Msg Buffer allocation based on
+	   the number of maximum descriptor entries */
+	for (i = 0; i < entries; i++) {
+		priv->omsg_ring[mbox].omq_base[i] =
+			dma_alloc_coherent(
+				&priv->pdev->dev, TSI721_MSG_BUFFER_SIZE,
+				&priv->omsg_ring[mbox].omq_phys[i],
+				GFP_KERNEL);
+		if (priv->omsg_ring[mbox].omq_base[i] == NULL) {
+			dev_dbg(&priv->pdev->dev,
+				"Unable to allocate OB MSG data buffer for"
+				" MBOX%d\n", mbox);
+			rc = -ENOMEM;
+			goto out_buf;
+		}
+	}
+
+	/* Outbound message descriptor allocation */
+	priv->omsg_ring[mbox].omd_base = dma_alloc_coherent(
+				&priv->pdev->dev,
+				(entries + 1) * sizeof(struct tsi721_omsg_desc),
+				&priv->omsg_ring[mbox].omd_phys, GFP_KERNEL);
+	if (priv->omsg_ring[mbox].omd_base == NULL) {
+		dev_dbg(&priv->pdev->dev,
+			"Unable to allocate OB MSG descriptor memory "
+			"for MBOX%d\n", mbox);
+		rc = -ENOMEM;
+		goto out_buf;
+	}
+
+	priv->omsg_ring[mbox].tx_slot = 0;
+
+	/* Outbound message descriptor status FIFO allocation */
+	priv->omsg_ring[mbox].sts_size = roundup_pow_of_two(entries + 1);
+	priv->omsg_ring[mbox].sts_base = dma_alloc_coherent(&priv->pdev->dev,
+			priv->omsg_ring[mbox].sts_size *
+						sizeof(struct tsi721_dma_sts),
+			&priv->omsg_ring[mbox].sts_phys, GFP_KERNEL);
+	if (priv->omsg_ring[mbox].sts_base == NULL) {
+		dev_dbg(&priv->pdev->dev,
+			"Unable to allocate OB MSG descriptor status FIFO "
+			"for MBOX%d\n", mbox);
+		rc = -ENOMEM;
+		goto out_desc;
+	}
+
+	memset(priv->omsg_ring[mbox].sts_base, 0,
+		entries * sizeof(struct tsi721_dma_sts));
+
+	/*
+	 * Configure Outbound Messaging Engine
+	 */
+
+	/* Setup Outbound Message descriptor pointer */
+	iowrite32(((u64)priv->omsg_ring[mbox].omd_phys >> 32),
+			priv->regs + TSI721_OBDMAC_DPTRH(mbox));
+	iowrite32(((u64)priv->omsg_ring[mbox].omd_phys &
+					TSI721_OBDMAC_DPTRL_MASK),
+			priv->regs + TSI721_OBDMAC_DPTRL(mbox));
+
+	/* Setup Outbound Message descriptor status FIFO */
+	iowrite32(((u64)priv->omsg_ring[mbox].sts_phys >> 32),
+			priv->regs + TSI721_OBDMAC_DSBH(mbox));
+	iowrite32(((u64)priv->omsg_ring[mbox].sts_phys &
+					TSI721_OBDMAC_DSBL_MASK),
+			priv->regs + TSI721_OBDMAC_DSBL(mbox));
+	iowrite32(TSI721_DMAC_DSSZ_SIZE(priv->omsg_ring[mbox].sts_size),
+		priv->regs + (u32)TSI721_OBDMAC_DSSZ(mbox));
+
+	/* Enable interrupts */
+
+#ifdef CONFIG_PCI_MSI
+	if (priv->flags & TSI721_USING_MSIX) {
+		/* Request interrupt service if we are in MSI-X mode */
+		rc = request_irq(
+			priv->msix[TSI721_VECT_OMB0_DONE + mbox].vector,
+			tsi721_omsg_msix, 0,
+			priv->msix[TSI721_VECT_OMB0_DONE + mbox].irq_name,
+			(void *)mport);
+
+		if (rc) {
+			dev_dbg(&priv->pdev->dev,
+				"Unable to allocate MSI-X interrupt for "
+				"OBOX%d-DONE\n", mbox);
+			goto out_stat;
+		}
+
+		rc = request_irq(priv->msix[TSI721_VECT_OMB0_INT + mbox].vector,
+			tsi721_omsg_msix, 0,
+			priv->msix[TSI721_VECT_OMB0_INT + mbox].irq_name,
+			(void *)mport);
+
+		if (rc)	{
+			dev_dbg(&priv->pdev->dev,
+				"Unable to allocate MSI-X interrupt for "
+				"MBOX%d-INT\n", mbox);
+			free_irq(
+				priv->msix[TSI721_VECT_OMB0_DONE + mbox].vector,
+				(void *)mport);
+			goto out_stat;
+		}
+	}
+#endif /* CONFIG_PCI_MSI */
+
+	tsi721_omsg_interrupt_enable(priv, mbox, TSI721_OBDMAC_INT_ALL);
+
+	/* Initialize Outbound Message descriptors ring */
+	bd_ptr = priv->omsg_ring[mbox].omd_base;
+	bd_ptr[entries].type_id = cpu_to_le32(DTYPE5 << 29);
+	bd_ptr[entries].msg_info = 0;
+	bd_ptr[entries].next_lo =
+		cpu_to_le32((u64)priv->omsg_ring[mbox].omd_phys &
+		TSI721_OBDMAC_DPTRL_MASK);
+	bd_ptr[entries].next_hi =
+		cpu_to_le32((u64)priv->omsg_ring[mbox].omd_phys >> 32);
+	priv->omsg_ring[mbox].wr_count = 0;
+	mb();
+
+	/* Initialize Outbound Message engine */
+	iowrite32(TSI721_OBDMAC_CTL_INIT, priv->regs + TSI721_OBDMAC_CTL(mbox));
+	ioread32(priv->regs + TSI721_OBDMAC_DWRCNT(mbox));
+	udelay(10);
+
+	priv->omsg_init[mbox] = 1;
+
+	return 0;
+
+#ifdef CONFIG_PCI_MSI
+out_stat:
+	dma_free_coherent(&priv->pdev->dev,
+		priv->omsg_ring[mbox].sts_size * sizeof(struct tsi721_dma_sts),
+		priv->omsg_ring[mbox].sts_base,
+		priv->omsg_ring[mbox].sts_phys);
+
+	priv->omsg_ring[mbox].sts_base = NULL;
+#endif /* CONFIG_PCI_MSI */
+
+out_desc:
+	dma_free_coherent(&priv->pdev->dev,
+		(entries + 1) * sizeof(struct tsi721_omsg_desc),
+		priv->omsg_ring[mbox].omd_base,
+		priv->omsg_ring[mbox].omd_phys);
+
+	priv->omsg_ring[mbox].omd_base = NULL;
+
+out_buf:
+	for (i = 0; i < priv->omsg_ring[mbox].size; i++) {
+		if (priv->omsg_ring[mbox].omq_base[i]) {
+			dma_free_coherent(&priv->pdev->dev,
+				TSI721_MSG_BUFFER_SIZE,
+				priv->omsg_ring[mbox].omq_base[i],
+				priv->omsg_ring[mbox].omq_phys[i]);
+
+			priv->omsg_ring[mbox].omq_base[i] = NULL;
+		}
+	}
+
+out:
+	return rc;
+}
+
+/**
+ * tsi721_close_outb_mbox - Close Tsi721 outbound mailbox
+ * @mport: Master port implementing the outbound message unit
+ * @mbox: Mailbox to close
+ */
+static void tsi721_close_outb_mbox(struct rio_mport *mport, int mbox)
+{
+	struct tsi721_device *priv = mport->priv;
+	u32 i;
+
+	if (!priv->omsg_init[mbox])
+		return;
+	priv->omsg_init[mbox] = 0;
+
+	/* Disable Interrupts */
+
+	tsi721_omsg_interrupt_disable(priv, mbox, TSI721_OBDMAC_INT_ALL);
+
+#ifdef CONFIG_PCI_MSI
+	if (priv->flags & TSI721_USING_MSIX) {
+		free_irq(priv->msix[TSI721_VECT_OMB0_DONE + mbox].vector,
+			 (void *)mport);
+		free_irq(priv->msix[TSI721_VECT_OMB0_INT + mbox].vector,
+			 (void *)mport);
+	}
+#endif /* CONFIG_PCI_MSI */
+
+	/* Free OMSG Descriptor Status FIFO */
+	dma_free_coherent(&priv->pdev->dev,
+		priv->omsg_ring[mbox].sts_size * sizeof(struct tsi721_dma_sts),
+		priv->omsg_ring[mbox].sts_base,
+		priv->omsg_ring[mbox].sts_phys);
+
+	priv->omsg_ring[mbox].sts_base = NULL;
+
+	/* Free OMSG descriptors */
+	dma_free_coherent(&priv->pdev->dev,
+		(priv->omsg_ring[mbox].size + 1) *
+			sizeof(struct tsi721_omsg_desc),
+		priv->omsg_ring[mbox].omd_base,
+		priv->omsg_ring[mbox].omd_phys);
+
+	priv->omsg_ring[mbox].omd_base = NULL;
+
+	/* Free message buffers */
+	for (i = 0; i < priv->omsg_ring[mbox].size; i++) {
+		if (priv->omsg_ring[mbox].omq_base[i]) {
+			dma_free_coherent(&priv->pdev->dev,
+				TSI721_MSG_BUFFER_SIZE,
+				priv->omsg_ring[mbox].omq_base[i],
+				priv->omsg_ring[mbox].omq_phys[i]);
+
+			priv->omsg_ring[mbox].omq_base[i] = NULL;
+		}
+	}
+}
+
+/**
+ * tsi721_imsg_handler - Inbound Message Interrupt Handler
+ * @priv: pointer to tsi721 private data
+ * @ch: inbound message channel number to service
+ *
+ * Services channel interrupts from inbound messaging engine.
+ */
+static void tsi721_imsg_handler(struct tsi721_device *priv, int ch)
+{
+	u32 mbox = ch - 4;
+	u32 imsg_int;
+
+	spin_lock(&priv->imsg_ring[mbox].lock);
+
+	imsg_int = ioread32(priv->regs + TSI721_IBDMAC_INT(ch));
+
+	if (imsg_int & TSI721_IBDMAC_INT_SRTO)
+		dev_info(&priv->pdev->dev, "IB MBOX%d SRIO timeout\n",
+			mbox);
+
+	if (imsg_int & TSI721_IBDMAC_INT_PC_ERROR)
+		dev_info(&priv->pdev->dev, "IB MBOX%d PCIe error\n",
+			mbox);
+
+	if (imsg_int & TSI721_IBDMAC_INT_FQ_LOW)
+		dev_info(&priv->pdev->dev,
+			"IB MBOX%d IB free queue low\n", mbox);
+
+	/* Clear IB channel interrupts */
+	iowrite32(imsg_int, priv->regs + TSI721_IBDMAC_INT(ch));
+
+	/* If an IB Msg is received notify the upper layer */
+	if (imsg_int & TSI721_IBDMAC_INT_DQ_RCV &&
+		priv->mport->inb_msg[mbox].mcback)
+		priv->mport->inb_msg[mbox].mcback(priv->mport,
+				priv->imsg_ring[mbox].dev_id, mbox, -1);
+
+	if (!(priv->flags & TSI721_USING_MSIX)) {
+		u32 ch_inte;
+
+		/* Re-enable channel interrupts */
+		ch_inte = ioread32(priv->regs + TSI721_DEV_CHAN_INTE);
+		ch_inte |= TSI721_INT_IMSG_CHAN(ch);
+		iowrite32(ch_inte, priv->regs + TSI721_DEV_CHAN_INTE);
+	}
+
+	spin_unlock(&priv->imsg_ring[mbox].lock);
+}
+
+/**
+ * tsi721_open_inb_mbox - Initialize Tsi721 inbound mailbox
+ * @mport: Master port implementing the Inbound Messaging Engine
+ * @dev_id: Device specific pointer to pass on event
+ * @mbox: Mailbox to open
+ * @entries: Number of entries in the inbound mailbox ring
+ */
+static int tsi721_open_inb_mbox(struct rio_mport *mport, void *dev_id,
+				int mbox, int entries)
+{
+	struct tsi721_device *priv = mport->priv;
+	int ch = mbox + 4;
+	int i;
+	u64 *free_ptr;
+	int rc = 0;
+
+	if ((entries < TSI721_IMSGD_MIN_RING_SIZE) ||
+	    (entries > TSI721_IMSGD_RING_SIZE) ||
+	    (!is_power_of_2(entries)) || mbox >= RIO_MAX_MBOX) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	/* Initialize IB Messaging Ring */
+	priv->imsg_ring[mbox].dev_id = dev_id;
+	priv->imsg_ring[mbox].size = entries;
+	priv->imsg_ring[mbox].rx_slot = 0;
+	priv->imsg_ring[mbox].desc_rdptr = 0;
+	priv->imsg_ring[mbox].fq_wrptr = 0;
+	for (i = 0; i < priv->imsg_ring[mbox].size; i++)
+		priv->imsg_ring[mbox].imq_base[i] = NULL;
+	spin_lock_init(&priv->imsg_ring[mbox].lock);
+
+	/* Allocate buffers for incoming messages */
+	priv->imsg_ring[mbox].buf_base =
+		dma_alloc_coherent(&priv->pdev->dev,
+				   entries * TSI721_MSG_BUFFER_SIZE,
+				   &priv->imsg_ring[mbox].buf_phys,
+				   GFP_KERNEL);
+
+	if (priv->imsg_ring[mbox].buf_base == NULL) {
+		dev_err(&priv->pdev->dev,
+			"Failed to allocate buffers for IB MBOX%d\n", mbox);
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	/* Allocate memory for circular free list */
+	priv->imsg_ring[mbox].imfq_base =
+		dma_alloc_coherent(&priv->pdev->dev,
+				   entries * 8,
+				   &priv->imsg_ring[mbox].imfq_phys,
+				   GFP_KERNEL);
+
+	if (priv->imsg_ring[mbox].imfq_base == NULL) {
+		dev_err(&priv->pdev->dev,
+			"Failed to allocate free queue for IB MBOX%d\n", mbox);
+		rc = -ENOMEM;
+		goto out_buf;
+	}
+
+	/* Allocate memory for Inbound message descriptors */
+	priv->imsg_ring[mbox].imd_base =
+		dma_alloc_coherent(&priv->pdev->dev,
+				   entries * sizeof(struct tsi721_imsg_desc),
+				   &priv->imsg_ring[mbox].imd_phys, GFP_KERNEL);
+
+	if (priv->imsg_ring[mbox].imd_base == NULL) {
+		dev_err(&priv->pdev->dev,
+			"Failed to allocate descriptor memory for IB MBOX%d\n",
+			mbox);
+		rc = -ENOMEM;
+		goto out_dma;
+	}
+
+	/* Fill free buffer pointer list */
+	free_ptr = priv->imsg_ring[mbox].imfq_base;
+	for (i = 0; i < entries; i++)
+		free_ptr[i] = cpu_to_le64(
+				(u64)(priv->imsg_ring[mbox].buf_phys) +
+				i * 0x1000);
+
+	mb();
+
+	/*
+	 * For mapping of inbound SRIO Messages into appropriate queues we need
+	 * to set Inbound Device ID register in the messaging engine. We do it
+	 * once when first inbound mailbox is requested.
+	 */
+	if (!(priv->flags & TSI721_IMSGID_SET)) {
+		iowrite32((u32)priv->mport->host_deviceid,
+			priv->regs + TSI721_IB_DEVID);
+		priv->flags |= TSI721_IMSGID_SET;
+	}
+
+	/*
+	 * Configure Inbound Messaging channel (ch = mbox + 4)
+	 */
+
+	/* Setup Inbound Message free queue */
+	iowrite32(((u64)priv->imsg_ring[mbox].imfq_phys >> 32),
+		priv->regs + TSI721_IBDMAC_FQBH(ch));
+	iowrite32(((u64)priv->imsg_ring[mbox].imfq_phys &
+			TSI721_IBDMAC_FQBL_MASK),
+		priv->regs+TSI721_IBDMAC_FQBL(ch));
+	iowrite32(TSI721_DMAC_DSSZ_SIZE(entries),
+		priv->regs + TSI721_IBDMAC_FQSZ(ch));
+
+	/* Setup Inbound Message descriptor queue */
+	iowrite32(((u64)priv->imsg_ring[mbox].imd_phys >> 32),
+		priv->regs + TSI721_IBDMAC_DQBH(ch));
+	iowrite32(((u32)priv->imsg_ring[mbox].imd_phys &
+		   (u32)TSI721_IBDMAC_DQBL_MASK),
+		priv->regs+TSI721_IBDMAC_DQBL(ch));
+	iowrite32(TSI721_DMAC_DSSZ_SIZE(entries),
+		priv->regs + TSI721_IBDMAC_DQSZ(ch));
+
+	/* Enable interrupts */
+
+#ifdef CONFIG_PCI_MSI
+	if (priv->flags & TSI721_USING_MSIX) {
+		/* Request interrupt service if we are in MSI-X mode */
+		rc = request_irq(priv->msix[TSI721_VECT_IMB0_RCV + mbox].vector,
+			tsi721_imsg_msix, 0,
+			priv->msix[TSI721_VECT_IMB0_RCV + mbox].irq_name,
+			(void *)mport);
+
+		if (rc) {
+			dev_dbg(&priv->pdev->dev,
+				"Unable to allocate MSI-X interrupt for "
+				"IBOX%d-DONE\n", mbox);
+			goto out_desc;
+		}
+
+		rc = request_irq(priv->msix[TSI721_VECT_IMB0_INT + mbox].vector,
+			tsi721_imsg_msix, 0,
+			priv->msix[TSI721_VECT_IMB0_INT + mbox].irq_name,
+			(void *)mport);
+
+		if (rc)	{
+			dev_dbg(&priv->pdev->dev,
+				"Unable to allocate MSI-X interrupt for "
+				"IBOX%d-INT\n", mbox);
+			free_irq(
+				priv->msix[TSI721_VECT_IMB0_RCV + mbox].vector,
+				(void *)mport);
+			goto out_desc;
+		}
+	}
+#endif /* CONFIG_PCI_MSI */
+
+	tsi721_imsg_interrupt_enable(priv, ch, TSI721_IBDMAC_INT_ALL);
+
+	/* Initialize Inbound Message Engine */
+	iowrite32(TSI721_IBDMAC_CTL_INIT, priv->regs + TSI721_IBDMAC_CTL(ch));
+	ioread32(priv->regs + TSI721_IBDMAC_CTL(ch));
+	udelay(10);
+	priv->imsg_ring[mbox].fq_wrptr = entries - 1;
+	iowrite32(entries - 1, priv->regs + TSI721_IBDMAC_FQWP(ch));
+
+	priv->imsg_init[mbox] = 1;
+	return 0;
+
+#ifdef CONFIG_PCI_MSI
+out_desc:
+	dma_free_coherent(&priv->pdev->dev,
+		priv->imsg_ring[mbox].size * sizeof(struct tsi721_imsg_desc),
+		priv->imsg_ring[mbox].imd_base,
+		priv->imsg_ring[mbox].imd_phys);
+
+	priv->imsg_ring[mbox].imd_base = NULL;
+#endif /* CONFIG_PCI_MSI */
+
+out_dma:
+	dma_free_coherent(&priv->pdev->dev,
+		priv->imsg_ring[mbox].size * 8,
+		priv->imsg_ring[mbox].imfq_base,
+		priv->imsg_ring[mbox].imfq_phys);
+
+	priv->imsg_ring[mbox].imfq_base = NULL;
+
+out_buf:
+	dma_free_coherent(&priv->pdev->dev,
+		priv->imsg_ring[mbox].size * TSI721_MSG_BUFFER_SIZE,
+		priv->imsg_ring[mbox].buf_base,
+		priv->imsg_ring[mbox].buf_phys);
+
+	priv->imsg_ring[mbox].buf_base = NULL;
+
+out:
+	return rc;
+}
+
+/**
+ * tsi721_close_inb_mbox - Shut down Tsi721 inbound mailbox
+ * @mport: Master port implementing the Inbound Messaging Engine
+ * @mbox: Mailbox to close
+ */
+static void tsi721_close_inb_mbox(struct rio_mport *mport, int mbox)
+{
+	struct tsi721_device *priv = mport->priv;
+	u32 rx_slot;
+	int ch = mbox + 4;
+
+	if (!priv->imsg_init[mbox]) /* mbox isn't initialized yet */
+		return;
+	priv->imsg_init[mbox] = 0;
+
+	/* Disable Inbound Messaging Engine */
+
+	/* Disable Interrupts */
+	tsi721_imsg_interrupt_disable(priv, ch, TSI721_OBDMAC_INT_MASK);
+
+#ifdef CONFIG_PCI_MSI
+	if (priv->flags & TSI721_USING_MSIX) {
+		free_irq(priv->msix[TSI721_VECT_IMB0_RCV + mbox].vector,
+				(void *)mport);
+		free_irq(priv->msix[TSI721_VECT_IMB0_INT + mbox].vector,
+				(void *)mport);
+	}
+#endif /* CONFIG_PCI_MSI */
+
+	/* Clear Inbound Buffer Queue */
+	for (rx_slot = 0; rx_slot < priv->imsg_ring[mbox].size; rx_slot++)
+		priv->imsg_ring[mbox].imq_base[rx_slot] = NULL;
+
+	/* Free memory allocated for message buffers */
+	dma_free_coherent(&priv->pdev->dev,
+		priv->imsg_ring[mbox].size * TSI721_MSG_BUFFER_SIZE,
+		priv->imsg_ring[mbox].buf_base,
+		priv->imsg_ring[mbox].buf_phys);
+
+	priv->imsg_ring[mbox].buf_base = NULL;
+
+	/* Free memory allocated for free pointr list */
+	dma_free_coherent(&priv->pdev->dev,
+		priv->imsg_ring[mbox].size * 8,
+		priv->imsg_ring[mbox].imfq_base,
+		priv->imsg_ring[mbox].imfq_phys);
+
+	priv->imsg_ring[mbox].imfq_base = NULL;
+
+	/* Free memory allocated for RX descriptors */
+	dma_free_coherent(&priv->pdev->dev,
+		priv->imsg_ring[mbox].size * sizeof(struct tsi721_imsg_desc),
+		priv->imsg_ring[mbox].imd_base,
+		priv->imsg_ring[mbox].imd_phys);
+
+	priv->imsg_ring[mbox].imd_base = NULL;
+}
+
+/**
+ * tsi721_add_inb_buffer - Add buffer to the Tsi721 inbound message queue
+ * @mport: Master port implementing the Inbound Messaging Engine
+ * @mbox: Inbound mailbox number
+ * @buf: Buffer to add to inbound queue
+ */
+static int tsi721_add_inb_buffer(struct rio_mport *mport, int mbox, void *buf)
+{
+	struct tsi721_device *priv = mport->priv;
+	u32 rx_slot;
+	int rc = 0;
+
+	rx_slot = priv->imsg_ring[mbox].rx_slot;
+	if (priv->imsg_ring[mbox].imq_base[rx_slot]) {
+		dev_err(&priv->pdev->dev,
+			"Error adding inbound buffer %d, buffer exists\n",
+			rx_slot);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	priv->imsg_ring[mbox].imq_base[rx_slot] = buf;
+
+	if (++priv->imsg_ring[mbox].rx_slot == priv->imsg_ring[mbox].size)
+		priv->imsg_ring[mbox].rx_slot = 0;
+
+out:
+	return rc;
+}
+
+/**
+ * tsi721_get_inb_message - Fetch inbound message from the Tsi721 MSG Queue
+ * @mport: Master port implementing the Inbound Messaging Engine
+ * @mbox: Inbound mailbox number
+ *
+ * Returns pointer to the message on success or NULL on failure.
+ */
+static void *tsi721_get_inb_message(struct rio_mport *mport, int mbox)
+{
+	struct tsi721_device *priv = mport->priv;
+	struct tsi721_imsg_desc *desc;
+	u32 rx_slot;
+	void *rx_virt = NULL;
+	u64 rx_phys;
+	void *buf = NULL;
+	u64 *free_ptr;
+	int ch = mbox + 4;
+	int msg_size;
+
+	if (!priv->imsg_init[mbox])
+		return NULL;
+
+	desc = priv->imsg_ring[mbox].imd_base;
+	desc += priv->imsg_ring[mbox].desc_rdptr;
+
+	if (!(le32_to_cpu(desc->msg_info) & TSI721_IMD_HO))
+		goto out;
+
+	rx_slot = priv->imsg_ring[mbox].rx_slot;
+	while (priv->imsg_ring[mbox].imq_base[rx_slot] == NULL) {
+		if (++rx_slot == priv->imsg_ring[mbox].size)
+			rx_slot = 0;
+	}
+
+	rx_phys = ((u64)le32_to_cpu(desc->bufptr_hi) << 32) |
+			le32_to_cpu(desc->bufptr_lo);
+
+	rx_virt = priv->imsg_ring[mbox].buf_base +
+		  (rx_phys - (u64)priv->imsg_ring[mbox].buf_phys);
+
+	buf = priv->imsg_ring[mbox].imq_base[rx_slot];
+	msg_size = le32_to_cpu(desc->msg_info) & TSI721_IMD_BCOUNT;
+	if (msg_size == 0)
+		msg_size = RIO_MAX_MSG_SIZE;
+
+	memcpy(buf, rx_virt, msg_size);
+	priv->imsg_ring[mbox].imq_base[rx_slot] = NULL;
+
+	desc->msg_info &= cpu_to_le32(~TSI721_IMD_HO);
+	if (++priv->imsg_ring[mbox].desc_rdptr == priv->imsg_ring[mbox].size)
+		priv->imsg_ring[mbox].desc_rdptr = 0;
+
+	iowrite32(priv->imsg_ring[mbox].desc_rdptr,
+		priv->regs + TSI721_IBDMAC_DQRP(ch));
+
+	/* Return free buffer into the pointer list */
+	free_ptr = priv->imsg_ring[mbox].imfq_base;
+	free_ptr[priv->imsg_ring[mbox].fq_wrptr] = cpu_to_le64(rx_phys);
+
+	if (++priv->imsg_ring[mbox].fq_wrptr == priv->imsg_ring[mbox].size)
+		priv->imsg_ring[mbox].fq_wrptr = 0;
+
+	iowrite32(priv->imsg_ring[mbox].fq_wrptr,
+		priv->regs + TSI721_IBDMAC_FQWP(ch));
+out:
+	return buf;
+}
+
+/**
+ * tsi721_messages_init - Initialization of Messaging Engine
+ * @priv: pointer to tsi721 private data
+ *
+ * Configures Tsi721 messaging engine.
+ */
+static int tsi721_messages_init(struct tsi721_device *priv)
+{
+	int	ch;
+
+	iowrite32(0, priv->regs + TSI721_SMSG_ECC_LOG);
+	iowrite32(0, priv->regs + TSI721_RETRY_GEN_CNT);
+	iowrite32(0, priv->regs + TSI721_RETRY_RX_CNT);
+
+	/* Set SRIO Message Request/Response Timeout */
+	iowrite32(TSI721_RQRPTO_VAL, priv->regs + TSI721_RQRPTO);
+
+	/* Initialize Inbound Messaging Engine Registers */
+	for (ch = 0; ch < TSI721_IMSG_CHNUM; ch++) {
+		/* Clear interrupt bits */
+		iowrite32(TSI721_IBDMAC_INT_MASK,
+			priv->regs + TSI721_IBDMAC_INT(ch));
+		/* Clear Status */
+		iowrite32(0, priv->regs + TSI721_IBDMAC_STS(ch));
+
+		iowrite32(TSI721_SMSG_ECC_COR_LOG_MASK,
+				priv->regs + TSI721_SMSG_ECC_COR_LOG(ch));
+		iowrite32(TSI721_SMSG_ECC_NCOR_MASK,
+				priv->regs + TSI721_SMSG_ECC_NCOR(ch));
+	}
+
+	return 0;
+}
+
+/**
+ * tsi721_disable_ints - disables all device interrupts
+ * @priv: pointer to tsi721 private data
+ */
+static void tsi721_disable_ints(struct tsi721_device *priv)
+{
+	int ch;
+
+	/* Disable all device level interrupts */
+	iowrite32(0, priv->regs + TSI721_DEV_INTE);
+
+	/* Disable all Device Channel interrupts */
+	iowrite32(0, priv->regs + TSI721_DEV_CHAN_INTE);
+
+	/* Disable all Inbound Msg Channel interrupts */
+	for (ch = 0; ch < TSI721_IMSG_CHNUM; ch++)
+		iowrite32(0, priv->regs + TSI721_IBDMAC_INTE(ch));
+
+	/* Disable all Outbound Msg Channel interrupts */
+	for (ch = 0; ch < TSI721_OMSG_CHNUM; ch++)
+		iowrite32(0, priv->regs + TSI721_OBDMAC_INTE(ch));
+
+	/* Disable all general messaging interrupts */
+	iowrite32(0, priv->regs + TSI721_SMSG_INTE);
+
+	/* Disable all BDMA Channel interrupts */
+	for (ch = 0; ch < TSI721_DMA_MAXCH; ch++)
+		iowrite32(0, priv->regs + TSI721_DMAC_INTE(ch));
+
+	/* Disable all general BDMA interrupts */
+	iowrite32(0, priv->regs + TSI721_BDMA_INTE);
+
+	/* Disable all SRIO Channel interrupts */
+	for (ch = 0; ch < TSI721_SRIO_MAXCH; ch++)
+		iowrite32(0, priv->regs + TSI721_SR_CHINTE(ch));
+
+	/* Disable all general SR2PC interrupts */
+	iowrite32(0, priv->regs + TSI721_SR2PC_GEN_INTE);
+
+	/* Disable all PC2SR interrupts */
+	iowrite32(0, priv->regs + TSI721_PC2SR_INTE);
+
+	/* Disable all I2C interrupts */
+	iowrite32(0, priv->regs + TSI721_I2C_INT_ENABLE);
+
+	/* Disable SRIO MAC interrupts */
+	iowrite32(0, priv->regs + TSI721_RIO_EM_INT_ENABLE);
+	iowrite32(0, priv->regs + TSI721_RIO_EM_DEV_INT_EN);
+}
+
+/**
+ * tsi721_setup_mport - Setup Tsi721 as RapidIO subsystem master port
+ * @priv: pointer to tsi721 private data
+ *
+ * Configures Tsi721 as RapidIO master port.
+ */
+static int __devinit tsi721_setup_mport(struct tsi721_device *priv)
+{
+	struct pci_dev *pdev = priv->pdev;
+	int err = 0;
+	struct rio_ops *ops;
+
+	struct rio_mport *mport;
+
+	ops = kzalloc(sizeof(struct rio_ops), GFP_KERNEL);
+	if (!ops) {
+		dev_dbg(&pdev->dev, "Unable to allocate memory for rio_ops\n");
+		return -ENOMEM;
+	}
+
+	ops->lcread = tsi721_lcread;
+	ops->lcwrite = tsi721_lcwrite;
+	ops->cread = tsi721_cread_dma;
+	ops->cwrite = tsi721_cwrite_dma;
+	ops->dsend = tsi721_dsend;
+	ops->open_inb_mbox = tsi721_open_inb_mbox;
+	ops->close_inb_mbox = tsi721_close_inb_mbox;
+	ops->open_outb_mbox = tsi721_open_outb_mbox;
+	ops->close_outb_mbox = tsi721_close_outb_mbox;
+	ops->add_outb_message = tsi721_add_outb_message;
+	ops->add_inb_buffer = tsi721_add_inb_buffer;
+	ops->get_inb_message = tsi721_get_inb_message;
+
+	mport = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
+	if (!mport) {
+		kfree(ops);
+		dev_dbg(&pdev->dev, "Unable to allocate memory for mport\n");
+		return -ENOMEM;
+	}
+
+	mport->ops = ops;
+	mport->index = 0;
+	mport->sys_size = 0; /* small system */
+	mport->phy_type = RIO_PHY_SERIAL;
+	mport->priv = (void *)priv;
+	mport->phys_efptr = 0x100;
+
+	INIT_LIST_HEAD(&mport->dbells);
+
+	rio_init_dbell_res(&mport->riores[RIO_DOORBELL_RESOURCE], 0, 0xffff);
+	rio_init_mbox_res(&mport->riores[RIO_INB_MBOX_RESOURCE], 0, 0);
+	rio_init_mbox_res(&mport->riores[RIO_OUTB_MBOX_RESOURCE], 0, 0);
+	strcpy(mport->name, "Tsi721 mport");
+
+	/* Hook up interrupt handler */
+
+#ifdef CONFIG_PCI_MSI
+	if (!tsi721_enable_msix(priv))
+		priv->flags |= TSI721_USING_MSIX;
+	else if (!pci_enable_msi(pdev))
+		priv->flags |= TSI721_USING_MSI;
+	else
+		dev_info(&pdev->dev,
+			 "MSI/MSI-X is not available. Using legacy INTx.\n");
+#endif /* CONFIG_PCI_MSI */
+
+	err = tsi721_request_irq(mport);
+
+	if (!err) {
+		tsi721_interrupts_init(priv);
+		ops->pwenable = tsi721_pw_enable;
+	} else
+		dev_err(&pdev->dev, "Unable to get assigned PCI IRQ "
+			"vector %02X err=0x%x\n", pdev->irq, err);
+
+	/* Enable SRIO link */
+	iowrite32(ioread32(priv->regs + TSI721_DEVCTL) |
+		  TSI721_DEVCTL_SRBOOT_CMPL,
+		  priv->regs + TSI721_DEVCTL);
+
+	rio_register_mport(mport);
+	priv->mport = mport;
+
+	if (mport->host_deviceid >= 0)
+		iowrite32(RIO_PORT_GEN_HOST | RIO_PORT_GEN_MASTER |
+			  RIO_PORT_GEN_DISCOVERED,
+			  priv->regs + (0x100 + RIO_PORT_GEN_CTL_CSR));
+	else
+		iowrite32(0, priv->regs + (0x100 + RIO_PORT_GEN_CTL_CSR));
+
+	return 0;
+}
+
+static int __devinit tsi721_probe(struct pci_dev *pdev,
+				  const struct pci_device_id *id)
+{
+	struct tsi721_device *priv;
+	int i;
+	int err;
+	u32 regval;
+
+	priv = kzalloc(sizeof(struct tsi721_device), GFP_KERNEL);
+	if (priv == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate memory for device\n");
+		err = -ENOMEM;
+		goto err_exit;
+	}
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to enable PCI device\n");
+		goto err_clean;
+	}
+
+	priv->pdev = pdev;
+
+#ifdef DEBUG
+	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
+		dev_dbg(&pdev->dev, "res[%d] @ 0x%llx (0x%lx, 0x%lx)\n",
+			i, (unsigned long long)pci_resource_start(pdev, i),
+			(unsigned long)pci_resource_len(pdev, i),
+			pci_resource_flags(pdev, i));
+	}
+#endif
+	/*
+	 * Verify BAR configuration
+	 */
+
+	/* BAR_0 (registers) must be 512KB+ in 32-bit address space */
+	if (!(pci_resource_flags(pdev, BAR_0) & IORESOURCE_MEM) ||
+	    pci_resource_flags(pdev, BAR_0) & IORESOURCE_MEM_64 ||
+	    pci_resource_len(pdev, BAR_0) < TSI721_REG_SPACE_SIZE) {
+		dev_err(&pdev->dev,
+			"Missing or misconfigured CSR BAR0, aborting.\n");
+		err = -ENODEV;
+		goto err_disable_pdev;
+	}
+
+	/* BAR_1 (outbound doorbells) must be 16MB+ in 32-bit address space */
+	if (!(pci_resource_flags(pdev, BAR_1) & IORESOURCE_MEM) ||
+	    pci_resource_flags(pdev, BAR_1) & IORESOURCE_MEM_64 ||
+	    pci_resource_len(pdev, BAR_1) < TSI721_DB_WIN_SIZE) {
+		dev_err(&pdev->dev,
+			"Missing or misconfigured Doorbell BAR1, aborting.\n");
+		err = -ENODEV;
+		goto err_disable_pdev;
+	}
+
+	/*
+	 * BAR_2 and BAR_4 (outbound translation) must be in 64-bit PCIe address
+	 * space.
+	 * NOTE: BAR_2 and BAR_4 are not used by this version of driver.
+	 * It may be a good idea to keep them disabled using HW configuration
+	 * to save PCI memory space.
+	 */
+	if ((pci_resource_flags(pdev, BAR_2) & IORESOURCE_MEM) &&
+	    (pci_resource_flags(pdev, BAR_2) & IORESOURCE_MEM_64)) {
+		dev_info(&pdev->dev, "Outbound BAR2 is not used but enabled.\n");
+	}
+
+	if ((pci_resource_flags(pdev, BAR_4) & IORESOURCE_MEM) &&
+	    (pci_resource_flags(pdev, BAR_4) & IORESOURCE_MEM_64)) {
+		dev_info(&pdev->dev, "Outbound BAR4 is not used but enabled.\n");
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		dev_err(&pdev->dev, "Cannot obtain PCI resources, "
+			"aborting.\n");
+		goto err_disable_pdev;
+	}
+
+	pci_set_master(pdev);
+
+	priv->regs = pci_ioremap_bar(pdev, BAR_0);
+	if (!priv->regs) {
+		dev_err(&pdev->dev,
+			"Unable to map device registers space, aborting\n");
+		err = -ENOMEM;
+		goto err_free_res;
+	}
+
+	priv->odb_base = pci_ioremap_bar(pdev, BAR_1);
+	if (!priv->odb_base) {
+		dev_err(&pdev->dev,
+			"Unable to map outbound doorbells space, aborting\n");
+		err = -ENOMEM;
+		goto err_unmap_bars;
+	}
+
+	/* Configure DMA attributes. */
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+			dev_info(&pdev->dev, "Unable to set DMA mask\n");
+			goto err_unmap_bars;
+		}
+
+		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
+			dev_info(&pdev->dev, "Unable to set consistent DMA mask\n");
+	} else {
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+		if (err)
+			dev_info(&pdev->dev, "Unable to set consistent DMA mask\n");
+	}
+
+	/* Clear "no snoop" and "relaxed ordering" bits. */
+	pci_read_config_dword(pdev, 0x40 + PCI_EXP_DEVCTL, &regval);
+	regval &= ~(PCI_EXP_DEVCTL_RELAX_EN | PCI_EXP_DEVCTL_NOSNOOP_EN);
+	pci_write_config_dword(pdev, 0x40 + PCI_EXP_DEVCTL, regval);
+
+	/*
+	 * FIXUP: correct offsets of MSI-X tables in the MSI-X Capability Block
+	 */
+	pci_write_config_dword(pdev, TSI721_PCIECFG_EPCTL, 0x01);
+	pci_write_config_dword(pdev, TSI721_PCIECFG_MSIXTBL,
+						TSI721_MSIXTBL_OFFSET);
+	pci_write_config_dword(pdev, TSI721_PCIECFG_MSIXPBA,
+						TSI721_MSIXPBA_OFFSET);
+	pci_write_config_dword(pdev, TSI721_PCIECFG_EPCTL, 0);
+	/* End of FIXUP */
+
+	tsi721_disable_ints(priv);
+
+	tsi721_init_pc2sr_mapping(priv);
+	tsi721_init_sr2pc_mapping(priv);
+
+	if (tsi721_bdma_init(priv)) {
+		dev_err(&pdev->dev, "BDMA initialization failed, aborting\n");
+		err = -ENOMEM;
+		goto err_unmap_bars;
+	}
+
+	err = tsi721_doorbell_init(priv);
+	if (err)
+		goto err_free_bdma;
+
+	tsi721_port_write_init(priv);
+
+	err = tsi721_messages_init(priv);
+	if (err)
+		goto err_free_consistent;
+
+	err = tsi721_setup_mport(priv);
+	if (err)
+		goto err_free_consistent;
+
+	return 0;
+
+err_free_consistent:
+	tsi721_doorbell_free(priv);
+err_free_bdma:
+	tsi721_bdma_free(priv);
+err_unmap_bars:
+	if (priv->regs)
+		iounmap(priv->regs);
+	if (priv->odb_base)
+		iounmap(priv->odb_base);
+err_free_res:
+	pci_release_regions(pdev);
+	pci_clear_master(pdev);
+err_disable_pdev:
+	pci_disable_device(pdev);
+err_clean:
+	kfree(priv);
+err_exit:
+	return err;
+}
+
+static DEFINE_PCI_DEVICE_TABLE(tsi721_pci_tbl) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_IDT, PCI_DEVICE_ID_TSI721) },
+	{ 0, }	/* terminate list */
+};
+
+MODULE_DEVICE_TABLE(pci, tsi721_pci_tbl);
+
+static struct pci_driver tsi721_driver = {
+	.name		= "tsi721",
+	.id_table	= tsi721_pci_tbl,
+	.probe		= tsi721_probe,
+};
+
+static int __init tsi721_init(void)
+{
+	return pci_register_driver(&tsi721_driver);
+}
+
+static void __exit tsi721_exit(void)
+{
+	pci_unregister_driver(&tsi721_driver);
+}
+
+device_initcall(tsi721_init);
diff -puN /dev/null drivers/rapidio/devices/tsi721.h
--- /dev/null
+++ a/drivers/rapidio/devices/tsi721.h
@@ -0,0 +1,766 @@
+/*
+ * Tsi721 PCIExpress-to-SRIO bridge definitions
+ *
+ * Copyright 2011, Integrated Device Technology, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#ifndef __TSI721_H
+#define __TSI721_H
+
+#define DRV_NAME	"tsi721"
+
+#define DEFAULT_HOPCOUNT	0xff
+#define DEFAULT_DESTID		0xff
+
+/* PCI device ID */
+#define PCI_DEVICE_ID_TSI721		0x80ab
+
+#define BAR_0	0
+#define BAR_1	1
+#define BAR_2	2
+#define BAR_4	4
+
+#define TSI721_PC2SR_BARS	2
+#define TSI721_PC2SR_WINS	8
+#define TSI721_PC2SR_ZONES	8
+#define TSI721_MAINT_WIN	0 /* Window for outbound maintenance requests */
+#define IDB_QUEUE		0 /* Inbound Doorbell Queue to use */
+#define IDB_QSIZE		512 /* Inbound Doorbell Queue size */
+
+/* Memory space sizes */
+#define TSI721_REG_SPACE_SIZE		(512 * 1024) /* 512K */
+#define TSI721_DB_WIN_SIZE		(16 * 1024 * 1024) /* 16MB */
+
+#define  RIO_TT_CODE_8		0x00000000
+#define  RIO_TT_CODE_16		0x00000001
+
+#define TSI721_DMA_MAXCH	8
+#define TSI721_DMA_MINSTSSZ	32
+#define TSI721_DMA_STSBLKSZ	8
+
+#define TSI721_SRIO_MAXCH	8
+
+#define DBELL_SID(buf)		(((u8)buf[2] << 8) | (u8)buf[3])
+#define DBELL_TID(buf)		(((u8)buf[4] << 8) | (u8)buf[5])
+#define DBELL_INF(buf)		(((u8)buf[0] << 8) | (u8)buf[1])
+
+#define TSI721_RIO_PW_MSG_SIZE	16  /* Tsi721 saves only 16 bytes of PW msg */
+
+/* Register definitions */
+
+/*
+ * Registers in PCIe configuration space
+ */
+
+#define TSI721_PCIECFG_MSIXTBL	0x0a4
+#define TSI721_MSIXTBL_OFFSET	0x2c000
+#define TSI721_PCIECFG_MSIXPBA	0x0a8
+#define TSI721_MSIXPBA_OFFSET	0x2a000
+#define TSI721_PCIECFG_EPCTL	0x400
+
+/*
+ * Event Management Registers
+ */
+
+#define TSI721_RIO_EM_INT_STAT		0x10910
+#define TSI721_RIO_EM_INT_STAT_PW_RX	0x00010000
+
+#define TSI721_RIO_EM_INT_ENABLE	0x10914
+#define TSI721_RIO_EM_INT_ENABLE_PW_RX	0x00010000
+
+#define TSI721_RIO_EM_DEV_INT_EN	0x10930
+#define TSI721_RIO_EM_DEV_INT_EN_INT	0x00000001
+
+/*
+ * Port-Write Block Registers
+ */
+
+#define TSI721_RIO_PW_CTL		0x10a04
+#define TSI721_RIO_PW_CTL_PW_TIMER	0xf0000000
+#define TSI721_RIO_PW_CTL_PWT_DIS	(0 << 28)
+#define TSI721_RIO_PW_CTL_PWT_103	(1 << 28)
+#define TSI721_RIO_PW_CTL_PWT_205	(1 << 29)
+#define TSI721_RIO_PW_CTL_PWT_410	(1 << 30)
+#define TSI721_RIO_PW_CTL_PWT_820	(1 << 31)
+#define TSI721_RIO_PW_CTL_PWC_MODE	0x01000000
+#define TSI721_RIO_PW_CTL_PWC_CONT	0x00000000
+#define TSI721_RIO_PW_CTL_PWC_REL	0x01000000
+
+#define TSI721_RIO_PW_RX_STAT		0x10a10
+#define TSI721_RIO_PW_RX_STAT_WR_SIZE	0x0000f000
+#define TSI_RIO_PW_RX_STAT_WDPTR	0x00000100
+#define TSI721_RIO_PW_RX_STAT_PW_SHORT	0x00000008
+#define TSI721_RIO_PW_RX_STAT_PW_TRUNC	0x00000004
+#define TSI721_RIO_PW_RX_STAT_PW_DISC	0x00000002
+#define TSI721_RIO_PW_RX_STAT_PW_VAL	0x00000001
+
+#define TSI721_RIO_PW_RX_CAPT(x)	(0x10a20 + (x)*4)
+
+/*
+ * Inbound Doorbells
+ */
+
+#define TSI721_IDB_ENTRY_SIZE	64
+
+#define TSI721_IDQ_CTL(x)	(0x20000 + (x) * 1000)
+#define TSI721_IDQ_SUSPEND	0x00000002
+#define TSI721_IDQ_INIT		0x00000001
+
+#define TSI721_IDQ_STS(x)	(0x20004 + (x) * 1000)
+#define TSI721_IDQ_RUN		0x00200000
+
+#define TSI721_IDQ_MASK(x)	(0x20008 + (x) * 1000)
+#define TSI721_IDQ_MASK_MASK	0xffff0000
+#define TSI721_IDQ_MASK_PATT	0x0000ffff
+
+#define TSI721_IDQ_RP(x)	(0x2000c + (x) * 1000)
+#define TSI721_IDQ_RP_PTR	0x0007ffff
+
+#define TSI721_IDQ_WP(x)	(0x20010 + (x) * 1000)
+#define TSI721_IDQ_WP_PTR	0x0007ffff
+
+#define TSI721_IDQ_BASEL(x)	(0x20014 + (x) * 1000)
+#define TSI721_IDQ_BASEL_ADDR	0xffffffc0
+#define TSI721_IDQ_BASEU(x)	(0x20018 + (x) * 1000)
+#define TSI721_IDQ_SIZE(x)	(0x2001c + (x) * 1000)
+#define TSI721_IDQ_SIZE_VAL(size)	(__fls(size) - 4)
+#define TSI721_IDQ_SIZE_MIN	512
+#define TSI721_IDQ_SIZE_MAX	(512 * 1024)
+
+#define TSI721_SR_CHINT(x)	(0x20040 + (x) * 1000)
+#define TSI721_SR_CHINTE(x)	(0x20044 + (x) * 1000)
+#define TSI721_SR_CHINTSET(x)	(0x20048 + (x) * 1000)
+#define TSI721_SR_CHINT_ODBOK	0x00000020
+#define TSI721_SR_CHINT_IDBQRCV	0x00000010
+#define TSI721_SR_CHINT_SUSP	0x00000008
+#define TSI721_SR_CHINT_ODBTO	0x00000004
+#define TSI721_SR_CHINT_ODBRTRY	0x00000002
+#define TSI721_SR_CHINT_ODBERR	0x00000001
+#define TSI721_SR_CHINT_ALL	0x0000003f
+
+#define TSI721_IBWIN_NUM	8
+
+#define TSI721_IBWINLB(x)	(0x29000 + (x) * 20)
+#define TSI721_IBWINLB_BA	0xfffff000
+#define TSI721_IBWINLB_WEN	0x00000001
+
+#define TSI721_SR2PC_GEN_INTE	0x29800
+#define TSI721_SR2PC_PWE	0x29804
+#define TSI721_SR2PC_GEN_INT	0x29808
+
+#define TSI721_DEV_INTE		0x29840
+#define TSI721_DEV_INT		0x29844
+#define TSI721_DEV_INTSET	0x29848
+#define TSI721_DEV_INT_SMSG_CH	0x00000800
+#define TSI721_DEV_INT_SMSG_NCH	0x00000400
+#define TSI721_DEV_INT_SR2PC_CH	0x00000200
+#define TSI721_DEV_INT_SRIO	0x00000020
+
+#define TSI721_DEV_CHAN_INTE	0x2984c
+#define TSI721_DEV_CHAN_INT	0x29850
+
+#define TSI721_INT_SR2PC_CHAN_M	0xff000000
+#define TSI721_INT_SR2PC_CHAN(x) (1 << (24 + (x)))
+#define TSI721_INT_IMSG_CHAN_M	0x00ff0000
+#define TSI721_INT_IMSG_CHAN(x)	(1 << (16 + (x)))
+#define TSI721_INT_OMSG_CHAN_M	0x0000ff00
+#define TSI721_INT_OMSG_CHAN(x)	(1 << (8 + (x)))
+
+/*
+ * PC2SR block registers
+ */
+#define TSI721_OBWIN_NUM	TSI721_PC2SR_WINS
+
+#define TSI721_OBWINLB(x)	(0x40000 + (x) * 20)
+#define TSI721_OBWINLB_BA	0xffff8000
+#define TSI721_OBWINLB_WEN	0x00000001
+
+#define TSI721_OBWINUB(x)	(0x40004 + (x) * 20)
+
+#define TSI721_OBWINSZ(x)	(0x40008 + (x) * 20)
+#define TSI721_OBWINSZ_SIZE	0x00001f00
+#define TSI721_OBWIN_SIZE(size)	(__fls(size) - 15)
+
+#define TSI721_ZONE_SEL		0x41300
+#define TSI721_ZONE_SEL_RD_WRB	0x00020000
+#define TSI721_ZONE_SEL_GO	0x00010000
+#define TSI721_ZONE_SEL_WIN	0x00000038
+#define TSI721_ZONE_SEL_ZONE	0x00000007
+
+#define TSI721_LUT_DATA0	0x41304
+#define TSI721_LUT_DATA0_ADD	0xfffff000
+#define TSI721_LUT_DATA0_RDTYPE	0x00000f00
+#define TSI721_LUT_DATA0_NREAD	0x00000100
+#define TSI721_LUT_DATA0_MNTRD	0x00000200
+#define TSI721_LUT_DATA0_RDCRF	0x00000020
+#define TSI721_LUT_DATA0_WRCRF	0x00000010
+#define TSI721_LUT_DATA0_WRTYPE	0x0000000f
+#define TSI721_LUT_DATA0_NWR	0x00000001
+#define TSI721_LUT_DATA0_MNTWR	0x00000002
+#define TSI721_LUT_DATA0_NWR_R	0x00000004
+
+#define TSI721_LUT_DATA1	0x41308
+
+#define TSI721_LUT_DATA2	0x4130c
+#define TSI721_LUT_DATA2_HC	0xff000000
+#define TSI721_LUT_DATA2_ADD65	0x000c0000
+#define TSI721_LUT_DATA2_TT	0x00030000
+#define TSI721_LUT_DATA2_DSTID	0x0000ffff
+
+#define TSI721_PC2SR_INTE	0x41310
+
+#define TSI721_DEVCTL		0x48004
+#define TSI721_DEVCTL_SRBOOT_CMPL	0x00000004
+
+#define TSI721_I2C_INT_ENABLE	0x49120
+
+/*
+ * Block DMA Engine Registers
+ *   x = 0..7
+ */
+
+#define TSI721_DMAC_DWRCNT(x)	(0x51000 + (x) * 0x1000)
+#define TSI721_DMAC_DRDCNT(x)	(0x51004 + (x) * 0x1000)
+
+#define TSI721_DMAC_CTL(x)	(0x51008 + (x) * 0x1000)
+#define TSI721_DMAC_CTL_SUSP	0x00000002
+#define TSI721_DMAC_CTL_INIT	0x00000001
+
+#define TSI721_DMAC_INT(x)	(0x5100c + (x) * 0x1000)
+#define TSI721_DMAC_INT_STFULL	0x00000010
+#define TSI721_DMAC_INT_DONE	0x00000008
+#define TSI721_DMAC_INT_SUSP	0x00000004
+#define TSI721_DMAC_INT_ERR	0x00000002
+#define TSI721_DMAC_INT_IOFDONE	0x00000001
+#define TSI721_DMAC_INT_ALL	0x0000001f
+
+#define TSI721_DMAC_INTSET(x)	(0x51010 + (x) * 0x1000)
+
+#define TSI721_DMAC_STS(x)	(0x51014 + (x) * 0x1000)
+#define TSI721_DMAC_STS_ABORT	0x00400000
+#define TSI721_DMAC_STS_RUN	0x00200000
+#define TSI721_DMAC_STS_CS	0x001f0000
+
+#define TSI721_DMAC_INTE(x)	(0x51018 + (x) * 0x1000)
+
+#define TSI721_DMAC_DPTRL(x)	(0x51024 + (x) * 0x1000)
+#define TSI721_DMAC_DPTRL_MASK	0xffffffe0
+
+#define TSI721_DMAC_DPTRH(x)	(0x51028 + (x) * 0x1000)
+
+#define TSI721_DMAC_DSBL(x)	(0x5102c + (x) * 0x1000)
+#define TSI721_DMAC_DSBL_MASK	0xffffffc0
+
+#define TSI721_DMAC_DSBH(x)	(0x51030 + (x) * 0x1000)
+
+#define TSI721_DMAC_DSSZ(x)	(0x51034 + (x) * 0x1000)
+#define TSI721_DMAC_DSSZ_SIZE_M	0x0000000f
+#define TSI721_DMAC_DSSZ_SIZE(size)	(__fls(size) - 4)
+
+
+#define TSI721_DMAC_DSRP(x)	(0x51038 + (x) * 0x1000)
+#define TSI721_DMAC_DSRP_MASK	0x0007ffff
+
+#define TSI721_DMAC_DSWP(x)	(0x5103c + (x) * 0x1000)
+#define TSI721_DMAC_DSWP_MASK	0x0007ffff
+
+#define TSI721_BDMA_INTE	0x5f000
+
+/*
+ * Messaging definitions
+ */
+#define TSI721_MSG_BUFFER_SIZE		RIO_MAX_MSG_SIZE
+#define TSI721_MSG_MAX_SIZE		RIO_MAX_MSG_SIZE
+#define TSI721_IMSG_MAXCH		8
+#define TSI721_IMSG_CHNUM		TSI721_IMSG_MAXCH
+#define TSI721_IMSGD_MIN_RING_SIZE	32
+#define TSI721_IMSGD_RING_SIZE		512
+
+#define TSI721_OMSG_CHNUM		4 /* One channel per MBOX */
+#define TSI721_OMSGD_MIN_RING_SIZE	32
+#define TSI721_OMSGD_RING_SIZE		512
+
+/*
+ * Outbound Messaging Engine Registers
+ *   x = 0..7
+ */
+
+#define TSI721_OBDMAC_DWRCNT(x)		(0x61000 + (x) * 0x1000)
+
+#define TSI721_OBDMAC_DRDCNT(x)		(0x61004 + (x) * 0x1000)
+
+#define TSI721_OBDMAC_CTL(x)		(0x61008 + (x) * 0x1000)
+#define TSI721_OBDMAC_CTL_MASK		0x00000007
+#define TSI721_OBDMAC_CTL_RETRY_THR	0x00000004
+#define TSI721_OBDMAC_CTL_SUSPEND	0x00000002
+#define TSI721_OBDMAC_CTL_INIT		0x00000001
+
+#define TSI721_OBDMAC_INT(x)		(0x6100c + (x) * 0x1000)
+#define TSI721_OBDMAC_INTSET(x)		(0x61010 + (x) * 0x1000)
+#define TSI721_OBDMAC_INTE(x)		(0x61018 + (x) * 0x1000)
+#define TSI721_OBDMAC_INT_MASK		0x0000001F
+#define TSI721_OBDMAC_INT_ST_FULL	0x00000010
+#define TSI721_OBDMAC_INT_DONE		0x00000008
+#define TSI721_OBDMAC_INT_SUSPENDED	0x00000004
+#define TSI721_OBDMAC_INT_ERROR		0x00000002
+#define TSI721_OBDMAC_INT_IOF_DONE	0x00000001
+#define TSI721_OBDMAC_INT_ALL		TSI721_OBDMAC_INT_MASK
+
+#define TSI721_OBDMAC_STS(x)		(0x61014 + (x) * 0x1000)
+#define TSI721_OBDMAC_STS_MASK		0x007f0000
+#define TSI721_OBDMAC_STS_ABORT		0x00400000
+#define TSI721_OBDMAC_STS_RUN		0x00200000
+#define TSI721_OBDMAC_STS_CS		0x001f0000
+
+#define TSI721_OBDMAC_PWE(x)		(0x6101c + (x) * 0x1000)
+#define TSI721_OBDMAC_PWE_MASK		0x00000002
+#define TSI721_OBDMAC_PWE_ERROR_EN	0x00000002
+
+#define TSI721_OBDMAC_DPTRL(x)		(0x61020 + (x) * 0x1000)
+#define TSI721_OBDMAC_DPTRL_MASK	0xfffffff0
+
+#define TSI721_OBDMAC_DPTRH(x)		(0x61024 + (x) * 0x1000)
+#define TSI721_OBDMAC_DPTRH_MASK	0xffffffff
+
+#define TSI721_OBDMAC_DSBL(x)		(0x61040 + (x) * 0x1000)
+#define TSI721_OBDMAC_DSBL_MASK		0xffffffc0
+
+#define TSI721_OBDMAC_DSBH(x)		(0x61044 + (x) * 0x1000)
+#define TSI721_OBDMAC_DSBH_MASK		0xffffffff
+
+#define TSI721_OBDMAC_DSSZ(x)		(0x61048 + (x) * 0x1000)
+#define TSI721_OBDMAC_DSSZ_MASK		0x0000000f
+
+#define TSI721_OBDMAC_DSRP(x)		(0x6104c + (x) * 0x1000)
+#define TSI721_OBDMAC_DSRP_MASK		0x0007ffff
+
+#define TSI721_OBDMAC_DSWP(x)		(0x61050 + (x) * 0x1000)
+#define TSI721_OBDMAC_DSWP_MASK		0x0007ffff
+
+#define TSI721_RQRPTO			0x60010
+#define TSI721_RQRPTO_MASK		0x00ffffff
+#define TSI721_RQRPTO_VAL		400	/* Response TO value */
+
+/*
+ * Inbound Messaging Engine Registers
+ *   x = 0..7
+ */
+
+#define TSI721_IB_DEVID_GLOBAL		0xffff
+#define TSI721_IBDMAC_FQBL(x)		(0x61200 + (x) * 0x1000)
+#define TSI721_IBDMAC_FQBL_MASK		0xffffffc0
+
+#define TSI721_IBDMAC_FQBH(x)		(0x61204 + (x) * 0x1000)
+#define TSI721_IBDMAC_FQBH_MASK		0xffffffff
+
+#define TSI721_IBDMAC_FQSZ_ENTRY_INX	TSI721_IMSGD_RING_SIZE
+#define TSI721_IBDMAC_FQSZ(x)		(0x61208 + (x) * 0x1000)
+#define TSI721_IBDMAC_FQSZ_MASK		0x0000000f
+
+#define TSI721_IBDMAC_FQRP(x)		(0x6120c + (x) * 0x1000)
+#define TSI721_IBDMAC_FQRP_MASK		0x0007ffff
+
+#define TSI721_IBDMAC_FQWP(x)		(0x61210 + (x) * 0x1000)
+#define TSI721_IBDMAC_FQWP_MASK		0x0007ffff
+
+#define TSI721_IBDMAC_FQTH(x)		(0x61214 + (x) * 0x1000)
+#define TSI721_IBDMAC_FQTH_MASK		0x0007ffff
+
+#define TSI721_IB_DEVID			0x60020
+#define TSI721_IB_DEVID_MASK		0x0000ffff
+
+#define TSI721_IBDMAC_CTL(x)		(0x61240 + (x) * 0x1000)
+#define TSI721_IBDMAC_CTL_MASK		0x00000003
+#define TSI721_IBDMAC_CTL_SUSPEND	0x00000002
+#define TSI721_IBDMAC_CTL_INIT		0x00000001
+
+#define TSI721_IBDMAC_STS(x)		(0x61244 + (x) * 0x1000)
+#define TSI721_IBDMAC_STS_MASK		0x007f0000
+#define TSI721_IBSMAC_STS_ABORT		0x00400000
+#define TSI721_IBSMAC_STS_RUN		0x00200000
+#define TSI721_IBSMAC_STS_CS		0x001f0000
+
+#define TSI721_IBDMAC_INT(x)		(0x61248 + (x) * 0x1000)
+#define TSI721_IBDMAC_INTSET(x)		(0x6124c + (x) * 0x1000)
+#define TSI721_IBDMAC_INTE(x)		(0x61250 + (x) * 0x1000)
+#define TSI721_IBDMAC_INT_MASK		0x0000100f
+#define TSI721_IBDMAC_INT_SRTO		0x00001000
+#define TSI721_IBDMAC_INT_SUSPENDED	0x00000008
+#define TSI721_IBDMAC_INT_PC_ERROR	0x00000004
+#define TSI721_IBDMAC_INT_FQ_LOW	0x00000002
+#define TSI721_IBDMAC_INT_DQ_RCV	0x00000001
+#define TSI721_IBDMAC_INT_ALL		TSI721_IBDMAC_INT_MASK
+
+#define TSI721_IBDMAC_PWE(x)		(0x61254 + (x) * 0x1000)
+#define TSI721_IBDMAC_PWE_MASK		0x00001700
+#define TSI721_IBDMAC_PWE_SRTO		0x00001000
+#define TSI721_IBDMAC_PWE_ILL_FMT	0x00000400
+#define TSI721_IBDMAC_PWE_ILL_DEC	0x00000200
+#define TSI721_IBDMAC_PWE_IMP_SP	0x00000100
+
+#define TSI721_IBDMAC_DQBL(x)		(0x61300 + (x) * 0x1000)
+#define TSI721_IBDMAC_DQBL_MASK		0xffffffc0
+#define TSI721_IBDMAC_DQBL_ADDR		0xffffffc0
+
+#define TSI721_IBDMAC_DQBH(x)		(0x61304 + (x) * 0x1000)
+#define TSI721_IBDMAC_DQBH_MASK		0xffffffff
+
+#define TSI721_IBDMAC_DQRP(x)		(0x61308 + (x) * 0x1000)
+#define TSI721_IBDMAC_DQRP_MASK		0x0007ffff
+
+#define TSI721_IBDMAC_DQWR(x)		(0x6130c + (x) * 0x1000)
+#define TSI721_IBDMAC_DQWR_MASK		0x0007ffff
+
+#define TSI721_IBDMAC_DQSZ(x)		(0x61314 + (x) * 0x1000)
+#define TSI721_IBDMAC_DQSZ_MASK		0x0000000f
+
+/*
+ * Messaging Engine Interrupts
+ */
+
+#define TSI721_SMSG_PWE			0x6a004
+
+#define TSI721_SMSG_INTE		0x6a000
+#define TSI721_SMSG_INT			0x6a008
+#define TSI721_SMSG_INTSET		0x6a010
+#define TSI721_SMSG_INT_MASK		0x0086ffff
+#define TSI721_SMSG_INT_UNS_RSP		0x00800000
+#define TSI721_SMSG_INT_ECC_NCOR	0x00040000
+#define TSI721_SMSG_INT_ECC_COR		0x00020000
+#define TSI721_SMSG_INT_ECC_NCOR_CH	0x0000ff00
+#define TSI721_SMSG_INT_ECC_COR_CH	0x000000ff
+
+#define TSI721_SMSG_ECC_LOG		0x6a014
+#define TSI721_SMSG_ECC_LOG_MASK	0x00070007
+#define TSI721_SMSG_ECC_LOG_ECC_NCOR_M	0x00070000
+#define TSI721_SMSG_ECC_LOG_ECC_COR_M	0x00000007
+
+#define TSI721_RETRY_GEN_CNT		0x6a100
+#define TSI721_RETRY_GEN_CNT_MASK	0xffffffff
+
+#define TSI721_RETRY_RX_CNT		0x6a104
+#define TSI721_RETRY_RX_CNT_MASK	0xffffffff
+
+#define TSI721_SMSG_ECC_COR_LOG(x)	(0x6a300 + (x) * 4)
+#define TSI721_SMSG_ECC_COR_LOG_MASK	0x000000ff
+
+#define TSI721_SMSG_ECC_NCOR(x)		(0x6a340 + (x) * 4)
+#define TSI721_SMSG_ECC_NCOR_MASK	0x000000ff
+
+/*
+ * Block DMA Descriptors
+ */
+
+struct tsi721_dma_desc {
+	__le32 type_id;
+
+#define TSI721_DMAD_DEVID	0x0000ffff
+#define TSI721_DMAD_CRF		0x00010000
+#define TSI721_DMAD_PRIO	0x00060000
+#define TSI721_DMAD_RTYPE	0x00780000
+#define TSI721_DMAD_IOF		0x08000000
+#define TSI721_DMAD_DTYPE	0xe0000000
+
+	__le32 bcount;
+
+#define TSI721_DMAD_BCOUNT1	0x03ffffff /* if DTYPE == 1 */
+#define TSI721_DMAD_BCOUNT2	0x0000000f /* if DTYPE == 2 */
+#define TSI721_DMAD_TT		0x0c000000
+#define TSI721_DMAD_RADDR0	0xc0000000
+
+	union {
+		__le32 raddr_lo;	   /* if DTYPE == (1 || 2) */
+		__le32 next_lo;		   /* if DTYPE == 3 */
+	};
+
+#define TSI721_DMAD_CFGOFF	0x00ffffff
+#define TSI721_DMAD_HOPCNT	0xff000000
+
+	union {
+		__le32 raddr_hi;	   /* if DTYPE == (1 || 2) */
+		__le32 next_hi;		   /* if DTYPE == 3 */
+	};
+
+	union {
+		struct {		   /* if DTYPE == 1 */
+			__le32 bufptr_lo;
+			__le32 bufptr_hi;
+			__le32 s_dist;
+			__le32 s_size;
+		} t1;
+		__le32 data[4];		   /* if DTYPE == 2 */
+		u32    reserved[4];	   /* if DTYPE == 3 */
+	};
+} __aligned(32);
+
+/*
+ * Inbound Messaging Descriptor
+ */
+struct tsi721_imsg_desc {
+	__le32 type_id;
+
+#define TSI721_IMD_DEVID	0x0000ffff
+#define TSI721_IMD_CRF		0x00010000
+#define TSI721_IMD_PRIO		0x00060000
+#define TSI721_IMD_TT		0x00180000
+#define TSI721_IMD_DTYPE	0xe0000000
+
+	__le32 msg_info;
+
+#define TSI721_IMD_BCOUNT	0x00000ff8
+#define TSI721_IMD_SSIZE	0x0000f000
+#define TSI721_IMD_LETER	0x00030000
+#define TSI721_IMD_XMBOX	0x003c0000
+#define TSI721_IMD_MBOX		0x00c00000
+#define TSI721_IMD_CS		0x78000000
+#define TSI721_IMD_HO		0x80000000
+
+	__le32 bufptr_lo;
+	__le32 bufptr_hi;
+	u32    reserved[12];
+
+} __aligned(64);
+
+/*
+ * Outbound Messaging Descriptor
+ */
+struct tsi721_omsg_desc {
+	__le32 type_id;
+
+#define TSI721_OMD_DEVID	0x0000ffff
+#define TSI721_OMD_CRF		0x00010000
+#define TSI721_OMD_PRIO		0x00060000
+#define TSI721_OMD_IOF		0x08000000
+#define TSI721_OMD_DTYPE	0xe0000000
+#define TSI721_OMD_RSRVD	0x17f80000
+
+	__le32 msg_info;
+
+#define TSI721_OMD_BCOUNT	0x00000ff8
+#define TSI721_OMD_SSIZE	0x0000f000
+#define TSI721_OMD_LETER	0x00030000
+#define TSI721_OMD_XMBOX	0x003c0000
+#define TSI721_OMD_MBOX		0x00c00000
+#define TSI721_OMD_TT		0x0c000000
+
+	union {
+		__le32 bufptr_lo;	/* if DTYPE == 4 */
+		__le32 next_lo;		/* if DTYPE == 5 */
+	};
+
+	union {
+		__le32 bufptr_hi;	/* if DTYPE == 4 */
+		__le32 next_hi;		/* if DTYPE == 5 */
+	};
+
+} __aligned(16);
+
+struct tsi721_dma_sts {
+	__le64	desc_sts[8];
+} __aligned(64);
+
+struct tsi721_desc_sts_fifo {
+	union {
+		__le64	da64;
+		struct {
+			__le32	lo;
+			__le32	hi;
+		} da32;
+	} stat[8];
+} __aligned(64);
+
+/* Descriptor types for BDMA and Messaging blocks */
+enum dma_dtype {
+	DTYPE1 = 1, /* Data Transfer DMA Descriptor */
+	DTYPE2 = 2, /* Immediate Data Transfer DMA Descriptor */
+	DTYPE3 = 3, /* Block Pointer DMA Descriptor */
+	DTYPE4 = 4, /* Outbound Msg DMA Descriptor */
+	DTYPE5 = 5, /* OB Messaging Block Pointer Descriptor */
+	DTYPE6 = 6  /* Inbound Messaging Descriptor */
+};
+
+enum dma_rtype {
+	NREAD = 0,
+	LAST_NWRITE_R = 1,
+	ALL_NWRITE = 2,
+	ALL_NWRITE_R = 3,
+	MAINT_RD = 4,
+	MAINT_WR = 5
+};
+
+/*
+ * mport Driver Definitions
+ */
+#define TSI721_DMA_CHNUM	TSI721_DMA_MAXCH
+
+#define TSI721_DMACH_MAINT	0	/* DMA channel for maint requests */
+#define TSI721_DMACH_MAINT_NBD	32	/* Number of BDs for maint requests */
+
+#define MSG_DMA_ENTRY_INX_TO_SIZE(x)	((0x10 << (x)) & 0xFFFF0)
+
+enum tsi721_smsg_int_flag {
+	SMSG_INT_NONE		= 0x00000000,
+	SMSG_INT_ECC_COR_CH	= 0x000000ff,
+	SMSG_INT_ECC_NCOR_CH	= 0x0000ff00,
+	SMSG_INT_ECC_COR	= 0x00020000,
+	SMSG_INT_ECC_NCOR	= 0x00040000,
+	SMSG_INT_UNS_RSP	= 0x00800000,
+	SMSG_INT_ALL		= 0x0006ffff
+};
+
+/* Structures */
+
+struct tsi721_bdma_chan {
+	int		bd_num;		/* number of buffer descriptors */
+	void		*bd_base;	/* start of DMA descriptors */
+	dma_addr_t	bd_phys;
+	void		*sts_base;	/* start of DMA BD status FIFO */
+	dma_addr_t	sts_phys;
+	int		sts_size;
+};
+
+struct tsi721_imsg_ring {
+	u32		size;
+	/* VA/PA of data buffers for incoming messages */
+	void		*buf_base;
+	dma_addr_t	buf_phys;
+	/* VA/PA of circular free buffer list */
+	void		*imfq_base;
+	dma_addr_t	imfq_phys;
+	/* VA/PA of Inbound message descriptors */
+	void		*imd_base;
+	dma_addr_t	imd_phys;
+	 /* Inbound Queue buffer pointers */
+	void		*imq_base[TSI721_IMSGD_RING_SIZE];
+
+	u32		rx_slot;
+	void		*dev_id;
+	u32		fq_wrptr;
+	u32		desc_rdptr;
+	spinlock_t	lock;
+};
+
+struct tsi721_omsg_ring {
+	u32		size;
+	/* VA/PA of OB Msg descriptors */
+	void		*omd_base;
+	dma_addr_t	omd_phys;
+	/* VA/PA of OB Msg data buffers */
+	void		*omq_base[TSI721_OMSGD_RING_SIZE];
+	dma_addr_t	omq_phys[TSI721_OMSGD_RING_SIZE];
+	/* VA/PA of OB Msg descriptor status FIFO */
+	void		*sts_base;
+	dma_addr_t	sts_phys;
+	u32		sts_size; /* # of allocated status entries */
+	u32		sts_rdptr;
+
+	u32		tx_slot;
+	void		*dev_id;
+	u32		wr_count;
+	spinlock_t	lock;
+};
+
+enum tsi721_flags {
+	TSI721_USING_MSI	= (1 << 0),
+	TSI721_USING_MSIX	= (1 << 1),
+	TSI721_IMSGID_SET	= (1 << 2),
+};
+
+#ifdef CONFIG_PCI_MSI
+/*
+ * MSI-X Table Entries (0 ... 69)
+ */
+#define TSI721_MSIX_DMACH_DONE(x)	(0 + (x))
+#define TSI721_MSIX_DMACH_INT(x)	(8 + (x))
+#define TSI721_MSIX_BDMA_INT		16
+#define TSI721_MSIX_OMSG_DONE(x)	(17 + (x))
+#define TSI721_MSIX_OMSG_INT(x)		(25 + (x))
+#define TSI721_MSIX_IMSG_DQ_RCV(x)	(33 + (x))
+#define TSI721_MSIX_IMSG_INT(x)		(41 + (x))
+#define TSI721_MSIX_MSG_INT		49
+#define TSI721_MSIX_SR2PC_IDBQ_RCV(x)	(50 + (x))
+#define TSI721_MSIX_SR2PC_CH_INT(x)	(58 + (x))
+#define TSI721_MSIX_SR2PC_INT		66
+#define TSI721_MSIX_PC2SR_INT		67
+#define TSI721_MSIX_SRIO_MAC_INT	68
+#define TSI721_MSIX_I2C_INT		69
+
+/* MSI-X vector and init table entry indexes */
+enum tsi721_msix_vect {
+	TSI721_VECT_IDB,
+	TSI721_VECT_PWRX, /* PW_RX is part of SRIO MAC Interrupt reporting */
+	TSI721_VECT_OMB0_DONE,
+	TSI721_VECT_OMB1_DONE,
+	TSI721_VECT_OMB2_DONE,
+	TSI721_VECT_OMB3_DONE,
+	TSI721_VECT_OMB0_INT,
+	TSI721_VECT_OMB1_INT,
+	TSI721_VECT_OMB2_INT,
+	TSI721_VECT_OMB3_INT,
+	TSI721_VECT_IMB0_RCV,
+	TSI721_VECT_IMB1_RCV,
+	TSI721_VECT_IMB2_RCV,
+	TSI721_VECT_IMB3_RCV,
+	TSI721_VECT_IMB0_INT,
+	TSI721_VECT_IMB1_INT,
+	TSI721_VECT_IMB2_INT,
+	TSI721_VECT_IMB3_INT,
+	TSI721_VECT_MAX
+};
+
+#define IRQ_DEVICE_NAME_MAX	64
+
+struct msix_irq {
+	u16	vector;
+	char	irq_name[IRQ_DEVICE_NAME_MAX];
+};
+#endif /* CONFIG_PCI_MSI */
+
+struct tsi721_device {
+	struct pci_dev	*pdev;
+	struct rio_mport *mport;
+	u32		flags;
+	void __iomem	*regs;
+#ifdef CONFIG_PCI_MSI
+	struct msix_irq	msix[TSI721_VECT_MAX];
+#endif
+	/* Doorbells */
+	void __iomem	*odb_base;
+	void		*idb_base;
+	dma_addr_t	idb_dma;
+	struct work_struct idb_work;
+	u32		db_discard_count;
+
+	/* Inbound Port-Write */
+	struct work_struct pw_work;
+	struct kfifo	pw_fifo;
+	spinlock_t	pw_fifo_lock;
+	u32		pw_discard_count;
+
+	/* BDMA Engine */
+	struct tsi721_bdma_chan bdma[TSI721_DMA_CHNUM];
+
+	/* Inbound Messaging */
+	int		imsg_init[TSI721_IMSG_CHNUM];
+	struct tsi721_imsg_ring imsg_ring[TSI721_IMSG_CHNUM];
+
+	/* Outbound Messaging */
+	int		omsg_init[TSI721_OMSG_CHNUM];
+	struct tsi721_omsg_ring	omsg_ring[TSI721_OMSG_CHNUM];
+};
+
+#endif
diff -puN include/linux/rio_ids.h~rapidio-add-mport-driver-for-tsi721-bridge include/linux/rio_ids.h
--- a/include/linux/rio_ids.h~rapidio-add-mport-driver-for-tsi721-bridge
+++ a/include/linux/rio_ids.h
@@ -39,5 +39,6 @@
 #define RIO_DID_IDTCPS1616		0x0379
 #define RIO_DID_IDTVPS1616		0x0377
 #define RIO_DID_IDTSPS1616		0x0378
+#define RIO_DID_TSI721			0x80ab
 
 #endif				/* LINUX_RIO_IDS_H */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

