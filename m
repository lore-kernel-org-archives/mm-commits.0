From: akpm@linux-foundation.org
Subject: + gpiolib-fix-device_create-result-check.patch added to -mm tree
Date: Tue, 03 Nov 2009 14:44:48 -0800
Message-ID: <200911032244.nA3MimLb030327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602AbZKCWpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 17:45:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sshtylyov@ru.mvista.com, david-b@pacbell.net


The patch titled
     gpiolib: fix device_create() result check
has been added to the -mm tree.  Its filename is
     gpiolib-fix-device_create-result-check.patch

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
Subject: gpiolib: fix device_create() result check
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

In case of failure, device_create() returns not NULL but the error code. 
The current code checks for non-NULL though which causes kernel oops in
sysfs_create_group() when device_create() fails.  Check for error using
IS_ERR() and propagate the error value using PTR_ERR() instead of fixed
-ENODEV code returned now...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/gpio/gpiolib.c~gpiolib-fix-device_create-result-check drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-fix-device_create-result-check
+++ a/drivers/gpio/gpiolib.c
@@ -661,7 +661,7 @@ int gpio_export(unsigned gpio, bool dire
 
 		dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
 				desc, ioname ? ioname : "gpio%d", gpio);
-		if (dev) {
+		if (!IS_ERR(dev)) {
 			if (direction_may_change)
 				status = sysfs_create_group(&dev->kobj,
 						&gpio_attr_group);
@@ -679,7 +679,7 @@ int gpio_export(unsigned gpio, bool dire
 			if (status != 0)
 				device_unregister(dev);
 		} else
-			status = -ENODEV;
+			status = PTR_ERR(dev);
 		if (status == 0)
 			set_bit(FLAG_EXPORT, &desc->flags);
 	}
@@ -800,11 +800,11 @@ static int gpiochip_export(struct gpio_c
 	mutex_lock(&sysfs_lock);
 	dev = device_create(&gpio_class, chip->dev, MKDEV(0, 0), chip,
 				"gpiochip%d", chip->base);
-	if (dev) {
+	if (!IS_ERR(dev)) {
 		status = sysfs_create_group(&dev->kobj,
 				&gpiochip_attr_group);
 	} else
-		status = -ENODEV;
+		status = PTR_ERR(dev);
 	chip->exported = (status == 0);
 	mutex_unlock(&sysfs_lock);
 
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

linux-next.patch
gpiolib-fix-device_create-result-check.patch
3x59x-fix-pci-resource-management.patch
sound-core-pcm_timerc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch

