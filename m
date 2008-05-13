From: akpm@linux-foundation.org
Subject: - atl1-add-phy-power-save-mode.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:47 -0700
Message-ID: <200805132134.m4DLYlYV000956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760114AbYEMVeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacliburn@bellsouth.net, mm-commits@vger.kernel.org


The patch titled
     atl1: add PHY power save mode
has been removed from the -mm tree.  Its filename was
     atl1-add-phy-power-save-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atl1: add PHY power save mode
From: Jay Cliburn <jacliburn@bellsouth.net>

Using vendor-provided magic, add code to enter power save mode on the PHY.
 We'll need this for suspend and wake-on-lan.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atlx/atl1.c |   19 ++++++++-----------
 drivers/net/atlx/atlx.h |    3 +++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/net/atlx/atl1.c~atl1-add-phy-power-save-mode drivers/net/atlx/atl1.c
--- a/drivers/net/atlx/atl1.c~atl1-add-phy-power-save-mode
+++ a/drivers/net/atlx/atl1.c
@@ -638,21 +638,18 @@ static s32 atl1_phy_leave_power_saving(s
 }
 
 /*
- *TODO: do something or get rid of this
+ * Force the PHY into power saving mode using vendor magic.
  */
 #ifdef CONFIG_PM
-static s32 atl1_phy_enter_power_saving(struct atl1_hw *hw)
+static void atl1_phy_enter_power_saving(struct atl1_hw *hw)
 {
-/*    s32 ret_val;
- *    u16 phy_data;
- */
+	atl1_write_phy_reg(hw, MII_DBG_ADDR, 0);
+	atl1_write_phy_reg(hw, MII_DBG_DATA, 0x124E);
+	atl1_write_phy_reg(hw, MII_DBG_ADDR, 2);
+	atl1_write_phy_reg(hw, MII_DBG_DATA, 0x3000);
+	atl1_write_phy_reg(hw, MII_DBG_ADDR, 3);
+	atl1_write_phy_reg(hw, MII_DBG_DATA, 0);
 
-/*
-    ret_val = atl1_write_phy_reg(hw, ...);
-    ret_val = atl1_write_phy_reg(hw, ...);
-    ....
-*/
-	return 0;
 }
 #endif
 
diff -puN drivers/net/atlx/atlx.h~atl1-add-phy-power-save-mode drivers/net/atlx/atlx.h
--- a/drivers/net/atlx/atlx.h~atl1-add-phy-power-save-mode
+++ a/drivers/net/atlx/atlx.h
@@ -460,6 +460,9 @@ MODULE_VERSION(ATLX_DRIVER_VERSION);
 #define MII_ATLX_PSSR_100MBS		0x4000	/* 01=100Mbs */
 #define MII_ATLX_PSSR_1000MBS		0x8000	/* 10=1000Mbs */
 
+#define MII_DBG_ADDR			0x1D
+#define MII_DBG_DATA			0x1E
+
 /* PCI Command Register Bit Definitions */
 #define PCI_REG_COMMAND			0x04	/* PCI Command Register */
 #define CMD_IO_SPACE			0x0001
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

git-net.patch

