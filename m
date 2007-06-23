From: akpm@linux-foundation.org
Subject: - asus_acpi-fix-oops-on-non-asus-machines.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:33 -0700
Message-ID: <200706231928.l5NJSXwL022156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50153 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468AbXFWTez (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:34:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxime@tralhalla.org, lenb@kernel.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     asus_acpi: fix oops on non-asus machines
has been removed from the -mm tree.  Its filename was
     asus_acpi-fix-oops-on-non-asus-machines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: asus_acpi: fix oops on non-asus machines
From: Maxime Austruy <maxime@tralhalla.org>

If asus_acpi_init doesn't find any device it knows about, it mistakenly
returns a "success" error code even though it cleans up after itself.  Later
when trying to rmmod asus_acpi, the module_exit routine would try to clean up
one more time and we would end up calling
acpi_bus_unregister_driver(&asus_hotk_driver) twice.  This patch addresses
this first problem by returning -ENODEV when no appropriate device is found.  

Then there was also another bug with the code handling the return value of
backlight_device_register.  If this function ever failed, the driver would
cleanup by calling the module_exit routine from module_init, but it would
still return "success".  So any attempt to rmmod this module would result in
asus_acpi_exit being called twice but it's not ready to handle it (I haven't
hit this bug, just found it by code inspection).  This patch fixes that by
inserting a return -ENODEV; at the end of this error handling path.

Signed-off-by: Maxime Austruy <maxime@tralhalla.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/asus_acpi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/asus_acpi.c~asus_acpi-fix-oops-on-non-asus-machines drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~asus_acpi-fix-oops-on-non-asus-machines
+++ a/drivers/acpi/asus_acpi.c
@@ -1398,7 +1398,7 @@ static int __init asus_acpi_init(void)
 	if (!asus_hotk_found) {
 		acpi_bus_unregister_driver(&asus_hotk_driver);
 		remove_proc_entry(PROC_ASUS, acpi_root_dir);
-		return result;
+		return -ENODEV;
 	}
 
 	asus_backlight_device = backlight_device_register("asus",NULL,NULL,
@@ -1407,6 +1407,7 @@ static int __init asus_acpi_init(void)
 		printk(KERN_ERR "Could not register asus backlight device\n");
 		asus_backlight_device = NULL;
 		asus_acpi_exit();
+		return -ENODEV;
 	}
         asus_backlight_device->props.max_brightness = 15;
 
_

Patches currently in -mm which might be from maxime@tralhalla.org are
