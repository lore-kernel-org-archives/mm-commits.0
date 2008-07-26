From: akpm@linux-foundation.org
Subject: - memstick-allow-set_param-method-to-return-an-error-code.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:14:00 -0700
Message-ID: <200807262114.m6QLE0Fp019649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757500AbYGZVOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:14:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: allow "set_param" method to return an error code
has been removed from the -mm tree.  Its filename was
     memstick-allow-set_param-method-to-return-an-error-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: allow "set_param" method to return an error code
From: Alex Dubov <oakad@yahoo.com>

Some controllers (Jmicron, for instance) can report temporal failure
condition during power-on.  It is desirable to account for this using a
return value of "set_param" device method.  The return value can also be
handy to distinguish between supported and unsupported device parameters
in run time.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c  |   18 +++++--
 drivers/memstick/host/jmb38x_ms.c |   67 ++++++++++++++++++++--------
 drivers/memstick/host/tifm_ms.c   |   17 +++----
 include/linux/memstick.h          |    2 
 4 files changed, 71 insertions(+), 33 deletions(-)

diff -puN drivers/memstick/core/memstick.c~memstick-allow-set_param-method-to-return-an-error-code drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-allow-set_param-method-to-return-an-error-code
+++ a/drivers/memstick/core/memstick.c
@@ -415,10 +415,14 @@ err_out:
 	return NULL;
 }
 
-static void memstick_power_on(struct memstick_host *host)
+static int memstick_power_on(struct memstick_host *host)
 {
-	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
-	host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
+	int rc = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
+
+	if (!rc)
+		rc = host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
+
+	return rc;
 }
 
 static void memstick_check(struct work_struct *work)
@@ -573,11 +577,15 @@ EXPORT_SYMBOL(memstick_suspend_host);
  */
 void memstick_resume_host(struct memstick_host *host)
 {
+	int rc = 0;
+
 	mutex_lock(&host->lock);
 	if (host->card)
-		memstick_power_on(host);
+		rc = memstick_power_on(host);
 	mutex_unlock(&host->lock);
-	memstick_detect_change(host);
+
+	if (!rc)
+		memstick_detect_change(host);
 }
 EXPORT_SYMBOL(memstick_resume_host);
 
diff -puN drivers/memstick/host/jmb38x_ms.c~memstick-allow-set_param-method-to-return-an-error-code drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c~memstick-allow-set_param-method-to-return-an-error-code
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -609,36 +609,68 @@ static void jmb38x_ms_request(struct mem
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-static void jmb38x_ms_reset(struct jmb38x_ms_host *host)
+static int jmb38x_ms_reset(struct jmb38x_ms_host *host)
 {
-	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
+	int cnt;
+
+	writel(HOST_CONTROL_RESET_REQ | HOST_CONTROL_CLOCK_EN
+	       | readl(host->addr + HOST_CONTROL),
+	       host->addr + HOST_CONTROL);
+	mmiowb();
+
+	for (cnt = 0; cnt < 20; ++cnt) {
+		if (!(HOST_CONTROL_RESET_REQ
+		      & readl(host->addr + HOST_CONTROL)))
+			goto reset_next;
+
+		ndelay(20);
+	}
+	dev_dbg(&host->chip->pdev->dev, "reset_req timeout\n");
+	return -EIO;
+
+reset_next:
+	writel(HOST_CONTROL_RESET | HOST_CONTROL_CLOCK_EN
+	       | readl(host->addr + HOST_CONTROL),
+	       host->addr + HOST_CONTROL);
+	mmiowb();
 
-	writel(HOST_CONTROL_RESET_REQ, host->addr + HOST_CONTROL);
+	for (cnt = 0; cnt < 20; ++cnt) {
+		if (!(HOST_CONTROL_RESET
+		      & readl(host->addr + HOST_CONTROL)))
+			goto reset_ok;
 
-	while (HOST_CONTROL_RESET_REQ
-	       & (host_ctl = readl(host->addr + HOST_CONTROL))) {
 		ndelay(20);
-		dev_dbg(&host->chip->pdev->dev, "reset %08x\n", host_ctl);
 	}
+	dev_dbg(&host->chip->pdev->dev, "reset timeout\n");
+	return -EIO;
 
-	writel(HOST_CONTROL_RESET, host->addr + HOST_CONTROL);
+reset_ok:
 	mmiowb();
 	writel(INT_STATUS_ALL, host->addr + INT_SIGNAL_ENABLE);
 	writel(INT_STATUS_ALL, host->addr + INT_STATUS_ENABLE);
+	return 0;
 }
 
-static void jmb38x_ms_set_param(struct memstick_host *msh,
-				enum memstick_param param,
-				int value)
+static int jmb38x_ms_set_param(struct memstick_host *msh,
+			       enum memstick_param param,
+			       int value)
 {
 	struct jmb38x_ms_host *host = memstick_priv(msh);
 	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
 	unsigned int clock_ctl = CLOCK_CONTROL_40MHZ, clock_delay = 0;
+	int rc = 0;
 
 	switch (param) {
 	case MEMSTICK_POWER:
 		if (value == MEMSTICK_POWER_ON) {
-			jmb38x_ms_reset(host);
+			rc = jmb38x_ms_reset(host);
+			if (rc)
+				return rc;
+
+			host_ctl = 7;
+			host_ctl |= HOST_CONTROL_POWER_EN
+				 | HOST_CONTROL_CLOCK_EN;
+			writel(host_ctl, host->addr + HOST_CONTROL);
 
 			writel(host->id ? PAD_PU_PD_ON_MS_SOCK1
 					: PAD_PU_PD_ON_MS_SOCK0,
@@ -647,11 +679,7 @@ static void jmb38x_ms_set_param(struct m
 			writel(PAD_OUTPUT_ENABLE_MS,
 			       host->addr + PAD_OUTPUT_ENABLE);
 
-			host_ctl = 7;
-			host_ctl |= HOST_CONTROL_POWER_EN
-				 | HOST_CONTROL_CLOCK_EN;
-			writel(host_ctl, host->addr + HOST_CONTROL);
-
+			msleep(10);
 			dev_dbg(&host->chip->pdev->dev, "power on\n");
 		} else if (value == MEMSTICK_POWER_OFF) {
 			host_ctl &= ~(HOST_CONTROL_POWER_EN
@@ -660,7 +688,8 @@ static void jmb38x_ms_set_param(struct m
 			writel(0, host->addr + PAD_OUTPUT_ENABLE);
 			writel(PAD_PU_PD_OFF, host->addr + PAD_PU_PD);
 			dev_dbg(&host->chip->pdev->dev, "power off\n");
-		}
+		} else
+			return -EINVAL;
 		break;
 	case MEMSTICK_INTERFACE:
 		host_ctl &= ~(3 << HOST_CONTROL_IF_SHIFT);
@@ -686,12 +715,14 @@ static void jmb38x_ms_set_param(struct m
 			host_ctl &= ~HOST_CONTROL_REI;
 			clock_ctl = CLOCK_CONTROL_60MHZ;
 			clock_delay = 0;
-		}
+		} else
+			return -EINVAL;
 		writel(host_ctl, host->addr + HOST_CONTROL);
 		writel(clock_ctl, host->addr + CLOCK_CONTROL);
 		writel(clock_delay, host->addr + CLOCK_DELAY);
 		break;
 	};
+	return 0;
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/memstick/host/tifm_ms.c~memstick-allow-set_param-method-to-return-an-error-code drivers/memstick/host/tifm_ms.c
--- a/drivers/memstick/host/tifm_ms.c~memstick-allow-set_param-method-to-return-an-error-code
+++ a/drivers/memstick/host/tifm_ms.c
@@ -489,15 +489,12 @@ static void tifm_ms_request(struct memst
 	return;
 }
 
-static void tifm_ms_set_param(struct memstick_host *msh,
-			      enum memstick_param param,
-			      int value)
+static int tifm_ms_set_param(struct memstick_host *msh,
+			     enum memstick_param param,
+			     int value)
 {
 	struct tifm_ms *host = memstick_priv(msh);
 	struct tifm_dev *sock = host->dev;
-	unsigned long flags;
-
-	spin_lock_irqsave(&sock->lock, flags);
 
 	switch (param) {
 	case MEMSTICK_POWER:
@@ -512,7 +509,8 @@ static void tifm_ms_set_param(struct mem
 			writel(TIFM_MS_SYS_FCLR | TIFM_MS_SYS_INTCLR,
 			       sock->addr + SOCK_MS_SYSTEM);
 			writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
-		}
+		} else
+			return -EINVAL;
 		break;
 	case MEMSTICK_INTERFACE:
 		if (value == MEMSTICK_SERIAL) {
@@ -525,11 +523,12 @@ static void tifm_ms_set_param(struct mem
 			writel(TIFM_CTRL_FAST_CLK
 			       | readl(sock->addr + SOCK_CONTROL),
 			       sock->addr + SOCK_CONTROL);
-		}
+		} else
+			return -EINVAL;
 		break;
 	};
 
-	spin_unlock_irqrestore(&sock->lock, flags);
+	return 0;
 }
 
 static void tifm_ms_abort(unsigned long data)
diff -puN include/linux/memstick.h~memstick-allow-set_param-method-to-return-an-error-code include/linux/memstick.h
--- a/include/linux/memstick.h~memstick-allow-set_param-method-to-return-an-error-code
+++ a/include/linux/memstick.h
@@ -284,7 +284,7 @@ struct memstick_host {
 	/* Notify the host that some requests are pending. */
 	void                (*request)(struct memstick_host *host);
 	/* Set host IO parameters (power, clock, etc).     */
-	void                (*set_param)(struct memstick_host *host,
+	int                 (*set_param)(struct memstick_host *host,
 					 enum memstick_param param,
 					 int value);
 	unsigned long       private[0] ____cacheline_aligned;
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch

