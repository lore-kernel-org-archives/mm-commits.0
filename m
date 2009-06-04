From: akpm@linux-foundation.org
Subject: + dell-wmi-mask-off-upper-bytes-of-event-response.patch added to -mm tree
Date: Thu, 04 Jun 2009 14:07:12 -0700
Message-ID: <200906042107.n54L7Cpe004348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbZFDVIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 17:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mario_limonciello@dell.com, lenb@kernel.org, mjg@redhat.com


The patch titled
     dell-wmi: mask off upper bytes of event response
has been added to the -mm tree.  Its filename is
     dell-wmi-mask-off-upper-bytes-of-event-response.patch

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
Subject: dell-wmi: mask off upper bytes of event response
From: Mario Limonciello <mario_limonciello@dell.com>

In debugging with some future machines that actually contain BIOS level
support for dell-wmi, I've determined that the upper half of the data that
comes back from wmi_get_event_data may sometimes contain extra information
that isn't currently relevant when pulling scan codes out of the data. 
This causes dell-wmi to improperly respond to these events.

Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/dell-wmi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/platform/x86/dell-wmi.c~dell-wmi-mask-off-upper-bytes-of-event-response drivers/platform/x86/dell-wmi.c
--- a/drivers/platform/x86/dell-wmi.c~dell-wmi-mask-off-upper-bytes-of-event-response
+++ a/drivers/platform/x86/dell-wmi.c
@@ -122,7 +122,12 @@ static void dell_wmi_notify(u32 value, v
 
 	if (obj && obj->type == ACPI_TYPE_BUFFER) {
 		int *buffer = (int *)obj->buffer.pointer;
-		key = dell_wmi_get_entry_by_scancode(buffer[1]);
+		/*
+		 *  The upper bytes of the event may contain
+		 *  additional information, so mask them off for the
+		 *  scancode lookup
+		 */
+		key = dell_wmi_get_entry_by_scancode(buffer[1] & 0xFFFF);
 		if (key) {
 			input_report_key(dell_wmi_input_dev, key->keycode, 1);
 			input_sync(dell_wmi_input_dev);
_

Patches currently in -mm which might be from mario_limonciello@dell.com are

dell-wmi-mask-off-upper-bytes-of-event-response.patch
dell-wmi-add-additional-keyboard-events.patch

