From: akpm@linux-foundation.org
Subject: + wmi-fix-a-memory-leak-in-wmi_notify_debug.patch added to -mm tree
Date: Wed, 30 Jun 2010 14:01:43 -0700
Message-ID: <201006302101.o5UL1hi9026161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784Ab0F3VCD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 17:02:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, mjg@redhat.com, trenn@suse.de


The patch titled
     wmi: fix a memory leak in wmi_notify_debug
has been added to the -mm tree.  Its filename is
     wmi-fix-a-memory-leak-in-wmi_notify_debug.patch

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
Subject: wmi: fix a memory leak in wmi_notify_debug
From: Axel Lin <axel.lin@gmail.com>

When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER, the caller
must kfree the returned buffer if AE_OK is returned.

The callers of wmi_get_event_data() pass ACPI_ALLOCATE_BUFFER, and thus
must check its return value before accessing or kfree() on the buffer.

This patch adds return value checking for wmi_get_event_data() and adds a
missing kfree(obj) in the end of wmi_notify_debug

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Thomas Renninger <trenn@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/wmi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/platform/x86/wmi.c~wmi-fix-a-memory-leak-in-wmi_notify_debug drivers/platform/x86/wmi.c
--- a/drivers/platform/x86/wmi.c~wmi-fix-a-memory-leak-in-wmi_notify_debug
+++ a/drivers/platform/x86/wmi.c
@@ -518,8 +518,13 @@ static void wmi_notify_debug(u32 value, 
 {
 	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
+	acpi_status status;
 
-	wmi_get_event_data(value, &response);
+	status = wmi_get_event_data(value, &response);
+	if (status != AE_OK) {
+		printk(KERN_INFO "wmi: bad event status 0x%x\n", status);
+		return;
+	}
 
 	obj = (union acpi_object *)response.pointer;
 
@@ -543,6 +548,7 @@ static void wmi_notify_debug(u32 value, 
 	default:
 		printk("object type 0x%X\n", obj->type);
 	}
+	kfree(obj);
 }
 
 /**
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.patch
wmi-fix-a-memory-leak-in-wmi_notify_debug.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

