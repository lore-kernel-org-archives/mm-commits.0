From: akpm@linux-foundation.org
Subject: - sky2-fix-phy-setup-on-fe-p.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:27:15 -0700
Message-ID: <200709160927.l8G9RFpU009244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46802 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbXIPJiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:08 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8G9c76O003816
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Sun, 16 Sep 2007 02:38:08 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     sky2: fix PHY setup on FE-P
has been removed from the -mm tree.  Its filename was
     sky2-fix-phy-setup-on-fe-p.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sky2: fix PHY setup on FE-P
From: Stephen Hemminger <shemminger@linux-foundation.org>

Marvell reported the following fix is necessary to get fe-plus chips to
work.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/sky2.c~sky2-fix-phy-setup-on-fe-p drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-fix-phy-setup-on-fe-p
+++ a/drivers/net/sky2.c
@@ -488,11 +488,12 @@ static void sky2_phy_init(struct sky2_hw
 
 	case CHIP_ID_YUKON_FE_P:
 		/* Enable Link Partner Next Page */
+		ctrl = gm_phy_read(hw, port, PHY_MARV_PHY_CTRL);
 		ctrl |= PHY_M_PC_ENA_LIP_NP;
 
 		/* disable Energy Detect and enable scrambler */
 		ctrl &= ~(PHY_M_PC_ENA_ENE_DT | PHY_M_PC_DIS_SCRAMB);
-		gm_phy_write(hw, port, PHY_MARV_CTRL, ctrl);
+		gm_phy_write(hw, port, PHY_MARV_PHY_CTRL, ctrl);
 
 		/* set LED2 -> ACT, LED1 -> LINK, LED0 -> SPEED */
 		ctrl = PHY_M_FELP_LED2_CTRL(LED_PAR_CTRL_ACT_BL) |
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
git-infiniband.patch
git-input.patch
git-net.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
export-reciprocal_value-for-modules.patch
sky2-avoid-divide-in-receive-path.patch
sky2-118.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
