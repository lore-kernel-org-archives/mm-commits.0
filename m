From: akpm@linux-foundation.org
Subject: + sdhci-s3c-add-support-for-new-card-detection-methods-update.patch added to -mm tree
Date: Mon, 12 Jul 2010 17:04:39 -0700
Message-ID: <201007130004.o6D04dOD004743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776Ab0GMAFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 20:05:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com


The patch titled
     sdhci-s3c-add-support-for-new-card-detection-methods-update
has been added to the -mm tree.  Its filename is
     sdhci-s3c-add-support-for-new-card-detection-methods-update.patch

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
Subject: sdhci-s3c-add-support-for-new-card-detection-methods-update
From: Marek Szyprowski <m.szyprowski@samsung.com>

According to Andrew Morton's suggestion local_irq_save() call in the
sdhci_s3c_notify_change function has been replaced by spin_lock_irqsave
(host driver already has a spinlock that is used for protecting internal
state of the driver).

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-s3c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-add-support-for-new-card-detection-methods-update drivers/mmc/host/sdhci-s3c.c
--- a/drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-add-support-for-new-card-detection-methods-update
+++ a/drivers/mmc/host/sdhci-s3c.c
@@ -250,9 +250,9 @@ static void sdhci_s3c_notify_change(stru
 	struct sdhci_host *host;
 	unsigned long flags;
 
-	local_irq_save(flags);
 	host = platform_get_drvdata(dev);
 	if (host) {
+		spin_lock_irqsave(&host->lock, flags);
 		if (state) {
 			dev_dbg(&dev->dev, "card inserted.\n");
 			host->flags &= ~SDHCI_DEVICE_DEAD;
@@ -264,8 +264,8 @@ static void sdhci_s3c_notify_change(stru
 			host->quirks &= ~SDHCI_QUIRK_BROKEN_CARD_DETECTION;
 			tasklet_schedule(&host->card_tasklet);
 		}
+		spin_unlock_irqrestore(&host->lock, flags);
 	}
-	local_irq_restore(flags);
 }
 
 static irqreturn_t sdhci_s3c_gpio_card_detect_isr(int irq, void *dev_id)
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
sdhci-s3c-add-missing-remove-function.patch
linux-next.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value.patch
sdhci-s3c-add-support-for-new-card-detection-methods.patch
sdhci-s3c-add-support-for-new-card-detection-methods-update.patch
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

