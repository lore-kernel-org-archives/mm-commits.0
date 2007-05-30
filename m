From: akpm@linux-foundation.org
Subject: + rtc-use-fallback-irq-if-pnp-tables-dont-provide-one.patch added to -mm tree
Date: Tue, 29 May 2007 17:31:08 -0700
Message-ID: <200705300031.l4U0V8Hx015417@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609AbXE3AbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 20:31:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, castet.matthieu@free.fr, dbrownell@users.sourceforge.net


The patch titled
     RTC: use fallback IRQ if PNP tables don't provide one
has been added to the -mm tree.  Its filename is
     rtc-use-fallback-irq-if-pnp-tables-dont-provide-one.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RTC: use fallback IRQ if PNP tables don't provide one
From: Matthew Garrett <mjg59@srcf.ucam.org>

Intel Macs (and possibly other machines) provide a PNP entry for the RTC,
but provide no IRQ.  As a result the rtc-cmos driver doesn't allow wakeup
alarms.  If the RTC is located at the legacy ioport range, assume that it's
on IRQ 8 unless the tables say otherwise.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

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

working-3d-dri-intel-agpko-resume-for-i815-chip.patch
rtc-use-fallback-irq-if-pnp-tables-dont-provide-one.patch
