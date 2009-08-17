From: akpm@linux-foundation.org
Subject: + sdhci-of-fix-high-speed-cards-recognition.patch added to -mm tree
Date: Mon, 17 Aug 2009 16:09:06 -0700
Message-ID: <200908172309.n7HN97B6014787__4728.33662429384$1250550851$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758230AbZHQXN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 19:13:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ben@fluff.org, david.vrabel@csr.com, galak@kernel.crashing.org, linux-mmc@vger.kernel.org, pierre@ossman.eu, s.hauer@pengutronix.de


The patch titled
     sdhci-of: fix high-speed cards recognition
has been added to the -mm tree.  Its filename is
     sdhci-of-fix-high-speed-cards-recognition.patch

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
Subject: sdhci-of: fix high-speed cards recognition
From: Anton Vorontsov <avorontsov@ru.mvista.com>

eSDHC fails to recognize some SDHS cards, throwing timeout errors:

  mmc0: error -110 whilst initialising SD card

That's because we calculate timeout value in a wrong way: on eSDHC hosts
the timeout clock is derivied from the SD clock, which is set dynamically.

As David Vrabel suggested, deriving timeout clock from SD clock is a
common scheme, so let's implement DATA_TIMEOUT_USES_SDCLK quirk and use it
for eSDHC hosts.

Also, from now on we don't need esdhc_get_timeout_clock() callback, so
remove it.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Ben Dooks <ben@fluff.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-of.c |    9 +--------
 drivers/mmc/host/sdhci.c    |    9 +++++++--
 drivers/mmc/host/sdhci.h    |    2 ++
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/mmc/host/sdhci-of.c~sdhci-of-fix-high-speed-cards-recognition drivers/mmc/host/sdhci-of.c
--- a/drivers/mmc/host/sdhci-of.c~sdhci-of-fix-high-speed-cards-recognition
+++ a/drivers/mmc/host/sdhci-of.c
@@ -172,19 +172,13 @@ static unsigned int esdhc_get_min_clock(
 	return of_host->clock / 256 / 16;
 }
 
-static unsigned int esdhc_get_timeout_clock(struct sdhci_host *host)
-{
-	struct sdhci_of_host *of_host = sdhci_priv(host);
-
-	return of_host->clock / 1000;
-}
-
 static struct sdhci_of_data sdhci_esdhc = {
 	.quirks = SDHCI_QUIRK_FORCE_BLK_SZ_2048 |
 		  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
 		  SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
 		  SDHCI_QUIRK_NO_BUSY_IRQ |
 		  SDHCI_QUIRK_NONSTANDARD_CLOCK |
+		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
 		  SDHCI_QUIRK_PIO_NEEDS_DELAY |
 		  SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET |
 		  SDHCI_QUIRK_NO_CARD_NO_RESET,
@@ -199,7 +193,6 @@ static struct sdhci_of_data sdhci_esdhc 
 		.enable_dma = esdhc_enable_dma,
 		.get_max_clock = esdhc_get_max_clock,
 		.get_min_clock = esdhc_get_min_clock,
-		.get_timeout_clock = esdhc_get_timeout_clock,
 	},
 };
 
diff -puN drivers/mmc/host/sdhci.c~sdhci-of-fix-high-speed-cards-recognition drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-of-fix-high-speed-cards-recognition
+++ a/drivers/mmc/host/sdhci.c
@@ -591,6 +591,9 @@ static u8 sdhci_calc_timeout(struct sdhc
 	target_timeout = data->timeout_ns / 1000 +
 		data->timeout_clks / host->clock;
 
+	if (host->quirks & SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)
+		host->timeout_clk = host->clock / 1000;
+
 	/*
 	 * Figure out needed cycles.
 	 * We do this in steps in order to fit inside a 32 bit int.
@@ -1757,13 +1760,15 @@ int sdhci_add_host(struct sdhci_host *ho
 	host->timeout_clk =
 		(caps & SDHCI_TIMEOUT_CLK_MASK) >> SDHCI_TIMEOUT_CLK_SHIFT;
 	if (host->timeout_clk == 0) {
-		if (!host->ops->get_timeout_clock) {
+		if (host->ops->get_timeout_clock) {
+			host->timeout_clk = host->ops->get_timeout_clock(host);
+		} else if (!(host->quirks &
+				SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)) {
 			printk(KERN_ERR
 			       "%s: Hardware doesn't specify timeout clock "
 			       "frequency.\n", mmc_hostname(mmc));
 			return -ENODEV;
 		}
-		host->timeout_clk = host->ops->get_timeout_clock(host);
 	}
 	if (caps & SDHCI_TIMEOUT_CLK_UNIT)
 		host->timeout_clk *= 1000;
diff -puN drivers/mmc/host/sdhci.h~sdhci-of-fix-high-speed-cards-recognition drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-of-fix-high-speed-cards-recognition
+++ a/drivers/mmc/host/sdhci.h
@@ -232,6 +232,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_FORCE_1_BIT_DATA			(1<<22)
 /* Controller needs 10ms delay between applying power and clock */
 #define SDHCI_QUIRK_DELAY_AFTER_POWER			(1<<23)
+/* Controller uses SDCLK instead of TMCLK for data timeouts */
+#define SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK		(1<<24)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-m25p80-fix-null-pointer-dereference-bug.patch
sdhci-be-more-strict-with-get_min_clock-usage.patch
sdhci-of-fix-sd-clock-calculation.patch
sdhci-of-avoid-writing-reserved-bits-into-host-control-register.patch
sdhci-of-fix-high-speed-cards-recognition.patch
powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc.patch
sdhci-of-dont-hard-code-inverted-write-protect-quirk.patch
sdhci-of-cleanup-esdhcs-set_clock-a-little-bit.patch
powerpc-85xx-add-esdhc-support-for-mpc8536ds-boards.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch

