From: akpm@linux-foundation.org
Subject: + hp-wmi-add-error-handling-for-hp_wmi_init.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:53:25 -0700
Message-ID: <201006141953.o5EJrPYX027608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100Ab0FNTyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, len.brown@intel.com, mjg@redhat.com, trenn@suse.de


The patch titled
     hp-wmi: add error handling for hp_wmi_init()
has been added to the -mm tree.  Its filename is
     hp-wmi-add-error-handling-for-hp_wmi_init.patch

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
Subject: hp-wmi: add error handling for hp_wmi_init()
From: Axel Lin <axel.lin@gmail.com>

hp_wmi_init() does not check for errors and always returns success.  This
patch properly handles recource reclaim and return err in error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp-wmi.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff -puN drivers/platform/x86/hp-wmi.c~hp-wmi-add-error-handling-for-hp_wmi_init drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~hp-wmi-add-error-handling-for-hp_wmi_init
+++ a/drivers/platform/x86/hp-wmi.c
@@ -715,23 +715,42 @@ static int __init hp_wmi_init(void)
 	if (wmi_has_guid(HPWMI_EVENT_GUID)) {
 		err = wmi_install_notify_handler(HPWMI_EVENT_GUID,
 						 hp_wmi_notify, NULL);
-		if (ACPI_SUCCESS(err))
-			hp_wmi_input_setup();
+		if (ACPI_FAILURE(err))
+			return -EINVAL;
+		err = hp_wmi_input_setup();
+		if (err) {
+			wmi_remove_notify_handler(HPWMI_EVENT_GUID);
+			return err;
+		}
 	}
 
 	if (wmi_has_guid(HPWMI_BIOS_GUID)) {
 		err = platform_driver_register(&hp_wmi_driver);
 		if (err)
-			return 0;
+			goto err_driver_reg;
 		hp_wmi_platform_dev = platform_device_alloc("hp-wmi", -1);
 		if (!hp_wmi_platform_dev) {
-			platform_driver_unregister(&hp_wmi_driver);
-			return 0;
+			err = -ENOMEM;
+			goto err_device_alloc;
 		}
-		platform_device_add(hp_wmi_platform_dev);
+		err = platform_device_add(hp_wmi_platform_dev);
+		if (err)
+			goto err_device_add;
 	}
 
 	return 0;
+
+err_device_add:
+	platform_device_put(hp_wmi_platform_dev);
+err_device_alloc:
+	platform_driver_unregister(&hp_wmi_driver);
+err_driver_reg:
+	if (wmi_has_guid(HPWMI_EVENT_GUID)) {
+		input_unregister_device(hp_wmi_input_dev);
+		wmi_remove_notify_handler(HPWMI_EVENT_GUID);
+	}
+
+	return err;
 }
 
 static void __exit hp_wmi_exit(void)
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
wmi-fix-memory-leak-in-parse_wdg.patch
acer-wmi-hp-wmi-use-platform_device_unregister-instead-of-platform_device_del-in-module_exit.patch
hp-wmi-add-error-handling-for-hp_wmi_init.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch

