From: akpm@linux-foundation.org
Subject: - clean-up-misleading-ia64-acpi-error-message.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:28:06 -0800
Message-ID: <200803062228.m26MS6TV021157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756804AbYCFW2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:28:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gbeshers@gmail.com, gbeshers@sgi.com, lenb@kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Clean up misleading IA64 ACPI error message
has been removed from the -mm tree.  Its filename was
     clean-up-misleading-ia64-acpi-error-message.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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


