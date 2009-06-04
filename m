From: akpm@linux-foundation.org
Subject: + dell-wmi-add-additional-keyboard-events.patch added to -mm tree
Date: Thu, 04 Jun 2009 14:07:14 -0700
Message-ID: <200906042107.n54L7EoN004351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbZFDVIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 17:08:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mario_limonciello@dell.com, lenb@kernel.org, mjg@redhat.com


The patch titled
     dell-wmi: add additional keyboard events
has been added to the -mm tree.  Its filename is
     dell-wmi-add-additional-keyboard-events.patch

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

dell-wmi-mask-off-upper-bytes-of-event-response.patch
dell-wmi-add-additional-keyboard-events.patch

