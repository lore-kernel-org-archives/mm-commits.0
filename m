From: akpm@linux-foundation.org
Subject: + mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:27:15 -0700
Message-ID: <200803172227.m2HMRGar001528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753483AbYCQW1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: juha.yrjola@solidboot.com, carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx, jarkko.lavinen@nokia.com, tony@atomide.com


The patch titled
     mmc: omap: introduce new multislot structure and change driver to use it
has been added to the -mm tree.  Its filename is
     mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: introduce new multislot structure and change driver to use it
From: Juha Yrjola <juha.yrjola@solidboot.com>

Introduce new MMC multislot structure and change driver to use it.

Note that MMC clocking is now enabled in mmc_omap_select_slot() and disabled
in mmc_omap_release_slot().

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c         |  409 ++++++++++++++++++++++--------
 include/asm-arm/arch-omap/mmc.h |    2 
 2 files changed, 306 insertions(+), 105 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it
+++ a/drivers/mmc/host/omap.c
@@ -32,6 +32,7 @@
 #include <asm/mach-types.h>
 
 #include <asm/arch/board.h>
+#include <asm/arch/mmc.h>
 #include <asm/arch/gpio.h>
 #include <asm/arch/dma.h>
 #include <asm/arch/mux.h>
@@ -95,6 +96,22 @@
  * when the cover switch is open */
 #define OMAP_MMC_SWITCH_POLL_DELAY	500
 
+struct mmc_omap_host;
+
+struct mmc_omap_slot {
+	int			id;
+	unsigned int		vdd;
+	u16			saved_con;
+	u16			bus_mode;
+	unsigned int		fclk_freq;
+	unsigned		powered:1;
+
+	struct mmc_request      *mrq;
+	struct mmc_omap_host    *host;
+	struct mmc_host		*mmc;
+	struct omap_mmc_slot_data *pdata;
+};
+
 struct mmc_omap_host {
 	int			initialized;
 	int			suspended;
@@ -129,13 +146,98 @@ struct mmc_omap_host {
 	unsigned		dma_len;
 
 	short			power_pin;
-	short			wp_pin;
 
-	struct work_struct	switch_work;
-	struct timer_list	switch_timer;
-	int			switch_last_state;
+	struct mmc_omap_slot    *slots[OMAP_MMC_MAX_SLOTS];
+	struct mmc_omap_slot    *current_slot;
+	spinlock_t              slot_lock;
+	wait_queue_head_t       slot_wq;
+	int                     nr_slots;
+
+	struct omap_mmc_platform_data *pdata;
 };
 
+static void mmc_omap_select_slot(struct mmc_omap_slot *slot, int claimed)
+{
+	struct mmc_omap_host *host = slot->host;
+	unsigned long flags;
+
+	if (claimed)
+		goto no_claim;
+	spin_lock_irqsave(&host->slot_lock, flags);
+	while (host->mmc != NULL) {
+		spin_unlock_irqrestore(&host->slot_lock, flags);
+		wait_event(host->slot_wq, host->mmc == NULL);
+		spin_lock_irqsave(&host->slot_lock, flags);
+	}
+	host->mmc = slot->mmc;
+	spin_unlock_irqrestore(&host->slot_lock, flags);
+no_claim:
+	clk_enable(host->fclk);
+	if (host->current_slot != slot) {
+		if (host->pdata->switch_slot != NULL)
+			host->pdata->switch_slot(mmc_dev(slot->mmc), slot->id);
+		host->current_slot = slot;
+	}
+
+	/* Doing the dummy read here seems to work around some bug
+	 * at least in OMAP24xx silicon where the command would not
+	 * start after writing the CMD register. Sigh. */
+	OMAP_MMC_READ(host, CON);
+
+	OMAP_MMC_WRITE(host, CON, slot->saved_con);
+}
+
+static void mmc_omap_start_request(struct mmc_omap_host *host,
+				   struct mmc_request *req);
+
+static void mmc_omap_release_slot(struct mmc_omap_slot *slot)
+{
+	struct mmc_omap_host *host = slot->host;
+	unsigned long flags;
+	int i;
+
+	BUG_ON(slot == NULL || host->mmc == NULL);
+	clk_disable(host->fclk);
+
+	spin_lock_irqsave(&host->slot_lock, flags);
+	/* Check for any pending requests */
+	for (i = 0; i < host->nr_slots; i++) {
+		struct mmc_omap_slot *new_slot;
+		struct mmc_request *rq;
+
+		if (host->slots[i] == NULL || host->slots[i]->mrq == NULL)
+			continue;
+
+		new_slot = host->slots[i];
+		/* The current slot should not have a request in queue */
+		BUG_ON(new_slot == host->current_slot);
+
+		host->mmc = new_slot->mmc;
+		spin_unlock_irqrestore(&host->slot_lock, flags);
+		mmc_omap_select_slot(new_slot, 1);
+		rq = new_slot->mrq;
+		new_slot->mrq = NULL;
+		mmc_omap_start_request(host, rq);
+		return;
+	}
+
+	host->mmc = NULL;
+	wake_up(&host->slot_wq);
+	spin_unlock_irqrestore(&host->slot_lock, flags);
+}
+
+static ssize_t
+mmc_omap_show_slot_name(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct mmc_host *mmc = container_of(dev, struct mmc_host, class_dev);
+	struct mmc_omap_slot *slot = mmc_priv(mmc);
+
+	return sprintf(buf, "%s\n", slot->pdata->name);
+}
+
+static DEVICE_ATTR(slot_name, S_IRUGO, mmc_omap_show_slot_name, NULL);
+
 static void
 mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd)
 {
@@ -180,7 +282,7 @@ mmc_omap_start_command(struct mmc_omap_h
 
 	cmdreg = cmd->opcode | (resptype << 8) | (cmdtype << 12);
 
-	if (host->bus_mode == MMC_BUSMODE_OPENDRAIN)
+	if (host->current_slot->bus_mode == MMC_BUSMODE_OPENDRAIN)
 		cmdreg |= 1 << 6;
 
 	if (cmd->flags & MMC_RSP_BUSY)
@@ -189,8 +291,6 @@ mmc_omap_start_command(struct mmc_omap_h
 	if (host->data && !(host->data->flags & MMC_DATA_WRITE))
 		cmdreg |= 1 << 15;
 
-	clk_enable(host->fclk);
-
 	OMAP_MMC_WRITE(host, CTO, 200);
 	OMAP_MMC_WRITE(host, ARGL, cmd->arg & 0xffff);
 	OMAP_MMC_WRITE(host, ARGH, cmd->arg >> 16);
@@ -442,6 +542,8 @@ static irqreturn_t mmc_omap_irq(int irq,
 		if (status & OMAP_MMC_STAT_CMD_TOUT) {
 			/* Timeouts are routine with some commands */
 			if (host->cmd) {
+				struct mmc_omap_slot *slot =
+					host->current_slot;
 				dev_err(mmc_dev(host->mmc),
 					"command timeout, CMD %d\n",
 					host->cmd->opcode);
@@ -747,11 +849,10 @@ mmc_omap_prepare_data(struct mmc_omap_ho
 	}
 }
 
-static void mmc_omap_request(struct mmc_host *mmc, struct mmc_request *req)
+static void mmc_omap_start_request(struct mmc_omap_host *host,
+				   struct mmc_request *req)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
-
-	WARN_ON(host->mrq != NULL);
+	BUG_ON(host->mrq != NULL);
 
 	host->mrq = req;
 
@@ -760,6 +861,26 @@ static void mmc_omap_request(struct mmc_
 	mmc_omap_start_command(host, req->cmd);
 	if (host->dma_in_use)
 		omap_start_dma(host->dma_ch);
+	BUG_ON(irqs_disabled());
+}
+
+static void mmc_omap_request(struct mmc_host *mmc, struct mmc_request *req)
+{
+	struct mmc_omap_slot *slot = mmc_priv(mmc);
+	struct mmc_omap_host *host = slot->host;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->slot_lock, flags);
+	if (host->mmc != NULL) {
+		BUG_ON(slot->mrq != NULL);
+		slot->mrq = req;
+		spin_unlock_irqrestore(&host->slot_lock, flags);
+		return;
+	} else
+		host->mmc = mmc;
+	spin_unlock_irqrestore(&host->slot_lock, flags);
+	mmc_omap_select_slot(slot, 1);
+	mmc_omap_start_request(host, req);
 }
 
 static void innovator_fpga_socket_power(int on)
@@ -813,7 +934,8 @@ static void mmc_omap_power(struct mmc_om
 
 static int mmc_omap_calc_divisor(struct mmc_host *mmc, struct mmc_ios *ios)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct mmc_omap_slot *slot = mmc_priv(mmc);
+	struct mmc_omap_host *host = slot->host;
 	int func_clk_rate = clk_get_rate(host->fclk);
 	int dsor;
 
@@ -830,6 +952,8 @@ static int mmc_omap_calc_divisor(struct 
 	if (dsor > 250)
 		dsor = 250;
 
+	slot->fclk_freq = func_clk_rate / dsor;
+
 	if (ios->bus_width == MMC_BUS_WIDTH_4)
 		dsor |= 1 << 15;
 
@@ -838,9 +962,9 @@ static int mmc_omap_calc_divisor(struct 
 
 static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
-	int dsor;
-	int i;
+	struct mmc_omap_slot *slot = mmc_priv(mmc);
+	struct mmc_omap_host *host = slot->host;
+	int i, dsor;
 
 	dsor = mmc_omap_calc_divisor(mmc, ios);
 	host->bus_mode = ios->bus_mode;
@@ -880,9 +1004,11 @@ static void mmc_omap_set_ios(struct mmc_
 
 static int mmc_omap_get_ro(struct mmc_host *mmc)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct mmc_omap_slot *slot = mmc_priv(mmc);
 
-	return host->wp_pin && omap_get_gpio_datain(host->wp_pin);
+	if (slot->pdata->get_ro != NULL)
+		return slot->pdata->get_ro(mmc_dev(mmc), slot->id);
+	return 0;
 }
 
 static const struct mmc_host_ops mmc_omap_ops = {
@@ -891,19 +1017,103 @@ static const struct mmc_host_ops mmc_oma
 	.get_ro		= mmc_omap_get_ro,
 };
 
-static int __init mmc_omap_probe(struct platform_device *pdev)
+static int __init mmc_omap_new_slot(struct mmc_omap_host *host, int id)
 {
-	struct omap_mmc_conf *minfo = pdev->dev.platform_data;
+	struct mmc_omap_slot *slot = NULL;
 	struct mmc_host *mmc;
+	int r;
+
+	mmc = mmc_alloc_host(sizeof(struct mmc_omap_slot), host->dev);
+	if (mmc == NULL)
+		return -ENOMEM;
+
+	slot = mmc_priv(mmc);
+	slot->host = host;
+	slot->mmc = mmc;
+	slot->id = id;
+	slot->pdata = &host->pdata->slots[id];
+
+	host->slots[id] = slot;
+
+	mmc->caps = MMC_CAP_MULTIWRITE;
+	if (host->pdata->conf.wire4)
+		mmc->caps |= MMC_CAP_4_BIT_DATA;
+
+	mmc->ops = &mmc_omap_ops;
+	mmc->f_min = 400000;
+
+	if (cpu_class_is_omap2())
+		mmc->f_max = 48000000;
+	else
+		mmc->f_max = 24000000;
+	if (host->pdata->max_freq)
+		mmc->f_max = min(host->pdata->max_freq, mmc->f_max);
+	mmc->ocr_avail = slot->pdata->ocr_mask;
+
+	/* Use scatterlist DMA to reduce per-transfer costs.
+	 * NOTE max_seg_size assumption that small blocks aren't
+	 * normally used (except e.g. for reading SD registers).
+	 */
+	mmc->max_phys_segs = 32;
+	mmc->max_hw_segs = 32;
+	mmc->max_blk_size = 2048;	/* BLEN is 11 bits (+1) */
+	mmc->max_blk_count = 2048;	/* NBLK is 11 bits (+1) */
+	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
+	mmc->max_seg_size = mmc->max_req_size;
+
+	r = mmc_add_host(mmc);
+	if (r < 0)
+		goto err_remove_host;
+
+	if (slot->pdata->name != NULL) {
+		r = device_create_file(&mmc->class_dev,
+					&dev_attr_slot_name);
+		if (r < 0)
+			goto err_remove_host;
+	}
+
+	if (slot->pdata->get_ro != NULL) {
+		r = device_create_file(&mmc->class_dev,
+					&dev_attr_ro);
+	}
+
+	return 0;
+
+err_remove_host:
+	mmc_remove_host(mmc);
+	mmc_free_host(mmc);
+	return r;
+}
+
+static void mmc_omap_remove_slot(struct mmc_omap_slot *slot)
+{
+	struct mmc_host *mmc = slot->mmc;
+
+	if (slot->pdata->name != NULL)
+		device_remove_file(&mmc->class_dev, &dev_attr_slot_name);
+	if (slot->pdata->get_ro != NULL)
+		device_remove_file(&mmc->class_dev, &dev_attr_ro);
+
+	mmc_remove_host(mmc);
+	mmc_free_host(mmc);
+}
+
+static int __init mmc_omap_probe(struct platform_device *pdev)
+{
+	struct omap_mmc_platform_data *pdata = pdev->dev.platform_data;
 	struct mmc_omap_host *host = NULL;
 	struct resource *res;
-	int ret = 0;
+	int i, ret = 0;
 	int irq;
 
-	if (minfo == NULL) {
+	if (pdata == NULL) {
 		dev_err(&pdev->dev, "platform data missing\n");
 		return -ENXIO;
 	}
+	if (pdata->nr_slots == 0) {
+		dev_err(&pdev->dev, "no slots\n");
+		return -ENXIO;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
@@ -911,28 +1121,39 @@ static int __init mmc_omap_probe(struct 
 		return -ENXIO;
 
 	res = request_mem_region(res->start, res->end - res->start + 1,
-			         pdev->name);
+				 pdev->name);
 	if (res == NULL)
 		return -EBUSY;
 
-	mmc = mmc_alloc_host(sizeof(struct mmc_omap_host), &pdev->dev);
-	if (mmc == NULL) {
+	host = kzalloc(sizeof(struct mmc_omap_host), GFP_KERNEL);
+	if (host == NULL) {
 		ret = -ENOMEM;
 		goto err_free_mem_region;
 	}
 
-	host = mmc_priv(mmc);
-	host->mmc = mmc;
-
 	spin_lock_init(&host->dma_lock);
 	init_timer(&host->dma_timer);
+	spin_lock_init(&host->slot_lock);
+	init_waitqueue_head(&host->slot_wq);
+
 	host->dma_timer.function = mmc_omap_dma_timer;
 	host->dma_timer.data = (unsigned long) host;
 
+	host->pdata = pdata;
+	host->dev = &pdev->dev;
+	platform_set_drvdata(pdev, host);
+
 	host->id = pdev->id;
 	host->mem_res = res;
 	host->irq = irq;
 
+	host->use_dma = 1;
+	host->dma_ch = -1;
+
+	host->irq = irq;
+	host->phys_base = host->mem_res->start;
+	host->virt_base = (void __iomem *) IO_ADDRESS(host->phys_base);
+
 	if (cpu_is_omap24xx()) {
 		host->iclk = clk_get(&pdev->dev, "mmc_ick");
 		if (IS_ERR(host->iclk))
@@ -950,70 +1171,34 @@ static int __init mmc_omap_probe(struct 
 		goto err_free_iclk;
 	}
 
-	/* REVISIT:
-	 * Also, use minfo->cover to decide how to manage
-	 * the card detect sensing.
-	 */
-	host->power_pin = minfo->power_pin;
-	host->wp_pin = minfo->wp_pin;
-	host->use_dma = 1;
-	host->dma_ch = -1;
-
-	host->irq = irq;
-	host->phys_base = host->mem_res->start;
-	host->virt_base = (void __iomem *) IO_ADDRESS(host->phys_base);
-
-	mmc->ops = &mmc_omap_ops;
-	mmc->f_min = 400000;
-	mmc->f_max = 24000000;
-	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_MULTIWRITE;
-
-	if (minfo->wire4)
-		 mmc->caps |= MMC_CAP_4_BIT_DATA;
-
-	/* Use scatterlist DMA to reduce per-transfer costs.
-	 * NOTE max_seg_size assumption that small blocks aren't
-	 * normally used (except e.g. for reading SD registers).
-	 */
-	mmc->max_phys_segs = 32;
-	mmc->max_hw_segs = 32;
-	mmc->max_blk_size = 2048;	/* BLEN is 11 bits (+1) */
-	mmc->max_blk_count = 2048;	/* NBLK is 11 bits (+1) */
-	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
-	mmc->max_seg_size = mmc->max_req_size;
-
-	if (host->power_pin >= 0) {
-		if ((ret = omap_request_gpio(host->power_pin)) != 0) {
-			dev_err(mmc_dev(host->mmc),
-				"Unable to get GPIO pin for MMC power\n");
-			goto err_free_fclk;
-		}
-		omap_set_gpio_direction(host->power_pin, 0);
-	}
-
 	ret = request_irq(host->irq, mmc_omap_irq, 0, DRIVER_NAME, host);
 	if (ret)
-		goto err_free_power_gpio;
+		goto err_free_fclk;
 
-	host->dev = &pdev->dev;
-	platform_set_drvdata(pdev, host);
+	if (pdata->init != NULL) {
+		ret = pdata->init(&pdev->dev);
+		if (ret < 0)
+			goto err_free_irq;
+	}
+
+	host->nr_slots = pdata->nr_slots;
+	for (i = 0; i < pdata->nr_slots; i++) {
+		ret = mmc_omap_new_slot(host, i);
+		if (ret < 0) {
+			while (--i >= 0)
+				mmc_omap_remove_slot(host->slots[i]);
 
-	mmc_add_host(mmc);
+			goto err_plat_cleanup;
+		}
+	}
 
 	return 0;
 
-	/* FIXME: Free other resources too. */
-	if (host) {
-		if (host->iclk && !IS_ERR(host->iclk))
-			clk_put(host->iclk);
-		if (host->fclk && !IS_ERR(host->fclk))
-			clk_put(host->fclk);
-		mmc_free_host(host->mmc);
-	}
-err_free_power_gpio:
-	if (host->power_pin >= 0)
-		omap_free_gpio(host->power_pin);
+err_plat_cleanup:
+	if (pdata->cleanup)
+		pdata->cleanup(&pdev->dev);
+err_free_irq:
+	free_irq(host->irq, host);
 err_free_fclk:
 	clk_put(host->fclk);
 err_free_iclk:
@@ -1022,7 +1207,7 @@ err_free_iclk:
 		clk_put(host->iclk);
 	}
 err_free_mmc_host:
-	mmc_free_host(host->mmc);
+	kfree(host);
 err_free_mem_region:
 	release_mem_region(res->start, res->end - res->start + 1);
 	return ret;
@@ -1031,16 +1216,18 @@ err_free_mem_region:
 static int mmc_omap_remove(struct platform_device *pdev)
 {
 	struct mmc_omap_host *host = platform_get_drvdata(pdev);
+	int i;
 
 	platform_set_drvdata(pdev, NULL);
 
 	BUG_ON(host == NULL);
 
-	mmc_remove_host(host->mmc);
-	free_irq(host->irq, host);
+	for (i = 0; i < host->nr_slots; i++)
+		mmc_omap_remove_slot(host->slots[i]);
+
+	if (host->pdata->cleanup)
+		host->pdata->cleanup(&pdev->dev);
 
-	if (host->power_pin >= 0)
-		omap_free_gpio(host->power_pin);
 	if (host->iclk && !IS_ERR(host->iclk))
 		clk_put(host->iclk);
 	if (host->fclk && !IS_ERR(host->fclk))
@@ -1049,7 +1236,7 @@ static int mmc_omap_remove(struct platfo
 	release_mem_region(pdev->resource[0].start,
 			   pdev->resource[0].end - pdev->resource[0].start + 1);
 
-	mmc_free_host(host->mmc);
+	kfree(host);
 
 	return 0;
 }
@@ -1057,35 +1244,47 @@ static int mmc_omap_remove(struct platfo
 #ifdef CONFIG_PM
 static int mmc_omap_suspend(struct platform_device *pdev, pm_message_t mesg)
 {
-	int ret = 0;
+	int i, ret = 0;
 	struct mmc_omap_host *host = platform_get_drvdata(pdev);
 
-	if (host && host->suspended)
+	if (host == NULL || host->suspended)
 		return 0;
 
-	if (host) {
-		ret = mmc_suspend_host(host->mmc, mesg);
-		if (ret == 0)
-			host->suspended = 1;
+	for (i = 0; i < host->nr_slots; i++) {
+		struct mmc_omap_slot *slot;
+
+		slot = host->slots[i];
+		ret = mmc_suspend_host(slot->mmc, mesg);
+		if (ret < 0) {
+			while (--i >= 0) {
+				slot = host->slots[i];
+				mmc_resume_host(slot->mmc);
+			}
+			return ret;
+		}
 	}
-	return ret;
+	host->suspended = 1;
+	return 0;
 }
 
 static int mmc_omap_resume(struct platform_device *pdev)
 {
-	int ret = 0;
+	int i, ret = 0;
 	struct mmc_omap_host *host = platform_get_drvdata(pdev);
 
-	if (host && !host->suspended)
+	if (host == NULL || !host->suspended)
 		return 0;
 
-	if (host) {
-		ret = mmc_resume_host(host->mmc);
-		if (ret == 0)
-			host->suspended = 0;
-	}
+	for (i = 0; i < host->nr_slots; i++) {
+		struct mmc_omap_slot *slot;
+		slot = host->slots[i];
+		ret = mmc_resume_host(slot->mmc);
+		if (ret < 0)
+			return ret;
 
-	return ret;
+		host->suspended = 0;
+	}
+	return 0;
 }
 #else
 #define mmc_omap_suspend	NULL
diff -puN include/asm-arm/arch-omap/mmc.h~mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it include/asm-arm/arch-omap/mmc.h
--- a/include/asm-arm/arch-omap/mmc.h~mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it
+++ a/include/asm-arm/arch-omap/mmc.h
@@ -18,6 +18,8 @@
 #define OMAP_MMC_MAX_SLOTS	2
 
 struct omap_mmc_platform_data {
+	struct omap_mmc_conf	conf;
+
 	unsigned enabled:1;
 	/* number of slots on board */
 	unsigned nr_slots:2;
_

Patches currently in -mm which might be from juha.yrjola@solidboot.com are

mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it.patch
mmc-omap-add-back-cover-switch-support.patch
mmc-omap-new-release-dma-and-abort-xfer-functions.patch
mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch
mmc-omap-power-functions-modified-to-mmc-multislot-support.patch
mmc-omap-general-cleanup-for-mmc-multislot-support.patch

