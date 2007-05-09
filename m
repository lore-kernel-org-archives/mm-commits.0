From: akpm@linux-foundation.org
Subject: - applesmc-use-the-address-as-platform-device-id.patch removed from -mm tree
Date: Wed, 09 May 2007 01:42:46 -0700
Message-ID: <200705090842.l498gkFx018230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326AbXEIInG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 04:43:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     applesmc: Use the address as platform device ID
has been removed from the -mm tree.  Its filename was
     applesmc-use-the-address-as-platform-device-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+), 1 deletion(-)

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
git-alsa.patch
git-dvb.patch
scx200-use-mutex-instead-of-semaphore.patch
