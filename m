From: akpm@linux-foundation.org
Subject: + omap-pandora-pass-wl1251-information-to-sdio-core.patch added to -mm tree
Date: Thu, 01 Jul 2010 15:31:39 -0700
Message-ID: <201007012231.o61MVddO001599__10766.9505676769$1278023584$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932199Ab0GAWct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2010 18:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: notasas@gmail.com, adrian.hunter@nokia.com, kishore.kadiyala@ti.com, kvalo@adurom.com, linux-mmc@vger.kernel.org, linux@arm.linux.org.uk, madhu.cr@ti.com, me@bobcopeland.com, tony@atomide.com


The patch titled
     omap: pandora: pass wl1251 information to SDIO core
has been added to the -mm tree.  Its filename is
     omap-pandora-pass-wl1251-information-to-sdio-core.patch

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
Subject: omap: pandora: pass wl1251 information to SDIO core
From: Grazvydas Ignotas <notasas@gmail.com>

Pandora has TI WL1251 attached on MMC3, which is non-standard SDIO chip.
Make use MMC_QUIRK_NONSTD_SDIO to tell SDIO core about it.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Bob Copeland <me@bobcopeland.com>
Cc: Kalle Valo <kvalo@adurom.com>
Cc: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: Kishore Kadiyala <kishore.kadiyala@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/board-omap3pandora.c |   16 ++++++++++++++++
 arch/arm/mach-omap2/hsmmc.c              |    1 +
 arch/arm/mach-omap2/hsmmc.h              |    4 ++++
 3 files changed, 21 insertions(+)

diff -puN arch/arm/mach-omap2/board-omap3pandora.c~omap-pandora-pass-wl1251-information-to-sdio-core arch/arm/mach-omap2/board-omap3pandora.c
--- a/arch/arm/mach-omap2/board-omap3pandora.c~omap-pandora-pass-wl1251-information-to-sdio-core
+++ a/arch/arm/mach-omap2/board-omap3pandora.c
@@ -29,6 +29,7 @@
 #include <linux/input.h>
 #include <linux/input/matrix_keypad.h>
 #include <linux/gpio_keys.h>
+#include <linux/mmc/card.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -227,6 +228,20 @@ static struct platform_device pandora_ds
 	},
 };
 
+static void pandora_wl1251_init_card(struct mmc_card *card)
+{
+	/*
+	 * We have TI wl1251 attached to MMC3. Pass this information to
+	 * SDIO core because it can't be probed by normal methods.
+	 */
+	card->quirks |= MMC_QUIRK_NONSTD_SDIO;
+	card->cccr.wide_bus = 1;
+	card->cis.vendor = 0x104c;
+	card->cis.device = 0x9066;
+	card->cis.blksize = 512;
+	card->cis.max_dtr = 20000000;
+}
+
 static struct omap2_hsmmc_info omap3pandora_mmc[] = {
 	{
 		.mmc		= 1,
@@ -248,6 +263,7 @@ static struct omap2_hsmmc_info omap3pand
 		.wires		= 4,
 		.gpio_cd	= -EINVAL,
 		.gpio_wp	= -EINVAL,
+		.init_card	= pandora_wl1251_init_card,
 	},
 	{}	/* Terminator */
 };
diff -puN arch/arm/mach-omap2/hsmmc.c~omap-pandora-pass-wl1251-information-to-sdio-core arch/arm/mach-omap2/hsmmc.c
--- a/arch/arm/mach-omap2/hsmmc.c~omap-pandora-pass-wl1251-information-to-sdio-core
+++ a/arch/arm/mach-omap2/hsmmc.c
@@ -268,6 +268,7 @@ void __init omap2_hsmmc_init(struct omap
 		mmc->slots[0].gpio_wp = c->gpio_wp;
 
 		mmc->slots[0].remux = c->remux;
+		mmc->slots[0].init_card = c->init_card;
 
 		if (c->cover_only)
 			mmc->slots[0].cover = 1;
diff -puN arch/arm/mach-omap2/hsmmc.h~omap-pandora-pass-wl1251-information-to-sdio-core arch/arm/mach-omap2/hsmmc.h
--- a/arch/arm/mach-omap2/hsmmc.h~omap-pandora-pass-wl1251-information-to-sdio-core
+++ a/arch/arm/mach-omap2/hsmmc.h
@@ -6,6 +6,8 @@
  * published by the Free Software Foundation.
  */
 
+struct mmc_card;
+
 struct omap2_hsmmc_info {
 	u8	mmc;		/* controller 1/2/3 */
 	u8	wires;		/* 1/4/8 wires */
@@ -23,6 +25,8 @@ struct omap2_hsmmc_info {
 	int	ocr_mask;	/* temporary HACK */
 	/* Remux (pad configuation) when powering on/off */
 	void (*remux)(struct device *dev, int slot, int power_on);
+	/* init some special card */
+	void (*init_card)(struct mmc_card *card);
 };
 
 #if defined(CONFIG_MMC_OMAP_HS) || defined(CONFIG_MMC_OMAP_HS_MODULE)
_

Patches currently in -mm which might be from notasas@gmail.com are

linux-next.patch
sdio-allow-non-standard-sdio-cards.patch
omap_hsmmc-add-init_card-pass-through-callback.patch
omap-pandora-pass-wl1251-information-to-sdio-core.patch

