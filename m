From: akpm@linux-foundation.org
Subject: + sdhci-get-rid-of-frequency-too-high-flood-when-using-esdhc.patch added to -mm tree
Date: Fri, 24 Jul 2009 15:58:01 -0700
Message-ID: <200907242258.n6OMw1C6004064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754995AbZGXW6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 18:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, drzeus@drzeus.cx, ian@mnementh.co.uk, matt@console-pimps.org, roberto.foglietta@gmail.com


The patch titled
     sdhci: get rid of "frequency too high" flood when using eSDHC
has been added to the -mm tree.  Its filename is
     sdhci-get-rid-of-frequency-too-high-flood-when-using-esdhc.patch

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
Subject: sdhci: get rid of "frequency too high" flood when using eSDHC
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Since commit 8dfd0374be84793360db7fff2e635d2cd3bbcb21 ("MMC core: limit
minimum initialization frequency to 400kHz") MMC core checks for minimum
frequency, and that causes following messages flood when using eSDHC
controllers:

  ...
  mmc0: Minimum clock frequency too high for identification mode
  mmc0: Minimum clock frequency too high for identification mode
  ...

The warnings are legitimate, since if we'd use 133 MHz clocks for standard
SDHCI controllers, we'd not able to scale frequency down to 400 kHz.

But eSDHC controllers have a non-standard SD clock management, so we can
divide clock by 256 * 16, not just 256.

This patch introduces get_min_clock() callback for sdhci core and
implements it for sdhci-of driver, and thus fixes the issue.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-of.c |    8 ++++++++
 drivers/mmc/host/sdhci.c    |    5 ++++-
 drivers/mmc/host/sdhci.h    |    1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci-of.c~sdhci-get-rid-of-frequency-too-high-flood-when-using-esdhc drivers/mmc/host/sdhci-of.c
--- a/drivers/mmc/host/sdhci-of.c~sdhci-get-rid-of-frequency-too-high-flood-when-using-esdhc
+++ a/drivers/mmc/host/sdhci-of.c
@@ -158,6 +158,13 @@ static unsigned int esdhc_get_max_clock(
 	return of_host->clock;
 }
 
+static unsigned int esdhc_get_min_clock(struct sdhci_host *host)
+{
+	struct sdhci_of_host *of_host = sdhci_priv(host);
+
+	return of_host->clock / 256 / 16;
+}
+
 static unsigned int esdhc_get_timeout_clock(struct sdhci_host *host)
 {
 	struct sdhci_of_host *of_host = sdhci_priv(host);
@@ -184,6 +191,7 @@ static struct sdhci_of_data sdhci_esdhc 
 		.set_clock = esdhc_set_clock,
 		.enable_dma = esdhc_enable_dma,
 		.get_max_clock = esdhc_get_max_clock,
+		.get_min_clock = esdhc_get_min_clock,
 		.get_timeout_clock = esdhc_get_timeout_clock,
 	},
 };
diff -puN drivers/mmc/host/sdhci.c~sdhci-get-rid-of-frequency-too-high-flood-when-using-esdhc drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-get-rid-of-frequency-too-high-flood-when-using-esdhc
+++ a/drivers/mmc/host/sdhci.c
@@ -1766,7 +1766,10 @@ int sdhci_add_host(struct sdhci_host *ho
 	 * Set host parameters.
 	 */
 	mmc->ops = &sdhci_ops;
-	mmc->f_min = host->max_clk / 256;
+	if (host->ops->get_min_clock)
+		mmc->f_min = host->ops->get_min_clock(host);
+	else
+		mmc->f_min = host->max_clk / 256;
 	mmc->f_max = host->max_clk;
 	mmc->caps = MMC_CAP_SDIO_IRQ;
 
diff -puN drivers/mmc/host/sdhci.h~sdhci-get-rid-of-frequency-too-high-flood-when-using-esdhc drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-get-rid-of-frequency-too-high-flood-when-using-esdhc
+++ a/drivers/mmc/host/sdhci.h
@@ -302,6 +302,7 @@ struct sdhci_ops {
 
 	int		(*enable_dma)(struct sdhci_host *host);
 	unsigned int	(*get_max_clock)(struct sdhci_host *host);
+	unsigned int	(*get_min_clock)(struct sdhci_host *host);
 	unsigned int	(*get_timeout_clock)(struct sdhci_host *host);
 };
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-sst25l-non-jedec-spi-flash-driver-update.patch
mtd-sst25l-non-jedec-spi-flash-driver-fix.patch
sdhci-get-rid-of-frequency-too-high-flood-when-using-esdhc.patch

