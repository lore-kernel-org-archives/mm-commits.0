From: akpm@linux-foundation.org
Subject: [merged] s3cmci-add-sdio-irq-support.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:00 -0700
Message-ID: <200910051839.n95Id01u018162__14514.9363940165$1254768063$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652AbZJESjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     s3cmci: add SDIO IRQ support
has been removed from the -mm tree.  Its filename was
     s3cmci-add-sdio-irq-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3cmci: add SDIO IRQ support
From: Ben Dooks <ben@simtec.co.uk>

The controller supports SDIO IRQ detection so add support for hardware
assisted SDIO interrupt detection for the SDIO core.  This improves the
response time for SDIO interrupts and thus the transfer rate from devices
such as the Marvel 8686.

As a note, it does seem that the controller will miss an IRQ than is held
asserted, so there are some manual checks to see if the SDIO interrupt is
active after a transfer.

Major testing on the S3C2440.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |  161 +++++++++++++++++++++++++++++++++---
 drivers/mmc/host/s3cmci.h |    5 +
 2 files changed, 156 insertions(+), 10 deletions(-)

diff -puN drivers/mmc/host/s3cmci.c~s3cmci-add-sdio-irq-support drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-add-sdio-irq-support
+++ a/drivers/mmc/host/s3cmci.c
@@ -190,7 +190,33 @@ static inline u32 disable_imask(struct s
 
 static inline void clear_imask(struct s3cmci_host *host)
 {
-	writel(0, host->base + host->sdiimsk);
+	u32 mask = readl(host->base + host->sdiimsk);
+
+	/* preserve the SDIO IRQ mask state */
+	mask &= S3C2410_SDIIMSK_SDIOIRQ;
+	writel(mask, host->base + host->sdiimsk);
+}
+
+/**
+ * s3cmci_check_sdio_irq - test whether the SDIO IRQ is being signalled
+ * @host: The host to check.
+ *
+ * Test to see if the SDIO interrupt is being signalled in case the
+ * controller has failed to re-detect a card interrupt. Read GPE8 and
+ * see if it is low and if so, signal a SDIO interrupt.
+ *
+ * This is currently called if a request is finished (we assume that the
+ * bus is now idle) and when the SDIO IRQ is enabled in case the IRQ is
+ * already being indicated.
+*/
+static void s3cmci_check_sdio_irq(struct s3cmci_host *host)
+{
+	if (host->sdio_irqen) {
+		if (gpio_get_value(S3C2410_GPE(8)) == 0) {
+			printk(KERN_DEBUG "%s: signalling irq\n", __func__);
+			mmc_signal_sdio_irq(host->mmc);
+		}
+	}
 }
 
 static inline int get_data_buffer(struct s3cmci_host *host,
@@ -238,6 +264,64 @@ static inline u32 fifo_free(struct s3cmc
 	return 63 - fifostat;
 }
 
+/**
+ * s3cmci_enable_irq - enable IRQ, after having disabled it.
+ * @host: The device state.
+ * @more: True if more IRQs are expected from transfer.
+ *
+ * Enable the main IRQ if needed after it has been disabled.
+ *
+ * The IRQ can be one of the following states:
+ *	- disabled during IDLE
+ *	- disabled whilst processing data
+ *	- enabled during transfer
+ *	- enabled whilst awaiting SDIO interrupt detection
+ */
+static void s3cmci_enable_irq(struct s3cmci_host *host, bool more)
+{
+	unsigned long flags;
+	bool enable = false;
+
+	local_irq_save(flags);
+
+	host->irq_enabled = more;
+	host->irq_disabled = false;
+
+	enable = more | host->sdio_irqen;
+
+	if (host->irq_state != enable) {
+		host->irq_state = enable;
+
+		if (enable)
+			enable_irq(host->irq);
+		else
+			disable_irq(host->irq);
+	}
+
+	local_irq_restore(flags);
+}
+
+/**
+ *
+ */
+static void s3cmci_disable_irq(struct s3cmci_host *host, bool transfer)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	//printk(KERN_DEBUG "%s: transfer %d\n", __func__, transfer);
+
+	host->irq_disabled = transfer;
+
+	if (transfer && host->irq_state) {
+		host->irq_state = false;
+		disable_irq(host->irq);
+	}
+
+	local_irq_restore(flags);
+}
+
 static void do_pio_read(struct s3cmci_host *host)
 {
 	int res;
@@ -374,8 +458,7 @@ static void pio_tasklet(unsigned long da
 {
 	struct s3cmci_host *host = (struct s3cmci_host *) data;
 
-
-	disable_irq(host->irq);
+	s3cmci_disable_irq(host, true);
 
 	if (host->pio_active == XFER_WRITE)
 		do_pio_write(host);
@@ -395,9 +478,10 @@ static void pio_tasklet(unsigned long da
 				host->mrq->data->error = -EINVAL;
 		}
 
+		s3cmci_enable_irq(host, false);
 		finalize_request(host);
 	} else
-		enable_irq(host->irq);
+		s3cmci_enable_irq(host, true);
 }
 
 /*
@@ -432,17 +516,27 @@ static irqreturn_t s3cmci_irq(int irq, v
 	struct s3cmci_host *host = dev_id;
 	struct mmc_command *cmd;
 	u32 mci_csta, mci_dsta, mci_fsta, mci_dcnt, mci_imsk;
-	u32 mci_cclear, mci_dclear;
+	u32 mci_cclear = 0, mci_dclear;
 	unsigned long iflags;
 
+	mci_dsta = readl(host->base + S3C2410_SDIDSTA);
+	mci_imsk = readl(host->base + host->sdiimsk);
+
+	if (mci_dsta & S3C2410_SDIDSTA_SDIOIRQDETECT) {
+		if (mci_imsk & S3C2410_SDIIMSK_SDIOIRQ) {
+			mci_dclear = S3C2410_SDIDSTA_SDIOIRQDETECT;
+			writel(mci_dclear, host->base + S3C2410_SDIDSTA);
+
+			mmc_signal_sdio_irq(host->mmc);
+			return IRQ_HANDLED;
+		}
+	}
+
 	spin_lock_irqsave(&host->complete_lock, iflags);
 
 	mci_csta = readl(host->base + S3C2410_SDICMDSTAT);
-	mci_dsta = readl(host->base + S3C2410_SDIDSTA);
 	mci_dcnt = readl(host->base + S3C2410_SDIDCNT);
 	mci_fsta = readl(host->base + S3C2410_SDIFSTA);
-	mci_imsk = readl(host->base + host->sdiimsk);
-	mci_cclear = 0;
 	mci_dclear = 0;
 
 	if ((host->complete_what == COMPLETION_NONE) ||
@@ -776,6 +870,8 @@ static void finalize_request(struct s3cm
 request_done:
 	host->complete_what = COMPLETION_NONE;
 	host->mrq = NULL;
+
+	s3cmci_check_sdio_irq(host);
 	mmc_request_done(host->mmc, mrq);
 }
 
@@ -1037,7 +1133,7 @@ static void s3cmci_send_request(struct m
 	s3cmci_send_command(host, cmd);
 
 	/* Enable Interrupt */
-	enable_irq(host->irq);
+	s3cmci_enable_irq(host, true);
 }
 
 static int s3cmci_card_present(struct mmc_host *mmc)
@@ -1178,11 +1274,52 @@ static int s3cmci_get_ro(struct mmc_host
 	return ret;
 }
 
+static void s3cmci_enable_sdio_irq(struct mmc_host *mmc, int enable)
+{
+	struct s3cmci_host *host = mmc_priv(mmc);
+	unsigned long flags;
+	u32 con;
+
+	local_irq_save(flags);
+
+	con = readl(host->base + S3C2410_SDICON);
+	host->sdio_irqen = enable;
+
+	if (enable == host->sdio_irqen)
+		goto same_state;
+
+	if (enable) {
+		con |= S3C2410_SDICON_SDIOIRQ;
+		enable_imask(host, S3C2410_SDIIMSK_SDIOIRQ);
+
+		if (!host->irq_state && !host->irq_disabled) {
+			host->irq_state = true;
+			enable_irq(host->irq);
+		}
+	} else {
+		disable_imask(host, S3C2410_SDIIMSK_SDIOIRQ);
+		con &= ~S3C2410_SDICON_SDIOIRQ;
+
+		if (!host->irq_enabled && host->irq_state) {
+			disable_irq_nosync(host->irq);
+			host->irq_state = false;
+		}
+	}
+
+	writel(con, host->base + S3C2410_SDICON);
+
+ same_state:
+	local_irq_restore(flags);
+
+	s3cmci_check_sdio_irq(host);
+}
+
 static struct mmc_host_ops s3cmci_ops = {
 	.request	= s3cmci_request,
 	.set_ios	= s3cmci_set_ios,
 	.get_ro		= s3cmci_get_ro,
 	.get_cd		= s3cmci_card_present,
+	.enable_sdio_irq = s3cmci_enable_sdio_irq,
 };
 
 static struct s3c24xx_mci_pdata s3cmci_def_pdata = {
@@ -1257,6 +1394,9 @@ static int s3cmci_state_show(struct seq_
 	seq_printf(seq, "Prescale = %d\n", host->prescaler);
 	seq_printf(seq, "is2440 = %d\n", host->is2440);
 	seq_printf(seq, "IRQ = %d\n", host->irq);
+	seq_printf(seq, "IRQ enabled = %d\n", host->irq_enabled);
+	seq_printf(seq, "IRQ disabled = %d\n", host->irq_disabled);
+	seq_printf(seq, "IRQ state = %d\n", host->irq_state);
 	seq_printf(seq, "CD IRQ = %d\n", host->irq_cd);
 	seq_printf(seq, "Do DMA = %d\n", host->dodma);
 	seq_printf(seq, "SDIIMSK at %d\n", host->sdiimsk);
@@ -1468,6 +1608,7 @@ static int __devinit s3cmci_probe(struct
 	 * ensure we don't lock the system with un-serviceable requests. */
 
 	disable_irq(host->irq);
+	host->irq_state = false;
 
 	if (host->pdata->gpio_detect) {
 		ret = gpio_request(host->pdata->gpio_detect, "s3cmci detect");
@@ -1526,7 +1667,7 @@ static int __devinit s3cmci_probe(struct
 
 	mmc->ops 	= &s3cmci_ops;
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps	= MMC_CAP_4_BIT_DATA;
+	mmc->caps	= MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
 	mmc->f_min 	= host->clk_rate / (host->clk_div * 256);
 	mmc->f_max 	= host->clk_rate / host->clk_div;
 
diff -puN drivers/mmc/host/s3cmci.h~s3cmci-add-sdio-irq-support drivers/mmc/host/s3cmci.h
--- a/drivers/mmc/host/s3cmci.h~s3cmci-add-sdio-irq-support
+++ a/drivers/mmc/host/s3cmci.h
@@ -42,6 +42,11 @@ struct s3cmci_host {
 	int			dodma;
 	int			dmatogo;
 
+	bool			irq_disabled;
+	bool			irq_enabled;
+	bool			irq_state;
+	int			sdio_irqen;
+
 	struct mmc_request	*mrq;
 	int			cmd_is_stop;
 
_

Patches currently in -mm which might be from ben@simtec.co.uk are

gpiolib-add-names-file-in-gpio-chip-sysfs.patch

