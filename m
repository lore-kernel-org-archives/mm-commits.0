From: akpm@linux-foundation.org
Subject: [merged] sdhci-of-cleanup-esdhcs-set_clock-a-little-bit.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:53 -0700
Message-ID: <200909231955.n8NJtrV2003738__6350.53100199929$1253735860$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753726AbZIWT5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, ben@fluff.org, david.vrabel@csr.com, galak@kernel.crashing.org, linux-mmc@vger.kernel.org, pierre@ossman.eu, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     sdhci-of: cleanup eSDHC's set_clock() a little bit
has been removed from the -mm tree.  Its filename was
     sdhci-of-cleanup-esdhcs-set_clock-a-little-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdhci-of: cleanup eSDHC's set_clock() a little bit
From: Anton Vorontsov <avorontsov@ru.mvista.com>

- Get rid of incomprehensible "if { for { if } }" construction for the
  exponential divisor calculation. The first if statement isn't correct
  at all, since it should check for "host->max_clk / pre_div / 16 >
  clock". The error doesn't cause any bugs because the check in the for
  loop does the right thing, and so the outer check becomes useless;

- For the linear divisor do the same: a single while statement is more
  readable than for + if construction;

- Add dev_dbg() that prints desired and actual clock frequency.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Ben Dooks <ben@fluff.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-of.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN drivers/mmc/host/sdhci-of.c~sdhci-of-cleanup-esdhcs-set_clock-a-little-bit drivers/mmc/host/sdhci-of.c
--- a/drivers/mmc/host/sdhci-of.c~sdhci-of-cleanup-esdhcs-set_clock-a-little-bit
+++ a/drivers/mmc/host/sdhci-of.c
@@ -121,8 +121,8 @@ static void esdhc_writeb(struct sdhci_ho
 
 static void esdhc_set_clock(struct sdhci_host *host, unsigned int clock)
 {
-	int div;
 	int pre_div = 2;
+	int div = 1;
 
 	clrbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_IPGEN |
 		  ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN | ESDHC_CLOCK_MASK);
@@ -130,17 +130,14 @@ static void esdhc_set_clock(struct sdhci
 	if (clock == 0)
 		goto out;
 
-	if (host->max_clk / 16 > clock) {
-		for (; pre_div < 256; pre_div *= 2) {
-			if (host->max_clk / pre_div < clock * 16)
-				break;
-		}
-	}
+	while (host->max_clk / pre_div / 16 > clock && pre_div < 256)
+		pre_div *= 2;
 
-	for (div = 1; div <= 16; div++) {
-		if (host->max_clk / (div * pre_div) <= clock)
-			break;
-	}
+	while (host->max_clk / pre_div / div > clock && div < 16)
+		div++;
+
+	dev_dbg(mmc_dev(host->mmc), "desired SD clock: %d, actual: %d\n",
+		clock, host->max_clk / pre_div / div);
 
 	pre_div >>= 1;
 	div--;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

