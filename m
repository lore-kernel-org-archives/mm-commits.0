From: akpm@linux-foundation.org
Subject: - altix-more-acpi-prt-support.patch removed from -mm tree
Date: Mon, 05 Feb 2007 01:25:29 -0800
Message-ID: <200702050925.l159PTJt016444@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37379 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXBEJ0q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 04:26:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpk@sgi.com, lenb@kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Altix: more ACPI PRT support
has been removed from the -mm tree.  Its filename was
     altix-more-acpi-prt-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Len Brown <lenb@kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/acpi.c |    3 +++
 1 file changed, 3 insertions(+)

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

git-acpi.patch
