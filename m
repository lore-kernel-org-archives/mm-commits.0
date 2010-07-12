From: akpm@linux-foundation.org
Subject: + edd-fix-possible-memory-leak-in-edd_init-error-path.patch added to -mm tree
Date: Mon, 12 Jul 2010 16:23:15 -0700
Message-ID: <201007122323.o6CNNFQV003076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755569Ab0GLXXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 19:23:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, jens.axboe@oracle.com, shemminger@vyatta.com


The patch titled
     edd: fix possible memory leak in edd_init() error path
has been added to the -mm tree.  Its filename is
     edd-fix-possible-memory-leak-in-edd_init-error-path.patch

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
Subject: edd: fix possible memory leak in edd_init() error path
From: Axel Lin <axel.lin@gmail.com>

The error may happen at any iteration of the for loop, this patch properly
unregisters already registed edd_devices in error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/edd.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN drivers/firmware/edd.c~edd-fix-possible-memory-leak-in-edd_init-error-path drivers/firmware/edd.c
--- a/drivers/firmware/edd.c~edd-fix-possible-memory-leak-in-edd_init-error-path
+++ a/drivers/firmware/edd.c
@@ -744,7 +744,7 @@ static inline int edd_num_devices(void)
 static int __init
 edd_init(void)
 {
-	unsigned int i;
+	int i;
 	int rc=0;
 	struct edd_device *edev;
 
@@ -760,21 +760,30 @@ edd_init(void)
 	if (!edd_kset)
 		return -ENOMEM;
 
-	for (i = 0; i < edd_num_devices() && !rc; i++) {
+	for (i = 0; i < edd_num_devices(); i++) {
 		edev = kzalloc(sizeof (*edev), GFP_KERNEL);
-		if (!edev)
-			return -ENOMEM;
+		if (!edev) {
+			rc = -ENOMEM;
+			goto out;
+		}
 
 		rc = edd_device_register(edev, i);
 		if (rc) {
 			kfree(edev);
-			break;
+			goto out;
 		}
 		edd_devices[i] = edev;
 	}
 
-	if (rc)
-		kset_unregister(edd_kset);
+	return 0;
+
+out:
+	while (--i >= 0) {
+		edev = edd_devices[i];
+		if (edev)
+			edd_device_unregister(edev);
+	}
+	kset_unregister(edd_kset);
 	return rc;
 }
 
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
toshiba_acpi-make-remove_device-and-add_device-void.patch
toshiba_acpi-rename-add_device-and-remove_device-to-create_toshiba_proc_entries-and-remove_toshiba_proc_entries.patch
hp-wmi-add-return-value-checking-for-input_allocate_device.patch
acer-wmi-fix-memory-leaks-in-wmid_set_capabilities-and-get_wmid_devices.patch
acer-wmi-fix-memory-leaks-in-wmab_execute-error-path.patch
acer-wmi-remove-non-used-acer_quirks-struct-definition.patch
asus-laptop-fix-wapf-wlan_status-and-bluetooth_status-module_param-permissions.patch
eeepc-laptop-fix-hotplug_disabled-module_param-permissions.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch
edd-fix-possible-memory-leak-in-edd_init-error-path.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch

