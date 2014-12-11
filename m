From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-use-dev_info.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:06:24 -0800
Message-ID: <5489eb30.lS+m8qCjnfQ5gxIP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182AbaLKTGZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: use dev_info
has been removed from the -mm tree.  Its filename was
     rtc-omap-use-dev_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: use dev_info

Use dev_info rather than pr_info.

Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Keerthy J <j-keerthy@ti.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-use-dev_info drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-use-dev_info
+++ a/drivers/rtc/rtc-omap.c
@@ -427,8 +427,7 @@ static int __init omap_rtc_probe(struct
 	/* clear old status */
 	reg = rtc_read(OMAP_RTC_STATUS_REG);
 	if (reg & (u8) OMAP_RTC_STATUS_POWER_UP) {
-		pr_info("%s: RTC power up reset detected\n",
-			pdev->name);
+		dev_info(&pdev->dev, "RTC power up reset detected\n");
 		rtc_write(OMAP_RTC_STATUS_POWER_UP, OMAP_RTC_STATUS_REG);
 	}
 	if (reg & (u8) OMAP_RTC_STATUS_ALARM)
@@ -437,7 +436,7 @@ static int __init omap_rtc_probe(struct
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
 	reg = rtc_read(OMAP_RTC_CTRL_REG);
 	if (reg & (u8) OMAP_RTC_CTRL_STOP)
-		pr_info("%s: already running\n", pdev->name);
+		dev_info(&pdev->dev, "already running\n");
 
 	/* force to 24 hour mode */
 	new_ctrl = reg & (OMAP_RTC_CTRL_SPLIT|OMAP_RTC_CTRL_AUTO_COMP);
@@ -458,7 +457,7 @@ static int __init omap_rtc_probe(struct
 	 */
 
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
-		pr_info("%s: split power mode\n", pdev->name);
+		dev_info(&pdev->dev, "split power mode\n");
 
 	if (reg != new_ctrl)
 		rtc_write(new_ctrl, OMAP_RTC_CTRL_REG);
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

