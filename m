From: akpm@linux-foundation.org
Subject: + applesmc-use-the-address-as-platform-device-id.patch added to -mm tree
Date: Tue, 08 May 2007 14:31:20 -0700
Message-ID: <200705082131.l48LVK7n002273@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968024AbXEHVbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:31:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, nicolas@boichat.ch


The patch titled
     applesmc: Use the address as platform device ID
has been added to the -mm tree.  Its filename is
     applesmc-use-the-address-as-platform-device-id.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: applesmc: Use the address as platform device ID
From: Jean Delvare <khali@linux-fr.org>

Let the applesmc device export its address to userspace.  libsensors needs
this to recognize the device and give it a unique ID.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/applesmc.c~applesmc-use-the-address-as-platform-device-id drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~applesmc-use-the-address-as-platform-device-id
+++ a/drivers/hwmon/applesmc.c
@@ -1190,7 +1190,8 @@ static int __init applesmc_init(void)
 	if (ret)
 		goto out_region;
 
-	pdev = platform_device_register_simple("applesmc", -1, NULL, 0);
+	pdev = platform_device_register_simple("applesmc", APPLESMC_DATA_PORT,
+					       NULL, 0);
 	if (IS_ERR(pdev)) {
 		ret = PTR_ERR(pdev);
 		goto out_driver;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
apple-smc-driver-hardware-monitoring-and-control.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
clean-up-mutex_trylock-noise.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
applesmc-use-the-address-as-platform-device-id.patch
applesmc-use-standard-sysfs-names-for-labels.patch
git-alsa.patch
scx200-use-mutex-instead-of-semaphore.patch
x86-msr-add-support-for-safe-variants.patch
