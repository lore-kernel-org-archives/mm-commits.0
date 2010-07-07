From: akpm@linux-foundation.org
Subject: + asus_acpi-fix-coding-style-to-improve-readability.patch added to -mm tree
Date: Wed, 07 Jul 2010 16:44:05 -0700
Message-ID: <201007072344.o67Ni5CR001360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758101Ab0GGXoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2010 19:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, corentincj@iksaif.net, len.brown@intel.com, mjg@redhat.com, sziwan@users.sourceforge.net


The patch titled
     asus_acpi: fix coding style to improve readability
has been added to the -mm tree.  Its filename is
     asus_acpi-fix-coding-style-to-improve-readability.patch

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
Subject: asus_acpi: fix coding style to improve readability
From: Axel Lin <axel.lin@gmail.com>

In the case of no match ( hotk->model == END_MODEL ), the only posible
case to return 0 is to have a Samsung P30 detected.  This patch improves
readability by moving related code after if/else clause to be inside if
clause.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Karol Kozimor <sziwan@users.sourceforge.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/asus_acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/asus_acpi.c~asus_acpi-fix-coding-style-to-improve-readability drivers/platform/x86/asus_acpi.c
--- a/drivers/platform/x86/asus_acpi.c~asus_acpi-fix-coding-style-to-improve-readability
+++ a/drivers/platform/x86/asus_acpi.c
@@ -1330,6 +1330,9 @@ static int asus_hotk_get_info(void)
 			hotk->model = P30;
 			printk(KERN_NOTICE
 			       "  Samsung P30 detected, supported\n");
+			hotk->methods = &model_conf[hotk->model];
+			kfree(model);
+			return 0;
 		} else {
 			hotk->model = M2E;
 			printk(KERN_NOTICE "  unsupported model %s, trying "
@@ -1339,9 +1342,6 @@ static int asus_hotk_get_info(void)
 			kfree(model);
 			return -ENODEV;
 		}
-		hotk->methods = &model_conf[hotk->model];
-		kfree(model);
-		return 0;
 	}
 	hotk->methods = &model_conf[hotk->model];
 	printk(KERN_NOTICE "  %s model detected, supported\n", string);
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.patch
fujitsu-laptop-remove-unnecessary-input_free_device-calls.patch
compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0.patch
asus_acpi-fix-a-memory-leak-in-asus_hotk_get_info.patch
asus_acpi-fix-coding-style-to-improve-readability.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

