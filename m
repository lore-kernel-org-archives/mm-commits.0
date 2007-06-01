From: akpm@linux-foundation.org
Subject: - rtc-use-fallback-irq-if-pnp-tables-dont-provide-one.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:46 -0700
Message-ID: <200706011747.l51Hlj43015150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761137AbXFARr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, castet.matthieu@free.fr, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     RTC: use fallback IRQ if PNP tables don't provide one
has been removed from the -mm tree.  Its filename was
     rtc-use-fallback-irq-if-pnp-tables-dont-provide-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RTC: use fallback IRQ if PNP tables don't provide one
From: Matthew Garrett <mjg59@srcf.ucam.org>

Intel Macs (and possibly other machines) provide a PNP entry for the RTC,
but provide no IRQ.  As a result the rtc-cmos driver doesn't allow wakeup
alarms.  If the RTC is located at the legacy ioport range, assume that it's
on IRQ 8 unless the tables say otherwise.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-use-fallback-irq-if-pnp-tables-dont-provide-one drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-use-fallback-irq-if-pnp-tables-dont-provide-one
+++ a/drivers/rtc/rtc-cmos.c
@@ -641,9 +641,16 @@ cmos_pnp_probe(struct pnp_dev *pnp, cons
 	 * drivers can't provide shutdown() methods to disable IRQs.
 	 * Or better yet, fix PNP to allow those methods...
 	 */
-	return cmos_do_probe(&pnp->dev,
-			&pnp->res.port_resource[0],
-			pnp->res.irq_resource[0].start);
+	if (pnp_port_start(pnp,0) == 0x70 && !pnp_irq_valid(pnp,0))
+		/* Some machines contain a PNP entry for the RTC, but
+		 * don't define the IRQ. It should always be safe to
+		 * hardcode it in these cases
+		 */
+		return cmos_do_probe(&pnp->dev, &pnp->res.port_resource[0], 8);
+	else
+		return cmos_do_probe(&pnp->dev,
+				     &pnp->res.port_resource[0],
+				     pnp->res.irq_resource[0].start);
 }
 
 static void __exit cmos_pnp_remove(struct pnp_dev *pnp)
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

origin.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
