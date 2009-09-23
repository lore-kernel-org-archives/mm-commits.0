From: akpm@linux-foundation.org
Subject: [merged] sdhci-of-dont-hard-code-inverted-write-protect-quirk.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:50 -0700
Message-ID: <200909231955.n8NJtoCZ003615__7681.39643264494$1253736454$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734AbZIWUHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:07:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, ben@fluff.org, david.vrabel@csr.com, galak@kernel.crashing.org, linux-mmc@vger.kernel.org, pierre@ossman.eu, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     sdhci-of: don't hard-code inverted write-protect quirk
has been removed from the -mm tree.  Its filename was
     sdhci-of-dont-hard-code-inverted-write-protect-quirk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdhci-of: don't hard-code inverted write-protect quirk
From: Anton Vorontsov <avorontsov@ru.mvista.com>

MPC85xx SOCs have normal write-protect state reporting, so we shouldn't
hard-code the quirk.

Instead, look for "sdhci,wp-inverted" property, plus check for
mpc837x_{rdb,mds} machines since older device trees don't specify the new
property.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Ben Dooks <ben@fluff.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-of.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci-of.c~sdhci-of-dont-hard-code-inverted-write-protect-quirk drivers/mmc/host/sdhci-of.c
--- a/drivers/mmc/host/sdhci-of.c~sdhci-of-dont-hard-code-inverted-write-protect-quirk
+++ a/drivers/mmc/host/sdhci-of.c
@@ -21,6 +21,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/mmc/host.h>
+#include <asm/machdep.h>
 #include "sdhci.h"
 
 struct sdhci_of_data {
@@ -175,7 +176,6 @@ static unsigned int esdhc_get_min_clock(
 static struct sdhci_of_data sdhci_esdhc = {
 	.quirks = SDHCI_QUIRK_FORCE_BLK_SZ_2048 |
 		  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
-		  SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
 		  SDHCI_QUIRK_NO_BUSY_IRQ |
 		  SDHCI_QUIRK_NONSTANDARD_CLOCK |
 		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
@@ -219,6 +219,15 @@ static int sdhci_of_resume(struct of_dev
 
 #endif
 
+static bool __devinit sdhci_of_wp_inverted(struct device_node *np)
+{
+	if (of_get_property(np, "sdhci,wp-inverted", NULL))
+		return true;
+
+	/* Old device trees don't have the wp-inverted property. */
+	return machine_is(mpc837x_rdb) || machine_is(mpc837x_mds);
+}
+
 static int __devinit sdhci_of_probe(struct of_device *ofdev,
 				 const struct of_device_id *match)
 {
@@ -261,6 +270,9 @@ static int __devinit sdhci_of_probe(stru
 	if (of_get_property(np, "sdhci,1-bit-only", NULL))
 		host->quirks |= SDHCI_QUIRK_FORCE_1_BIT_DATA;
 
+	if (sdhci_of_wp_inverted(np))
+		host->quirks |= SDHCI_QUIRK_INVERTED_WRITE_PROTECT;
+
 	clk = of_get_property(np, "clock-frequency", &size);
 	if (clk && size == sizeof(*clk) && *clk)
 		of_host->clock = *clk;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

