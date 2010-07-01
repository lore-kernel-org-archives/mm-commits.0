From: akpm@linux-foundation.org
Subject: + omap_hsmmc-add-init_card-pass-through-callback.patch added to -mm tree
Date: Thu, 01 Jul 2010 15:31:37 -0700
Message-ID: <201007012231.o61MVbdj001596__30565.5778189704$1278023585$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758335Ab0GAWc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2010 18:32:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: notasas@gmail.com, adrian.hunter@nokia.com, kishore.kadiyala@ti.com, kvalo@adurom.com, linux-mmc@vger.kernel.org, linux@arm.linux.org.uk, madhu.cr@ti.com, me@bobcopeland.com, tony@atomide.com


The patch titled
     omap_hsmmc: add init_card pass-through callback
has been added to the -mm tree.  Its filename is
     omap_hsmmc-add-init_card-pass-through-callback.patch

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
Subject: omap_hsmmc: add init_card pass-through callback
From: Grazvydas Ignotas <notasas@gmail.com>

This will allow us to set up special cards in machine drivers just after
they are detected by MMC core.

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

 arch/arm/plat-omap/include/plat/mmc.h |    2 ++
 drivers/mmc/host/omap_hsmmc.c         |   10 ++++++++++
 2 files changed, 12 insertions(+)

diff -puN arch/arm/plat-omap/include/plat/mmc.h~omap_hsmmc-add-init_card-pass-through-callback arch/arm/plat-omap/include/plat/mmc.h
--- a/arch/arm/plat-omap/include/plat/mmc.h~omap_hsmmc-add-init_card-pass-through-callback
+++ a/arch/arm/plat-omap/include/plat/mmc.h
@@ -122,6 +122,8 @@ struct omap_mmc_platform_data {
 		/* Call back after enabling / disabling regulators */
 		void (*after_set_reg)(struct device *dev, int slot,
 				      int power_on, int vdd);
+		/* if we have special card, init it using this callback */
+		void (*init_card)(struct mmc_card *card);
 
 		/* return MMC cover switch state, can be NULL if not supported.
 		 *
diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-add-init_card-pass-through-callback drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-add-init_card-pass-through-callback
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -1598,6 +1598,14 @@ static int omap_hsmmc_get_ro(struct mmc_
 	return mmc_slot(host).get_ro(host->dev, 0);
 }
 
+static void omap_hsmmc_init_card(struct mmc_host *mmc, struct mmc_card *card)
+{
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
+
+	if (mmc_slot(host).init_card)
+		mmc_slot(host).init_card(card);
+}
+
 static void omap_hsmmc_conf_bus_power(struct omap_hsmmc_host *host)
 {
 	u32 hctl, capa, value;
@@ -1869,6 +1877,7 @@ static const struct mmc_host_ops omap_hs
 	.set_ios = omap_hsmmc_set_ios,
 	.get_cd = omap_hsmmc_get_cd,
 	.get_ro = omap_hsmmc_get_ro,
+	.init_card = omap_hsmmc_init_card,
 	/* NYET -- enable_sdio_irq */
 };
 
@@ -1879,6 +1888,7 @@ static const struct mmc_host_ops omap_hs
 	.set_ios = omap_hsmmc_set_ios,
 	.get_cd = omap_hsmmc_get_cd,
 	.get_ro = omap_hsmmc_get_ro,
+	.init_card = omap_hsmmc_init_card,
 	/* NYET -- enable_sdio_irq */
 };
 
_

Patches currently in -mm which might be from notasas@gmail.com are

linux-next.patch
sdio-allow-non-standard-sdio-cards.patch
omap_hsmmc-add-init_card-pass-through-callback.patch
omap-pandora-pass-wl1251-information-to-sdio-core.patch

