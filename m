From: akpm@linux-foundation.org
Subject: [merged] usb-common-convert-to-use-match_string-helper.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:42:20 -0700
Message-ID: <56f0408c.XYoh9JQKryhj/kfp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941AbcCUTVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heikki.krogerus@linux.intel.com, andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: usb: common: convert to use match_string() helper
has been removed from the -mm tree.  Its filename was
     usb-common-convert-to-use-match_string-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: usb: common: convert to use match_string() helper

The new helper returns index of the mathing string in an array.  We would
use it here.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/common/common.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/usb/common/common.c~usb-common-convert-to-use-match_string-helper drivers/usb/common/common.c
--- a/drivers/usb/common/common.c~usb-common-convert-to-use-match_string-helper
+++ a/drivers/usb/common/common.c
@@ -64,18 +64,15 @@ EXPORT_SYMBOL_GPL(usb_speed_string);
 enum usb_device_speed usb_get_maximum_speed(struct device *dev)
 {
 	const char *maximum_speed;
-	int err;
-	int i;
+	int ret;
 
-	err = device_property_read_string(dev, "maximum-speed", &maximum_speed);
-	if (err < 0)
+	ret = device_property_read_string(dev, "maximum-speed", &maximum_speed);
+	if (ret < 0)
 		return USB_SPEED_UNKNOWN;
 
-	for (i = 0; i < ARRAY_SIZE(speed_names); i++)
-		if (strcmp(maximum_speed, speed_names[i]) == 0)
-			return i;
+	ret = match_string(speed_names, ARRAY_SIZE(speed_names), maximum_speed);
 
-	return USB_SPEED_UNKNOWN;
+	return (ret < 0) ? USB_SPEED_UNKNOWN : ret;
 }
 EXPORT_SYMBOL_GPL(usb_get_maximum_speed);
 
@@ -109,13 +106,10 @@ static const char *const usb_dr_modes[]
 
 static enum usb_dr_mode usb_get_dr_mode_from_string(const char *str)
 {
-	int i;
+	int ret;
 
-	for (i = 0; i < ARRAY_SIZE(usb_dr_modes); i++)
-		if (!strcmp(usb_dr_modes[i], str))
-			return i;
