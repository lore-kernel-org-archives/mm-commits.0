From: akpm@linux-foundation.org
Subject: + leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling-update.patch added to -mm tree
Date: Mon, 18 Aug 2008 15:33:27 -0700
Message-ID: <200808182233.m7IMXRxb016489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877AbYHRWeN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 18:34:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sven.wegener@stealer.net, ncase@xes-inc.com, rpurdie@rpsys.net


The patch titled
     leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling update
has been added to the -mm tree.  Its filename is
     leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling-update.patch

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
Subject: leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling update
From: Sven Wegener <sven.wegener@stealer.net>

Andrew, could you please update the patch in -mm with the one below. It
contains the below fixes, that were applied after you added it to -mm,
and is identical to the one Nate tested.

- Another 32 -> sizeof() conversion
- Move the unregister code to where we also free the memory on failure
- cancel_work_sync() when unregistering on failure

Cc: Nate Case <ncase@xes-inc.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca955x.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/leds/leds-pca955x.c~leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling-update drivers/leds/leds-pca955x.c
--- a/drivers/leds/leds-pca955x.c~leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling-update
+++ a/drivers/leds/leds-pca955x.c
@@ -302,7 +302,8 @@ static int __devinit pca955x_probe(struc
 				pca955x[i].led_cdev.default_trigger =
 					pdata->leds[i].default_trigger;
 		} else {
-			snprintf(pca955x[i].name, 32, "pca955x:%d", i);
+			snprintf(pca955x[i].name, sizeof(pca955x[i].name),
+				 "pca955x:%d", i);
 		}
 
 		spin_lock_init(&pca955x[i].lock);
@@ -313,14 +314,8 @@ static int __devinit pca955x_probe(struc
 		INIT_WORK(&pca955x[i].work, pca955x_led_work);
 
 		err = led_classdev_register(&client->dev, &pca955x[i].led_cdev);
-		if (err < 0) {
-			while (i > 0) {
-				i--;
-				led_classdev_unregister(&pca955x[i].led_cdev);
-			}
-
+		if (err < 0)
 			goto exit;
-		}
 	}
 
 	/* Turn off LEDs */
@@ -340,6 +335,11 @@ static int __devinit pca955x_probe(struc
 	return 0;
 
 exit:
+	while (i--) {
+		led_classdev_unregister(&pca955x[i].led_cdev);
+		cancel_work_sync(&pca955x[i].work);
+	}
+
 	kfree(pca955x);
 	i2c_set_clientdata(client, NULL);
 
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

origin.patch
leds-avoid-needless-strlen-for-attributes.patch
leds-wrap-use-default-on-trigger-for-power-led.patch
leds-fsg-change-order-of-initialization-and-deinitialization.patch
leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling.patch
leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling-update.patch

