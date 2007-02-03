From: akpm@osdl.org
Subject: - r8169-fix-a-race-between-pci-probe-and-dev_open.patch removed from -mm tree
Date: Fri, 02 Feb 2007 18:15:49 -0800
Message-ID: <200702030215.l132FouN028879@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53432 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946229AbXBCCQD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 21:16:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, bwalle@suse.de, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     r8169: fix a race between PCI probe and dev_open
has been removed from the -mm tree.  Its filename was
     r8169-fix-a-race-between-pci-probe-and-dev_open.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r8169: fix a race between PCI probe and dev_open
From: Francois Romieu <romieu@fr.zoreil.com>

Call chain:
-> rtl8169_init_one
   -> register_netdev                  (dev_open starts to race...)
   -> rtl8169_init_phy
      -> rtl8169_set_speed
         -> tp->set_speed
         -> mod_timer(&tp->timer, ...) (if netif_running() is true)

As netif_running() is true just before dev->open() is issued and the
timer is initialized during dev->open, mod_timer() meets an uninitialized
tp->timer and oopses.

rtl8169_init_phy is only used on rtl8169_init_one so it's fine to never
ask it to activate the timer: the racing dev->open will do it anyway.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Bernhard Walle <bwalle@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/r8169.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/r8169.c~r8169-fix-a-race-between-pci-probe-and-dev_open drivers/net/r8169.c
--- a/drivers/net/r8169.c~r8169-fix-a-race-between-pci-probe-and-dev_open
+++ a/drivers/net/r8169.c
@@ -1448,7 +1448,7 @@ static void rtl8169_init_phy(struct net_
 
 	rtl8169_phy_reset(dev, tp);
 
-	rtl8169_set_speed(dev, autoneg, speed, duplex);
+	tp->set_speed(dev, autoneg, speed, duplex);
 
 	if ((RTL_R8(PHYstatus) & TBI_Enable) && netif_msg_link(tp))
 		printk(KERN_INFO PFX "%s: TBI auto-negotiating\n", dev->name);
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

r8169-fix-a-race-between-pci-probe-and-dev_open.patch
git-netdev-all.patch
r8169-warning-fixes.patch
