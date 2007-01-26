From: akpm@osdl.org
Subject: + bugfixes-pci-devices-get-assigned-redundant-irqs.patch added to -mm tree
Date: Fri, 26 Jan 2007 12:13:59 -0800
Message-ID: <200701262013.l0QKDxVG025428@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53170 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbXAZUOW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 15:14:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andreas.block@esd-electronics.com, ebiederm@xmission.com, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, torvalds@osdl.org


The patch titled
     Bugfixes: PCI devices get assigned redundant IRQs
has been added to the -mm tree.  Its filename is
     bugfixes-pci-devices-get-assigned-redundant-irqs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Bugfixes: PCI devices get assigned redundant IRQs
From: "Andreas Block" <andreas.block@esd-electronics.com>

I'm currently working on a port to a CPCI board with a MPC5200.  When
testing the PCI interrupt routing, I discovered the following: Even devices
which don't use interrupts (-> PCI Spec.: Interrupt Pin Register is zero),
get an interrupt assigned (this is at least true for most of the
PPC-targets I looked at).

The cause is pretty obvious in drivers/pci/setup-irq.c.  I guess at least
in an ideal world with correctly designed hardware, the code should rather
look as in the patch below.

Of course it doesn't hurt anybody to have an unuseable IRQ assigned to a
PCI-to-PCI-bridge (or something alike), but to me it seems a bit strange. 
Please correct me, if I'm mislead.

The patch below is tested on the above mentioned CPCI-MPC5200 board and is
compiler tested with the latest git-repository kernel on x86.

Cc: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/setup-irq.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff -puN drivers/pci/setup-irq.c~bugfixes-pci-devices-get-assigned-redundant-irqs drivers/pci/setup-irq.c
--- a/drivers/pci/setup-irq.c~bugfixes-pci-devices-get-assigned-redundant-irqs
+++ a/drivers/pci/setup-irq.c
@@ -24,7 +24,7 @@ pdev_fixup_irq(struct pci_dev *dev,
 	       int (*map_irq)(struct pci_dev *, u8, u8))
 {
 	u8 pin, slot;
-	int irq;
+	int irq = 0;
 
 	/* If this device is not on the primary bus, we need to figure out
 	   which interrupt pin it will come in on.   We know which slot it
@@ -33,16 +33,18 @@ pdev_fixup_irq(struct pci_dev *dev,
 	   apply the swizzle function.  */
 
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
-	/* Cope with 0 and illegal. */
-	if (pin == 0 || pin > 4)
+	/* Cope with illegal. */
+	if (pin > 4)
 		pin = 1;
 
-	/* Follow the chain of bridges, swizzling as we go.  */
-	slot = (*swizzle)(dev, &pin);
-
-	irq = (*map_irq)(dev, slot, pin);
-	if (irq == -1)
-		irq = 0;
+	if (pin != 0) {
+		/* Follow the chain of bridges, swizzling as we go.  */
+		slot = (*swizzle)(dev, &pin);
+
+		irq = (*map_irq)(dev, slot, pin);
+		if (irq == -1)
+			irq = 0;
+	}
 	dev->irq = irq;
 
 	pr_debug("PCI: fixup irq: (%s) got %d\n",
_

Patches currently in -mm which might be from andreas.block@esd-electronics.com are

bugfixes-pci-devices-get-assigned-redundant-irqs.patch
