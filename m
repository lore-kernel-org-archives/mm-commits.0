From: akpm@linux-foundation.org
Subject: + parport_pc-fix-parport_pc_probe_port-section-warning.patch added to -mm tree
Date: Fri, 16 Feb 2007 13:17:39 -0800
Message-ID: <200702162117.l1GLHdfJ010097@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36449 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946254AbXBPVRy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 16:17:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org


The patch titled
     parport_pc: fix parport_pc_probe_port section warning
has been added to the -mm tree.  Its filename is
     parport_pc-fix-parport_pc_probe_port-section-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: parport_pc: fix parport_pc_probe_port section warning
From: Jean Delvare <khali@linux-fr.org>

WARNING: drivers/parport/parport_pc.o - Section mismatch: reference
to .init.text: from .text between 'parport_pc_probe_port' (at offset
0x14f7) and 'parport_pc_unregister_port'

parport_dma_probe() cannot be declared __devinit as it is called
from parport_pc_probe_port() which isn't.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/parport/parport_pc.c~parport_pc-fix-parport_pc_probe_port-section-warning drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport_pc-fix-parport_pc_probe_port-section-warning
+++ a/drivers/parport/parport_pc.c
@@ -1546,7 +1546,7 @@ static void __devinit detect_and_report_
 }
 #endif /* CONFIG_PARPORT_PC_SUPERIO */
 
-static int __devinit get_superio_dma (struct parport *p)
+static int get_superio_dma (struct parport *p)
 {
 	int i=0;
 	while( (superios[i].io != p->base) && (i<NR_SUPERIOS))
@@ -2106,7 +2106,7 @@ static int parport_irq_probe(struct parp
 /* --- DMA detection -------------------------------------- */
 
 /* Only if chipset conforms to ECP ISA Interface Standard */
-static int __devinit programmable_dma_support (struct parport *p)
+static int programmable_dma_support (struct parport *p)
 {
 	unsigned char oecr = inb (ECONTROL (p));
 	int dma;
@@ -2123,7 +2123,7 @@ static int __devinit programmable_dma_su
 	return dma;
 }
 
-static int __devinit parport_dma_probe (struct parport *p)
+static int parport_dma_probe (struct parport *p)
 {
 	const struct parport_pc_private *priv = p->private_data;
 	if (priv->ecr)
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
git-input.patch
parport_pc-fix-parport_pc_probe_port-section-warning.patch
