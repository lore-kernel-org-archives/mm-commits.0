From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-omapc-remove-multiple-device-id-checks.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:30:12 -0700
Message-ID: <53960b44.bhzH9zC2jxa/UFVw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaFITaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:30:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lokeshvutla@ti.com, a.zummo@towertech.it, nsekhar@ti.com

Subject: [merged] drivers-rtc-rtc-omapc-remove-multiple-device-id-checks.patch removed from -mm tree
To: nsekhar@ti.com,a.zummo@towertech.it,lokeshvutla@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:30:12 -0700


The patch titled
     Subject: drivers/rtc/rtc-omap.c: remove multiple device id checks
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-omapc-remove-multiple-device-id-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sekhar Nori <nsekhar@ti.com>
Subject: drivers/rtc/rtc-omap.c: remove multiple device id checks

Remove multiple superfluous device id checks.  Since an id_table is
present in the driver probe() should never encounter an empty device id
entry.  In case of OF style match, of_match_device() returns an matching
entry.

For paranoia sake, check for device id entry once and fail probe() if none
is found.  This is much better than checking for it multiple times.

Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-remove-multiple-device-id-checks drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-remove-multiple-device-id-checks
+++ a/drivers/rtc/rtc-omap.c
@@ -352,6 +352,12 @@ static int __init omap_rtc_probe(struct
 	if (of_id)
 		pdev->id_entry = of_id->data;
 
+	id_entry = platform_get_device_id(pdev);
+	if (!id_entry) {
+		dev_err(&pdev->dev, "no matching device entry\n");
+		return -ENODEV;
+	}
+
 	omap_rtc_timer = platform_get_irq(pdev, 0);
 	if (omap_rtc_timer <= 0) {
 		pr_debug("%s: no update irq?\n", pdev->name);
@@ -373,8 +379,7 @@ static int __init omap_rtc_probe(struct
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	id_entry = platform_get_device_id(pdev);
-	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER)) {
+	if (id_entry->driver_data & OMAP_RTC_HAS_KICKER) {
 		rtc_writel(KICK0_VALUE, OMAP_RTC_KICK0_REG);
 		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
 	}
@@ -452,7 +457,7 @@ static int __init omap_rtc_probe(struct
 	return 0;
 
 fail0:
-	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER))
+	if (id_entry->driver_data & OMAP_RTC_HAS_KICKER)
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -469,7 +474,7 @@ static int __exit omap_rtc_remove(struct
 	/* leave rtc running, but disable irqs */
 	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
 
-	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER))
+	if (id_entry->driver_data & OMAP_RTC_HAS_KICKER)
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
 
 	/* Disable the clock/module */
_

Patches currently in -mm which might be from nsekhar@ti.com are

origin.patch
linux-next.patch

