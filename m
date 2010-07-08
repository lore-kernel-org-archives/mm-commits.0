From: akpm@linux-foundation.org
Subject: + asus-laptop-return-proper-error-for-store_ledd-if-write_acpi_int-fail.patch added to -mm tree
Date: Thu, 08 Jul 2010 12:49:00 -0700
Message-ID: <201007081949.o68Jn0wq025016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758543Ab0GHTtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 15:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, alan-jenkins@tuffmail.co.uk, corentincj@iksaif.net, mjg@redhat.com


The patch titled
     asus-laptop: return proper error for store_ledd if write_acpi_int fail
has been added to the -mm tree.  Its filename is
     asus-laptop-return-proper-error-for-store_ledd-if-write_acpi_int-fail.patch

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
Subject: asus-laptop: return proper error for store_ledd if write_acpi_int fail
From: Axel Lin <axel.lin@gmail.com>

In current implementation, store_ledd() does not return error if
write_acpi_int fail.  This patch fixes it by return -ENODEV if
write_acpi_int fail.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/asus-laptop.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/asus-laptop.c~asus-laptop-return-proper-error-for-store_ledd-if-write_acpi_int-fail drivers/platform/x86/asus-laptop.c
--- a/drivers/platform/x86/asus-laptop.c~asus-laptop-return-proper-error-for-store_ledd-if-write_acpi_int-fail
+++ a/drivers/platform/x86/asus-laptop.c
@@ -796,10 +796,11 @@ static ssize_t store_ledd(struct device 
 
 	rv = parse_arg(buf, count, &value);
 	if (rv > 0) {
-		if (write_acpi_int(asus->handle, METHOD_LEDD, value))
+		if (write_acpi_int(asus->handle, METHOD_LEDD, value)) {
 			pr_warning("LED display write failed\n");
-		else
-			asus->ledd_status = (u32) value;
+			return -ENODEV;
+		}
+		asus->ledd_status = (u32) value;
 	}
 	return rv;
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
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

