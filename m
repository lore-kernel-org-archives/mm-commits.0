From: akpm@linux-foundation.org
Subject: + gpiolib-make-gpiochip_add-show-a-better-error-message.patch added to -mm tree
Date: Thu, 06 May 2010 13:54:49 -0700
Message-ID: <201005062054.o46Ksnaw013100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757112Ab0EFUzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 16:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, david-b@pacbell.net


The patch titled
     gpiolib: make gpiochip_add() show a better error message
has been added to the -mm tree.  Its filename is
     gpiolib-make-gpiochip_add-show-a-better-error-message.patch

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
Subject: gpiolib: make gpiochip_add() show a better error message
From: Ben Dooks <ben-linux@fluff.org>

The current message, 'not registered' is confusing as it implies it was
not registered with something, whereas printing 'failed to register'
implies it was the gpiochip_add() call that did not work correctly.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-make-gpiochip_add-show-a-better-error-message drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-make-gpiochip_add-show-a-better-error-message
+++ a/drivers/gpio/gpiolib.c
@@ -1118,7 +1118,7 @@ unlock:
 	return 0;
 fail:
 	/* failures here can mean systems won't boot... */
-	pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
+	pr_err("gpiochip_add: gpios %d..%d (%s) failed to register\n",
 		chip->base, chip->base + chip->ngpio - 1,
 		chip->label ? : "generic");
 	return status;
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
sdhci-rename-sdhci-i-o-accessor-functions.patch
s3c6410-add-new-quirk-in-sdhci-driver-and-update-adma-descriptor-build.patch
s3c6410-enable-adma-feature-in-6410-sdhci-controller.patch
sdhci-enable-multiblock-transfers-in-sdhci-s3c.patch
s3c-rtc-driver-add-support-for-s3c64xx.patch
max732x-correct-nr_port-checking-off-by-one-error.patch
gpiolib-make-gpiochip_add-show-a-better-error-message.patch

