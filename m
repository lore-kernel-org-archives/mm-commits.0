From: akpm@linux-foundation.org
Subject: + acpi-add-missing-_osi-strings-resend.patch added to -mm tree
Date: Tue, 05 Jul 2011 15:08:58 -0700
Message-ID: <201107052208.p65M8wTm027182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609Ab1GEWJB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 18:09:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, lenb@kernel.org, mjg@redhat.com, sebastian.jarosz@intel.com


The patch titled
     acpi: add missing _OSI strings
has been added to the -mm tree.  Its filename is
     acpi-add-missing-_osi-strings-resend.patch

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
Subject: acpi: add missing _OSI strings
From: Shaohua Li <shaohua.li@intel.com>

Linux supports some optional features, but it should notify the BIOS about
them via the _OSI method.  Currently Linux doesn't notify any, which might
make such features not work because the BIOS doesn't know about them.

Reported-by: "Jarosz, Sebastian" <sebastian.jarosz@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/osl.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/osl.c~acpi-add-missing-_osi-strings-resend drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~acpi-add-missing-_osi-strings-resend
+++ a/drivers/acpi/osl.c
@@ -1083,7 +1083,13 @@ struct osi_setup_entry {
 	bool enable;
 };
 
-static struct osi_setup_entry __initdata osi_setup_entries[OSI_STRING_ENTRIES_MAX];
+static struct osi_setup_entry __initdata
+		osi_setup_entries[OSI_STRING_ENTRIES_MAX] = {
+	{"Module Device", true},
+	{"Processor Device", true},
+	{"3.0 _SCP Extensions", true},
+	{"Processor Aggregator Device", true},
+};
 
 void __init acpi_osi_setup(char *str)
 {
_

Patches currently in -mm which might be from shaohua.li@intel.com are

mm-__tlb_remove_page-checks-correct-batch.patch
linux-next.patch
acpi-add-missing-_osi-strings-resend.patch
tmpfs-simplify-prealloc_page.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

