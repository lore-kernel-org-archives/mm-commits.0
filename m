From: akpm@linux-foundation.org
Subject: - sky2-auto-negotiation-phy-errata.patch removed from -mm tree
Date: Wed, 07 Feb 2007 12:10:26 -0800
Message-ID: <200702072010.l17KARcC025837@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34611 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030659AbXBGUKb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 15:10:31 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l17KAUdD017231
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 7 Feb 2007 12:10:31 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     sky2 auto negotiation PHY errata
has been removed from the -mm tree.  Its filename was
     sky2-auto-negotiation-phy-errata.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: sky2 auto negotiation PHY errata
From: Stephen Hemminger <shemminger@linux-foundation.org>

This patch does the Marvell errata before auto negotiation
(from drivers/phy/marvell.c).  The Yukon II chips have an internal
version of the same PHY, so perhaps this errata is necessary for them
as well.

For test only, but it may fix some of the hangs. It seems to fix
the PHY lockups I saw yesterday on Mac Mini.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/net/sky2.c~sky2-auto-negotiation-phy-errata drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-auto-negotiation-phy-errata
+++ a/drivers/net/sky2.c
@@ -363,6 +363,14 @@ static void sky2_phy_init(struct sky2_hw
 
 	if (sky2->autoneg == AUTONEG_ENABLE) {
 		if (sky2_is_copper(hw)) {
+			/* Errata setup */
+			gm_phy_write(hw, port, PHY_MARV_PAGE_ADDR, 0x1f);
+			gm_phy_write(hw, port, PHY_MARV_PAGE_DATA, 0x200c);
+			gm_phy_write(hw, port, PHY_MARV_PAGE_ADDR, 5);
+			gm_phy_write(hw, port, PHY_MARV_PAGE_DATA, 0);
+			gm_phy_write(hw, port, PHY_MARV_PAGE_DATA, 0x100);
+
+
 			if (sky2->advertising & ADVERTISED_1000baseT_Full)
 				ct1000 |= PHY_M_1000C_AFD;
 			if (sky2->advertising & ADVERTISED_1000baseT_Half)
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

git-netdev-all.patch
sky2-auto-negotiation-phy-errata.patch
