From: akpm@linux-foundation.org
Subject: [merged] gpiolib-fix-device_create-result-check.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:27:20 -0800
Message-ID: <200911131927.nADJRKmw030381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932230AbZKMT1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpiolib: fix device_create() result check
has been removed from the -mm tree.  Its filename was
     gpiolib-fix-device_create-result-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
3x59x-fix-pci-resource-management.patch
sound-core-pcm_timerc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch

