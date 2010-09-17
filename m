From: akpm@linux-foundation.org
Subject: + memstick-add-driver-for-ricoh-r5c592-card-reader.patch added to -mm tree
Date: Fri, 17 Sep 2010 16:18:04 -0700
Message-ID: <201009172318.o8HNI4Ig015826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637Ab0IQXSI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 19:18:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, oakad@yahoo.com


The patch titled
     memstick: add driver for Ricoh R5C592 card reader
has been added to the -mm tree.  Its filename is
     memstick-add-driver-for-ricoh-r5c592-card-reader.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: add driver for Ricoh R5C592 card reader
From: Maxim Levitsky <maximlevitsky@gmail.com>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Acked-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                    |    5 
 drivers/memstick/host/Kconfig  |   13 
 drivers/memstick/host/Makefile |    1 
 drivers/memstick/host/r592.c   |  893 +++++++++++++++++++++++++++++++
 drivers/memstick/host/r592.h   |  177 ++++++
 5 files changed, 1089 insertions(+)

diff -puN MAINTAINERS~memstick-add-driver-for-ricoh-r5c592-card-reader MAINTAINERS
--- a/MAINTAINERS~memstick-add-driver-for-ricoh-r5c592-card-reader
+++ a/MAINTAINERS
@@ -4946,6 +4946,11 @@ S:	Maintained
 F:	drivers/mtd/nand/r852.c
 F:	drivers/mtd/nand/r852.h
 
+RICOH R5C592 MEMORYSTICK DRIVER
+M:	Maxim Levitsky <maximlevitsky@gmail.com>
+S:	Maintained
+F:	drivers/memstick/host/r592.*
+
 RISCOM8 DRIVER
 S:	Orphan
 F:	Documentation/serial/riscom8.txt
diff -puN drivers/memstick/host/Kconfig~memstick-add-driver-for-ricoh-r5c592-card-reader drivers/memstick/host/Kconfig
--- a/drivers/memstick/host/Kconfig~memstick-add-driver-for-ricoh-r5c592-card-reader
+++ a/drivers/memstick/host/Kconfig
@@ -30,3 +30,16 @@ config MEMSTICK_JMICRON_38X
 
           To compile this driver as a module, choose M here: the
 	  module will be called jmb38x_ms.
+
+config MEMSTICK_R592
+	tristate "Ricoh R5C592 MemoryStick interface support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && PCI
+
+	help
+	  Say Y here if you want to be able to access MemoryStick cards with
+	  the Ricoh R5C592 MemoryStick card reader (which is part of 5 in one
+		multifunction reader)
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called r592.
+
diff -puN drivers/memstick/host/Makefile~memstick-add-driver-for-ricoh-r5c592-card-reader drivers/memstick/host/Makefile
--- a/drivers/memstick/host/Makefile~memstick-add-driver-for-ricoh-r5c592-card-reader
+++ a/drivers/memstick/host/Makefile
@@ -8,3 +8,4 @@ endif
 
 obj-$(CONFIG_MEMSTICK_TIFM_MS)		+= tifm_ms.o
 obj-$(CONFIG_MEMSTICK_JMICRON_38X)	+= jmb38x_ms.o
+obj-$(CONFIG_MEMSTICK_R592)		+= r592.o
diff -puN /dev/null drivers/memstick/host/r592.c
--- /dev/null
+++ a/drivers/memstick/host/r592.c
@@ -0,0 +1,893 @@
+/*
+ * Copyright (C) 2010 - Maxim Levitsky
+ * driver for Ricoh memstick readers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/freezer.h>
+#include <linux/jiffies.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/highmem.h>
+#include <asm/byteorder.h>
+#include "r592.h"
+
+static int enable_dma = 1;
+static int debug;
+
+static const char *tpc_names[] = {
+	"MS_TPC_READ_MG_STATUS",
+	"MS_TPC_READ_LONG_DATA",
+	"MS_TPC_READ_SHORT_DATA",
+	"MS_TPC_READ_REG",
+	"MS_TPC_READ_QUAD_DATA",
+	"MS_INVALID",
+	"MS_TPC_GET_INT",
+	"MS_TPC_SET_RW_REG_ADRS",
+	"MS_TPC_EX_SET_CMD",
+	"MS_TPC_WRITE_QUAD_DATA",
+	"MS_TPC_WRITE_REG",
+	"MS_TPC_WRITE_SHORT_DATA",
+	"MS_TPC_WRITE_LONG_DATA",
+	"MS_TPC_SET_CMD",
+};
+
+static const char *dbg_tpc_name(int tpc)
+{
+	return tpc_names[tpc-1];
+}
+
+/* Read a register*/
+static inline u32 r592_read_reg(struct r592_device *dev, int address)
+{
+	u32 value = le32_to_cpu(readl(dev->mmio + address));
+	dbg_reg("reg #%02d == 0x%08x", address, value);
+	return value;
+}
+
+/* Write a register */
+static inline void r592_write_reg(struct r592_device *dev,
+							int address, u32 value)
+{
+	dbg_reg("reg #%02d <- 0x%08x", address, value);
+	writel(cpu_to_le32(value), dev->mmio + address);
+	mmiowb();
+}
+
+/* Reads a big endian DWORD register */
+static inline u32 r592_read_reg_be(struct r592_device *dev, int address)
+{
+	return be32_to_cpu(r592_read_reg(dev, address));
+}
+
+/* Writes a big endian DWORD register */
+static inline void r592_write_reg_be(struct r592_device *dev,
+							int address, u32 value)
+{
+	return r592_write_reg(dev, address, cpu_to_be32(value));
+}
+
+/* Set specific bits in a register (little endian) */
+static inline void r592_set_reg_mask(struct r592_device *dev,
+							int address, u32 mask)
+{
+	u32 reg = readl(dev->mmio + address);
+	dbg_reg("reg #%02d |= 0x%08x (old =0x%08x)", address, mask, reg);
+	writel(cpu_to_le32(reg | mask) , dev->mmio + address);
+	mmiowb();
+}
+
+/* Clear specific bits in a register (little endian) */
+static inline void r592_clear_reg_mask(struct r592_device *dev,
+						int address, u32 mask)
+{
+	u32 reg = readl(dev->mmio + address);
+	dbg_reg("reg #%02d &= 0x%08x (old = 0x%08x, mask = 0x%08x)",
+						address, ~mask, reg, mask);
+	writel(cpu_to_le32(reg & ~mask), dev->mmio + address);
+	mmiowb();
+}
+
+/* Busy wait till specific bits are set/clear in a register */
+/* Note that this is intended for waits that take very little time */
+static inline int r592_reg_wait(struct r592_device *dev, int address,
+					u32 mask, u32 wanted_mask)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
+
+	if ((r592_read_reg(dev, address) & mask) == wanted_mask)
+		return 0;
+
+	while (time_before(jiffies, timeout)) {
+		if ((r592_read_reg(dev, address) & mask) == wanted_mask)
+			return 0;
+		cpu_relax();
+	}
+	return -ETIME;
+}
+
+/* Wait for status bits while checking for errors */
+static int r592_wait_status(struct r592_device *dev, u32 mask, u32 wanted_mask)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
+	u32 reg = r592_read_reg(dev, R592_STATUS);
+
+	if ((reg & mask) == wanted_mask)
+		return 0;
+
+	while (time_before(jiffies, timeout)) {
+
+		reg = r592_read_reg(dev, R592_STATUS);
+
+		if ((reg & mask) == wanted_mask)
+			return 0;
+
+		if (reg & (R592_STATUS_SEND_ERR | R592_STATUS_RECV_ERR))
+			return -EIO;
+
+		cpu_relax();
+	}
+	return -ETIME;
+}
+
+/* Enable/disable device */
+static int r592_enable_device(struct r592_device *dev, bool enable)
+{
+	dbg("%sabling the device", enable ? "en" : "dis");
+
+	if (enable) {
+		r592_write_reg(dev, R592_REG32, 3);
+	} else {
+		r592_set_reg_mask(dev, R592_IO, R592_IO_RESET);
+		r592_write_reg(dev, R592_REG32, 0);
+	}
+	return 0;
+}
+
+/* Set serial/parallel mode */
+static int r592_set_mode(struct r592_device *dev, bool parallel_mode)
+{
+	if (!parallel_mode) {
+		dbg("enabling serial mode");
+		r592_write_reg(dev, R592_REG36, 1);
+		r592_set_reg_mask(dev, R592_IO, R592_IO_RESET);
+		msleep(100);
+	} else {
+		dbg("enabling parallel mode");
+		r592_set_reg_mask(dev, R592_REG32, R592_REG32_20);
+
+		r592_set_reg_mask(dev, R592_IO, R592_IO_RESET);
+		msleep(100);
+
+		r592_clear_reg_mask(dev, R592_IO,
+			R592_IO_SERIAL1 | R592_IO_SERIAL2);
+
+		r592_write_reg(dev, R592_REG36, 3);
+	}
+
+	dev->parallel_mode = parallel_mode;
+	return 0;
+}
+
+/* Disable all hardware interrupts */
+static void r592_clear_interrupts(struct r592_device *dev)
+{
+	/* Disable & ACK all interrupts */
+	r592_clear_reg_mask(dev, R592_REG_MSC, 0x7F000000);
+	r592_clear_reg_mask(dev, R592_REG_MSC, 0x00007F00);
+}
+
+/* Tests if there is an CRC error */
+static int r592_test_io_error(struct r592_device *dev)
+{
+	if (r592_read_reg(dev, R592_STATUS) &
+		(R592_STATUS_SEND_ERR | R592_STATUS_RECV_ERR)) {
+		message("got IO error");
+		return -EILSEQ;
+	}
+	return 0;
+}
+
+/* Wait for empty fifo. Mostly precation */
+static int r592_wait_fifo_empty(struct r592_device *dev)
+{
+	/* Ensure fifo is ready */
+	int error = r592_reg_wait(dev, R592_REG_MSC,
+		R592_REG_MSC_FIFO_EMPTY, R592_REG_MSC_FIFO_EMPTY);
+
+	if (error) {
+		message("wait for FIFO empty failed");
+		return error;
+	}
+	return 0;
+}
+
+/* Activates the DMA transfer from to FIFO */
+static void r592_start_dma(struct r592_device *dev, bool is_write)
+{
+	unsigned long flags;
+	u32 reg;
+	spin_lock_irqsave(&dev->irq_lock, flags);
+
+	/* Ack interrupts (just in case) + enable them */
+	r592_clear_reg_mask(dev, R592_REG_MSC, DMA_IRQ_ACK_MASK);
+	r592_set_reg_mask(dev, R592_REG_MSC, DMA_IRQ_EN_MASK);
+
+	/* Set DMA address */
+	r592_write_reg(dev, R592_FIFO_DMA, sg_dma_address(&dev->req->sg));
+
+	/* Enable the DMA */
+	reg = r592_read_reg(dev, R592_FIFO_DMA_SETTINGS);
+	reg |= R592_FIFO_DMA_SETTINGS_EN;
+
+	if (!is_write)
+		reg |= R592_FIFO_DMA_SETTINGS_DIR;
+	else
+		reg &= ~R592_FIFO_DMA_SETTINGS_DIR;
+	r592_write_reg(dev, R592_FIFO_DMA_SETTINGS, reg);
+
+	spin_unlock_irqrestore(&dev->irq_lock, flags);
+}
+
+/* Cleanups DMA related settings */
+static void r592_stop_dma(struct r592_device *dev, int error)
+{
+	r592_clear_reg_mask(dev, R592_FIFO_DMA_SETTINGS,
+		R592_FIFO_DMA_SETTINGS_EN);
+
+	/* This is only a precation */
+	r592_write_reg(dev, R592_FIFO_DMA,
+			dev->dummy_dma_page_physical_address);
+
+	r592_clear_reg_mask(dev, R592_REG_MSC, DMA_IRQ_EN_MASK);
+	r592_clear_reg_mask(dev, R592_REG_MSC, DMA_IRQ_ACK_MASK);
+	dev->dma_error = error;
+}
+
+/* Test if hardware supports DMA */
+static void r592_check_dma(struct r592_device *dev)
+{
+	dev->dma_capable = enable_dma &&
+		(r592_read_reg(dev, R592_FIFO_DMA_SETTINGS) &
+			R592_FIFO_DMA_SETTINGS_CAP);
+}
+
+/* Transfers fifo contents in/out using DMA */
+static int r592_transfer_fifo_dma(struct r592_device *dev)
+{
+	int len, sg_count;
+	bool is_write;
+
+	if (!dev->dma_capable || !dev->req->long_data)
+		return -EINVAL;
+
+	len = dev->req->sg.length;
+	is_write = dev->req->data_dir == WRITE;
+
+	if (len != R592_LFIFO_SIZE)
+		return -EINVAL;
+
+	dbg_verbose("doing dma transfer");
+
+	dev->dma_error = 0;
+	INIT_COMPLETION(dev->dma_done);
+
+	/* TODO: hidden assumption about nenth beeing always 1 */
+	sg_count = dma_map_sg(&dev->pci_dev->dev, &dev->req->sg, 1, is_write ?
+		PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
+
+	if (sg_count != 1 ||
+			(sg_dma_len(&dev->req->sg) < dev->req->sg.length)) {
+		message("problem in dma_map_sg");
+		return -EIO;
+	}
+
+	r592_start_dma(dev, is_write);
+
+	/* Wait for DMA completion */
+	if (!wait_for_completion_timeout(
+			&dev->dma_done, msecs_to_jiffies(1000))) {
+		message("DMA timeout");
+		r592_stop_dma(dev, -ETIMEDOUT);
+	}
+
+	dma_unmap_sg(&dev->pci_dev->dev, &dev->req->sg, 1, is_write ?
+		PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
+
+
+	return dev->dma_error;
+}
+
+/*
+ * Writes the FIFO in 4 byte chunks.
+ * If length isn't 4 byte aligned, it spills remaining bytes into 'spill'
+ * buffer.  It also accepts spill from former write to flush a write, just call
+ * this with null  buffer
+ */
+static void r592_write_fifo_pio(struct r592_device *dev,
+	struct dword_buffer *spill, unsigned char *buffer, int len)
+{
+	unsigned char dword[4] = {0};
+
+	if (!buffer) {
+
+		if (!spill->len)
+			return;
+
+		buffer = dword;
+		len = sizeof(dword);
+	}
+
+	/* flush spill from former write */
+	while (spill->len < 4 && len) {
+		spill->dword[spill->len++] = *buffer++;
+		len--;
+	}
+
+	if (spill->len == 4) {
+		r592_write_reg_be(dev, R592_FIFO_PIO, *(u32 *)spill->dword);
+		spill->len = 0;
+	}
+
+	if (!len)
+		return;
+
+	/* write full dwords */
+	while (len >= 4) {
+		r592_write_reg_be(
+			dev, R592_FIFO_PIO, *(u32 *)buffer);
+		buffer += 4;
+		len -= 4;
+	}
+
+	/* put remaining bytes to the spill */
+	while (len--)
+		spill->dword[spill->len++] = *buffer++;
+}
+
+/*
+ * Read a fifo in 4 bytes chunks.
+ * If input doesn't fit the buffer, it places bytes of last dword in spill
+ * buffer, so that they don't get lost on last read, just throw these away.
+ */
+static void r592_read_fifo_pio(struct r592_device *dev,
+		struct dword_buffer *spill, unsigned char *buffer, int len)
+{
+	int i;
+	u32 tmp;
+
+	for (i = 0 ; len && i < spill->len ; i++) {
+		*buffer++ = spill->dword[i];
+		len--;
+		spill->len--;
+	}
+
+	if (spill->len) {
+		memmove(spill->dword, spill->dword + i, spill->len);
+		return;
+	}
+
+	while (len >= 4) {
+		*(u32 *)buffer = r592_read_reg_be(
+					dev, R592_FIFO_PIO);
+		buffer += 4;
+		len -= 4;
+	}
+
+	if (!len)
+		return;
+
+	tmp = r592_read_reg_be(dev, R592_FIFO_PIO);
+
+	spill->len = 4;
+	while (len--) {
+		*buffer++ = tmp & 0xFF;
+		tmp >>= 8;
+		spill->len--;
+	}
+
+	for (i = 0 ; i < spill->len ; i++) {
+		spill->dword[i] = tmp & 0xFF;
+		tmp >>= 8;
+	}
+
+	return;
+}
+
+/* Transfers actual data using PIO. */
+static int r592_transfer_fifo_pio(struct r592_device *dev)
+{
+	unsigned char *buffer;
+	struct dword_buffer spill = {{0}, 0};
+	unsigned long flags;
+
+	bool is_write = dev->req->tpc >= MS_TPC_SET_RW_REG_ADRS;
+	int p_len, p_offset, len, offset;
+	struct page *page;
+
+
+	if (!dev->req->long_data) {
+		if (is_write) {
+			r592_write_fifo_pio(dev, &spill, dev->req->data,
+							dev->req->data_len);
+			r592_write_fifo_pio(dev, &spill, NULL, 0);
+		} else
+			r592_read_fifo_pio(dev, &spill, dev->req->data,
+							dev->req->data_len);
+		return 0;
+	}
+
+	spin_lock_irqsave(&dev->atomic_lock, flags);
+
+	len = dev->req->sg.length;
+	offset = dev->req->sg.offset;
+
+	while (len) {
+
+		p_offset = offset_in_page(offset);
+		p_len = min((int)(PAGE_SIZE - p_offset), len);
+
+		page = nth_page(sg_page(&dev->req->sg), offset >> PAGE_SHIFT);
+		buffer = kmap_atomic(page, KM_BIO_SRC_IRQ) + p_offset;
+
+
+		/* Do the transfer fifo<->memory*/
+		if (is_write)
+			r592_write_fifo_pio(dev, &spill, buffer, p_len);
+		else
+			r592_read_fifo_pio(dev, &spill, buffer, p_len);
+
+		kunmap_atomic(buffer - p_offset, KM_BIO_SRC_IRQ);
+
+		offset += p_len;
+		len -= p_len;
+
+	}
+
+	if (is_write)
+		r592_write_fifo_pio(dev, &spill, NULL, 0);
+
+	spin_unlock_irqrestore(&dev->atomic_lock, flags);
+	return 0;
+}
+
+
+/* Executes one TPC (data is read/written from small or large fifo) */
+static void r592_process_request(struct r592_device *dev)
+{
+	bool is_write = dev->req->tpc >= MS_TPC_SET_RW_REG_ADRS;
+	int len, error;
+	u32 status, reg;
+
+	if (!dev->req) {
+		message("BUG: r592_process_request with no request!");
+		return;
+	}
+
+	len = dev->req->long_data ?
+		dev->req->sg.length : dev->req->data_len;
+
+	/* Ensure that FIFO can hold the input data */
+	WARN_ON(len > R592_LFIFO_SIZE);
+	if (len > R592_LFIFO_SIZE) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	dbg_verbose("IO: executing %s LEN=%d", dbg_tpc_name(dev->req->tpc), len);
+
+	/* Set IO direction */
+	if (is_write)
+		r592_set_reg_mask(dev, R592_IO, R592_IO_DIRECTION);
+	else
+		r592_clear_reg_mask(dev, R592_IO, R592_IO_DIRECTION);
+
+
+	error = r592_wait_fifo_empty(dev);
+	if (error)
+		goto out;
+
+	/* Transfer write data */
+	if (is_write) {
+		error = r592_transfer_fifo_dma(dev);
+		if (error == -EINVAL)
+			error = r592_transfer_fifo_pio(dev);
+	}
+
+	if (error)
+		goto out;
+
+	/* Trigger the TPC */
+	reg = (len << R592_TPC_EXEC_LEN_SHIFT) |
+		(dev->req->tpc << R592_TPC_EXEC_TPC_SHIFT) |
+			R592_TPC_EXEC_BIG_FIFO;
+
+	r592_write_reg(dev, R592_TPC_EXEC, reg);
+
+	/* Wait for TPC completion */
+	status = R592_STATUS_RDY;
+	if (dev->req->need_card_int)
+		status |= R592_STATUS_CED;
+
+	error = r592_wait_status(dev, status, status);
+	if (error) {
+		message("card didn't respond");
+		goto out;
+	}
+
+	/* Test IO errors */
+	error = r592_test_io_error(dev);
+	if (error)
+		goto out;
+
+	/* Read data from FIFO */
+	if (!is_write) {
+		error = r592_transfer_fifo_dma(dev);
+		if (error == -EINVAL)
+			error = r592_transfer_fifo_pio(dev);
+	}
+
+	/* read INT reg. This can be shortened with shifts, but that way
+		its more readable */
+	if (dev->parallel_mode && dev->req->need_card_int) {
+
+		dev->req->int_reg = 0;
+		status = r592_read_reg(dev, R592_STATUS);
+
+		if (status & R592_STATUS_P_CMDNACK)
+			dev->req->int_reg |= MEMSTICK_INT_CMDNAK;
+		if (status & R592_STATUS_P_BREQ)
+			dev->req->int_reg |= MEMSTICK_INT_BREQ;
+		if (status & R592_STATUS_P_INTERR)
+			dev->req->int_reg |= MEMSTICK_INT_ERR;
+		if (status & R592_STATUS_P_CED)
+			dev->req->int_reg |= MEMSTICK_INT_CED;
+	}
+out:
+	dev->req->error = error;
+	r592_clear_reg_mask(dev, R592_REG_MSC, R592_REG_MSC_LED);
+	return;
+}
+
+/* Main request processing thread */
+static int r592_process_thread(void *data)
+{
+	int error;
+	struct r592_device *dev = (struct r592_device *)data;
+
+	while (!kthread_should_stop()) {
+
+		try_to_freeze();
+		set_current_state(TASK_INTERRUPTIBLE);
+		error = memstick_next_req(dev->host, &dev->req);
+
+		if (error) {
+			if (error == -EAGAIN) {
+				dbg_verbose("IO: done IO, sleeping");
+			} else {
+				message("IO: unknown error from "
+					"memstick_next_req %d", error);
+			}
+
+			schedule();
+		} else {
+			set_current_state(TASK_RUNNING);
+			r592_process_request(dev);
+		}
+	}
+	return 0;
+}
+
+/* Reprogram chip to detect change in card state */
+/* eg, if card is detected, arm it to detect removal, and vice versa */
+static void r592_update_card_detect(struct r592_device *dev)
+{
+	u32 reg = r592_read_reg(dev, R592_REG_MSC);
+	bool card_detected = reg & R592_REG_MSC_PRSNT;
+
+	dbg("update card detect. card state: %s", card_detected ?
+		"present" : "absent");
+
+	reg &= ~((R592_REG_MSC_IRQ_REMOVE | R592_REG_MSC_IRQ_INSERT) << 16);
+
+	if (card_detected)
+		reg |= (R592_REG_MSC_IRQ_REMOVE << 16);
+	else
+		reg |= (R592_REG_MSC_IRQ_INSERT << 16);
+
+	r592_write_reg(dev, R592_REG_MSC, reg);
+}
+
+/* Timer routine that fires 1 second after last card detection event, */
+static void r592_detect_timer(long unsigned int data)
+{
+	struct r592_device *dev = (struct r592_device *)data;
+	r592_update_card_detect(dev);
+	memstick_detect_change(dev->host);
+}
+
+/* Interrupt handler */
+static irqreturn_t r592_irq(int irq, void *data)
+{
+	struct r592_device *dev = (struct r592_device *)data;
+	irqreturn_t ret = IRQ_NONE;
+	u32 reg;
+	u16 irq_enable, irq_status;
+	unsigned long flags;
+	int error;
+
+	spin_lock_irqsave(&dev->irq_lock, flags);
+
+	reg = r592_read_reg(dev, R592_REG_MSC);
+	irq_enable = reg >> 16;
+	irq_status = reg & 0xFFFF;
+
+	/* Ack the interrupts */
+	reg &= ~irq_status;
+	r592_write_reg(dev, R592_REG_MSC, reg);
+
+	/* Get the IRQ status minus bits that aren't enabled */
+	irq_status &= (irq_enable);
+
+	/* Due to limitation of memstick core, we don't look at bits that
+		indicate that card was removed/inserted and/or present */
+	if (irq_status & (R592_REG_MSC_IRQ_INSERT | R592_REG_MSC_IRQ_REMOVE)) {
+
+		bool card_was_added = irq_status & R592_REG_MSC_IRQ_INSERT;
+		ret = IRQ_HANDLED;
+
+		message("IRQ: card %s", card_was_added ? "added" : "removed");
+
+		mod_timer(&dev->detect_timer,
+			jiffies + msecs_to_jiffies(card_was_added ? 500 : 50));
+	}
+
+	if (irq_status &
+		(R592_REG_MSC_FIFO_DMA_DONE | R592_REG_MSC_FIFO_DMA_ERR)) {
+		ret = IRQ_HANDLED;
+
+		if (irq_status & R592_REG_MSC_FIFO_DMA_ERR) {
+			message("IRQ: DMA error");
+			error = -EIO;
+		} else {
+			dbg_verbose("IRQ: dma done");
+			error = 0;
+		}
+
+		r592_stop_dma(dev, error);
+		complete(&dev->dma_done);
+	}
+
+	spin_unlock_irqrestore(&dev->irq_lock, flags);
+	return ret;
+}
+
+/* External inteface: set settings */
+static int r592_set_param(struct memstick_host *host,
+			enum memstick_param param, int value)
+{
+	struct r592_device *dev = memstick_priv(host);
+
+	switch (param) {
+	case MEMSTICK_POWER:
+		switch (value) {
+		case MEMSTICK_POWER_ON:
+			return r592_enable_device(dev, true);
+		case MEMSTICK_POWER_OFF:
+			return r592_enable_device(dev, false);
+		default:
+			return -EINVAL;
+		}
+	case MEMSTICK_INTERFACE:
+		switch (value) {
+		case MEMSTICK_SERIAL:
+			return r592_set_mode(dev, 0);
+		case MEMSTICK_PAR4:
+			return r592_set_mode(dev, 1);
+		default:
+			return -EINVAL;
+		}
+	default:
+		return -EINVAL;
+	}
+}
+
+/* External interface: submit requests */
+static void r592_submit_req(struct memstick_host *host)
+{
+	struct r592_device *dev = memstick_priv(host);
+	if (wake_up_process(dev->io_thread))
+		dbg_verbose("IO thread woken to process requests");
+}
+
+static const struct pci_device_id r592_pci_id_tbl[] = {
+
+	{ PCI_VDEVICE(RICOH, 0x0592), },
+	{ },
+};
+
+/* Main entry */
+static int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	int error = -ENOMEM;
+	struct memstick_host *host;
+	struct r592_device *dev;
+
+	/* Allocate memory */
+	host = memstick_alloc_host(sizeof(struct r592_device), &pdev->dev);
+	if (!host)
+		goto error1;
+
+	dev = memstick_priv(host);
+	dev->host = host;
+	dev->pci_dev = pdev;
+	pci_set_drvdata(pdev, dev);
+
+	/* pci initialization */
+	error = pci_enable_device(pdev);
+	if (error)
+		goto error2;
+
+	pci_set_master(pdev);
+	error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (error)
+		goto error3;
+
+	error = pci_request_regions(pdev, DRV_NAME);
+	if (error)
+		goto error3;
+
+	dev->mmio = pci_ioremap_bar(pdev, 0);
+	if (!dev->mmio)
+		goto error4;
+
+	dev->irq = pdev->irq;
+	spin_lock_init(&dev->irq_lock);
+	spin_lock_init(&dev->atomic_lock);
+	init_completion(&dev->dma_done);
+	setup_timer(&dev->detect_timer,
+		r592_detect_timer, (long unsigned int)dev);
+
+	/* Host initialization */
+	host->caps = MEMSTICK_CAP_PAR4;
+	host->request = r592_submit_req;
+	host->set_param = r592_set_param;
+	r592_check_dma(dev);
+
+	dev->io_thread = kthread_run(r592_process_thread, dev, "r592_io");
+	if (IS_ERR(dev->io_thread)) {
+		error = PTR_ERR(dev->io_thread);
+		goto error5;
+	}
+
+	/* This is just a precation, so don't fail */
+	dev->dummy_dma_page = pci_alloc_consistent(pdev, PAGE_SIZE,
+		&dev->dummy_dma_page_physical_address);
+	r592_stop_dma(dev , 0);
+
+	if (request_irq(dev->irq, &r592_irq, IRQF_SHARED,
+			  DRV_NAME, dev))
+		goto error6;
+
+	r592_update_card_detect(dev);
+	if (memstick_add_host(host))
+		goto error7;
+
+	message("driver succesfully loaded");
+	return 0;
+error7:
+	free_irq(dev->irq, dev);
+error6:
+	if (dev->dummy_dma_page)
+		pci_free_consistent(pdev, PAGE_SIZE, dev->dummy_dma_page,
+			dev->dummy_dma_page_physical_address);
+
+	kthread_stop(dev->io_thread);
+error5:
+	iounmap(dev->mmio);
+error4:
+	pci_release_regions(pdev);
+error3:
+	pci_disable_device(pdev);
+error2:
+	memstick_free_host(host);
+error1:
+	return error;
+}
+
+static void r592_remove(struct pci_dev *pdev)
+{
+	int error = 0;
+	struct r592_device *dev = pci_get_drvdata(pdev);
+
+	/* Stop the processing thread.
+	That ensures that we won't take any more requests */
+	kthread_stop(dev->io_thread);
+
+	while (!error && dev->req) {
+		dev->req->error = -ETIME;
+		error = memstick_next_req(dev->host, &dev->req);
+	}
+	memstick_remove_host(dev->host);
+
+	free_irq(dev->irq, dev);
+	iounmap(dev->mmio);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	memstick_free_host(dev->host);
+
+	if (dev->dummy_dma_page)
+		pci_free_consistent(pdev, PAGE_SIZE, dev->dummy_dma_page,
+			dev->dummy_dma_page_physical_address);
+}
+
+#ifdef CONFIG_PM
+static int r592_suspend(struct device *core_dev)
+{
+	struct pci_dev *pdev = to_pci_dev(core_dev);
+	struct r592_device *dev = pci_get_drvdata(pdev);
+
+	r592_clear_interrupts(dev);
+	memstick_suspend_host(dev->host);
+	del_timer_sync(&dev->detect_timer);
+	return 0;
+}
+
+static int r592_resume(struct device *core_dev)
+{
+	struct pci_dev *pdev = to_pci_dev(core_dev);
+	struct r592_device *dev = pci_get_drvdata(pdev);
+
+	r592_clear_interrupts(dev);
+	r592_enable_device(dev, false);
+	memstick_resume_host(dev->host);
+	r592_update_card_detect(dev);
+	return 0;
+}
+
+SIMPLE_DEV_PM_OPS(r592_pm_ops, r592_suspend, r592_resume);
+#endif
+
+MODULE_DEVICE_TABLE(pci, r592_pci_id_tbl);
+
+static struct pci_driver r852_pci_driver = {
+	.name		= DRV_NAME,
+	.id_table	= r592_pci_id_tbl,
+	.probe		= r592_probe,
+	.remove		= r592_remove,
+#ifdef CONFIG_PM
+	.driver.pm	= &r592_pm_ops,
+#endif
+};
+
+static __init int r592_module_init(void)
+{
+	return pci_register_driver(&r852_pci_driver);
+}
+
+static void __exit r592_module_exit(void)
+{
+	pci_unregister_driver(&r852_pci_driver);
+}
+
+module_init(r592_module_init);
+module_exit(r592_module_exit);
+
+module_param(enable_dma, bool, S_IRUGO);
+MODULE_PARM_DESC(enable_dma, "Enable usage of the DMA (default)");
+module_param(debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Debug level (0-3)");
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Maxim Levitsky <maximlevitsky@gmail.com>");
+MODULE_DESCRIPTION("Ricoh R5C592 Memstick/Memstick PRO card reader driver");
diff -puN /dev/null drivers/memstick/host/r592.h
--- /dev/null
+++ a/drivers/memstick/host/r592.h
@@ -0,0 +1,177 @@
+/*
+ * Copyright (C) 2010 - Maxim Levitsky
+ * driver for Ricoh memstick readers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef R592_H
+
+#include <linux/memstick.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/ctype.h>
+
+/* write to this reg (number,len) triggers TPC execution */
+#define R592_TPC_EXEC			0x00
+#define R592_TPC_EXEC_LEN_SHIFT		16		/* Bits 16..25 are TPC len */
+#define R592_TPC_EXEC_BIG_FIFO		(1 << 26)	/* If bit 26 is set, large fifo is used (reg 48) */
+#define R592_TPC_EXEC_TPC_SHIFT		28		/* Bits 28..31 are the TPC number */
+
+
+/* Window for small TPC fifo (big endian)*/
+/* reads and writes always are done in  8 byte chunks */
+/* Not used in driver, because large fifo does better job */
+#define R592_SFIFO			0x08
+
+
+/* Status register (ms int, small fifo, IO)*/
+#define R592_STATUS			0x10
+							/* Parallel INT bits */
+#define R592_STATUS_P_CMDNACK		(1 << 16)	/* INT reg: NACK (parallel mode) */
+#define R592_STATUS_P_BREQ		(1 << 17)	/* INT reg: card ready (parallel mode)*/
+#define R592_STATUS_P_INTERR		(1 << 18)	/* INT reg: int error (parallel mode)*/
+#define R592_STATUS_P_CED		(1 << 19)	/* INT reg: command done (parallel mode) */
+
+							/* Fifo status */
+#define R592_STATUS_SFIFO_FULL		(1 << 20)	/* Small Fifo almost full (last chunk is written) */
+#define R592_STATUS_SFIFO_EMPTY		(1 << 21)	/* Small Fifo empty */
+
+							/* Error detection via CRC */
+#define R592_STATUS_SEND_ERR		(1 << 24)	/* Send failed */
+#define R592_STATUS_RECV_ERR		(1 << 25)	/* Recieve failed */
+
+							/* Card state */
+#define R592_STATUS_RDY			(1 << 28)	/* RDY signal recieved */
+#define R592_STATUS_CED			(1 << 29)	/* INT: Command done (serial mode)*/
+#define R592_STATUS_SFIFO_INPUT		(1 << 30)	/* Small fifo recieved data*/
+
+#define R592_SFIFO_SIZE			32		/* total size of small fifo is 32 bytes */
+#define R592_SFIFO_PACKET		8		/* packet size of small fifo */
+
+/* IO control */
+#define R592_IO				0x18
+#define	R592_IO_16			(1 << 16)	/* Set by default, can be cleared */
+#define	R592_IO_18			(1 << 18)	/* Set by default, can be cleared */
+#define	R592_IO_SERIAL1			(1 << 20)	/* Set by default, can be cleared, (cleared on parallel) */
+#define	R592_IO_22			(1 << 22)	/* Set by default, can be cleared */
+#define R592_IO_DIRECTION		(1 << 24)	/* TPC direction (1 write 0 read) */
+#define	R592_IO_26			(1 << 26)	/* Set by default, can be cleared */
+#define	R592_IO_SERIAL2			(1 << 30)	/* Set by default, can be cleared (cleared on parallel), serial doesn't work if unset */
+#define R592_IO_RESET			(1 << 31)	/* Reset, sets defaults*/
+
+
+/* Unknown register 1 (enables internal blocks ???)*/
+#define R592_REG32			0x20		/* bits 0-7 writeable */
+#define R592_REG32_0			(1 << 0)	/* set on start, cleared on stop - must be set*/
+#define R592_REG32_1			(1 << 1)	/* set on start, cleared on stop - must be set*/
+#define R592_REG32_3			(1 << 3)	/* must be clear */
+#define R592_REG32_20			(1 << 5)	/* set before switch to parallel */
+
+/* Unknown register (clock control???)*/
+#define R592_REG36			0x24
+#define R592_REG36_0			(1 << 0)	/* set on init, never reset (enable clock engine???)*/
+#define R592_REG36_1			(1 << 1)	/* set after switch to parallel (fast clock??)*/
+
+
+/* IRQ,card detection,large fifo (first word irq status, second enable) */
+/* IRQs are ACKed by clearing the bits */
+#define R592_REG_MSC			0x28
+#define R592_REG_MSC_PRSNT		(1 << 1)	/* card present (only status)*/
+#define R592_REG_MSC_IRQ_INSERT		(1 << 8)	/* detect insert / card insered */
+#define R592_REG_MSC_IRQ_REMOVE		(1 << 9)	/* detect removal / card removed */
+#define R592_REG_MSC_FIFO_EMPTY		(1 << 10)	/* fifo is empty */
+#define R592_REG_MSC_FIFO_DMA_DONE	(1 << 11)	/* dma enable / dma done */
+
+#define R592_REG_MSC_FIFO_USER_ORN	(1 << 12)	/* set if software reads empty fifo (if R592_REG_MSC_FIFO_EMPTY is set) */
+#define R592_REG_MSC_FIFO_MISMATH	(1 << 13)	/* set if amount of data in fifo doesn't match amount in TPC */
+#define R592_REG_MSC_FIFO_DMA_ERR	(1 << 14)	/* IO failure */
+#define R592_REG_MSC_LED		(1 << 15)	/* clear to turn led off (only status)*/
+
+#define DMA_IRQ_ACK_MASK \
+	(R592_REG_MSC_FIFO_DMA_DONE | R592_REG_MSC_FIFO_DMA_ERR)
+
+#define DMA_IRQ_EN_MASK (DMA_IRQ_ACK_MASK << 16)
+
+/* DMA address for large FIFO read/writes*/
+#define R592_FIFO_DMA			0x2C
+
+/* PIO access to large FIFO (512 bytes) (big endian)*/
+#define R592_FIFO_PIO			0x30
+#define R592_LFIFO_SIZE			512		/* large fifo size */
+
+
+/* large FIFO DMA settings */
+#define R592_FIFO_DMA_SETTINGS		0x34
+#define R592_FIFO_DMA_SETTINGS_EN	(1 << 0)	/* DMA enabled */
+#define R592_FIFO_DMA_SETTINGS_DIR	(1 << 1)	/* Dma direction (1 read, 0 write) */
+#define R592_FIFO_DMA_SETTINGS_CAP	(1 << 24)	/* Dma is aviable */
+
+
+/* Maybe just an delay */
+/* Bits 17..19 are just number */
+/* bit 16 is set, then bit 20 is waited */
+/* time to wait is about 50 spins * 2 ^ (bits 17..19) */
+/* seems to be possible just to ignore */
+/* Probably debug register */
+#define R592_REG38			0x38
+#define R592_REG38_START		(1 << 16)	/* Start bit */
+#define R592_REG38_WAIT			(1 << 20)	/* HW set this after the delay */
+
+/* Debug register, written (0xABCDEF00) when error happens - not used*/
+#define R592_REG_3C			0x3C
+
+struct r592_device {
+	struct pci_dev *pci_dev;
+	struct memstick_host	*host;		/* host backpointer */
+	struct memstick_request *req;		/* current request */
+
+	/* Registers, IRQ */
+	void __iomem *mmio;
+	int irq;
+	spinlock_t irq_lock;
+	struct timer_list detect_timer;
+
+
+	struct task_struct *io_thread;
+	bool parallel_mode;
+
+
+	/* DMA area */
+	int dma_capable;
+	int dma_error;
+	struct completion dma_done;
+	void *dummy_dma_page;
+	dma_addr_t dummy_dma_page_physical_address;
+	spinlock_t atomic_lock;	/* used to enter atomic mode only in PIO */
+};
+
+
+struct dword_buffer {
+	unsigned char dword[4];
+	unsigned char len;
+};
+
+
+#define DRV_NAME "r592"
+
+
+#define message(format, ...) \
+	printk(KERN_INFO DRV_NAME ": " format "\n", ## __VA_ARGS__)
+
+#define __dbg(level, format, ...) \
+	do { \
+		if (debug >= level) \
+			printk(KERN_DEBUG DRV_NAME \
+				": " format "\n", ## __VA_ARGS__); \
+	} while (0)
+
+
+#define dbg(format, ...)		__dbg(1, format, ## __VA_ARGS__)
+#define dbg_verbose(format, ...)	__dbg(2, format, ## __VA_ARGS__)
+#define dbg_reg(format, ...)		__dbg(3, format, ## __VA_ARGS__)
+
+#endif
\ No newline at end of file
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
drivers-media-ir-ene_irc-fix-null-dereference.patch
memstick-a-few-changes-to-core.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch

