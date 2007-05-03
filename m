From: akpm@linux-foundation.org
Subject: + i386-add-support-for-picopower-irq-router.patch added to -mm tree
Date: Wed, 02 May 2007 22:26:25 -0700
Message-ID: <200705030526.l435QPtQ005510@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767393AbXECF0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 01:26:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tmb@mandriva.org


The patch titled
     i386: add support for picopower irq router
has been added to the -mm tree.  Its filename is
     i386-add-support-for-picopower-irq-router.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: i386: add support for picopower irq router
=46rom: Thomas Backlund <tmb@mandriva.org>

Add support for PicoPower PT86C523 IRQ router to be used with the in-ke=
rnel
yenta driver for CardBus.  With this patch cardbus works on e.g.  Dell
Latitude XPi P150CD.

Initial patch for kernel 2.4 series by Sune M=C3=B8lgaard
http://molgaard.org/code/linux-2.4.31-picopower.patch

Ported to 2.6.20 by Chmouel Boudjnah (http://www.chmouel.com)

Testing and confirmation that it works by Austin Acton

Cleaned up a little for inclusion in a 2.6.21-rc7 based kernel.

Added some more cleanups according to CodingStyle, as noted by
Randy Dunlap on LKML.

Signed-off-by: Thomas Backlund <tmb@mandriva.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/irq.c     |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h |    3 +++
 2 files changed, 40 insertions(+)

diff -puN arch/i386/pci/irq.c~i386-add-support-for-picopower-irq-router=
 arch/i386/pci/irq.c
--- a/arch/i386/pci/irq.c~i386-add-support-for-picopower-irq-router
+++ a/arch/i386/pci/irq.c
@@ -491,6 +491,24 @@ static int pirq_amd756_set(struct pci_de
 	return 1;
 }
=20
+/*
+ * PicoPower PT86C523
+ */
+static int pirq_pico_get(struct pci_dev *router, struct pci_dev *dev, =
int pirq)
+{
+	outb(0x10 + ((pirq - 1) >> 1), 0x24);
+	return ((pirq - 1) & 1) ? (inb(0x26) >> 4) : (inb(0x26) & 0xf);
+}
+
+static int pirq_pico_set(struct pci_dev *router, struct pci_dev *dev, =
int pirq, int irq)
+{
+	unsigned int x;
+	outb(0x10 + ((pirq - 1) >> 1), 0x24);
+	x =3D inb(0x26);
+	x =3D ((pirq - 1) & 1) ? ((x & 0x0f) | (irq << 4)) : ((x & 0xf0) | (i=
rq));
+	outb(x, 0x26);
+}
+
 #ifdef CONFIG_PCI_BIOS
=20
 static int pirq_bios_set(struct pci_dev *router, struct pci_dev *dev, =
int pirq, int irq)
@@ -719,6 +737,24 @@ static __init int amd_router_probe(struc
 	return 1;
 }
 	=09
+static __init int pico_router_probe(struct irq_router *r, struct pci_d=
ev *router, u16 device)
+{
+	switch (device) {
+	case PCI_DEVICE_ID_PICOPOWER_PT86C523:
+		r->name =3D "PicoPower PT86C523";
+		r->get =3D pirq_pico_get;
+		r->set =3D pirq_pico_set;
+		return 1;
+
+	case PCI_DEVICE_ID_PICOPOWER_PT86C523BBP:
+		r->name =3D "PicoPower PT86C523 rev. BB+";
+		r->get =3D pirq_pico_get;
+		r->set =3D pirq_pico_set;
+		return 1;
+	}
+	return 0;
+}
+
 static __initdata struct irq_router_handler pirq_routers[] =3D {
 	{ PCI_VENDOR_ID_INTEL, intel_router_probe },
 	{ PCI_VENDOR_ID_AL, ali_router_probe },
@@ -730,6 +766,7 @@ static __initdata struct irq_router_hand
 	{ PCI_VENDOR_ID_VLSI, vlsi_router_probe },
 	{ PCI_VENDOR_ID_SERVERWORKS, serverworks_router_probe },
 	{ PCI_VENDOR_ID_AMD, amd_router_probe },
+	{ PCI_VENDOR_ID_PICOPOWER, pico_router_probe },
 	/* Someone with docs needs to add the ATI Radeon IGP */
 	{ 0, NULL }
 };
diff -puN include/linux/pci_ids.h~i386-add-support-for-picopower-irq-ro=
uter include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~i386-add-support-for-picopower-irq-router
+++ a/include/linux/pci_ids.h
@@ -819,6 +819,9 @@
 #define PCI_DEVICE_ID_UMC_UM8886BF	0x673a
 #define PCI_DEVICE_ID_UMC_UM8886A	0x886a
=20
+#define PCI_VENDOR_ID_PICOPOWER		0x1066
+#define PCI_DEVICE_ID_PICOPOWER_PT86C523	0x0002
+#define PCI_DEVICE_ID_PICOPOWER_PT86C523BBP	0x8002
=20
 #define PCI_VENDOR_ID_MYLEX		0x1069
 #define PCI_DEVICE_ID_MYLEX_DAC960_P	0x0001
_

Patches currently in -mm which might be from tmb@mandriva.org are

i386-add-support-for-picopower-irq-router.patch
