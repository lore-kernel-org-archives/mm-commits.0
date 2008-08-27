From: akpm@linux-foundation.org
Subject: + x86-pci-follow-lspci-device-vendor-style.patch added to -mm tree
Date: Wed, 27 Aug 2008 16:14:49 -0700
Message-ID: <200808272314.m7RNEn0A027849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbYH0XPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 19:15:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86/pci: follow lspci device/vendor style
has been added to the -mm tree.  Its filename is
     x86-pci-follow-lspci-device-vendor-style.patch

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
Subject: x86/pci: follow lspci device/vendor style
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Use "[%04x:%04x]" for PCI vendor/device IDs to follow the format used by
lspci(8).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/irq.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/pci/irq.c~x86-pci-follow-lspci-device-vendor-style arch/x86/pci/irq.c
--- a/arch/x86/pci/irq.c~x86-pci-follow-lspci-device-vendor-style
+++ a/arch/x86/pci/irq.c
@@ -493,7 +493,7 @@ static int pirq_amd756_get(struct pci_de
 	if (pirq <= 4)
 		irq = read_config_nybble(router, 0x56, pirq - 1);
 	dev_info(&dev->dev,
-		 "AMD756: dev [%04x/%04x], router PIRQ %d get IRQ %d\n",
+		 "AMD756: dev [%04x:%04x], router PIRQ %d get IRQ %d\n",
 		 dev->vendor, dev->device, pirq, irq);
 	return irq;
 }
@@ -501,7 +501,7 @@ static int pirq_amd756_get(struct pci_de
 static int pirq_amd756_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
 {
 	dev_info(&dev->dev,
-		 "AMD756: dev [%04x/%04x], router PIRQ %d set IRQ %d\n",
+		 "AMD756: dev [%04x:%04x], router PIRQ %d set IRQ %d\n",
 		 dev->vendor, dev->device, pirq, irq);
 	if (pirq <= 4)
 		write_config_nybble(router, 0x56, pirq - 1, irq);
@@ -823,7 +823,7 @@ static void __init pirq_find_router(stru
 	r->get = NULL;
 	r->set = NULL;
 
-	DBG(KERN_DEBUG "PCI: Attempting to find IRQ router for %04x:%04x\n",
+	DBG(KERN_DEBUG "PCI: Attempting to find IRQ router for [%04x:%04x]\n",
 	    rt->rtr_vendor, rt->rtr_device);
 
 	pirq_router_dev = pci_get_bus_and_slot(rt->rtr_bus, rt->rtr_devfn);
@@ -843,7 +843,7 @@ static void __init pirq_find_router(stru
 			h->probe(r, pirq_router_dev, pirq_router_dev->device))
 			break;
 	}
-	dev_info(&pirq_router_dev->dev, "%s IRQ router [%04x/%04x]\n",
+	dev_info(&pirq_router_dev->dev, "%s IRQ router [%04x:%04x]\n",
 		 pirq_router.name,
 		 pirq_router_dev->vendor, pirq_router_dev->device);
 
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
x86-pci-follow-lspci-device-vendor-style.patch
agp-follow-lspci-device-vendor-style.patch
v4l-dvb-follow-lspci-device-vendor-style.patch
irda-follow-lspci-device-vendor-style.patch
pci-follow-lspci-device-vendor-style.patch

