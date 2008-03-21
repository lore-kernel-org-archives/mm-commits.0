From: akpm@linux-foundation.org
Subject: - memstick-optimize-setup-of-jmicron-host-parameters.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:30:07 -0700
Message-ID: <200803212030.m2LKU7Wf008957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758992AbYCUUaJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:30:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: optimize setup of JMicron host parameters
has been removed from the -mm tree.  Its filename was
     memstick-optimize-setup-of-jmicron-host-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: optimize setup of JMicron host parameters
From: Alex Dubov <oakad@yahoo.com>

Set correct clock management values to improve over-all performance.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/jmb38x_ms.c |   60 ++++++++++++++--------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff -puN drivers/memstick/host/jmb38x_ms.c~memstick-optimize-setup-of-jmicron-host-parameters drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c~memstick-optimize-setup-of-jmicron-host-parameters
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -131,6 +131,12 @@ struct jmb38x_ms {
 #define PAD_PU_PD_ON_MS_SOCK0 0x5f8f0000
 #define PAD_PU_PD_ON_MS_SOCK1 0x0f0f0000
 
+#define CLOCK_CONTROL_40MHZ   0x00000001
+#define CLOCK_CONTROL_50MHZ   0x00000002
+#define CLOCK_CONTROL_60MHZ   0x00000008
+#define CLOCK_CONTROL_62_5MHZ 0x0000000c
+#define CLOCK_CONTROL_OFF     0x00000000
+
 enum {
 	CMD_READY    = 0x01,
 	FIFO_READY   = 0x02,
@@ -607,19 +613,18 @@ static void jmb38x_ms_reset(struct jmb38
 {
 	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
 
-	writel(host_ctl | HOST_CONTROL_RESET_REQ | HOST_CONTROL_RESET,
-	       host->addr + HOST_CONTROL);
+	writel(HOST_CONTROL_RESET_REQ, host->addr + HOST_CONTROL);
 
 	while (HOST_CONTROL_RESET_REQ
 	       & (host_ctl = readl(host->addr + HOST_CONTROL))) {
-		ndelay(100);
-		dev_dbg(&host->chip->pdev->dev, "reset\n");
+		ndelay(20);
+		dev_dbg(&host->chip->pdev->dev, "reset %08x\n", host_ctl);
 	}
 
-	writel(INT_STATUS_ALL, host->addr + INT_STATUS_ENABLE);
+	writel(HOST_CONTROL_RESET, host->addr + HOST_CONTROL);
+	mmiowb();
 	writel(INT_STATUS_ALL, host->addr + INT_SIGNAL_ENABLE);
-
-	dev_dbg(&host->chip->pdev->dev, "reset\n");
+	writel(INT_STATUS_ALL, host->addr + INT_STATUS_ENABLE);
 }
 
 static void jmb38x_ms_set_param(struct memstick_host *msh,
@@ -627,10 +632,8 @@ static void jmb38x_ms_set_param(struct m
 				int value)
 {
 	struct jmb38x_ms_host *host = memstick_priv(msh);
-	unsigned int host_ctl;
-	unsigned long flags;
-
-	spin_lock_irqsave(&host->lock, flags);
+	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
+	unsigned int clock_ctl = CLOCK_CONTROL_40MHZ, clock_delay = 0;
 
 	switch (param) {
 	case MEMSTICK_POWER:
@@ -638,60 +641,57 @@ static void jmb38x_ms_set_param(struct m
 			jmb38x_ms_reset(host);
 
 			writel(host->id ? PAD_PU_PD_ON_MS_SOCK1
-					  : PAD_PU_PD_ON_MS_SOCK0,
+					: PAD_PU_PD_ON_MS_SOCK0,
 			       host->addr + PAD_PU_PD);
 
 			writel(PAD_OUTPUT_ENABLE_MS,
 			       host->addr + PAD_OUTPUT_ENABLE);
 
-			host_ctl = readl(host->addr + HOST_CONTROL);
-			host_ctl |= 7;
-			writel(host_ctl | (HOST_CONTROL_POWER_EN
-					   | HOST_CONTROL_CLOCK_EN),
-			       host->addr + HOST_CONTROL);
+			host_ctl = 7;
+			host_ctl |= HOST_CONTROL_POWER_EN
+				 | HOST_CONTROL_CLOCK_EN;
+			writel(host_ctl, host->addr + HOST_CONTROL);
 
 			dev_dbg(&host->chip->pdev->dev, "power on\n");
 		} else if (value == MEMSTICK_POWER_OFF) {
-			writel(readl(host->addr + HOST_CONTROL)
-			       & ~(HOST_CONTROL_POWER_EN
-				   | HOST_CONTROL_CLOCK_EN),
-			       host->addr +  HOST_CONTROL);
+			host_ctl &= ~(HOST_CONTROL_POWER_EN
+				      | HOST_CONTROL_CLOCK_EN);
+			writel(host_ctl, host->addr +  HOST_CONTROL);
 			writel(0, host->addr + PAD_OUTPUT_ENABLE);
 			writel(PAD_PU_PD_OFF, host->addr + PAD_PU_PD);
 			dev_dbg(&host->chip->pdev->dev, "power off\n");
 		}
 		break;
 	case MEMSTICK_INTERFACE:
-		/* jmb38x_ms_reset(host); */
-
-		host_ctl = readl(host->addr + HOST_CONTROL);
 		host_ctl &= ~(3 << HOST_CONTROL_IF_SHIFT);
-		/* host_ctl |= 7; */
 
 		if (value == MEMSTICK_SERIAL) {
 			host_ctl &= ~HOST_CONTROL_FAST_CLK;
 			host_ctl |= HOST_CONTROL_IF_SERIAL
 				    << HOST_CONTROL_IF_SHIFT;
 			host_ctl |= HOST_CONTROL_REI;
-			writel(0, host->addr + CLOCK_DELAY);
+			clock_ctl = CLOCK_CONTROL_40MHZ;
+			clock_delay = 0;
 		} else if (value == MEMSTICK_PAR4) {
 			host_ctl |= HOST_CONTROL_FAST_CLK;
 			host_ctl |= HOST_CONTROL_IF_PAR4
 				    << HOST_CONTROL_IF_SHIFT;
 			host_ctl &= ~HOST_CONTROL_REI;
-			writel(4, host->addr + CLOCK_DELAY);
+			clock_ctl = CLOCK_CONTROL_40MHZ;
+			clock_delay = 4;
 		} else if (value == MEMSTICK_PAR8) {
 			host_ctl |= HOST_CONTROL_FAST_CLK;
 			host_ctl |= HOST_CONTROL_IF_PAR8
 				    << HOST_CONTROL_IF_SHIFT;
 			host_ctl &= ~HOST_CONTROL_REI;
-			writel(4, host->addr + CLOCK_DELAY);
+			clock_ctl = CLOCK_CONTROL_60MHZ;
+			clock_delay = 0;
 		}
 		writel(host_ctl, host->addr + HOST_CONTROL);
+		writel(clock_ctl, host->addr + CLOCK_CONTROL);
+		writel(clock_delay, host->addr + CLOCK_DELAY);
 		break;
 	};
