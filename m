From: akpm@linux-foundation.org
Subject: - phylib-fix-an-interrupt-loop-potential-when-halting.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:43 -0700
Message-ID: <200710051957.l95Jvhgj022496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763573AbXJEUBt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, afleming@freescale.com, jgarzik@pobox.com, mm-commits@vger.kernel.org


The patch titled
     PHYLIB: fix an interrupt loop potential when halting
has been removed from the -mm tree.  Its filename was
     phylib-fix-an-interrupt-loop-potential-when-halting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PHYLIB: fix an interrupt loop potential when halting
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Ensure the PHY_HALTED state is not entered with the IRQ asserted as it
could lead to an interrupt loop.

There is a small window in phy_stop(), where the state of the PHY machine
indicates it has been halted, but its interrupt output might still be
unmasked.  If an interrupt goes active right at this moment it will loop as
the phy_interrupt() handler exits immediately with IRQ_NONE if the halted
state is seen.  It is unsafe to extend the phydev spinlock to cover
phy_interrupt().  It is safe to swap the order of the actions though as all
the competing places to unmask the interrupt output of the PHY, which are
phy_change() and phy_timer() are already covered with the lock as is the
sequence in question.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Andy Fleming <afleming@freescale.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/phy/phy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/phy/phy.c~phylib-fix-an-interrupt-loop-potential-when-halting drivers/net/phy/phy.c
--- a/drivers/net/phy/phy.c~phylib-fix-an-interrupt-loop-potential-when-halting
+++ a/drivers/net/phy/phy.c
@@ -737,8 +737,6 @@ void phy_stop(struct phy_device *phydev)
 	if (PHY_HALTED == phydev->state)
 		goto out_unlock;
 
-	phydev->state = PHY_HALTED;
-
 	if (phydev->irq != PHY_POLL) {
 		/* Disable PHY Interrupts */
 		phy_config_interrupt(phydev, PHY_INTERRUPT_DISABLED);
@@ -747,6 +745,8 @@ void phy_stop(struct phy_device *phydev)
 		phy_clear_interrupt(phydev);
 	}
 
+	phydev->state = PHY_HALTED;
+
 out_unlock:
 	spin_unlock_bh(&phydev->lock);
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
git-mips.patch
git-net.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
lk201-remove-obsolete-driver.patch
kernel-printkc-concerns-about-the-console-handover.patch
drivers-video-kconfig-fix-fb_pmagb_b-dependencies.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
pmagb-b-fb-improve-diagnostics.patch
