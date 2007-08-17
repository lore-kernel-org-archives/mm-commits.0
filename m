From: akpm@linux-foundation.org
Subject: + pnpacpi-simplify-irq_flags.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:39:12 -0700
Message-ID: <200708171839.l7HIdCpD023927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54380 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755343AbXHQSks (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:40:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, perex@suse.cz


The patch titled
     PNPACPI: simplify irq_flags()
has been added to the -mm tree.  Its filename is
     pnpacpi-simplify-irq_flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNPACPI: simplify irq_flags()
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

No need for a temporary variable; just return the flags once we know them.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/pnp/pnpacpi/rsparser.c~pnpacpi-simplify-irq_flags drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnpacpi-simplify-irq_flags
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -34,20 +34,17 @@
  */
 static int irq_flags(int triggering, int polarity)
 {
-	int flag;
-
 	if (triggering == ACPI_LEVEL_SENSITIVE) {
 		if (polarity == ACPI_ACTIVE_LOW)
-			flag = IORESOURCE_IRQ_LOWLEVEL;
+			return IORESOURCE_IRQ_LOWLEVEL;
 		else
-			flag = IORESOURCE_IRQ_HIGHLEVEL;
+			return IORESOURCE_IRQ_HIGHLEVEL;
 	} else {
 		if (polarity == ACPI_ACTIVE_LOW)
-			flag = IORESOURCE_IRQ_LOWEDGE;
+			return IORESOURCE_IRQ_LOWEDGE;
 		else
-			flag = IORESOURCE_IRQ_HIGHEDGE;
+			return IORESOURCE_IRQ_HIGHEDGE;
 	}
-	return flag;
 }
 
 static void decode_irq_flags(int flag, int *triggering, int *polarity)
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-fix-up-after-lindent.patch
pnpacpi-simplify-irq_flags.patch
pnpacpi-remove-unnecessary-casts-of-void.patch
isapnp-removed-unused-isapnp_detected-and-isapnp_debug.patch
pnp-remove-module-infrastructure.patch
pnp-remove-null-pointer-checks.patch
