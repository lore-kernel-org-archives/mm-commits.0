From: akpm@linux-foundation.org
Subject: + sdhci-s3c-enable-sdhci_quirk_no_hispd_bit-quirk.patch added to -mm tree
Date: Thu, 29 Jul 2010 13:52:27 -0700
Message-ID: <201007292052.o6TKqRlB000617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756707Ab0G2Uwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 16:52:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     sdhci-s3c: enable SDHCI_QUIRK_NO_HISPD_BIT quirk
has been added to the -mm tree.  Its filename is
     sdhci-s3c-enable-sdhci_quirk_no_hispd_bit-quirk.patch

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
Subject: sdhci-s3c: enable SDHCI_QUIRK_NO_HISPD_BIT quirk
From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch enables SDHCI_QUIRK_NO_HISPD_BIT on Samsung SDHCI driver.  This
solves detection problems with some external SD cards.  This change has
been tested on S5PC100 and S5PC110.  It has no inpact on driver speed.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-s3c.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-enable-sdhci_quirk_no_hispd_bit-quirk drivers/mmc/host/sdhci-s3c.c
--- a/drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-enable-sdhci_quirk_no_hispd_bit-quirk
+++ a/drivers/mmc/host/sdhci-s3c.c
@@ -338,6 +338,7 @@ static int __devinit sdhci_s3c_probe(str
 
 	/* Setup quirks for the controller */
 	host->quirks |= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC;
+	host->quirks |= SDHCI_QUIRK_NO_HISPD_BIT;
 
 #ifndef CONFIG_MMC_SDHCI_S3C_DMA
 
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

