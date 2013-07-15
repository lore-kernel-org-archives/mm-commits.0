From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-hid-sensor-timec-add-module-alias-to-let-the-module-load-automatically.patch added to -mm tree
Date: Mon, 15 Jul 2013 13:57:02 -0700
Message-ID: <51e4621e.TblAKeacW7RjHURx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3GOU5C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Jul 2013 16:57:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holler@ahsoftware.de

Subject: + drivers-rtc-rtc-hid-sensor-timec-add-module-alias-to-let-the-module-load-automatically.patch added to -mm tree
To: holler@ahsoftware.de
From: akpm@linux-foundation.org
Date: Mon, 15 Jul 2013 13:57:02 -0700


The patch titled
     Subject: drivers/rtc/rtc-hid-sensor-time.c: add module alias to let the module load automatically
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-hid-sensor-timec-add-module-alias-to-let-the-module-load-automatically.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-hid-sensor-timec-add-module-alias-to-let-the-module-load-automatically.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-hid-sensor-timec-add-module-alias-to-let-the-module-load-automatically.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Holler <holler@ahsoftware.de>
Subject: drivers/rtc/rtc-hid-sensor-time.c: add module alias to let the module load automatically

In order to get the module automatically loaded by hotplug mechanisms a
MODULE_DEVICE_TABLE is needed.

Therefore add one.

This makes it also possible to use a module name other than
HID-SENSOR-2000a0 which isn't very descriptive in kernel messages.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hid-sensor-time.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-hid-sensor-time.c~drivers-rtc-rtc-hid-sensor-timec-add-module-alias-to-let-the-module-load-automatically drivers/rtc/rtc-hid-sensor-time.c
--- a/drivers/rtc/rtc-hid-sensor-time.c~drivers-rtc-rtc-hid-sensor-timec-add-module-alias-to-let-the-module-load-automatically
+++ a/drivers/rtc/rtc-hid-sensor-time.c
@@ -23,10 +23,6 @@
 #include <linux/iio/iio.h>
 #include <linux/rtc.h>
 
-/* Format: HID-SENSOR-usage_id_in_hex */
-/* Usage ID from spec for Time: 0x2000A0 */
-#define DRIVER_NAME "HID-SENSOR-2000a0" /* must be lowercase */
-
 enum hid_time_channel {
 	CHANNEL_SCAN_INDEX_YEAR,
 	CHANNEL_SCAN_INDEX_MONTH,
@@ -300,9 +296,19 @@ static int hid_time_remove(struct platfo
 	return 0;
 }
 
+static struct platform_device_id hid_time_ids[] = {
+	{
+		/* Format: HID-SENSOR-usage_id_in_hex_lowercase */
+		.name = "HID-SENSOR-2000a0",
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(platform, hid_time_ids);
+
 static struct platform_driver hid_time_platform_driver = {
+	.id_table = hid_time_ids,
 	.driver = {
-		.name	= DRIVER_NAME,
+		.name	= KBUILD_MODNAME,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= hid_time_probe,
_

Patches currently in -mm which might be from holler@ahsoftware.de are

drivers-rtc-rtc-hid-sensor-timec-add-module-alias-to-let-the-module-load-automatically.patch

