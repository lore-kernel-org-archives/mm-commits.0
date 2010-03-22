From: akpm@linux-foundation.org
Subject: + davinci-mmc-add-a-function-to-control-reset-state-of-the-controller.patch added to -mm tree
Date: Mon, 22 Mar 2010 12:40:02 -0700
Message-ID: <201003221940.o2MJe3AS023156__10854.9327160747$1269286845$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896Ab0CVTkf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 15:40:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaithrika@ti.com, khilman@deeprootsystems.com, linux-mmc@vger.kernel.org, sudhakar.raj@ti.com, vipin.bhandari@ti.com


The patch titled
     davinci: mmc: add a function to control reset state of the controller
has been added to the -mm tree.  Its filename is
     davinci-mmc-add-a-function-to-control-reset-state-of-the-controller.patch

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
Subject: davinci: mmc: add a function to control reset state of the controller
From: Chaithrika U S <chaithrika@ti.com>

Add a helper function which will aid in changing the reset
status of the controller.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Vipin Bhandari <vipin.bhandari@ti.com>
Cc: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/davinci_mmc.c |   37 +++++++++++++------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff -puN drivers/mmc/host/davinci_mmc.c~davinci-mmc-add-a-function-to-control-reset-state-of-the-controller drivers/mmc/host/davinci_mmc.c
--- a/drivers/mmc/host/davinci_mmc.c~davinci-mmc-add-a-function-to-control-reset-state-of-the-controller
+++ a/drivers/mmc/host/davinci_mmc.c
@@ -909,19 +909,26 @@ static void mmc_davinci_cmd_done(struct 
 	}
 }
 
-static void
-davinci_abort_data(struct mmc_davinci_host *host, struct mmc_data *data)
+static inline void mmc_davinci_reset_ctrl(struct mmc_davinci_host *host,
+								int val)
 {
 	u32 temp;
 
-	/* reset command and data state machines */
 	temp = readl(host->base + DAVINCI_MMCCTL);
-	writel(temp | MMCCTL_CMDRST | MMCCTL_DATRST,
-		host->base + DAVINCI_MMCCTL);
+	if (val)	/* reset */
+		temp |= MMCCTL_CMDRST | MMCCTL_DATRST;
+	else		/* enable */
+		temp &= ~(MMCCTL_CMDRST | MMCCTL_DATRST);
 
-	temp &= ~(MMCCTL_CMDRST | MMCCTL_DATRST);
-	udelay(10);
 	writel(temp, host->base + DAVINCI_MMCCTL);
+	udelay(10);
+}
+
+static void
+davinci_abort_data(struct mmc_davinci_host *host, struct mmc_data *data)
+{
+	mmc_davinci_reset_ctrl(host, 1);
+	mmc_davinci_reset_ctrl(host, 0);
 }
 
 static irqreturn_t mmc_davinci_irq(int irq, void *dev_id)
@@ -1125,15 +1132,8 @@ static inline void mmc_davinci_cpufreq_d
 #endif
 static void __init init_mmcsd_host(struct mmc_davinci_host *host)
 {
-	/* DAT line portion is diabled and in reset state */
-	writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_DATRST,
-		host->base + DAVINCI_MMCCTL);
-
-	/* CMD line portion is diabled and in reset state */
-	writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_CMDRST,
-		host->base + DAVINCI_MMCCTL);
 
-	udelay(10);
+	mmc_davinci_reset_ctrl(host, 1);
 
 	writel(0, host->base + DAVINCI_MMCCLK);
 	writel(MMCCLK_CLKEN, host->base + DAVINCI_MMCCLK);
@@ -1141,12 +1141,7 @@ static void __init init_mmcsd_host(struc
 	writel(0x1FFF, host->base + DAVINCI_MMCTOR);
 	writel(0xFFFF, host->base + DAVINCI_MMCTOD);
 
-	writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_DATRST,
-		host->base + DAVINCI_MMCCTL);
-	writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_CMDRST,
-		host->base + DAVINCI_MMCCTL);
