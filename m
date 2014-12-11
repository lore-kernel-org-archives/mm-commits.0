From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-fix-interrupt-disable-at-probe.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:06:12 -0800
Message-ID: <5489eb24.Z/0hjltHeycHDhyQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327AbaLKTGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: fix interrupt disable at probe
has been removed from the -mm tree.  Its filename was
     rtc-omap-fix-interrupt-disable-at-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: fix interrupt disable at probe

Use writel instead of writeb when disabling interrupts at probe as
ALARM2 is not cleared otherwise on some IP-block revisions (e.g.
AM3352).

Note that the driver currently never enables the ALARM2 interrupt.

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

 drivers/rtc/rtc-omap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-fix-interrupt-disable-at-probe drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-fix-interrupt-disable-at-probe
+++ a/drivers/rtc/rtc-omap.c
@@ -427,10 +427,12 @@ static int __init omap_rtc_probe(struct
 	}
 	platform_set_drvdata(pdev, rtc);
 
-	/* clear pending irqs, and set 1/second periodic,
-	 * which we'll use instead of update irqs
+	/*
+	 * disable interrupts
+	 *
+	 * NOTE: ALARM2 is not cleared on AM3352 if rtc_write (writeb) is used
 	 */
-	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
+	rtc_writel(0, OMAP_RTC_INTERRUPTS_REG);
 
 	/* enable RTC functional clock */
 	if (id_entry->driver_data & OMAP_RTC_HAS_32KCLK_EN) {
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

