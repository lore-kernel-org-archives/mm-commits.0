From: akpm@linux-foundation.org
Subject: + sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value.patch added to -mm tree
Date: Thu, 29 Jul 2010 13:52:24 -0700
Message-ID: <201007292052.o6TKqOZ7000614__24409.9275245846$1280436758$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755034Ab0G2Uwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 16:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     sdhci-s3c: add support for the non standard minimal clock value
has been added to the -mm tree.  Its filename is
     sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value.patch

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
Subject: sdhci-s3c: add support for the non standard minimal clock value
From: Marek Szyprowski <m.szyprowski@samsung.com>

S3C SDHCI host controller can change the source for generating mmc clock. 
By default host bus clock is used, what causes some problems on machines
with 133MHz bus, because the SDHCI divider cannot be as high get proper
clock value for identification mode.  This is not a problem for the
controller, because it can generate lower frequencies from other clock
sources.  This patch changes sdhci driver to use get_min_clock() call if
it has been provided.

This fixes the flood of the following warnings on Samsung S5PV210 SoCs:
mmc0: Minimum clock frequency too high for identification mode

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-s3c.c |   27 +++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c     |    3 +--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value drivers/mmc/host/sdhci-s3c.c
--- a/drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value
+++ a/drivers/mmc/host/sdhci-s3c.c
@@ -203,9 +203,36 @@ static void sdhci_s3c_set_clock(struct s
 	}
 }
 
+/**
+ * sdhci_s3c_get_min_clock - callback to get minimal supported clock value
+ * @host: The SDHCI host being queried
+ *
+ * To init mmc host properly a minimal clock value is needed. For high system
+ * bus clock's values the standard formula gives values out of allowed range.
+ * The clock still can be set to lower values, if clock source other then
+ * system bus is selected.
+*/
+static unsigned int sdhci_s3c_get_min_clock(struct sdhci_host *host)
+{
+	struct sdhci_s3c *ourhost = to_s3c(host);
+	unsigned int delta, min = UINT_MAX;
+	int src;
+
+	for (src = 0; src < MAX_BUS_CLK; src++) {
+		delta = sdhci_s3c_consider_clock(ourhost, src, 0);
+		if (delta == UINT_MAX)
+			continue;
+		/* delta is a negative value in this case */
+		if (-delta < min)
+			min = -delta;
+	}
+	return min;
+}
+
 static struct sdhci_ops sdhci_s3c_ops = {
 	.get_max_clock		= sdhci_s3c_get_max_clk,
 	.set_clock		= sdhci_s3c_set_clock,
+	.get_min_clock		= sdhci_s3c_get_min_clock,
 };
 
 static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
diff -puN drivers/mmc/host/sdhci.c~sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value
+++ a/drivers/mmc/host/sdhci.c
@@ -1776,8 +1776,7 @@ int sdhci_add_host(struct sdhci_host *ho
 	 * Set host parameters.
 	 */
 	mmc->ops = &sdhci_ops;
-	if (host->quirks & SDHCI_QUIRK_NONSTANDARD_CLOCK &&
-			host->ops->get_min_clock)
+	if (host->ops->get_min_clock)
 		mmc->f_min = host->ops->get_min_clock(host);
 	else
 		mmc->f_min = host->max_clk / 256;
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

