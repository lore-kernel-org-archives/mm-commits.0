From: akpm@linux-foundation.org
Subject: + asus-laptop-fix-incorrect-return-value-for-write_acpi_int_ret-if-handle-is-null.patch added to -mm tree
Date: Thu, 08 Jul 2010 12:48:58 -0700
Message-ID: <201007081948.o68JmwNe025013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758543Ab0GHTtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 15:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, alan-jenkins@tuffmail.co.uk, corentincj@iksaif.net, mjg@redhat.com


The patch titled
     asus-laptop: fix incorrect return value for write_acpi_int_ret if handle is NULL
has been added to the -mm tree.  Its filename is
     asus-laptop-fix-incorrect-return-value-for-write_acpi_int_ret-if-handle-is-null.patch

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
Subject: asus-laptop: fix incorrect return value for write_acpi_int_ret if handle is NULL
From: Axel Lin <axel.lin@gmail.com>

According to the comments of write_acpi_int_ret(), write_acpi_int_ret()
should return 0 if write is successful, -1 else.  Thus if handle is NULL,
the write does not happen, it should return -1.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/asus-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/x86/asus-laptop.c~asus-laptop-fix-incorrect-return-value-for-write_acpi_int_ret-if-handle-is-null drivers/platform/x86/asus-laptop.c
--- a/drivers/platform/x86/asus-laptop.c~asus-laptop-fix-incorrect-return-value-for-write_acpi_int_ret-if-handle-is-null
+++ a/drivers/platform/x86/asus-laptop.c
@@ -297,7 +297,7 @@ static int write_acpi_int_ret(acpi_handl
 	acpi_status status;
 
 	if (!handle)
-		return 0;
+		return -1;
 
 	params.count = 1;
 	params.pointer = &in_obj;
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

