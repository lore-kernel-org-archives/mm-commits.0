From: akpm@linux-foundation.org
Subject: + classmate-laptop-make-needlessly-global-symbols-static.patch added to -mm tree
Date: Thu, 08 Jul 2010 12:47:12 -0700
Message-ID: <201007081947.o68JlCa3024869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755918Ab0GHTr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 15:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, cascardo@holoscopio.com, don@syst.com.br, mjg@redhat.com


The patch titled
     classmate-laptop: make needlessly global symbols static
has been added to the -mm tree.  Its filename is
     classmate-laptop-make-needlessly-global-symbols-static.patch

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
Subject: classmate-laptop: make needlessly global symbols static
From: Axel Lin <axel.lin@gmail.com>

cmpc_accel_sensitivity_attr is needlessly defined global.
This patch makes the symbol static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Daniel Oliveira Nascimento <don@syst.com.br>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/classmate-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/x86/classmate-laptop.c~classmate-laptop-make-needlessly-global-symbols-static drivers/platform/x86/classmate-laptop.c
--- a/drivers/platform/x86/classmate-laptop.c~classmate-laptop-make-needlessly-global-symbols-static
+++ a/drivers/platform/x86/classmate-laptop.c
@@ -208,7 +208,7 @@ static ssize_t cmpc_accel_sensitivity_st
 	return strnlen(buf, count);
 }
 
-struct device_attribute cmpc_accel_sensitivity_attr = {
+static struct device_attribute cmpc_accel_sensitivity_attr = {
 	.attr = { .name = "sensitivity", .mode = 0660 },
 	.show = cmpc_accel_sensitivity_show,
 	.store = cmpc_accel_sensitivity_store
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
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

