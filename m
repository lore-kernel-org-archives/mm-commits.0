From: akpm@linux-foundation.org
Subject: + asus-laptop-fix-wapf-wlan_status-and-bluetooth_status-module_param-permissions.patch added to -mm tree
Date: Mon, 12 Jul 2010 16:18:19 -0700
Message-ID: <201007122318.o6CNIJRN002833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082Ab0GLXZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 19:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, alan-jenkins@tuffmail.co.uk, corentincj@iksaif.net, mjg@redhat.com


The patch titled
     asus-laptop: fix wapf, wlan_status and bluetooth_status module_param permissions
has been added to the -mm tree.  Its filename is
     asus-laptop-fix-wapf-wlan_status-and-bluetooth_status-module_param-permissions.patch

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
Subject: asus-laptop: fix wapf, wlan_status and bluetooth_status module_param permissions
From: Axel Lin <axel.lin@gmail.com>

The wapf module parameters defines the behavior of the Fn+Fx wlan key. 
The wlan_status and bluetooth_status module parameters are for setting the
wlan/bluetooth status on boot.

All above module parameters are determinated only at the module load time.
 Change the value after the module is loaded does not make sense and has
no effect at all, thus set the permissions to 0444 instead of 0644.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/asus-laptop.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/asus-laptop.c~asus-laptop-fix-wapf-wlan_status-and-bluetooth_status-module_param-permissions drivers/platform/x86/asus-laptop.c
--- a/drivers/platform/x86/asus-laptop.c~asus-laptop-fix-wapf-wlan_status-and-bluetooth_status-module_param-permissions
+++ a/drivers/platform/x86/asus-laptop.c
@@ -76,18 +76,18 @@ MODULE_LICENSE("GPL");
  * So, if something doesn't work as you want, just try other values =)
  */
 static uint wapf = 1;
-module_param(wapf, uint, 0644);
+module_param(wapf, uint, 0444);
 MODULE_PARM_DESC(wapf, "WAPF value");
 
 static int wlan_status = 1;
 static int bluetooth_status = 1;
 
-module_param(wlan_status, int, 0644);
+module_param(wlan_status, int, 0444);
 MODULE_PARM_DESC(wlan_status, "Set the wireless status on boot "
 		 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
 		 "default is 1");
 
-module_param(bluetooth_status, int, 0644);
+module_param(bluetooth_status, int, 0444);
 MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
 		 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
 		 "default is 1");
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

