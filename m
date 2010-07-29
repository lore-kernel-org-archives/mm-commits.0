From: akpm@linux-foundation.org
Subject: + sdhci-s3c-add-support-for-new-card-detection-methods.patch added to -mm tree
Date: Thu, 29 Jul 2010 13:52:30 -0700
Message-ID: <201007292052.o6TKqUC2000621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757208Ab0G2Uwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 16:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     sdhci-s3c: add support for new card detection methods
has been added to the -mm tree.  Its filename is
     sdhci-s3c-add-support-for-new-card-detection-methods.patch

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
Subject: sdhci-s3c: add support for new card detection methods
From: Marek Szyprowski <m.szyprowski@samsung.com>

On some Samsung SoCs not all SDHCI controllers have card detect (CD) line.
 For some embedded designs it is not even needed, because ususally the
device (like SDIO flash memory or wifi controller) is permanently wired to
the controller.  There are also systems which have a card detect line
connected to some of the external interrupt lines or the presence of the
card depends on some other actions (like enabling a power regulator).

This patch adds support for all these cases.  The following card detection
methods are possible:

1. internal sdhci host card detect line
2. external event
3. external gpio interrupt
4. no card detect line, controller will poll for the card
5. no card detect line, card is permanently wired to the controller
(once detected host won't poll it any more)

By default, all existing code would use method #1, what is compatible with
the previous version of the driver.

In case of external event, two callbacks must be provided in platdata:
ext_cd_init and ext_cd_cleanup.  Both of them get a callback to a function
that notifies the s3c-sdhci host contoller as their argument.  That
callback function should be called from the even dispatcher to let host
notice the card insertion/removal.

In case of external gpio interrupt, a gpio pin number must be provided in
platdata (ext_cd_gpio parameter), as well as the information about the
polarity of that gpio pin (ext_cd_gpio_invert).  By default
(ext_cd_gpio_invert == 0) gpio value 0 means 'card has been removed', but
this can be changed to 'card has been removed' when ext_cd_gpio_invert ==
1.

This patch adds all required changes to sdhci-s3c driver.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-s3c.c |   85 +++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c     |   47 ++++++++++--------
 drivers/mmc/host/sdhci.h     |    1 
 3 files changed, 113 insertions(+), 20 deletions(-)

diff -puN drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-add-support-for-new-card-detection-methods drivers/mmc/host/sdhci-s3c.c
--- a/drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-add-support-for-new-card-detection-methods
+++ a/drivers/mmc/host/sdhci-s3c.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/gpio.h>
 
 #include <linux/mmc/host.h>
 
@@ -44,6 +45,8 @@ struct sdhci_s3c {
 	struct resource		*ioarea;
 	struct s3c_sdhci_platdata *pdata;
 	unsigned int		cur_clk;
+	int			ext_cd_irq;
+	int			ext_cd_gpio;
 
 	struct clk		*clk_io;
 	struct clk		*clk_bus[MAX_BUS_CLK];
@@ -235,6 +238,61 @@ static struct sdhci_ops sdhci_s3c_ops = 
 	.get_min_clock		= sdhci_s3c_get_min_clock,
 };
 
+static void sdhci_s3c_notify_change(struct platform_device *dev, int state)
+{
+	struct sdhci_host *host = platform_get_drvdata(dev);
+	if (host) {
+		mutex_lock(&host->lock);
+		if (state) {
+			dev_dbg(&dev->dev, "card inserted.\n");
+			host->flags &= ~SDHCI_DEVICE_DEAD;
+			host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
+		} else {
+			dev_dbg(&dev->dev, "card removed.\n");
+			host->flags |= SDHCI_DEVICE_DEAD;
+			host->quirks &= ~SDHCI_QUIRK_BROKEN_CARD_DETECTION;
+		}
+		sdhci_card_detect(host);
+		mutex_unlock(&host->lock);
+	}
+}
+
+static irqreturn_t sdhci_s3c_gpio_card_detect_thread(int irq, void *dev_id)
+{
+	struct sdhci_s3c *sc = dev_id;
+	int status = gpio_get_value(sc->ext_cd_gpio);
+	if (sc->pdata->ext_cd_gpio_invert)
+		status = !status;
+	sdhci_s3c_notify_change(sc->pdev, status);
+	return IRQ_HANDLED;
+}
+
+static void sdhci_s3c_setup_card_detect_gpio(struct sdhci_s3c *sc)
+{
+	struct s3c_sdhci_platdata *pdata = sc->pdata;
+	struct device *dev = &sc->pdev->dev;
+
+	if (gpio_request(pdata->ext_cd_gpio, "SDHCI EXT CD") == 0) {
+		sc->ext_cd_gpio = pdata->ext_cd_gpio;
+		sc->ext_cd_irq = gpio_to_irq(pdata->ext_cd_gpio);
+		if (sc->ext_cd_irq &&
+		    request_threaded_irq(sc->ext_cd_irq, NULL,
+					 sdhci_s3c_gpio_card_detect_thread,
+					 IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+					 dev_name(dev), sc) == 0) {
+			int status = gpio_get_value(sc->ext_cd_gpio);
+			if (pdata->ext_cd_gpio_invert)
+				status = !status;
+			sdhci_s3c_notify_change(sc->pdev, status);
+		} else {
+			dev_warn(dev, "cannot request irq for card detect\n");
+			sc->ext_cd_irq = 0;
+		}
+	} else {
+		dev_err(dev, "cannot request gpio for card detect\n");
+	}
+}
+
 static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
 {
 	struct s3c_sdhci_platdata *pdata = pdev->dev.platform_data;
@@ -272,6 +330,7 @@ static int __devinit sdhci_s3c_probe(str
 	sc->host = host;
 	sc->pdev = pdev;
 	sc->pdata = pdata;
+	sc->ext_cd_gpio = -1; /* invalid gpio number */
 
 	platform_set_drvdata(pdev, host);
 
@@ -353,6 +412,13 @@ static int __devinit sdhci_s3c_probe(str
 	 * SDHCI block, or a missing configuration that needs to be set. */
 	host->quirks |= SDHCI_QUIRK_NO_BUSY_IRQ;
 
+	if (pdata->cd_type == S3C_SDHCI_CD_NONE ||
+	    pdata->cd_type == S3C_SDHCI_CD_PERMANENT)
+		host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
+
+	if (pdata->cd_type == S3C_SDHCI_CD_PERMANENT)
+		host->mmc->caps = MMC_CAP_NONREMOVABLE;
+
 	host->quirks |= (SDHCI_QUIRK_32BIT_DMA_ADDR |
 			 SDHCI_QUIRK_32BIT_DMA_SIZE);
 
@@ -365,6 +431,15 @@ static int __devinit sdhci_s3c_probe(str
 		goto err_add_host;
 	}
 
+	/* The following two methods of card detection might call
+	   sdhci_s3c_notify_change() immediately, so they can be called
+	   only after sdhci_add_host(). Setup errors are ignored. */
+	if (pdata->cd_type == S3C_SDHCI_CD_EXTERNAL && pdata->ext_cd_init)
+		pdata->ext_cd_init(&sdhci_s3c_notify_change);
+	if (pdata->cd_type == S3C_SDHCI_CD_GPIO &&
+	    gpio_is_valid(pdata->ext_cd_gpio))
+		sdhci_s3c_setup_card_detect_gpio(sc);
+
 	return 0;
 
  err_add_host:
@@ -389,10 +464,20 @@ static int __devinit sdhci_s3c_probe(str
 
 static int __devexit sdhci_s3c_remove(struct platform_device *pdev)
 {
+	struct s3c_sdhci_platdata *pdata = pdev->dev.platform_data;
 	struct sdhci_host *host =  platform_get_drvdata(pdev);
 	struct sdhci_s3c *sc = sdhci_priv(host);
 	int ptr;
 
+	if (pdata->cd_type == S3C_SDHCI_CD_EXTERNAL && pdata->ext_cd_cleanup)
+		pdata->ext_cd_cleanup(&sdhci_s3c_notify_change);
+
+	if (sc->ext_cd_irq)
+		free_irq(sc->ext_cd_irq, sc);
+
+	if (gpio_is_valid(sc->ext_cd_gpio))
+		gpio_free(sc->ext_cd_gpio);
+
 	sdhci_remove_host(host, 1);
 
 	for (ptr = 0; ptr < 3; ptr++) {
diff -puN drivers/mmc/host/sdhci.c~sdhci-s3c-add-support-for-new-card-detection-methods drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-s3c-add-support-for-new-card-detection-methods
+++ a/drivers/mmc/host/sdhci.c
@@ -1244,26 +1244,6 @@ static const struct mmc_host_ops sdhci_o
  *                                                                           *
 \*****************************************************************************/
 
-static void sdhci_card_detect(struct sdhci_host *host)
-{
-	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)) {
-		if (host->mrq) {
-			printk(KERN_ERR "%s: Card removed during transfer!\n",
-				mmc_hostname(host->mmc));
-			printk(KERN_ERR "%s: Resetting controller.\n",
-				mmc_hostname(host->mmc));
-
-			sdhci_reset(host, SDHCI_RESET_CMD);
-			sdhci_reset(host, SDHCI_RESET_DATA);
-
-			host->mrq->cmd->error = -ENOMEDIUM;
-			schedule_work(&host->finish_work);
-		}
-	}
-
-	mmc_detect_change(host->mmc, msecs_to_jiffies(200));
-}
-
 static void sdhci_finish_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
@@ -1627,6 +1607,33 @@ EXPORT_SYMBOL_GPL(sdhci_resume_host);
 
 /*****************************************************************************\
  *                                                                           *
+ * Implementation dependent callbacks                                        *
+ *                                                                           *
+\*****************************************************************************/
+
+void sdhci_card_detect(struct sdhci_host *host)
+{
+	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)) {
+		if (host->mrq) {
+			printk(KERN_ERR "%s: Card removed during transfer!\n",
+				mmc_hostname(host->mmc));
+			printk(KERN_ERR "%s: Resetting controller.\n",
+				mmc_hostname(host->mmc));
+
+			sdhci_reset(host, SDHCI_RESET_CMD);
+			sdhci_reset(host, SDHCI_RESET_DATA);
+
+			host->mrq->cmd->error = -ENOMEDIUM;
+			schedule_work(&host->finish_work);
+		}
+	}
+
+	mmc_detect_change(host->mmc, msecs_to_jiffies(200));
+}
+EXPORT_SYMBOL_GPL(sdhci_card_detect);
+
+/*****************************************************************************\
+ *                                                                           *
  * Device allocation/registration                                            *
  *                                                                           *
 \*****************************************************************************/
diff -puN drivers/mmc/host/sdhci.h~sdhci-s3c-add-support-for-new-card-detection-methods drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-s3c-add-support-for-new-card-detection-methods
+++ a/drivers/mmc/host/sdhci.h
@@ -415,6 +415,7 @@ static inline void *sdhci_priv(struct sd
 	return (void *)host->private;
 }
 
+extern void sdhci_card_detect(struct sdhci_host *host);
 extern int sdhci_add_host(struct sdhci_host *host);
 extern void sdhci_remove_host(struct sdhci_host *host, int dead);
 
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

linux-next.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value.patch
sdhci-s3c-enable-sdhci_quirk_no_hispd_bit-quirk.patch
sdhci-s3c-add-support-for-new-card-detection-methods.patch
sdhci-add-regulator-support.patch
s3c-fb-change-to-depending-on-config_s3c_fb_dev.patch
s3c-fb-add-default-window-feature.patch
s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch
s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch
s3c-fb-initial-move-to-unifying-the-header-files.patch
s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch
s3c-fb-integrate-palette-setup-code-into-main-driver.patch
s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch
s3c-fb-correct-framesel1-bitfield-defines-for-vidintcon0-register.patch
s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch
s3c-fb-add-device-name-initialization.patch
s3c-fb-add-support-for-display-panning.patch
s3c-fb-add-wait-for-vsync-ioctl.patch
s3c-fb-window-3-of-64xx-does-not-have-an-osd_d-register.patch
s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch
s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch
s3c-fb-protect-window-specific-registers-during-updates.patch
s3c-fb-fix-section-mismatch.patch
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch
s3c-fb-automatically-calculate-pixel-clock-when-none-is-given.patch
arm-samsung-remove-pixclock-from-several-boards.patch

