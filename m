From: akpm@linux-foundation.org
Subject: + acpi-fix-medion-_prt-quirk-use-isa_-not-isa.patch added to -mm tree
Date: Tue, 25 Mar 2008 12:47:15 -0700
Message-ID: <200803251947.m2PJlFqm010260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323AbYCYTsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 15:48:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, johann-nikolaus.andreae@nacs.de, lenb@kernel.org


The patch titled
     ACPI: fix Medion _PRT quirk (use "ISA_", not "ISA")
has been added to the -mm tree.  Its filename is
     acpi-fix-medion-_prt-quirk-use-isa_-not-isa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI: fix Medion _PRT quirk (use "ISA_", not "ISA")
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

This fixes the builtin RTL8139 NIC on the Medion MD9580-F laptop.  The BIOS
reports the interrupt routing incorrectly.  I recently added a quirk to work
around this, and this patch fixes a typo in the quirk.

We pad every ACPI pathname component to four characters, so ".ISA." will never
match anything.  We need ".ISA_." instead.

Thank you Johann-Nikolaus Andreae for patiently testing this patch.

See http://bugzilla.kernel.org/show_bug.cgi?id=4773

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Johann-Nikolaus Andreae <johann-nikolaus.andreae@nacs.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/pci_irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/pci_irq.c~acpi-fix-medion-_prt-quirk-use-isa_-not-isa drivers/acpi/pci_irq.c
--- a/drivers/acpi/pci_irq.c~acpi-fix-medion-_prt-quirk-use-isa_-not-isa
+++ a/drivers/acpi/pci_irq.c
@@ -131,8 +131,8 @@ struct prt_quirk {
  */
 static struct prt_quirk prt_quirks[] = {
 	{ medion_md9580, 0, 0, 9, 'A',
-		"\\_SB_.PCI0.ISA.LNKA",
-		"\\_SB_.PCI0.ISA.LNKB"},
+		"\\_SB_.PCI0.ISA_.LNKA",
+		"\\_SB_.PCI0.ISA_.LNKB"},
 	{ dell_optiplex, 0, 0, 0xd, 'A',
 		"\\_SB_.LNKB",
 		"\\_SB_.LNKA"},
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
pnp-use-dev_printk-for-quirk-messages.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
acpi-fix-medion-_prt-quirk-use-isa_-not-isa.patch

