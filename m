From: akpm@linux-foundation.org
Subject: - define-module_system_table-for-mbp_nvidia_blo-and-applesmco.patch removed from -mm tree
Date: Wed, 10 Dec 2008 11:17:37 -0800
Message-ID: <200812101917.mBAJHbXX014096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbYLJTSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Dec 2008 14:18:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, mjg@redhat.com, nicolas@boichat.chpenguin-kernel@i-love.sakura.ne.jp, rydberg@euromail.se, mm-commits@vger.kernel.org


The patch titled
     Define MODULE_SYSTEM_TABLE for mbp_nvidia_bl.o and applesmc.o
has been removed from the -mm tree.  Its filename was
     define-module_system_table-for-mbp_nvidia_blo-and-applesmco.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Define MODULE_SYSTEM_TABLE for mbp_nvidia_bl.o and applesmc.o
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

When compiling mbp_nvidia_bl.o and applesmc.o using gcc 3.3.5,
the below compilation error occurs.

  CC [M]  drivers/video/backlight/mbp_nvidia_bl.o
  drivers/video/backlight/mbp_nvidia_bl.c:114: error: storage size of `__mod_dmi_device_table' isn't known
  make[1]: *** [drivers/video/backlight/mbp_nvidia_bl.o] Error 1
  make: *** [drivers/video/backlight/mbp_nvidia_bl.o] Error 2

  CC [M]  drivers/hwmon/applesmc.o
  drivers/hwmon/applesmc.c:1567: error: storage size of `__mod_dmi_device_table' isn't known
  make[1]: *** [drivers/hwmon/applesmc.o] Error 1
  make: *** [drivers/hwmon/applesmc.o] Error 2

Diffs between 2.6.27.7 and 2.6.28-rc7 are shown below.

  # diff linux-2.6.27.7/drivers/video/backlight/mbp_nvidia_bl.c linux-2.6.28-rc7/drivers/video/backlight/mbp_nvidia_bl.c
  114,116c114
  < MODULE_ALIAS("svnAppleInc.:pnMacBookPro3,1");
  < MODULE_ALIAS("svnAppleInc.:pnMacBookPro3,2");
  < MODULE_ALIAS("svnAppleInc.:pnMacBookPro4,1");
  ---
  > MODULE_DEVICE_TABLE(dmi, mbp_device_table);

We can see that MODULE_ALIAS is replaced by MODULE_DEVICE_TABLE.

mbp_nvidia_bl.c and applesmc.c are using MODULE_DEVICE_TABLE(dmi, ...);
which will extracted to __mod_dmi_device_table, but it seems to me that
dmi does not define __mod_dmi_device_table.

I don't know why gcc 4.x doesn't trigger this compilation error.

I don't know whether mbp_nvidia_bl.o and applesmc.o compiled with this
patch work or not.  Can somebody who has these hardwares try this patch?

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c                |    2 +-
 drivers/video/backlight/mbp_nvidia_bl.c |    2 +-
 include/linux/module.h                  |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/applesmc.c~define-module_system_table-for-mbp_nvidia_blo-and-applesmco drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~define-module_system_table-for-mbp_nvidia_blo-and-applesmco
+++ a/drivers/hwmon/applesmc.c
@@ -1564,4 +1564,4 @@ module_exit(applesmc_exit);
 MODULE_AUTHOR("Nicolas Boichat");
 MODULE_DESCRIPTION("Apple SMC");
 MODULE_LICENSE("GPL v2");
-MODULE_DEVICE_TABLE(dmi, applesmc_whitelist);
+MODULE_SYSTEM_TABLE(dmi, applesmc_whitelist);
diff -puN drivers/video/backlight/mbp_nvidia_bl.c~define-module_system_table-for-mbp_nvidia_blo-and-applesmco drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c~define-module_system_table-for-mbp_nvidia_blo-and-applesmco
+++ a/drivers/video/backlight/mbp_nvidia_bl.c
@@ -111,4 +111,4 @@ module_exit(mbp_exit);
 MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
 MODULE_DESCRIPTION("Nvidia-based Macbook Pro Backlight Driver");
 MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(dmi, mbp_device_table);
+MODULE_SYSTEM_TABLE(dmi, mbp_device_table);
diff -puN include/linux/module.h~define-module_system_table-for-mbp_nvidia_blo-and-applesmco include/linux/module.h
--- a/include/linux/module.h~define-module_system_table-for-mbp_nvidia_blo-and-applesmco
+++ a/include/linux/module.h
@@ -139,6 +139,8 @@ extern struct module __this_module;
 
 #define MODULE_DEVICE_TABLE(type,name)		\
   MODULE_GENERIC_TABLE(type##_device,name)
+#define MODULE_SYSTEM_TABLE(type,name)		\
+  MODULE_GENERIC_TABLE(type##_system,name)
 
 /* Version of form [<epoch>:]<version>[-<extra-version>].
    Or for CVS/RCS ID version, everything but the number is stripped.
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

define-module_system_table-for-mbp_nvidia_blo-and-applesmco.patch

