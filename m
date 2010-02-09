From: akpm@linux-foundation.org
Subject: [to-be-updated] thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask.patch removed from -mm tree
Date: Tue, 09 Feb 2010 15:30:17 -0800
Message-ID: <201002092330.o19NUHYT008132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987Ab0BIXbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 18:31:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, hmh@hmh.eng.br, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     thinkpad-acpi: setup hotkey polling after changing hotkey_driver_mask
has been removed from the -mm tree.  Its filename was
     thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask.patch

This patch was dropped because an updated version will be merged

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

 drivers/platform/x86/thinkpad_acpi.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -2597,6 +2597,10 @@ static void hotkey_poll_set_freq(unsigne
 
 #else /* CONFIG_THINKPAD_ACPI_HOTKEY_POLL */
 
+static void hotkey_poll_setup(bool __unused)
+{
+}
+
 static void hotkey_poll_setup_safe(bool __unused)
 {
 }
@@ -2694,9 +2698,7 @@ static ssize_t hotkey_mask_store(struct 
 
 	res = hotkey_user_mask_set(t);
 
-#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
 	hotkey_poll_setup(true);
-#endif
 
 	mutex_unlock(&hotkey_mutex);
 
@@ -6272,6 +6274,9 @@ static int __init brightness_init(struct
 	tpacpi_hotkey_driver_mask_set(hotkey_driver_mask
 				| TP_ACPI_HKEY_BRGHTUP_MASK
 				| TP_ACPI_HKEY_BRGHTDWN_MASK);;
+
+	hotkey_poll_setup_safe(true);
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
eisa-fix-coding-style-for-eisa-bus-code.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch

