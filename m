From: akpm@linux-foundation.org
Subject: - 3c59x-fix-duplex-configuration.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:12:19 -0700
Message-ID: <200708141912.l7EJCJA9016395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55855 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934790AbXHNTNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:13:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klassert@mathematik.tu-chemnitz.de, mb-tmp-ohtmvyyn.xreary.bet@gromit.dyndns.org, protasnb@gmail.com, mm-commits@vger.kernel.org


The patch titled
     3c59x: fix duplex configuration
has been removed from the -mm tree.  Its filename was
     3c59x-fix-duplex-configuration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 3c59x: fix duplex configuration
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>

A special sequence of ifconfig up/down and plug/unplug the cable can break
the duplex configuration of the driver.

Setting
vp->mii.full_duplex = vp->full_duplex
in vortex_up should fix this.

Addresses Bug 8575 3c59x duplex configuration broken
http://bugzilla.kernel.org/show_bug.cgi?id=8575

Cc: Martin Buck <mb-tmp-ohtmvyyn.xreary.bet@gromit.dyndns.org>
Signed-off-by: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Cc: Natalie Protasevich <protasnb@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/net/3c59x.c~3c59x-fix-duplex-configuration drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~3c59x-fix-duplex-configuration
+++ a/drivers/net/3c59x.c
@@ -1559,6 +1559,7 @@ vortex_up(struct net_device *dev)
 		mii_reg1 = mdio_read(dev, vp->phys[0], MII_BMSR);
 		mii_reg5 = mdio_read(dev, vp->phys[0], MII_LPA);
 		vp->partner_flow_ctrl = ((mii_reg5 & 0x0400) != 0);
+		vp->mii.full_duplex = vp->full_duplex;
 
 		vortex_check_media(dev, 1);
 	}
_

Patches currently in -mm which might be from klassert@mathematik.tu-chemnitz.de are

origin.patch
add-3c59x-maintainer.patch
wol-bugfix-for-3c59xc.patch
