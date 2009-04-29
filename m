From: akpm@linux-foundation.org
Subject: + dell-wmi-mask-off-bis-provided-garbage-in-scancode-data.patch added to -mm tree
Date: Wed, 29 Apr 2009 13:16:17 -0700
Message-ID: <200904292016.n3TKGHrX029299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474AbZD2USU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 16:18:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mario_limonciello@dell.com, dtor@mail.ru, len.brown@intel.com, mjg@redhat.com


The patch titled
     dell-wmi: mask off BIS-provided garbage in scancode data
has been added to the -mm tree.  Its filename is
     dell-wmi-mask-off-bis-provided-garbage-in-scancode-data.patch

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
Subject: dell-wmi: mask off BIS-provided garbage in scancode data
From: Mario Limonciello <mario_limonciello@dell.com>

In debugging with some future machines that actually contain BIOS level
support for dell-wmi, I've determined that the upper half of the data that
comes back from wmi_get_event_data may sometimes contain extra information
that isn't currently relevant when pulling scan codes out of the data. 
This causes dell-wmi to improperly respond to these events.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/dell-wmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/dell-wmi.c~dell-wmi-mask-off-bis-provided-garbage-in-scancode-data drivers/platform/x86/dell-wmi.c
--- a/drivers/platform/x86/dell-wmi.c~dell-wmi-mask-off-bis-provided-garbage-in-scancode-data
+++ a/drivers/platform/x86/dell-wmi.c
@@ -122,7 +122,7 @@ static void dell_wmi_notify(u32 value, v
 
 	if (obj && obj->type == ACPI_TYPE_BUFFER) {
 		int *buffer = (int *)obj->buffer.pointer;
-		key = dell_wmi_get_entry_by_scancode(buffer[1]);
+		key = dell_wmi_get_entry_by_scancode(0xFFFF & buffer[1]);
 		if (key) {
 			input_report_key(dell_wmi_input_dev, key->keycode, 1);
 			input_sync(dell_wmi_input_dev);
@@ -130,7 +130,7 @@ static void dell_wmi_notify(u32 value, v
 			input_sync(dell_wmi_input_dev);
 		} else
 			printk(KERN_INFO "dell-wmi: Unknown key %x pressed\n",
-			       buffer[1]);
+			       0xFFFF & buffer[1]);
 	}
 }
 
_

Patches currently in -mm which might be from mario_limonciello@dell.com are

dell-wmi-mask-off-bis-provided-garbage-in-scancode-data.patch

