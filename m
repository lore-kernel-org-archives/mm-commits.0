From: akpm@linux-foundation.org
Subject: + hp-wmi-add-proper-hotkey-support.patch added to -mm tree
Date: Wed, 27 Aug 2008 16:37:28 -0700
Message-ID: <200808272337.m7RNbS5t028806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955AbYH0XiS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 19:38:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, mjg@redhat.com


The patch titled
     hp-wmi: add proper hotkey support
has been added to the -mm tree.  Its filename is
     hp-wmi-add-proper-hotkey-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hp-wmi: add proper hotkey support
From: Matthew Garrett <mjg59@srcf.ucam.org>

It turns out that event 0x4 merely indcates that a hotkey has been
pressed, not which one.  A further query is required in order to determine
the actual keypress.  The following patch adds support for that along with
the known keycodes.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hp-wmi.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/misc/hp-wmi.c~hp-wmi-add-proper-hotkey-support drivers/misc/hp-wmi.c
--- a/drivers/misc/hp-wmi.c~hp-wmi-add-proper-hotkey-support
+++ a/drivers/misc/hp-wmi.c
@@ -49,6 +49,7 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE9
 #define HPWMI_ALS_QUERY 0x3
 #define HPWMI_DOCK_QUERY 0x4
 #define HPWMI_WIRELESS_QUERY 0x5
+#define HPWMI_HOTKEY_QUERY 0xc
 
 static int __init hp_wmi_bios_setup(struct platform_device *device);
 static int __exit hp_wmi_bios_remove(struct platform_device *device);
@@ -69,7 +70,7 @@ struct bios_return {
 
 struct key_entry {
 	char type;		/* See KE_* below */
-	u8 code;
+	u16 code;
 	u16 keycode;
 };
 
@@ -79,7 +80,9 @@ static struct key_entry hp_wmi_keymap[] 
 	{KE_SW, 0x01, SW_DOCK},
 	{KE_KEY, 0x02, KEY_BRIGHTNESSUP},
 	{KE_KEY, 0x03, KEY_BRIGHTNESSDOWN},
-	{KE_KEY, 0x04, KEY_HELP},
+	{KE_KEY, 0x20e6, KEY_PROG1},
+	{KE_KEY, 0x2142, KEY_MEDIA},
+	{KE_KEY, 0x231b, KEY_HELP},
 	{KE_END, 0}
 };
 
@@ -318,6 +321,9 @@ void hp_wmi_notify(u32 value, void *cont
 
 	if (obj && obj->type == ACPI_TYPE_BUFFER && obj->buffer.length == 8) {
 		int eventcode = *((u8 *) obj->buffer.pointer);
+		if (eventcode == 0x4)
+			eventcode = hp_wmi_perform_query(HPWMI_HOTKEY_QUERY, 0,
+							 0);
 		key = hp_wmi_get_entry_by_scancode(eventcode);
 		if (key) {
 			switch (key->type) {
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

hp-wmi-add-proper-hotkey-support.patch
linux-next.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7.patch
eeepc-laptop-use-standard-interfaces.patch
hp-wmi-update-to-match-current-rfkill-semantics.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch

