From: akpm@linux-foundation.org
Subject: + leds-fsg-change-order-of-initialization-and-deinitialization.patch added to -mm tree
Date: Wed, 30 Jul 2008 00:57:05 -0700
Message-ID: <200807300757.m6U7v57u014986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbYG3H5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 03:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sven.wegener@stealer.net, rod@whitby.id.au


The patch titled
     leds-fsg: change order of initialization and deinitialization
has been added to the -mm tree.  Its filename is
     leds-fsg-change-order-of-initialization-and-deinitialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-fsg: change order of initialization and deinitialization
From: Sven Wegener <sven.wegener@stealer.net>

On initialization, we first do the ioremap and then register the led devices.
On deinitialization, we do it in reverse order. This prevents someone calling
into the brightness_set functions with an invalid latch_address.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Acked-by: Rod Whitby <rod@whitby.id.au>
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
