From: akpm@linux-foundation.org
Subject: - fujitsu-application-panel-driver-space-savings.patch removed from -mm tree
Date: Wed, 21 Nov 2007 14:58:59 -0800
Message-ID: <200711212259.lALMwxbb013418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381AbXKUW7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Nov 2007 17:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, dtor@mail.ru, jkosina@suse.cz, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     apanel: space savings
has been removed from the -mm tree.  Its filename was
     fujitsu-application-panel-driver-space-savings.patch

This patch was dropped because it was folded into fujitsu-application-panel-driver.patch

------------------------------------------------------
Subject: apanel: space savings
From: Stephen Hemminger <shemminger@linux-foundation.org>

Eliminate the device_names they are only used for debug messages.  Add
paren's for one expression.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/apanel.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff -puN drivers/input/misc/apanel.c~fujitsu-application-panel-driver-space-savings drivers/input/misc/apanel.c
--- a/drivers/input/misc/apanel.c~fujitsu-application-panel-driver-space-savings
+++ a/drivers/input/misc/apanel.c
@@ -27,7 +27,7 @@
 #include <linux/leds.h>
 
 #define APANEL_NAME	"Fujitsu Application Panel"
-#define APANEL_VERSION	"1.3"
+#define APANEL_VERSION	"1.3.1"
 #define APANEL		"apanel"
 
 /* How often we poll keys - msecs */
@@ -40,6 +40,7 @@ enum apanel_devid {
 	APANEL_DEV_CDBTN  = 2,
 	APANEL_DEV_LCD	  = 3,
 	APANEL_DEV_LED	  = 4,
+
 	APANEL_DEV_MAX,
 };
 
@@ -53,14 +54,6 @@ enum apanel_chip {
 /* Result of BIOS snooping/probing -- what features are supported */
 static enum apanel_chip device_chip[APANEL_DEV_MAX];
 
-/* names for APANEL_XXX */
-static const char *device_names[APANEL_DEV_MAX] __initdata = {
-	[APANEL_DEV_APPBTN] = "Application Buttons",
-	[APANEL_DEV_LCD]    = "LCD",
-	[APANEL_DEV_LED]    = "LED",
-	[APANEL_DEV_CDBTN]  = "CD Buttons",
-};
-
 #define MAX_PANEL_KEYS	12
 
 struct apanel {
@@ -123,7 +116,7 @@ static void apanel_poll(struct input_pol
 
 	dev_dbg(&ipdev->input->dev, APANEL ": data %#x\n", data);
 	for (i = 0; i < ipdev->input->keycodemax; i++)
-		if (1ul << i & data)
+		if ((1u << i) & data)
 			report_key(idev, ap->keymap[i]);
 }
 
@@ -366,17 +359,14 @@ static int __init apanel_init(void)
 		}
 
 		if (devno >= APANEL_DEV_MAX)
-			pr_notice(APANEL ": unknown device %d found\n", devno);
+			pr_notice(APANEL ": unknown device %u found\n", devno);
 		else if (device_chip[devno] != CHIP_NONE)
-			pr_warning(APANEL ": duplicate entry for %s\n",
-				   device_names[devno]);
+			pr_warning(APANEL ": duplicate entry for devno %u\n", devno);
 
 		else if (method != 1 && method != 2 && method != 4) {
-			pr_notice(APANEL ": unknown  method %u for %s\n",
-				  method, device_names[devno]);
+			pr_notice(APANEL ": unknown method %u for devno %u\n",
+				  method, devno);
 		} else {
-			pr_debug(APANEL ": %s found.\n", device_names[devno]);
-
 			device_chip[devno] = (enum apanel_chip) chip;
 			++found;
 		}
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

fujitsu-application-panel-driver.patch
fujitsu-application-panel-driver-space-savings.patch
input-polled-device-timer-rounding.patch
git-wireless.patch
