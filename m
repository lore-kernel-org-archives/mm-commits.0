From: akpm@linux-foundation.org
Subject: - pnpacpi-simplify-irq_flags.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:57 -0700
Message-ID: <200708242058.l7OKwvwo014347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762978AbXHXVJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, perex@suse.cz, mm-commits@vger.kernel.org


The patch titled
     PNPACPI: simplify irq_flags()
has been removed from the -mm tree.  Its filename was
     pnpacpi-simplify-irq_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
serial-keep-the-dtr-setting-for-serial-console.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
