From: akpm@osdl.org
Subject: + problem-phy-probe-not-working-properly-for-ibm_emac-ppc4xx.patch added to -mm tree
Date: Thu, 14 Dec 2006 17:23:44 -0800
Message-ID: <200612150123.kBF1Ni8q002708@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48778 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbWLOBYJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 20:24:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hynek@swac.cz, jeff@garzik.org


The patch titled
     PHY probe not working properly for ibm_emac (PPC4xx)
has been added to the -mm tree.  Its filename is
     problem-phy-probe-not-working-properly-for-ibm_emac-ppc4xx.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PHY probe not working properly for ibm_emac (PPC4xx)
From: Hynek Petrak <hynek@swac.cz>

I have a system with AMCC PowerPC 405EP and PHY Intel LXT971A.  Linux
2.6.18.3 is not able to detect the PHY ID correctly.  The PHY ID
detected is 0, but should be 0x1d.

This is because phy_read() (__emac_mdio_read() resp.) from
drivers/net/ibm_emac/ibm_emac_core.c might return -ETIMEDOUT or
-EREMOTEIO on error.  This is ignored inside the

int mii_phy_probe(struct mii_phy *phy, int address)
from drivers/net/ibm_emac/ibm_emac_phy.c

as the return value is assigned to an u32 variable.

Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/ibm_emac/ibm_emac_phy.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/net/ibm_emac/ibm_emac_phy.c~problem-phy-probe-not-working-properly-for-ibm_emac-ppc4xx drivers/net/ibm_emac/ibm_emac_phy.c
--- a/drivers/net/ibm_emac/ibm_emac_phy.c~problem-phy-probe-not-working-properly-for-ibm_emac-ppc4xx
+++ a/drivers/net/ibm_emac/ibm_emac_phy.c
@@ -309,7 +309,7 @@ int mii_phy_probe(struct mii_phy *phy, i
 {
 	struct mii_phy_def *def;
 	int i;
-	u32 id;
+	int id;
 
 	phy->autoneg = AUTONEG_DISABLE;
 	phy->advertising = 0;
@@ -324,6 +324,8 @@ int mii_phy_probe(struct mii_phy *phy, i
 
 	/* Read ID and find matching entry */
 	id = (phy_read(phy, MII_PHYSID1) << 16) | phy_read(phy, MII_PHYSID2);
+	if (id < 0)
+		return -ENODEV;
 	for (i = 0; (def = mii_phy_table[i]) != NULL; i++)
 		if ((id & def->phy_id_mask) == def->phy_id)
 			break;
_

Patches currently in -mm which might be from hynek@swac.cz are

problem-phy-probe-not-working-properly-for-ibm_emac-ppc4xx.patch

