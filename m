From: akpm@linux-foundation.org
Subject: + gpio-fix-spurious-printk-when-freeing-a-gpio.patch added to -mm tree
Date: Mon, 26 Jul 2010 14:36:31 -0700
Message-ID: <201007262136.o6QLaVkH011136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637Ab0GZVg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 17:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jon.povey@racelogic.co.uk, david-b@pacbell.net


The patch titled
     gpio: fix spurious printk when freeing a gpio
has been added to the -mm tree.  Its filename is
     gpio-fix-spurious-printk-when-freeing-a-gpio.patch

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
Subject: gpio: fix spurious printk when freeing a gpio
From: Jon Povey <jon.povey@racelogic.co.uk>

When freeing a gpio that has not been exported, gpio_unexport() prints a
debug message when it should just fall through silently.

Example spurious message:

	gpio_unexport: gpio0 status -22

Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpio-fix-spurious-printk-when-freeing-a-gpio drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-fix-spurious-printk-when-freeing-a-gpio
+++ a/drivers/gpio/gpiolib.c
@@ -893,10 +893,12 @@ EXPORT_SYMBOL_GPL(gpio_sysfs_set_active_
 void gpio_unexport(unsigned gpio)
 {
 	struct gpio_desc	*desc;
-	int			status = -EINVAL;
+	int			status = 0;
 
-	if (!gpio_is_valid(gpio))
+	if (!gpio_is_valid(gpio)) {
+		status = -EINVAL;
 		goto done;
+	}
 
 	mutex_lock(&sysfs_lock);
 
@@ -911,7 +913,6 @@ void gpio_unexport(unsigned gpio)
 			clear_bit(FLAG_EXPORT, &desc->flags);
 			put_device(dev);
 			device_unregister(dev);
-			status = 0;
 		} else
 			status = -ENODEV;
 	}
_

Patches currently in -mm which might be from jon.povey@racelogic.co.uk are

gpio-fix-spurious-printk-when-freeing-a-gpio.patch

