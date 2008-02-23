From: akpm@linux-foundation.org
Subject: + pci-remove-pci=routeirq-noise-from-dmesg.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:31:38 -0800
Message-ID: <200802230732.m1N7WRUU018082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757341AbYBWIDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:03:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     PCI: remove "pci=routeirq" noise from dmesg
has been added to the -mm tree.  Its filename is
     pci-remove-pci=routeirq-noise-from-dmesg.patch

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
Subject: PCI: remove "pci=routeirq" noise from dmesg
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

The "pci=routeirq" option was added in 2004, and I don't get any valid reports
anymore.  The option is still mentioned in kernel-parameters.txt.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/pci/acpi.c~pci-remove-pci=routeirq-noise-from-dmesg arch/x86/pci/acpi.c
--- a/arch/x86/pci/acpi.c~pci-remove-pci=routeirq-noise-from-dmesg
+++ a/arch/x86/pci/acpi.c
@@ -262,11 +262,11 @@ static int __init pci_acpi_init(void)
 		 * also do it here in case there are still broken drivers that
 		 * don't use pci_enable_device().
 		 */
-		printk(KERN_INFO "PCI: Routing PCI interrupts for all devices because \"pci=routeirq\" specified\n");
+		printk(KERN_INFO "PCI: Routing PCI interrupts for all devices "
+				"because \"pci=routeirq\" specified\n");
 		for_each_pci_dev(dev)
 			acpi_pci_irq_enable(dev);
-	} else
-		printk(KERN_INFO "PCI: If a device doesn't work, try \"pci=routeirq\".  If it helps, post a report\n");
+	}
 
 #ifdef CONFIG_X86_IO_APIC
 	if (acpi_ioapic)
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
