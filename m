From: akpm@linux-foundation.org
Subject: [merged] dell-wmi-add-additional-keyboard-events.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:01:00 -0700
Message-ID: <200906221701.n5MH107A010385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbZFVRDe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:03:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mario_limonciello@dell.com, lenb@kernel.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dell-wmi: add additional keyboard events
has been removed from the -mm tree.  Its filename was
     dell-wmi-add-additional-keyboard-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dell-wmi: add additional keyboard events
From: Mario Limonciello <mario_limonciello@dell.com>

Upcoming Dell hardware will send more keyboard events via WMI.  Add
support for them.

Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/dell-wmi.c |   45 +++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff -puN drivers/platform/x86/dell-wmi.c~dell-wmi-add-additional-keyboard-events drivers/platform/x86/dell-wmi.c
--- a/drivers/platform/x86/dell-wmi.c~dell-wmi-add-additional-keyboard-events
+++ a/drivers/platform/x86/dell-wmi.c
@@ -46,10 +46,53 @@ struct key_entry {
 	u16 keycode;
 };
 
-enum { KE_KEY, KE_SW, KE_END };
+enum { KE_KEY, KE_SW, KE_IGNORE, KE_END };
+
+/*
+ * Certain keys are flagged as KE_IGNORE. All of these are either
+ * notifications (rather than requests for change) or are also sent
+ * via the keyboard controller so should not be sent again.
+ */
 
 static struct key_entry dell_wmi_keymap[] = {
 	{KE_KEY, 0xe045, KEY_PROG1},
+	{KE_KEY, 0xe009, KEY_EJECTCD},
+
+	/* These also contain the brightness level at offset 6 */
+	{KE_KEY, 0xe006, KEY_BRIGHTNESSUP},
+	{KE_KEY, 0xe005, KEY_BRIGHTNESSDOWN},
+
+	/* Battery health status button */
+	{KE_KEY, 0xe007, KEY_BATTERY},
+
+	/* This is actually for all radios. Although physically a
+	 * switch, the notification does not provide an indication of
+	 * state and so it should be reported as a key */
+	{KE_KEY, 0xe008, KEY_WLAN},
+
+	/* The next device is at offset 6, the active devices are at
+	   offset 8 and the attached devices at offset 10 */
+	{KE_KEY, 0xe00b, KEY_DISPLAYTOGGLE},
+
+	{KE_IGNORE, 0xe00c, KEY_KBDILLUMTOGGLE},
+
+	/* BIOS error detected */
+	{KE_IGNORE, 0xe00d, KEY_RESERVED},
+
+	/* Wifi Catcher */
+	{KE_KEY, 0xe011, KEY_PROG2},
+
+	/* Ambient light sensor toggle */
+	{KE_IGNORE, 0xe013, KEY_RESERVED},
+
+	{KE_IGNORE, 0xe020, KEY_MUTE},
+	{KE_IGNORE, 0xe02e, KEY_VOLUMEDOWN},
+	{KE_IGNORE, 0xe030, KEY_VOLUMEUP},
+	{KE_IGNORE, 0xe033, KEY_KBDILLUMUP},
+	{KE_IGNORE, 0xe034, KEY_KBDILLUMDOWN},
+	{KE_IGNORE, 0xe03a, KEY_CAPSLOCK},
+	{KE_IGNORE, 0xe045, KEY_NUMLOCK},
+	{KE_IGNORE, 0xe046, KEY_SCROLLLOCK},
 	{KE_END, 0}
 };
 
_

Patches currently in -mm which might be from mario_limonciello@dell.com are

linux-next.patch

