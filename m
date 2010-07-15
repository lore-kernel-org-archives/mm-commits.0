From: akpm@linux-foundation.org
Subject: + mmc-add-jz4740-mmc-driver-v6.patch added to -mm tree
Date: Thu, 15 Jul 2010 14:17:57 -0700
Message-ID: <201007152117.o6FLHvJL019822__29739.625278353$1279228701$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934801Ab0GOVSL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jul 2010 17:18:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lars@metafoo.de, linux-mmc@vger.kernel.org, matt@console-pimps.org, ralf@linux-mips.org


The patch titled
     From: Lars-Peter Clausen <lars@metafoo.de>
has been added to the -mm tree.  Its filename is
     mmc-add-jz4740-mmc-driver-v6.patch

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
Subject: From: Lars-Peter Clausen <lars@metafoo.de>


- Rework Kconfig entry
- Avoid reloading the fifo address before each read/write

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/mach-jz4740/jz4740_mmc.h |   15 
 drivers/mmc/host/Kconfig                       |   17 
 drivers/mmc/host/jz4740_mmc.c                  |  490 ++++++++-------
 include/linux/mmc/jz4740_mmc.h                 |   15 
 4 files changed, 301 insertions(+), 236 deletions(-)

diff -puN /dev/null arch/mips/include/asm/mach-jz4740/jz4740_mmc.h
--- /dev/null
+++ a/arch/mips/include/asm/mach-jz4740/jz4740_mmc.h
@@ -0,0 +1,15 @@
+#ifndef __LINUX_MMC_JZ4740_MMC
+#define __LINUX_MMC_JZ4740_MMC
+
+struct jz4740_mmc_platform_data {
+	int gpio_power;
+	int gpio_card_detect;
+	int gpio_read_only;
+	unsigned card_detect_active_low:1;
+	unsigned read_only_active_low:1;
+	unsigned power_active_low:1;
+
+	unsigned data_1bit:1;
+};
+
+#endif
diff -puN drivers/mmc/host/Kconfig~mmc-add-jz4740-mmc-driver-v6 drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~mmc-add-jz4740-mmc-driver-v6
+++ a/drivers/mmc/host/Kconfig
@@ -81,14 +81,6 @@ config MMC_RICOH_MMC
 
 	  If unsure, say Y.
 
-config MMC_JZ4740
-	tristate "JZ4740 SD/Multimedia Card Interface support"
-	depends on MACH_JZ4740
-	help
-	  This selects the Ingenic Z4740 SD/Multimedia card Interface.
-	  If you have an ngenic platform with a Multimedia Card slot,
-	  say Y or M here.
-
 config MMC_SDHCI_OF
 	tristate "SDHCI support on OpenFirmware platforms"
 	depends on MMC_SDHCI && PPC_OF
@@ -440,3 +432,12 @@ config MMC_SH_MMCIF
 	  This selects the MMC Host Interface controler (MMCIF).
 
 	  This driver supports MMCIF in sh7724/sh7757/sh7372.
+
+config MMC_JZ4740
+	tristate "JZ4740 SD/Multimedia Card Interface support"
+	depends on MACH_JZ4740
+	help
+	  This selects support for the SD/MMC controller on Ingenic JZ4740
+	  SoCs.
+	  If you have a board based on such a SoC and with a SD/MMC slot,
+	  say Y or M here.
diff -puN drivers/mmc/host/jz4740_mmc.c~mmc-add-jz4740-mmc-driver-v6 drivers/mmc/host/jz4740_mmc.c
--- a/drivers/mmc/host/jz4740_mmc.c~mmc-add-jz4740-mmc-driver-v6
+++ a/drivers/mmc/host/jz4740_mmc.c
@@ -22,7 +22,6 @@
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <linux/clk.h>
-#include <linux/mmc/jz4740_mmc.h>
 
 #include <linux/bitops.h>
 #include <linux/gpio.h>
@@ -30,6 +29,7 @@
 #include <asm/cacheflush.h>
 #include <linux/dma-mapping.h>
 
+#include <asm/mach-jz4740/jz4740_mmc.h>
 
 #define JZ_REG_MMC_STRPCL	0x00
 #define JZ_REG_MMC_STATUS	0x04
@@ -103,7 +103,12 @@
 
 #define JZ_MMC_CLK_RATE 24000000
 
-#define JZ4740_MMC_MAX_TIMEOUT 10000000
+enum jz4740_mmc_state {
+	JZ4740_MMC_STATE_READ_RESPONSE,
+	JZ4740_MMC_STATE_TRANSFER_DATA,
+	JZ4740_MMC_STATE_SEND_STOP,
+	JZ4740_MMC_STATE_DONE,
+};
 
 struct jz4740_mmc_host {
 	struct mmc_host *mmc;
@@ -121,7 +126,6 @@ struct jz4740_mmc_host {
 
 	unsigned long waiting;
 
-	int max_clock;
 	uint32_t cmdat;
 
 	uint16_t irq_mask;
@@ -129,6 +133,8 @@ struct jz4740_mmc_host {
 	spinlock_t lock;
 
 	struct timer_list timeout_timer;
+	struct sg_mapping_iter miter;
+	enum jz4740_mmc_state state;
 };
 
 static void jz4740_mmc_set_irq_enabled(struct jz4740_mmc_host *host,
@@ -160,22 +166,24 @@ static void jz4740_mmc_clock_enable(stru
 static void jz4740_mmc_clock_disable(struct jz4740_mmc_host *host)
 {
 	uint32_t status;
+	unsigned int timeout = 1000;
 
 	writew(JZ_MMC_STRPCL_CLOCK_STOP, host->base + JZ_REG_MMC_STRPCL);
 	do {
 		status = readl(host->base + JZ_REG_MMC_STATUS);
-	} while (status & JZ_MMC_STATUS_CLK_EN);
+	} while (status & JZ_MMC_STATUS_CLK_EN && --timeout);
 }
 
 static void jz4740_mmc_reset(struct jz4740_mmc_host *host)
 {
 	uint32_t status;
+	unsigned int timeout = 1000;
 
 	writew(JZ_MMC_STRPCL_RESET, host->base + JZ_REG_MMC_STRPCL);
 	udelay(10);
 	do {
 		status = readl(host->base + JZ_REG_MMC_STATUS);
-	} while (status & JZ_MMC_STATUS_IS_RESETTING);
+	} while (status & JZ_MMC_STATUS_IS_RESETTING && --timeout);
 }
 
 static void jz4740_mmc_request_done(struct jz4740_mmc_host *host)
@@ -188,177 +196,171 @@ static void jz4740_mmc_request_done(stru
 	mmc_request_done(host->mmc, req);
 }
 
-static unsigned int jz4740_mmc_wait_irq(struct jz4740_mmc_host *host,
+static unsigned int jz4740_mmc_poll_irq(struct jz4740_mmc_host *host,
 	unsigned int irq)
 {
-	unsigned int timeout = JZ4740_MMC_MAX_TIMEOUT;
+	unsigned int timeout = 0x800;
 	uint16_t status;
 
 	do {
 		status = readw(host->base + JZ_REG_MMC_IREG);
 	} while (!(status & irq) && --timeout);
 
-	return timeout;
+	if (timeout == 0) {
+		set_bit(0, &host->waiting);
+		mod_timer(&host->timeout_timer, jiffies + 5*HZ);
+		jz4740_mmc_set_irq_enabled(host, irq, true);
+		return true;
+	}
+
+	return false;
 }
 
-static void jz4740_mmc_write_data(struct jz4740_mmc_host *host,
+static void jz4740_mmc_transfer_check_state(struct jz4740_mmc_host *host,
 	struct mmc_data *data)
 {
-	struct sg_mapping_iter miter;
-	uint32_t *buf;
 	int status;
-	unsigned int timeout;
+
+	status = readl(host->base + JZ_REG_MMC_STATUS);
+	if (status & JZ_MMC_STATUS_WRITE_ERROR_MASK) {
+		if (status & (JZ_MMC_STATUS_TIMEOUT_WRITE)) {
+			host->req->cmd->error = -ETIMEDOUT;
+			data->error = -ETIMEDOUT;
+		} else {
+			host->req->cmd->error = -EIO;
+			data->error = -EIO;
+		}
+	}
+}
+
+static bool jz4740_mmc_write_data(struct jz4740_mmc_host *host,
+	struct mmc_data *data)
+{
+	struct sg_mapping_iter *miter = &host->miter;
+	void __iomem *fifo_addr = host->base + JZ_REG_MMC_TXFIFO;
+	uint32_t *buf;
+	bool timeout;
 	size_t i, j;
 
-	sg_miter_start(&miter, data->sg, data->sg_len, SG_MITER_FROM_SG);
-	while (sg_miter_next(&miter)) {
-		buf = miter.addr;
-		i = miter.length / 4;
-		j = i >> 3;
+	while (sg_miter_next(miter)) {
+		buf = miter->addr;
+		i = miter->length / 4;
+		j = i / 8;
 		i = i & 0x7;
 		while (j) {
-			timeout = jz4740_mmc_wait_irq(host, JZ_MMC_IRQ_TXFIFO_WR_REQ);
-			if (unlikely(timeout == 0)) {
-				sg_miter_stop(&miter);
-				goto err_timeout;
-			}
-
-			writel(buf[0], host->base + JZ_REG_MMC_TXFIFO);
-			writel(buf[1], host->base + JZ_REG_MMC_TXFIFO);
-			writel(buf[2], host->base + JZ_REG_MMC_TXFIFO);
-			writel(buf[3], host->base + JZ_REG_MMC_TXFIFO);
-			writel(buf[4], host->base + JZ_REG_MMC_TXFIFO);
-			writel(buf[5], host->base + JZ_REG_MMC_TXFIFO);
-			writel(buf[6], host->base + JZ_REG_MMC_TXFIFO);
-			writel(buf[7], host->base + JZ_REG_MMC_TXFIFO);
+			timeout = jz4740_mmc_poll_irq(host, JZ_MMC_IRQ_TXFIFO_WR_REQ);
+			if (unlikely(timeout))
+				goto poll_timeout;
+
+			writel(buf[0], fifo_addr);
+			writel(buf[1], fifo_addr);
+			writel(buf[2], fifo_addr);
+			writel(buf[3], fifo_addr);
+			writel(buf[4], fifo_addr);
+			writel(buf[5], fifo_addr);
+			writel(buf[6], fifo_addr);
+			writel(buf[7], fifo_addr);
 			buf += 8;
 			--j;
 		}
 		if (unlikely(i)) {
-			timeout = jz4740_mmc_wait_irq(host, JZ_MMC_IRQ_TXFIFO_WR_REQ);
-			if (unlikely(timeout == 0)) {
-				sg_miter_stop(&miter);
-				goto err_timeout;
-			}
+			timeout = jz4740_mmc_poll_irq(host, JZ_MMC_IRQ_TXFIFO_WR_REQ);
+			if (unlikely(timeout))
+				goto poll_timeout;
 
 			while (i) {
-				writel(*buf, host->base + JZ_REG_MMC_TXFIFO);
+				writel(*buf, fifo_addr);
 				++buf;
 				--i;
 			}
 		}
-		data->bytes_xfered += miter.length;
-	}
-	sg_miter_stop(&miter);
-
-	status = readl(host->base + JZ_REG_MMC_STATUS);
-	if (status & JZ_MMC_STATUS_WRITE_ERROR_MASK) {
-		if (status & (JZ_MMC_STATUS_TIMEOUT_WRITE)) {
-			host->req->cmd->error = -ETIMEDOUT;
-			data->error = -ETIMEDOUT;
-		} else {
-			host->req->cmd->error = -EIO;
-			data->error = -EIO;
-		}
-		return;
+		data->bytes_xfered += miter->length;
 	}
+	sg_miter_stop(miter);
 
-	timeout = JZ4740_MMC_MAX_TIMEOUT;
-	do {
-		status = readl(host->base + JZ_REG_MMC_STATUS);
-	} while ((status & JZ_MMC_STATUS_DATA_TRAN_DONE) == 0 && --timeout);
+	return false;
 
-	if (unlikely(timeout == 0))
-		goto err_timeout;
-	writew(JZ_MMC_IRQ_DATA_TRAN_DONE, host->base + JZ_REG_MMC_IREG);
+poll_timeout:
+	miter->consumed = (void *)buf - miter->addr;
+	data->bytes_xfered += miter->consumed;
+	sg_miter_stop(miter);
 
-	return;
-
-err_timeout:
-	host->req->cmd->error = -ETIMEDOUT;
-	data->error = -ETIMEDOUT;
+	return true;
 }
 
-static void jz4740_mmc_read_data(struct jz4740_mmc_host *host,
+static bool jz4740_mmc_read_data(struct jz4740_mmc_host *host,
 				struct mmc_data *data)
 {
-	struct sg_mapping_iter miter;
+	struct sg_mapping_iter *miter = &host->miter;
+	void __iomem *fifo_addr = host->base + JZ_REG_MMC_RXFIFO;
 	uint32_t *buf;
 	uint32_t d;
-	uint16_t status = 0;
+	uint16_t status;
 	size_t i, j;
 	unsigned int timeout;
 
-	sg_miter_start(&miter, data->sg, data->sg_len, SG_MITER_TO_SG);
-	while (sg_miter_next(&miter)) {
-		buf = miter.addr;
-		i = miter.length;
-		j = i >> 5;
+	while (sg_miter_next(miter)) {
+		buf = miter->addr;
+		i = miter->length;
+		j = i / 32;
 		i = i & 0x1f;
 		while (j) {
-			timeout = jz4740_mmc_wait_irq(host, JZ_MMC_IRQ_RXFIFO_RD_REQ);
-			if (unlikely(timeout == 0)) {
-				sg_miter_stop(&miter);
-				goto err_timeout;
-			}
-
-			buf[0] = readl(host->base + JZ_REG_MMC_RXFIFO);
-			buf[1] = readl(host->base + JZ_REG_MMC_RXFIFO);
-			buf[2] = readl(host->base + JZ_REG_MMC_RXFIFO);
-			buf[3] = readl(host->base + JZ_REG_MMC_RXFIFO);
-			buf[4] = readl(host->base + JZ_REG_MMC_RXFIFO);
-			buf[5] = readl(host->base + JZ_REG_MMC_RXFIFO);
-			buf[6] = readl(host->base + JZ_REG_MMC_RXFIFO);
-			buf[7] = readl(host->base + JZ_REG_MMC_RXFIFO);
+			timeout = jz4740_mmc_poll_irq(host, JZ_MMC_IRQ_RXFIFO_RD_REQ);
+			if (unlikely(timeout))
+				goto poll_timeout;
+
+			buf[0] = readl(fifo_addr);
+			buf[1] = readl(fifo_addr);
+			buf[2] = readl(fifo_addr);
+			buf[3] = readl(fifo_addr);
+			buf[4] = readl(fifo_addr);
+			buf[5] = readl(fifo_addr);
+			buf[6] = readl(fifo_addr);
+			buf[7] = readl(fifo_addr);
 
 			buf += 8;
 			--j;
 		}
 
-		while (i >= 4) {
-			timeout = jz4740_mmc_wait_irq(host, JZ_MMC_IRQ_RXFIFO_RD_REQ);
-			if (unlikely(timeout == 0)) {
-				sg_miter_stop(&miter);
-				goto err_timeout;
+		if (unlikely(i)) {
+			timeout = jz4740_mmc_poll_irq(host, JZ_MMC_IRQ_RXFIFO_RD_REQ);
+			if (unlikely(timeout))
+				goto poll_timeout;
+
+			while (i >= 4) {
+				*buf++ = readl(fifo_addr);
+				i -= 4;
+			}
+			if (unlikely(i > 0)) {
+				d = readl(fifo_addr);
+				memcpy(buf, &d, i);
 			}
-
-			*buf++ = readl(host->base + JZ_REG_MMC_RXFIFO);
-			i -= 4;
-		}
-		if (unlikely(i > 0)) {
-			d = readl(host->base + JZ_REG_MMC_RXFIFO);
-			memcpy(buf, &d, i);
 		}
-		data->bytes_xfered += miter.length;
+		data->bytes_xfered += miter->length;
 
-		/* This can go away once MIPS implements flush_kernel_dcache_page */
-		flush_dcache_page(miter.page);
-	}
-	sg_miter_stop(&miter);
-
-	status = readl(host->base + JZ_REG_MMC_STATUS);
-	if (status & JZ_MMC_STATUS_READ_ERROR_MASK) {
-		if (status & JZ_MMC_STATUS_TIMEOUT_READ) {
-			host->req->cmd->error = -ETIMEDOUT;
-			data->error = -ETIMEDOUT;
-		} else {
-			host->req->cmd->error = -EIO;
-			data->error = -EIO;
-		}
-		return;
+		/* This can go away once MIPS implements
+		 * flush_kernel_dcache_page */
+		flush_dcache_page(miter->page);
 	}
+	sg_miter_stop(miter);
 
 	/* For whatever reason there is sometime one word more in the fifo then
 	 * requested */
-	while ((status & JZ_MMC_STATUS_DATA_FIFO_EMPTY) == 0 && --timeout) {
-		d = readl(host->base + JZ_REG_MMC_RXFIFO);
+	timeout = 1000;
+	status = readl(host->base + JZ_REG_MMC_STATUS);
+	while (!(status & JZ_MMC_STATUS_DATA_FIFO_EMPTY) && --timeout) {
+		d = readl(fifo_addr);
 		status = readl(host->base + JZ_REG_MMC_STATUS);
 	}
-	return;
 
-err_timeout:
-	host->req->cmd->error = -ETIMEDOUT;
-	data->error = -ETIMEDOUT;
+	return false;
+
+poll_timeout:
+	miter->consumed = (void *)buf - miter->addr;
+	data->bytes_xfered += miter->consumed;
+	sg_miter_stop(miter);
+
+	return true;
 }
 
 static void jz4740_mmc_timeout(unsigned long data)
@@ -379,19 +381,21 @@ static void jz4740_mmc_read_response(str
 {
 	int i;
 	uint16_t tmp;
+	void __iomem *fifo_addr = host->base + JZ_REG_MMC_RESP_FIFO;
 
 	if (cmd->flags & MMC_RSP_136) {
-		tmp = readw(host->base + JZ_REG_MMC_RESP_FIFO);
+		tmp = readw(fifo_addr);
 		for (i = 0; i < 4; ++i) {
 			cmd->resp[i] = tmp << 24;
-			cmd->resp[i] |= readw(host->base + JZ_REG_MMC_RESP_FIFO) << 8;
-			tmp = readw(host->base + JZ_REG_MMC_RESP_FIFO);
+			tmp = readw(fifo_addr);
+			cmd->resp[i] |= tmp << 8;
+			tmp = readw(fifo_addr);
 			cmd->resp[i] |= tmp >> 8;
 		}
 	} else {
-		cmd->resp[0] = readw(host->base + JZ_REG_MMC_RESP_FIFO) << 24;
-		cmd->resp[0] |= readw(host->base + JZ_REG_MMC_RESP_FIFO) << 8;
-		cmd->resp[0] |= readw(host->base + JZ_REG_MMC_RESP_FIFO) & 0xff;
+		cmd->resp[0] = readw(fifo_addr) << 24;
+		cmd->resp[0] |= readw(fifo_addr) << 8;
+		cmd->resp[0] |= readw(fifo_addr) & 0xff;
 	}
 }
 
@@ -441,41 +445,78 @@ static void jz4740_mmc_send_command(stru
 	jz4740_mmc_clock_enable(host, 1);
 }
 
+static void jz_mmc_prepare_data_transfer(struct jz4740_mmc_host *host)
+{
+	struct mmc_command *cmd = host->req->cmd;
+	struct mmc_data *data = cmd->data;
+	int direction;
+
+	if (data->flags & MMC_DATA_READ)
+		direction = SG_MITER_TO_SG;
+	else
+		direction = SG_MITER_FROM_SG;
+
+	sg_miter_start(&host->miter, data->sg, data->sg_len, direction);
+}
+
 
 static irqreturn_t jz_mmc_irq_worker(int irq, void *devid)
 {
 	struct jz4740_mmc_host *host = (struct jz4740_mmc_host *)devid;
 	struct mmc_command *cmd = host->req->cmd;
 	struct mmc_request *req = host->req;
-	unsigned int timeout = JZ4740_MMC_MAX_TIMEOUT;
-	uint32_t status;
+	bool timeout = false;
 
 	if (cmd->error)
-		goto done;
+		host->state = JZ4740_MMC_STATE_DONE;
 
-	if (cmd->flags & MMC_RSP_PRESENT)
-		jz4740_mmc_read_response(host, cmd);
+	switch (host->state) {
+	case JZ4740_MMC_STATE_READ_RESPONSE:
+		if (cmd->flags & MMC_RSP_PRESENT)
+			jz4740_mmc_read_response(host, cmd);
 
-	if (cmd->data) {
+		if (!cmd->data)
+			break;
+
+		jz_mmc_prepare_data_transfer(host);
+
+	case JZ4740_MMC_STATE_TRANSFER_DATA:
 		if (cmd->data->flags & MMC_DATA_READ)
-			jz4740_mmc_read_data(host, cmd->data);
+			timeout = jz4740_mmc_read_data(host, cmd->data);
 		else
-			jz4740_mmc_write_data(host, cmd->data);
-	}
+			timeout = jz4740_mmc_write_data(host, cmd->data);
+
+		if (unlikely(timeout)) {
+			host->state = JZ4740_MMC_STATE_TRANSFER_DATA;
+			break;
+		}
+
+		jz4740_mmc_transfer_check_state(host, cmd->data);
+
+		timeout = jz4740_mmc_poll_irq(host, JZ_MMC_IRQ_DATA_TRAN_DONE);
+		if (unlikely(timeout)) {
+			host->state = JZ4740_MMC_STATE_SEND_STOP;
+			break;
+		}
+		writew(JZ_MMC_IRQ_DATA_TRAN_DONE, host->base + JZ_REG_MMC_IREG);
+
+	case JZ4740_MMC_STATE_SEND_STOP:
+		if (!req->stop)
+			break;
 
-	if (req->stop) {
 		jz4740_mmc_send_command(host, req->stop);
-		do {
-			status = readw(host->base + JZ_REG_MMC_IREG);
-		} while ((status & JZ_MMC_IRQ_PRG_DONE) == 0 && --timeout);
-		writew(JZ_MMC_IRQ_PRG_DONE, host->base + JZ_REG_MMC_IREG);
-	}
 
-	if (unlikely(timeout == 0))
-		req->stop->error = -ETIMEDOUT;
+		timeout = jz4740_mmc_poll_irq(host, JZ_MMC_IRQ_PRG_DONE);
+		if (timeout) {
+			host->state = JZ4740_MMC_STATE_DONE;
+			break;
+		}
+	case JZ4740_MMC_STATE_DONE:
+		break;
+	}
 
-done:
-	jz4740_mmc_request_done(host);
+	if (!timeout)
+		jz4740_mmc_request_done(host);
 
 	return IRQ_HANDLED;
 }
@@ -483,8 +524,8 @@ done:
 static irqreturn_t jz_mmc_irq(int irq, void *devid)
 {
 	struct jz4740_mmc_host *host = devid;
+	struct mmc_command *cmd = host->cmd;
 	uint16_t irq_reg, status, tmp;
-	irqreturn_t ret = IRQ_HANDLED;
 
 	irq_reg = readw(host->base + JZ_REG_MMC_IREG);
 
@@ -492,7 +533,7 @@ static irqreturn_t jz_mmc_irq(int irq, v
 	irq_reg &= ~host->irq_mask;
 
 	tmp &= ~(JZ_MMC_IRQ_TXFIFO_WR_REQ | JZ_MMC_IRQ_RXFIFO_RD_REQ |
-		    JZ_MMC_IRQ_PRG_DONE | JZ_MMC_IRQ_DATA_TRAN_DONE);
+		JZ_MMC_IRQ_PRG_DONE | JZ_MMC_IRQ_DATA_TRAN_DONE);
 
 	if (tmp != irq_reg)
 		writew(tmp & ~irq_reg, host->base + JZ_REG_MMC_IREG);
@@ -500,39 +541,39 @@ static irqreturn_t jz_mmc_irq(int irq, v
 	if (irq_reg & JZ_MMC_IRQ_SDIO) {
 		writew(JZ_MMC_IRQ_SDIO, host->base + JZ_REG_MMC_IREG);
 		mmc_signal_sdio_irq(host->mmc);
+		irq_reg &= ~JZ_MMC_IRQ_SDIO;
 	}
 
-	if (!host->req || !host->cmd)
-		goto handled;
-
-	if (!(irq_reg & JZ_MMC_IRQ_END_CMD_RES))
-		goto handled;
-
-	if (test_and_clear_bit(0, &host->waiting)) {
-		del_timer(&host->timeout_timer);
+	if (host->req && cmd && irq_reg) {
+		if (test_and_clear_bit(0, &host->waiting)) {
+			del_timer(&host->timeout_timer);
+
+			status = readl(host->base + JZ_REG_MMC_STATUS);
+
+			if (status & JZ_MMC_STATUS_TIMEOUT_RES) {
+					cmd->error = -ETIMEDOUT;
+			} else if (status & JZ_MMC_STATUS_CRC_RES_ERR) {
+					cmd->error = -EIO;
+			} else if (status & (JZ_MMC_STATUS_CRC_READ_ERROR |
+				    JZ_MMC_STATUS_CRC_WRITE_ERROR)) {
+					if (cmd->data)
+							cmd->data->error = -EIO;
+					cmd->error = -EIO;
+			} else if (status & (JZ_MMC_STATUS_CRC_READ_ERROR |
+					JZ_MMC_STATUS_CRC_WRITE_ERROR)) {
+					if (cmd->data)
+							cmd->data->error = -EIO;
+					cmd->error = -EIO;
+			}
 
-		status = readl(host->base + JZ_REG_MMC_STATUS);
+			jz4740_mmc_set_irq_enabled(host, irq_reg, false);
+			writew(irq_reg, host->base + JZ_REG_MMC_IREG);
 
-		if (status & JZ_MMC_STATUS_TIMEOUT_RES) {
-			host->cmd->error = -ETIMEDOUT;
-		} else if (status & JZ_MMC_STATUS_CRC_RES_ERR) {
-			host->cmd->error = -EIO;
-		} else if (status & (JZ_MMC_STATUS_CRC_READ_ERROR |
-				JZ_MMC_STATUS_CRC_WRITE_ERROR)) {
-			host->cmd->data->error = -EIO;
-		} else if (status & (JZ_MMC_STATUS_CRC_READ_ERROR |
-				JZ_MMC_STATUS_CRC_WRITE_ERROR)) {
-			host->cmd->data->error = -EIO;
+			return IRQ_WAKE_THREAD;
 		}
-
-		ret = IRQ_WAKE_THREAD;
 	}
 
-	jz4740_mmc_set_irq_enabled(host, JZ_MMC_IRQ_END_CMD_RES, false);
-	writew(JZ_MMC_IRQ_END_CMD_RES, host->base + JZ_REG_MMC_IREG);
-
-handled:
-	return ret;
+	return IRQ_HANDLED;
 }
 
 static int jz4740_mmc_set_clock_rate(struct jz4740_mmc_host *host, int rate)
@@ -565,6 +606,7 @@ static void jz4740_mmc_request(struct mm
 	writew(JZ_MMC_IRQ_END_CMD_RES, host->base + JZ_REG_MMC_IREG);
 	jz4740_mmc_set_irq_enabled(host, JZ_MMC_IRQ_END_CMD_RES, true);
 
+	host->state = JZ4740_MMC_STATE_READ_RESPONSE;
 	set_bit(0, &host->waiting);
 	mod_timer(&host->timeout_timer, jiffies + 5*HZ);
 	jz4740_mmc_send_command(host, req->cmd);
@@ -631,7 +673,7 @@ static irqreturn_t jz4740_mmc_card_detec
 {
 	struct jz4740_mmc_host *host = devid;
 
-	mmc_detect_change(host->mmc, HZ / 3);
+	mmc_detect_change(host->mmc, HZ / 2);
 
 	return IRQ_HANDLED;
 }
@@ -659,6 +701,28 @@ static const struct jz_gpio_bulk_request
 	JZ_GPIO_BULK_PIN(MSC_DATA3),
 };
 
+static int __devinit jz4740_mmc_request_gpio(struct device *dev, int gpio,
+	const char *name, bool output, int value)
+{
+	int ret;
+
+	if (!gpio_is_valid(gpio))
+		return 0;
+
+	ret = gpio_request(gpio, name);
+	if (ret) {
+		dev_err(dev, "Failed to request %s gpio: %d\n", name, ret);
+		return ret;
+	}
+
+	if (output)
+		gpio_direction_output(gpio, value);
+	else
+		gpio_direction_input(gpio);
+
+	return 0;
+}
+
 static int __devinit jz4740_mmc_request_gpios(struct platform_device *pdev)
 {
 	int ret;
@@ -667,32 +731,20 @@ static int __devinit jz4740_mmc_request_
 	if (!pdata)
 		return 0;
 
-	if (gpio_is_valid(pdata->gpio_card_detect)) {
-		ret = gpio_request(pdata->gpio_card_detect, "MMC detect change");
-		if (ret) {
-			dev_err(&pdev->dev, "Failed to request detect change gpio\n");
-			goto err;
-		}
-		gpio_direction_input(pdata->gpio_card_detect);
-	}
+	ret = jz4740_mmc_request_gpio(&pdev->dev, pdata->gpio_card_detect,
+			"MMC detect change", false, 0);
+	if (ret)
+		goto err;
 
-	if (gpio_is_valid(pdata->gpio_read_only)) {
-		ret = gpio_request(pdata->gpio_read_only, "MMC read only");
-		if (ret) {
-			dev_err(&pdev->dev, "Failed to request read only gpio: %d\n", ret);
-			goto err_free_gpio_card_detect;
-		}
-		gpio_direction_input(pdata->gpio_read_only);
-	}
+	ret = jz4740_mmc_request_gpio(&pdev->dev, pdata->gpio_read_only,
+			"MMC read only", false, 0);
+	if (ret)
+		goto err_free_gpio_card_detect;
 
-	if (gpio_is_valid(pdata->gpio_power)) {
-		ret = gpio_request(pdata->gpio_power, "MMC power");
-		if (ret) {
-			dev_err(&pdev->dev, "Failed to request power gpio: %d\n", ret);
-			goto err_free_gpio_read_only;
-		}
-		gpio_direction_output(pdata->gpio_power, pdata->power_active_low);
-	}
+	ret = jz4740_mmc_request_gpio(&pdev->dev, pdata->gpio_power,
+			"MMC read only", true, pdata->power_active_low);
+	if (ret)
+		goto err_free_gpio_read_only;
 
 	return 0;
 
@@ -706,6 +758,29 @@ err:
 	return ret;
 }
 
+static int __devinit jz4740_mmc_request_cd_irq(struct platform_device *pdev,
+	struct jz4740_mmc_host *host)
+{
+	int ret;
+	struct jz4740_mmc_platform_data *pdata = pdev->dev.platform_data;
+
+	if (gpio_is_valid(pdata->gpio_card_detect))
+		return 0;
+
+	host->card_detect_irq = gpio_to_irq(pdata->gpio_card_detect);
+
+	if (host->card_detect_irq < 0) {
+		dev_warn(&pdev->dev, "Failed to get card detect irq\n");
+		return 0;
+	}
+	return request_irq(host->card_detect_irq, jz4740_mmc_card_detect_irq,
+			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+			"MMC card detect", host);
+
+
+	return ret;
+}
+
 static void jz4740_mmc_free_gpios(struct platform_device *pdev)
 {
 	struct jz4740_mmc_platform_data *pdata = pdev->dev.platform_data;
@@ -811,24 +886,13 @@ static int __devinit jz4740_mmc_probe(st
 
 	host->mmc = mmc;
 	host->pdev = pdev;
-	host->max_clock = JZ_MMC_CLK_RATE;
 	spin_lock_init(&host->lock);
 	host->irq_mask = 0xffff;
 
-	host->card_detect_irq = gpio_to_irq(pdata->gpio_card_detect);
-
-	if (host->card_detect_irq < 0) {
-		dev_warn(&pdev->dev, "Failed to get irq for card detect gpio\n");
-	} else {
-		ret = request_irq(host->card_detect_irq,
-			jz4740_mmc_card_detect_irq,
-			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
-			"MMC card detect", host);
-
-		if (ret) {
-			dev_err(&pdev->dev, "Failed to request card detect irq");
-			goto err_free_gpios;
-		}
+	ret = jz4740_mmc_request_cd_irq(pdev, host);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request card detect irq\n");
+		goto err_free_gpios;
 	}
 
 	ret = request_threaded_irq(host->irq, jz_mmc_irq, jz_mmc_irq_worker, 0,
@@ -842,7 +906,7 @@ static int __devinit jz4740_mmc_probe(st
 	jz4740_mmc_clock_disable(host);
 	setup_timer(&host->timeout_timer, jz4740_mmc_timeout,
 			(unsigned long)host);
-	/* It is not that important when it times out, it just needs to timeout. */
+	/* It is not important when it times out, it just needs to timeout. */
 	set_timer_slack(&host->timeout_timer, HZ);
 
 	platform_set_drvdata(pdev, host);
diff -puN include/linux/mmc/jz4740_mmc.h~mmc-add-jz4740-mmc-driver-v6 /dev/null
--- a/include/linux/mmc/jz4740_mmc.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef __LINUX_MMC_JZ4740_MMC
-#define __LINUX_MMC_JZ4740_MMC
-
-struct jz4740_mmc_platform_data {
-	int gpio_power;
-	int gpio_card_detect;
-	int gpio_read_only;
-	unsigned card_detect_active_low:1;
-	unsigned read_only_active_low:1;
-	unsigned power_active_low:1;
-
-	unsigned data_1bit:1;
-};
