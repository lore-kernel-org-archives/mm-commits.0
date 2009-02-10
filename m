From: akpm@linux-foundation.org
Subject: + omap-mmc-replace-infinite-loops-with-timeouts.patch added to -mm tree
Date: Tue, 10 Feb 2009 13:09:54 -0800
Message-ID: <200902102109.n1AL9sjk019178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbZBJVNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 16:13:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpihet@mvista.com, alowe@mvista.com, drzeus-mmc@drzeus.cx, ext-adrian.hunter@nokia.com, jarkko.lavinen@nokia.com, tony@atomide.com


The patch titled
     omap: mmc: replace infinite loops with timeouts
has been added to the -mm tree.  Its filename is
     omap-mmc-replace-infinite-loops-with-timeouts.patch

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
Subject: omap: mmc: replace infinite loops with timeouts
From: Jean Pihet <jpihet@mvista.com>

Replace the 'while() ;' with a timeout

Signed-off-by: Jean Pihet <jpihet@mvista.com>
Cc: Andy Lowe <alowe@mvista.com>
Cc: Jean Pihet <jpihet@mvista.com>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   56 +++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 11 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap-mmc-replace-infinite-loops-with-timeouts drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap-mmc-replace-infinite-loops-with-timeouts
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -102,6 +102,8 @@
 #define OMAP_MMC_DATADIR_READ	1
 #define OMAP_MMC_DATADIR_WRITE	2
 #define MMC_TIMEOUT_MS		20
+#define MMC_TIMEOUT_WAIT	100	/* Active wait duration, in usec */
+#define MMC_TIMEOUT_WAIT_LOOPS	((MMC_TIMEOUT_MS * 1000) / MMC_TIMEOUT_WAIT)
 #define OMAP_MMC_MASTER_CLOCK	96000000
 #define DRIVER_NAME		"mmci-omap-hs"
 
@@ -384,6 +386,7 @@ static irqreturn_t mmc_omap_irq(int irq,
 	struct mmc_omap_host *host = dev_id;
 	struct mmc_data *data;
 	int end_cmd = 0, end_trans = 0, status;
+	unsigned long timeout_counter;
 
 	if (host->cmd == NULL && host->data == NULL) {
 		OMAP_HSMMC_WRITE(host->base, STAT,
@@ -406,9 +409,17 @@ static irqreturn_t mmc_omap_irq(int irq,
 					OMAP_HSMMC_WRITE(host->base, SYSCTL,
 						OMAP_HSMMC_READ(host->base,
 								SYSCTL) | SRC);
-					while (OMAP_HSMMC_READ(host->base,
-							SYSCTL) & SRC)
-						;
+					timeout_counter = 0;
+					while ((OMAP_HSMMC_READ(host->base,
+								SYSCTL) & SRC)
+						&& (timeout_counter++ <
+								MMC_TIMEOUT_WAIT_LOOPS))
+							udelay(MMC_TIMEOUT_WAIT);
+
+					if (OMAP_HSMMC_READ(host->base,
+								SYSCTL)	& SRC)
+						dev_err(mmc_dev(host->mmc),
+							"Timeout waiting on SRC\n");
 
 					host->cmd->error = -ETIMEDOUT;
 				} else {
@@ -421,9 +432,17 @@ static irqreturn_t mmc_omap_irq(int irq,
 				OMAP_HSMMC_WRITE(host->base, SYSCTL,
 					OMAP_HSMMC_READ(host->base,
 							SYSCTL) | SRD);
-				while (OMAP_HSMMC_READ(host->base,
-						SYSCTL) & SRD)
-					;
+				timeout_counter = 0;
+				while ((OMAP_HSMMC_READ(host->base,
+							SYSCTL) & SRD)
+					&& (timeout_counter++ <
+							MMC_TIMEOUT_WAIT_LOOPS))
+					udelay(MMC_TIMEOUT_WAIT);
+
+				if (OMAP_HSMMC_READ(host->base,
+							SYSCTL)	& SRD)
+					dev_err(mmc_dev(host->mmc),
+						"Timeout waiting on SRD\n");
 			}
 		}
 		if ((status & DATA_TIMEOUT) ||
@@ -436,9 +455,17 @@ static irqreturn_t mmc_omap_irq(int irq,
 				OMAP_HSMMC_WRITE(host->base, SYSCTL,
 					OMAP_HSMMC_READ(host->base,
 							SYSCTL) | SRD);
-				while (OMAP_HSMMC_READ(host->base,
-						SYSCTL) & SRD)
-					;
+				timeout_counter = 0;
+				while ((OMAP_HSMMC_READ(host->base,
+							SYSCTL) & SRD)
+					&& (timeout_counter++ <
+							MMC_TIMEOUT_WAIT_LOOPS))
+					udelay(MMC_TIMEOUT_WAIT);
+
+				if (OMAP_HSMMC_READ(host->base,
+							SYSCTL)	& SRD)
+					dev_err(mmc_dev(host->mmc),
+						"Timeout waiting on SRD\n");
 				end_trans = 1;
 			}
 		}
@@ -524,6 +551,7 @@ static void mmc_omap_detect(struct work_
 {
 	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
 						mmc_carddetect_work);
+	unsigned long timeout;
 
 	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
 	if (host->carddetect) {
@@ -531,8 +559,14 @@ static void mmc_omap_detect(struct work_
 	} else {
 		OMAP_HSMMC_WRITE(host->base, SYSCTL,
 			OMAP_HSMMC_READ(host->base, SYSCTL) | SRD);
-		while (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
-			;
+		/* Wait till the SRD bit is reset */
+		timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
+		while ((OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
+			&& time_before(jiffies, timeout))
+			msleep(1);
+
+		if (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
+			dev_err(mmc_dev(host->mmc), "Timeout waiting on SRD\n");
 
 		mmc_detect_change(host->mmc, (HZ * 50) / 1000);
 	}
_

Patches currently in -mm which might be from jpihet@mvista.com are

omap-mmc-recover-from-transfer-failures-resend.patch
omap-mmc-replace-infinite-loops-with-timeouts.patch

