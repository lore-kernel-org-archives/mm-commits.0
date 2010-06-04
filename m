From: akpm@linux-foundation.org
Subject: + wmi-fix-memory-leak-in-parse_wdg.patch added to -mm tree
Date: Fri, 04 Jun 2010 15:33:13 -0700
Message-ID: <201006042233.o54MXDup022229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755920Ab0FDWgQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 18:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, carlos@strangeworlds.co.uk, mjg@redhat.com, trenn@suse.de


The patch titled
     wmi: fix memory leak in parse_wdg
has been added to the -mm tree.  Its filename is
     wmi-fix-memory-leak-in-parse_wdg.patch

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
Subject: wmi: fix memory leak in parse_wdg
From: Axel Lin <axel.lin@gmail.com>

kfree out.pointer and gblock on an error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/wmi.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN drivers/platform/x86/wmi.c~wmi-fix-memory-leak-in-parse_wdg drivers/platform/x86/wmi.c
--- a/drivers/platform/x86/wmi.c~wmi-fix-memory-leak-in-parse_wdg
+++ a/drivers/platform/x86/wmi.c
@@ -827,8 +827,10 @@ static __init acpi_status parse_wdg(acpi
 	total = obj->buffer.length / sizeof(struct guid_block);
 
 	gblock = kmemdup(obj->buffer.pointer, obj->buffer.length, GFP_KERNEL);
-	if (!gblock)
-		return AE_NO_MEMORY;
+	if (!gblock) {
+		status = AE_NO_MEMORY;
+		goto out_free_pointer;
+	}
 
 	for (i = 0; i < total; i++) {
 		/*
@@ -848,8 +850,10 @@ static __init acpi_status parse_wdg(acpi
 			wmi_dump_wdg(&gblock[i]);
 
 		wblock = kzalloc(sizeof(struct wmi_block), GFP_KERNEL);
-		if (!wblock)
-			return AE_NO_MEMORY;
+		if (!wblock) {
+			status = AE_NO_MEMORY;
+			goto out_free_gblock;
+		}
 
 		wblock->gblock = gblock[i];
 		wblock->handle = handle;
@@ -860,8 +864,10 @@ static __init acpi_status parse_wdg(acpi
 		list_add_tail(&wblock->list, &wmi_blocks.list);
 	}
 
-	kfree(out.pointer);
+out_free_gblock:
 	kfree(gblock);
+out_free_pointer:
+	kfree(out.pointer);
 
 	return status;
 }
_

Patches currently in -mm which might be from axel.lin@gmail.com are

intel_menlow-fix-memory-leaks-in-error-path.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
wmi-fix-memory-leak-in-parse_wdg.patch
cdc-acm-fix-resource-reclaim-in-error-path-of-acm_probe.patch

