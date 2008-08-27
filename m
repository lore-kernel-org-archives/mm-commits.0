From: akpm@linux-foundation.org
Subject: + x86-use-dev_printk-in-quirk-message.patch added to -mm tree
Date: Tue, 26 Aug 2008 17:50:04 -0700
Message-ID: <200808270050.m7R0o4kG004038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249AbYH0Aug (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 20:50:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com


The patch titled
     x86: use dev_printk in quirk message
has been added to the -mm tree.  Its filename is
     x86-use-dev_printk-in-quirk-message.patch

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
Subject: x86: use dev_printk in quirk message
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Change a VIA PCI quirk to use dev_info() rather than printk().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/kernel/pci-dma.c~x86-use-dev_printk-in-quirk-message arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~x86-use-dev_printk-in-quirk-message
+++ a/arch/x86/kernel/pci-dma.c
@@ -269,8 +269,7 @@ fs_initcall(pci_iommu_init);
 static __devinit void via_no_dac(struct pci_dev *dev)
 {
 	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
-		printk(KERN_INFO "PCI: VIA PCI bridge detected."
-				 "Disabling DAC.\n");
+		dev_info(&dev->dev, "disabling DAC on VIA PCI bridge\n");
 		forbid_dac = 1;
 	}
 }
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
x86-use-dev_printk-in-quirk-message.patch
pci-tidy-pme-support-messages.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
pnp-remove-printk-with-outdated-version.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch
firmware-use-dev_printk-when-possible.patch
resources-tidy-__request_region.patch

