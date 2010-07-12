From: akpm@linux-foundation.org
Subject: + acer-wmi-fix-memory-leaks-in-wmab_execute-error-path.patch added to -mm tree
Date: Mon, 12 Jul 2010 12:34:17 -0700
Message-ID: <201007121934.o6CJYIUH025137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352Ab0GLTej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 15:34:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, alan-jenkins@tuffmail.co.uk, carlos@strangeworlds.co.uk, mjg@redhat.com, trenn@suse.de


The patch titled
     acer-wmi: fix memory leaks in wmab_execute error path
has been added to the -mm tree.  Its filename is
     acer-wmi-fix-memory-leaks-in-wmab_execute-error-path.patch

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
Subject: acer-wmi: fix memory leaks in wmab_execute error path
From: Axel Lin <axel.lin@gmail.com>

When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER, the caller
must kfree the returned buffer if AE_OK is returned.

Call Trace:
wmab_execute
  -> wmi_evaluate_method
    -> acpi_evaluate_object

Thus if callers of wmab_execute() pass ACPI_ALLOCATE_BUFFER, the return
buffer must be kfreed if wmab_execute return AE_OK.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acer-wmi.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/platform/x86/acer-wmi.c~acer-wmi-fix-memory-leaks-in-wmab_execute-error-path drivers/platform/x86/acer-wmi.c
--- a/drivers/platform/x86/acer-wmi.c~acer-wmi-fix-memory-leaks-in-wmab_execute-error-path
+++ a/drivers/platform/x86/acer-wmi.c
@@ -555,6 +555,7 @@ static acpi_status AMW0_find_mailled(voi
 	obj->buffer.length == sizeof(struct wmab_ret)) {
 		ret = *((struct wmab_ret *) obj->buffer.pointer);
 	} else {
+		kfree(out.pointer);
 		return AE_ERROR;
 	}
 
@@ -598,6 +599,7 @@ static acpi_status AMW0_set_capabilities
 	obj->buffer.length == sizeof(struct wmab_ret)) {
 		ret = *((struct wmab_ret *) obj->buffer.pointer);
 	} else {
+		kfree(out.pointer);
 		return AE_ERROR;
 	}
 
@@ -607,15 +609,24 @@ static acpi_status AMW0_set_capabilities
 	args.ebx = 2 << 8;
 	args.ebx |= ACER_AMW0_BLUETOOTH_MASK;
 
+	/*
+	 * It's ok to use existing buffer for next wmab_execute call.
+	 * But we need to kfree(out.pointer) if next wmab_execute call
+	 * returns AE_BUFFER_OVERFLOW.
+	 */
 	status = wmab_execute(&args, &out);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(status)) {
+		if (status == AE_BUFFER_OVERFLOW)
+			kfree(out.pointer);
 		return status;
+	}
 
 	obj = (union acpi_object *) out.pointer;
 	if (obj && obj->type == ACPI_TYPE_BUFFER
 	&& obj->buffer.length == sizeof(struct wmab_ret)) {
 		ret = *((struct wmab_ret *) obj->buffer.pointer);
 	} else {
+		kfree(out.pointer);
 		return AE_ERROR;
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
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

