From: akpm@linux-foundation.org
Subject: [merged] mn10300-use-generic-pci_enable_resources.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:31 -0800
Message-ID: <201001112019.o0BKJVxN025578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128Ab0AKUfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:35:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: use generic pci_enable_resources()
has been removed from the -mm tree.  Its filename was
     mn10300-use-generic-pci_enable_resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: use generic pci_enable_resources()
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Use the generic pci_enable_resources() instead of the arch-specific code.

Unlike this arch-specific code, the generic version:

 - checks PCI_NUM_RESOURCES (11), not 6, resources
 - skips resources that have neither IORESOURCE_IO nor IORESOURCE_MEM set
 - skips ROM resources unless IORESOURCE_ROM_ENABLE is set
 - checks for resource collisions with "!r->parent"

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/unit-asb2305/pci-asb2305.c |   39 ----------------------
 arch/mn10300/unit-asb2305/pci-asb2305.h |    1 
 arch/mn10300/unit-asb2305/pci.c         |    3 +
 3 files changed, 2 insertions(+), 41 deletions(-)

diff -puN arch/mn10300/unit-asb2305/pci-asb2305.c~mn10300-use-generic-pci_enable_resources arch/mn10300/unit-asb2305/pci-asb2305.c
--- a/arch/mn10300/unit-asb2305/pci-asb2305.c~mn10300-use-generic-pci_enable_resources
+++ a/arch/mn10300/unit-asb2305/pci-asb2305.c
@@ -218,45 +218,6 @@ void __init pcibios_resource_survey(void
 	pcibios_allocate_resources(1);
 }
 
-int pcibios_enable_resources(struct pci_dev *dev, int mask)
-{
-	u16 cmd, old_cmd;
-	int idx;
-	struct resource *r;
-
-	pci_read_config_word(dev, PCI_COMMAND, &cmd);
-	old_cmd = cmd;
-
-	for (idx = 0; idx < 6; idx++) {
-		/* Only set up the requested stuff */
-		if (!(mask & (1 << idx)))
-			continue;
-
-		r = &dev->resource[idx];
-
-		if (!r->start && r->end) {
-			printk(KERN_ERR
-			       "PCI: Device %s not available because of"
-			       " resource collisions\n",
-			       pci_name(dev));
-			return -EINVAL;
-		}
-
-		if (r->flags & IORESOURCE_IO)
-			cmd |= PCI_COMMAND_IO;
-		if (r->flags & IORESOURCE_MEM)
-			cmd |= PCI_COMMAND_MEMORY;
-	}
-
-	if (dev->resource[PCI_ROM_RESOURCE].start)
-		cmd |= PCI_COMMAND_MEMORY;
-
-	if (cmd != old_cmd)
-		pci_write_config_word(dev, PCI_COMMAND, cmd);
-
-	return 0;
-}
-
 /*
  *  If we set up a device for bus mastering, we need to check the latency
  *  timer as certain crappy BIOSes forget to set it properly.
diff -puN arch/mn10300/unit-asb2305/pci-asb2305.h~mn10300-use-generic-pci_enable_resources arch/mn10300/unit-asb2305/pci-asb2305.h
--- a/arch/mn10300/unit-asb2305/pci-asb2305.h~mn10300-use-generic-pci_enable_resources
+++ a/arch/mn10300/unit-asb2305/pci-asb2305.h
@@ -34,7 +34,6 @@ extern unsigned int pci_probe;
 extern unsigned int pcibios_max_latency;
 
 extern void pcibios_resource_survey(void);
-extern int pcibios_enable_resources(struct pci_dev *dev, int mask);
 
 /* pci.c */
 
diff -puN arch/mn10300/unit-asb2305/pci.c~mn10300-use-generic-pci_enable_resources arch/mn10300/unit-asb2305/pci.c
--- a/arch/mn10300/unit-asb2305/pci.c~mn10300-use-generic-pci_enable_resources
+++ a/arch/mn10300/unit-asb2305/pci.c
@@ -440,7 +440,7 @@ int pcibios_enable_device(struct pci_dev
 {
 	int err;
 
-	err = pcibios_enable_resources(dev, mask);
+	err = pci_enable_resources(dev, mask);
 	if (err == 0)
 		pcibios_enable_irq(dev);
 	return err;
@@ -455,6 +455,7 @@ static void __init unit_disable_pcnet(st
 
 	bus->number = 0;
 
+	o->read (bus, PCI_DEVFN(2, 0), PCI_VENDOR_ID,		4, &x);
 	o->read (bus, PCI_DEVFN(2, 0), PCI_COMMAND,		2, &x);
 	x |= PCI_COMMAND_MASTER |
 		PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
linux-next.patch

