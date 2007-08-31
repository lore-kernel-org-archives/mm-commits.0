From: akpm@linux-foundation.org
Subject: + sky2-fe-chip-support.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:29:58 -0700
Message-ID: <200708311929.l7VJTwpo022989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbXHaTaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:30:01 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l7VJTxwt018086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2007 12:30:00 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     sky2: fe+ chip support
has been added to the -mm tree.  Its filename is
     sky2-fe-chip-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sky2: fe+ chip support
From: Stephen Hemminger <shemminger@linux-foundation.org>

Add support for new Marvell 100mbit chips.

This code is ported from the SysKonnect 10.20.3.3 driver.  It is *untested*
because I don't have access to this hardware.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |   64 +++++++++++++++++++++++++++++++++++--------
 drivers/net/sky2.h |   20 ++++++++++---
 2 files changed, 69 insertions(+), 15 deletions(-)

diff -puN drivers/net/sky2.c~sky2-fe-chip-support drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-fe-chip-support
+++ a/drivers/net/sky2.c
@@ -118,12 +118,15 @@ static const struct pci_device_id sky2_i
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4351) }, /* 88E8036 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4352) }, /* 88E8038 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4353) }, /* 88E8039 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4356) }, /* 88E8033 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4356) }, /* 88EC033 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x435A) }, /* 88E8048 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4360) }, /* 88E8052 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4361) }, /* 88E8050 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4362) }, /* 88E8053 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4363) }, /* 88E8055 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4364) }, /* 88E8056 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4365) }, /* 88E8070 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4366) }, /* 88EC036 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4367) }, /* 88EC032 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4368) }, /* 88EC034 */
@@ -147,6 +150,7 @@ static const char *yukon2_name[] = {
 	"Extreme",	/* 0xb5 */
 	"EC",		/* 0xb6 */
 	"FE",		/* 0xb7 */
+	"FE+",		/* 0xb8 */
 };
 
 /* Access to external PHY */
@@ -332,7 +336,8 @@ static void sky2_phy_init(struct sky2_hw
 
 	ctrl = gm_phy_read(hw, port, PHY_MARV_PHY_CTRL);
 	if (sky2_is_copper(hw)) {
-		if (hw->chip_id == CHIP_ID_YUKON_FE) {
+		if (hw->chip_id == CHIP_ID_YUKON_FE ||
+		    hw->chip_id == CHIP_ID_YUKON_FE_P) {
 			/* enable automatic crossover */
 			ctrl |= PHY_M_PC_MDI_XMODE(PHY_M_PC_ENA_AUTO) >> 1;
 		} else {
@@ -453,7 +458,7 @@ static void sky2_phy_init(struct sky2_hw
 
 	gma_write16(hw, port, GM_GP_CTRL, reg);
 
-	if (hw->chip_id != CHIP_ID_YUKON_FE)
+	if (sky2_is_gigabit(hw))
 		gm_phy_write(hw, port, PHY_MARV_1000T_CTRL, ct1000);
 
 	gm_phy_write(hw, port, PHY_MARV_AUNE_ADV, adv);
@@ -477,6 +482,22 @@ static void sky2_phy_init(struct sky2_hw
 		gm_phy_write(hw, port, PHY_MARV_FE_LED_PAR, ctrl);
 		break;
 
+	case CHIP_ID_YUKON_FE_P:
+		/* Enable Link Partner Next Page */
+		ctrl |= PHY_M_PC_ENA_LIP_NP;
+
+		/* disable Energy Detect and enable scrambler */
+		ctrl &= ~(PHY_M_PC_ENA_ENE_DT | PHY_M_PC_DIS_SCRAMB);
+		gm_phy_write(hw, port, PHY_MARV_CTRL, ctrl);
+
+		/* set LED2 -> ACT, LED1 -> LINK, LED0 -> SPEED */
+		ctrl = PHY_M_FELP_LED2_CTRL(LED_PAR_CTRL_ACT_BL) |
+			PHY_M_FELP_LED1_CTRL(LED_PAR_CTRL_LINK) |
+			PHY_M_FELP_LED0_CTRL(LED_PAR_CTRL_SPEED);
+
+		gm_phy_write(hw, port, PHY_MARV_FE_LED_PAR, ctrl);
+		break;
+
 	case CHIP_ID_YUKON_XL:
 		pg = gm_phy_read(hw, port, PHY_MARV_EXT_ADR);
 
@@ -546,7 +567,13 @@ static void sky2_phy_init(struct sky2_hw
 
 		/* set page register to 0 */
 		gm_phy_write(hw, port, PHY_MARV_EXT_ADR, 0);
+	} else if (hw->chip_id == CHIP_ID_YUKON_FE_P &&
+		   hw->chip_rev == CHIP_REV_YU_FE2_A0) {
+		/* apply workaround for integrated resistors calibration */
+		gm_phy_write(hw, port, PHY_MARV_PAGE_ADDR, 17);
+		gm_phy_write(hw, port, PHY_MARV_PAGE_DATA, 0x3f60);
 	} else if (hw->chip_id != CHIP_ID_YUKON_EX) {
+		/* no effect on Yukon-XL */
 		gm_phy_write(hw, port, PHY_MARV_LED_CTRL, ledctrl);
 
 		if (sky2->autoneg == AUTONEG_DISABLE || sky2->speed == SPEED_100) {
@@ -1709,8 +1736,12 @@ static u16 sky2_phy_speed(const struct s
 	if (!sky2_is_copper(hw))
 		return SPEED_1000;
 
-	if (hw->chip_id == CHIP_ID_YUKON_FE)
-		return (aux & PHY_M_PS_SPEED_100) ? SPEED_100 : SPEED_10;
+	if (!sky2_is_gigabit(hw)) {
+		if (aux & PHY_M_PS_SPEED_100)
+			return SPEED_100;
+		else
+			return SPEED_10;
+	}
 
 	switch (aux & PHY_M_PS_SPEED_MSK) {
 	case PHY_M_PS_SPEED_1000:
@@ -1956,7 +1987,9 @@ static int sky2_change_mtu(struct net_de
 	if (new_mtu < ETH_ZLEN || new_mtu > ETH_JUMBO_MTU)
 		return -EINVAL;
 
-	if (new_mtu > ETH_DATA_LEN && hw->chip_id == CHIP_ID_YUKON_FE)
+	if (new_mtu > ETH_DATA_LEN &&
+	    (hw->chip_id == CHIP_ID_YUKON_FE ||
+	     hw->chip_id == CHIP_ID_YUKON_FE_P))
 		return -EINVAL;
 
 	if (!netif_running(dev)) {
@@ -2544,17 +2577,25 @@ static void sky2_netpoll(struct net_devi
 #endif
 
 /* Chip internal frequency for clock calculations */
-static inline u32 sky2_mhz(const struct sky2_hw *hw)
+static u32 sky2_mhz(const struct sky2_hw *hw)
 {
 	switch (hw->chip_id) {
 	case CHIP_ID_YUKON_EC:
 	case CHIP_ID_YUKON_EC_U:
 	case CHIP_ID_YUKON_EX:
-		return 125;	/* 125 Mhz */
+		return 125;
+
 	case CHIP_ID_YUKON_FE:
-		return 100;	/* 100 Mhz */
-	default:		/* YUKON_XL */
-		return 156;	/* 156 Mhz */
+		return 100;
+
+	case CHIP_ID_YUKON_FE_P:
+		return 50;
+
+	case CHIP_ID_YUKON_XL:
+		return 156;
+
+	default:
+		BUG();
 	}
 }
 
@@ -2579,7 +2620,8 @@ static int __devinit sky2_init(struct sk
 	sky2_write8(hw, B0_CTST, CS_RST_CLR);
 
 	hw->chip_id = sky2_read8(hw, B2_CHIP_ID);
-	if (hw->chip_id < CHIP_ID_YUKON_XL || hw->chip_id > CHIP_ID_YUKON_FE) {
+	if (hw->chip_id < CHIP_ID_YUKON_XL ||
+	    hw->chip_id > CHIP_ID_YUKON_FE_P) {
 		dev_err(&hw->pdev->dev, "unsupported chip type 0x%x\n",
 			hw->chip_id);
 		return -EOPNOTSUPP;
diff -puN drivers/net/sky2.h~sky2-fe-chip-support drivers/net/sky2.h
--- a/drivers/net/sky2.h~sky2-fe-chip-support
+++ a/drivers/net/sky2.h
@@ -470,18 +470,24 @@ enum {
 	CHIP_ID_YUKON_EX   = 0xb5, /* Chip ID for YUKON-2 Extreme */
 	CHIP_ID_YUKON_EC   = 0xb6, /* Chip ID for YUKON-2 EC */
  	CHIP_ID_YUKON_FE   = 0xb7, /* Chip ID for YUKON-2 FE */
-
+ 	CHIP_ID_YUKON_FE_P = 0xb8, /* Chip ID for YUKON-2 FE+ */
+};
+enum yukon_ec_rev {
 	CHIP_REV_YU_EC_A1    = 0,  /* Chip Rev. for Yukon-EC A1/A0 */
 	CHIP_REV_YU_EC_A2    = 1,  /* Chip Rev. for Yukon-EC A2 */
 	CHIP_REV_YU_EC_A3    = 2,  /* Chip Rev. for Yukon-EC A3 */
-
+};
+enum yukon_ec_u_rev {
 	CHIP_REV_YU_EC_U_A0  = 1,
 	CHIP_REV_YU_EC_U_A1  = 2,
 	CHIP_REV_YU_EC_U_B0  = 3,
-
+};
+enum yukon_fe_rev {
 	CHIP_REV_YU_FE_A1    = 1,
 	CHIP_REV_YU_FE_A2    = 2,
-
+};
+enum yukon_fe_p_rev {
+	CHIP_REV_YU_FE2_A0   = 0,
 };
 enum yukon_ex_rev {
 	CHIP_REV_YU_EX_A0    = 1,
@@ -2062,6 +2068,12 @@ static inline int sky2_is_copper(const s
 	return !(hw->pmd_type == 'L' || hw->pmd_type == 'S' || hw->pmd_type == 'P');
 }
 
+static inline int sky2_is_gigabit(const struct sky2_hw *hw)
+{
+	return !(hw->chip_id == CHIP_ID_YUKON_FE
+		 || hw->chip_id == CHIP_ID_YUKON_FE_P);
+}
+
 /* Register accessor for memory mapped device */
 static inline u32 sky2_read32(const struct sky2_hw *hw, unsigned reg)
 {
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
sky2-fe-chip-support.patch
sky2-use-debugfs-rename.patch
sky2-document-gphy_ctrl-bits.patch
sky2-dont-restrict-config-space-access.patch
sky2-advanced-error-reporting.patch
sky2-use-pci_config-access-functions.patch
sky2-use-net_device-internal-stats.patch
ktime_sub_ns-analog-of-ktime_add_ns.patch
export-reciprocal_value-for-modules.patch
sky2-hardware-receive-timestamp-counter.patch
sky2-avoid-divide-in-receive-path.patch
sky2-118.patch
git-net.patch
i386-optimize-memset-of-6-and-8-bytes.patch
