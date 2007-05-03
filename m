From: akpm@linux-foundation.org
Subject: + platform-reorder-platform_device_del.patch added to -mm tree
Date: Thu, 03 May 2007 02:36:32 -0700
Message-ID: <200705030936.l439aWg9009011@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030278AbXECJgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 05:36:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org


The patch titled
     platform: reorder platform_device_del
has been added to the -mm tree.  Its filename is
     platform-reorder-platform_device_del.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: platform: reorder platform_device_del
From: Jean Delvare <khali@linux-fr.org>

In platform_device_del(), we currently delete the device resources first,
then we delete the device itself.  This causes a (minor) bug to occur when
one unregisters a platform device before unregistering its platform driver,
and the driver is requesting (in .probe()) and releasing (in .remove()) a
resource of the device.  The device resources are already gone by the time
the driver gets the chance to release the resources it had been requesting,
causing an error like: Trying to free nonexistent resource
<0000000000000295-0000000000000296>

If the platform driver is unregistered first, the problem doesn't occur, as
the driver will have the opportunity to release the resources it had
requested before the device resources themselves are released.  It's a bit
odd that unregistering the driver first or the device first doesn't lead to
the same result.

So I believe that we should delete the device first in
platform_device_del().  I've searched the git history and found that it
used to be the case before 2.6.8, but was changed here:

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commitdiff;h=96ef7b3689936ee1e64b711511342026a8ce459c

> 2004/07/14 16:09:44-07:00 dtor_core
> [PATCH] Driver core: Fix OOPS in device_platform_unregister
>
> Driver core: platform_device_unregister should release resources first
>              and only then call device_unregister, otherwise if there
>              are no more references to the device it will be freed and
>              the fucntion will try to access freed memory.

However we now have an explicit call to put_device() at the end of
platform_device_unregister() so I guess the original problem no longer
exists and it is safe to revert that change.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/base/platform.c~platform-reorder-platform_device_del drivers/base/platform.c
--- a/drivers/base/platform.c~platform-reorder-platform_device_del
+++ a/drivers/base/platform.c
@@ -292,20 +292,22 @@ EXPORT_SYMBOL_GPL(platform_device_add);
  *	@pdev:	platform device we're removing
  *
  *	Note that this function will also release all memory- and port-based
- *	resources owned by the device (@dev->resource).
+ *	resources owned by the device (@dev->resource).  This function
+ *	must _only_ be externally called in error cases.  All other usage
+ *	is a bug.
  */
 void platform_device_del(struct platform_device *pdev)
 {
 	int i;
 
 	if (pdev) {
+		device_del(&pdev->dev);
+
 		for (i = 0; i < pdev->num_resources; i++) {
 			struct resource *r = &pdev->resource[i];
 			if (r->flags & (IORESOURCE_MEM|IORESOURCE_IO))
 				release_resource(r);
 		}
-
-		device_del(&pdev->dev);
 	}
 }
 EXPORT_SYMBOL_GPL(platform_device_del);
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
xtensa-strlcpy-is-smart-enough.patch
git-alsa.patch
platform-reorder-platform_device_del.patch
apple-smc-driver-hardware-monitoring-and-control.patch
x86-msr-add-support-for-safe-variants.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900-update.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
clean-up-mutex_trylock-noise.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
rename-get_property-to-of_get_property-drivers.patch
rename-device_is_compatible-to-of_device_is_compatible.patch
