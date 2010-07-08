From: akpm@linux-foundation.org
Subject: + acerhdf-fix-resource-reclaim-in-error-path.patch added to -mm tree
Date: Thu, 08 Jul 2010 14:34:40 -0700
Message-ID: <201007082134.o68LYecY030402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756529Ab0GHVfj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 17:35:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, bp@alien8.de, mjg@redhat.com, peter@piie.net


The patch titled
     acerhdf: fix resource reclaim in error path
has been added to the -mm tree.  Its filename is
     acerhdf-fix-resource-reclaim-in-error-path.patch

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
Subject: acerhdf: fix resource reclaim in error path
From: Axel Lin <axel.lin@gmail.com>

Fix resource reclaim in below cases:

1. acerhdf_register_platform() does not properly handle
   platform_device_alloc() failure and platform_device_add() failure This
   patch adds error handing for acerhdf_register_platform().

2. acerhdf_register_platform() return err with acerhdf_dev == NULL. 
   as a result, acerhdf_unregister_platform() does not do resource reclaim
   in acerhdf_init() error path.  This patch adds error handing for
   acerhdf_register_platform(), thus correct the error handing path in
   acerhdf_init().  goto out_err instead of err_unreg if
   acerhdf_register_platform() fail.

3. platform_device_del() should only used in error handling.  Current
   implementation missed a platform_device_put() in acerhdf_exit.  This
   patch fixes it by using platform_device_unregister() instead of
   platform_device_del() in acerhdf_unregister_platform.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Peter Feuerer <peter@piie.net>
Cc: Matthew Garrett <mjg@redhat.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-fix-resource-reclaim-in-error-path drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-fix-resource-reclaim-in-error-path
+++ a/drivers/platform/x86/acerhdf.c
@@ -615,17 +615,26 @@ static int acerhdf_register_platform(voi
 		return err;
 
 	acerhdf_dev = platform_device_alloc("acerhdf", -1);
-	platform_device_add(acerhdf_dev);
+	if (!acerhdf_dev) {
+		err = -ENOMEM;
+		goto err_device_alloc;
+	}
+	err = platform_device_add(acerhdf_dev);
+	if (err)
+		goto err_device_add;
 
 	return 0;
+
+err_device_add:
+	platform_device_put(acerhdf_dev);
+err_device_alloc:
+	platform_driver_unregister(&acerhdf_driver);
+	return err;
 }
 
 static void acerhdf_unregister_platform(void)
 {
-	if (!acerhdf_dev)
-		return;
-
-	platform_device_del(acerhdf_dev);
+	platform_device_unregister(acerhdf_dev);
 	platform_driver_unregister(&acerhdf_driver);
 }
 
@@ -669,7 +678,7 @@ static int __init acerhdf_init(void)
 
 	err = acerhdf_register_platform();
 	if (err)
-		goto err_unreg;
+		goto out_err;
 
 	err = acerhdf_register_thermal();
 	if (err)
@@ -682,7 +691,7 @@ err_unreg:
 	acerhdf_unregister_platform();
 
 out_err:
-	return -ENODEV;
+	return err;
 }
 
 static void __exit acerhdf_exit(void)
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.patch
fujitsu-laptop-remove-unnecessary-input_free_device-calls.patch
compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0.patch
asus_acpi-fix-a-memory-leak-in-asus_hotk_get_info.patch
asus_acpi-fix-coding-style-to-improve-readability.patch
acerhdf-make-needlessly-global-symbols-static.patch
classmate-laptop-make-needlessly-global-symbols-static.patch
fujitsu-laptop-make-needlessly-global-symbols-static.patch
msi-laptop-make-struct-rfkill_ops-const.patch
asus-laptop-fix-incorrect-return-value-for-write_acpi_int_ret-if-handle-is-null.patch
asus-laptop-return-proper-error-for-store_ledd-if-write_acpi_int-fail.patch
acerhdf-fix-resource-reclaim-in-error-path.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

