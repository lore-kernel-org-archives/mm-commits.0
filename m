From: akpm@linux-foundation.org
Subject: [merged] thinkpad-acpi-make-driver-events-work-in-nvram-poll-mode.patch removed from -mm tree
Date: Wed, 03 Mar 2010 12:04:47 -0800
Message-ID: <201003032004.o23K4lYg028523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756474Ab0CCUE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 15:04:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hmh@hmh.eng.br, cascardo@holoscopio.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     thinkpad-acpi: make driver events work in NVRAM poll mode
has been removed from the -mm tree.  Its filename was
     thinkpad-acpi-make-driver-events-work-in-nvram-poll-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thinkpad-acpi: make driver events work in NVRAM poll mode
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Thadeu Lima de Souza Cascardo reports this:

Brightness notification does not work until the user writes to hotkey_mask
attribute.  That's because the polling thread will only run if
hotkey_user_mask is set and someone is reading the input device or if
hotkey_driver_mask is set.  In this second case, this condition is not
tested after the mask is changed, because the brightness and volume
drivers are started after the hotkey drivers.

Fix tpacpi_hotkey_driver_mask_set() to call hotkey_poll_setup(), so that
the poller kthread will be started when needed.

Reported-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Tested-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/thinkpad_acpi.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-make-driver-events-work-in-nvram-poll-mode drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-make-driver-events-work-in-nvram-poll-mode
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -2082,6 +2082,7 @@ static struct attribute_set *hotkey_dev_
 
 static void tpacpi_driver_event(const unsigned int hkey_event);
 static void hotkey_driver_event(const unsigned int scancode);
+static void hotkey_poll_setup(const bool may_warn);
 
 /* HKEY.MHKG() return bits */
 #define TP_HOTKEY_TABLET_MASK (1 << 3)
@@ -2264,6 +2265,8 @@ static int tpacpi_hotkey_driver_mask_set
 
 	rc = hotkey_mask_set((hotkey_acpi_mask | hotkey_driver_mask) &
 							~hotkey_source_mask);
+	hotkey_poll_setup(true);
+
 	mutex_unlock(&hotkey_mutex);
 
 	return rc;
@@ -2548,7 +2551,7 @@ static void hotkey_poll_stop_sync(void)
 }
 
 /* call with hotkey_mutex held */
-static void hotkey_poll_setup(bool may_warn)
+static void hotkey_poll_setup(const bool may_warn)
 {
 	const u32 poll_driver_mask = hotkey_driver_mask & hotkey_source_mask;
 	const u32 poll_user_mask = hotkey_user_mask & hotkey_source_mask;
@@ -2579,7 +2582,7 @@ static void hotkey_poll_setup(bool may_w
 	}
 }
 
-static void hotkey_poll_setup_safe(bool may_warn)
+static void hotkey_poll_setup_safe(const bool may_warn)
 {
 	mutex_lock(&hotkey_mutex);
 	hotkey_poll_setup(may_warn);
@@ -2597,7 +2600,11 @@ static void hotkey_poll_set_freq(unsigne
 
 #else /* CONFIG_THINKPAD_ACPI_HOTKEY_POLL */
 
-static void hotkey_poll_setup_safe(bool __unused)
+static void hotkey_poll_setup(const bool __unused)
+{
+}
+
+static void hotkey_poll_setup_safe(const bool __unused)
 {
 }
 
_

Patches currently in -mm which might be from hmh@hmh.eng.br are

origin.patch

