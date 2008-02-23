From: akpm@linux-foundation.org
Subject: + pci-simplify-quirk-debug-output.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:30:31 -0800
Message-ID: <200802230731.m1N7VJij017990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYBWHyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, greg@kroah.com


The patch titled
     PCI: simplify quirk debug output
has been added to the -mm tree.  Its filename is
     pci-simplify-quirk-debug-output.patch

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
Subject: PCI: simplify quirk debug output
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

print_fn_descriptor_symbol() prints the address if we don't have a symbol,
so no need to print both.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pci/quirks.c~pci-simplify-quirk-debug-output drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-simplify-quirk-debug-output
+++ a/drivers/pci/quirks.c
@@ -1498,8 +1498,8 @@ static void pci_do_fixups(struct pci_dev
 		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
  		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
 #ifdef DEBUG
-			dev_dbg(&dev->dev, "calling quirk 0x%p", f->hook);
-			print_fn_descriptor_symbol(": %s()\n",
+			dev_dbg(&dev->dev, "calling ");
+			print_fn_descriptor_symbol("%s()\n",
 				(unsigned long) f->hook);
 #endif
 			f->hook(dev);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

mm-only-enforce-acpi-resource-conflict-checks.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup-update.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
pci-simplify-quirk-debug-output.patch
pci-remove-pci=routeirq-noise-from-dmesg.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
