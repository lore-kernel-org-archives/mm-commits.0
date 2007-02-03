From: akpm@osdl.org
Subject: + sky2-auto-negotiation-phy-errata.patch added to -mm tree
Date: Fri, 02 Feb 2007 17:28:37 -0800
Message-ID: <200702030128.l131SbgD023721@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48675 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946196AbXBCB2l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 20:28:41 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l131SbQ5026022
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 2 Feb 2007 17:28:40 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@osdl.org


The patch titled
     sky2 auto negotiation PHY errata
has been added to the -mm tree.  Its filename is
     sky2-auto-negotiation-phy-errata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sky2 auto negotiation PHY errata
From: Stephen Hemminger <shemminger@linux-foundation.org>

This patch does the Marvell errata before auto negotiation
(from drivers/phy/marvell.c).  The Yukon II chips have an internal
version of the same PHY, so perhaps this errata is necessary for them
as well.

For test only, but it may fix some of the hangs. It seems to fix
the PHY lockups I saw yesterday on Mac Mini.


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/sky2.c |    8 ++++++++
 1 files changed, 8 insertions(+)

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
