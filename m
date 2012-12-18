From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tps65910c-enable-rtc-power-domain-on-initialization.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:08:27 -0800
Message-ID: <20121218200828.56752200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:51025 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2LRUIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:08:31 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so63376wib.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:08:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, a.zummo@towertech.it, milo.kim@ti.com, sameo@linux.intel.com, sivaramn@nvidia.com, vbyravarasu@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: enable RTC power domain on initialization
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tps65910c-enable-rtc-power-domain-on-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: drivers/rtc/rtc-tps65910.c: enable RTC power domain on initialization

Enabling RTC HW block depends on the default value of TPS65910 register. 
In some mode, RTC block is disabled by default.(eg.  AM3517 Craneboard) In
this case, RTC_PWDN(RTC power down) bit should be cleared to enable the
RTC HW block.

This patch also works in case that RTC block is active by default, because
there is no side effect even if the bit is updated again.

Tested on AM3517 Craneboard.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com> 
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sivaram Nair <sivaramn@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-enable-rtc-power-domain-on-initialization drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-enable-rtc-power-domain-on-initialization
+++ a/drivers/rtc/rtc-tps65910.c
@@ -247,6 +247,13 @@ static int __devinit tps65910_rtc_probe(
 		return ret;
 
 	dev_dbg(&pdev->dev, "Enabling rtc-tps65910.\n");
+
+	/* Enable RTC digital power domain */
+	ret = regmap_update_bits(tps65910->regmap, TPS65910_DEVCTRL,
+		DEVCTRL_RTC_PWDN_MASK, 0 << DEVCTRL_RTC_PWDN_SHIFT);
+	if (ret < 0)
+		return ret;
+
 	rtc_reg = TPS65910_RTC_CTRL_STOP_RTC;
 	ret = regmap_write(tps65910->regmap, TPS65910_RTC_CTRL, rtc_reg);
 	if (ret < 0)
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch

