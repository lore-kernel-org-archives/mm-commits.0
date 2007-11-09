From: akpm@linux-foundation.org
Subject: - add-the-rdc-machine-specific-reboot-fixup.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:13:34 -0800
Message-ID: <200711091913.lA9JDYMH028039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbXKITRo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:17:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian.fainelli@telecomint.eu, david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: add the RDC machine specific reboot fixup
has been removed from the -mm tree.  Its filename was
     add-the-rdc-machine-specific-reboot-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: add the RDC machine specific reboot fixup
From: Florian Fainelli <florian.fainelli@telecomint.eu>

The RDC R-321x SoC needs a reboot fixup which uses its internal hardware
watchdog set to reset the CPU on next tick.

Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot_fixups_32.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN arch/x86/kernel/reboot_fixups_32.c~add-the-rdc-machine-specific-reboot-fixup arch/x86/kernel/reboot_fixups_32.c
--- a/arch/x86/kernel/reboot_fixups_32.c~add-the-rdc-machine-specific-reboot-fixup
+++ a/arch/x86/kernel/reboot_fixups_32.c
@@ -30,6 +30,19 @@ static void cs5536_warm_reset(struct pci
 	udelay(50); /* shouldn't get here but be safe and spin a while */
 }
 
+static void rdc321x_reset(struct pci_dev *dev)
+{
+	unsigned i;
+	/* Voluntary reset the watchdog timer */
+	outl(0x80003840, 0xCF8);
+	/* Generate a CPU reset on next tick */
+	i = inl(0xCFC);
+	/* Use the minimum timer resolution */
+	i |= 0x1600;
+	outl(i, 0xCFC);
+	outb(1, 0x92);
+}
+
 struct device_fixup {
 	unsigned int vendor;
 	unsigned int device;
@@ -39,6 +52,7 @@ struct device_fixup {
 static struct device_fixup fixups_table[] = {
 { PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY, cs5530a_warm_reset },
 { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, cs5536_warm_reset },
+{ PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6030, rdc321x_reset },
 };
 
 /*
_

Patches currently in -mm which might be from florian.fainelli@telecomint.eu are

git-x86.patch
