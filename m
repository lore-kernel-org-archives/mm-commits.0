From: akpm@linux-foundation.org
Subject: - fixed_phy-must-depend-on-phylib=y.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:23:00 -0800
Message-ID: <200803062223.m26MN0be020854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765137AbYCFWXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:23:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.bunk@movial.fi, jeff@garzik.org, olaf@aepfle.de, mm-commits@vger.kernel.org


The patch titled
     FIXED_PHY must depend on PHYLIB=y
has been removed from the -mm tree.  Its filename was
     fixed_phy-must-depend-on-phylib=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: FIXED_PHY must depend on PHYLIB=y
From: Adrian Bunk <adrian.bunk@movial.fi>

Fix the following build error introduced by commit
a79d8e93d300adb84cccc38ac396cfb118c238ad and reported by Olaf Hering:

arch/powerpc/sysdev/built-in.o: In function `of_add_fixed_phys':
fsl_soc.c:(.init.text+0xd34): undefined reference to `fixed_phy_add'

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
Tested-by: Olaf Hering <olaf@aepfle.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/phy/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/phy/Kconfig~fixed_phy-must-depend-on-phylib=y drivers/net/phy/Kconfig
--- a/drivers/net/phy/Kconfig~fixed_phy-must-depend-on-phylib=y
+++ a/drivers/net/phy/Kconfig
@@ -67,6 +67,7 @@ config REALTEK_PHY
 
 config FIXED_PHY
 	bool "Driver for MDIO Bus/PHY emulation with fixed speed/link PHYs"
+	depends on PHYLIB=y
 	---help---
 	  Adds the platform "fixed" MDIO Bus to cover the boards that use
 	  PHYs that are not connected to the real MDIO bus.
_

Patches currently in -mm which might be from adrian.bunk@movial.fi are

git-net.patch
git-parisc.patch
git-sh.patch

