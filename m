From: akpm@linux-foundation.org
Subject: + sdhci-of-dont-hard-code-inverted-write-protect-quirk.patch added to -mm tree
Date: Mon, 17 Aug 2009 16:09:12 -0700
Message-ID: <200908172309.n7HN9Cgp014849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758223AbZHQXNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 19:13:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ben@fluff.org, david.vrabel@csr.com, galak@kernel.crashing.org, linux-mmc@vger.kernel.org, pierre@ossman.eu, s.hauer@pengutronix.de


The patch titled
     sdhci-of: don't hard-code inverted write-protect quirk
has been added to the -mm tree.  Its filename is
     sdhci-of-dont-hard-code-inverted-write-protect-quirk.patch

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

