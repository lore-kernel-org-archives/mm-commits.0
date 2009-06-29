From: akpm@linux-foundation.org
Subject: + framebuffer-support-for-htc-dream.patch added to -mm tree
Date: Mon, 29 Jun 2009 12:41:36 -0700
Message-ID: <200906291941.n5TJfaLr019756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755162AbZF2Tl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 15:41:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, krzysztof.h1@poczta.fm, swetland@google.com


The patch titled
     fbdev: framebuffer support for HTC Dream
has been added to the -mm tree.  Its filename is
     framebuffer-support-for-htc-dream.patch

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
Subject: fbdev: framebuffer support for HTC Dream
From: Pavel Machek <pavel@ucw.cz>

This adds support for framebuffer on HTC Dream smartphone (aka T-Mobile
G1, aka ADP1).

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig                   |    8 
 drivers/video/Makefile                  |    1 
 drivers/video/msm/Makefile              |   19 
 drivers/video/msm/mddi.c                |  828 ++++++++++++++++++++++
 drivers/video/msm/mddi_client_dummy.c   |   97 ++
 drivers/video/msm/mddi_client_nt35399.c |  255 ++++++
 drivers/video/msm/mddi_client_toshiba.c |  283 +++++++
 drivers/video/msm/mddi_hw.h             |  303 ++++++++
 drivers/video/msm/mdp.c                 |  538 ++++++++++++++
 drivers/video/msm/mdp_csc_table.h       |  582 +++++++++++++++
 drivers/video/msm/mdp_hw.h              |  621 ++++++++++++++++
 drivers/video/msm/mdp_ppp.c             |  750 +++++++++++++++++++
 drivers/video/msm/mdp_scale_tables.c    |  766 ++++++++++++++++++++
 drivers/video/msm/mdp_scale_tables.h    |   38 +
 drivers/video/msm/msm_fb.c              |  636 ++++++++++++++++
 15 files changed, 5725 insertions(+)

diff -puN drivers/video/Kconfig~framebuffer-support-for-htc-dream drivers/video/Kconfig
--- a/drivers/video/Kconfig~framebuffer-support-for-htc-dream
+++ a/drivers/video/Kconfig
@@ -2119,6 +2119,14 @@ config FB_PRE_INIT_FB
 	  Select this option if display contents should be inherited as set by
 	  the bootloader.
 
+config FB_MSM
+	tristate
+	depends on FB && ARCH_MSM
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	default y
+
 config FB_MX3
 	tristate "MX3 Framebuffer support"
 	depends on FB && MX3_IPU
diff -puN drivers/video/Makefile~framebuffer-support-for-htc-dream drivers/video/Makefile
--- a/drivers/video/Makefile~framebuffer-support-for-htc-dream
+++ a/drivers/video/Makefile
@@ -126,6 +126,7 @@ obj-$(CONFIG_FB_OMAP)             += oma
 obj-$(CONFIG_XEN_FBDEV_FRONTEND)  += xen-fbfront.o
 obj-$(CONFIG_FB_CARMINE)          += carminefb.o
 obj-$(CONFIG_FB_MB862XX)	  += mb862xx/
+obj-$(CONFIG_FB_MSM)              += msm/
 
 # Platform or fallback drivers go here
 obj-$(CONFIG_FB_UVESA)            += uvesafb.o
diff -puN /dev/null drivers/video/msm/Makefile
--- /dev/null
+++ a/drivers/video/msm/Makefile
@@ -0,0 +1,19 @@
+
+# core framebuffer
+#
+obj-y := msm_fb.o
+
+# MDP DMA/PPP engine
+#
+obj-y += mdp.o mdp_scale_tables.o mdp_ppp.o
+
+# MDDI interface
+#
+obj-y += mddi.o
+
+# MDDI client/panel drivers
+#
+obj-y += mddi_client_dummy.o
+obj-y += mddi_client_toshiba.o
+obj-y += mddi_client_nt35399.o
+
diff -puN /dev/null drivers/video/msm/mddi.c
--- /dev/null
+++ a/drivers/video/msm/mddi.c
@@ -0,0 +1,828 @@
+/*
+ * MSM MDDI Transport
+ *
+ * Copyright (C) 2007 Google Incorporated
+ * Copyright (C) 2007 QUALCOMM Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <mach/msm_iomap.h>
+#include <mach/irqs.h>
+#include <mach/board.h>
+#include <linux/delay.h>
+
+#include <mach/msm_fb.h>
+#include "mddi_hw.h"
+
+#define FLAG_DISABLE_HIBERNATION 0x0001
+#define FLAG_HAVE_CAPS		 0x0002
+#define FLAG_HAS_VSYNC_IRQ	 0x0004
+#define FLAG_HAVE_STATUS	 0x0008
+
+#define CMD_GET_CLIENT_CAP     0x0601
+#define CMD_GET_CLIENT_STATUS  0x0602
+
+union mddi_rev {
+	unsigned char raw[MDDI_REV_BUFFER_SIZE];
+	struct mddi_rev_packet hdr;
+	struct mddi_client_status status;
+	struct mddi_client_caps caps;
+	struct mddi_register_access reg;
+};
+
+struct reg_read_info {
+	struct completion done;
+	uint32_t reg;
+	uint32_t status;
+	uint32_t result;
+};
+
+struct mddi_info {
+	uint16_t flags;
+	uint16_t version;
+	char __iomem *base;
+	int irq;
+	struct clk *clk;
+	struct msm_mddi_client_data client_data;
+
+	/* buffer for rev encap packets */
+	void *rev_data;
+	dma_addr_t rev_addr;
+	struct mddi_llentry *reg_write_data;
+	dma_addr_t reg_write_addr;
+	struct mddi_llentry *reg_read_data;
+	dma_addr_t reg_read_addr;
+	size_t rev_data_curr;
+
+	spinlock_t int_lock;
+	uint32_t int_enable;
+	uint32_t got_int;
+	wait_queue_head_t int_wait;
+
+	struct mutex reg_write_lock;
+	struct mutex reg_read_lock;
+	struct reg_read_info *reg_read;
+
+	struct mddi_client_caps caps;
+	struct mddi_client_status status;
+
+	void (*power_client)(struct msm_mddi_client_data *, int);
+
+	/* client device published to bind us to the
+	 * appropriate mddi_client driver
+	 */
+	char client_name[20];
+
+	struct platform_device client_pdev;
+};
+
+static void mddi_init_rev_encap(struct mddi_info *mddi);
+
+#define mddi_readl(r) readl(mddi->base + (MDDI_##r))
+#define mddi_writel(v, r) writel((v), mddi->base + (MDDI_##r))
+
+void mddi_activate_link(struct msm_mddi_client_data *cdata)
+{
+	struct mddi_info *mddi = container_of(cdata, struct mddi_info,
+					      client_data);
+
+	mddi_writel(MDDI_CMD_LINK_ACTIVE, CMD);
+}
+
+static void mddi_handle_link_list_done(struct mddi_info *mddi)
+{
+}
+
+static void mddi_reset_rev_encap_ptr(struct mddi_info *mddi)
+{
+	printk(KERN_INFO "mddi: resetting rev ptr\n");
+	mddi->rev_data_curr = 0;
+	mddi_writel(mddi->rev_addr, REV_PTR);
+	mddi_writel(mddi->rev_addr, REV_PTR);
+	mddi_writel(MDDI_CMD_FORCE_NEW_REV_PTR, CMD);
+}
+
+static void mddi_handle_rev_data(struct mddi_info *mddi, union mddi_rev *rev)
+{
+	int i;
+	struct reg_read_info *ri;
+
+	if ((rev->hdr.length <= MDDI_REV_BUFFER_SIZE - 2) &&
+	   (rev->hdr.length >= sizeof(struct mddi_rev_packet) - 2)) {
+
+		switch (rev->hdr.type) {
+		case TYPE_CLIENT_CAPS:
+			memcpy(&mddi->caps, &rev->caps,
+			       sizeof(struct mddi_client_caps));
+			mddi->flags |= FLAG_HAVE_CAPS;
+			wake_up(&mddi->int_wait);
+			break;
+		case TYPE_CLIENT_STATUS:
+			memcpy(&mddi->status, &rev->status,
+			       sizeof(struct mddi_client_status));
+			mddi->flags |= FLAG_HAVE_STATUS;
+			wake_up(&mddi->int_wait);
+			break;
+		case TYPE_REGISTER_ACCESS:
+			ri = mddi->reg_read;
+			if (ri == 0) {
+				printk(KERN_INFO "rev: got reg %x = %x without "
+						 " pending read\n",
+				       rev->reg.register_address,
+				       rev->reg.register_data_list);
+				break;
+			}
+			if (ri->reg != rev->reg.register_address) {
+				printk(KERN_INFO "rev: got reg %x = %x for "
+						 "wrong register, expected "
+						 "%x\n",
+				       rev->reg.register_address,
+				       rev->reg.register_data_list, ri->reg);
+				break;
+			}
+			mddi->reg_read = NULL;
+			ri->status = 0;
+			ri->result = rev->reg.register_data_list;
+			complete(&ri->done);
+			break;
+		default:
+			printk(KERN_INFO "rev: unknown reverse packet: "
+					 "len=%04x type=%04x CURR_REV_PTR=%x\n",
+			       rev->hdr.length, rev->hdr.type,
+			       mddi_readl(CURR_REV_PTR));
+			for (i = 0; i < rev->hdr.length + 2; i++) {
+				if ((i % 16) == 0)
+					printk(KERN_INFO "\n");
+				printk(KERN_INFO " %02x", rev->raw[i]);
+			}
+			printk(KERN_INFO "\n");
+			mddi_reset_rev_encap_ptr(mddi);
+		}
+	} else {
+		printk(KERN_INFO "bad rev length, %d, CURR_REV_PTR %x\n",
+		       rev->hdr.length, mddi_readl(CURR_REV_PTR));
+		mddi_reset_rev_encap_ptr(mddi);
+	}
+}
+
+static void mddi_wait_interrupt(struct mddi_info *mddi, uint32_t intmask);
+
+static void mddi_handle_rev_data_avail(struct mddi_info *mddi)
+{
+	union mddi_rev *rev = mddi->rev_data;
+	uint32_t rev_data_count;
+	uint32_t rev_crc_err_count;
+	int i;
+	struct reg_read_info *ri;
+	size_t prev_offset;
+	uint16_t length;
+
+	union mddi_rev *crev = mddi->rev_data + mddi->rev_data_curr;
+
+	/* clear the interrupt */
+	mddi_writel(MDDI_INT_REV_DATA_AVAIL, INT);
+	rev_data_count = mddi_readl(REV_PKT_CNT);
+	rev_crc_err_count = mddi_readl(REV_CRC_ERR);
+	if (rev_data_count > 1)
+		printk(KERN_INFO "rev_data_count %d\n", rev_data_count);
+
+	if (rev_crc_err_count) {
+		printk(KERN_INFO "rev_crc_err_count %d, INT %x\n",
+		       rev_crc_err_count,  mddi_readl(INT));
+		ri = mddi->reg_read;
+		if (ri == 0) {
+			printk(KERN_INFO "rev: got crc error without pending "
+			       "read\n");
+		} else {
+			mddi->reg_read = NULL;
+			ri->status = -EIO;
+			ri->result = -1;
+			complete(&ri->done);
+		}
+	}
+
+	if (rev_data_count == 0)
+		return;
+
+	prev_offset = mddi->rev_data_curr;
+
+	length = *((uint8_t *)mddi->rev_data + mddi->rev_data_curr);
+	mddi->rev_data_curr++;
+	if (mddi->rev_data_curr == MDDI_REV_BUFFER_SIZE)
+		mddi->rev_data_curr = 0;
+	length += *((uint8_t *)mddi->rev_data + mddi->rev_data_curr) << 8;
+	mddi->rev_data_curr += 1 + length;
+	if (mddi->rev_data_curr >= MDDI_REV_BUFFER_SIZE)
+		mddi->rev_data_curr =
+			mddi->rev_data_curr % MDDI_REV_BUFFER_SIZE;
+
+	if (length > MDDI_REV_BUFFER_SIZE - 2) {
+		printk(KERN_INFO "mddi: rev data length greater than buffer"
+			"size\n");
+		mddi_reset_rev_encap_ptr(mddi);
+		return;
+	}
+
+	if (prev_offset + 2 + length >= MDDI_REV_BUFFER_SIZE) {
+		union mddi_rev tmprev;
+		size_t rem = MDDI_REV_BUFFER_SIZE - prev_offset;
+		memcpy(&tmprev.raw[0], mddi->rev_data + prev_offset, rem);
+		memcpy(&tmprev.raw[rem], mddi->rev_data, 2 + length - rem);
+		mddi_handle_rev_data(mddi, &tmprev);
+	} else {
+		mddi_handle_rev_data(mddi, crev);
+	}
+
+	if (prev_offset < MDDI_REV_BUFFER_SIZE / 2 &&
+	    mddi->rev_data_curr >= MDDI_REV_BUFFER_SIZE / 2) {
+		mddi_writel(mddi->rev_addr, REV_PTR);
+	}
+}
+
+static irqreturn_t mddi_isr(int irq, void *data)
+{
+	struct msm_mddi_client_data *cdata = data;
+	struct mddi_info *mddi = container_of(cdata, struct mddi_info,
+					      client_data);
+	uint32_t active, status;
+
+	spin_lock(&mddi->int_lock);
+
+	active = mddi_readl(INT);
+	status = mddi_readl(STAT);
+
+	mddi_writel(active, INT);
+
+	/* ignore any interrupts we have disabled */
+	active &= mddi->int_enable;
+
+	mddi->got_int |= active;
+	wake_up(&mddi->int_wait);
+
+	if (active & MDDI_INT_PRI_LINK_LIST_DONE) {
+		mddi->int_enable &= (~MDDI_INT_PRI_LINK_LIST_DONE);
+		mddi_handle_link_list_done(mddi);
+	}
+	if (active & MDDI_INT_REV_DATA_AVAIL)
+		mddi_handle_rev_data_avail(mddi);
+
+	if (active & ~MDDI_INT_NEED_CLEAR)
+		mddi->int_enable &= ~(active & ~MDDI_INT_NEED_CLEAR);
+
+	if (active & MDDI_INT_LINK_ACTIVE) {
+		mddi->int_enable &= (~MDDI_INT_LINK_ACTIVE);
+		mddi->int_enable |= MDDI_INT_IN_HIBERNATION;
+	}
+
+	if (active & MDDI_INT_IN_HIBERNATION) {
+		mddi->int_enable &= (~MDDI_INT_IN_HIBERNATION);
+		mddi->int_enable |= MDDI_INT_LINK_ACTIVE;
+	}
+
+	mddi_writel(mddi->int_enable, INTEN);
+	spin_unlock(&mddi->int_lock);
+
+	return IRQ_HANDLED;
+}
+
+static long mddi_wait_interrupt_timeout(struct mddi_info *mddi,
+					uint32_t intmask, int timeout)
+{
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&mddi->int_lock, irq_flags);
+	mddi->got_int &= ~intmask;
+	mddi->int_enable |= intmask;
+	mddi_writel(mddi->int_enable, INTEN);
+	spin_unlock_irqrestore(&mddi->int_lock, irq_flags);
+	return wait_event_timeout(mddi->int_wait, mddi->got_int & intmask,
+				  timeout);
+}
+
+static void mddi_wait_interrupt(struct mddi_info *mddi, uint32_t intmask)
+{
+	if (mddi_wait_interrupt_timeout(mddi, intmask, HZ/10) == 0)
+		printk(KERN_INFO KERN_ERR "mddi_wait_interrupt %d, timeout "
+		       "waiting for %x, INT = %x, STAT = %x gotint = %x\n",
+		       current->pid, intmask, mddi_readl(INT), mddi_readl(STAT),
+		       mddi->got_int);
+}
+
+static void mddi_init_rev_encap(struct mddi_info *mddi)
+{
+	memset(mddi->rev_data, 0xee, MDDI_REV_BUFFER_SIZE);
+	mddi_writel(mddi->rev_addr, REV_PTR);
+	mddi_writel(MDDI_CMD_FORCE_NEW_REV_PTR, CMD);
+	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+}
+
+void mddi_set_auto_hibernate(struct msm_mddi_client_data *cdata, int on)
+{
+	struct mddi_info *mddi = container_of(cdata, struct mddi_info,
+					      client_data);
+	mddi_writel(MDDI_CMD_POWERDOWN, CMD);
+	mddi_wait_interrupt(mddi, MDDI_INT_IN_HIBERNATION);
+	mddi_writel(MDDI_CMD_HIBERNATE | !!on, CMD);
+	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+}
+
+
+static uint16_t mddi_init_registers(struct mddi_info *mddi)
+{
+	mddi_writel(0x0001, VERSION);
+	mddi_writel(MDDI_HOST_BYTES_PER_SUBFRAME, BPS);
+	mddi_writel(0x0003, SPM); /* subframes per media */
+	mddi_writel(0x0005, TA1_LEN);
+	mddi_writel(MDDI_HOST_TA2_LEN, TA2_LEN);
+	mddi_writel(0x0096, DRIVE_HI);
+	/* 0x32 normal, 0x50 for Toshiba display */
+	mddi_writel(0x0050, DRIVE_LO);
+	mddi_writel(0x003C, DISP_WAKE); /* wakeup counter */
+	mddi_writel(MDDI_HOST_REV_RATE_DIV, REV_RATE_DIV);
+
+	mddi_writel(MDDI_REV_BUFFER_SIZE, REV_SIZE);
+	mddi_writel(MDDI_MAX_REV_PKT_SIZE, REV_ENCAP_SZ);
+
+	/* disable periodic rev encap */
+	mddi_writel(MDDI_CMD_PERIODIC_REV_ENCAP, CMD);
+	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+
+	if (mddi_readl(PAD_CTL) == 0) {
+		/* If we are turning on band gap, need to wait 5us before
+		 * turning on the rest of the PAD */
+		mddi_writel(0x08000, PAD_CTL);
+		udelay(5);
+	}
+
+	/* Recommendation from PAD hw team */
+	mddi_writel(0xa850f, PAD_CTL);
+
+
+	/* Need an even number for counts */
+	mddi_writel(0x60006, DRIVER_START_CNT);
+
+	mddi_set_auto_hibernate(&mddi->client_data, 0);
+
+	mddi_writel(MDDI_CMD_DISP_IGNORE, CMD);
+	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+
+	mddi_init_rev_encap(mddi);
+	return mddi_readl(CORE_VER) & 0xffff;
+}
+
+static void mddi_suspend(struct msm_mddi_client_data *cdata)
+{
+	struct mddi_info *mddi = container_of(cdata, struct mddi_info,
+					      client_data);
+	/* turn off the client */
+	if (mddi->power_client)
+		mddi->power_client(&mddi->client_data, 0);
+	/* turn off the link */
+	mddi_writel(MDDI_CMD_RESET, CMD);
+	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+	/* turn off the clock */
+	clk_disable(mddi->clk);
+}
+
+static void mddi_resume(struct msm_mddi_client_data *cdata)
+{
+	struct mddi_info *mddi = container_of(cdata, struct mddi_info,
+					      client_data);
+	mddi_set_auto_hibernate(&mddi->client_data, 0);
+	/* turn on the client */
+	if (mddi->power_client)
+		mddi->power_client(&mddi->client_data, 1);
+	/* turn on the clock */
+	clk_enable(mddi->clk);
+	/* set up the local registers */
+	mddi->rev_data_curr = 0;
+	mddi_init_registers(mddi);
+	mddi_writel(mddi->int_enable, INTEN);
+	mddi_writel(MDDI_CMD_LINK_ACTIVE, CMD);
+	mddi_writel(MDDI_CMD_SEND_RTD, CMD);
+	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+	mddi_set_auto_hibernate(&mddi->client_data, 1);
+}
+
+static int __init mddi_get_client_caps(struct mddi_info *mddi)
+{
+	int i, j;
+
+	/* clear any stale interrupts */
+	mddi_writel(0xffffffff, INT);
+
+	mddi->int_enable = MDDI_INT_LINK_ACTIVE |
+			   MDDI_INT_IN_HIBERNATION |
+			   MDDI_INT_PRI_LINK_LIST_DONE |
+			   MDDI_INT_REV_DATA_AVAIL |
+			   MDDI_INT_REV_OVERFLOW |
+			   MDDI_INT_REV_OVERWRITE |
+			   MDDI_INT_RTD_FAILURE;
+	mddi_writel(mddi->int_enable, INTEN);
+
+	mddi_writel(MDDI_CMD_LINK_ACTIVE, CMD);
+	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+
+	for (j = 0; j < 3; j++) {
+		/* the toshiba vga panel does not respond to get
+		 * caps unless you SEND_RTD, but the first SEND_RTD
+		 * will fail...
+		 */
+		for (i = 0; i < 4; i++) {
+			uint32_t stat;
+
+			mddi_writel(MDDI_CMD_SEND_RTD, CMD);
+			mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+			stat = mddi_readl(STAT);
+			printk(KERN_INFO "mddi cmd send rtd: int %x, stat %x, "
+					"rtd val %x\n", mddi_readl(INT), stat,
+					mddi_readl(RTD_VAL));
+			if ((stat & MDDI_STAT_RTD_MEAS_FAIL) == 0)
+				break;
+			msleep(1);
+		}
+
+		mddi_writel(CMD_GET_CLIENT_CAP, CMD);
+		mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+		wait_event_timeout(mddi->int_wait, mddi->flags & FLAG_HAVE_CAPS,
+				   HZ / 100);
+
+		if (mddi->flags & FLAG_HAVE_CAPS)
+			break;
+		printk(KERN_INFO KERN_ERR "mddi_init, timeout waiting for "
+				"caps\n");
+	}
+	return mddi->flags & FLAG_HAVE_CAPS;
+}
+
+/* link must be active when this is called */
+int mddi_check_status(struct mddi_info *mddi)
+{
+	int ret = -1, retry = 3;
+	mutex_lock(&mddi->reg_read_lock);
+	mddi_writel(MDDI_CMD_PERIODIC_REV_ENCAP | 1, CMD);
+	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+
+	do {
+		mddi->flags &= ~FLAG_HAVE_STATUS;
+		mddi_writel(CMD_GET_CLIENT_STATUS, CMD);
+		mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+		wait_event_timeout(mddi->int_wait,
+				   mddi->flags & FLAG_HAVE_STATUS,
+				   HZ / 100);
+
+		if (mddi->flags & FLAG_HAVE_STATUS) {
+			if (mddi->status.crc_error_count)
+				printk(KERN_INFO "mddi status: crc_error "
+					"count: %d\n",
+					mddi->status.crc_error_count);
+			else
+				ret = 0;
+			break;
+		} else
+			printk(KERN_INFO "mddi status: failed to get client "
+				"status\n");
+		mddi_writel(MDDI_CMD_SEND_RTD, CMD);
+		mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+	} while (--retry);
+
+	mddi_writel(MDDI_CMD_PERIODIC_REV_ENCAP | 0, CMD);
+	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+	mutex_unlock(&mddi->reg_read_lock);
+	return ret;
+}
+
+
+void mddi_remote_write(struct msm_mddi_client_data *cdata, uint32_t val,
+		       uint32_t reg)
+{
+	struct mddi_info *mddi = container_of(cdata, struct mddi_info,
+					      client_data);
+	struct mddi_llentry *ll;
+	struct mddi_register_access *ra;
+
+	mutex_lock(&mddi->reg_write_lock);
+
+	ll = mddi->reg_write_data;
+
+	ra = &(ll->u.r);
+	ra->length = 14 + 4;
+	ra->type = TYPE_REGISTER_ACCESS;
+	ra->client_id = 0;
+	ra->read_write_info = MDDI_WRITE | 1;
+	ra->crc16 = 0;
+
+	ra->register_address = reg;
+	ra->register_data_list = val;
+
+	ll->flags = 1;
+	ll->header_count = 14;
+	ll->data_count = 4;
+	ll->data = mddi->reg_write_addr + offsetof(struct mddi_llentry,
+						   u.r.register_data_list);
+	ll->next = 0;
+	ll->reserved = 0;
+
+	mddi_writel(mddi->reg_write_addr, PRI_PTR);
+
+	mddi_wait_interrupt(mddi, MDDI_INT_PRI_LINK_LIST_DONE);
+	mutex_unlock(&mddi->reg_write_lock);
+}
+
+uint32_t mddi_remote_read(struct msm_mddi_client_data *cdata, uint32_t reg)
+{
+	struct mddi_info *mddi = container_of(cdata, struct mddi_info,
+					      client_data);
+	struct mddi_llentry *ll;
+	struct mddi_register_access *ra;
+	struct reg_read_info ri;
+	unsigned s;
+	int retry_count = 2;
+	unsigned long irq_flags;
+
+	mutex_lock(&mddi->reg_read_lock);
+
+	ll = mddi->reg_read_data;
+
+	ra = &(ll->u.r);
+	ra->length = 14;
+	ra->type = TYPE_REGISTER_ACCESS;
+	ra->client_id = 0;
+	ra->read_write_info = MDDI_READ | 1;
+	ra->crc16 = 0;
+
+	ra->register_address = reg;
+
+	ll->flags = 0x11;
+	ll->header_count = 14;
+	ll->data_count = 0;
+	ll->data = 0;
+	ll->next = 0;
+	ll->reserved = 0;
+
+	s = mddi_readl(STAT);
+
+	ri.reg = reg;
+	ri.status = -1;
+
+	do {
+		init_completion(&ri.done);
+		mddi->reg_read = &ri;
+		mddi_writel(mddi->reg_read_addr, PRI_PTR);
+
+		mddi_wait_interrupt(mddi, MDDI_INT_PRI_LINK_LIST_DONE);
+
+		/* Enable Periodic Reverse Encapsulation. */
+		mddi_writel(MDDI_CMD_PERIODIC_REV_ENCAP | 1, CMD);
+		mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+		if (wait_for_completion_timeout(&ri.done, HZ/10) == 0 &&
+		    !ri.done.done) {
+			printk(KERN_INFO "mddi_remote_read(%x) timeout "
+					 "(%d %d %d)\n",
+			       reg, ri.status, ri.result, ri.done.done);
+			spin_lock_irqsave(&mddi->int_lock, irq_flags);
+			mddi->reg_read = NULL;
+			spin_unlock_irqrestore(&mddi->int_lock, irq_flags);
+			ri.status = -1;
+			ri.result = -1;
+		}
+		if (ri.status == 0)
+			break;
+
+		mddi_writel(MDDI_CMD_SEND_RTD, CMD);
+		mddi_writel(MDDI_CMD_LINK_ACTIVE, CMD);
+		mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+		printk(KERN_INFO "mddi_remote_read: failed, sent "
+		       "MDDI_CMD_SEND_RTD: int %x, stat %x, rtd val %x "
+		       "curr_rev_ptr %x\n", mddi_readl(INT), mddi_readl(STAT),
+		       mddi_readl(RTD_VAL), mddi_readl(CURR_REV_PTR));
+	} while (retry_count-- > 0);
+	/* Disable Periodic Reverse Encapsulation. */
+	mddi_writel(MDDI_CMD_PERIODIC_REV_ENCAP | 0, CMD);
+	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+	mddi->reg_read = NULL;
+	mutex_unlock(&mddi->reg_read_lock);
+	return ri.result;
+}
+
+static struct mddi_info mddi_info[2];
+
+static int __init mddi_clk_setup(struct platform_device *pdev,
+				 struct mddi_info *mddi,
+				 unsigned long clk_rate)
+{
+	int ret;
+
+	/* set up the clocks */
+	mddi->clk = clk_get(&pdev->dev, "mddi_clk");
+	if (IS_ERR(mddi->clk)) {
+		printk(KERN_INFO "mddi: failed to get clock\n");
+		return PTR_ERR(mddi->clk);
+	}
+	ret =  clk_enable(mddi->clk);
+	if (ret)
+		goto fail;
+	ret = clk_set_rate(mddi->clk, clk_rate);
+	if (ret)
+		goto fail;
+	return 0;
+
+fail:
+	clk_put(mddi->clk);
+	return ret;
+}
+
+static int __init mddi_rev_data_setup(struct mddi_info *mddi)
+{
+	void *dma;
+	dma_addr_t dma_addr;
+
+	/* set up dma buffer */
+	dma = dma_alloc_coherent(NULL, 0x1000, &dma_addr, GFP_KERNEL);
+	if (dma == 0)
+		return -ENOMEM;
+	mddi->rev_data = dma;
+	mddi->rev_data_curr = 0;
+	mddi->rev_addr = dma_addr;
+	mddi->reg_write_data = dma + MDDI_REV_BUFFER_SIZE;
+	mddi->reg_write_addr = dma_addr + MDDI_REV_BUFFER_SIZE;
+	mddi->reg_read_data = mddi->reg_write_data + 1;
+	mddi->reg_read_addr = mddi->reg_write_addr +
+			      sizeof(*mddi->reg_write_data);
+	return 0;
+}
+
+static int __init mddi_probe(struct platform_device *pdev)
+{
+	struct msm_mddi_platform_data *pdata = pdev->dev.platform_data;
+	struct mddi_info *mddi = &mddi_info[pdev->id];
+	struct resource *resource;
+	int ret, i;
+
+	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!resource) {
+		printk(KERN_ERR "mddi: no associated mem resource!\n");
+		return -ENOMEM;
+	}
+	mddi->base = ioremap(resource->start, resource->end - resource->start);
+	if (!mddi->base) {
+		printk(KERN_ERR "mddi: failed to remap base!\n");
+		ret = -EINVAL;
+		goto error_ioremap;
+	}
+	resource = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!resource) {
+		printk(KERN_ERR "mddi: no associated irq resource!\n");
+		ret = -EINVAL;
+		goto error_get_irq_resource;
+	}
+	mddi->irq = resource->start;
+	printk(KERN_INFO "mddi: init() base=0x%p irq=%d\n", mddi->base,
+	       mddi->irq);
+	mddi->power_client = pdata->power_client;
+
+	mutex_init(&mddi->reg_write_lock);
+	mutex_init(&mddi->reg_read_lock);
+	spin_lock_init(&mddi->int_lock);
+	init_waitqueue_head(&mddi->int_wait);
+
+	ret = mddi_clk_setup(pdev, mddi, pdata->clk_rate);
+	if (ret) {
+		printk(KERN_ERR "mddi: failed to setup clock!\n");
+		goto error_clk_setup;
+	}
+
+	ret = mddi_rev_data_setup(mddi);
+	if (ret) {
+		printk(KERN_ERR "mddi: failed to setup rev data!\n");
+		goto error_rev_data;
+	}
+
+	mddi->int_enable = 0;
+	mddi_writel(mddi->int_enable, INTEN);
+	ret = request_irq(mddi->irq, mddi_isr, IRQF_DISABLED, "mddi",
+			  &mddi->client_data);
+	if (ret) {
+		printk(KERN_ERR "mddi: failed to request enable irq!\n");
+		goto error_request_irq;
+	}
+
+	/* turn on the mddi client bridge chip */
+	if (mddi->power_client)
+		mddi->power_client(&mddi->client_data, 1);
+
+	/* initialize the mddi registers */
+	mddi_set_auto_hibernate(&mddi->client_data, 0);
+	mddi_writel(MDDI_CMD_RESET, CMD);
+	mddi_wait_interrupt(mddi, MDDI_INT_NO_CMD_PKTS_PEND);
+	mddi->version = mddi_init_registers(mddi);
+	if (mddi->version < 0x20) {
+		printk(KERN_ERR "mddi: unsupported version 0x%x\n",
+		       mddi->version);
+		ret = -ENODEV;
+		goto error_mddi_version;
+	}
+
+	/* read the capabilities off the client */
+	if (!mddi_get_client_caps(mddi)) {
+		printk(KERN_INFO "mddi: no client found\n");
+		/* power down the panel */
+		mddi_writel(MDDI_CMD_POWERDOWN, CMD);
+		printk(KERN_INFO "mddi powerdown: stat %x\n", mddi_readl(STAT));
+		msleep(100);
+		printk(KERN_INFO "mddi powerdown: stat %x\n", mddi_readl(STAT));
+		return 0;
+	}
+	mddi_set_auto_hibernate(&mddi->client_data, 1);
+
+	if (mddi->caps.Mfr_Name == 0 && mddi->caps.Product_Code == 0)
+		pdata->fixup(&mddi->caps.Mfr_Name, &mddi->caps.Product_Code);
+
+	mddi->client_pdev.id = 0;
+	for (i = 0; i < pdata->num_clients; i++) {
+		if (pdata->client_platform_data[i].product_id ==
+		    (mddi->caps.Mfr_Name << 16 | mddi->caps.Product_Code)) {
+			mddi->client_data.private_client_data =
+				pdata->client_platform_data[i].client_data;
+			mddi->client_pdev.name =
+				pdata->client_platform_data[i].name;
+			mddi->client_pdev.id =
+				pdata->client_platform_data[i].id;
+			/* XXX: possibly set clock */
+			break;
+		}
+	}
+
+	if (i >= pdata->num_clients)
+		mddi->client_pdev.name = "mddi_c_dummy";
+	printk(KERN_INFO "mddi: registering panel %s\n",
+		mddi->client_pdev.name);
+
+	mddi->client_data.suspend = mddi_suspend;
+	mddi->client_data.resume = mddi_resume;
+	mddi->client_data.activate_link = mddi_activate_link;
+	mddi->client_data.remote_write = mddi_remote_write;
+	mddi->client_data.remote_read = mddi_remote_read;
+	mddi->client_data.auto_hibernate = mddi_set_auto_hibernate;
+	mddi->client_data.fb_resource = pdata->fb_resource;
+	if (pdev->id == 0)
+		mddi->client_data.interface_type = MSM_MDDI_PMDH_INTERFACE;
+	else if (pdev->id == 1)
+		mddi->client_data.interface_type = MSM_MDDI_EMDH_INTERFACE;
+	else {
+		printk(KERN_ERR "mddi: can not determine interface %d!\n",
+		       pdev->id);
+		ret = -EINVAL;
+		goto error_mddi_interface;
+	}
+
+	mddi->client_pdev.dev.platform_data = &mddi->client_data;
+	printk(KERN_INFO "mddi: publish: %s\n", mddi->client_name);
+	platform_device_register(&mddi->client_pdev);
+	return 0;
+
+error_mddi_interface:
+error_mddi_version:
+	free_irq(mddi->irq, 0);
+error_request_irq:
+	dma_free_coherent(NULL, 0x1000, mddi->rev_data, mddi->rev_addr);
+error_rev_data:
+error_clk_setup:
+error_get_irq_resource:
+	iounmap(mddi->base);
+error_ioremap:
+
+	printk(KERN_INFO "mddi: mddi_init() failed (%d)\n", ret);
+	return ret;
+}
+
+
+static struct platform_driver mddi_driver = {
+	.probe = mddi_probe,
+	.driver = { .name = "msm_mddi" },
+};
+
+static int __init _mddi_init(void)
+{
+	return platform_driver_register(&mddi_driver);
+}
+
+module_init(_mddi_init);
diff -puN /dev/null drivers/video/msm/mddi_client_dummy.c
--- /dev/null
+++ a/drivers/video/msm/mddi_client_dummy.c
@@ -0,0 +1,97 @@
+/* drivers/video/msm_fb/mddi_client_dummy.c
+ *
+ * Support for "dummy" mddi client devices which require no
+ * special initialization code.
+ *
+ * Copyright (C) 2007 Google Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+
+#include <mach/msm_fb.h>
+
+struct panel_info {
+	struct platform_device pdev;
+	struct msm_panel_data panel_data;
+};
+
+static int mddi_dummy_suspend(struct msm_panel_data *panel_data)
+{
+	return 0;
+}
+
+static int mddi_dummy_resume(struct msm_panel_data *panel_data)
+{
+	return 0;
+}
+
+static int mddi_dummy_blank(struct msm_panel_data *panel_data)
+{
+	return 0;
+}
+
+static int mddi_dummy_unblank(struct msm_panel_data *panel_data)
+{
+	return 0;
+}
+
+static int mddi_dummy_probe(struct platform_device *pdev)
+{
+	struct msm_mddi_client_data *client_data = pdev->dev.platform_data;
+	struct panel_info *panel =
+		kzalloc(sizeof(struct panel_info), GFP_KERNEL);
+	int ret;
+	if (!panel)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, panel);
+	panel->panel_data.suspend = mddi_dummy_suspend;
+	panel->panel_data.resume = mddi_dummy_resume;
+	panel->panel_data.blank = mddi_dummy_blank;
+	panel->panel_data.unblank = mddi_dummy_unblank;
+	panel->panel_data.caps = MSMFB_CAP_PARTIAL_UPDATES;
+	panel->pdev.name = "msm_panel";
+	panel->pdev.id = pdev->id;
+	platform_device_add_resources(&panel->pdev,
+				      client_data->fb_resource, 1);
+	panel->panel_data.fb_data = client_data->private_client_data;
+	panel->pdev.dev.platform_data = &panel->panel_data;
+	ret = platform_device_register(&panel->pdev);
+	if (ret) {
+		kfree(panel);
+		return ret;
+	}
+	return 0;
+}
+
+static int mddi_dummy_remove(struct platform_device *pdev)
+{
+	struct panel_info *panel = platform_get_drvdata(pdev);
+	kfree(panel);
+	return 0;
+}
+
+static struct platform_driver mddi_client_dummy = {
+	.probe = mddi_dummy_probe,
+	.remove = mddi_dummy_remove,
+	.driver = { .name = "mddi_c_dummy" },
+};
+
+static int __init mddi_client_dummy_init(void)
+{
+	platform_driver_register(&mddi_client_dummy);
+	return 0;
+}
+
+module_init(mddi_client_dummy_init);
+
diff -puN /dev/null drivers/video/msm/mddi_client_nt35399.c
--- /dev/null
+++ a/drivers/video/msm/mddi_client_nt35399.c
@@ -0,0 +1,255 @@
+/* drivers/video/msm_fb/mddi_client_nt35399.c
+ *
+ * Support for Novatek NT35399 MDDI client of Sapphire
+ *
+ * Copyright (C) 2008 HTC Incorporated
+ * Author: Solomon Chiu (solomon_chiu@htc.com)
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <mach/msm_fb.h>
+
+static DECLARE_WAIT_QUEUE_HEAD(nt35399_vsync_wait);
+
+struct panel_info {
+	struct msm_mddi_client_data *client_data;
+	struct platform_device pdev;
+	struct msm_panel_data panel_data;
+	struct msmfb_callback *fb_callback;
+	struct work_struct panel_work;
+	struct workqueue_struct *fb_wq;
+	int nt35399_got_int;
+};
+
+static void
+nt35399_request_vsync(struct msm_panel_data *panel_data,
+		      struct msmfb_callback *callback)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+
+	panel->fb_callback = callback;
+	if (panel->nt35399_got_int) {
+		panel->nt35399_got_int = 0;
+		client_data->activate_link(client_data); /* clears interrupt */
+	}
+}
+
+static void nt35399_wait_vsync(struct msm_panel_data *panel_data)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+
+	if (panel->nt35399_got_int) {
+		panel->nt35399_got_int = 0;
+		client_data->activate_link(client_data); /* clears interrupt */
+	}
+
+	if (wait_event_timeout(nt35399_vsync_wait, panel->nt35399_got_int,
+				HZ/2) == 0)
+		printk(KERN_ERR "timeout waiting for VSYNC\n");
+
+	panel->nt35399_got_int = 0;
+	/* interrupt clears when screen dma starts */
+}
+
+static int nt35399_suspend(struct msm_panel_data *panel_data)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+
+	struct msm_mddi_bridge_platform_data *bridge_data =
+		client_data->private_client_data;
+	int ret;
+
+	ret = bridge_data->uninit(bridge_data, client_data);
+	if (ret) {
+		printk(KERN_INFO "mddi nt35399 client: non zero return from "
+			"uninit\n");
+		return ret;
+	}
+	client_data->suspend(client_data);
+	return 0;
+}
+
+static int nt35399_resume(struct msm_panel_data *panel_data)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+
+	struct msm_mddi_bridge_platform_data *bridge_data =
+		client_data->private_client_data;
+	int ret;
+
+	client_data->resume(client_data);
+	ret = bridge_data->init(bridge_data, client_data);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+static int nt35399_blank(struct msm_panel_data *panel_data)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+	struct msm_mddi_bridge_platform_data *bridge_data =
+		client_data->private_client_data;
+
+	return bridge_data->blank(bridge_data, client_data);
+}
+
+static int nt35399_unblank(struct msm_panel_data *panel_data)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+	struct msm_mddi_bridge_platform_data *bridge_data =
+		client_data->private_client_data;
+
+	return bridge_data->unblank(bridge_data, client_data);
+}
+
+irqreturn_t nt35399_vsync_interrupt(int irq, void *data)
+{
+	struct panel_info *panel = data;
+
+	panel->nt35399_got_int = 1;
+
+	if (panel->fb_callback) {
+		panel->fb_callback->func(panel->fb_callback);
+		panel->fb_callback = NULL;
+	}
+
+	wake_up(&nt35399_vsync_wait);
+
+	return IRQ_HANDLED;
+}
+
+static int setup_vsync(struct panel_info *panel, int init)
+{
+	int ret;
+	int gpio = 97;
+	unsigned int irq;
+
+	if (!init) {
+		ret = 0;
+		goto uninit;
+	}
+	ret = gpio_request(gpio, "vsync");
+	if (ret)
+		goto err_request_gpio_failed;
+
+	ret = gpio_direction_input(gpio);
+	if (ret)
+		goto err_gpio_direction_input_failed;
+
+	ret = irq = gpio_to_irq(gpio);
+	if (ret < 0)
+		goto err_get_irq_num_failed;
+
+	ret = request_irq(irq, nt35399_vsync_interrupt, IRQF_TRIGGER_RISING,
+			  "vsync", panel);
+	if (ret)
+		goto err_request_irq_failed;
+
+	printk(KERN_INFO "vsync on gpio %d now %d\n",
+	       gpio, gpio_get_value(gpio));
+	return 0;
+
+uninit:
+	free_irq(gpio_to_irq(gpio), panel->client_data);
+err_request_irq_failed:
+err_get_irq_num_failed:
+err_gpio_direction_input_failed:
+	gpio_free(gpio);
+err_request_gpio_failed:
+	return ret;
+}
+
+static int mddi_nt35399_probe(struct platform_device *pdev)
+{
+	struct msm_mddi_client_data *client_data = pdev->dev.platform_data;
+	struct msm_mddi_bridge_platform_data *bridge_data =
+		client_data->private_client_data;
+
+	int ret;
+
+	struct panel_info *panel = kzalloc(sizeof(struct panel_info),
+					   GFP_KERNEL);
+
+	printk(KERN_DEBUG "%s: enter.\n", __func__);
+
+	if (!panel)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, panel);
+
+	ret = setup_vsync(panel, 1);
+	if (ret) {
+		dev_err(&pdev->dev, "mddi_nt35399_setup_vsync failed\n");
+		return ret;
+	}
+
+	panel->client_data = client_data;
+	panel->panel_data.suspend = nt35399_suspend;
+	panel->panel_data.resume = nt35399_resume;
+	panel->panel_data.wait_vsync = nt35399_wait_vsync;
+	panel->panel_data.request_vsync = nt35399_request_vsync;
+	panel->panel_data.blank = nt35399_blank;
+	panel->panel_data.unblank = nt35399_unblank;
+	panel->panel_data.fb_data = &bridge_data->fb_data;
+	panel->panel_data.caps = 0;
+
+	panel->pdev.name = "msm_panel";
+	panel->pdev.id = pdev->id;
+	panel->pdev.resource = client_data->fb_resource;
+	panel->pdev.num_resources = 1;
+	panel->pdev.dev.platform_data = &panel->panel_data;
+
+	if (bridge_data->init)
+		bridge_data->init(bridge_data, client_data);
+
+	platform_device_register(&panel->pdev);
+
+	return 0;
+}
+
+static int mddi_nt35399_remove(struct platform_device *pdev)
+{
+	struct panel_info *panel = platform_get_drvdata(pdev);
+
+	setup_vsync(panel, 0);
+	kfree(panel);
+	return 0;
+}
+
+static struct platform_driver mddi_client_0bda_8a47 = {
+	.probe = mddi_nt35399_probe,
+	.remove = mddi_nt35399_remove,
+	.driver = { .name = "mddi_c_0bda_8a47" },
+};
+
+static int __init mddi_client_nt35399_init(void)
+{
+	return platform_driver_register(&mddi_client_0bda_8a47);
+}
+
+module_init(mddi_client_nt35399_init);
+
diff -puN /dev/null drivers/video/msm/mddi_client_toshiba.c
--- /dev/null
+++ a/drivers/video/msm/mddi_client_toshiba.c
@@ -0,0 +1,283 @@
+/* drivers/video/msm_fb/mddi_client_toshiba.c
+ *
+ * Support for Toshiba TC358720XBG mddi client devices which require no
+ * special initialization code.
+ *
+ * Copyright (C) 2007 Google Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <mach/msm_fb.h>
+
+
+#define LCD_CONTROL_BLOCK_BASE 0x110000
+#define CMN         (LCD_CONTROL_BLOCK_BASE|0x10)
+#define INTFLG      (LCD_CONTROL_BLOCK_BASE|0x18)
+#define HCYCLE      (LCD_CONTROL_BLOCK_BASE|0x34)
+#define HDE_START   (LCD_CONTROL_BLOCK_BASE|0x3C)
+#define VPOS        (LCD_CONTROL_BLOCK_BASE|0xC0)
+#define MPLFBUF     (LCD_CONTROL_BLOCK_BASE|0x20)
+#define WAKEUP      (LCD_CONTROL_BLOCK_BASE|0x54)
+#define WSYN_DLY    (LCD_CONTROL_BLOCK_BASE|0x58)
+#define REGENB      (LCD_CONTROL_BLOCK_BASE|0x5C)
+
+#define BASE5 0x150000
+#define BASE6 0x160000
+#define BASE7 0x170000
+
+#define GPIOIEV     (BASE5 + 0x10)
+#define GPIOIE      (BASE5 + 0x14)
+#define GPIORIS     (BASE5 + 0x18)
+#define GPIOMIS     (BASE5 + 0x1C)
+#define GPIOIC      (BASE5 + 0x20)
+
+#define INTMASK     (BASE6 + 0x0C)
+#define INTMASK_VWAKEOUT (1U << 0)
+#define INTMASK_VWAKEOUT_ACTIVE_LOW (1U << 8)
+#define GPIOSEL     (BASE7 + 0x00)
+#define GPIOSEL_VWAKEINT (1U << 0)
+
+static DECLARE_WAIT_QUEUE_HEAD(toshiba_vsync_wait);
+
+struct panel_info {
+	struct msm_mddi_client_data *client_data;
+	struct platform_device pdev;
+	struct msm_panel_data panel_data;
+	struct msmfb_callback *toshiba_callback;
+	int toshiba_got_int;
+};
+
+
+static void toshiba_request_vsync(struct msm_panel_data *panel_data,
+				  struct msmfb_callback *callback)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+
+	panel->toshiba_callback = callback;
+	if (panel->toshiba_got_int) {
+		panel->toshiba_got_int = 0;
+		client_data->activate_link(client_data);
+	}
+}
+
+static void toshiba_clear_vsync(struct msm_panel_data *panel_data)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+
+	client_data->activate_link(client_data);
+}
+
+static void toshiba_wait_vsync(struct msm_panel_data *panel_data)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+
+	if (panel->toshiba_got_int) {
+		panel->toshiba_got_int = 0;
+		client_data->activate_link(client_data); /* clears interrupt */
+	}
+	if (wait_event_timeout(toshiba_vsync_wait, panel->toshiba_got_int,
+				HZ/2) == 0)
+		printk(KERN_ERR "timeout waiting for VSYNC\n");
+	panel->toshiba_got_int = 0;
+	/* interrupt clears when screen dma starts */
+}
+
+static int toshiba_suspend(struct msm_panel_data *panel_data)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+
+	struct msm_mddi_bridge_platform_data *bridge_data =
+		client_data->private_client_data;
+	int ret;
+
+	ret = bridge_data->uninit(bridge_data, client_data);
+	if (ret) {
+		printk(KERN_INFO "mddi toshiba client: non zero return from "
+			"uninit\n");
+		return ret;
+	}
+	client_data->suspend(client_data);
+	return 0;
+}
+
+static int toshiba_resume(struct msm_panel_data *panel_data)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+
+	struct msm_mddi_bridge_platform_data *bridge_data =
+		client_data->private_client_data;
+	int ret;
+
+	client_data->resume(client_data);
+	ret = bridge_data->init(bridge_data, client_data);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+static int toshiba_blank(struct msm_panel_data *panel_data)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+	struct msm_mddi_bridge_platform_data *bridge_data =
+		client_data->private_client_data;
+
+	return bridge_data->blank(bridge_data, client_data);
+}
+
+static int toshiba_unblank(struct msm_panel_data *panel_data)
+{
+	struct panel_info *panel = container_of(panel_data, struct panel_info,
+						panel_data);
+	struct msm_mddi_client_data *client_data = panel->client_data;
+	struct msm_mddi_bridge_platform_data *bridge_data =
+		client_data->private_client_data;
+
+	return bridge_data->unblank(bridge_data, client_data);
+}
+
+irqreturn_t toshiba_vsync_interrupt(int irq, void *data)
+{
+	struct panel_info *panel = data;
+
+	panel->toshiba_got_int = 1;
+	if (panel->toshiba_callback) {
+		panel->toshiba_callback->func(panel->toshiba_callback);
+		panel->toshiba_callback = 0;
+	}
+	wake_up(&toshiba_vsync_wait);
+	return IRQ_HANDLED;
+}
+
+static int setup_vsync(struct panel_info *panel,
+		       int init)
+{
+	int ret;
+	int gpio = 97;
+	unsigned int irq;
+
+	if (!init) {
+		ret = 0;
+		goto uninit;
+	}
+	ret = gpio_request(gpio, "vsync");
+	if (ret)
+		goto err_request_gpio_failed;
+
+	ret = gpio_direction_input(gpio);
+	if (ret)
+		goto err_gpio_direction_input_failed;
+
+	ret = irq = gpio_to_irq(gpio);
+	if (ret < 0)
+		goto err_get_irq_num_failed;
+
+	ret = request_irq(irq, toshiba_vsync_interrupt, IRQF_TRIGGER_RISING,
+			  "vsync", panel);
+	if (ret)
+		goto err_request_irq_failed;
+	printk(KERN_INFO "vsync on gpio %d now %d\n",
+	       gpio, gpio_get_value(gpio));
+	return 0;
+
+uninit:
+	free_irq(gpio_to_irq(gpio), panel);
+err_request_irq_failed:
+err_get_irq_num_failed:
+err_gpio_direction_input_failed:
+	gpio_free(gpio);
+err_request_gpio_failed:
+	return ret;
+}
+
+static int mddi_toshiba_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct msm_mddi_client_data *client_data = pdev->dev.platform_data;
+	struct msm_mddi_bridge_platform_data *bridge_data =
+		client_data->private_client_data;
+	struct panel_info *panel =
+		kzalloc(sizeof(struct panel_info), GFP_KERNEL);
+	if (!panel)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, panel);
+
+	/* mddi_remote_write(mddi, 0, WAKEUP); */
+	client_data->remote_write(client_data, GPIOSEL_VWAKEINT, GPIOSEL);
+	client_data->remote_write(client_data, INTMASK_VWAKEOUT, INTMASK);
+
+	ret = setup_vsync(panel, 1);
+	if (ret) {
+		dev_err(&pdev->dev, "mddi_bridge_setup_vsync failed\n");
+		return ret;
+	}
+
+	panel->client_data = client_data;
+	panel->panel_data.suspend = toshiba_suspend;
+	panel->panel_data.resume = toshiba_resume;
+	panel->panel_data.wait_vsync = toshiba_wait_vsync;
+	panel->panel_data.request_vsync = toshiba_request_vsync;
+	panel->panel_data.clear_vsync = toshiba_clear_vsync;
+	panel->panel_data.blank = toshiba_blank;
+	panel->panel_data.unblank = toshiba_unblank;
+	panel->panel_data.fb_data =  &bridge_data->fb_data;
+	panel->panel_data.caps = MSMFB_CAP_PARTIAL_UPDATES;
+
+	panel->pdev.name = "msm_panel";
+	panel->pdev.id = pdev->id;
+	panel->pdev.resource = client_data->fb_resource;
+	panel->pdev.num_resources = 1;
+	panel->pdev.dev.platform_data = &panel->panel_data;
+	bridge_data->init(bridge_data, client_data);
+	platform_device_register(&panel->pdev);
+
+	return 0;
+}
+
+static int mddi_toshiba_remove(struct platform_device *pdev)
+{
+	struct panel_info *panel = platform_get_drvdata(pdev);
+
+	setup_vsync(panel, 0);
+	kfree(panel);
+	return 0;
+}
+
+static struct platform_driver mddi_client_d263_0000 = {
+	.probe = mddi_toshiba_probe,
+	.remove = mddi_toshiba_remove,
+	.driver = { .name = "mddi_c_d263_0000" },
+};
+
+static int __init mddi_client_toshiba_init(void)
+{
+	platform_driver_register(&mddi_client_d263_0000);
+	return 0;
+}
+
+module_init(mddi_client_toshiba_init);
+
diff -puN /dev/null drivers/video/msm/mddi_hw.h
--- /dev/null
+++ a/drivers/video/msm/mddi_hw.h
@@ -0,0 +1,303 @@
+/* drivers/video/msm_fb/mddi_hw.h
+ *
+ * MSM MDDI Hardware Registers and Structures
+ *
+ * Copyright (C) 2007 QUALCOMM Incorporated
+ * Copyright (C) 2007 Google Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MDDI_HW_H_
+#define _MDDI_HW_H_
+
+#include <linux/types.h>
+
+#define MDDI_CMD                0x0000
+#define MDDI_VERSION            0x0004
+#define MDDI_PRI_PTR            0x0008
+#define MDDI_SEC_PTR            0x000c
+#define MDDI_BPS                0x0010
+#define MDDI_SPM                0x0014
+#define MDDI_INT                0x0018
+#define MDDI_INTEN              0x001c
+#define MDDI_REV_PTR            0x0020
+#define MDDI_REV_SIZE           0x0024
+#define MDDI_STAT               0x0028
+#define MDDI_REV_RATE_DIV       0x002c
+#define MDDI_REV_CRC_ERR        0x0030
+#define MDDI_TA1_LEN            0x0034
+#define MDDI_TA2_LEN            0x0038
+#define MDDI_TEST_BUS           0x003c
+#define MDDI_TEST               0x0040
+#define MDDI_REV_PKT_CNT        0x0044
+#define MDDI_DRIVE_HI           0x0048
+#define MDDI_DRIVE_LO           0x004c
+#define MDDI_DISP_WAKE          0x0050
+#define MDDI_REV_ENCAP_SZ       0x0054
+#define MDDI_RTD_VAL            0x0058
+#define MDDI_PAD_CTL            0x0068
+#define MDDI_DRIVER_START_CNT   0x006c
+#define MDDI_NEXT_PRI_PTR       0x0070
+#define MDDI_NEXT_SEC_PTR       0x0074
+#define MDDI_MISR_CTL           0x0078
+#define MDDI_MISR_DATA          0x007c
+#define MDDI_SF_CNT             0x0080
+#define MDDI_MF_CNT             0x0084
+#define MDDI_CURR_REV_PTR       0x0088
+#define MDDI_CORE_VER           0x008c
+
+#define MDDI_INT_PRI_PTR_READ       0x0001
+#define MDDI_INT_SEC_PTR_READ       0x0002
+#define MDDI_INT_REV_DATA_AVAIL     0x0004
+#define MDDI_INT_DISP_REQ           0x0008
+#define MDDI_INT_PRI_UNDERFLOW      0x0010
+#define MDDI_INT_SEC_UNDERFLOW      0x0020
+#define MDDI_INT_REV_OVERFLOW       0x0040
+#define MDDI_INT_CRC_ERROR          0x0080
+#define MDDI_INT_MDDI_IN            0x0100
+#define MDDI_INT_PRI_OVERWRITE      0x0200
+#define MDDI_INT_SEC_OVERWRITE      0x0400
+#define MDDI_INT_REV_OVERWRITE      0x0800
+#define MDDI_INT_DMA_FAILURE        0x1000
+#define MDDI_INT_LINK_ACTIVE        0x2000
+#define MDDI_INT_IN_HIBERNATION     0x4000
+#define MDDI_INT_PRI_LINK_LIST_DONE 0x8000
+#define MDDI_INT_SEC_LINK_LIST_DONE 0x10000
+#define MDDI_INT_NO_CMD_PKTS_PEND   0x20000
+#define MDDI_INT_RTD_FAILURE        0x40000
+#define MDDI_INT_REV_PKT_RECEIVED   0x80000
+#define MDDI_INT_REV_PKTS_AVAIL     0x100000
+
+#define MDDI_INT_NEED_CLEAR ( \
+	MDDI_INT_REV_DATA_AVAIL | \
+	MDDI_INT_PRI_UNDERFLOW | \
+	MDDI_INT_SEC_UNDERFLOW | \
+	MDDI_INT_REV_OVERFLOW | \
+	MDDI_INT_CRC_ERROR | \
+	MDDI_INT_REV_PKT_RECEIVED)
+
+
+#define MDDI_STAT_LINK_ACTIVE        0x0001
+#define MDDI_STAT_NEW_REV_PTR        0x0002
+#define MDDI_STAT_NEW_PRI_PTR        0x0004
+#define MDDI_STAT_NEW_SEC_PTR        0x0008
+#define MDDI_STAT_IN_HIBERNATION     0x0010
+#define MDDI_STAT_PRI_LINK_LIST_DONE 0x0020
+#define MDDI_STAT_SEC_LINK_LIST_DONE 0x0040
+#define MDDI_STAT_PENDING_TIMING_PKT 0x0080
+#define MDDI_STAT_PENDING_REV_ENCAP  0x0100
+#define MDDI_STAT_PENDING_POWERDOWN  0x0200
+#define MDDI_STAT_RTD_MEAS_FAIL      0x0800
+#define MDDI_STAT_CLIENT_WAKEUP_REQ  0x1000
+
+
+#define MDDI_CMD_POWERDOWN           0x0100
+#define MDDI_CMD_POWERUP             0x0200
+#define MDDI_CMD_HIBERNATE           0x0300
+#define MDDI_CMD_RESET               0x0400
+#define MDDI_CMD_DISP_IGNORE         0x0501
+#define MDDI_CMD_DISP_LISTEN         0x0500
+#define MDDI_CMD_SEND_REV_ENCAP      0x0600
+#define MDDI_CMD_GET_CLIENT_CAP      0x0601
+#define MDDI_CMD_GET_CLIENT_STATUS   0x0602
+#define MDDI_CMD_SEND_RTD            0x0700
+#define MDDI_CMD_LINK_ACTIVE         0x0900
+#define MDDI_CMD_PERIODIC_REV_ENCAP  0x0A00
+#define MDDI_CMD_FORCE_NEW_REV_PTR   0x0C00
+
+
+
+#define MDDI_VIDEO_REV_PKT_SIZE              0x40
+#define MDDI_CLIENT_CAPABILITY_REV_PKT_SIZE  0x60
+#define MDDI_MAX_REV_PKT_SIZE                0x60
+
+/* #define MDDI_REV_BUFFER_SIZE 128 */
+#define MDDI_REV_BUFFER_SIZE (MDDI_MAX_REV_PKT_SIZE * 4)
+
+/* MDP sends 256 pixel packets, so lower value hibernates more without
+ * significantly increasing latency of waiting for next subframe */
+#define MDDI_HOST_BYTES_PER_SUBFRAME  0x3C00
+#define MDDI_HOST_TA2_LEN       0x000c
+#define MDDI_HOST_REV_RATE_DIV  0x0002
+
+
+struct __attribute__((packed)) mddi_rev_packet {
+	uint16_t length;
+	uint16_t type;
+	uint16_t client_id;
+};
+
+struct __attribute__((packed)) mddi_client_status {
+	uint16_t length;
+	uint16_t type;
+	uint16_t client_id;
+	uint16_t reverse_link_request;  /* bytes needed in rev encap message */
+	uint8_t  crc_error_count;
+	uint8_t  capability_change;
+	uint16_t graphics_busy_flags;
+	uint16_t crc16;
+};
+
+struct __attribute__((packed)) mddi_client_caps {
+	uint16_t length; /* length, exclusive of this field */
+	uint16_t type; /* 66 */
+	uint16_t client_id;
+
+	uint16_t Protocol_Version;
+	uint16_t Minimum_Protocol_Version;
+	uint16_t Data_Rate_Capability;
+	uint8_t  Interface_Type_Capability;
+	uint8_t  Number_of_Alt_Displays;
+	uint16_t PostCal_Data_Rate;
+	uint16_t Bitmap_Width;
+	uint16_t Bitmap_Height;
+	uint16_t Display_Window_Width;
+	uint16_t Display_Window_Height;
+	uint32_t Color_Map_Size;
+	uint16_t Color_Map_RGB_Width;
+	uint16_t RGB_Capability;
+	uint8_t  Monochrome_Capability;
+	uint8_t  Reserved_1;
+	uint16_t Y_Cb_Cr_Capability;
+	uint16_t Bayer_Capability;
+	uint16_t Alpha_Cursor_Image_Planes;
+	uint32_t Client_Feature_Capability_Indicators;
+	uint8_t  Maximum_Video_Frame_Rate_Capability;
+	uint8_t  Minimum_Video_Frame_Rate_Capability;
+	uint16_t Minimum_Sub_frame_Rate;
+	uint16_t Audio_Buffer_Depth;
+	uint16_t Audio_Channel_Capability;
+	uint16_t Audio_Sample_Rate_Capability;
+	uint8_t  Audio_Sample_Resolution;
+	uint8_t  Mic_Audio_Sample_Resolution;
+	uint16_t Mic_Sample_Rate_Capability;
+	uint8_t  Keyboard_Data_Format;
+	uint8_t  pointing_device_data_format;
+	uint16_t content_protection_type;
+	uint16_t Mfr_Name;
+	uint16_t Product_Code;
+	uint16_t Reserved_3;
+	uint32_t Serial_Number;
+	uint8_t  Week_of_Manufacture;
+	uint8_t  Year_of_Manufacture;
+
+	uint16_t crc16;
+} mddi_client_capability_type;
+
+
+struct __attribute__((packed)) mddi_video_stream {
+	uint16_t length;
+	uint16_t type; /* 16 */
+	uint16_t client_id; /* 0 */
+
+	uint16_t video_data_format_descriptor;
+	/* format of each pixel in the Pixel Data in the present stream in the
+	 * present packet.
+	 * If bits [15:13] = 000 monochrome
+	 * If bits [15:13] = 001 color pixels (palette).
+	 * If bits [15:13] = 010 color pixels in raw RGB
+	 * If bits [15:13] = 011 data in 4:2:2 Y Cb Cr format
+	 * If bits [15:13] = 100 Bayer pixels
+	 */
+
+	uint16_t pixel_data_attributes;
+	/* interpreted as follows:
+	 * Bits [1:0] = 11  pixel data is displayed to both eyes
+	 * Bits [1:0] = 10  pixel data is routed to the left eye only.
+	 * Bits [1:0] = 01  pixel data is routed to the right eye only.
+	 * Bits [1:0] = 00  pixel data is routed to the alternate display.
+	 * Bit 2 is 0  Pixel Data is in the standard progressive format.
+	 * Bit 2 is 1  Pixel Data is in interlace format.
+	 * Bit 3 is 0  Pixel Data is in the standard progressive format.
+	 * Bit 3 is 1  Pixel Data is in alternate pixel format.
+	 * Bit 4 is 0  Pixel Data is to or from the display frame buffer.
+	 * Bit 4 is 1  Pixel Data is to or from the camera.
+	 * Bit 5 is 0  pixel data contains the next consecutive row of pixels.
+	 * Bit 5 is 1  X Left Edge, Y Top Edge, X Right Edge, Y Bottom Edge,
+	 *             X Start, and Y Start parameters are not defined and
+	 *             shall be ignored by the client.
+	 * Bits [7:6] = 01  Pixel data is written to the offline image buffer.
+	 * Bits [7:6] = 00  Pixel data is written to the buffer to refresh display.
+	 * Bits [7:6] = 11  Pixel data is written to all image buffers.
+	 * Bits [7:6] = 10  Invalid. Reserved for future use.
+	 * Bits 8 through 11 alternate display number.
+	 * Bits 12 through 14 are reserved for future use and shall be set to zero.
+	 * Bit 15 is 1 the row of pixels is the last row of pixels in a frame.
+	 */
+
+	uint16_t x_left_edge;
+	uint16_t y_top_edge;
+	/* X,Y coordinate of the top left edge of the screen window */
+
+	uint16_t x_right_edge;
+	uint16_t y_bottom_edge;
+	/*  X,Y coordinate of the bottom right edge of the window being updated. */
+
+	uint16_t x_start;
+	uint16_t y_start;
+	/*  (X Start, Y Start) is the first pixel in the Pixel Data field below. */
+
+	uint16_t pixel_count;
+	/*  number of pixels in the Pixel Data field below. */
+
+	uint16_t parameter_CRC;
+	/*  16-bit CRC of all bytes from the Packet Length to the Pixel Count. */
+
+	uint16_t reserved;
+	/* 16-bit variable to make structure align on 4 byte boundary */
+};
+
+#define TYPE_VIDEO_STREAM      16
+#define TYPE_CLIENT_CAPS       66
+#define TYPE_REGISTER_ACCESS   146
+#define TYPE_CLIENT_STATUS     70
+
+struct __attribute__((packed)) mddi_register_access {
+	uint16_t length;
+	uint16_t type; /* 146 */
+	uint16_t client_id;
+
+	uint16_t read_write_info;
+	/* Bits 13:0  a 14-bit unsigned integer that specifies the number of
+	 *            32-bit Register Data List items to be transferred in the
+	 *            Register Data List field.
+	 * Bits[15:14] = 00  Write to register(s);
+	 * Bits[15:14] = 10  Read from register(s);
+	 * Bits[15:14] = 11  Response to a Read.
+	 * Bits[15:14] = 01  this value is reserved for future use. */
+#define MDDI_WRITE     (0 << 14)
+#define MDDI_READ      (2 << 14)
+#define MDDI_READ_RESP (3 << 14)
+
+	uint32_t register_address;
+	/* the register address that is to be written to or read from. */
+
+	uint16_t crc16;
+
+	uint32_t register_data_list;
+	/* list of 4-byte register data values for/from client registers */
+};
+
+struct __attribute__((packed)) mddi_llentry {
+	uint16_t flags;
+	uint16_t header_count;
+	uint16_t data_count;
+	dma_addr_t data; /* 32 bit */
+	struct mddi_llentry *next;
+	uint16_t reserved;
+	union {
+		struct mddi_video_stream v;
+		struct mddi_register_access r;
+		uint32_t _[12];
+	} u;
+};
+
+#endif
diff -puN /dev/null drivers/video/msm/mdp.c
--- /dev/null
+++ a/drivers/video/msm/mdp.c
@@ -0,0 +1,538 @@
+/* drivers/video/msm_fb/mdp.c
+ *
+ * MSM MDP Interface (used by framebuffer core)
+ *
+ * Copyright (C) 2007 QUALCOMM Incorporated
+ * Copyright (C) 2007 Google Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/fb.h>
+#include <linux/msm_mdp.h>
+#include <linux/interrupt.h>
+#include <linux/wait.h>
+#include <linux/clk.h>
+#include <linux/file.h>
+#ifdef CONFIG_ANDROID_PMEM
+#include <linux/android_pmem.h>
+#endif
+#include <linux/major.h>
+
+#include <mach/msm_iomap.h>
+#include <mach/msm_fb.h>
+#include <linux/platform_device.h>
+
+#include "mdp_hw.h"
+
+struct class *mdp_class;
+
+#define MDP_CMD_DEBUG_ACCESS_BASE (0x10000)
+
+static uint16_t mdp_default_ccs[] = {
+	0x254, 0x000, 0x331, 0x254, 0xF38, 0xE61, 0x254, 0x409, 0x000,
+	0x010, 0x080, 0x080
+};
+
+static DECLARE_WAIT_QUEUE_HEAD(mdp_dma2_waitqueue);
+static DECLARE_WAIT_QUEUE_HEAD(mdp_ppp_waitqueue);
+static struct msmfb_callback *dma_callback;
+static struct clk *clk;
+static unsigned int mdp_irq_mask;
+static DEFINE_SPINLOCK(mdp_lock);
+DEFINE_MUTEX(mdp_mutex);
+
+static int enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
+{
+	unsigned long irq_flags;
+	int ret = 0;
+
+	BUG_ON(!mask);
+
+	spin_lock_irqsave(&mdp_lock, irq_flags);
+	/* if the mask bits are already set return an error, this interrupt
+	 * is already enabled */
+	if (mdp_irq_mask & mask) {
+		printk(KERN_ERR "mdp irq already on already on %x %x\n",
+		       mdp_irq_mask, mask);
+		ret = -1;
+	}
+	/* if the mdp irq is not already enabled enable it */
+	if (!mdp_irq_mask) {
+		if (clk)
+			clk_enable(clk);
+		enable_irq(mdp->irq);
+	}
+
+	/* update the irq mask to reflect the fact that the interrupt is
+	 * enabled */
+	mdp_irq_mask |= mask;
+	spin_unlock_irqrestore(&mdp_lock, irq_flags);
+	return ret;
+}
+
+static int locked_disable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
+{
+	/* this interrupt is already disabled! */
+	if (!(mdp_irq_mask & mask)) {
+		printk(KERN_ERR "mdp irq already off %x %x\n",
+		       mdp_irq_mask, mask);
+		return -1;
+	}
+	/* update the irq mask to reflect the fact that the interrupt is
+	 * disabled */
+	mdp_irq_mask &= ~(mask);
+	/* if no one is waiting on the interrupt, disable it */
+	if (!mdp_irq_mask) {
+		disable_irq(mdp->irq);
+		if (clk)
+			clk_disable(clk);
+	}
+	return 0;
+}
+
+static int disable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
+{
+	unsigned long irq_flags;
+	int ret;
+
+	spin_lock_irqsave(&mdp_lock, irq_flags);
+	ret = locked_disable_mdp_irq(mdp, mask);
+	spin_unlock_irqrestore(&mdp_lock, irq_flags);
+	return ret;
+}
+
+static irqreturn_t mdp_isr(int irq, void *data)
+{
+	uint32_t status;
+	unsigned long irq_flags;
+	struct mdp_info *mdp = data;
+
+	spin_lock_irqsave(&mdp_lock, irq_flags);
+
+	status = mdp_readl(mdp, MDP_INTR_STATUS);
+	mdp_writel(mdp, status, MDP_INTR_CLEAR);
+
+	status &= mdp_irq_mask;
+	if (status & DL0_DMA2_TERM_DONE) {
+		if (dma_callback) {
+			dma_callback->func(dma_callback);
+			dma_callback = NULL;
+		}
+		wake_up(&mdp_dma2_waitqueue);
+	}
+
+	if (status & DL0_ROI_DONE)
+		wake_up(&mdp_ppp_waitqueue);
+
+	if (status)
+		locked_disable_mdp_irq(mdp, status);
+
+	spin_unlock_irqrestore(&mdp_lock, irq_flags);
+	return IRQ_HANDLED;
+}
+
+static uint32_t mdp_check_mask(uint32_t mask)
+{
+	uint32_t ret;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&mdp_lock, irq_flags);
+	ret = mdp_irq_mask & mask;
+	spin_unlock_irqrestore(&mdp_lock, irq_flags);
+	return ret;
+}
+
+static int mdp_wait(struct mdp_info *mdp, uint32_t mask, wait_queue_head_t *wq)
+{
+	int ret = 0;
+	unsigned long irq_flags;
+
+	wait_event_timeout(*wq, !mdp_check_mask(mask), HZ);
+
+	spin_lock_irqsave(&mdp_lock, irq_flags);
+	if (mdp_irq_mask & mask) {
+		locked_disable_mdp_irq(mdp, mask);
+		printk(KERN_WARNING "timeout waiting for mdp to complete %x\n",
+		       mask);
+		ret = -ETIMEDOUT;
+	}
+	spin_unlock_irqrestore(&mdp_lock, irq_flags);
+
+	return ret;
+}
+
+void mdp_dma_wait(struct mdp_device *mdp_dev)
+{
+#define MDP_MAX_TIMEOUTS 20
+	static int timeout_count;
+	struct mdp_info *mdp = container_of(mdp_dev, struct mdp_info, mdp_dev);
+
+	if (mdp_wait(mdp, DL0_DMA2_TERM_DONE, &mdp_dma2_waitqueue) == -ETIMEDOUT)
+		timeout_count++;
+	else
+		timeout_count = 0;
+
+	if (timeout_count > MDP_MAX_TIMEOUTS) {
+		printk(KERN_ERR "mdp: dma failed %d times, somethings wrong!\n",
+		       MDP_MAX_TIMEOUTS);
+		BUG();
+	}
+}
+
+static int mdp_ppp_wait(struct mdp_info *mdp)
+{
+	return mdp_wait(mdp, DL0_ROI_DONE, &mdp_ppp_waitqueue);
+}
+
+void mdp_dma_to_mddi(struct mdp_info *mdp, uint32_t addr, uint32_t stride,
+		     uint32_t width, uint32_t height, uint32_t x, uint32_t y,
+		     struct msmfb_callback *callback)
+{
+	uint32_t dma2_cfg;
+	uint16_t ld_param = 0; /* 0=PRIM, 1=SECD, 2=EXT */
+
+	if (enable_mdp_irq(mdp, DL0_DMA2_TERM_DONE)) {
+		printk(KERN_ERR "mdp_dma_to_mddi: busy\n");
+		return;
+	}
+
+	dma_callback = callback;
+
+	dma2_cfg = DMA_PACK_TIGHT |
+		DMA_PACK_ALIGN_LSB |
+		DMA_PACK_PATTERN_RGB |
+		DMA_OUT_SEL_AHB |
+		DMA_IBUF_NONCONTIGUOUS;
+
+	dma2_cfg |= DMA_IBUF_FORMAT_RGB565;
+
+	dma2_cfg |= DMA_OUT_SEL_MDDI;
+
+	dma2_cfg |= DMA_MDDI_DMAOUT_LCD_SEL_PRIMARY;
+
+	dma2_cfg |= DMA_DITHER_EN;
+
+	/* setup size, address, and stride */
+	mdp_writel(mdp, (height << 16) | (width),
+		   MDP_CMD_DEBUG_ACCESS_BASE + 0x0184);
+	mdp_writel(mdp, addr, MDP_CMD_DEBUG_ACCESS_BASE + 0x0188);
+	mdp_writel(mdp, stride, MDP_CMD_DEBUG_ACCESS_BASE + 0x018C);
+
+	/* 666 18BPP */
+	dma2_cfg |= DMA_DSTC0G_6BITS | DMA_DSTC1B_6BITS | DMA_DSTC2R_6BITS;
+
+	/* set y & x offset and MDDI transaction parameters */
+	mdp_writel(mdp, (y << 16) | (x), MDP_CMD_DEBUG_ACCESS_BASE + 0x0194);
+	mdp_writel(mdp, ld_param, MDP_CMD_DEBUG_ACCESS_BASE + 0x01a0);
+	mdp_writel(mdp, (MDDI_VDO_PACKET_DESC << 16) | MDDI_VDO_PACKET_PRIM,
+		   MDP_CMD_DEBUG_ACCESS_BASE + 0x01a4);
+
+	mdp_writel(mdp, dma2_cfg, MDP_CMD_DEBUG_ACCESS_BASE + 0x0180);
+
+	/* start DMA2 */
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0044);
+}
+
+void mdp_dma(struct mdp_device *mdp_dev, uint32_t addr, uint32_t stride,
+	     uint32_t width, uint32_t height, uint32_t x, uint32_t y,
+	     struct msmfb_callback *callback, int interface)
+{
+	struct mdp_info *mdp = container_of(mdp_dev, struct mdp_info, mdp_dev);
+
+	if (interface == MSM_MDDI_PMDH_INTERFACE) {
+		mdp_dma_to_mddi(mdp, addr, stride, width, height, x, y,
+				callback);
+	}
+}
+
+int get_img(struct mdp_img *img, struct fb_info *info,
+	    unsigned long *start, unsigned long *len,
+	    struct file **filep)
+{
+	int put_needed, ret = 0;
+	struct file *file;
+	unsigned long vstart;
+
+#ifdef CONFIG_ANDROID_PMEM
+	if (!get_pmem_file(img->memory_id, start, &vstart, len, filep))
+		return 0;
+#endif
+
+	file = fget_light(img->memory_id, &put_needed);
+	if (file == NULL)
+		return -1;
+
+	if (MAJOR(file->f_dentry->d_inode->i_rdev) == FB_MAJOR) {
+		*start = info->fix.smem_start;
+		*len = info->fix.smem_len;
+	} else
+		ret = -1;
+	fput_light(file, put_needed);
+
+	return ret;
+}
+
+void put_img(struct file *src_file, struct file *dst_file)
+{
+#ifdef CONFIG_ANDROID_PMEM
+	if (src_file)
+		put_pmem_file(src_file);
+	if (dst_file)
+		put_pmem_file(dst_file);
+#endif
+}
+
+int mdp_blit(struct mdp_device *mdp_dev, struct fb_info *fb,
+	     struct mdp_blit_req *req)
+{
+	int ret;
+	unsigned long src_start = 0, src_len = 0, dst_start = 0, dst_len = 0;
+	struct mdp_info *mdp = container_of(mdp_dev, struct mdp_info, mdp_dev);
+	struct file *src_file = 0, *dst_file = 0;
+
+	/* WORKAROUND FOR HARDWARE BUG IN BG TILE FETCH */
+	if (unlikely(req->src_rect.h == 0 ||
+		     req->src_rect.w == 0)) {
+		printk(KERN_ERR "mpd_ppp: src img of zero size!\n");
+		return -EINVAL;
+	}
+	if (unlikely(req->dst_rect.h == 0 ||
+		     req->dst_rect.w == 0))
+		return -EINVAL;
+
+	/* do this first so that if this fails, the caller can always
+	 * safely call put_img */
+	if (unlikely(get_img(&req->src, fb, &src_start, &src_len, &src_file))) {
+		printk(KERN_ERR "mpd_ppp: could not retrieve src image from "
+				"memory\n");
+		return -EINVAL;
+	}
+
+	if (unlikely(get_img(&req->dst, fb, &dst_start, &dst_len, &dst_file))) {
+		printk(KERN_ERR "mpd_ppp: could not retrieve dst image from "
+				"memory\n");
+#ifdef CONFIG_ANDROID_PMEM
+		put_pmem_file(src_file);
+#endif
+		return -EINVAL;
+	}
+	mutex_lock(&mdp_mutex);
+
+	/* transp_masking unimplemented */
+	req->transp_mask = MDP_TRANSP_NOP;
+	if (unlikely((req->transp_mask != MDP_TRANSP_NOP ||
+		      req->alpha != MDP_ALPHA_NOP ||
+		      HAS_ALPHA(req->src.format)) &&
+		     (req->flags & MDP_ROT_90 &&
+		      req->dst_rect.w <= 16 && req->dst_rect.h >= 16))) {
+		int i;
+		unsigned int tiles = req->dst_rect.h / 16;
+		unsigned int remainder = req->dst_rect.h % 16;
+		req->src_rect.w = 16*req->src_rect.w / req->dst_rect.h;
+		req->dst_rect.h = 16;
+		for (i = 0; i < tiles; i++) {
+			enable_mdp_irq(mdp, DL0_ROI_DONE);
+			ret = mdp_ppp_blit(mdp, req, src_file, src_start,
+					   src_len, dst_file, dst_start,
+					   dst_len);
+			if (ret)
+				goto err_bad_blit;
+			ret = mdp_ppp_wait(mdp);
+			if (ret)
+				goto err_wait_failed;
+			req->dst_rect.y += 16;
+			req->src_rect.x += req->src_rect.w;
+		}
+		if (!remainder)
+			goto end;
+		req->src_rect.w = remainder*req->src_rect.w / req->dst_rect.h;
+		req->dst_rect.h = remainder;
+	}
+	enable_mdp_irq(mdp, DL0_ROI_DONE);
+	ret = mdp_ppp_blit(mdp, req, src_file, src_start, src_len, dst_file,
+			   dst_start,
+			   dst_len);
+	if (ret)
+		goto err_bad_blit;
+	ret = mdp_ppp_wait(mdp);
+	if (ret)
+		goto err_wait_failed;
+end:
+	put_img(src_file, dst_file);
+	mutex_unlock(&mdp_mutex);
+	return 0;
+err_bad_blit:
+	disable_mdp_irq(mdp, DL0_ROI_DONE);
+err_wait_failed:
+	put_img(src_file, dst_file);
+	mutex_unlock(&mdp_mutex);
+	return ret;
+}
+
+void mdp_set_grp_disp(struct mdp_device *mdp_dev, unsigned disp_id)
+{
+	struct mdp_info *mdp = container_of(mdp_dev, struct mdp_info, mdp_dev);
+
+	disp_id &= 0xf;
+	mdp_writel(mdp, disp_id, MDP_FULL_BYPASS_WORD43);
+}
+
+int register_mdp_client(struct class_interface *cint)
+{
+	if (!mdp_class) {
+		pr_err("mdp: no mdp_class when registering mdp client\n");
+		return -ENODEV;
+	}
+	cint->class = mdp_class;
+	return class_interface_register(cint);
+}
+
+#include "mdp_csc_table.h"
+#include "mdp_scale_tables.h"
+
+int mdp_probe(struct platform_device *pdev)
+{
+	struct resource *resource;
+	int ret;
+	int n;
+	struct mdp_info *mdp;
+
+	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!resource) {
+		pr_err("mdp: can not get mdp mem resource!\n");
+		return -ENOMEM;
+	}
+
+	mdp = kzalloc(sizeof(struct mdp_info), GFP_KERNEL);
+	if (!mdp)
+		return -ENOMEM;
+
+	mdp->irq = platform_get_irq(pdev, 0);
+	if (mdp->irq < 0) {
+		pr_err("mdp: can not get mdp irq\n");
+		ret = mdp->irq;
+		goto error_get_irq;
+	}
+
+	mdp->base = ioremap(resource->start,
+			    resource->end - resource->start);
+	if (mdp->base == 0) {
+		printk(KERN_ERR "msmfb: cannot allocate mdp regs!\n");
+		ret = -ENOMEM;
+		goto error_ioremap;
+	}
+
+	mdp->mdp_dev.dma = mdp_dma;
+	mdp->mdp_dev.dma_wait = mdp_dma_wait;
+	mdp->mdp_dev.blit = mdp_blit;
+	mdp->mdp_dev.set_grp_disp = mdp_set_grp_disp;
+
+	clk = clk_get(&pdev->dev, "mdp_clk");
+	if (IS_ERR(clk)) {
+		printk(KERN_INFO "mdp: failed to get mdp clk");
+		return PTR_ERR(clk);
+	}
+
+	ret = request_irq(mdp->irq, mdp_isr, IRQF_DISABLED, "msm_mdp", mdp);
+	if (ret)
+		goto error_request_irq;
+	disable_irq(mdp->irq);
+	mdp_irq_mask = 0;
+
+	/* debug interface write access */
+	mdp_writel(mdp, 1, 0x60);
+
+	mdp_writel(mdp, MDP_ANY_INTR_MASK, MDP_INTR_ENABLE);
+	mdp_writel(mdp, 1, MDP_EBI2_PORTMAP_MODE);
+
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01f8);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01fc);
+
+	for (n = 0; n < ARRAY_SIZE(csc_table); n++)
+		mdp_writel(mdp, csc_table[n].val, csc_table[n].reg);
+
+	/* clear up unused fg/main registers */
+	/* comp.plane 2&3 ystride */
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0120);
+
+	/* unpacked pattern */
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x012c);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0130);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0134);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0158);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x015c);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0160);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0170);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0174);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x017c);
+
+	/* comp.plane 2 & 3 */
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0114);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0118);
+
+	/* clear unused bg registers */
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01c8);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01d0);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01dc);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01e0);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01e4);
+
+	for (n = 0; n < ARRAY_SIZE(mdp_upscale_table); n++)
+		mdp_writel(mdp, mdp_upscale_table[n].val,
+		       mdp_upscale_table[n].reg);
+
+	for (n = 0; n < 9; n++)
+		mdp_writel(mdp, mdp_default_ccs[n], 0x40440 + 4 * n);
+	mdp_writel(mdp, mdp_default_ccs[9], 0x40500 + 4 * 0);
+	mdp_writel(mdp, mdp_default_ccs[10], 0x40500 + 4 * 0);
+	mdp_writel(mdp, mdp_default_ccs[11], 0x40500 + 4 * 0);
+
+	/* register mdp device */
+	mdp->mdp_dev.dev.parent = &pdev->dev;
+	mdp->mdp_dev.dev.class = mdp_class;
+	snprintf(mdp->mdp_dev.dev.bus_id, BUS_ID_SIZE, "mdp%d", pdev->id);
+
+	/* if you can remove the platform device you'd have to implement
+	 * this:
+	mdp_dev.release = mdp_class; */
+
+	ret = device_register(&mdp->mdp_dev.dev);
+	if (ret)
+		goto error_device_register;
+	return 0;
+
+error_device_register:
+	free_irq(mdp->irq, mdp);
+error_request_irq:
+	iounmap(mdp->base);
+error_get_irq:
+error_ioremap:
+	kfree(mdp);
+	return ret;
+}
+
+static struct platform_driver msm_mdp_driver = {
+	.probe = mdp_probe,
+	.driver = {.name = "msm_mdp"},
+};
+
+static int __init mdp_init(void)
+{
+	mdp_class = class_create(THIS_MODULE, "msm_mdp");
+	if (IS_ERR(mdp_class)) {
+		printk(KERN_ERR "Error creating mdp class\n");
+		return PTR_ERR(mdp_class);
+	}
+	return platform_driver_register(&msm_mdp_driver);
+}
+
+subsys_initcall(mdp_init);
diff -puN /dev/null drivers/video/msm/mdp_csc_table.h
--- /dev/null
+++ a/drivers/video/msm/mdp_csc_table.h
@@ -0,0 +1,582 @@
+/* drivers/video/msm_fb/mdp_csc_table.h
+ *
+ * Copyright (C) 2007 QUALCOMM Incorporated
+ * Copyright (C) 2007 Google Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+static struct {
+	uint32_t reg;
+	uint32_t val;
+} csc_table[] = {
+	{ 0x40400, 0x83 },
+	{ 0x40404, 0x102 },
+	{ 0x40408, 0x32 },
+	{ 0x4040c, 0xffffffb5 },
+	{ 0x40410, 0xffffff6c },
+	{ 0x40414, 0xe1 },
+	{ 0x40418, 0xe1 },
+	{ 0x4041c, 0xffffff45 },
+	{ 0x40420, 0xffffffdc },
+	{ 0x40440, 0x254 },
+	{ 0x40444, 0x0 },
+	{ 0x40448, 0x331 },
+	{ 0x4044c, 0x254 },
+	{ 0x40450, 0xffffff38 },
+	{ 0x40454, 0xfffffe61 },
+	{ 0x40458, 0x254 },
+	{ 0x4045c, 0x409 },
+	{ 0x40460, 0x0 },
+	{ 0x40480, 0x5d },
+	{ 0x40484, 0x13a },
+	{ 0x40488, 0x20 },
+	{ 0x4048c, 0xffffffcd },
+	{ 0x40490, 0xffffff54 },
+	{ 0x40494, 0xe1 },
+	{ 0x40498, 0xe1 },
+	{ 0x4049c, 0xffffff35 },
+	{ 0x404a0, 0xffffffec },
+	{ 0x404c0, 0x254 },
+	{ 0x404c4, 0x0 },
+	{ 0x404c8, 0x396 },
+	{ 0x404cc, 0x254 },
+	{ 0x404d0, 0xffffff94 },
+	{ 0x404d4, 0xfffffef0 },
+	{ 0x404d8, 0x254 },
+	{ 0x404dc, 0x43a },
+	{ 0x404e0, 0x0 },
+	{ 0x40500, 0x10 },
+	{ 0x40504, 0x80 },
+	{ 0x40508, 0x80 },
+	{ 0x40540, 0x10 },
+	{ 0x40544, 0x80 },
+	{ 0x40548, 0x80 },
+	{ 0x40580, 0x10 },
+	{ 0x40584, 0xeb },
+	{ 0x40588, 0x10 },
+	{ 0x4058c, 0xf0 },
+	{ 0x405c0, 0x10 },
+	{ 0x405c4, 0xeb },
+	{ 0x405c8, 0x10 },
+	{ 0x405cc, 0xf0 },
+	{ 0x40800, 0x0 },
+	{ 0x40804, 0x151515 },
+	{ 0x40808, 0x1d1d1d },
+	{ 0x4080c, 0x232323 },
+	{ 0x40810, 0x272727 },
+	{ 0x40814, 0x2b2b2b },
+	{ 0x40818, 0x2f2f2f },
+	{ 0x4081c, 0x333333 },
+	{ 0x40820, 0x363636 },
+	{ 0x40824, 0x393939 },
+	{ 0x40828, 0x3b3b3b },
+	{ 0x4082c, 0x3e3e3e },
+	{ 0x40830, 0x404040 },
+	{ 0x40834, 0x434343 },
+	{ 0x40838, 0x454545 },
+	{ 0x4083c, 0x474747 },
+	{ 0x40840, 0x494949 },
+	{ 0x40844, 0x4b4b4b },
+	{ 0x40848, 0x4d4d4d },
+	{ 0x4084c, 0x4f4f4f },
+	{ 0x40850, 0x515151 },
+	{ 0x40854, 0x535353 },
+	{ 0x40858, 0x555555 },
+	{ 0x4085c, 0x565656 },
+	{ 0x40860, 0x585858 },
+	{ 0x40864, 0x5a5a5a },
+	{ 0x40868, 0x5b5b5b },
+	{ 0x4086c, 0x5d5d5d },
+	{ 0x40870, 0x5e5e5e },
+	{ 0x40874, 0x606060 },
+	{ 0x40878, 0x616161 },
+	{ 0x4087c, 0x636363 },
+	{ 0x40880, 0x646464 },
+	{ 0x40884, 0x666666 },
+	{ 0x40888, 0x676767 },
+	{ 0x4088c, 0x686868 },
+	{ 0x40890, 0x6a6a6a },
+	{ 0x40894, 0x6b6b6b },
+	{ 0x40898, 0x6c6c6c },
+	{ 0x4089c, 0x6e6e6e },
+	{ 0x408a0, 0x6f6f6f },
+	{ 0x408a4, 0x707070 },
+	{ 0x408a8, 0x717171 },
+	{ 0x408ac, 0x727272 },
+	{ 0x408b0, 0x747474 },
+	{ 0x408b4, 0x757575 },
+	{ 0x408b8, 0x767676 },
+	{ 0x408bc, 0x777777 },
+	{ 0x408c0, 0x787878 },
+	{ 0x408c4, 0x797979 },
+	{ 0x408c8, 0x7a7a7a },
+	{ 0x408cc, 0x7c7c7c },
+	{ 0x408d0, 0x7d7d7d },
+	{ 0x408d4, 0x7e7e7e },
+	{ 0x408d8, 0x7f7f7f },
+	{ 0x408dc, 0x808080 },
+	{ 0x408e0, 0x818181 },
+	{ 0x408e4, 0x828282 },
+	{ 0x408e8, 0x838383 },
+	{ 0x408ec, 0x848484 },
+	{ 0x408f0, 0x858585 },
+	{ 0x408f4, 0x868686 },
+	{ 0x408f8, 0x878787 },
+	{ 0x408fc, 0x888888 },
+	{ 0x40900, 0x898989 },
+	{ 0x40904, 0x8a8a8a },
+	{ 0x40908, 0x8b8b8b },
+	{ 0x4090c, 0x8c8c8c },
+	{ 0x40910, 0x8d8d8d },
+	{ 0x40914, 0x8e8e8e },
+	{ 0x40918, 0x8f8f8f },
+	{ 0x4091c, 0x8f8f8f },
+	{ 0x40920, 0x909090 },
+	{ 0x40924, 0x919191 },
+	{ 0x40928, 0x929292 },
+	{ 0x4092c, 0x939393 },
+	{ 0x40930, 0x949494 },
+	{ 0x40934, 0x959595 },
+	{ 0x40938, 0x969696 },
+	{ 0x4093c, 0x969696 },
+	{ 0x40940, 0x979797 },
+	{ 0x40944, 0x989898 },
+	{ 0x40948, 0x999999 },
+	{ 0x4094c, 0x9a9a9a },
+	{ 0x40950, 0x9b9b9b },
+	{ 0x40954, 0x9c9c9c },
+	{ 0x40958, 0x9c9c9c },
+	{ 0x4095c, 0x9d9d9d },
+	{ 0x40960, 0x9e9e9e },
+	{ 0x40964, 0x9f9f9f },
+	{ 0x40968, 0xa0a0a0 },
+	{ 0x4096c, 0xa0a0a0 },
+	{ 0x40970, 0xa1a1a1 },
+	{ 0x40974, 0xa2a2a2 },
+	{ 0x40978, 0xa3a3a3 },
+	{ 0x4097c, 0xa4a4a4 },
+	{ 0x40980, 0xa4a4a4 },
+	{ 0x40984, 0xa5a5a5 },
+	{ 0x40988, 0xa6a6a6 },
+	{ 0x4098c, 0xa7a7a7 },
+	{ 0x40990, 0xa7a7a7 },
+	{ 0x40994, 0xa8a8a8 },
+	{ 0x40998, 0xa9a9a9 },
+	{ 0x4099c, 0xaaaaaa },
+	{ 0x409a0, 0xaaaaaa },
+	{ 0x409a4, 0xababab },
+	{ 0x409a8, 0xacacac },
+	{ 0x409ac, 0xadadad },
+	{ 0x409b0, 0xadadad },
+	{ 0x409b4, 0xaeaeae },
+	{ 0x409b8, 0xafafaf },
+	{ 0x409bc, 0xafafaf },
+	{ 0x409c0, 0xb0b0b0 },
+	{ 0x409c4, 0xb1b1b1 },
+	{ 0x409c8, 0xb2b2b2 },
+	{ 0x409cc, 0xb2b2b2 },
+	{ 0x409d0, 0xb3b3b3 },
+	{ 0x409d4, 0xb4b4b4 },
+	{ 0x409d8, 0xb4b4b4 },
+	{ 0x409dc, 0xb5b5b5 },
+	{ 0x409e0, 0xb6b6b6 },
+	{ 0x409e4, 0xb6b6b6 },
+	{ 0x409e8, 0xb7b7b7 },
+	{ 0x409ec, 0xb8b8b8 },
+	{ 0x409f0, 0xb8b8b8 },
+	{ 0x409f4, 0xb9b9b9 },
+	{ 0x409f8, 0xbababa },
+	{ 0x409fc, 0xbababa },
+	{ 0x40a00, 0xbbbbbb },
+	{ 0x40a04, 0xbcbcbc },
+	{ 0x40a08, 0xbcbcbc },
+	{ 0x40a0c, 0xbdbdbd },
+	{ 0x40a10, 0xbebebe },
+	{ 0x40a14, 0xbebebe },
+	{ 0x40a18, 0xbfbfbf },
+	{ 0x40a1c, 0xc0c0c0 },
+	{ 0x40a20, 0xc0c0c0 },
+	{ 0x40a24, 0xc1c1c1 },
+	{ 0x40a28, 0xc1c1c1 },
+	{ 0x40a2c, 0xc2c2c2 },
+	{ 0x40a30, 0xc3c3c3 },
+	{ 0x40a34, 0xc3c3c3 },
+	{ 0x40a38, 0xc4c4c4 },
+	{ 0x40a3c, 0xc5c5c5 },
+	{ 0x40a40, 0xc5c5c5 },
+	{ 0x40a44, 0xc6c6c6 },
+	{ 0x40a48, 0xc6c6c6 },
+	{ 0x40a4c, 0xc7c7c7 },
+	{ 0x40a50, 0xc8c8c8 },
+	{ 0x40a54, 0xc8c8c8 },
+	{ 0x40a58, 0xc9c9c9 },
+	{ 0x40a5c, 0xc9c9c9 },
+	{ 0x40a60, 0xcacaca },
+	{ 0x40a64, 0xcbcbcb },
+	{ 0x40a68, 0xcbcbcb },
+	{ 0x40a6c, 0xcccccc },
+	{ 0x40a70, 0xcccccc },
+	{ 0x40a74, 0xcdcdcd },
+	{ 0x40a78, 0xcecece },
+	{ 0x40a7c, 0xcecece },
+	{ 0x40a80, 0xcfcfcf },
+	{ 0x40a84, 0xcfcfcf },
+	{ 0x40a88, 0xd0d0d0 },
+	{ 0x40a8c, 0xd0d0d0 },
+	{ 0x40a90, 0xd1d1d1 },
+	{ 0x40a94, 0xd2d2d2 },
+	{ 0x40a98, 0xd2d2d2 },
+	{ 0x40a9c, 0xd3d3d3 },
+	{ 0x40aa0, 0xd3d3d3 },
+	{ 0x40aa4, 0xd4d4d4 },
+	{ 0x40aa8, 0xd4d4d4 },
+	{ 0x40aac, 0xd5d5d5 },
+	{ 0x40ab0, 0xd6d6d6 },
+	{ 0x40ab4, 0xd6d6d6 },
+	{ 0x40ab8, 0xd7d7d7 },
+	{ 0x40abc, 0xd7d7d7 },
+	{ 0x40ac0, 0xd8d8d8 },
+	{ 0x40ac4, 0xd8d8d8 },
+	{ 0x40ac8, 0xd9d9d9 },
+	{ 0x40acc, 0xd9d9d9 },
+	{ 0x40ad0, 0xdadada },
+	{ 0x40ad4, 0xdbdbdb },
+	{ 0x40ad8, 0xdbdbdb },
+	{ 0x40adc, 0xdcdcdc },
+	{ 0x40ae0, 0xdcdcdc },
+	{ 0x40ae4, 0xdddddd },
+	{ 0x40ae8, 0xdddddd },
+	{ 0x40aec, 0xdedede },
+	{ 0x40af0, 0xdedede },
+	{ 0x40af4, 0xdfdfdf },
+	{ 0x40af8, 0xdfdfdf },
+	{ 0x40afc, 0xe0e0e0 },
+	{ 0x40b00, 0xe0e0e0 },
+	{ 0x40b04, 0xe1e1e1 },
+	{ 0x40b08, 0xe1e1e1 },
+	{ 0x40b0c, 0xe2e2e2 },
+	{ 0x40b10, 0xe3e3e3 },
+	{ 0x40b14, 0xe3e3e3 },
+	{ 0x40b18, 0xe4e4e4 },
+	{ 0x40b1c, 0xe4e4e4 },
+	{ 0x40b20, 0xe5e5e5 },
+	{ 0x40b24, 0xe5e5e5 },
+	{ 0x40b28, 0xe6e6e6 },
+	{ 0x40b2c, 0xe6e6e6 },
+	{ 0x40b30, 0xe7e7e7 },
+	{ 0x40b34, 0xe7e7e7 },
+	{ 0x40b38, 0xe8e8e8 },
+	{ 0x40b3c, 0xe8e8e8 },
+	{ 0x40b40, 0xe9e9e9 },
+	{ 0x40b44, 0xe9e9e9 },
+	{ 0x40b48, 0xeaeaea },
+	{ 0x40b4c, 0xeaeaea },
+	{ 0x40b50, 0xebebeb },
+	{ 0x40b54, 0xebebeb },
+	{ 0x40b58, 0xececec },
+	{ 0x40b5c, 0xececec },
+	{ 0x40b60, 0xededed },
+	{ 0x40b64, 0xededed },
+	{ 0x40b68, 0xeeeeee },
+	{ 0x40b6c, 0xeeeeee },
+	{ 0x40b70, 0xefefef },
+	{ 0x40b74, 0xefefef },
+	{ 0x40b78, 0xf0f0f0 },
+	{ 0x40b7c, 0xf0f0f0 },
+	{ 0x40b80, 0xf1f1f1 },
+	{ 0x40b84, 0xf1f1f1 },
+	{ 0x40b88, 0xf2f2f2 },
+	{ 0x40b8c, 0xf2f2f2 },
+	{ 0x40b90, 0xf2f2f2 },
+	{ 0x40b94, 0xf3f3f3 },
+	{ 0x40b98, 0xf3f3f3 },
+	{ 0x40b9c, 0xf4f4f4 },
+	{ 0x40ba0, 0xf4f4f4 },
+	{ 0x40ba4, 0xf5f5f5 },
+	{ 0x40ba8, 0xf5f5f5 },
+	{ 0x40bac, 0xf6f6f6 },
+	{ 0x40bb0, 0xf6f6f6 },
+	{ 0x40bb4, 0xf7f7f7 },
+	{ 0x40bb8, 0xf7f7f7 },
+	{ 0x40bbc, 0xf8f8f8 },
+	{ 0x40bc0, 0xf8f8f8 },
+	{ 0x40bc4, 0xf9f9f9 },
+	{ 0x40bc8, 0xf9f9f9 },
+	{ 0x40bcc, 0xfafafa },
+	{ 0x40bd0, 0xfafafa },
+	{ 0x40bd4, 0xfafafa },
+	{ 0x40bd8, 0xfbfbfb },
+	{ 0x40bdc, 0xfbfbfb },
+	{ 0x40be0, 0xfcfcfc },
+	{ 0x40be4, 0xfcfcfc },
+	{ 0x40be8, 0xfdfdfd },
+	{ 0x40bec, 0xfdfdfd },
+	{ 0x40bf0, 0xfefefe },
+	{ 0x40bf4, 0xfefefe },
+	{ 0x40bf8, 0xffffff },
+	{ 0x40bfc, 0xffffff },
+	{ 0x40c00, 0x0 },
+	{ 0x40c04, 0x0 },
+	{ 0x40c08, 0x0 },
+	{ 0x40c0c, 0x0 },
+	{ 0x40c10, 0x0 },
+	{ 0x40c14, 0x0 },
+	{ 0x40c18, 0x0 },
+	{ 0x40c1c, 0x0 },
+	{ 0x40c20, 0x0 },
+	{ 0x40c24, 0x0 },
+	{ 0x40c28, 0x0 },
+	{ 0x40c2c, 0x0 },
+	{ 0x40c30, 0x0 },
+	{ 0x40c34, 0x0 },
+	{ 0x40c38, 0x0 },
+	{ 0x40c3c, 0x0 },
+	{ 0x40c40, 0x10101 },
+	{ 0x40c44, 0x10101 },
+	{ 0x40c48, 0x10101 },
+	{ 0x40c4c, 0x10101 },
+	{ 0x40c50, 0x10101 },
+	{ 0x40c54, 0x10101 },
+	{ 0x40c58, 0x10101 },
+	{ 0x40c5c, 0x10101 },
+	{ 0x40c60, 0x10101 },
+	{ 0x40c64, 0x10101 },
+	{ 0x40c68, 0x20202 },
+	{ 0x40c6c, 0x20202 },
+	{ 0x40c70, 0x20202 },
+	{ 0x40c74, 0x20202 },
+	{ 0x40c78, 0x20202 },
+	{ 0x40c7c, 0x20202 },
+	{ 0x40c80, 0x30303 },
+	{ 0x40c84, 0x30303 },
+	{ 0x40c88, 0x30303 },
+	{ 0x40c8c, 0x30303 },
+	{ 0x40c90, 0x30303 },
+	{ 0x40c94, 0x40404 },
+	{ 0x40c98, 0x40404 },
+	{ 0x40c9c, 0x40404 },
+	{ 0x40ca0, 0x40404 },
+	{ 0x40ca4, 0x40404 },
+	{ 0x40ca8, 0x50505 },
+	{ 0x40cac, 0x50505 },
+	{ 0x40cb0, 0x50505 },
+	{ 0x40cb4, 0x50505 },
+	{ 0x40cb8, 0x60606 },
+	{ 0x40cbc, 0x60606 },
+	{ 0x40cc0, 0x60606 },
+	{ 0x40cc4, 0x70707 },
+	{ 0x40cc8, 0x70707 },
+	{ 0x40ccc, 0x70707 },
+	{ 0x40cd0, 0x70707 },
+	{ 0x40cd4, 0x80808 },
+	{ 0x40cd8, 0x80808 },
+	{ 0x40cdc, 0x80808 },
+	{ 0x40ce0, 0x90909 },
+	{ 0x40ce4, 0x90909 },
+	{ 0x40ce8, 0xa0a0a },
+	{ 0x40cec, 0xa0a0a },
+	{ 0x40cf0, 0xa0a0a },
+	{ 0x40cf4, 0xb0b0b },
+	{ 0x40cf8, 0xb0b0b },
+	{ 0x40cfc, 0xb0b0b },
+	{ 0x40d00, 0xc0c0c },
+	{ 0x40d04, 0xc0c0c },
+	{ 0x40d08, 0xd0d0d },
+	{ 0x40d0c, 0xd0d0d },
+	{ 0x40d10, 0xe0e0e },
+	{ 0x40d14, 0xe0e0e },
+	{ 0x40d18, 0xe0e0e },
+	{ 0x40d1c, 0xf0f0f },
+	{ 0x40d20, 0xf0f0f },
+	{ 0x40d24, 0x101010 },
+	{ 0x40d28, 0x101010 },
+	{ 0x40d2c, 0x111111 },
+	{ 0x40d30, 0x111111 },
+	{ 0x40d34, 0x121212 },
+	{ 0x40d38, 0x121212 },
+	{ 0x40d3c, 0x131313 },
+	{ 0x40d40, 0x131313 },
+	{ 0x40d44, 0x141414 },
+	{ 0x40d48, 0x151515 },
+	{ 0x40d4c, 0x151515 },
+	{ 0x40d50, 0x161616 },
+	{ 0x40d54, 0x161616 },
+	{ 0x40d58, 0x171717 },
+	{ 0x40d5c, 0x171717 },
+	{ 0x40d60, 0x181818 },
+	{ 0x40d64, 0x191919 },
+	{ 0x40d68, 0x191919 },
+	{ 0x40d6c, 0x1a1a1a },
+	{ 0x40d70, 0x1b1b1b },
+	{ 0x40d74, 0x1b1b1b },
+	{ 0x40d78, 0x1c1c1c },
+	{ 0x40d7c, 0x1c1c1c },
+	{ 0x40d80, 0x1d1d1d },
+	{ 0x40d84, 0x1e1e1e },
+	{ 0x40d88, 0x1f1f1f },
+	{ 0x40d8c, 0x1f1f1f },
+	{ 0x40d90, 0x202020 },
+	{ 0x40d94, 0x212121 },
+	{ 0x40d98, 0x212121 },
+	{ 0x40d9c, 0x222222 },
+	{ 0x40da0, 0x232323 },
+	{ 0x40da4, 0x242424 },
+	{ 0x40da8, 0x242424 },
+	{ 0x40dac, 0x252525 },
+	{ 0x40db0, 0x262626 },
+	{ 0x40db4, 0x272727 },
+	{ 0x40db8, 0x272727 },
+	{ 0x40dbc, 0x282828 },
+	{ 0x40dc0, 0x292929 },
+	{ 0x40dc4, 0x2a2a2a },
+	{ 0x40dc8, 0x2b2b2b },
+	{ 0x40dcc, 0x2c2c2c },
+	{ 0x40dd0, 0x2c2c2c },
+	{ 0x40dd4, 0x2d2d2d },
+	{ 0x40dd8, 0x2e2e2e },
+	{ 0x40ddc, 0x2f2f2f },
+	{ 0x40de0, 0x303030 },
+	{ 0x40de4, 0x313131 },
+	{ 0x40de8, 0x323232 },
+	{ 0x40dec, 0x333333 },
+	{ 0x40df0, 0x333333 },
+	{ 0x40df4, 0x343434 },
+	{ 0x40df8, 0x353535 },
+	{ 0x40dfc, 0x363636 },
+	{ 0x40e00, 0x373737 },
+	{ 0x40e04, 0x383838 },
+	{ 0x40e08, 0x393939 },
+	{ 0x40e0c, 0x3a3a3a },
+	{ 0x40e10, 0x3b3b3b },
+	{ 0x40e14, 0x3c3c3c },
+	{ 0x40e18, 0x3d3d3d },
+	{ 0x40e1c, 0x3e3e3e },
+	{ 0x40e20, 0x3f3f3f },
+	{ 0x40e24, 0x404040 },
+	{ 0x40e28, 0x414141 },
+	{ 0x40e2c, 0x424242 },
+	{ 0x40e30, 0x434343 },
+	{ 0x40e34, 0x444444 },
+	{ 0x40e38, 0x464646 },
+	{ 0x40e3c, 0x474747 },
+	{ 0x40e40, 0x484848 },
+	{ 0x40e44, 0x494949 },
+	{ 0x40e48, 0x4a4a4a },
+	{ 0x40e4c, 0x4b4b4b },
+	{ 0x40e50, 0x4c4c4c },
+	{ 0x40e54, 0x4d4d4d },
+	{ 0x40e58, 0x4f4f4f },
+	{ 0x40e5c, 0x505050 },
+	{ 0x40e60, 0x515151 },
+	{ 0x40e64, 0x525252 },
+	{ 0x40e68, 0x535353 },
+	{ 0x40e6c, 0x545454 },
+	{ 0x40e70, 0x565656 },
+	{ 0x40e74, 0x575757 },
+	{ 0x40e78, 0x585858 },
+	{ 0x40e7c, 0x595959 },
+	{ 0x40e80, 0x5b5b5b },
+	{ 0x40e84, 0x5c5c5c },
+	{ 0x40e88, 0x5d5d5d },
+	{ 0x40e8c, 0x5e5e5e },
+	{ 0x40e90, 0x606060 },
+	{ 0x40e94, 0x616161 },
+	{ 0x40e98, 0x626262 },
+	{ 0x40e9c, 0x646464 },
+	{ 0x40ea0, 0x656565 },
+	{ 0x40ea4, 0x666666 },
+	{ 0x40ea8, 0x686868 },
+	{ 0x40eac, 0x696969 },
+	{ 0x40eb0, 0x6a6a6a },
+	{ 0x40eb4, 0x6c6c6c },
+	{ 0x40eb8, 0x6d6d6d },
+	{ 0x40ebc, 0x6f6f6f },
+	{ 0x40ec0, 0x707070 },
+	{ 0x40ec4, 0x717171 },
+	{ 0x40ec8, 0x737373 },
+	{ 0x40ecc, 0x747474 },
+	{ 0x40ed0, 0x767676 },
+	{ 0x40ed4, 0x777777 },
+	{ 0x40ed8, 0x797979 },
+	{ 0x40edc, 0x7a7a7a },
+	{ 0x40ee0, 0x7c7c7c },
+	{ 0x40ee4, 0x7d7d7d },
+	{ 0x40ee8, 0x7f7f7f },
+	{ 0x40eec, 0x808080 },
+	{ 0x40ef0, 0x828282 },
+	{ 0x40ef4, 0x838383 },
+	{ 0x40ef8, 0x858585 },
+	{ 0x40efc, 0x868686 },
+	{ 0x40f00, 0x888888 },
+	{ 0x40f04, 0x898989 },
+	{ 0x40f08, 0x8b8b8b },
+	{ 0x40f0c, 0x8d8d8d },
+	{ 0x40f10, 0x8e8e8e },
+	{ 0x40f14, 0x909090 },
+	{ 0x40f18, 0x919191 },
+	{ 0x40f1c, 0x939393 },
+	{ 0x40f20, 0x959595 },
+	{ 0x40f24, 0x969696 },
+	{ 0x40f28, 0x989898 },
+	{ 0x40f2c, 0x9a9a9a },
+	{ 0x40f30, 0x9b9b9b },
+	{ 0x40f34, 0x9d9d9d },
+	{ 0x40f38, 0x9f9f9f },
+	{ 0x40f3c, 0xa1a1a1 },
+	{ 0x40f40, 0xa2a2a2 },
+	{ 0x40f44, 0xa4a4a4 },
+	{ 0x40f48, 0xa6a6a6 },
+	{ 0x40f4c, 0xa7a7a7 },
+	{ 0x40f50, 0xa9a9a9 },
+	{ 0x40f54, 0xababab },
+	{ 0x40f58, 0xadadad },
+	{ 0x40f5c, 0xafafaf },
+	{ 0x40f60, 0xb0b0b0 },
+	{ 0x40f64, 0xb2b2b2 },
+	{ 0x40f68, 0xb4b4b4 },
+	{ 0x40f6c, 0xb6b6b6 },
+	{ 0x40f70, 0xb8b8b8 },
+	{ 0x40f74, 0xbababa },
+	{ 0x40f78, 0xbbbbbb },
+	{ 0x40f7c, 0xbdbdbd },
+	{ 0x40f80, 0xbfbfbf },
+	{ 0x40f84, 0xc1c1c1 },
+	{ 0x40f88, 0xc3c3c3 },
+	{ 0x40f8c, 0xc5c5c5 },
+	{ 0x40f90, 0xc7c7c7 },
+	{ 0x40f94, 0xc9c9c9 },
+	{ 0x40f98, 0xcbcbcb },
+	{ 0x40f9c, 0xcdcdcd },
+	{ 0x40fa0, 0xcfcfcf },
+	{ 0x40fa4, 0xd1d1d1 },
+	{ 0x40fa8, 0xd3d3d3 },
+	{ 0x40fac, 0xd5d5d5 },
+	{ 0x40fb0, 0xd7d7d7 },
+	{ 0x40fb4, 0xd9d9d9 },
+	{ 0x40fb8, 0xdbdbdb },
+	{ 0x40fbc, 0xdddddd },
+	{ 0x40fc0, 0xdfdfdf },
+	{ 0x40fc4, 0xe1e1e1 },
+	{ 0x40fc8, 0xe3e3e3 },
+	{ 0x40fcc, 0xe5e5e5 },
+	{ 0x40fd0, 0xe7e7e7 },
+	{ 0x40fd4, 0xe9e9e9 },
+	{ 0x40fd8, 0xebebeb },
+	{ 0x40fdc, 0xeeeeee },
+	{ 0x40fe0, 0xf0f0f0 },
+	{ 0x40fe4, 0xf2f2f2 },
+	{ 0x40fe8, 0xf4f4f4 },
+	{ 0x40fec, 0xf6f6f6 },
+	{ 0x40ff0, 0xf8f8f8 },
+	{ 0x40ff4, 0xfbfbfb },
+	{ 0x40ff8, 0xfdfdfd },
+	{ 0x40ffc, 0xffffff },
+};
diff -puN /dev/null drivers/video/msm/mdp_hw.h
--- /dev/null
+++ a/drivers/video/msm/mdp_hw.h
@@ -0,0 +1,621 @@
+/* drivers/video/msm_fb/mdp_hw.h
+ *
+ * Copyright (C) 2007 QUALCOMM Incorporated
+ * Copyright (C) 2007 Google Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _MDP_HW_H_
+#define _MDP_HW_H_
+
+#include <mach/msm_iomap.h>
+#include <mach/msm_fb.h>
+
+struct mdp_info {
+	struct mdp_device mdp_dev;
+	char* __iomem base;
+	int irq;
+};
+struct mdp_blit_req;
+struct mdp_device;
+int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
+		 struct file *src_file, unsigned long src_start,
+		 unsigned long src_len, struct file *dst_file,
+		 unsigned long dst_start, unsigned long dst_len);
+#define mdp_writel(mdp, value, offset) writel(value, mdp->base + offset)
+#define mdp_readl(mdp, offset) readl(mdp->base + offset)
+
+#define MDP_SYNC_CONFIG_0                ( 0x00000)
+#define MDP_SYNC_CONFIG_1                ( 0x00004)
+#define MDP_SYNC_CONFIG_2                ( 0x00008)
+#define MDP_SYNC_STATUS_0                ( 0x0000c)
+#define MDP_SYNC_STATUS_1                ( 0x00010)
+#define MDP_SYNC_STATUS_2                ( 0x00014)
+#define MDP_SYNC_THRESH_0                ( 0x00018)
+#define MDP_SYNC_THRESH_1                ( 0x0001c)
+#define MDP_INTR_ENABLE                  ( 0x00020)
+#define MDP_INTR_STATUS                  ( 0x00024)
+#define MDP_INTR_CLEAR                   ( 0x00028)
+#define MDP_DISPLAY0_START               ( 0x00030)
+#define MDP_DISPLAY1_START               ( 0x00034)
+#define MDP_DISPLAY_STATUS               ( 0x00038)
+#define MDP_EBI2_LCD0                    ( 0x0003c)
+#define MDP_EBI2_LCD1                    ( 0x00040)
+#define MDP_DISPLAY0_ADDR                ( 0x00054)
+#define MDP_DISPLAY1_ADDR                ( 0x00058)
+#define MDP_EBI2_PORTMAP_MODE            ( 0x0005c)
+#define MDP_MODE                         ( 0x00060)
+#define MDP_TV_OUT_STATUS                ( 0x00064)
+#define MDP_HW_VERSION                   ( 0x00070)
+#define MDP_SW_RESET                     ( 0x00074)
+#define MDP_AXI_ERROR_MASTER_STOP        ( 0x00078)
+#define MDP_SEL_CLK_OR_HCLK_TEST_BUS     ( 0x0007c)
+#define MDP_PRIMARY_VSYNC_OUT_CTRL       ( 0x00080)
+#define MDP_SECONDARY_VSYNC_OUT_CTRL     ( 0x00084)
+#define MDP_EXTERNAL_VSYNC_OUT_CTRL      ( 0x00088)
+#define MDP_VSYNC_CTRL                   ( 0x0008c)
+#define MDP_CGC_EN                       ( 0x00100)
+#define MDP_CMD_STATUS                   ( 0x10008)
+#define MDP_PROFILE_EN                   ( 0x10010)
+#define MDP_PROFILE_COUNT                ( 0x10014)
+#define MDP_DMA_START                    ( 0x10044)
+#define MDP_FULL_BYPASS_WORD0            ( 0x10100)
+#define MDP_FULL_BYPASS_WORD1            ( 0x10104)
+#define MDP_COMMAND_CONFIG               ( 0x10104)
+#define MDP_FULL_BYPASS_WORD2            ( 0x10108)
+#define MDP_FULL_BYPASS_WORD3            ( 0x1010c)
+#define MDP_FULL_BYPASS_WORD4            ( 0x10110)
+#define MDP_FULL_BYPASS_WORD6            ( 0x10118)
+#define MDP_FULL_BYPASS_WORD7            ( 0x1011c)
+#define MDP_FULL_BYPASS_WORD8            ( 0x10120)
+#define MDP_FULL_BYPASS_WORD9            ( 0x10124)
+#define MDP_PPP_SOURCE_CONFIG            ( 0x10124)
+#define MDP_FULL_BYPASS_WORD10           ( 0x10128)
+#define MDP_FULL_BYPASS_WORD11           ( 0x1012c)
+#define MDP_FULL_BYPASS_WORD12           ( 0x10130)
+#define MDP_FULL_BYPASS_WORD13           ( 0x10134)
+#define MDP_FULL_BYPASS_WORD14           ( 0x10138)
+#define MDP_PPP_OPERATION_CONFIG         ( 0x10138)
+#define MDP_FULL_BYPASS_WORD15           ( 0x1013c)
+#define MDP_FULL_BYPASS_WORD16           ( 0x10140)
+#define MDP_FULL_BYPASS_WORD17           ( 0x10144)
+#define MDP_FULL_BYPASS_WORD18           ( 0x10148)
+#define MDP_FULL_BYPASS_WORD19           ( 0x1014c)
+#define MDP_FULL_BYPASS_WORD20           ( 0x10150)
+#define MDP_PPP_DESTINATION_CONFIG       ( 0x10150)
+#define MDP_FULL_BYPASS_WORD21           ( 0x10154)
+#define MDP_FULL_BYPASS_WORD22           ( 0x10158)
+#define MDP_FULL_BYPASS_WORD23           ( 0x1015c)
+#define MDP_FULL_BYPASS_WORD24           ( 0x10160)
+#define MDP_FULL_BYPASS_WORD25           ( 0x10164)
+#define MDP_FULL_BYPASS_WORD26           ( 0x10168)
+#define MDP_FULL_BYPASS_WORD27           ( 0x1016c)
+#define MDP_FULL_BYPASS_WORD29           ( 0x10174)
+#define MDP_FULL_BYPASS_WORD30           ( 0x10178)
+#define MDP_FULL_BYPASS_WORD31           ( 0x1017c)
+#define MDP_FULL_BYPASS_WORD32           ( 0x10180)
+#define MDP_DMA_CONFIG                   ( 0x10180)
+#define MDP_FULL_BYPASS_WORD33           ( 0x10184)
+#define MDP_FULL_BYPASS_WORD34           ( 0x10188)
+#define MDP_FULL_BYPASS_WORD35           ( 0x1018c)
+#define MDP_FULL_BYPASS_WORD37           ( 0x10194)
+#define MDP_FULL_BYPASS_WORD39           ( 0x1019c)
+#define MDP_FULL_BYPASS_WORD40           ( 0x101a0)
+#define MDP_FULL_BYPASS_WORD41           ( 0x101a4)
+#define MDP_FULL_BYPASS_WORD43           ( 0x101ac)
+#define MDP_FULL_BYPASS_WORD46           ( 0x101b8)
+#define MDP_FULL_BYPASS_WORD47           ( 0x101bc)
+#define MDP_FULL_BYPASS_WORD48           ( 0x101c0)
+#define MDP_FULL_BYPASS_WORD49           ( 0x101c4)
+#define MDP_FULL_BYPASS_WORD50           ( 0x101c8)
+#define MDP_FULL_BYPASS_WORD51           ( 0x101cc)
+#define MDP_FULL_BYPASS_WORD52           ( 0x101d0)
+#define MDP_FULL_BYPASS_WORD53           ( 0x101d4)
+#define MDP_FULL_BYPASS_WORD54           ( 0x101d8)
+#define MDP_FULL_BYPASS_WORD55           ( 0x101dc)
+#define MDP_FULL_BYPASS_WORD56           ( 0x101e0)
+#define MDP_FULL_BYPASS_WORD57           ( 0x101e4)
+#define MDP_FULL_BYPASS_WORD58           ( 0x101e8)
+#define MDP_FULL_BYPASS_WORD59           ( 0x101ec)
+#define MDP_FULL_BYPASS_WORD60           ( 0x101f0)
+#define MDP_VSYNC_THRESHOLD              ( 0x101f0)
+#define MDP_FULL_BYPASS_WORD61           ( 0x101f4)
+#define MDP_FULL_BYPASS_WORD62           ( 0x101f8)
+#define MDP_FULL_BYPASS_WORD63           ( 0x101fc)
+#define MDP_TFETCH_TEST_MODE             ( 0x20004)
+#define MDP_TFETCH_STATUS                ( 0x20008)
+#define MDP_TFETCH_TILE_COUNT            ( 0x20010)
+#define MDP_TFETCH_FETCH_COUNT           ( 0x20014)
+#define MDP_TFETCH_CONSTANT_COLOR        ( 0x20040)
+#define MDP_CSC_BYPASS                   ( 0x40004)
+#define MDP_SCALE_COEFF_LSB              ( 0x5fffc)
+#define MDP_TV_OUT_CTL                   ( 0xc0000)
+#define MDP_TV_OUT_FIR_COEFF             ( 0xc0004)
+#define MDP_TV_OUT_BUF_ADDR              ( 0xc0008)
+#define MDP_TV_OUT_CC_DATA               ( 0xc000c)
+#define MDP_TV_OUT_SOBEL                 ( 0xc0010)
+#define MDP_TV_OUT_Y_CLAMP               ( 0xc0018)
+#define MDP_TV_OUT_CB_CLAMP              ( 0xc001c)
+#define MDP_TV_OUT_CR_CLAMP              ( 0xc0020)
+#define MDP_TEST_MODE_CLK                ( 0xd0000)
+#define MDP_TEST_MISR_RESET_CLK          ( 0xd0004)
+#define MDP_TEST_EXPORT_MISR_CLK         ( 0xd0008)
+#define MDP_TEST_MISR_CURR_VAL_CLK       ( 0xd000c)
+#define MDP_TEST_MODE_HCLK               ( 0xd0100)
+#define MDP_TEST_MISR_RESET_HCLK         ( 0xd0104)
+#define MDP_TEST_EXPORT_MISR_HCLK        ( 0xd0108)
+#define MDP_TEST_MISR_CURR_VAL_HCLK      ( 0xd010c)
+#define MDP_TEST_MODE_DCLK               ( 0xd0200)
+#define MDP_TEST_MISR_RESET_DCLK         ( 0xd0204)
+#define MDP_TEST_EXPORT_MISR_DCLK        ( 0xd0208)
+#define MDP_TEST_MISR_CURR_VAL_DCLK      ( 0xd020c)
+#define MDP_TEST_CAPTURED_DCLK           ( 0xd0210)
+#define MDP_TEST_MISR_CAPT_VAL_DCLK      ( 0xd0214)
+#define MDP_LCDC_CTL                     ( 0xe0000)
+#define MDP_LCDC_HSYNC_CTL               ( 0xe0004)
+#define MDP_LCDC_VSYNC_CTL               ( 0xe0008)
+#define MDP_LCDC_ACTIVE_HCTL             ( 0xe000c)
+#define MDP_LCDC_ACTIVE_VCTL             ( 0xe0010)
+#define MDP_LCDC_BORDER_CLR              ( 0xe0014)
+#define MDP_LCDC_H_BLANK                 ( 0xe0018)
+#define MDP_LCDC_V_BLANK                 ( 0xe001c)
+#define MDP_LCDC_UNDERFLOW_CLR           ( 0xe0020)
+#define MDP_LCDC_HSYNC_SKEW              ( 0xe0024)
+#define MDP_LCDC_TEST_CTL                ( 0xe0028)
+#define MDP_LCDC_LINE_IRQ                ( 0xe002c)
+#define MDP_LCDC_CTL_POLARITY            ( 0xe0030)
+#define MDP_LCDC_DMA_CONFIG              ( 0xe1000)
+#define MDP_LCDC_DMA_SIZE                ( 0xe1004)
+#define MDP_LCDC_DMA_IBUF_ADDR           ( 0xe1008)
+#define MDP_LCDC_DMA_IBUF_Y_STRIDE       ( 0xe100c)
+
+
+#define MDP_DMA2_TERM 0x1
+#define MDP_DMA3_TERM 0x2
+#define MDP_PPP_TERM 0x3
+
+/* MDP_INTR_ENABLE */
+#define DL0_ROI_DONE           (1<<0)
+#define DL1_ROI_DONE           (1<<1)
+#define DL0_DMA2_TERM_DONE     (1<<2)
+#define DL1_DMA2_TERM_DONE     (1<<3)
+#define DL0_PPP_TERM_DONE      (1<<4)
+#define DL1_PPP_TERM_DONE      (1<<5)
+#define TV_OUT_DMA3_DONE       (1<<6)
+#define TV_ENC_UNDERRUN        (1<<7)
+#define DL0_FETCH_DONE         (1<<11)
+#define DL1_FETCH_DONE         (1<<12)
+
+#define MDP_PPP_BUSY_STATUS (DL0_ROI_DONE| \
+			   DL1_ROI_DONE| \
+			   DL0_PPP_TERM_DONE| \
+			   DL1_PPP_TERM_DONE)
+
+#define MDP_ANY_INTR_MASK (DL0_ROI_DONE| \
+			   DL1_ROI_DONE| \
+			   DL0_DMA2_TERM_DONE| \
+			   DL1_DMA2_TERM_DONE| \
+			   DL0_PPP_TERM_DONE| \
+			   DL1_PPP_TERM_DONE| \
+			   DL0_FETCH_DONE| \
+			   DL1_FETCH_DONE| \
+			   TV_ENC_UNDERRUN)
+
+#define MDP_TOP_LUMA       16
+#define MDP_TOP_CHROMA     0
+#define MDP_BOTTOM_LUMA    19
+#define MDP_BOTTOM_CHROMA  3
+#define MDP_LEFT_LUMA      22
+#define MDP_LEFT_CHROMA    6
+#define MDP_RIGHT_LUMA     25
+#define MDP_RIGHT_CHROMA   9
+
+#define CLR_G 0x0
+#define CLR_B 0x1
+#define CLR_R 0x2
+#define CLR_ALPHA 0x3
+
+#define CLR_Y  CLR_G
+#define CLR_CB CLR_B
+#define CLR_CR CLR_R
+
+/* from lsb to msb */
+#define MDP_GET_PACK_PATTERN(a, x, y, z, bit) \
+	(((a)<<(bit*3))|((x)<<(bit*2))|((y)<<bit)|(z))
+
+/* MDP_SYNC_CONFIG_0/1/2 */
+#define MDP_SYNCFG_HGT_LOC 22
+#define MDP_SYNCFG_VSYNC_EXT_EN (1<<21)
+#define MDP_SYNCFG_VSYNC_INT_EN (1<<20)
+
+/* MDP_SYNC_THRESH_0 */
+#define MDP_PRIM_BELOW_LOC 0
+#define MDP_PRIM_ABOVE_LOC 8
+
+/* MDP_{PRIMARY,SECONDARY,EXTERNAL}_VSYNC_OUT_CRL */
+#define VSYNC_PULSE_EN (1<<31)
+#define VSYNC_PULSE_INV (1<<30)
+
+/* MDP_VSYNC_CTRL */
+#define DISP0_VSYNC_MAP_VSYNC0 0
+#define DISP0_VSYNC_MAP_VSYNC1 (1<<0)
+#define DISP0_VSYNC_MAP_VSYNC2 (1<<0)|(1<<1)
+
+#define DISP1_VSYNC_MAP_VSYNC0 0
+#define DISP1_VSYNC_MAP_VSYNC1 (1<<2)
+#define DISP1_VSYNC_MAP_VSYNC2 (1<<2)|(1<<3)
+
+#define PRIMARY_LCD_SYNC_EN (1<<4)
+#define PRIMARY_LCD_SYNC_DISABLE 0
+
+#define SECONDARY_LCD_SYNC_EN (1<<5)
+#define SECONDARY_LCD_SYNC_DISABLE 0
+
+#define EXTERNAL_LCD_SYNC_EN (1<<6)
+#define EXTERNAL_LCD_SYNC_DISABLE 0
+
+/* MDP_VSYNC_THRESHOLD / MDP_FULL_BYPASS_WORD60 */
+#define VSYNC_THRESHOLD_ABOVE_LOC 0
+#define VSYNC_THRESHOLD_BELOW_LOC 16
+#define VSYNC_ANTI_TEAR_EN (1<<31)
+
+/* MDP_COMMAND_CONFIG / MDP_FULL_BYPASS_WORD1 */
+#define MDP_CMD_DBGBUS_EN (1<<0)
+
+/* MDP_PPP_SOURCE_CONFIG / MDP_FULL_BYPASS_WORD9&53 */
+#define PPP_SRC_C0G_8BIT ((1<<1)|(1<<0))
+#define PPP_SRC_C1B_8BIT ((1<<3)|(1<<2))
+#define PPP_SRC_C2R_8BIT ((1<<5)|(1<<4))
+#define PPP_SRC_C3A_8BIT ((1<<7)|(1<<6))
+
+#define PPP_SRC_C0G_6BIT (1<<1)
+#define PPP_SRC_C1B_6BIT (1<<3)
+#define PPP_SRC_C2R_6BIT (1<<5)
+
+#define PPP_SRC_C0G_5BIT (1<<0)
+#define PPP_SRC_C1B_5BIT (1<<2)
+#define PPP_SRC_C2R_5BIT (1<<4)
+
+#define PPP_SRC_C3ALPHA_EN (1<<8)
+
+#define PPP_SRC_BPP_1BYTES 0
+#define PPP_SRC_BPP_2BYTES (1<<9)
+#define PPP_SRC_BPP_3BYTES (1<<10)
+#define PPP_SRC_BPP_4BYTES ((1<<10)|(1<<9))
+
+#define PPP_SRC_BPP_ROI_ODD_X (1<<11)
+#define PPP_SRC_BPP_ROI_ODD_Y (1<<12)
+#define PPP_SRC_INTERLVD_2COMPONENTS (1<<13)
+#define PPP_SRC_INTERLVD_3COMPONENTS (1<<14)
+#define PPP_SRC_INTERLVD_4COMPONENTS ((1<<14)|(1<<13))
+
+
+/* RGB666 unpack format
+** TIGHT means R6+G6+B6 together
+** LOOSE means R6+2 +G6+2+ B6+2 (with MSB)
+**          or 2+R6 +2+G6 +2+B6 (with LSB)
+*/
+#define PPP_SRC_PACK_TIGHT (1<<17)
+#define PPP_SRC_PACK_LOOSE 0
+#define PPP_SRC_PACK_ALIGN_LSB 0
+#define PPP_SRC_PACK_ALIGN_MSB (1<<18)
+
+#define PPP_SRC_PLANE_INTERLVD 0
+#define PPP_SRC_PLANE_PSEUDOPLNR (1<<20)
+
+#define PPP_SRC_WMV9_MODE (1<<21)
+
+/* MDP_PPP_OPERATION_CONFIG / MDP_FULL_BYPASS_WORD14 */
+#define PPP_OP_SCALE_X_ON (1<<0)
+#define PPP_OP_SCALE_Y_ON (1<<1)
+
+#define PPP_OP_CONVERT_RGB2YCBCR 0
+#define PPP_OP_CONVERT_YCBCR2RGB (1<<2)
+#define PPP_OP_CONVERT_ON (1<<3)
+
+#define PPP_OP_CONVERT_MATRIX_PRIMARY 0
+#define PPP_OP_CONVERT_MATRIX_SECONDARY (1<<4)
+
+#define PPP_OP_LUT_C0_ON (1<<5)
+#define PPP_OP_LUT_C1_ON (1<<6)
+#define PPP_OP_LUT_C2_ON (1<<7)
+
+/* rotate or blend enable */
+#define PPP_OP_ROT_ON (1<<8)
+
+#define PPP_OP_ROT_90 (1<<9)
+#define PPP_OP_FLIP_LR (1<<10)
+#define PPP_OP_FLIP_UD (1<<11)
+
+#define PPP_OP_BLEND_ON (1<<12)
+
+#define PPP_OP_BLEND_SRCPIXEL_ALPHA 0
+#define PPP_OP_BLEND_DSTPIXEL_ALPHA (1<<13)
+#define PPP_OP_BLEND_CONSTANT_ALPHA (1<<14)
+#define PPP_OP_BLEND_SRCPIXEL_TRANSP ((1<<13)|(1<<14))
+
+#define PPP_OP_BLEND_ALPHA_BLEND_NORMAL 0
+#define PPP_OP_BLEND_ALPHA_BLEND_REVERSE (1<<15)
+
+#define PPP_OP_DITHER_EN (1<<16)
+
+#define PPP_OP_COLOR_SPACE_RGB 0
+#define PPP_OP_COLOR_SPACE_YCBCR (1<<17)
+
+#define PPP_OP_SRC_CHROMA_RGB 0
+#define PPP_OP_SRC_CHROMA_H2V1 (1<<18)
+#define PPP_OP_SRC_CHROMA_H1V2 (1<<19)
+#define PPP_OP_SRC_CHROMA_420 ((1<<18)|(1<<19))
+#define PPP_OP_SRC_CHROMA_COSITE 0
+#define PPP_OP_SRC_CHROMA_OFFSITE (1<<20)
+
+#define PPP_OP_DST_CHROMA_RGB 0
+#define PPP_OP_DST_CHROMA_H2V1 (1<<21)
+#define PPP_OP_DST_CHROMA_H1V2 (1<<22)
+#define PPP_OP_DST_CHROMA_420 ((1<<21)|(1<<22))
+#define PPP_OP_DST_CHROMA_COSITE 0
+#define PPP_OP_DST_CHROMA_OFFSITE (1<<23)
+
+#define PPP_BLEND_ALPHA_TRANSP (1<<24)
+
+#define PPP_OP_BG_CHROMA_RGB 0
+#define PPP_OP_BG_CHROMA_H2V1 (1<<25)
+#define PPP_OP_BG_CHROMA_H1V2 (1<<26)
+#define PPP_OP_BG_CHROMA_420 (1<<25)|(1<<26)
+#define PPP_OP_BG_CHROMA_SITE_COSITE 0
+#define PPP_OP_BG_CHROMA_SITE_OFFSITE (1<<27)
+
+/* MDP_PPP_DESTINATION_CONFIG / MDP_FULL_BYPASS_WORD20 */
+#define PPP_DST_C0G_8BIT ((1<<0)|(1<<1))
+#define PPP_DST_C1B_8BIT ((1<<3)|(1<<2))
+#define PPP_DST_C2R_8BIT ((1<<5)|(1<<4))
+#define PPP_DST_C3A_8BIT ((1<<7)|(1<<6))
+
+#define PPP_DST_C0G_6BIT (1<<1)
+#define PPP_DST_C1B_6BIT (1<<3)
+#define PPP_DST_C2R_6BIT (1<<5)
+
+#define PPP_DST_C0G_5BIT (1<<0)
+#define PPP_DST_C1B_5BIT (1<<2)
+#define PPP_DST_C2R_5BIT (1<<4)
+
+#define PPP_DST_C3A_8BIT ((1<<7)|(1<<6))
+#define PPP_DST_C3ALPHA_EN (1<<8)
+
+#define PPP_DST_INTERLVD_2COMPONENTS (1<<9)
+#define PPP_DST_INTERLVD_3COMPONENTS (1<<10)
+#define PPP_DST_INTERLVD_4COMPONENTS ((1<<10)|(1<<9))
+#define PPP_DST_INTERLVD_6COMPONENTS ((1<<11)|(1<<9))
+
+#define PPP_DST_PACK_LOOSE 0
+#define PPP_DST_PACK_TIGHT (1<<13)
+#define PPP_DST_PACK_ALIGN_LSB 0
+#define PPP_DST_PACK_ALIGN_MSB (1<<14)
+
+#define PPP_DST_OUT_SEL_AXI 0
+#define PPP_DST_OUT_SEL_MDDI (1<<15)
+
+#define PPP_DST_BPP_2BYTES (1<<16)
+#define PPP_DST_BPP_3BYTES (1<<17)
+#define PPP_DST_BPP_4BYTES ((1<<17)|(1<<16))
+
+#define PPP_DST_PLANE_INTERLVD 0
+#define PPP_DST_PLANE_PLANAR (1<<18)
+#define PPP_DST_PLANE_PSEUDOPLNR (1<<19)
+
+#define PPP_DST_TO_TV (1<<20)
+
+#define PPP_DST_MDDI_PRIMARY 0
+#define PPP_DST_MDDI_SECONDARY (1<<21)
+#define PPP_DST_MDDI_EXTERNAL (1<<22)
+
+/* image configurations by image type */
+#define PPP_CFG_MDP_RGB_565(dir)	PPP_##dir##_C2R_5BIT | \
+					PPP_##dir##_C0G_6BIT | \
+					PPP_##dir##_C1B_5BIT | \
+					PPP_##dir##_BPP_2BYTES | \
+					PPP_##dir##_INTERLVD_3COMPONENTS | \
+					PPP_##dir##_PACK_TIGHT | \
+					PPP_##dir##_PACK_ALIGN_LSB | \
+					PPP_##dir##_PLANE_INTERLVD
+
+#define PPP_CFG_MDP_RGB_888(dir)	PPP_##dir##_C2R_8BIT | \
+					PPP_##dir##_C0G_8BIT | \
+					PPP_##dir##_C1B_8BIT | \
+					PPP_##dir##_BPP_3BYTES | \
+					PPP_##dir##_INTERLVD_3COMPONENTS | \
+					PPP_##dir##_PACK_TIGHT | \
+					PPP_##dir##_PACK_ALIGN_LSB | \
+					PPP_##dir##_PLANE_INTERLVD
+
+#define PPP_CFG_MDP_ARGB_8888(dir)	PPP_##dir##_C2R_8BIT | \
+					PPP_##dir##_C0G_8BIT | \
+					PPP_##dir##_C1B_8BIT | \
+					PPP_##dir##_C3A_8BIT | \
+					PPP_##dir##_C3ALPHA_EN | \
+					PPP_##dir##_BPP_4BYTES | \
+					PPP_##dir##_INTERLVD_4COMPONENTS | \
+					PPP_##dir##_PACK_TIGHT | \
+					PPP_##dir##_PACK_ALIGN_LSB | \
+					PPP_##dir##_PLANE_INTERLVD
+
+#define PPP_CFG_MDP_XRGB_8888(dir) PPP_CFG_MDP_ARGB_8888(dir)
+#define PPP_CFG_MDP_RGBA_8888(dir) PPP_CFG_MDP_ARGB_8888(dir)
+#define PPP_CFG_MDP_BGRA_8888(dir) PPP_CFG_MDP_ARGB_8888(dir)
+
+#define PPP_CFG_MDP_Y_CBCR_H2V2(dir)	PPP_##dir##_C2R_8BIT | \
+					PPP_##dir##_C0G_8BIT | \
+					PPP_##dir##_C1B_8BIT | \
+					PPP_##dir##_C3A_8BIT | \
+					PPP_##dir##_BPP_2BYTES | \
+					PPP_##dir##_INTERLVD_2COMPONENTS | \
+					PPP_##dir##_PACK_TIGHT | \
+					PPP_##dir##_PACK_ALIGN_LSB | \
+					PPP_##dir##_PLANE_PSEUDOPLNR
+
+#define PPP_CFG_MDP_Y_CRCB_H2V2(dir)	PPP_CFG_MDP_Y_CBCR_H2V2(dir)
+
+#define PPP_CFG_MDP_YCRYCB_H2V1(dir)	PPP_##dir##_C2R_8BIT | \
+					PPP_##dir##_C0G_8BIT | \
+					PPP_##dir##_C1B_8BIT | \
+					PPP_##dir##_C3A_8BIT | \
+					PPP_##dir##_BPP_2BYTES | \
+					PPP_##dir##_INTERLVD_4COMPONENTS | \
+					PPP_##dir##_PACK_TIGHT | \
+					PPP_##dir##_PACK_ALIGN_LSB |\
+					PPP_##dir##_PLANE_INTERLVD
+
+#define PPP_CFG_MDP_Y_CBCR_H2V1(dir)	PPP_##dir##_C2R_8BIT | \
+					PPP_##dir##_C0G_8BIT | \
+					PPP_##dir##_C1B_8BIT | \
+					PPP_##dir##_C3A_8BIT | \
+					PPP_##dir##_BPP_2BYTES |   \
+					PPP_##dir##_INTERLVD_2COMPONENTS |  \
+					PPP_##dir##_PACK_TIGHT | \
+					PPP_##dir##_PACK_ALIGN_LSB | \
+					PPP_##dir##_PLANE_PSEUDOPLNR
+
+#define PPP_CFG_MDP_Y_CRCB_H2V1(dir)	PPP_CFG_MDP_Y_CBCR_H2V1(dir)
+
+#define PPP_PACK_PATTERN_MDP_RGB_565 \
+	MDP_GET_PACK_PATTERN(0, CLR_R, CLR_G, CLR_B, 8)
+#define PPP_PACK_PATTERN_MDP_RGB_888 PPP_PACK_PATTERN_MDP_RGB_565
+#define PPP_PACK_PATTERN_MDP_XRGB_8888 \
+	MDP_GET_PACK_PATTERN(CLR_ALPHA, CLR_R, CLR_G, CLR_B, 8)
+#define PPP_PACK_PATTERN_MDP_ARGB_8888 PPP_PACK_PATTERN_MDP_XRGB_8888
+#define PPP_PACK_PATTERN_MDP_RGBA_8888 \
+	MDP_GET_PACK_PATTERN(CLR_ALPHA, CLR_B, CLR_G, CLR_R, 8)
+#define PPP_PACK_PATTERN_MDP_BGRA_8888 \
+	MDP_GET_PACK_PATTERN(CLR_ALPHA, CLR_R, CLR_G, CLR_B, 8)
+#define PPP_PACK_PATTERN_MDP_Y_CBCR_H2V1 \
+	MDP_GET_PACK_PATTERN(0, 0, CLR_CB, CLR_CR, 8)
+#define PPP_PACK_PATTERN_MDP_Y_CBCR_H2V2 PPP_PACK_PATTERN_MDP_Y_CBCR_H2V1
+#define PPP_PACK_PATTERN_MDP_Y_CRCB_H2V1 \
+	MDP_GET_PACK_PATTERN(0, 0, CLR_CR, CLR_CB, 8)
+#define PPP_PACK_PATTERN_MDP_Y_CRCB_H2V2 PPP_PACK_PATTERN_MDP_Y_CRCB_H2V1
+#define PPP_PACK_PATTERN_MDP_YCRYCB_H2V1 \
+	MDP_GET_PACK_PATTERN(CLR_Y, CLR_R, CLR_Y, CLR_B, 8)
+
+#define PPP_CHROMA_SAMP_MDP_RGB_565(dir) PPP_OP_##dir##_CHROMA_RGB
+#define PPP_CHROMA_SAMP_MDP_RGB_888(dir) PPP_OP_##dir##_CHROMA_RGB
+#define PPP_CHROMA_SAMP_MDP_XRGB_8888(dir) PPP_OP_##dir##_CHROMA_RGB
+#define PPP_CHROMA_SAMP_MDP_ARGB_8888(dir) PPP_OP_##dir##_CHROMA_RGB
+#define PPP_CHROMA_SAMP_MDP_RGBA_8888(dir) PPP_OP_##dir##_CHROMA_RGB
+#define PPP_CHROMA_SAMP_MDP_BGRA_8888(dir) PPP_OP_##dir##_CHROMA_RGB
+#define PPP_CHROMA_SAMP_MDP_Y_CBCR_H2V1(dir) PPP_OP_##dir##_CHROMA_H2V1
+#define PPP_CHROMA_SAMP_MDP_Y_CBCR_H2V2(dir) PPP_OP_##dir##_CHROMA_420
+#define PPP_CHROMA_SAMP_MDP_Y_CRCB_H2V1(dir) PPP_OP_##dir##_CHROMA_H2V1
+#define PPP_CHROMA_SAMP_MDP_Y_CRCB_H2V2(dir) PPP_OP_##dir##_CHROMA_420
+#define PPP_CHROMA_SAMP_MDP_YCRYCB_H2V1(dir) PPP_OP_##dir##_CHROMA_H2V1
+
+/* Helpful array generation macros */
+#define PPP_ARRAY0(name) \
+	[MDP_RGB_565] = PPP_##name##_MDP_RGB_565,\
+	[MDP_RGB_888] = PPP_##name##_MDP_RGB_888,\
+	[MDP_XRGB_8888] = PPP_##name##_MDP_XRGB_8888,\
+	[MDP_ARGB_8888] = PPP_##name##_MDP_ARGB_8888,\
+	[MDP_RGBA_8888] = PPP_##name##_MDP_RGBA_8888,\
+	[MDP_BGRA_8888] = PPP_##name##_MDP_BGRA_8888,\
+	[MDP_Y_CBCR_H2V1] = PPP_##name##_MDP_Y_CBCR_H2V1,\
+	[MDP_Y_CBCR_H2V2] = PPP_##name##_MDP_Y_CBCR_H2V2,\
+	[MDP_Y_CRCB_H2V1] = PPP_##name##_MDP_Y_CRCB_H2V1,\
+	[MDP_Y_CRCB_H2V2] = PPP_##name##_MDP_Y_CRCB_H2V2,\
+	[MDP_YCRYCB_H2V1] = PPP_##name##_MDP_YCRYCB_H2V1
+
+#define PPP_ARRAY1(name, dir) \
+	[MDP_RGB_565] = PPP_##name##_MDP_RGB_565(dir),\
+	[MDP_RGB_888] = PPP_##name##_MDP_RGB_888(dir),\
+	[MDP_XRGB_8888] = PPP_##name##_MDP_XRGB_8888(dir),\
+	[MDP_ARGB_8888] = PPP_##name##_MDP_ARGB_8888(dir),\
+	[MDP_RGBA_8888] = PPP_##name##_MDP_RGBA_8888(dir),\
+	[MDP_BGRA_8888] = PPP_##name##_MDP_BGRA_8888(dir),\
+	[MDP_Y_CBCR_H2V1] = PPP_##name##_MDP_Y_CBCR_H2V1(dir),\
+	[MDP_Y_CBCR_H2V2] = PPP_##name##_MDP_Y_CBCR_H2V2(dir),\
+	[MDP_Y_CRCB_H2V1] = PPP_##name##_MDP_Y_CRCB_H2V1(dir),\
+	[MDP_Y_CRCB_H2V2] = PPP_##name##_MDP_Y_CRCB_H2V2(dir),\
+	[MDP_YCRYCB_H2V1] = PPP_##name##_MDP_YCRYCB_H2V1(dir)
+
+#define IS_YCRCB(img) ((img == MDP_Y_CRCB_H2V2) | (img == MDP_Y_CBCR_H2V2) | \
+		       (img == MDP_Y_CRCB_H2V1) | (img == MDP_Y_CBCR_H2V1) | \
+		       (img == MDP_YCRYCB_H2V1))
+#define IS_RGB(img) ((img == MDP_RGB_565) | (img == MDP_RGB_888) | \
+		     (img == MDP_ARGB_8888) | (img == MDP_RGBA_8888) | \
+		     (img == MDP_XRGB_8888) | (img == MDP_BGRA_8888))
+#define HAS_ALPHA(img) ((img == MDP_ARGB_8888) | (img == MDP_RGBA_8888) | \
+		        (img == MDP_BGRA_8888))
+
+#define IS_PSEUDOPLNR(img) ((img == MDP_Y_CRCB_H2V2) | \
+			    (img == MDP_Y_CBCR_H2V2) | \
+			    (img == MDP_Y_CRCB_H2V1) | \
+			    (img == MDP_Y_CBCR_H2V1))
+
+/* Mappings from addr to purpose */
+#define PPP_ADDR_SRC_ROI		MDP_FULL_BYPASS_WORD2
+#define PPP_ADDR_SRC0			MDP_FULL_BYPASS_WORD3
+#define PPP_ADDR_SRC1			MDP_FULL_BYPASS_WORD4
+#define PPP_ADDR_SRC_YSTRIDE		MDP_FULL_BYPASS_WORD7
+#define PPP_ADDR_SRC_CFG		MDP_FULL_BYPASS_WORD9
+#define PPP_ADDR_SRC_PACK_PATTERN	MDP_FULL_BYPASS_WORD10
+#define PPP_ADDR_OPERATION		MDP_FULL_BYPASS_WORD14
+#define PPP_ADDR_PHASEX_INIT		MDP_FULL_BYPASS_WORD15
+#define PPP_ADDR_PHASEY_INIT		MDP_FULL_BYPASS_WORD16
+#define PPP_ADDR_PHASEX_STEP		MDP_FULL_BYPASS_WORD17
+#define PPP_ADDR_PHASEY_STEP		MDP_FULL_BYPASS_WORD18
+#define PPP_ADDR_ALPHA_TRANSP		MDP_FULL_BYPASS_WORD19
+#define PPP_ADDR_DST_CFG		MDP_FULL_BYPASS_WORD20
+#define PPP_ADDR_DST_PACK_PATTERN	MDP_FULL_BYPASS_WORD21
+#define PPP_ADDR_DST_ROI		MDP_FULL_BYPASS_WORD25
+#define PPP_ADDR_DST0			MDP_FULL_BYPASS_WORD26
+#define PPP_ADDR_DST1			MDP_FULL_BYPASS_WORD27
+#define PPP_ADDR_DST_YSTRIDE		MDP_FULL_BYPASS_WORD30
+#define PPP_ADDR_EDGE			MDP_FULL_BYPASS_WORD46
+#define PPP_ADDR_BG0			MDP_FULL_BYPASS_WORD48
+#define PPP_ADDR_BG1			MDP_FULL_BYPASS_WORD49
+#define PPP_ADDR_BG_YSTRIDE		MDP_FULL_BYPASS_WORD51
+#define PPP_ADDR_BG_CFG			MDP_FULL_BYPASS_WORD53
+#define PPP_ADDR_BG_PACK_PATTERN	MDP_FULL_BYPASS_WORD54
+
+/* MDP_DMA_CONFIG / MDP_FULL_BYPASS_WORD32 */
+#define DMA_DSTC0G_6BITS (1<<1)
+#define DMA_DSTC1B_6BITS (1<<3)
+#define DMA_DSTC2R_6BITS (1<<5)
+#define DMA_DSTC0G_5BITS (1<<0)
+#define DMA_DSTC1B_5BITS (1<<2)
+#define DMA_DSTC2R_5BITS (1<<4)
+
+#define DMA_PACK_TIGHT (1<<6)
+#define DMA_PACK_LOOSE 0
+#define DMA_PACK_ALIGN_LSB 0
+#define DMA_PACK_ALIGN_MSB (1<<7)
+#define DMA_PACK_PATTERN_RGB \
+	(MDP_GET_PACK_PATTERN(0, CLR_R, CLR_G, CLR_B, 2)<<8)
+
+#define DMA_OUT_SEL_AHB  0
+#define DMA_OUT_SEL_MDDI (1<<14)
+#define DMA_AHBM_LCD_SEL_PRIMARY 0
+#define DMA_AHBM_LCD_SEL_SECONDARY (1<<15)
+#define DMA_IBUF_C3ALPHA_EN (1<<16)
+#define DMA_DITHER_EN (1<<17)
+
+#define DMA_MDDI_DMAOUT_LCD_SEL_PRIMARY 0
+#define DMA_MDDI_DMAOUT_LCD_SEL_SECONDARY (1<<18)
+#define DMA_MDDI_DMAOUT_LCD_SEL_EXTERNAL (1<<19)
+
+#define DMA_IBUF_FORMAT_RGB565 (1<<20)
+#define DMA_IBUF_FORMAT_RGB888_OR_ARGB8888 0
+
+#define DMA_IBUF_NONCONTIGUOUS (1<<21)
+
+/* MDDI REGISTER ? */
+#define MDDI_VDO_PACKET_DESC  0x5666
+#define MDDI_VDO_PACKET_PRIM  0xC3
+#define MDDI_VDO_PACKET_SECD  0xC0
+
+#endif
diff -puN /dev/null drivers/video/msm/mdp_ppp.c
--- /dev/null
+++ a/drivers/video/msm/mdp_ppp.c
@@ -0,0 +1,750 @@
+/* drivers/video/msm/mdp_ppp.c
+ *
+ * Copyright (C) 2007 QUALCOMM Incorporated
+ * Copyright (C) 2007 Google Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/fb.h>
+#include <linux/file.h>
+#include <linux/delay.h>
+#include <linux/msm_mdp.h>
+#include <linux/android_pmem.h>
+#include <mach/msm_fb.h>
+
+#include "mdp_hw.h"
+#include "mdp_scale_tables.h"
+
+#define DLOG(x...) do {} while (0)
+
+#define MDP_DOWNSCALE_BLUR (MDP_DOWNSCALE_MAX + 1)
+static int downscale_y_table = MDP_DOWNSCALE_MAX;
+static int downscale_x_table = MDP_DOWNSCALE_MAX;
+
+struct mdp_regs {
+	uint32_t src0;
+	uint32_t src1;
+	uint32_t dst0;
+	uint32_t dst1;
+	uint32_t src_cfg;
+	uint32_t dst_cfg;
+	uint32_t src_pack;
+	uint32_t dst_pack;
+	uint32_t src_rect;
+	uint32_t dst_rect;
+	uint32_t src_ystride;
+	uint32_t dst_ystride;
+	uint32_t op;
+	uint32_t src_bpp;
+	uint32_t dst_bpp;
+	uint32_t edge;
+	uint32_t phasex_init;
+	uint32_t phasey_init;
+	uint32_t phasex_step;
+	uint32_t phasey_step;
+};
+
+static uint32_t pack_pattern[] = {
+	PPP_ARRAY0(PACK_PATTERN)
+};
+
+static uint32_t src_img_cfg[] = {
+	PPP_ARRAY1(CFG, SRC)
+};
+
+static uint32_t dst_img_cfg[] = {
+	PPP_ARRAY1(CFG, DST)
+};
+
+static uint32_t bytes_per_pixel[] = {
+	[MDP_RGB_565] = 2,
+	[MDP_RGB_888] = 3,
+	[MDP_XRGB_8888] = 4,
+	[MDP_ARGB_8888] = 4,
+	[MDP_RGBA_8888] = 4,
+	[MDP_BGRA_8888] = 4,
+	[MDP_Y_CBCR_H2V1] = 1,
+	[MDP_Y_CBCR_H2V2] = 1,
+	[MDP_Y_CRCB_H2V1] = 1,
+	[MDP_Y_CRCB_H2V2] = 1,
+	[MDP_YCRYCB_H2V1] = 2
+};
+
+static uint32_t dst_op_chroma[] = {
+	PPP_ARRAY1(CHROMA_SAMP, DST)
+};
+
+static uint32_t src_op_chroma[] = {
+	PPP_ARRAY1(CHROMA_SAMP, SRC)
+};
+
+static uint32_t bg_op_chroma[] = {
+	PPP_ARRAY1(CHROMA_SAMP, BG)
+};
+
+static void rotate_dst_addr_x(struct mdp_blit_req *req, struct mdp_regs *regs)
+{
+	regs->dst0 += (req->dst_rect.w -
+		       min((uint32_t)16, req->dst_rect.w)) * regs->dst_bpp;
+	regs->dst1 += (req->dst_rect.w -
+		       min((uint32_t)16, req->dst_rect.w)) * regs->dst_bpp;
+}
+
+static void rotate_dst_addr_y(struct mdp_blit_req *req, struct mdp_regs *regs)
+{
+	regs->dst0 += (req->dst_rect.h -
+		       min((uint32_t)16, req->dst_rect.h)) *
+		       regs->dst_ystride;
+	regs->dst1 += (req->dst_rect.h -
+		       min((uint32_t)16, req->dst_rect.h)) *
+		       regs->dst_ystride;
+}
+
+static void blit_rotate(struct mdp_blit_req *req,
+			struct mdp_regs *regs)
+{
+	if (req->flags == MDP_ROT_NOP)
+		return;
+
+	regs->op |= PPP_OP_ROT_ON;
+	if ((req->flags & MDP_ROT_90 || req->flags & MDP_FLIP_LR) &&
+	    !(req->flags & MDP_ROT_90 && req->flags & MDP_FLIP_LR))
+		rotate_dst_addr_x(req, regs);
+	if (req->flags & MDP_ROT_90)
+		regs->op |= PPP_OP_ROT_90;
+	if (req->flags & MDP_FLIP_UD) {
+		regs->op |= PPP_OP_FLIP_UD;
+		rotate_dst_addr_y(req, regs);
+	}
+	if (req->flags & MDP_FLIP_LR)
+		regs->op |= PPP_OP_FLIP_LR;
+}
+
+static void blit_convert(struct mdp_blit_req *req, struct mdp_regs *regs)
+{
+	if (req->src.format == req->dst.format)
+		return;
+	if (IS_RGB(req->src.format) && IS_YCRCB(req->dst.format)) {
+		regs->op |= PPP_OP_CONVERT_RGB2YCBCR | PPP_OP_CONVERT_ON;
+	} else if (IS_YCRCB(req->src.format) && IS_RGB(req->dst.format)) {
+		regs->op |= PPP_OP_CONVERT_YCBCR2RGB | PPP_OP_CONVERT_ON;
+		if (req->dst.format == MDP_RGB_565)
+			regs->op |= PPP_OP_CONVERT_MATRIX_SECONDARY;
+	}
+}
+
+#define GET_BIT_RANGE(value, high, low) \
+	(((1 << (high - low + 1)) - 1) & (value >> low))
+static uint32_t transp_convert(struct mdp_blit_req *req)
+{
+	uint32_t transp = 0;
+	if (req->src.format == MDP_RGB_565) {
+		/* pad each value to 8 bits by copying the high bits into the
+		 * low end, convert RGB to RBG by switching low 2 components */
+		transp |= ((GET_BIT_RANGE(req->transp_mask, 15, 11) << 3) |
+			   (GET_BIT_RANGE(req->transp_mask, 15, 13))) << 16;
+
+		transp |= ((GET_BIT_RANGE(req->transp_mask, 4, 0) << 3) |
+			   (GET_BIT_RANGE(req->transp_mask, 4, 2))) << 8;
+
+		transp |= (GET_BIT_RANGE(req->transp_mask, 10, 5) << 2) |
+			  (GET_BIT_RANGE(req->transp_mask, 10, 9));
+	} else {
+		/* convert RGB to RBG */
+		transp |= (GET_BIT_RANGE(req->transp_mask, 15, 8)) |
+			  (GET_BIT_RANGE(req->transp_mask, 23, 16) << 16) |
+			  (GET_BIT_RANGE(req->transp_mask, 7, 0) << 8);
+	}
+	return transp;
+}
+#undef GET_BIT_RANGE
+
+static void blit_blend(struct mdp_blit_req *req, struct mdp_regs *regs)
+{
+	/* TRANSP BLEND */
+	if (req->transp_mask != MDP_TRANSP_NOP) {
+		req->transp_mask = transp_convert(req);
+		if (req->alpha != MDP_ALPHA_NOP) {
+			/* use blended transparancy mode
+			 * pixel = (src == transp) ? dst : blend
+			 * blend is combo of blend_eq_sel and
+			 * blend_alpha_sel */
+			regs->op |= PPP_OP_ROT_ON | PPP_OP_BLEND_ON |
+				PPP_OP_BLEND_ALPHA_BLEND_NORMAL |
+				PPP_OP_BLEND_CONSTANT_ALPHA |
+				PPP_BLEND_ALPHA_TRANSP;
+		} else {
+			/* simple transparancy mode
+			 * pixel = (src == transp) ? dst : src */
+			regs->op |= PPP_OP_ROT_ON | PPP_OP_BLEND_ON |
+				PPP_OP_BLEND_SRCPIXEL_TRANSP;
+		}
+	}
+
+	req->alpha &= 0xff;
+	/* ALPHA BLEND */
+	if (HAS_ALPHA(req->src.format)) {
+		regs->op |= PPP_OP_ROT_ON | PPP_OP_BLEND_ON |
+			PPP_OP_BLEND_SRCPIXEL_ALPHA;
+	} else if (req->alpha < MDP_ALPHA_NOP) {
+		/* just blend by alpha */
+		regs->op |= PPP_OP_ROT_ON | PPP_OP_BLEND_ON |
+			PPP_OP_BLEND_ALPHA_BLEND_NORMAL |
+			PPP_OP_BLEND_CONSTANT_ALPHA;
+	}
+
+	regs->op |= bg_op_chroma[req->dst.format];
+}
+
+#define ONE_HALF	(1LL << 32)
+#define ONE		(1LL << 33)
+#define TWO		(2LL << 33)
+#define THREE		(3LL << 33)
+#define FRAC_MASK (ONE - 1)
+#define INT_MASK (~FRAC_MASK)
+
+static int scale_params(uint32_t dim_in, uint32_t dim_out, uint32_t origin,
+			uint32_t *phase_init, uint32_t *phase_step)
+{
+	/* to improve precicsion calculations are done in U31.33 and converted
+	 * to U3.29 at the end */
+	int64_t k1, k2, k3, k4, tmp;
+	uint64_t n, d, os, os_p, od, od_p, oreq;
+	unsigned rpa = 0;
+	int64_t ip64, delta;
+
+	if (dim_out % 3 == 0)
+		rpa = !(dim_in % (dim_out / 3));
+
+	n = ((uint64_t)dim_out) << 34;
+	d = dim_in;
+	if (!d)
+		return -1;
+	do_div(n, d);
+	k3 = (n + 1) >> 1;
+	if ((k3 >> 4) < (1LL << 27) || (k3 >> 4) > (1LL << 31)) {
+		DLOG("crap bad scale\n");
+		return -1;
+	}
+	n = ((uint64_t)dim_in) << 34;
+	d = (uint64_t)dim_out;
+	if (!d)
+		return -1;
+	do_div(n, d);
+	k1 = (n + 1) >> 1;
+	k2 = (k1 - ONE) >> 1;
+
+	*phase_init = (int)(k2 >> 4);
+	k4 = (k3 - ONE) >> 1;
+
+	if (rpa) {
+		os = ((uint64_t)origin << 33) - ONE_HALF;
+		tmp = (dim_out * os) + ONE_HALF;
+		if (!dim_in)
+			return -1;
+		do_div(tmp, dim_in);
+		od = tmp - ONE_HALF;
+	} else {
+		os = ((uint64_t)origin << 1) - 1;
+		od = (((k3 * os) >> 1) + k4);
+	}
+
+	od_p = od & INT_MASK;
+	if (od_p != od)
+		od_p += ONE;
+
+	if (rpa) {
+		tmp = (dim_in * od_p) + ONE_HALF;
+		if (!dim_in)
+			return -1;
+		do_div(tmp, dim_in);
+		os_p = tmp - ONE_HALF;
+	} else {
+		os_p = ((k1 * (od_p >> 33)) + k2);
+	}
+
+	oreq = (os_p & INT_MASK) - ONE;
+
+	ip64 = os_p - oreq;
+	delta = ((int64_t)(origin) << 33) - oreq;
+	ip64 -= delta;
+	/* limit to valid range before the left shift */
+	delta = (ip64 & (1LL << 63)) ? 4 : -4;
+	delta <<= 33;
+	while (abs((int)(ip64 >> 33)) > 4)
+		ip64 += delta;
+	*phase_init = (int)(ip64 >> 4);
+	*phase_step = (uint32_t)(k1 >> 4);
+	return 0;
+}
+
+static void load_scale_table(const struct mdp_info *mdp,
+			     struct mdp_table_entry *table, int len)
+{
+	int i;
+	for (i = 0; i < len; i++)
+		mdp_writel(mdp, table[i].val, table[i].reg);
+}
+
+enum {
+IMG_LEFT,
+IMG_RIGHT,
+IMG_TOP,
+IMG_BOTTOM,
+};
+
+static void get_edge_info(uint32_t src, uint32_t src_coord, uint32_t dst,
+			  uint32_t *interp1, uint32_t *interp2,
+			  uint32_t *repeat1, uint32_t *repeat2) {
+	if (src > 3 * dst) {
+		*interp1 = 0;
+		*interp2 = src - 1;
+		*repeat1 = 0;
+		*repeat2 = 0;
+	} else if (src == 3 * dst) {
+		*interp1 = 0;
+		*interp2 = src;
+		*repeat1 = 0;
+		*repeat2 = 1;
+	} else if (src > dst && src < 3 * dst) {
+		*interp1 = -1;
+		*interp2 = src;
+		*repeat1 = 1;
+		*repeat2 = 1;
+	} else if (src == dst) {
+		*interp1 = -1;
+		*interp2 = src + 1;
+		*repeat1 = 1;
+		*repeat2 = 2;
+	} else {
+		*interp1 = -2;
+		*interp2 = src + 1;
+		*repeat1 = 2;
+		*repeat2 = 2;
+	}
+	*interp1 += src_coord;
+	*interp2 += src_coord;
+}
+
+static int get_edge_cond(struct mdp_blit_req *req, struct mdp_regs *regs)
+{
+	int32_t luma_interp[4];
+	int32_t luma_repeat[4];
+	int32_t chroma_interp[4];
+	int32_t chroma_bound[4];
+	int32_t chroma_repeat[4];
+	uint32_t dst_w, dst_h;
+
+	memset(&luma_interp, 0, sizeof(int32_t) * 4);
+	memset(&luma_repeat, 0, sizeof(int32_t) * 4);
+	memset(&chroma_interp, 0, sizeof(int32_t) * 4);
+	memset(&chroma_bound, 0, sizeof(int32_t) * 4);
+	memset(&chroma_repeat, 0, sizeof(int32_t) * 4);
+	regs->edge = 0;
+
+	if (req->flags & MDP_ROT_90) {
+		dst_w = req->dst_rect.h;
+		dst_h = req->dst_rect.w;
+	} else {
+		dst_w = req->dst_rect.w;
+		dst_h = req->dst_rect.h;
+	}
+
+	if (regs->op & (PPP_OP_SCALE_Y_ON | PPP_OP_SCALE_X_ON)) {
+		get_edge_info(req->src_rect.h, req->src_rect.y, dst_h,
+			      &luma_interp[IMG_TOP], &luma_interp[IMG_BOTTOM],
+			      &luma_repeat[IMG_TOP], &luma_repeat[IMG_BOTTOM]);
+		get_edge_info(req->src_rect.w, req->src_rect.x, dst_w,
+			      &luma_interp[IMG_LEFT], &luma_interp[IMG_RIGHT],
+			      &luma_repeat[IMG_LEFT], &luma_repeat[IMG_RIGHT]);
+	} else {
+		luma_interp[IMG_LEFT] = req->src_rect.x;
+		luma_interp[IMG_RIGHT] = req->src_rect.x + req->src_rect.w - 1;
+		luma_interp[IMG_TOP] = req->src_rect.y;
+		luma_interp[IMG_BOTTOM] = req->src_rect.y + req->src_rect.h - 1;
+		luma_repeat[IMG_LEFT] = 0;
+		luma_repeat[IMG_TOP] = 0;
+		luma_repeat[IMG_RIGHT] = 0;
+		luma_repeat[IMG_BOTTOM] = 0;
+	}
+
+	chroma_interp[IMG_LEFT] = luma_interp[IMG_LEFT];
+	chroma_interp[IMG_RIGHT] = luma_interp[IMG_RIGHT];
+	chroma_interp[IMG_TOP] = luma_interp[IMG_TOP];
+	chroma_interp[IMG_BOTTOM] = luma_interp[IMG_BOTTOM];
+
+	chroma_bound[IMG_LEFT] = req->src_rect.x;
+	chroma_bound[IMG_RIGHT] = req->src_rect.x + req->src_rect.w - 1;
+	chroma_bound[IMG_TOP] = req->src_rect.y;
+	chroma_bound[IMG_BOTTOM] = req->src_rect.y + req->src_rect.h - 1;
+
+	if (IS_YCRCB(req->src.format)) {
+		chroma_interp[IMG_LEFT] = chroma_interp[IMG_LEFT] >> 1;
+		chroma_interp[IMG_RIGHT] = (chroma_interp[IMG_RIGHT] + 1) >> 1;
+
+		chroma_bound[IMG_LEFT] = chroma_bound[IMG_LEFT] >> 1;
+		chroma_bound[IMG_RIGHT] = chroma_bound[IMG_RIGHT] >> 1;
+	}
+
+	if (req->src.format == MDP_Y_CBCR_H2V2 ||
+	    req->src.format == MDP_Y_CRCB_H2V2) {
+		chroma_interp[IMG_TOP] = (chroma_interp[IMG_TOP] - 1) >> 1;
+		chroma_interp[IMG_BOTTOM] = (chroma_interp[IMG_BOTTOM] + 1)
+					    >> 1;
+		chroma_bound[IMG_TOP] = (chroma_bound[IMG_TOP] + 1) >> 1;
+		chroma_bound[IMG_BOTTOM] = chroma_bound[IMG_BOTTOM] >> 1;
+	}
+
+	chroma_repeat[IMG_LEFT] = chroma_bound[IMG_LEFT] -
+				  chroma_interp[IMG_LEFT];
+	chroma_repeat[IMG_RIGHT] = chroma_interp[IMG_RIGHT] -
+				  chroma_bound[IMG_RIGHT];
+	chroma_repeat[IMG_TOP] = chroma_bound[IMG_TOP] -
+				  chroma_interp[IMG_TOP];
+	chroma_repeat[IMG_BOTTOM] = chroma_interp[IMG_BOTTOM] -
+				  chroma_bound[IMG_BOTTOM];
+
+	if (chroma_repeat[IMG_LEFT] < 0 || chroma_repeat[IMG_LEFT] > 3 ||
+	    chroma_repeat[IMG_RIGHT] < 0 || chroma_repeat[IMG_RIGHT] > 3 ||
+	    chroma_repeat[IMG_TOP] < 0 || chroma_repeat[IMG_TOP] > 3 ||
+	    chroma_repeat[IMG_BOTTOM] < 0 || chroma_repeat[IMG_BOTTOM] > 3 ||
+	    luma_repeat[IMG_LEFT] < 0 || luma_repeat[IMG_LEFT] > 3 ||
+	    luma_repeat[IMG_RIGHT] < 0 || luma_repeat[IMG_RIGHT] > 3 ||
+	    luma_repeat[IMG_TOP] < 0 || luma_repeat[IMG_TOP] > 3 ||
+	    luma_repeat[IMG_BOTTOM] < 0 || luma_repeat[IMG_BOTTOM] > 3)
+		return -1;
+
+	regs->edge |= (chroma_repeat[IMG_LEFT] & 3) << MDP_LEFT_CHROMA;
+	regs->edge |= (chroma_repeat[IMG_RIGHT] & 3) << MDP_RIGHT_CHROMA;
+	regs->edge |= (chroma_repeat[IMG_TOP] & 3) << MDP_TOP_CHROMA;
+	regs->edge |= (chroma_repeat[IMG_BOTTOM] & 3) << MDP_BOTTOM_CHROMA;
+	regs->edge |= (luma_repeat[IMG_LEFT] & 3) << MDP_LEFT_LUMA;
+	regs->edge |= (luma_repeat[IMG_RIGHT] & 3) << MDP_RIGHT_LUMA;
+	regs->edge |= (luma_repeat[IMG_TOP] & 3) << MDP_TOP_LUMA;
+	regs->edge |= (luma_repeat[IMG_BOTTOM] & 3) << MDP_BOTTOM_LUMA;
+	return 0;
+}
+
+static int blit_scale(const struct mdp_info *mdp, struct mdp_blit_req *req,
+		      struct mdp_regs *regs)
+{
+	uint32_t phase_init_x, phase_init_y, phase_step_x, phase_step_y;
+	uint32_t scale_factor_x, scale_factor_y;
+	uint32_t downscale;
+	uint32_t dst_w, dst_h;
+
+	if (req->flags & MDP_ROT_90) {
+		dst_w = req->dst_rect.h;
+		dst_h = req->dst_rect.w;
+	} else {
+		dst_w = req->dst_rect.w;
+		dst_h = req->dst_rect.h;
+	}
+	if ((req->src_rect.w == dst_w)  && (req->src_rect.h == dst_h) &&
+	    !(req->flags & MDP_BLUR)) {
+		regs->phasex_init = 0;
+		regs->phasey_init = 0;
+		regs->phasex_step = 0;
+		regs->phasey_step = 0;
+		return 0;
+	}
+
+	if (scale_params(req->src_rect.w, dst_w, 1, &phase_init_x,
+			 &phase_step_x) ||
+	    scale_params(req->src_rect.h, dst_h, 1, &phase_init_y,
+			 &phase_step_y))
+		return -1;
+
+	scale_factor_x = (dst_w * 10) / req->src_rect.w;
+	scale_factor_y = (dst_h * 10) / req->src_rect.h;
+
+	if (scale_factor_x > 8)
+		downscale = MDP_DOWNSCALE_PT8TO1;
+	else if (scale_factor_x > 6)
+		downscale = MDP_DOWNSCALE_PT6TOPT8;
+	else if (scale_factor_x > 4)
+		downscale = MDP_DOWNSCALE_PT4TOPT6;
+	else
+		downscale = MDP_DOWNSCALE_PT2TOPT4;
+	if (downscale != downscale_x_table) {
+		load_scale_table(mdp, mdp_downscale_x_table[downscale], 64);
+		downscale_x_table = downscale;
+	}
+
+	if (scale_factor_y > 8)
+		downscale = MDP_DOWNSCALE_PT8TO1;
+	else if (scale_factor_y > 6)
+		downscale = MDP_DOWNSCALE_PT6TOPT8;
+	else if (scale_factor_y > 4)
+		downscale = MDP_DOWNSCALE_PT4TOPT6;
+	else
+		downscale = MDP_DOWNSCALE_PT2TOPT4;
+	if (downscale != downscale_y_table) {
+		load_scale_table(mdp, mdp_downscale_y_table[downscale], 64);
+		downscale_y_table = downscale;
+	}
+
+	regs->phasex_init = phase_init_x;
+	regs->phasey_init = phase_init_y;
+	regs->phasex_step = phase_step_x;
+	regs->phasey_step = phase_step_y;
+	regs->op |= (PPP_OP_SCALE_Y_ON | PPP_OP_SCALE_X_ON);
+	return 0;
+
+}
+
+static void blit_blur(const struct mdp_info *mdp, struct mdp_blit_req *req,
+		      struct mdp_regs *regs)
+{
+	if (!(req->flags & MDP_BLUR))
+		return;
+
+	if (!(downscale_x_table == MDP_DOWNSCALE_BLUR &&
+	      downscale_y_table == MDP_DOWNSCALE_BLUR)) {
+		load_scale_table(mdp, mdp_gaussian_blur_table, 128);
+		downscale_x_table = MDP_DOWNSCALE_BLUR;
+		downscale_y_table = MDP_DOWNSCALE_BLUR;
+	}
+
+	regs->op |= (PPP_OP_SCALE_Y_ON | PPP_OP_SCALE_X_ON);
+}
+
+
+#define IMG_LEN(rect_h, w, rect_w, bpp) (((rect_h) * w) * bpp)
+
+#define Y_TO_CRCB_RATIO(format) \
+	((format == MDP_Y_CBCR_H2V2 || format == MDP_Y_CRCB_H2V2) ?  2 :\
+	 (format == MDP_Y_CBCR_H2V1 || format == MDP_Y_CRCB_H2V1) ?  1 : 1)
+
+static void get_len(struct mdp_img *img, struct mdp_rect *rect, uint32_t bpp,
+		    uint32_t *len0, uint32_t *len1)
+{
+	*len0 = IMG_LEN(rect->h, img->width, rect->w, bpp);
+	if (IS_PSEUDOPLNR(img->format))
+		*len1 = *len0/Y_TO_CRCB_RATIO(img->format);
+	else
+		*len1 = 0;
+}
+
+static int valid_src_dst(unsigned long src_start, unsigned long src_len,
+			 unsigned long dst_start, unsigned long dst_len,
+			 struct mdp_blit_req *req, struct mdp_regs *regs)
+{
+	unsigned long src_min_ok = src_start;
+	unsigned long src_max_ok = src_start + src_len;
+	unsigned long dst_min_ok = dst_start;
+	unsigned long dst_max_ok = dst_start + dst_len;
+	uint32_t src0_len, src1_len, dst0_len, dst1_len;
+	get_len(&req->src, &req->src_rect, regs->src_bpp, &src0_len,
+		 &src1_len);
+	get_len(&req->dst, &req->dst_rect, regs->dst_bpp, &dst0_len,
+		 &dst1_len);
+
+	if (regs->src0 < src_min_ok || regs->src0 > src_max_ok ||
+	    regs->src0 + src0_len > src_max_ok) {
+		DLOG("invalid_src %x %x %lx %lx\n", regs->src0,
+		      src0_len, src_min_ok, src_max_ok);
+		return 0;
+	}
+	if (regs->src_cfg & PPP_SRC_PLANE_PSEUDOPLNR) {
+		if (regs->src1 < src_min_ok || regs->src1 > src_max_ok ||
+		    regs->src1 + src1_len > src_max_ok) {
+			DLOG("invalid_src1");
+			return 0;
+		}
+	}
+	if (regs->dst0 < dst_min_ok || regs->dst0 > dst_max_ok ||
+	    regs->dst0 + dst0_len > dst_max_ok) {
+		DLOG("invalid_dst");
+		return 0;
+	}
+	if (regs->dst_cfg & PPP_SRC_PLANE_PSEUDOPLNR) {
+		if (regs->dst1 < dst_min_ok || regs->dst1 > dst_max_ok ||
+		    regs->dst1 + dst1_len > dst_max_ok) {
+			DLOG("invalid_dst1");
+			return 0;
+		}
+	}
+	return 1;
+}
+
+
+static void flush_imgs(struct mdp_blit_req *req, struct mdp_regs *regs,
+		       struct file *src_file, struct file *dst_file)
+{
+#ifdef CONFIG_ANDROID_PMEM
+	uint32_t src0_len, src1_len, dst0_len, dst1_len;
+
+	/* flush src images to memory before dma to mdp */
+	get_len(&req->src, &req->src_rect, regs->src_bpp, &src0_len,
+		&src1_len);
+	flush_pmem_file(src_file, req->src.offset, src0_len);
+	if (IS_PSEUDOPLNR(req->src.format))
+		flush_pmem_file(src_file, req->src.offset + src0_len,
+				src1_len);
+
+	/* flush dst images */
+	get_len(&req->dst, &req->dst_rect, regs->dst_bpp, &dst0_len,
+		&dst1_len);
+	flush_pmem_file(dst_file, req->dst.offset, dst0_len);
+	if (IS_PSEUDOPLNR(req->dst.format))
+		flush_pmem_file(dst_file, req->dst.offset + dst0_len,
+				dst1_len);
+#endif
+}
+
+static void get_chroma_addr(struct mdp_img *img, struct mdp_rect *rect,
+			    uint32_t base, uint32_t bpp, uint32_t cfg,
+			    uint32_t *addr, uint32_t *ystride)
+{
+	uint32_t compress_v = Y_TO_CRCB_RATIO(img->format);
+	uint32_t compress_h = 2;
+	uint32_t  offset;
+
+	if (IS_PSEUDOPLNR(img->format)) {
+		offset = (rect->x / compress_h) * compress_h;
+		offset += rect->y == 0 ? 0 :
+			  ((rect->y + 1) / compress_v) * img->width;
+		*addr = base + (img->width * img->height * bpp);
+		*addr += offset * bpp;
+		*ystride |= *ystride << 16;
+	} else {
+		*addr = 0;
+	}
+}
+
+static int send_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
+		     struct mdp_regs *regs, struct file *src_file,
+		     struct file *dst_file)
+{
+	mdp_writel(mdp, 1, 0x060);
+	mdp_writel(mdp, regs->src_rect, PPP_ADDR_SRC_ROI);
+	mdp_writel(mdp, regs->src0, PPP_ADDR_SRC0);
+	mdp_writel(mdp, regs->src1, PPP_ADDR_SRC1);
+	mdp_writel(mdp, regs->src_ystride, PPP_ADDR_SRC_YSTRIDE);
+	mdp_writel(mdp, regs->src_cfg, PPP_ADDR_SRC_CFG);
+	mdp_writel(mdp, regs->src_pack, PPP_ADDR_SRC_PACK_PATTERN);
+
+	mdp_writel(mdp, regs->op, PPP_ADDR_OPERATION);
+	mdp_writel(mdp, regs->phasex_init, PPP_ADDR_PHASEX_INIT);
+	mdp_writel(mdp, regs->phasey_init, PPP_ADDR_PHASEY_INIT);
+	mdp_writel(mdp, regs->phasex_step, PPP_ADDR_PHASEX_STEP);
+	mdp_writel(mdp, regs->phasey_step, PPP_ADDR_PHASEY_STEP);
+
+	mdp_writel(mdp, (req->alpha << 24) | (req->transp_mask & 0xffffff),
+	       PPP_ADDR_ALPHA_TRANSP);
+
+	mdp_writel(mdp, regs->dst_cfg, PPP_ADDR_DST_CFG);
+	mdp_writel(mdp, regs->dst_pack, PPP_ADDR_DST_PACK_PATTERN);
+	mdp_writel(mdp, regs->dst_rect, PPP_ADDR_DST_ROI);
+	mdp_writel(mdp, regs->dst0, PPP_ADDR_DST0);
+	mdp_writel(mdp, regs->dst1, PPP_ADDR_DST1);
+	mdp_writel(mdp, regs->dst_ystride, PPP_ADDR_DST_YSTRIDE);
+
+	mdp_writel(mdp, regs->edge, PPP_ADDR_EDGE);
+	if (regs->op & PPP_OP_BLEND_ON) {
+		mdp_writel(mdp, regs->dst0, PPP_ADDR_BG0);
+		mdp_writel(mdp, regs->dst1, PPP_ADDR_BG1);
+		mdp_writel(mdp, regs->dst_ystride, PPP_ADDR_BG_YSTRIDE);
+		mdp_writel(mdp, src_img_cfg[req->dst.format], PPP_ADDR_BG_CFG);
+		mdp_writel(mdp, pack_pattern[req->dst.format],
+			   PPP_ADDR_BG_PACK_PATTERN);
+	}
+	flush_imgs(req, regs, src_file, dst_file);
+	mdp_writel(mdp, 0x1000, MDP_DISPLAY0_START);
+	return 0;
+}
+
+int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
+		 struct file *src_file, unsigned long src_start, unsigned long src_len,
+		 struct file *dst_file, unsigned long dst_start, unsigned long dst_len)
+{
+	struct mdp_regs regs = {0};
+
+	if (unlikely(req->src.format >= MDP_IMGTYPE_LIMIT ||
+		     req->dst.format >= MDP_IMGTYPE_LIMIT)) {
+		printk(KERN_ERR "mpd_ppp: img is of wrong format\n");
+		return -EINVAL;
+	}
+
+	if (unlikely(req->src_rect.x > req->src.width ||
+		     req->src_rect.y > req->src.height ||
+		     req->dst_rect.x > req->dst.width ||
+		     req->dst_rect.y > req->dst.height)) {
+		printk(KERN_ERR "mpd_ppp: img rect is outside of img!\n");
+		return -EINVAL;
+	}
+
+	/* set the src image configuration */
+	regs.src_cfg = src_img_cfg[req->src.format];
+	regs.src_cfg |= (req->src_rect.x & 0x1) ? PPP_SRC_BPP_ROI_ODD_X : 0;
+	regs.src_cfg |= (req->src_rect.y & 0x1) ? PPP_SRC_BPP_ROI_ODD_Y : 0;
+	regs.src_rect = (req->src_rect.h << 16) | req->src_rect.w;
+	regs.src_pack = pack_pattern[req->src.format];
+
+	/* set the dest image configuration */
+	regs.dst_cfg = dst_img_cfg[req->dst.format] | PPP_DST_OUT_SEL_AXI;
+	regs.dst_rect = (req->dst_rect.h << 16) | req->dst_rect.w;
+	regs.dst_pack = pack_pattern[req->dst.format];
+
+	/* set src, bpp, start pixel and ystride */
+	regs.src_bpp = bytes_per_pixel[req->src.format];
+	regs.src0 = src_start + req->src.offset;
+	regs.src_ystride = req->src.width * regs.src_bpp;
+	get_chroma_addr(&req->src, &req->src_rect, regs.src0, regs.src_bpp,
+			regs.src_cfg, &regs.src1, &regs.src_ystride);
+	regs.src0 += (req->src_rect.x + (req->src_rect.y * req->src.width)) *
+		      regs.src_bpp;
+
+	/* set dst, bpp, start pixel and ystride */
+	regs.dst_bpp = bytes_per_pixel[req->dst.format];
+	regs.dst0 = dst_start + req->dst.offset;
+	regs.dst_ystride = req->dst.width * regs.dst_bpp;
+	get_chroma_addr(&req->dst, &req->dst_rect, regs.dst0, regs.dst_bpp,
+			regs.dst_cfg, &regs.dst1, &regs.dst_ystride);
+	regs.dst0 += (req->dst_rect.x + (req->dst_rect.y * req->dst.width)) *
+		      regs.dst_bpp;
+
+	if (!valid_src_dst(src_start, src_len, dst_start, dst_len, req,
+			   &regs)) {
+		printk(KERN_ERR "mpd_ppp: final src or dst location is "
+			"invalid, are you trying to make an image too large "
+			"or to place it outside the screen?\n");
+		return -EINVAL;
+	}
+
+	/* set up operation register */
+	regs.op = 0;
+	blit_rotate(req, &regs);
+	blit_convert(req, &regs);
+	if (req->flags & MDP_DITHER)
+		regs.op |= PPP_OP_DITHER_EN;
+	blit_blend(req, &regs);
+	if (blit_scale(mdp, req, &regs)) {
+		printk(KERN_ERR "mpd_ppp: error computing scale for img.\n");
+		return -EINVAL;
+	}
+	blit_blur(mdp, req, &regs);
+	regs.op |= dst_op_chroma[req->dst.format] |
+		   src_op_chroma[req->src.format];
+
+	/* if the image is YCRYCB, the x and w must be even */
+	if (unlikely(req->src.format == MDP_YCRYCB_H2V1)) {
+		req->src_rect.x = req->src_rect.x & (~0x1);
+		req->src_rect.w = req->src_rect.w & (~0x1);
+		req->dst_rect.x = req->dst_rect.x & (~0x1);
+		req->dst_rect.w = req->dst_rect.w & (~0x1);
+	}
+	if (get_edge_cond(req, &regs))
+		return -EINVAL;
+
+	send_blit(mdp, req, &regs, src_file, dst_file);
+	return 0;
+}
diff -puN /dev/null drivers/video/msm/mdp_scale_tables.c
--- /dev/null
+++ a/drivers/video/msm/mdp_scale_tables.c
@@ -0,0 +1,766 @@
+/* drivers/video/msm_fb/mdp_scale_tables.c
+ *
+ * Copyright (C) 2007 QUALCOMM Incorporated
+ * Copyright (C) 2007 Google Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "mdp_scale_tables.h"
+#include "mdp_hw.h"
+
+struct mdp_table_entry mdp_upscale_table[] = {
+	{ 0x5fffc, 0x0 },
+	{ 0x50200, 0x7fc00000 },
+	{ 0x5fffc, 0xff80000d },
+	{ 0x50204, 0x7ec003f9 },
+	{ 0x5fffc, 0xfec0001c },
+	{ 0x50208, 0x7d4003f3 },
+	{ 0x5fffc, 0xfe40002b },
+	{ 0x5020c, 0x7b8003ed },
+	{ 0x5fffc, 0xfd80003c },
+	{ 0x50210, 0x794003e8 },
+	{ 0x5fffc, 0xfcc0004d },
+	{ 0x50214, 0x76c003e4 },
+	{ 0x5fffc, 0xfc40005f },
+	{ 0x50218, 0x73c003e0 },
+	{ 0x5fffc, 0xfb800071 },
+	{ 0x5021c, 0x708003de },
+	{ 0x5fffc, 0xfac00085 },
+	{ 0x50220, 0x6d0003db },
+	{ 0x5fffc, 0xfa000098 },
+	{ 0x50224, 0x698003d9 },
+	{ 0x5fffc, 0xf98000ac },
+	{ 0x50228, 0x654003d8 },
+	{ 0x5fffc, 0xf8c000c1 },
+	{ 0x5022c, 0x610003d7 },
+	{ 0x5fffc, 0xf84000d5 },
+	{ 0x50230, 0x5c8003d7 },
+	{ 0x5fffc, 0xf7c000e9 },
+	{ 0x50234, 0x580003d7 },
+	{ 0x5fffc, 0xf74000fd },
+	{ 0x50238, 0x534003d8 },
+	{ 0x5fffc, 0xf6c00112 },
+	{ 0x5023c, 0x4e8003d8 },
+	{ 0x5fffc, 0xf6800126 },
+	{ 0x50240, 0x494003da },
+	{ 0x5fffc, 0xf600013a },
+	{ 0x50244, 0x448003db },
+	{ 0x5fffc, 0xf600014d },
+	{ 0x50248, 0x3f4003dd },
+	{ 0x5fffc, 0xf5c00160 },
+	{ 0x5024c, 0x3a4003df },
+	{ 0x5fffc, 0xf5c00172 },
+	{ 0x50250, 0x354003e1 },
+	{ 0x5fffc, 0xf5c00184 },
+	{ 0x50254, 0x304003e3 },
+	{ 0x5fffc, 0xf6000195 },
+	{ 0x50258, 0x2b0003e6 },
+	{ 0x5fffc, 0xf64001a6 },
+	{ 0x5025c, 0x260003e8 },
+	{ 0x5fffc, 0xf6c001b4 },
+	{ 0x50260, 0x214003eb },
+	{ 0x5fffc, 0xf78001c2 },
+	{ 0x50264, 0x1c4003ee },
+	{ 0x5fffc, 0xf80001cf },
+	{ 0x50268, 0x17c003f1 },
+	{ 0x5fffc, 0xf90001db },
+	{ 0x5026c, 0x134003f3 },
+	{ 0x5fffc, 0xfa0001e5 },
+	{ 0x50270, 0xf0003f6 },
+	{ 0x5fffc, 0xfb4001ee },
+	{ 0x50274, 0xac003f9 },
+	{ 0x5fffc, 0xfcc001f5 },
+	{ 0x50278, 0x70003fb },
+	{ 0x5fffc, 0xfe4001fb },
+	{ 0x5027c, 0x34003fe },
+};
+
+static struct mdp_table_entry mdp_downscale_x_table_PT2TOPT4[] = {
+	{ 0x5fffc, 0x740008c },
+	{ 0x50280, 0x33800088 },
+	{ 0x5fffc, 0x800008e },
+	{ 0x50284, 0x33400084 },
+	{ 0x5fffc, 0x8400092 },
+	{ 0x50288, 0x33000080 },
+	{ 0x5fffc, 0x9000094 },
+	{ 0x5028c, 0x3300007b },
+	{ 0x5fffc, 0x9c00098 },
+	{ 0x50290, 0x32400077 },
+	{ 0x5fffc, 0xa40009b },
+	{ 0x50294, 0x32000073 },
+	{ 0x5fffc, 0xb00009d },
+	{ 0x50298,  0x31c0006f },
+	{ 0x5fffc,  0xbc000a0 },
+	{ 0x5029c,  0x3140006b },
+	{ 0x5fffc,  0xc8000a2 },
+	{ 0x502a0,  0x31000067 },
+	{ 0x5fffc,  0xd8000a5 },
+	{ 0x502a4,  0x30800062 },
+	{ 0x5fffc,  0xe4000a8 },
+	{ 0x502a8,  0x2fc0005f },
+	{ 0x5fffc,  0xec000aa },
+	{ 0x502ac,  0x2fc0005b },
+	{ 0x5fffc,  0xf8000ad },
+	{ 0x502b0,  0x2f400057 },
+	{ 0x5fffc,  0x108000b0 },
+	{ 0x502b4,  0x2e400054 },
+	{ 0x5fffc,  0x114000b2 },
+	{ 0x502b8,  0x2e000050 },
+	{ 0x5fffc,  0x124000b4 },
+	{ 0x502bc,  0x2d80004c },
+	{ 0x5fffc,  0x130000b6 },
+	{ 0x502c0,  0x2d000049 },
+	{ 0x5fffc,  0x140000b8 },
+	{ 0x502c4,  0x2c800045 },
+	{ 0x5fffc,  0x150000b9 },
+	{ 0x502c8,  0x2c000042 },
+	{ 0x5fffc,  0x15c000bd },
+	{ 0x502cc,  0x2b40003e },
+	{ 0x5fffc,  0x16c000bf },
+	{ 0x502d0,  0x2a80003b },
+	{ 0x5fffc,  0x17c000bf },
+	{ 0x502d4,  0x2a000039 },
+	{ 0x5fffc,  0x188000c2 },
+	{ 0x502d8,  0x29400036 },
+	{ 0x5fffc,  0x19c000c4 },
+	{ 0x502dc,  0x28800032 },
+	{ 0x5fffc,  0x1ac000c5 },
+	{ 0x502e0,  0x2800002f },
+	{ 0x5fffc,  0x1bc000c7 },
+	{ 0x502e4,  0x2740002c },
+	{ 0x5fffc,  0x1cc000c8 },
+	{ 0x502e8,  0x26c00029 },
+	{ 0x5fffc,  0x1dc000c9 },
+	{ 0x502ec,  0x26000027 },
+	{ 0x5fffc,  0x1ec000cc },
+	{ 0x502f0,  0x25000024 },
+	{ 0x5fffc,  0x200000cc },
+	{ 0x502f4,  0x24800021 },
+	{ 0x5fffc,  0x210000cd },
+	{ 0x502f8,  0x23800020 },
+	{ 0x5fffc,  0x220000ce },
+	{ 0x502fc,  0x2300001d },
+};
+
+static struct mdp_table_entry mdp_downscale_x_table_PT4TOPT6[] = {
+	{ 0x5fffc,  0x740008c },
+	{ 0x50280,  0x33800088 },
+	{ 0x5fffc,  0x800008e },
+	{ 0x50284,  0x33400084 },
+	{ 0x5fffc,  0x8400092 },
+	{ 0x50288,  0x33000080 },
+	{ 0x5fffc,  0x9000094 },
+	{ 0x5028c,  0x3300007b },
+	{ 0x5fffc,  0x9c00098 },
+	{ 0x50290,  0x32400077 },
+	{ 0x5fffc,  0xa40009b },
+	{ 0x50294,  0x32000073 },
+	{ 0x5fffc,  0xb00009d },
+	{ 0x50298,  0x31c0006f },
+	{ 0x5fffc,  0xbc000a0 },
+	{ 0x5029c,  0x3140006b },
+	{ 0x5fffc,  0xc8000a2 },
+	{ 0x502a0,  0x31000067 },
+	{ 0x5fffc,  0xd8000a5 },
+	{ 0x502a4,  0x30800062 },
+	{ 0x5fffc,  0xe4000a8 },
+	{ 0x502a8,  0x2fc0005f },
+	{ 0x5fffc,  0xec000aa },
+	{ 0x502ac,  0x2fc0005b },
+	{ 0x5fffc,  0xf8000ad },
+	{ 0x502b0,  0x2f400057 },
+	{ 0x5fffc,  0x108000b0 },
+	{ 0x502b4,  0x2e400054 },
+	{ 0x5fffc,  0x114000b2 },
+	{ 0x502b8,  0x2e000050 },
+	{ 0x5fffc,  0x124000b4 },
+	{ 0x502bc,  0x2d80004c },
+	{ 0x5fffc,  0x130000b6 },
+	{ 0x502c0,  0x2d000049 },
+	{ 0x5fffc,  0x140000b8 },
+	{ 0x502c4,  0x2c800045 },
+	{ 0x5fffc,  0x150000b9 },
+	{ 0x502c8,  0x2c000042 },
+	{ 0x5fffc,  0x15c000bd },
+	{ 0x502cc,  0x2b40003e },
+	{ 0x5fffc,  0x16c000bf },
+	{ 0x502d0,  0x2a80003b },
+	{ 0x5fffc,  0x17c000bf },
+	{ 0x502d4,  0x2a000039 },
+	{ 0x5fffc,  0x188000c2 },
+	{ 0x502d8,  0x29400036 },
+	{ 0x5fffc,  0x19c000c4 },
+	{ 0x502dc,  0x28800032 },
+	{ 0x5fffc,  0x1ac000c5 },
+	{ 0x502e0,  0x2800002f },
+	{ 0x5fffc,  0x1bc000c7 },
+	{ 0x502e4,  0x2740002c },
+	{ 0x5fffc,  0x1cc000c8 },
+	{ 0x502e8,  0x26c00029 },
+	{ 0x5fffc,  0x1dc000c9 },
+	{ 0x502ec,  0x26000027 },
+	{ 0x5fffc,  0x1ec000cc },
+	{ 0x502f0,  0x25000024 },
+	{ 0x5fffc,  0x200000cc },
+	{ 0x502f4,  0x24800021 },
+	{ 0x5fffc,  0x210000cd },
+	{ 0x502f8,  0x23800020 },
+	{ 0x5fffc,  0x220000ce },
+	{ 0x502fc,  0x2300001d },
+};
+
+static struct mdp_table_entry mdp_downscale_x_table_PT6TOPT8[] = {
+	{ 0x5fffc,  0xfe000070 },
+	{ 0x50280,  0x4bc00068 },
+	{ 0x5fffc,  0xfe000078 },
+	{ 0x50284,  0x4bc00060 },
+	{ 0x5fffc,  0xfe000080 },
+	{ 0x50288,  0x4b800059 },
+	{ 0x5fffc,  0xfe000089 },
+	{ 0x5028c,  0x4b000052 },
+	{ 0x5fffc,  0xfe400091 },
+	{ 0x50290,  0x4a80004b },
+	{ 0x5fffc,  0xfe40009a },
+	{ 0x50294,  0x4a000044 },
+	{ 0x5fffc,  0xfe8000a3 },
+	{ 0x50298,  0x4940003d },
+	{ 0x5fffc,  0xfec000ac },
+	{ 0x5029c,  0x48400037 },
+	{ 0x5fffc,  0xff0000b4 },
+	{ 0x502a0,  0x47800031 },
+	{ 0x5fffc,  0xff8000bd },
+	{ 0x502a4,  0x4640002b },
+	{ 0x5fffc,  0xc5 },
+	{ 0x502a8,  0x45000026 },
+	{ 0x5fffc,  0x8000ce },
+	{ 0x502ac,  0x43800021 },
+	{ 0x5fffc,  0x10000d6 },
+	{ 0x502b0,  0x4240001c },
+	{ 0x5fffc,  0x18000df },
+	{ 0x502b4,  0x40800018 },
+	{ 0x5fffc,  0x24000e6 },
+	{ 0x502b8,  0x3f000014 },
+	{ 0x5fffc,  0x30000ee },
+	{ 0x502bc,  0x3d400010 },
+	{ 0x5fffc,  0x40000f5 },
+	{ 0x502c0,  0x3b80000c },
+	{ 0x5fffc,  0x50000fc },
+	{ 0x502c4,  0x39800009 },
+	{ 0x5fffc,  0x6000102 },
+	{ 0x502c8,  0x37c00006 },
+	{ 0x5fffc,  0x7000109 },
+	{ 0x502cc,  0x35800004 },
+	{ 0x5fffc,  0x840010e },
+	{ 0x502d0,  0x33800002 },
+	{ 0x5fffc,  0x9800114 },
+	{ 0x502d4,  0x31400000 },
+	{ 0x5fffc,  0xac00119 },
+	{ 0x502d8,  0x2f4003fe },
+	{ 0x5fffc,  0xc40011e },
+	{ 0x502dc,  0x2d0003fc },
+	{ 0x5fffc,  0xdc00121 },
+	{ 0x502e0,  0x2b0003fb },
+	{ 0x5fffc,  0xf400125 },
+	{ 0x502e4,  0x28c003fa },
+	{ 0x5fffc,  0x11000128 },
+	{ 0x502e8,  0x268003f9 },
+	{ 0x5fffc,  0x12c0012a },
+	{ 0x502ec,  0x244003f9 },
+	{ 0x5fffc,  0x1480012c },
+	{ 0x502f0,  0x224003f8 },
+	{ 0x5fffc,  0x1640012e },
+	{ 0x502f4,  0x200003f8 },
+	{ 0x5fffc,  0x1800012f },
+	{ 0x502f8,  0x1e0003f8 },
+	{ 0x5fffc,  0x1a00012f },
+	{ 0x502fc,  0x1c0003f8 },
+};
+
+static struct mdp_table_entry mdp_downscale_x_table_PT8TO1[] = {
+	{ 0x5fffc,  0x0 },
+	{ 0x50280,  0x7fc00000 },
+	{ 0x5fffc,  0xff80000d },
+	{ 0x50284,  0x7ec003f9 },
+	{ 0x5fffc,  0xfec0001c },
+	{ 0x50288,  0x7d4003f3 },
+	{ 0x5fffc,  0xfe40002b },
+	{ 0x5028c,  0x7b8003ed },
+	{ 0x5fffc,  0xfd80003c },
+	{ 0x50290,  0x794003e8 },
+	{ 0x5fffc,  0xfcc0004d },
+	{ 0x50294,  0x76c003e4 },
+	{ 0x5fffc,  0xfc40005f },
+	{ 0x50298,  0x73c003e0 },
+	{ 0x5fffc,  0xfb800071 },
+	{ 0x5029c,  0x708003de },
+	{ 0x5fffc,  0xfac00085 },
+	{ 0x502a0,  0x6d0003db },
+	{ 0x5fffc,  0xfa000098 },
+	{ 0x502a4,  0x698003d9 },
+	{ 0x5fffc,  0xf98000ac },
+	{ 0x502a8,  0x654003d8 },
+	{ 0x5fffc,  0xf8c000c1 },
+	{ 0x502ac,  0x610003d7 },
+	{ 0x5fffc,  0xf84000d5 },
+	{ 0x502b0,  0x5c8003d7 },
+	{ 0x5fffc,  0xf7c000e9 },
+	{ 0x502b4,  0x580003d7 },
+	{ 0x5fffc,  0xf74000fd },
+	{ 0x502b8,  0x534003d8 },
+	{ 0x5fffc,  0xf6c00112 },
+	{ 0x502bc,  0x4e8003d8 },
+	{ 0x5fffc,  0xf6800126 },
+	{ 0x502c0,  0x494003da },
+	{ 0x5fffc,  0xf600013a },
+	{ 0x502c4,  0x448003db },
+	{ 0x5fffc,  0xf600014d },
+	{ 0x502c8,  0x3f4003dd },
+	{ 0x5fffc,  0xf5c00160 },
+	{ 0x502cc,  0x3a4003df },
+	{ 0x5fffc,  0xf5c00172 },
+	{ 0x502d0,  0x354003e1 },
+	{ 0x5fffc,  0xf5c00184 },
+	{ 0x502d4,  0x304003e3 },
+	{ 0x5fffc,  0xf6000195 },
+	{ 0x502d8,  0x2b0003e6 },
+	{ 0x5fffc,  0xf64001a6 },
+	{ 0x502dc,  0x260003e8 },
+	{ 0x5fffc,  0xf6c001b4 },
+	{ 0x502e0,  0x214003eb },
+	{ 0x5fffc,  0xf78001c2 },
+	{ 0x502e4,  0x1c4003ee },
+	{ 0x5fffc,  0xf80001cf },
+	{ 0x502e8,  0x17c003f1 },
+	{ 0x5fffc,  0xf90001db },
+	{ 0x502ec,  0x134003f3 },
+	{ 0x5fffc,  0xfa0001e5 },
+	{ 0x502f0,  0xf0003f6 },
+	{ 0x5fffc,  0xfb4001ee },
+	{ 0x502f4,  0xac003f9 },
+	{ 0x5fffc,  0xfcc001f5 },
+	{ 0x502f8,  0x70003fb },
+	{ 0x5fffc,  0xfe4001fb },
+	{ 0x502fc,  0x34003fe },
+};
+
+struct mdp_table_entry *mdp_downscale_x_table[MDP_DOWNSCALE_MAX] = {
+	[MDP_DOWNSCALE_PT2TOPT4] = mdp_downscale_x_table_PT2TOPT4,
+	[MDP_DOWNSCALE_PT4TOPT6] = mdp_downscale_x_table_PT4TOPT6,
+	[MDP_DOWNSCALE_PT6TOPT8] = mdp_downscale_x_table_PT6TOPT8,
+	[MDP_DOWNSCALE_PT8TO1]  = mdp_downscale_x_table_PT8TO1,
+};
+
+static struct mdp_table_entry mdp_downscale_y_table_PT2TOPT4[] = {
+	{ 0x5fffc,  0x740008c },
+	{ 0x50300,  0x33800088 },
+	{ 0x5fffc,  0x800008e },
+	{ 0x50304,  0x33400084 },
+	{ 0x5fffc,  0x8400092 },
+	{ 0x50308,  0x33000080 },
+	{ 0x5fffc,  0x9000094 },
+	{ 0x5030c,  0x3300007b },
+	{ 0x5fffc,  0x9c00098 },
+	{ 0x50310,  0x32400077 },
+	{ 0x5fffc,  0xa40009b },
+	{ 0x50314,  0x32000073 },
+	{ 0x5fffc,  0xb00009d },
+	{ 0x50318,  0x31c0006f },
+	{ 0x5fffc,  0xbc000a0 },
+	{ 0x5031c,  0x3140006b },
+	{ 0x5fffc,  0xc8000a2 },
+	{ 0x50320,  0x31000067 },
+	{ 0x5fffc,  0xd8000a5 },
+	{ 0x50324,  0x30800062 },
+	{ 0x5fffc,  0xe4000a8 },
+	{ 0x50328,  0x2fc0005f },
+	{ 0x5fffc,  0xec000aa },
+	{ 0x5032c,  0x2fc0005b },
+	{ 0x5fffc,  0xf8000ad },
+	{ 0x50330,  0x2f400057 },
+	{ 0x5fffc,  0x108000b0 },
+	{ 0x50334,  0x2e400054 },
+	{ 0x5fffc,  0x114000b2 },
+	{ 0x50338,  0x2e000050 },
+	{ 0x5fffc,  0x124000b4 },
+	{ 0x5033c,  0x2d80004c },
+	{ 0x5fffc,  0x130000b6 },
+	{ 0x50340,  0x2d000049 },
+	{ 0x5fffc,  0x140000b8 },
+	{ 0x50344,  0x2c800045 },
+	{ 0x5fffc,  0x150000b9 },
+	{ 0x50348,  0x2c000042 },
+	{ 0x5fffc,  0x15c000bd },
+	{ 0x5034c,  0x2b40003e },
+	{ 0x5fffc,  0x16c000bf },
+	{ 0x50350,  0x2a80003b },
+	{ 0x5fffc,  0x17c000bf },
+	{ 0x50354,  0x2a000039 },
+	{ 0x5fffc,  0x188000c2 },
+	{ 0x50358,  0x29400036 },
+	{ 0x5fffc,  0x19c000c4 },
+	{ 0x5035c,  0x28800032 },
+	{ 0x5fffc,  0x1ac000c5 },
+	{ 0x50360,  0x2800002f },
+	{ 0x5fffc,  0x1bc000c7 },
+	{ 0x50364,  0x2740002c },
+	{ 0x5fffc,  0x1cc000c8 },
+	{ 0x50368,  0x26c00029 },
+	{ 0x5fffc,  0x1dc000c9 },
+	{ 0x5036c,  0x26000027 },
+	{ 0x5fffc,  0x1ec000cc },
+	{ 0x50370,  0x25000024 },
+	{ 0x5fffc,  0x200000cc },
+	{ 0x50374,  0x24800021 },
+	{ 0x5fffc,  0x210000cd },
+	{ 0x50378,  0x23800020 },
+	{ 0x5fffc,  0x220000ce },
+	{ 0x5037c,  0x2300001d },
+};
+
+static struct mdp_table_entry mdp_downscale_y_table_PT4TOPT6[] = {
+	{ 0x5fffc,  0x740008c },
+	{ 0x50300,  0x33800088 },
+	{ 0x5fffc,  0x800008e },
+	{ 0x50304,  0x33400084 },
+	{ 0x5fffc,  0x8400092 },
+	{ 0x50308,  0x33000080 },
+	{ 0x5fffc,  0x9000094 },
+	{ 0x5030c,  0x3300007b },
+	{ 0x5fffc,  0x9c00098 },
+	{ 0x50310,  0x32400077 },
+	{ 0x5fffc,  0xa40009b },
+	{ 0x50314,  0x32000073 },
+	{ 0x5fffc,  0xb00009d },
+	{ 0x50318,  0x31c0006f },
+	{ 0x5fffc,  0xbc000a0 },
+	{ 0x5031c,  0x3140006b },
+	{ 0x5fffc,  0xc8000a2 },
+	{ 0x50320,  0x31000067 },
+	{ 0x5fffc,  0xd8000a5 },
+	{ 0x50324,  0x30800062 },
+	{ 0x5fffc,  0xe4000a8 },
+	{ 0x50328,  0x2fc0005f },
+	{ 0x5fffc,  0xec000aa },
+	{ 0x5032c,  0x2fc0005b },
+	{ 0x5fffc,  0xf8000ad },
+	{ 0x50330,  0x2f400057 },
+	{ 0x5fffc,  0x108000b0 },
+	{ 0x50334,  0x2e400054 },
+	{ 0x5fffc,  0x114000b2 },
+	{ 0x50338,  0x2e000050 },
+	{ 0x5fffc,  0x124000b4 },
+	{ 0x5033c,  0x2d80004c },
+	{ 0x5fffc,  0x130000b6 },
+	{ 0x50340,  0x2d000049 },
+	{ 0x5fffc,  0x140000b8 },
+	{ 0x50344,  0x2c800045 },
+	{ 0x5fffc,  0x150000b9 },
+	{ 0x50348,  0x2c000042 },
+	{ 0x5fffc,  0x15c000bd },
+	{ 0x5034c,  0x2b40003e },
+	{ 0x5fffc,  0x16c000bf },
+	{ 0x50350,  0x2a80003b },
+	{ 0x5fffc,  0x17c000bf },
+	{ 0x50354,  0x2a000039 },
+	{ 0x5fffc,  0x188000c2 },
+	{ 0x50358,  0x29400036 },
+	{ 0x5fffc,  0x19c000c4 },
+	{ 0x5035c,  0x28800032 },
+	{ 0x5fffc,  0x1ac000c5 },
+	{ 0x50360,  0x2800002f },
+	{ 0x5fffc,  0x1bc000c7 },
+	{ 0x50364,  0x2740002c },
+	{ 0x5fffc,  0x1cc000c8 },
+	{ 0x50368,  0x26c00029 },
+	{ 0x5fffc,  0x1dc000c9 },
+	{ 0x5036c,  0x26000027 },
+	{ 0x5fffc,  0x1ec000cc },
+	{ 0x50370,  0x25000024 },
+	{ 0x5fffc,  0x200000cc },
+	{ 0x50374,  0x24800021 },
+	{ 0x5fffc,  0x210000cd },
+	{ 0x50378,  0x23800020 },
+	{ 0x5fffc,  0x220000ce },
+	{ 0x5037c,  0x2300001d },
+};
+
+static struct mdp_table_entry mdp_downscale_y_table_PT6TOPT8[] = {
+	{ 0x5fffc,  0xfe000070 },
+	{ 0x50300,  0x4bc00068 },
+	{ 0x5fffc,  0xfe000078 },
+	{ 0x50304,  0x4bc00060 },
+	{ 0x5fffc,  0xfe000080 },
+	{ 0x50308,  0x4b800059 },
+	{ 0x5fffc,  0xfe000089 },
+	{ 0x5030c,  0x4b000052 },
+	{ 0x5fffc,  0xfe400091 },
+	{ 0x50310,  0x4a80004b },
+	{ 0x5fffc,  0xfe40009a },
+	{ 0x50314,  0x4a000044 },
+	{ 0x5fffc,  0xfe8000a3 },
+	{ 0x50318,  0x4940003d },
+	{ 0x5fffc,  0xfec000ac },
+	{ 0x5031c,  0x48400037 },
+	{ 0x5fffc,  0xff0000b4 },
+	{ 0x50320,  0x47800031 },
+	{ 0x5fffc,  0xff8000bd },
+	{ 0x50324,  0x4640002b },
+	{ 0x5fffc,  0xc5 },
+	{ 0x50328,  0x45000026 },
+	{ 0x5fffc,  0x8000ce },
+	{ 0x5032c,  0x43800021 },
+	{ 0x5fffc,  0x10000d6 },
+	{ 0x50330,  0x4240001c },
+	{ 0x5fffc,  0x18000df },
+	{ 0x50334,  0x40800018 },
+	{ 0x5fffc,  0x24000e6 },
+	{ 0x50338,  0x3f000014 },
+	{ 0x5fffc,  0x30000ee },
+	{ 0x5033c,  0x3d400010 },
+	{ 0x5fffc,  0x40000f5 },
+	{ 0x50340,  0x3b80000c },
+	{ 0x5fffc,  0x50000fc },
+	{ 0x50344,  0x39800009 },
+	{ 0x5fffc,  0x6000102 },
+	{ 0x50348,  0x37c00006 },
+	{ 0x5fffc,  0x7000109 },
+	{ 0x5034c,  0x35800004 },
+	{ 0x5fffc,  0x840010e },
+	{ 0x50350,  0x33800002 },
+	{ 0x5fffc,  0x9800114 },
+	{ 0x50354,  0x31400000 },
+	{ 0x5fffc,  0xac00119 },
+	{ 0x50358,  0x2f4003fe },
+	{ 0x5fffc,  0xc40011e },
+	{ 0x5035c,  0x2d0003fc },
+	{ 0x5fffc,  0xdc00121 },
+	{ 0x50360,  0x2b0003fb },
+	{ 0x5fffc,  0xf400125 },
+	{ 0x50364,  0x28c003fa },
+	{ 0x5fffc,  0x11000128 },
+	{ 0x50368,  0x268003f9 },
+	{ 0x5fffc,  0x12c0012a },
+	{ 0x5036c,  0x244003f9 },
+	{ 0x5fffc,  0x1480012c },
+	{ 0x50370,  0x224003f8 },
+	{ 0x5fffc,  0x1640012e },
+	{ 0x50374,  0x200003f8 },
+	{ 0x5fffc,  0x1800012f },
+	{ 0x50378,  0x1e0003f8 },
+	{ 0x5fffc,  0x1a00012f },
+	{ 0x5037c,  0x1c0003f8 },
+};
+
+static struct mdp_table_entry mdp_downscale_y_table_PT8TO1[] = {
+	{ 0x5fffc,  0x0 },
+	{ 0x50300,  0x7fc00000 },
+	{ 0x5fffc,  0xff80000d },
+	{ 0x50304,  0x7ec003f9 },
+	{ 0x5fffc,  0xfec0001c },
+	{ 0x50308,  0x7d4003f3 },
+	{ 0x5fffc,  0xfe40002b },
+	{ 0x5030c,  0x7b8003ed },
+	{ 0x5fffc,  0xfd80003c },
+	{ 0x50310,  0x794003e8 },
+	{ 0x5fffc,  0xfcc0004d },
+	{ 0x50314,  0x76c003e4 },
+	{ 0x5fffc,  0xfc40005f },
+	{ 0x50318,  0x73c003e0 },
+	{ 0x5fffc,  0xfb800071 },
+	{ 0x5031c,  0x708003de },
+	{ 0x5fffc,  0xfac00085 },
+	{ 0x50320,  0x6d0003db },
+	{ 0x5fffc,  0xfa000098 },
+	{ 0x50324,  0x698003d9 },
+	{ 0x5fffc,  0xf98000ac },
+	{ 0x50328,  0x654003d8 },
+	{ 0x5fffc,  0xf8c000c1 },
+	{ 0x5032c,  0x610003d7 },
+	{ 0x5fffc,  0xf84000d5 },
+	{ 0x50330,  0x5c8003d7 },
+	{ 0x5fffc,  0xf7c000e9 },
+	{ 0x50334,  0x580003d7 },
+	{ 0x5fffc,  0xf74000fd },
+	{ 0x50338,  0x534003d8 },
+	{ 0x5fffc,  0xf6c00112 },
+	{ 0x5033c,  0x4e8003d8 },
+	{ 0x5fffc,  0xf6800126 },
+	{ 0x50340,  0x494003da },
+	{ 0x5fffc,  0xf600013a },
+	{ 0x50344,  0x448003db },
+	{ 0x5fffc,  0xf600014d },
+	{ 0x50348,  0x3f4003dd },
+	{ 0x5fffc,  0xf5c00160 },
+	{ 0x5034c,  0x3a4003df },
+	{ 0x5fffc,  0xf5c00172 },
+	{ 0x50350,  0x354003e1 },
+	{ 0x5fffc,  0xf5c00184 },
+	{ 0x50354,  0x304003e3 },
+	{ 0x5fffc,  0xf6000195 },
+	{ 0x50358,  0x2b0003e6 },
+	{ 0x5fffc,  0xf64001a6 },
+	{ 0x5035c,  0x260003e8 },
+	{ 0x5fffc,  0xf6c001b4 },
+	{ 0x50360,  0x214003eb },
+	{ 0x5fffc,  0xf78001c2 },
+	{ 0x50364,  0x1c4003ee },
+	{ 0x5fffc,  0xf80001cf },
+	{ 0x50368,  0x17c003f1 },
+	{ 0x5fffc,  0xf90001db },
+	{ 0x5036c,  0x134003f3 },
+	{ 0x5fffc,  0xfa0001e5 },
+	{ 0x50370,  0xf0003f6 },
+	{ 0x5fffc,  0xfb4001ee },
+	{ 0x50374,  0xac003f9 },
+	{ 0x5fffc,  0xfcc001f5 },
+	{ 0x50378,  0x70003fb },
+	{ 0x5fffc,  0xfe4001fb },
+	{ 0x5037c,  0x34003fe },
+};
+
+struct mdp_table_entry *mdp_downscale_y_table[MDP_DOWNSCALE_MAX] = {
+	[MDP_DOWNSCALE_PT2TOPT4] = mdp_downscale_y_table_PT2TOPT4,
+	[MDP_DOWNSCALE_PT4TOPT6] = mdp_downscale_y_table_PT4TOPT6,
+	[MDP_DOWNSCALE_PT6TOPT8] = mdp_downscale_y_table_PT6TOPT8,
+	[MDP_DOWNSCALE_PT8TO1]  = mdp_downscale_y_table_PT8TO1,
+};
+
+struct mdp_table_entry mdp_gaussian_blur_table[] = {
+	/* max variance */
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50280, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50284, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50288, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x5028c, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50290, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50294, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50298, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x5029c, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502a0, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502a4, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502a8, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502ac, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502b0, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502b4, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502b8, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502bc, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502c0, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502c4, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502c8, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502cc, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502d0, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502d4, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502d8, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502dc, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502e0, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502e4, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502e8, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502ec, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502f0, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502f4, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502f8, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x502fc, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50300, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50304, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50308, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x5030c, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50310, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50314, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50318, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x5031c, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50320, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50324, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50328, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x5032c, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50330, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50334, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50338, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x5033c, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50340, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50344, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50348, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x5034c, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50350, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50354, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50358, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x5035c, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50360, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50364, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50368, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x5036c, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50370, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50374, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x50378, 0x20000080 },
+	{ 0x5fffc, 0x20000080 },
+	{ 0x5037c, 0x20000080 },
+};
diff -puN /dev/null drivers/video/msm/mdp_scale_tables.h
--- /dev/null
+++ a/drivers/video/msm/mdp_scale_tables.h
@@ -0,0 +1,38 @@
+/* drivers/video/msm_fb/mdp_scale_tables.h
+ *
+ * Copyright (C) 2007 QUALCOMM Incorporated
+ * Copyright (C) 2007 Google Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _MDP_SCALE_TABLES_H_
+#define _MDP_SCALE_TABLES_H_
+
+#include <linux/types.h>
+struct mdp_table_entry {
+	uint32_t reg;
+	uint32_t val;
+};
+
+extern struct mdp_table_entry mdp_upscale_table[64];
+
+enum {
+	MDP_DOWNSCALE_PT2TOPT4,
+	MDP_DOWNSCALE_PT4TOPT6,
+	MDP_DOWNSCALE_PT6TOPT8,
+	MDP_DOWNSCALE_PT8TO1,
+	MDP_DOWNSCALE_MAX,
+};
+
+extern struct mdp_table_entry* mdp_downscale_x_table[MDP_DOWNSCALE_MAX];
+extern struct mdp_table_entry* mdp_downscale_y_table[MDP_DOWNSCALE_MAX];
+extern struct mdp_table_entry mdp_gaussian_blur_table[];
+
+#endif  //_MDP_SCALE_TABLES_H_
diff -puN /dev/null drivers/video/msm/msm_fb.c
--- /dev/null
+++ a/drivers/video/msm/msm_fb.c
@@ -0,0 +1,636 @@
+/* drivers/video/msm/msm_fb.c
+ *
+ * Core MSM framebuffer driver.
+ *
+ * Copyright (C) 2007 Google Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/fb.h>
+#include <linux/delay.h>
+
+#include <linux/freezer.h>
+#include <linux/wait.h>
+#include <linux/msm_mdp.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <mach/msm_fb.h>
+#include <mach/board.h>
+#include <linux/workqueue.h>
+#include <linux/clk.h>
+#include <linux/debugfs.h>
+#include <linux/dma-mapping.h>
+
+#define PRINT_FPS 0
+#define PRINT_BLIT_TIME 0
+
+#define SLEEPING 0x4
+#define UPDATING 0x3
+#define FULL_UPDATE_DONE 0x2
+#define WAKING 0x1
+#define AWAKE 0x0
+
+#define NONE 0
+#define SUSPEND_RESUME 0x1
+#define FPS 0x2
+#define BLIT_TIME 0x4
+#define SHOW_UPDATES 0x8
+
+#define DLOG(mask, fmt, args...) \
+do { \
+	if (msmfb_debug_mask & mask) \
+		printk(KERN_INFO "msmfb: "fmt, ##args); \
+} while (0)
+
+static int msmfb_debug_mask;
+module_param_named(msmfb_debug_mask, msmfb_debug_mask, int,
+		   S_IRUGO | S_IWUSR | S_IWGRP);
+
+struct mdp_device *mdp;
+
+struct msmfb_info {
+	struct fb_info *fb;
+	struct msm_panel_data *panel;
+	int xres;
+	int yres;
+	unsigned output_format;
+	unsigned yoffset;
+	unsigned frame_requested;
+	unsigned frame_done;
+	int sleeping;
+	unsigned update_frame;
+	struct {
+		int left;
+		int top;
+		int eright; /* exclusive */
+		int ebottom; /* exclusive */
+	} update_info;
+	char *black;
+
+	spinlock_t update_lock;
+	struct mutex panel_init_lock;
+	wait_queue_head_t frame_wq;
+	struct workqueue_struct *resume_workqueue;
+	struct work_struct resume_work;
+	struct msmfb_callback dma_callback;
+	struct msmfb_callback vsync_callback;
+	struct hrtimer fake_vsync;
+	ktime_t vsync_request_time;
+};
+
+static int msmfb_open(struct fb_info *info, int user)
+{
+	return 0;
+}
+
+static int msmfb_release(struct fb_info *info, int user)
+{
+	return 0;
+}
+
+/* Called from dma interrupt handler, must not sleep */
+static void msmfb_handle_dma_interrupt(struct msmfb_callback *callback)
+{
+	unsigned long irq_flags;
+	struct msmfb_info *msmfb  = container_of(callback, struct msmfb_info,
+					       dma_callback);
+
+	spin_lock_irqsave(&msmfb->update_lock, irq_flags);
+	msmfb->frame_done = msmfb->frame_requested;
+	if (msmfb->sleeping == UPDATING &&
+	    msmfb->frame_done == msmfb->update_frame) {
+		DLOG(SUSPEND_RESUME, "full update completed\n");
+		queue_work(msmfb->resume_workqueue, &msmfb->resume_work);
+	}
+	spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
+	wake_up(&msmfb->frame_wq);
+}
+
+static int msmfb_start_dma(struct msmfb_info *msmfb)
+{
+	uint32_t x, y, w, h;
+	unsigned addr;
+	unsigned long irq_flags;
+	uint32_t yoffset;
+	s64 time_since_request;
+	struct msm_panel_data *panel = msmfb->panel;
+
+	spin_lock_irqsave(&msmfb->update_lock, irq_flags);
+	time_since_request = ktime_to_ns(ktime_sub(ktime_get(),
+			     msmfb->vsync_request_time));
+	if (time_since_request > 20 * NSEC_PER_MSEC) {
+		uint32_t us;
+		us = do_div(time_since_request, NSEC_PER_MSEC) / NSEC_PER_USEC;
+		printk(KERN_WARNING "msmfb_start_dma %lld.%03u ms after vsync "
+			"request\n", time_since_request, us);
+	}
+	if (msmfb->frame_done == msmfb->frame_requested) {
+		spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
+		return -1;
+	}
+	if (msmfb->sleeping == SLEEPING) {
+		DLOG(SUSPEND_RESUME, "tried to start dma while asleep\n");
+		spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
+		return -1;
+	}
+	x = msmfb->update_info.left;
+	y = msmfb->update_info.top;
+	w = msmfb->update_info.eright - x;
+	h = msmfb->update_info.ebottom - y;
+	yoffset = msmfb->yoffset;
+	msmfb->update_info.left = msmfb->xres + 1;
+	msmfb->update_info.top = msmfb->yres + 1;
+	msmfb->update_info.eright = 0;
+	msmfb->update_info.ebottom = 0;
+	if (unlikely(w > msmfb->xres || h > msmfb->yres ||
+		     w == 0 || h == 0)) {
+		printk(KERN_INFO "invalid update: %d %d %d "
+				"%d\n", x, y, w, h);
+		msmfb->frame_done = msmfb->frame_requested;
+		goto error;
+	}
+	spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
+
+	addr = ((msmfb->xres * (yoffset + y) + x) * 2);
+	mdp->dma(mdp, addr + msmfb->fb->fix.smem_start,
+		 msmfb->xres * 2, w, h, x, y, &msmfb->dma_callback,
+		 panel->interface_type);
+	return 0;
+error:
+	spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
+	/* some clients need to clear their vsync interrupt */
+	if (panel->clear_vsync)
+		panel->clear_vsync(panel);
+	wake_up(&msmfb->frame_wq);
+	return 0;
+}
+
+/* Called from esync interrupt handler, must not sleep */
+static void msmfb_handle_vsync_interrupt(struct msmfb_callback *callback)
+{
+	struct msmfb_info *msmfb = container_of(callback, struct msmfb_info,
+					       vsync_callback);
+	msmfb_start_dma(msmfb);
+}
+
+static enum hrtimer_restart msmfb_fake_vsync(struct hrtimer *timer)
+{
+	struct msmfb_info *msmfb  = container_of(timer, struct msmfb_info,
+					       fake_vsync);
+	msmfb_start_dma(msmfb);
+	return HRTIMER_NORESTART;
+}
+
+static void msmfb_pan_update(struct fb_info *info, uint32_t left, uint32_t top,
+			     uint32_t eright, uint32_t ebottom,
+			     uint32_t yoffset, int pan_display)
+{
+	struct msmfb_info *msmfb = info->par;
+	struct msm_panel_data *panel = msmfb->panel;
+	unsigned long irq_flags;
+	int sleeping;
+	int retry = 1;
+
+	DLOG(SHOW_UPDATES, "update %d %d %d %d %d %d\n",
+		left, top, eright, ebottom, yoffset, pan_display);
+restart:
+	spin_lock_irqsave(&msmfb->update_lock, irq_flags);
+
+	/* if we are sleeping, on a pan_display wait 10ms (to throttle back
+	 * drawing otherwise return */
+	if (msmfb->sleeping == SLEEPING) {
+		DLOG(SUSPEND_RESUME, "drawing while asleep\n");
+		spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
+		if (pan_display)
+			wait_event_interruptible_timeout(msmfb->frame_wq,
+				msmfb->sleeping != SLEEPING, HZ/10);
+		return;
+	}
+
+	sleeping = msmfb->sleeping;
+	/* on a full update, if the last frame has not completed, wait for it */
+	if (pan_display && (msmfb->frame_requested != msmfb->frame_done ||
+			    sleeping == UPDATING)) {
+		int ret;
+		spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
+		ret = wait_event_interruptible_timeout(msmfb->frame_wq,
+			msmfb->frame_done == msmfb->frame_requested &&
+			msmfb->sleeping != UPDATING, 5 * HZ);
+		if (ret <= 0 && (msmfb->frame_requested != msmfb->frame_done ||
+				 msmfb->sleeping == UPDATING)) {
+			if (retry && panel->request_vsync &&
+			    (sleeping == AWAKE)) {
+				panel->request_vsync(panel,
+					&msmfb->vsync_callback);
+				retry = 0;
+				printk(KERN_WARNING "msmfb_pan_display timeout "
+					"rerequest vsync\n");
+			} else {
+				printk(KERN_WARNING "msmfb_pan_display timeout "
+					"waiting for frame start, %d %d\n",
+					msmfb->frame_requested,
+					msmfb->frame_done);
+				return;
+			}
+		}
+		goto restart;
+	}
+
+
+	msmfb->frame_requested++;
+	/* if necessary, update the y offset, if this is the
+	 * first full update on resume, set the sleeping state */
+	if (pan_display) {
+		msmfb->yoffset = yoffset;
+		if (left == 0 && top == 0 && eright == info->var.xres &&
+		    ebottom == info->var.yres) {
+			if (sleeping == WAKING) {
+				msmfb->update_frame = msmfb->frame_requested;
+				DLOG(SUSPEND_RESUME, "full update starting\n");
+				msmfb->sleeping = UPDATING;
+			}
+		}
+	}
+
+	/* set the update request */
+	if (left < msmfb->update_info.left)
+		msmfb->update_info.left = left;
+	if (top < msmfb->update_info.top)
+		msmfb->update_info.top = top;
+	if (eright > msmfb->update_info.eright)
+		msmfb->update_info.eright = eright;
+	if (ebottom > msmfb->update_info.ebottom)
+		msmfb->update_info.ebottom = ebottom;
+	DLOG(SHOW_UPDATES, "update queued %d %d %d %d %d\n",
+		msmfb->update_info.left, msmfb->update_info.top,
+		msmfb->update_info.eright, msmfb->update_info.ebottom,
+		msmfb->yoffset);
+	spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
+
+	/* if the panel is all the way on wait for vsync, otherwise sleep
+	 * for 16 ms (long enough for the dma to panel) and then begin dma */
+	msmfb->vsync_request_time = ktime_get();
+	if (panel->request_vsync && (sleeping == AWAKE)) {
+		panel->request_vsync(panel, &msmfb->vsync_callback);
+	} else {
+		if (!hrtimer_active(&msmfb->fake_vsync)) {
+			hrtimer_start(&msmfb->fake_vsync,
+				      ktime_set(0, NSEC_PER_SEC/60),
+				      HRTIMER_MODE_REL);
+		}
+	}
+}
+
+static void msmfb_update(struct fb_info *info, uint32_t left, uint32_t top,
+			 uint32_t eright, uint32_t ebottom)
+{
+	msmfb_pan_update(info, left, top, eright, ebottom, 0, 0);
+}
+
+static void power_on_panel(struct work_struct *work)
+{
+	struct msmfb_info *msmfb =
+		container_of(work, struct msmfb_info, resume_work);
+	struct msm_panel_data *panel = msmfb->panel;
+	unsigned long irq_flags;
+
+	mutex_lock(&msmfb->panel_init_lock);
+	DLOG(SUSPEND_RESUME, "turning on panel\n");
+	if (msmfb->sleeping == UPDATING) {
+		if (panel->unblank(panel)) {
+			printk(KERN_INFO "msmfb: panel unblank failed,"
+			       "not starting drawing\n");
+			goto error;
+		}
+		spin_lock_irqsave(&msmfb->update_lock, irq_flags);
+		msmfb->sleeping = AWAKE;
+		wake_up(&msmfb->frame_wq);
+		spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
+	}
+error:
+	mutex_unlock(&msmfb->panel_init_lock);
+}
+
+
+static int msmfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	if ((var->xres != info->var.xres) ||
+	    (var->yres != info->var.yres) ||
+	    (var->xres_virtual != info->var.xres_virtual) ||
+	    (var->yres_virtual != info->var.yres_virtual) ||
+	    (var->xoffset != info->var.xoffset) ||
+	    (var->bits_per_pixel != info->var.bits_per_pixel) ||
+	    (var->grayscale != info->var.grayscale))
+		 return -EINVAL;
+	return 0;
+}
+
+int msmfb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	struct msmfb_info *msmfb = info->par;
+	struct msm_panel_data *panel = msmfb->panel;
+
+	/* "UPDT" */
+	if ((panel->caps & MSMFB_CAP_PARTIAL_UPDATES) &&
+	    (var->reserved[0] == 0x54445055)) {
+		msmfb_pan_update(info, var->reserved[1] & 0xffff,
+				 var->reserved[1] >> 16,
+				 var->reserved[2] & 0xffff,
+				 var->reserved[2] >> 16, var->yoffset, 1);
+	} else {
+		msmfb_pan_update(info, 0, 0, info->var.xres, info->var.yres,
+				 var->yoffset, 1);
+	}
+	return 0;
+}
+
+static void msmfb_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
+{
+	cfb_fillrect(p, rect);
+	msmfb_update(p, rect->dx, rect->dy, rect->dx + rect->width,
+		     rect->dy + rect->height);
+}
+
+static void msmfb_copyarea(struct fb_info *p, const struct fb_copyarea *area)
+{
+	cfb_copyarea(p, area);
+	msmfb_update(p, area->dx, area->dy, area->dx + area->width,
+		     area->dy + area->height);
+}
+
+static void msmfb_imageblit(struct fb_info *p, const struct fb_image *image)
+{
+	cfb_imageblit(p, image);
+	msmfb_update(p, image->dx, image->dy, image->dx + image->width,
+		     image->dy + image->height);
+}
+
+
+static int msmfb_blit(struct fb_info *info,
+		      void __user *p)
+{
+	struct mdp_blit_req req;
+	struct mdp_blit_req_list req_list;
+	int i;
+	int ret;
+
+	if (copy_from_user(&req_list, p, sizeof(req_list)))
+		return -EFAULT;
+
+	for (i = 0; i < req_list.count; i++) {
+		struct mdp_blit_req_list *list =
+			(struct mdp_blit_req_list *)p;
+		if (copy_from_user(&req, &list->req[i], sizeof(req)))
+			return -EFAULT;
+		ret = mdp->blit(mdp, info, &req);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+
+DEFINE_MUTEX(mdp_ppp_lock);
+
+static int msmfb_ioctl(struct fb_info *p, unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int ret;
+
+	switch (cmd) {
+	case MSMFB_GRP_DISP:
+		mdp->set_grp_disp(mdp, arg);
+		break;
+	case MSMFB_BLIT:
+		ret = msmfb_blit(p, argp);
+		if (ret)
+			return ret;
+		break;
+	default:
+			printk(KERN_INFO "msmfb unknown ioctl: %d\n", cmd);
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static struct fb_ops msmfb_ops = {
+	.owner = THIS_MODULE,
+	.fb_open = msmfb_open,
+	.fb_release = msmfb_release,
+	.fb_check_var = msmfb_check_var,
+	.fb_pan_display = msmfb_pan_display,
+	.fb_fillrect = msmfb_fillrect,
+	.fb_copyarea = msmfb_copyarea,
+	.fb_imageblit = msmfb_imageblit,
+	.fb_ioctl = msmfb_ioctl,
+};
+
+static unsigned PP[16];
+
+
+
+#define BITS_PER_PIXEL 16
+
+static void setup_fb_info(struct msmfb_info *msmfb)
+{
+	struct fb_info *fb_info = msmfb->fb;
+	int r;
+
+	/* finish setting up the fb_info struct */
+	strncpy(fb_info->fix.id, "msmfb", 16);
+	fb_info->fix.ypanstep = 1;
+
+	fb_info->fbops = &msmfb_ops;
+	fb_info->flags = FBINFO_DEFAULT;
+
+	fb_info->fix.type = FB_TYPE_PACKED_PIXELS;
+	fb_info->fix.visual = FB_VISUAL_TRUECOLOR;
+	fb_info->fix.line_length = msmfb->xres * 2;
+
+	fb_info->var.xres = msmfb->xres;
+	fb_info->var.yres = msmfb->yres;
+	fb_info->var.width = msmfb->panel->fb_data->width;
+	fb_info->var.height = msmfb->panel->fb_data->height;
+	fb_info->var.xres_virtual = msmfb->xres;
+	fb_info->var.yres_virtual = msmfb->yres * 2;
+	fb_info->var.bits_per_pixel = BITS_PER_PIXEL;
+	fb_info->var.accel_flags = 0;
+
+	fb_info->var.yoffset = 0;
+
+	if (msmfb->panel->caps & MSMFB_CAP_PARTIAL_UPDATES) {
+		fb_info->var.reserved[0] = 0x54445055;
+		fb_info->var.reserved[1] = 0;
+		fb_info->var.reserved[2] = (uint16_t)msmfb->xres |
+					   ((uint32_t)msmfb->yres << 16);
+	}
+
+	fb_info->var.red.offset = 11;
+	fb_info->var.red.length = 5;
+	fb_info->var.red.msb_right = 0;
+	fb_info->var.green.offset = 5;
+	fb_info->var.green.length = 6;
+	fb_info->var.green.msb_right = 0;
+	fb_info->var.blue.offset = 0;
+	fb_info->var.blue.length = 5;
+	fb_info->var.blue.msb_right = 0;
+
+	r = fb_alloc_cmap(&fb_info->cmap, 16, 0);
+	fb_info->pseudo_palette = PP;
+
+	PP[0] = 0;
+	for (r = 1; r < 16; r++)
+		PP[r] = 0xffffffff;
+}
+
+static int setup_fbmem(struct msmfb_info *msmfb, struct platform_device *pdev)
+{
+	struct fb_info *fb = msmfb->fb;
+	struct resource *resource;
+	unsigned long size = msmfb->xres * msmfb->yres *
+			     (BITS_PER_PIXEL >> 3) * 2;
+	unsigned char *fbram;
+
+	/* board file might have attached a resource describing an fb */
+	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!resource)
+		return -EINVAL;
+
+	/* check the resource is large enough to fit the fb */
+	if (resource->end - resource->start < size) {
+		printk(KERN_ERR "allocated resource is too small for "
+				"fb\n");
+		return -ENOMEM;
+	}
+	fb->fix.smem_start = resource->start;
+	fb->fix.smem_len = resource->end - resource->start;
+	fbram = ioremap(resource->start,
+			resource->end - resource->start);
+	if (fbram == 0) {
+		printk(KERN_ERR "msmfb: cannot allocate fbram!\n");
+		return -ENOMEM;
+	}
+	fb->screen_base = fbram;
+	return 0;
+}
+
+static int msmfb_probe(struct platform_device *pdev)
+{
+	struct fb_info *fb;
+	struct msmfb_info *msmfb;
+	struct msm_panel_data *panel = pdev->dev.platform_data;
+	int ret;
+
+	if (!panel) {
+		pr_err("msmfb_probe: no platform data\n");
+		return -EINVAL;
+	}
+	if (!panel->fb_data) {
+		pr_err("msmfb_probe: no fb_data\n");
+		return -EINVAL;
+	}
+
+	fb = framebuffer_alloc(sizeof(struct msmfb_info), &pdev->dev);
+	if (!fb)
+		return -ENOMEM;
+	msmfb = fb->par;
+	msmfb->fb = fb;
+	msmfb->panel = panel;
+	msmfb->xres = panel->fb_data->xres;
+	msmfb->yres = panel->fb_data->yres;
+
+	ret = setup_fbmem(msmfb, pdev);
+	if (ret)
+		goto error_setup_fbmem;
+
+	setup_fb_info(msmfb);
+
+	spin_lock_init(&msmfb->update_lock);
+	mutex_init(&msmfb->panel_init_lock);
+	init_waitqueue_head(&msmfb->frame_wq);
+	msmfb->resume_workqueue = create_workqueue("panel_on");
+	if (msmfb->resume_workqueue == NULL) {
+		printk(KERN_ERR "failed to create panel_on workqueue\n");
+		ret = -ENOMEM;
+		goto error_create_workqueue;
+	}
+	INIT_WORK(&msmfb->resume_work, power_on_panel);
+	msmfb->black = kzalloc(msmfb->fb->var.bits_per_pixel*msmfb->xres,
+			       GFP_KERNEL);
+
+	printk(KERN_INFO "msmfb_probe() installing %d x %d panel\n",
+	       msmfb->xres, msmfb->yres);
+
+	msmfb->dma_callback.func = msmfb_handle_dma_interrupt;
+	msmfb->vsync_callback.func = msmfb_handle_vsync_interrupt;
+	hrtimer_init(&msmfb->fake_vsync, CLOCK_MONOTONIC,
+		     HRTIMER_MODE_REL);
+
+
+	msmfb->fake_vsync.function = msmfb_fake_vsync;
+
+	ret = register_framebuffer(fb);
+	if (ret)
+		goto error_register_framebuffer;
+
+	msmfb->sleeping = WAKING;
+
+	return 0;
+
+error_register_framebuffer:
+	destroy_workqueue(msmfb->resume_workqueue);
+error_create_workqueue:
+	iounmap(fb->screen_base);
+error_setup_fbmem:
+	framebuffer_release(msmfb->fb);
+	return ret;
+}
+
+static struct platform_driver msm_panel_driver = {
+	/* need to write remove */
+	.probe = msmfb_probe,
+	.driver = {.name = "msm_panel"},
+};
+
+
+static int msmfb_add_mdp_device(struct device *dev,
+				struct class_interface *class_intf)
+{
+	/* might need locking if mulitple mdp devices */
+	if (mdp)
+		return 0;
+	mdp = container_of(dev, struct mdp_device, dev);
+	return platform_driver_register(&msm_panel_driver);
+}
+
+static void msmfb_remove_mdp_device(struct device *dev,
+				struct class_interface *class_intf)
+{
+	/* might need locking if mulitple mdp devices */
+	if (dev != &mdp->dev)
+		return;
+	platform_driver_unregister(&msm_panel_driver);
+	mdp = NULL;
+}
+
+static struct class_interface msm_fb_interface = {
+	.add_dev = &msmfb_add_mdp_device,
+	.remove_dev = &msmfb_remove_mdp_device,
+};
+
+static int __init msmfb_init(void)
+{
+	return register_mdp_client(&msm_fb_interface);
+}
+
+module_init(msmfb_init);
_

Patches currently in -mm which might be from pavel@ucw.cz are

linux-next.patch
lis3-fix-typo.patch
lis3-add-free-fall-wakeup-function-via-platform_data.patch
lis3-add-power-management-functions.patch
lis3_spi-code-cleanups.patch
framebuffer-support-for-htc-dream.patch

