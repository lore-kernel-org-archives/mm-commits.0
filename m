From: akpm@linux-foundation.org
Subject: + cs5535-gpio-request-function-mask-names-added-fix.patch added to -mm tree
Date: Tue, 01 Sep 2009 16:04:58 -0700
Message-ID: <200909012304.n81N4w13019974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755335AbZIAXFx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 19:05:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@collabora.co.uk, Tobias_Mueller@twam.info, alessandro.zummo@towertech.it, david-b@pacbell.net, jordan@cosmicpenguin.net, tiwai@suse.de


The patch titled
     cs5535-gpio: make printk usage consistent
has been added to the -mm tree.  Its filename is
     cs5535-gpio-request-function-mask-names-added-fix.patch

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
Subject: cs5535-gpio: make printk usage consistent
From: Andres Salomon <dilinger@collabora.co.uk>

Clean up places where we were using printk()s instead of dev_*.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Tobias Mueller <Tobias_Mueller@twam.info>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/cs5535-gpio.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/gpio/cs5535-gpio.c~cs5535-gpio-request-function-mask-names-added-fix drivers/gpio/cs5535-gpio.c
--- a/drivers/gpio/cs5535-gpio.c~cs5535-gpio-request-function-mask-names-added-fix
+++ a/drivers/gpio/cs5535-gpio.c
@@ -134,8 +134,8 @@ static int chip_gpio_request(struct gpio
 
 	/* check if this pin is available */
 	if ((mask & (1 << offset)) == 0) {
-		printk(KERN_INFO DRV_NAME
-			": pin %u is not available (check mask)\n", offset);
+		dev_info(&chip->pdev->dev,
+			"pin %u is not available (check mask)\n", offset);
 		spin_unlock_irqrestore(&chip->lock, flags);
 		return -EINVAL;
 	}
@@ -265,18 +265,15 @@ static int __init cs5535_gpio_probe(stru
 	mask &= ~(1 << 28);
 
 	if (mask_orig != mask)
-		printk(KERN_INFO DRV_NAME
-				": mask changed from 0x%08lX to 0x%08lX\n",
+		dev_info(&pdev->dev, "mask changed from 0x%08lX to 0x%08lX\n",
 				mask_orig, mask);
 
 	/* finally, register with the generic GPIO API */
 	err = gpiochip_add(&cs5535_gpio_chip.chip);
-	if (err) {
-		dev_err(&pdev->dev, "failed to register gpio chip\n");
+	if (err)
 		goto release_region;
-	}
 
-	printk(KERN_INFO DRV_NAME ": GPIO support successfully loaded.\n");
+	dev_info(&pdev->dev, DRV_NAME ": GPIO support successfully loaded.\n");
 	return 0;
 
 release_region:
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

linux-next.patch
cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs5535-gpio-request-function-mask-names-added.patch
cs5535-gpio-request-function-mask-names-added-fix.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

