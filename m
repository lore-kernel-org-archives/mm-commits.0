From: akpm@linux-foundation.org
Subject: [merged] mfd-initialise-wm8350-interrupts-earlier.patch removed from -mm tree
Date: Thu, 05 Feb 2009 11:14:46 -0800
Message-ID: <200902051914.n15JEkSe012151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759355AbZBETPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 14:15:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     mfd: initialise WM8350 interrupts earlier
has been removed from the -mm tree.  Its filename was
     mfd-initialise-wm8350-interrupts-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: initialise WM8350 interrupts earlier
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Ensure that the interrupt handling is configured before we do platform
specific init.  This allows the platform specific initialisation to
configure things which use interrupts safely.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/wm8350-core.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/mfd/wm8350-core.c~mfd-initialise-wm8350-interrupts-earlier drivers/mfd/wm8350-core.c
--- a/drivers/mfd/wm8350-core.c~mfd-initialise-wm8350-interrupts-earlier
+++ a/drivers/mfd/wm8350-core.c
@@ -1419,15 +1419,6 @@ int wm8350_device_init(struct wm8350 *wm
 		return ret;
 	}
 
-	if (pdata && pdata->init) {
-		ret = pdata->init(wm8350);
-		if (ret != 0) {
-			dev_err(wm8350->dev, "Platform init() failed: %d\n",
-				ret);
-			goto err;
-		}
-	}
-
 	mutex_init(&wm8350->auxadc_mutex);
 	mutex_init(&wm8350->irq_mutex);
 	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
@@ -1445,6 +1436,15 @@ int wm8350_device_init(struct wm8350 *wm
 	}
 	wm8350->chip_irq = irq;
 
+	if (pdata && pdata->init) {
+		ret = pdata->init(wm8350);
+		if (ret != 0) {
+			dev_err(wm8350->dev, "Platform init() failed: %d\n",
+				ret);
+			goto err;
+		}
+	}
+
 	wm8350_reg_write(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK, 0x0);
 
 	wm8350_client_dev_register(wm8350, "wm8350-codec",
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
mfd-support-active-high-irqs-on-wm835x.patch
mfd-ensure-all-wm8350-irqs-are-masked-at-startup.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

