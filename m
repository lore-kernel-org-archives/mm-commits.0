From: akpm@linux-foundation.org
Subject: + b44-ssb-fix-irq-routing-bits-on-the-backplane.patch added to -mm tree
Date: Tue, 19 Jun 2007 13:43:42 -0700
Message-ID: <200706192043.l5JKhgxO020781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760742AbXFSUoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 16:44:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, maxi@daemonizer.de, zambrano@broadcom.com


The patch titled
     b44-ssb: fix IRQ routing bits on the backplane
has been added to the -mm tree.  Its filename is
     b44-ssb-fix-irq-routing-bits-on-the-backplane.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: b44-ssb: fix IRQ routing bits on the backplane
From: Michael Buesch <mb@bu3sch.de>

The backplane on the b44 chip seems to have a silicon bug in the IRQ
routing.  The ethernet core IRQ routing does not work with the routing bit
returned from the backplaneflag register.  This patch adds a workaround for
the b44 chip to use a hardcoded constant.  This constant was also used in
the old b44 driver.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Tested-by: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: Gary Zambrano <zambrano@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/driver_pcicore.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/ssb/driver_pcicore.c~b44-ssb-fix-irq-routing-bits-on-the-backplane drivers/ssb/driver_pcicore.c
--- a/drivers/ssb/driver_pcicore.c~b44-ssb-fix-irq-routing-bits-on-the-backplane
+++ a/drivers/ssb/driver_pcicore.c
@@ -496,9 +496,15 @@ int ssb_pcicore_dev_irqvecs_enable(struc
 		u32 intvec;
 
 		intvec = ssb_read32(pdev, SSB_INTVEC);
-		tmp = ssb_read32(dev, SSB_TPSFLAG);
-		tmp &= SSB_TPSFLAG_BPFLAG;
-		intvec |= tmp;
+		if ((bus->chip_id & 0xFF00) == 0x4400) {
+			/* Workaround: On the BCM44XX the BPFLAG routing
+			 * bit is wrong. Use a hardcoded constant. */
+			intvec |= 0x00000002;
+		} else {
+			tmp = ssb_read32(dev, SSB_TPSFLAG);
+			tmp &= SSB_TPSFLAG_BPFLAG;
+			intvec |= tmp;
+		}
 		ssb_write32(pdev, SSB_INTVEC, intvec);
 	}
 
_

Patches currently in -mm which might be from mb@bu3sch.de are

b44-ssb-fix-irq-routing-bits-on-the-backplane.patch
o_cloexec-for-scm_rights.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
