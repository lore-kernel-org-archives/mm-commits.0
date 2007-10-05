From: akpm@linux-foundation.org
Subject: - phylib-spinlock-fixes-for-softirqs.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:38 -0700
Message-ID: <200710051957.l95JvcUd022483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763072AbXJEUBM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     PHYLIB: Spinlock fixes for softirqs
has been removed from the -mm tree.  Its filename was
     phylib-spinlock-fixes-for-softirqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PHYLIB: Spinlock fixes for softirqs
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Use spin_lock_bh()/spin_unlock_bh() for the phydev lock throughout as it
is used in phy_timer() that is called as a softirq and all the other
operations may happen in the user context.

There has been a change recently that did such a conversion for some of the
operations on the lock, but some have been left intact.  Many of them,
perhaps all, may be called in the user context and I was able to trigger
recursive spinlock acquisition indeed, so I think for the sake of long-term
maintenance it is best to convert them all, even if unnecessarily for one
or two -- better safe than sorry.

Perhaps one in phy_timer() could actually be skipped as only called as a
softirq -- I can send an update if that sounds like a good idea.

Checked with checkpatch.pl and at the runtime.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/phy/phy.c        |   24 ++++++++++++------------
 drivers/net/phy/phy_device.c |    4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/net/phy/phy.c~phylib-spinlock-fixes-for-softirqs drivers/net/phy/phy.c
--- a/drivers/net/phy/phy.c~phylib-spinlock-fixes-for-softirqs
+++ a/drivers/net/phy/phy.c
@@ -424,7 +424,7 @@ int phy_start_aneg(struct phy_device *ph
 {
 	int err;
 
-	spin_lock(&phydev->lock);
+	spin_lock_bh(&phydev->lock);
 
 	if (AUTONEG_DISABLE == phydev->autoneg)
 		phy_sanitize_settings(phydev);
@@ -445,7 +445,7 @@ int phy_start_aneg(struct phy_device *ph
 	}
 
 out_unlock:
-	spin_unlock(&phydev->lock);
+	spin_unlock_bh(&phydev->lock);
 	return err;
 }
 EXPORT_SYMBOL(phy_start_aneg);
@@ -490,10 +490,10 @@ void phy_stop_machine(struct phy_device 
 {
 	del_timer_sync(&phydev->phy_timer);
 
-	spin_lock(&phydev->lock);
+	spin_lock_bh(&phydev->lock);
 	if (phydev->state > PHY_UP)
 		phydev->state = PHY_UP;
-	spin_unlock(&phydev->lock);
+	spin_unlock_bh(&phydev->lock);
 
 	phydev->adjust_state = NULL;
 }
@@ -537,9 +537,9 @@ static void phy_force_reduction(struct p
  */
 void phy_error(struct phy_device *phydev)
 {
-	spin_lock(&phydev->lock);
+	spin_lock_bh(&phydev->lock);
 	phydev->state = PHY_HALTED;
-	spin_unlock(&phydev->lock);
+	spin_unlock_bh(&phydev->lock);
 }
 
 /**
@@ -690,10 +690,10 @@ static void phy_change(struct work_struc
 	if (err)
 		goto phy_err;
 
-	spin_lock(&phydev->lock);
+	spin_lock_bh(&phydev->lock);
 	if ((PHY_RUNNING == phydev->state) || (PHY_NOLINK == phydev->state))
 		phydev->state = PHY_CHANGELINK;
-	spin_unlock(&phydev->lock);
+	spin_unlock_bh(&phydev->lock);
 
 	enable_irq(phydev->irq);
 
@@ -718,7 +718,7 @@ phy_err:
  */
 void phy_stop(struct phy_device *phydev)
 {
-	spin_lock(&phydev->lock);
+	spin_lock_bh(&phydev->lock);
 
 	if (PHY_HALTED == phydev->state)
 		goto out_unlock;
@@ -734,7 +734,7 @@ void phy_stop(struct phy_device *phydev)
 	}
 
 out_unlock:
-	spin_unlock(&phydev->lock);
+	spin_unlock_bh(&phydev->lock);
 
 	/*
 	 * Cannot call flush_scheduled_work() here as desired because
@@ -782,7 +782,7 @@ static void phy_timer(unsigned long data
 	int needs_aneg = 0;
 	int err = 0;
 
-	spin_lock(&phydev->lock);
+	spin_lock_bh(&phydev->lock);
 
 	if (phydev->adjust_state)
 		phydev->adjust_state(phydev->attached_dev);
@@ -948,7 +948,7 @@ static void phy_timer(unsigned long data
 			break;
 	}
 
-	spin_unlock(&phydev->lock);
+	spin_unlock_bh(&phydev->lock);
 
 	if (needs_aneg)
 		err = phy_start_aneg(phydev);
diff -puN drivers/net/phy/phy_device.c~phylib-spinlock-fixes-for-softirqs drivers/net/phy/phy_device.c
--- a/drivers/net/phy/phy_device.c~phylib-spinlock-fixes-for-softirqs
+++ a/drivers/net/phy/phy_device.c
@@ -670,9 +670,9 @@ static int phy_remove(struct device *dev
 
 	phydev = to_phy_device(dev);
 
-	spin_lock(&phydev->lock);
+	spin_lock_bh(&phydev->lock);
 	phydev->state = PHY_DOWN;
-	spin_unlock(&phydev->lock);
+	spin_unlock_bh(&phydev->lock);
 
 	if (phydev->drv->remove)
 		phydev->drv->remove(phydev);
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
