From: akpm@linux-foundation.org
Subject: - fix-compiler-warning-in-fixedc.patch removed from -mm tree
Date: Tue, 29 May 2007 11:54:32 -0700
Message-ID: <200705291854.l4TIsV80008530@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571AbXE2Sy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: denver@ossguy.com, vbordug@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     fix compiler warning in fixed.c
has been removed from the -mm tree.  Its filename was
     fix-compiler-warning-in-fixedc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix compiler warning in fixed.c
From: "Denver Gingerich" <denver@ossguy.com>

Correct the following compiler warning (and warnings resulting from
the correction):
warning: 'fixed_mdio_register_device' defined but not used

Signed-off-by: Denver Gingerich <denver@ossguy.com>
Cc: Vitaly Bordug <vbordug@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/phy/fixed.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/net/phy/fixed.c~fix-compiler-warning-in-fixedc drivers/net/phy/fixed.c
--- a/drivers/net/phy/fixed.c~fix-compiler-warning-in-fixedc
+++ a/drivers/net/phy/fixed.c
@@ -89,6 +89,7 @@ EXPORT_SYMBOL(fixed_mdio_set_link_update
 /*-----------------------------------------------------------------------------
  *  This is used for updating internal mii regs from the status
  *-----------------------------------------------------------------------------*/
+#if defined(CONFIG_FIXED_MII_100_FDX) || defined(CONFIG_FIXED_MII_10_FDX)
 static int fixed_mdio_update_regs(struct fixed_info *fixed)
 {
 	u16 *regs = fixed->regs;
@@ -165,6 +166,7 @@ static int fixed_mii_reset(struct mii_bu
 	/*nothing here - no way/need to reset it*/
 	return 0;
 }
+#endif
 
 static int fixed_config_aneg(struct phy_device *phydev)
 {
@@ -194,6 +196,7 @@ static struct phy_driver fixed_mdio_driv
  * number is used to create multiple fixed PHYs, so that several devices can
  * utilize them simultaneously.
  *-----------------------------------------------------------------------------*/
+#if defined(CONFIG_FIXED_MII_100_FDX) || defined(CONFIG_FIXED_MII_10_FDX)
 static int fixed_mdio_register_device(int number, int speed, int duplex)
 {
 	struct mii_bus *new_bus;
@@ -301,6 +304,7 @@ device_create_fail:
 
 	return err;
 }
+#endif
 
 
 MODULE_DESCRIPTION("Fixed PHY device & driver for PAL");
_

Patches currently in -mm which might be from denver@ossguy.com are

fix-compiler-warnings-in-acornc.patch
