From: akpm@linux-foundation.org
Subject: + thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask.patch added to -mm tree
Date: Mon, 08 Feb 2010 15:51:07 -0800
Message-ID: <201002082351.o18Np718010716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab0BHXvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 18:51:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, hmh@hmh.eng.br, lenb@kernel.org


The patch titled
     thinkpad-acpi: setup hotkey polling after changing hotkey_driver_mask
has been added to the -mm tree.  Its filename is
     thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask.patch

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
Subject: thinkpad-acpi: setup hotkey polling after changing hotkey_driver_mask
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Brightness notification does not work until the user writes to hotkey_mask
attribute.  That's because the polling thread will only run if
hotkey_user_mask is set and someone is reading the input device or if
hotkey_driver_mask is set.  In this second case, this condition is not
tested after the mask is changed, because the brightness and volume
drivers are started after the hotkey drivers.

This fixes the test for the polling condition that ends up starting the
polling thread after hotkey_driver_mask is set in brightness and volume
init functions.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/thinkpad_acpi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -6272,6 +6272,11 @@ static int __init brightness_init(struct
 	tpacpi_hotkey_driver_mask_set(hotkey_driver_mask
 				| TP_ACPI_HKEY_BRGHTUP_MASK
 				| TP_ACPI_HKEY_BRGHTDWN_MASK);;
+
+#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
+	hotkey_poll_setup(true);
+#endif
+
 	return 0;
 }
 
@@ -6903,6 +6908,10 @@ static int __init volume_init(struct ibm
 			| TP_ACPI_HKEY_VOLDWN_MASK
 			| TP_ACPI_HKEY_MUTE_MASK);
 
+#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
+	hotkey_poll_setup(true);
+#endif
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

linux-next.patch
thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask.patch
thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask-fix.patch
eisa-fix-coding-style-for-eisa-bus-code.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch

