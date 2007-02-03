From: akpm@osdl.org
Subject: + altix-more-acpi-prt-support.patch added to -mm tree
Date: Fri, 02 Feb 2007 17:38:05 -0800
Message-ID: <200702030138.l131c5e2023865@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49221 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406AbXBCBjW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 20:39:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpk@sgi.com, lenb@kernel.org, tony.luck@intel.com


The patch titled
     Altix: more ACPI PRT support
has been added to the -mm tree.  Its filename is
     altix-more-acpi-prt-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Altix: more ACPI PRT support
From: John Keller <jpk@sgi.com>

The SN Altix platform does not conform to the IOSAPIC IRQ routing model. 
Add code in acpi_unregister_gsi() to check if (acpi_irq_model ==
ACPI_IRQ_MODEL_PLATFORM) and return.

Due to an oversight, this code was not added previously when
similar code was added to acpi_register_gsi().

http://marc.theaimsgroup.com/?l=linux-acpi&m=116680983430121&w=2

Signed-off-by: John Keller <jpk@sgi.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/kernel/acpi.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN arch/ia64/kernel/acpi.c~altix-more-acpi-prt-support arch/ia64/kernel/acpi.c
--- a/arch/ia64/kernel/acpi.c~altix-more-acpi-prt-support
+++ a/arch/ia64/kernel/acpi.c
@@ -609,6 +609,9 @@ EXPORT_SYMBOL(acpi_register_gsi);
 
 void acpi_unregister_gsi(u32 gsi)
 {
+	if (acpi_irq_model == ACPI_IRQ_MODEL_PLATFORM)
+		return;
+
 	iosapic_unregister_intr(gsi);
 }
 
_

Patches currently in -mm which might be from jpk@sgi.com are

altix-more-acpi-prt-support.patch
git-acpi.patch
