From: akpm@linux-foundation.org
Subject: + power_supply-add-support-for-wm8350-pmu-update.patch added to -mm tree
Date: Thu, 13 Nov 2008 14:34:11 -0800
Message-ID: <200811132234.mADMYBZl028951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbYKMWeV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 17:34:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, cbouatmailru@gmail.com, sameo@openedhand.com


The patch titled
     power_supply: add support for WM8350 PMU (update)
has been added to the -mm tree.  Its filename is
     power_supply-add-support-for-wm8350-pmu-update.patch

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
Subject: power_supply: add support for WM8350 PMU (update)
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Modified to:
 - Notify core of status changes in the battery charger.
 - Remove the WM8350-specific supply state sysfs file.

following feedback from Andrew.

Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/wm8350_power.c |   38 +--------------------------------
 1 file changed, 2 insertions(+), 36 deletions(-)

diff -puN drivers/power/wm8350_power.c~power_supply-add-support-for-wm8350-pmu-update drivers/power/wm8350_power.c
--- a/drivers/power/wm8350_power.c~power_supply-add-support-for-wm8350-pmu-update
+++ a/drivers/power/wm8350_power.c
@@ -156,36 +156,6 @@ static int wm8350_batt_status(struct wm8
 	}
 }
 
-static ssize_t supply_state_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	struct wm8350 *wm8350 = dev_get_drvdata(dev);
-	char *supply;
-	int state;
-
-	state = wm8350_get_supplies(wm8350);
-	switch (state) {
-	case WM8350_BATT_SUPPLY:
-		supply = "Battery";
-		break;
-	case WM8350_USB_SUPPLY:
-		supply = "USB";
-		break;
-	case WM8350_LINE_SUPPLY:
-		supply = "Line";
-		break;
-	case WM8350_USB_SUPPLY | WM8350_BATT_SUPPLY:
-		supply = "Battery and USB";
-		break;
-	default:
-		return 0;
-	}
-
-	return sprintf(buf, "%s\n", supply);
-}
-
-static DEVICE_ATTR(supply_state, 0444, supply_state_show, NULL);
-
 static ssize_t charger_state_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
@@ -233,10 +203,10 @@ static void wm8350_charger_handler(struc
 		dev_err(wm8350->dev, "charger timeout\n");
 		break;
 	case WM8350_IRQ_CHG_END:
-		dev_dbg(wm8350->dev, "charger stopped\n");
+		power_supply_changed(&power->battery);
 		break;
 	case WM8350_IRQ_CHG_START:
-		dev_dbg(wm8350->dev, "charger started\n");
+		power_supply_changed(&power->battery);
 		break;
 
 	case WM8350_IRQ_CHG_FAST_RDY:
@@ -485,9 +455,6 @@ static __devinit int wm8350_power_probe(
 	if (ret)
 		goto usb_failed;
 
-	ret = device_create_file(&pdev->dev, &dev_attr_supply_state);
-	if (ret < 0)
-		dev_warn(wm8350->dev, "failed to add supply sysfs: %d\n", ret);
 	ret = device_create_file(&pdev->dev, &dev_attr_charger_state);
 	if (ret < 0)
 		dev_warn(wm8350->dev, "failed to add charge sysfs: %d\n", ret);
@@ -516,7 +483,6 @@ static __devexit int wm8350_power_remove
 	struct wm8350_power *power = &wm8350->power;
 
 	free_charger_irq(wm8350);
-	device_remove_file(&pdev->dev, &dev_attr_supply_state);
 	device_remove_file(&pdev->dev, &dev_attr_charger_state);
 	power_supply_unregister(&power->battery);
 	power_supply_unregister(&power->ac);
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
mfd-correct-wm8350-i2c-return-code-usage.patch
power_supply-add-support-for-wm8350-pmu.patch
power_supply-add-support-for-wm8350-pmu-update.patch

