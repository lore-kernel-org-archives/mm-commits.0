From: akpm@linux-foundation.org
Subject: + acer-wmi-fix-memory-leaks-in-wmid_set_capabilities-and-get_wmid_devices.patch added to -mm tree
Date: Fri, 09 Jul 2010 17:02:12 -0700
Message-ID: <201007100002.o6A02CSH000796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013Ab0GJACY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 20:02:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, carlos@strangeworlds.co.uk, mjg@redhat.com


The patch titled
     acer-wmi: fix memory leaks in WMID_set_capabilities and get_wmid_devices
has been added to the -mm tree.  Its filename is
     acer-wmi-fix-memory-leaks-in-wmid_set_capabilities-and-get_wmid_devices.patch

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
Subject: acer-wmi: fix memory leaks in WMID_set_capabilities and get_wmid_devices
From: Axel Lin <axel.lin@gmail.com>

When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER, the caller
must kfree the returned buffer if AE_OK is returned.

The callers of wmi_query_block() pass ACPI_ALLOCATE_BUFFER, and thus must
check its return value before accessing or kfree() on the buffer.

This patch adds a missing kfree(out.pointer) before exit
WMID_set_capabilities() and get_wmid_devices().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acer-wmi.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/acer-wmi.c~acer-wmi-fix-memory-leaks-in-wmid_set_capabilities-and-get_wmid_devices drivers/platform/x86/acer-wmi.c
--- a/drivers/platform/x86/acer-wmi.c~acer-wmi-fix-memory-leaks-in-wmid_set_capabilities-and-get_wmid_devices
+++ a/drivers/platform/x86/acer-wmi.c
@@ -772,6 +772,7 @@ static acpi_status WMID_set_capabilities
 		obj->buffer.length == sizeof(u32)) {
 		devices = *((u32 *) obj->buffer.pointer);
 	} else {
+		kfree(out.pointer);
 		return AE_ERROR;
 	}
 
@@ -788,6 +789,7 @@ static acpi_status WMID_set_capabilities
 	if (!(devices & 0x20))
 		max_brightness = 0x9;
 
+	kfree(out.pointer);
 	return status;
 }
 
@@ -1094,6 +1096,7 @@ static u32 get_wmid_devices(void)
 	struct acpi_buffer out = {ACPI_ALLOCATE_BUFFER, NULL};
 	union acpi_object *obj;
 	acpi_status status;
+	u32 devices = 0;
 
 	status = wmi_query_block(WMID_GUID2, 1, &out);
 	if (ACPI_FAILURE(status))
@@ -1102,10 +1105,11 @@ static u32 get_wmid_devices(void)
 	obj = (union acpi_object *) out.pointer;
 	if (obj && obj->type == ACPI_TYPE_BUFFER &&
 		obj->buffer.length == sizeof(u32)) {
-		return *((u32 *) obj->buffer.pointer);
-	} else {
-		return 0;
+		devices = *((u32 *) obj->buffer.pointer);
 	}
+
+	kfree(out.pointer);
+	return devices;
 }
 
 /*
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
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

