From: akpm@linux-foundation.org
Subject: + v3-fix-error-on-drivers-ata-pata_legacyc.patch added to -mm tree
Date: Fri, 17 Apr 2009 14:45:11 -0700
Message-ID: <200904172145.n3HLjBI9025424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944AbZDQVqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 17:46:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: helight.xu@gmail.com


The patch titled
     fix error on drivers/ata/pata_legacy.c
has been added to the -mm tree.  Its filename is
     v3-fix-error-on-drivers-ata-pata_legacyc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix error on drivers/ata/pata_legacy.c
From: Zhenwen Xu <helight.xu@gmail.com>

fix those errors:

drivers/ata/pata_legacy.c: In function `pdc_data_xfer_vlb':
drivers/ata/pata_legacy.c:289: error: `ap' undeclared (first use in this function)
drivers/ata/pata_legacy.c:289: error: (Each undeclared identifier is reported only once
drivers/ata/pata_legacy.c:289: error: for each function it appears in.)
drivers/ata/pata_legacy.c: At top level:
drivers/ata/pata_legacy.c:869: error: `ATA_PFLAG_PIO32_CHANGE' undeclared here (not in a
+function)

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_legacy.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/ata/pata_legacy.c~v3-fix-error-on-drivers-ata-pata_legacyc drivers/ata/pata_legacy.c
--- a/drivers/ata/pata_legacy.c~v3-fix-error-on-drivers-ata-pata_legacyc
+++ a/drivers/ata/pata_legacy.c
@@ -285,10 +285,11 @@ static unsigned int pdc_data_xfer_vlb(st
 			unsigned char *buf, unsigned int buflen, int rw)
 {
 	int slop = buflen & 3;
+	struct ata_port *ap = dev->link->ap;
+
 	/* 32bit I/O capable *and* we need to write a whole number of dwords */
 	if (ata_id_has_dword_io(dev->id) && (slop == 0 || slop == 3)
 					&& (ap->pflags & ATA_PFLAG_PIO32)) {
-		struct ata_port *ap = dev->link->ap;
 		unsigned long flags;
 
 		local_irq_save(flags);
@@ -866,7 +867,7 @@ static struct legacy_controller controll
 			0,			0,			NULL },
 	{"PDC20230",	&pdc20230_port_ops,	0x7,
 			ATA_FLAG_NO_IORDY,
-			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE,	NULL },
+			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,	NULL },
 	{"HT6560A",	&ht6560a_port_ops,	0x07,
 			ATA_FLAG_NO_IORDY,	0,			NULL },
 	{"HT6560B",	&ht6560b_port_ops,	0x1F,
@@ -877,13 +878,13 @@ static struct legacy_controller controll
 			0,			0,			NULL },
 	{"QDI6500",	&qdi6500_port_ops,	0x07,
 			ATA_FLAG_NO_IORDY,
-			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE,    qdi_port },
+			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,    qdi_port },
 	{"QDI6580",	&qdi6580_port_ops,	0x1F,
-			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE, qdi_port },
+			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE, qdi_port },
 	{"QDI6580DP",	&qdi6580dp_port_ops,	0x1F,
-			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE, qdi_port },
+			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE, qdi_port },
 	{"W83759A",	&winbond_port_ops,	0x1F,
-			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE,
+			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,
 								winbond_port }
 };
 
_

Patches currently in -mm which might be from helight.xu@gmail.com are

v3-fix-error-on-drivers-ata-pata_legacyc.patch
drivers-infiniband-hw-nes-nes_cmc-fix-unused-var-warning.patch
drivers-mtd-nand-cafe_nandc-fix-irq-handler-return-type.patch
drivers-pci-hotplug-ibmphp_corec-fix-warning-due-to-missing-module_exit.patch

