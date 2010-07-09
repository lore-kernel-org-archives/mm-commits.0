From: akpm@linux-foundation.org
Subject: + sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value.patch added to -mm tree
Date: Fri, 09 Jul 2010 14:26:45 -0700
Message-ID: <201007092126.o69LQj43026472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672Ab0GIV13 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 17:27:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, avorontsov@mvista.com, ben@simtec.co.uk, kyungmin.park@samsung.com


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
sources.  This patch adds a new quirk to SDHCI driver to calculate the
minimal supported clock frequency.

This fixes the flood of the following warnings on Samsung S5PV210 SoCs:
mmc0: Minimum clock frequency too high for identification mode

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Anton Vorontsov <avorontsov@mvista.com>
Cc: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-of-esdhc.c |    1 
 drivers/mmc/host/sdhci-s3c.c      |   29 ++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c          |    2 -
 drivers/mmc/host/sdhci.h          |    2 +
 4 files changed, 33 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci-of-esdhc.c~sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value drivers/mmc/host/sdhci-of-esdhc.c
--- a/drivers/mmc/host/sdhci-of-esdhc.c~sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value
+++ a/drivers/mmc/host/sdhci-of-esdhc.c
@@ -124,6 +124,7 @@ struct sdhci_of_data sdhci_esdhc = {
 		  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
 		  SDHCI_QUIRK_NO_BUSY_IRQ |
 		  SDHCI_QUIRK_NONSTANDARD_CLOCK |
+		  SDHCI_QUIRK_NONSTANDARD_MINCLOCK |
 		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
 		  SDHCI_QUIRK_PIO_NEEDS_DELAY |
 		  SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET |
diff -puN drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value drivers/mmc/host/sdhci-s3c.c
--- a/drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value
+++ a/drivers/mmc/host/sdhci-s3c.c
@@ -209,10 +209,37 @@ static void sdhci_s3c_set_clock(struct s
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
 	.get_timeout_clock	= sdhci_s3c_get_timeout_clk,
 	.set_clock		= sdhci_s3c_set_clock,
+	.get_min_clock		= sdhci_s3c_get_min_clock,
 };
 
 static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
@@ -316,6 +343,8 @@ static int __devinit sdhci_s3c_probe(str
 	host->quirks = 0;
 	host->irq = irq;
 
+	host->quirks |= SDHCI_QUIRK_NONSTANDARD_MINCLOCK;
+
 	/* Setup quirks for the controller */
 	host->quirks |= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC;
 
diff -puN drivers/mmc/host/sdhci.c~sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value
+++ a/drivers/mmc/host/sdhci.c
@@ -1792,7 +1792,7 @@ int sdhci_add_host(struct sdhci_host *ho
 	 * Set host parameters.
 	 */
 	mmc->ops = &sdhci_ops;
-	if (host->quirks & SDHCI_QUIRK_NONSTANDARD_CLOCK &&
+	if (host->quirks & SDHCI_QUIRK_NONSTANDARD_MINCLOCK &&
 			host->ops->get_min_clock)
 		mmc->f_min = host->ops->get_min_clock(host);
 	else
diff -puN drivers/mmc/host/sdhci.h~sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value
+++ a/drivers/mmc/host/sdhci.h
@@ -245,6 +245,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_NO_HISPD_BIT			(1<<27)
 /* Controller is missing device caps. Use caps provided by host */
 #define SDHCI_QUIRK_MISSING_CAPS			(1<<28)
+/* Controller has nonstandard clock management */
+#define SDHCI_QUIRK_NONSTANDARD_MINCLOCK		(1<<29)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
linux-next.patch
sdhci-s3c-add-missing-remove-function.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value-fix.patch
sdhci-s3c-add-support-for-new-card-detection-methods.patch

