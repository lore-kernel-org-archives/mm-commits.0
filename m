From: akpm@linux-foundation.org
Subject: - b44-ssb-fix-irq-routing-bits-on-the-backplane.patch removed from -mm tree
Date: Wed, 08 Aug 2007 16:54:12 -0700
Message-ID: <200708082359.l78Nx3lO005051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761050AbXHHX7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 19:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, maxi@daemonizer.de, zambrano@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     b44-ssb: fix IRQ routing bits on the backplane
has been removed from the -mm tree.  Its filename was
     b44-ssb-fix-irq-routing-bits-on-the-backplane.patch

This patch was dropped because an updated version will be merged

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

git-netdev-all.patch
git-wireless.patch
b44-ssb-fix-irq-routing-bits-on-the-backplane.patch
merge-the-sonics-silicon-backplane-subsystem-update.patch
ssb-compile-fix.patch
watchdog-support-3.patch
ssb-chipcommon-add-function-to-get-processor-clock.patch
ssb-chipcommon-add-function-to-get-processor-clock-fix.patch
ssb-mainc-needs-dma-mappingh.patch
use-ssb-extif-in-ssb-mips-core-driver.patch
add-buswidth-to-ssb-mips-core-flash-driver.patch
ssb-add-a-driver-for-the-broadcom-ohci-core.patch
