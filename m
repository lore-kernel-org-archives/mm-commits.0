From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:27:22 -0800
Message-ID: <200802070027.m170R3bo006985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38018 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765964AbYBGApU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.frysinger@analog.com, alessandro.zummo@towertech.it, bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     Blackfin RTC driver: we pass in a (struct device*) to the irq handler, not a (struct platform_device*), so fix the irq handler
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin RTC driver: we pass in a (struct device*) to the irq handler, not a (struct platform_device*), so fix the irq handler
From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler
+++ a/drivers/rtc/rtc-bfin.c
@@ -144,8 +144,8 @@ static void rtc_bfin_reset(struct bfin_r
 
 static irqreturn_t bfin_rtc_interrupt(int irq, void *dev_id)
 {
-	struct platform_device *pdev = to_platform_device(dev_id);
-	struct bfin_rtc *rtc = platform_get_drvdata(pdev);
+	struct device *dev = dev_id;
+	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	unsigned long events = 0;
 	u16 rtc_istat;
 
_

Patches currently in -mm which might be from michael.frysinger@analog.com are

origin.patch
git-watchdog.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
