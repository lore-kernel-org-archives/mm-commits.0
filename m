From: akpm@linux-foundation.org
Subject: + omap-mmc-replace-infinite-loops-with-timeouts-update.patch added to -mm tree
Date: Wed, 11 Feb 2009 14:49:31 -0800
Message-ID: <200902112249.n1BMnVFb016784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237AbZBKWz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 17:55:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpihet@mvista.com, alowe@mvista.com, drzeus-mmc@drzeus.cx, ext-adrian.hunter@nokia.com, jarkko.lavinen@nokia.com, tony@atomide.com


The patch titled
     omap-mmc-replace-infinite-loops-with-timeouts update
has been added to the -mm tree.  Its filename is
     omap-mmc-replace-infinite-loops-with-timeouts-update.patch

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
Subject: omap-mmc-replace-infinite-loops-with-timeouts update
From: Jean Pihet <jpihet@mvista.com>

Signed-off-by: Jean Pihet <jpihet@mvista.com>
Cc: Andy Lowe <alowe@mvista.com>
Cc: Jean Pihet <jpihet@mvista.com>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   88 ++++++++++----------------------
 1 file changed, 30 insertions(+), 58 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap-mmc-replace-infinite-loops-with-timeouts-update drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap-mmc-replace-infinite-loops-with-timeouts-update
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -102,8 +102,6 @@
 #define OMAP_MMC_DATADIR_READ	1
 #define OMAP_MMC_DATADIR_WRITE	2
 #define MMC_TIMEOUT_MS		20
-#define MMC_TIMEOUT_WAIT	100	/* Active wait duration, in usec */
-#define MMC_TIMEOUT_WAIT_LOOPS	((MMC_TIMEOUT_MS * 1000) / MMC_TIMEOUT_WAIT)
 #define OMAP_MMC_MASTER_CLOCK	96000000
 #define DRIVER_NAME		"mmci-omap-hs"
 
@@ -377,6 +375,32 @@ static void mmc_omap_report_irq(struct m
 }
 #endif  /* CONFIG_MMC_DEBUG */
 
+/*
+ * MMC controller internal state machines reset
+ *
+ * Used to reset command or data internal state machines, using respectively
+ *  SRC or SRD bit of SYSCTL register
+ * Can be called from interrupt context
+ */
+static inline void mmc_omap_reset_controller_fsm(struct mmc_omap_host *host,
+		unsigned long bit)
+{
+	unsigned long i = 0;
+	unsigned long limit = (loops_per_jiffy *
+				msecs_to_jiffies(MMC_TIMEOUT_MS));
+
+	OMAP_HSMMC_WRITE(host->base, SYSCTL,
+			 OMAP_HSMMC_READ(host->base, SYSCTL) | bit);
+
+	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit) &&
+		(i++ < limit))
+		cpu_relax();
+
+	if (OMAP_HSMMC_READ(host->base, SYSCTL) & bit)
+		dev_err(mmc_dev(host->mmc),
+			"Timeout waiting on controller reset in %s\n",
+			__func__);
+}
 
 /*
  * MMC controller IRQ handler
@@ -386,7 +410,6 @@ static irqreturn_t mmc_omap_irq(int irq,
 	struct mmc_omap_host *host = dev_id;
 	struct mmc_data *data;
 	int end_cmd = 0, end_trans = 0, status;
-	unsigned long timeout_counter;
 
 	if (host->cmd == NULL && host->data == NULL) {
 		OMAP_HSMMC_WRITE(host->base, STAT,
@@ -406,21 +429,7 @@ static irqreturn_t mmc_omap_irq(int irq,
 			(status & CMD_CRC)) {
 			if (host->cmd) {
 				if (status & CMD_TIMEOUT) {
-					OMAP_HSMMC_WRITE(host->base, SYSCTL,
-						OMAP_HSMMC_READ(host->base,
-								SYSCTL) | SRC);
-					timeout_counter = 0;
-					while ((OMAP_HSMMC_READ(host->base,
-								SYSCTL) & SRC)
-						&& (timeout_counter++ <
-								MMC_TIMEOUT_WAIT_LOOPS))
-							udelay(MMC_TIMEOUT_WAIT);
-
-					if (OMAP_HSMMC_READ(host->base,
-								SYSCTL)	& SRC)
-						dev_err(mmc_dev(host->mmc),
-							"Timeout waiting on SRC\n");
-
+					mmc_omap_reset_controller_fsm(host, SRC);
 					host->cmd->error = -ETIMEDOUT;
 				} else {
 					host->cmd->error = -EILSEQ;
@@ -429,20 +438,7 @@ static irqreturn_t mmc_omap_irq(int irq,
 			}
 			if (host->data) {
 				mmc_dma_cleanup(host);
-				OMAP_HSMMC_WRITE(host->base, SYSCTL,
-					OMAP_HSMMC_READ(host->base,
-							SYSCTL) | SRD);
-				timeout_counter = 0;
-				while ((OMAP_HSMMC_READ(host->base,
-							SYSCTL) & SRD)
-					&& (timeout_counter++ <
-							MMC_TIMEOUT_WAIT_LOOPS))
-					udelay(MMC_TIMEOUT_WAIT);
-
-				if (OMAP_HSMMC_READ(host->base,
-							SYSCTL)	& SRD)
-					dev_err(mmc_dev(host->mmc),
-						"Timeout waiting on SRD\n");
+				mmc_omap_reset_controller_fsm(host, SRD);
 			}
 		}
 		if ((status & DATA_TIMEOUT) ||
@@ -452,20 +448,7 @@ static irqreturn_t mmc_omap_irq(int irq,
 					mmc_dma_cleanup(host);
 				else
 					host->data->error = -EILSEQ;
-				OMAP_HSMMC_WRITE(host->base, SYSCTL,
-					OMAP_HSMMC_READ(host->base,
-							SYSCTL) | SRD);
-				timeout_counter = 0;
-				while ((OMAP_HSMMC_READ(host->base,
-							SYSCTL) & SRD)
-					&& (timeout_counter++ <
-							MMC_TIMEOUT_WAIT_LOOPS))
-					udelay(MMC_TIMEOUT_WAIT);
-
-				if (OMAP_HSMMC_READ(host->base,
-							SYSCTL)	& SRD)
-					dev_err(mmc_dev(host->mmc),
-						"Timeout waiting on SRD\n");
+				mmc_omap_reset_controller_fsm(host, SRD);
 				end_trans = 1;
 			}
 		}
@@ -551,23 +534,12 @@ static void mmc_omap_detect(struct work_
 {
 	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
 						mmc_carddetect_work);
-	unsigned long timeout;
 
 	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
 	if (host->carddetect) {
 		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
 	} else {
-		OMAP_HSMMC_WRITE(host->base, SYSCTL,
-			OMAP_HSMMC_READ(host->base, SYSCTL) | SRD);
-		/* Wait till the SRD bit is reset */
-		timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
-		while ((OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
-			&& time_before(jiffies, timeout))
-			msleep(1);
-
-		if (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
-			dev_err(mmc_dev(host->mmc), "Timeout waiting on SRD\n");
