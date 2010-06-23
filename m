From: akpm@linux-foundation.org
Subject: + acer-wmi-fix-resource-reclaim-in-acer_wmi_init-error-path.patch added to -mm tree
Date: Wed, 23 Jun 2010 13:04:12 -0700
Message-ID: <201006232004.o5NK4CJT028681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab0FWUEZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 16:04:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, carlos@strangeworlds.co.uk, len.brown@intel.com, mjg@redhat.com


The patch titled
     acer-wmi: fix resource reclaim in acer_wmi_init() error path
has been added to the -mm tree.  Its filename is
     acer-wmi-fix-resource-reclaim-in-acer_wmi_init-error-path.patch

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
Subject: acer-wmi: fix resource reclaim in acer_wmi_init() error path
From: Axel Lin <axel.lin@gmail.com>

Fix resource reclaiming in the acer_wmi_init() error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acer-wmi.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff -puN drivers/platform/x86/acer-wmi.c~acer-wmi-fix-resource-reclaim-in-acer_wmi_init-error-path drivers/platform/x86/acer-wmi.c
--- a/drivers/platform/x86/acer-wmi.c~acer-wmi-fix-resource-reclaim-in-acer_wmi_init-error-path
+++ a/drivers/platform/x86/acer-wmi.c
@@ -1327,22 +1327,31 @@ static int __init acer_wmi_init(void)
 		       "generic video driver\n");
 	}
 
-	if (platform_driver_register(&acer_platform_driver)) {
+	err = platform_driver_register(&acer_platform_driver);
+	if (err) {
 		printk(ACER_ERR "Unable to register platform driver.\n");
 		goto error_platform_register;
 	}
+
 	acer_platform_device = platform_device_alloc("acer-wmi", -1);
-	platform_device_add(acer_platform_device);
+	if (!acer_platform_device) {
+		err = -ENOMEM;
+		goto error_device_alloc;
+	}
+
+	err = platform_device_add(acer_platform_device);
+	if (err)
+		goto error_device_add;
 
 	err = create_sysfs();
 	if (err)
-		return err;
+		goto error_create_sys;
 
 	if (wmi_has_guid(WMID_GUID2)) {
 		interface->debug.wmid_devices = get_wmid_devices();
 		err = create_debugfs();
 		if (err)
-			return err;
+			goto error_create_debugfs;
 	}
 
 	/* Override any initial settings with values from the commandline */
@@ -1350,8 +1359,16 @@ static int __init acer_wmi_init(void)
 
 	return 0;
 
+error_create_debugfs:
+	remove_sysfs(acer_platform_device);
+error_create_sys:
+	platform_device_del(acer_platform_device);
+error_device_add:
+	platform_device_put(acer_platform_device);
+error_device_alloc:
+	platform_driver_unregister(&acer_platform_driver);
 error_platform_register:
-	return -ENODEV;
+	return err;
 }
 
 static void __exit acer_wmi_exit(void)
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
wmi-fix-memory-leak-in-parse_wdg.patch
acer-wmi-hp-wmi-use-platform_device_unregister-instead-of-platform_device_del-in-module_exit.patch
hp-wmi-add-error-handling-for-hp_wmi_init.patch
hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.patch
acer-wmi-fix-resource-reclaim-in-acer_wmi_init-error-path.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

