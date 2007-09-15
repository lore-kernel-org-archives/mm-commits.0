From: akpm@linux-foundation.org
Subject: + sky2-fix-phy-setup-on-fe-p.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:33:23 -0700
Message-ID: <200709150233.l8F2XNBR003310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37518 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760182AbXIOCdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:33:25 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8F2XNVI002648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 14 Sep 2007 19:33:24 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     sky2: fix PHY setup on FE-P
has been added to the -mm tree.  Its filename is
     sky2-fix-phy-setup-on-fe-p.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

pci-x-pci-express-read-control-interfaces-mthca.patch
git-netdev-all.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
export-reciprocal_value-for-modules.patch
sky2-avoid-divide-in-receive-path.patch
sky2-118.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
sky2-restore-multicast-list-on-resume-and-other-ops.patch
sky2-fix-phy-setup-on-fe-p.patch
git-net.patch
