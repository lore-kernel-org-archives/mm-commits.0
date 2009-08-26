From: akpm@linux-foundation.org
Subject: + wmi-fix-kernel-panic-when-stack-protection-enabled.patch added to -mm tree
Date: Wed, 26 Aug 2009 07:54:11 -0700
Message-ID: <200908261454.n7QEsBab007418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbZHZOzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 10:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lcostantino@gmail.com, bjorn.helgaas@hp.com, carlos@strangeworlds.co.uk, len.brown@intel.com, rjw@sisk.pl, stable@kernel.org


The patch titled
     wmi: fix kernel panic when stack protection enabled.
has been added to the -mm tree.  Its filename is
     wmi-fix-kernel-panic-when-stack-protection-enabled.patch

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
Subject: wmi: fix kernel panic when stack protection enabled.
From: Costantino Leandro <lcostantino@gmail.com>

Summary:
Kernel panic arise when stack protection is enabled, since strncat will
add a null terminating byte '\0'; So in functions
like this one (wmi_query_block):
        char wc[4]="WC";
	....
	strncat(method, block->object_id, 2);
        ...
the length of wc should be n+1 (wc[5]) or stack protection
fault will arise. This is not noticeable when stack protection is
disabled,but , isn't good either.
Config used: [CONFIG_CC_STACKPROTECTOR_ALL=y,
	      CONFIG_CC_STACKPROTECTOR=y]

Panic Trace
------------
       .... stack-protector: kernel stack corrupted in : fa7b182c
       2.6.30-rc8-obelisco-generic
       call_trace:
           [<c04a6c40>] ? panic+0x45/0xd9
	   [<c012925d>] ? __stack_chk_fail+0x1c/0x40
	   [<fa7b182c>] ? wmi_query_block+0x15a/0x162 [wmi]
	   [<fa7b182c>] ? wmi_query_block+0x15a/0x162 [wmi]
	   [<fa7e7000>] ? acer_wmi_init+0x00/0x61a [acer_wmi]
	   [<fa7e7135>] ? acer_wmi_init+0x135/0x61a [acer_wmi]
	   [<c0101159>] ? do_one_initcall+0x50+0x126

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13514

Signed-off-by: Costantino Leandro <lcostantino@gmail.com>
Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Len Brown <len.brown@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/wmi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/platform/x86/wmi.c~wmi-fix-kernel-panic-when-stack-protection-enabled drivers/platform/x86/wmi.c
--- a/drivers/platform/x86/wmi.c~wmi-fix-kernel-panic-when-stack-protection-enabled
+++ a/drivers/platform/x86/wmi.c
@@ -270,7 +270,7 @@ u32 method_id, const struct acpi_buffer 
 	acpi_status status;
 	struct acpi_object_list input;
 	union acpi_object params[3];
-	char method[4] = "WM";
+	char method[5] = "WM";
 
 	if (!find_guid(guid_string, &wblock))
 		return AE_ERROR;
@@ -328,8 +328,8 @@ struct acpi_buffer *out)
 	acpi_status status, wc_status = AE_ERROR;
 	struct acpi_object_list input, wc_input;
 	union acpi_object wc_params[1], wq_params[1];
-	char method[4];
-	char wc_method[4] = "WC";
+	char method[5];
+	char wc_method[5] = "WC";
 
 	if (!guid_string || !out)
 		return AE_BAD_PARAMETER;
@@ -410,7 +410,7 @@ const struct acpi_buffer *in)
 	acpi_handle handle;
 	struct acpi_object_list input;
 	union acpi_object params[2];
-	char method[4] = "WS";
+	char method[5] = "WS";
 
 	if (!guid_string || !in)
 		return AE_BAD_DATA;
_

Patches currently in -mm which might be from lcostantino@gmail.com are

wmi-fix-kernel-panic-when-stack-protection-enabled.patch

