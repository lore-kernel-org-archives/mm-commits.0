From: akpm@linux-foundation.org
Subject: + hp-wmi-add-return-value-checking-for-input_allocate_device.patch added to -mm tree
Date: Fri, 09 Jul 2010 17:02:58 -0700
Message-ID: <201007100002.o6A02wfU000890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922Ab0GJADN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 20:03:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, mjg@redhat.com, trenn@suse.de


The patch titled
     hp-wmi: add return value checking for input_allocate_device()
has been added to the -mm tree.  Its filename is
     hp-wmi-add-return-value-checking-for-input_allocate_device.patch

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
Subject: hp-wmi: add return value checking for input_allocate_device()
From: Axel Lin <axel.lin@gmail.com>

Add error checking and return -ENOMEM if input_allocate_device() fail.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Thomas Renninger <trenn@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp-wmi.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/platform/x86/hp-wmi.c~hp-wmi-add-return-value-checking-for-input_allocate_device drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~hp-wmi-add-return-value-checking-for-input_allocate_device
+++ a/drivers/platform/x86/hp-wmi.c
@@ -527,6 +527,8 @@ static int __init hp_wmi_input_setup(voi
 	int err;
 
 	hp_wmi_input_dev = input_allocate_device();
+	if (!hp_wmi_input_dev)
+		return -ENOMEM;
 
 	hp_wmi_input_dev->name = "HP WMI hotkeys";
 	hp_wmi_input_dev->phys = "wmi/input0";
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
acer-wmi-fix-memory-leaks-in-wmid_set_capabilities-and-get_wmid_devices.patch
hp-wmi-add-return-value-checking-for-input_allocate_device.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

