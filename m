From: akpm@linux-foundation.org
Subject: + leds-h1940-use-gpiolib-for-latch-access-fix-build-failure.patch added to -mm tree
Date: Tue, 04 Jan 2011 15:37:31 -0800
Message-ID: <201101042337.p04NbVAk030714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab1ADXij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 18:38:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterhuewe@gmx.de, anarsoul@gmail.com, ben-linux@fluff.org, linux@arm.linux.org.uk, rpurdie@rpsys.net, stable@kernel.org, support@simtec.co.uk


The patch titled
     drivers/leds/leds-h1940.c: use gpiolib for latch access, fix build failure
has been added to the -mm tree.  Its filename is
     leds-h1940-use-gpiolib-for-latch-access-fix-build-failure.patch

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
Subject: drivers/leds/leds-h1940.c: use gpiolib for latch access, fix build failure
From: Peter Huewe <peterhuewe@gmx.de>

Fix a build failure by converting leds-h1940.c to use gpiolib for latch
access introduced by 14477095abc6 ("ARM: h1940: Use gpiolib for latch
access").

drivers/leds/leds-h1940.c: In function 'h1940_greenled_set':
drivers/leds/leds-h1940.c:33: error: implicit declaration of function 'h1940_latch_control'

Unfortunately this driver was not converted back then.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Vincent Sanders <support@simtec.co.uk>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: <stable@kernel.org>		[2.6.37.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-h1940.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/leds/leds-h1940.c~leds-h1940-use-gpiolib-for-latch-access-fix-build-failure drivers/leds/leds-h1940.c
--- a/drivers/leds/leds-h1940.c~leds-h1940-use-gpiolib-for-latch-access-fix-build-failure
+++ a/drivers/leds/leds-h1940.c
@@ -30,17 +30,17 @@ static void h1940_greenled_set(struct le
 {
 	switch (value) {
 	case LED_HALF:
-		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
+		gpio_set_value(H1940_LATCH_LED_FLASH, 1);
 		s3c2410_gpio_setpin(S3C2410_GPA7, 1);
 		break;
 	case LED_FULL:
-		h1940_latch_control(0, H1940_LATCH_LED_GREEN);
+		gpio_set_value(H1940_LATCH_LED_GREEN, 1);
 		s3c2410_gpio_setpin(S3C2410_GPA7, 1);
 		break;
 	default:
 	case LED_OFF:
-		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
-		h1940_latch_control(H1940_LATCH_LED_GREEN, 0);
+		gpio_set_value(H1940_LATCH_LED_FLASH, 0);
+		gpio_set_value(H1940_LATCH_LED_GREEN, 0);
 		s3c2410_gpio_setpin(S3C2410_GPA7, 0);
 		break;
 	}
@@ -60,17 +60,17 @@ static void h1940_redled_set(struct led_
 {
 	switch (value) {
 	case LED_HALF:
-		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
+		gpio_set_value(H1940_LATCH_LED_FLASH, 1);
 		s3c2410_gpio_setpin(S3C2410_GPA1, 1);
 		break;
 	case LED_FULL:
-		h1940_latch_control(0, H1940_LATCH_LED_RED);
+		gpio_set_value(H1940_LATCH_LED_RED, 1);
 		s3c2410_gpio_setpin(S3C2410_GPA1, 1);
 		break;
 	default:
 	case LED_OFF:
-		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
-		h1940_latch_control(H1940_LATCH_LED_RED, 0);
+		gpio_set_value(H1940_LATCH_LED_FLASH, 0);
+		gpio_set_value(H1940_LATCH_LED_RED, 0);
 		s3c2410_gpio_setpin(S3C2410_GPA1, 0);
 		break;
 	}
@@ -91,10 +91,10 @@ static void h1940_blueled_set(struct led
 {
 	if (value) {
 		/* flashing Blue */
-		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
+		gpio_set_value(H1940_LATCH_LED_FLASH, 1);
 		s3c2410_gpio_setpin(S3C2410_GPA3, 1);
 	} else {
-		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
+		gpio_set_value(H1940_LATCH_LED_FLASH, 0);
 		s3c2410_gpio_setpin(S3C2410_GPA3, 0);
 	}
 
_

Patches currently in -mm which might be from peterhuewe@gmx.de are

origin.patch
linux-next.patch
leds-h1940-use-gpiolib-for-latch-access-fix-build-failure.patch

