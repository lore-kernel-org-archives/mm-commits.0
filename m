From: akpm@linux-foundation.org
Subject: - leds-fsg-change-order-of-initialization-and-deinitialization.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:39:26 -0700
Message-ID: <200810072339.m97NdQZv009556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755581AbYJGXjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:39:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sven.wegener@stealer.net, rod@whitby.id.au, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds-fsg: change order of initialization and deinitialization
has been removed from the -mm tree.  Its filename was
     leds-fsg-change-order-of-initialization-and-deinitialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-fsg: change order of initialization and deinitialization
From: Sven Wegener <sven.wegener@stealer.net>

On initialization, we first do the ioremap and then register the led devices.
On deinitialization, we do it in reverse order. This prevents someone calling
into the brightness_set functions with an invalid latch_address.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Acked-by: Rod Whitby <rod@whitby.id.au>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-fsg.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/leds/leds-fsg.c~leds-fsg-change-order-of-initialization-and-deinitialization drivers/leds/leds-fsg.c
--- a/drivers/leds/leds-fsg.c~leds-fsg-change-order-of-initialization-and-deinitialization
+++ a/drivers/leds/leds-fsg.c
@@ -161,6 +161,16 @@ static int fsg_led_probe(struct platform
 {
 	int ret;
 
+	/* Map the LED chip select address space */
+	latch_address = (unsigned short *) ioremap(IXP4XX_EXP_BUS_BASE(2), 512);
+	if (!latch_address) {
+		ret = -ENOMEM;
+		goto failremap;
+	}
+
+	latch_value = 0xffff;
+	*latch_address = latch_value;
+
 	ret = led_classdev_register(&pdev->dev, &fsg_wlan_led);
 	if (ret < 0)
 		goto failwlan;
@@ -185,20 +195,8 @@ static int fsg_led_probe(struct platform
 	if (ret < 0)
 		goto failring;
 
-	/* Map the LED chip select address space */
-	latch_address = (unsigned short *) ioremap(IXP4XX_EXP_BUS_BASE(2), 512);
-	if (!latch_address) {
-		ret = -ENOMEM;
-		goto failremap;
-	}
-
-	latch_value = 0xffff;
-	*latch_address = latch_value;
-
 	return ret;
 
- failremap:
-	led_classdev_unregister(&fsg_ring_led);
  failring:
 	led_classdev_unregister(&fsg_sync_led);
  failsync:
@@ -210,14 +208,14 @@ static int fsg_led_probe(struct platform
  failwan:
 	led_classdev_unregister(&fsg_wlan_led);
  failwlan:
+	iounmap(latch_address);
+ failremap:
 
 	return ret;
 }
 
 static int fsg_led_remove(struct platform_device *pdev)
 {
-	iounmap(latch_address);
