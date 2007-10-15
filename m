From: akpm@linux-foundation.org
Subject: + clean-up-misleading-ia64-acpi-error-message.patch added to -mm tree
Date: Mon, 15 Oct 2007 13:02:54 -0700
Message-ID: <200710152002.l9FK2sZS022379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933091AbXJOUDN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 16:03:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gbeshers@gmail.com, gbeshers@sgi.com, lenb@kernel.org, tony.luck@intel.com


The patch titled
     Clean up misleading IA64 ACPI error message
has been added to the -mm tree.  Its filename is
     clean-up-misleading-ia64-acpi-error-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Clean up misleading IA64 ACPI error message
From: George Beshers <gbeshers@gmail.com>

On Altix (sn2) machines the "Error parsing MADT" message is misleading
because the lack of IOSAPIC entries is expected.

Since I am sure someone will ask, I have been told that the chance of this
changing anytime soon is close to nil.

Signed-off-by: George Beshers <gbeshers@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/acpi.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/ia64/kernel/acpi.c~clean-up-misleading-ia64-acpi-error-message arch/ia64/kernel/acpi.c
--- a/arch/ia64/kernel/acpi.c~clean-up-misleading-ia64-acpi-error-message
+++ a/arch/ia64/kernel/acpi.c
@@ -678,9 +678,14 @@ int __init acpi_boot_init(void)
 	/* I/O APIC */
 
 	if (acpi_table_parse_madt
-	    (ACPI_MADT_TYPE_IO_SAPIC, acpi_parse_iosapic, NR_IOSAPICS) < 1)
-		printk(KERN_ERR PREFIX
-		       "Error parsing MADT - no IOSAPIC entries\n");
+	    (ACPI_MADT_TYPE_IO_SAPIC, acpi_parse_iosapic, NR_IOSAPICS) < 1) {
+		if (ia64_platform_is("sn2"))
+			printk(KERN_NOTICE
+			       "SGI/SN machines do not have IOSAPIC entries\n");
+		else
+			printk(KERN_ERR PREFIX
+			       "Error parsing MADT - no IOSAPIC entries\n");
+	}
 
 	/* System-Level Interrupt Routing */
 
_

Patches currently in -mm which might be from gbeshers@gmail.com are

clean-up-misleading-ia64-acpi-error-message.patch
