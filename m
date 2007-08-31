From: akpm@linux-foundation.org
Subject: + sky2-use-pci_config-access-functions.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:30:08 -0700
Message-ID: <200708311930.l7VJU8ID023083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbXHaTaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:30:11 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l7VJU9R4018133
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2007 12:30:10 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     sky2: use pci_config access functions
has been added to the -mm tree.  Its filename is
     sky2-use-pci_config-access-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sky2: use pci_config access functions
From: Stephen Hemminger <shemminger@linux-foundation.org>

Use the PCI layer config access functions.  The driver was using the memory
mapped window in device, to workaround issues accessing the advanced error
reporting registers.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |   93 +++++++++++++++++++++++--------------------
 drivers/net/sky2.h |   21 ---------
 2 files changed, 51 insertions(+), 63 deletions(-)

diff -puN drivers/net/sky2.c~sky2-use-pci_config-access-functions drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-use-pci_config-access-functions
+++ a/drivers/net/sky2.c
@@ -222,21 +222,22 @@ static void sky2_power_on(struct sky2_hw
 
 	if (hw->chip_id == CHIP_ID_YUKON_EC_U ||
 	    hw->chip_id == CHIP_ID_YUKON_EX) {
+		struct pci_dev *pdev = hw->pdev;
 		u32 reg;
 
-		sky2_pci_write32(hw, PCI_DEV_REG3, 0);
+		pci_write_config_dword(pdev, PCI_DEV_REG3, 0);
 
-		reg = sky2_pci_read32(hw, PCI_DEV_REG4);
+		pci_read_config_dword(pdev, PCI_DEV_REG4, &reg);
 		/* set all bits to 0 except bits 15..12 and 8 */
 		reg &= P_ASPM_CONTROL_MSK;
-		sky2_pci_write32(hw, PCI_DEV_REG4, reg);
+		pci_write_config_dword(pdev, PCI_DEV_REG4, reg);
 
-		reg = sky2_pci_read32(hw, PCI_DEV_REG5);
+		pci_read_config_dword(pdev, PCI_DEV_REG5, &reg);
 		/* set all bits to 0 except bits 28 & 27 */
 		reg &= P_CTL_TIM_VMAIN_AV_MSK;
-		sky2_pci_write32(hw, PCI_DEV_REG5, reg);
+		pci_write_config_dword(pdev, PCI_DEV_REG5, reg);
 
-		sky2_pci_write32(hw, PCI_CFG_REG_1, 0);
+		pci_write_config_dword(pdev, PCI_CFG_REG_1, 0);
 
 		/* Enable workaround for dev 4.107 on Yukon-Ultra & Extreme */
 		reg = sky2_read32(hw, B2_GP_IO);
@@ -596,6 +597,7 @@ static void sky2_phy_init(struct sky2_hw
 
 static void sky2_phy_power(struct sky2_hw *hw, unsigned port, int onoff)
 {
+	struct pci_dev *pdev = hw->pdev;
 	u32 reg1;
 	static const u32 phy_power[]
 		= { PCI_Y2_PHY1_POWD, PCI_Y2_PHY2_POWD };
@@ -604,15 +606,16 @@ static void sky2_phy_power(struct sky2_h
 	if (hw->chip_id == CHIP_ID_YUKON_XL && hw->chip_rev > 1)
 		onoff = !onoff;
 
-	reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
+	pci_read_config_dword(pdev, PCI_DEV_REG1, &reg1);
 	if (onoff)
 		/* Turn off phy power saving */
 		reg1 &= ~phy_power[port];
 	else
 		reg1 |= phy_power[port];
 
-	sky2_pci_write32(hw, PCI_DEV_REG1, reg1);
-	sky2_pci_read32(hw, PCI_DEV_REG1);
+	pci_write_config_dword(pdev, PCI_DEV_REG1, reg1);
+	pci_read_config_dword(pdev, PCI_DEV_REG1, &reg1);
+
 	udelay(100);
 }
 
@@ -680,9 +683,9 @@ static void sky2_wol_init(struct sky2_po
 	sky2_write16(hw, WOL_REGS(port, WOL_CTRL_STAT), ctrl);
 
 	/* Turn on legacy PCI-Express PME mode */
-	reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
+	pci_read_config_dword(hw->pdev, PCI_DEV_REG1, &reg1);
 	reg1 |= PCI_Y2_PME_LEGACY;
-	sky2_pci_write32(hw, PCI_DEV_REG1, reg1);
+	pci_write_config_dword(hw->pdev, PCI_DEV_REG1, reg1);
 
 	/* block receiver */
 	sky2_write8(hw, SK_REG(port, RX_GMF_CTRL_T), GMF_RST_SET);
@@ -1281,9 +1284,9 @@ static int sky2_up(struct net_device *de
  		struct sky2_port *osky2 = netdev_priv(otherdev);
  		u16 cmd;
 
- 		cmd = sky2_pci_read16(hw, cap + PCI_X_CMD);
+		pci_read_config_word(hw->pdev, cap + PCI_X_CMD, &cmd);
  		cmd &= ~PCI_X_CMD_MAX_SPLIT;
- 		sky2_pci_write16(hw, cap + PCI_X_CMD, cmd);
+ 		pci_write_config_word(hw->pdev, cap + PCI_X_CMD, cmd);
 
  		sky2->rx_csum = 0;
  		osky2->rx_csum = 0;
@@ -2382,13 +2385,13 @@ static void sky2_hw_intr(struct sky2_hw 
 	if (status & (Y2_IS_MST_ERR | Y2_IS_IRQ_STAT)) {
 		u16 pci_err;
 
-		pci_err = sky2_pci_read16(hw, PCI_STATUS);
+		pci_read_config_word(pdev, PCI_STATUS, &pci_err);
 		if (net_ratelimit())
 			dev_err(&pdev->dev, "PCI hardware error (0x%x)\n",
 			        pci_err);
 
-		sky2_pci_write16(hw, PCI_STATUS,
-				 pci_err | PCI_STATUS_ERROR_BITS);
+		pci_write_config_word(pdev, PCI_STATUS,
+				      pci_err | PCI_STATUS_ERROR_BITS);
 	}
 
 	if (status & Y2_IS_PCI_EXP) {
@@ -2599,10 +2602,13 @@ static inline u32 sky2_clk2us(const stru
 
 static int __devinit sky2_init(struct sky2_hw *hw)
 {
+	int rc;
 	u8 t8;
 
-	/* Enable all clocks */
-	sky2_pci_write32(hw, PCI_DEV_REG3, 0);
+	/* Enable all clocks and check for bad PCI access */
+	rc = pci_write_config_dword(hw->pdev, PCI_DEV_REG3, 0);
+	if (rc)
+		return rc;
 
 	sky2_write8(hw, B0_CTST, CS_RST_CLR);
 
@@ -2657,10 +2663,9 @@ static void sky2_reset(struct sky2_hw *h
 	sky2_write8(hw, B0_CTST, CS_RST_CLR);
 
 	/* clear PCI errors, if any */
-	status = sky2_pci_read16(hw, PCI_STATUS);
-
-	sky2_pci_write16(hw, PCI_STATUS, status | PCI_STATUS_ERROR_BITS);
-
+	pci_read_config_word(pdev, PCI_STATUS, &status);
+	status |= PCI_STATUS_ERROR_BITS;
+	pci_write_config_word(pdev, PCI_STATUS, status);
 
 	sky2_write8(hw, B0_CTST, CS_MRST_CLR);
 
@@ -3477,26 +3482,31 @@ static int sky2_get_eeprom_len(struct ne
 	struct sky2_port *sky2 = netdev_priv(dev);
 	u16 reg2;
 
-	reg2 = sky2_pci_read32(sky2->hw, PCI_DEV_REG2);
+	pci_read_config_word(sky2->hw->pdev, PCI_DEV_REG2, &reg2);
 	return 1 << ( ((reg2 & PCI_VPD_ROM_SZ) >> 14) + 8);
 }
 
-static u32 sky2_vpd_read(struct sky2_hw *hw, int cap, u16 offset)
+static u32 sky2_vpd_read(struct pci_dev *pdev, int cap, u16 offset)
 {
-	sky2_pci_write16(hw, cap + PCI_VPD_ADDR, offset);
+	u32 val;
 
-	while (!(sky2_pci_read16(hw, cap + PCI_VPD_ADDR) & PCI_VPD_ADDR_F))
-			cpu_relax();
-	return sky2_pci_read32(hw, cap + PCI_VPD_DATA);
+	pci_write_config_word(pdev, cap + PCI_VPD_ADDR, offset);
+
+	do {
+		pci_read_config_word(pdev, cap + PCI_VPD_ADDR, &offset);
+	} while (!(offset & PCI_VPD_ADDR_F));
+
+	pci_read_config_dword(pdev, cap + PCI_VPD_DATA, &val);
+	return val;
 }
 
-static void sky2_vpd_write(struct sky2_hw *hw, int cap, u16 offset, u32 val)
+static void sky2_vpd_write(struct pci_dev *pdev, int cap, u16 offset, u32 val)
 {
-	sky2_pci_write32(hw, cap + PCI_VPD_DATA, val);
-	sky2_pci_write16(hw, cap + PCI_VPD_ADDR, offset | PCI_VPD_ADDR_F);
+	pci_write_config_word(pdev, cap + PCI_VPD_DATA, val);
+	pci_write_config_dword(pdev, cap + PCI_VPD_ADDR, offset | PCI_VPD_ADDR_F);
 	do {
-		cpu_relax();
-	} while (sky2_pci_read16(hw, cap + PCI_VPD_ADDR) & PCI_VPD_ADDR_F);
+		pci_read_config_word(pdev, cap + PCI_VPD_ADDR, &offset);
+	} while (offset & PCI_VPD_ADDR_F);
 }
 
 static int sky2_get_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
@@ -3513,7 +3523,7 @@ static int sky2_get_eeprom(struct net_de
 	eeprom->magic = SKY2_EEPROM_MAGIC;
 
 	while (length > 0) {
-		u32 val = sky2_vpd_read(sky2->hw, cap, offset);
+		u32 val = sky2_vpd_read(sky2->hw->pdev, cap, offset);
 		int n = min_t(int, length, sizeof(val));
 
 		memcpy(data, &val, n);
@@ -3543,10 +3553,10 @@ static int sky2_set_eeprom(struct net_de
 		int n = min_t(int, length, sizeof(val));
 
 		if (n < sizeof(val))
-			val = sky2_vpd_read(sky2->hw, cap, offset);
+			val = sky2_vpd_read(sky2->hw->pdev, cap, offset);
 		memcpy(&val, data, n);
 
-		sky2_vpd_write(sky2->hw, cap, offset, val);
+		sky2_vpd_write(sky2->hw->pdev, cap, offset, val);
 
 		length -= n;
 		data += n;
@@ -3990,15 +4000,14 @@ static int __devinit sky2_probe(struct p
 	 */
 	{
 		u32 reg;
-		reg = sky2_pci_read32(hw, PCI_DEV_REG2);
+		pci_read_config_dword(pdev,PCI_DEV_REG2, &reg);
 		reg &= ~PCI_REV_DESC;
-		sky2_pci_write32(hw, PCI_DEV_REG2, reg);
+		pci_write_config_dword(pdev, PCI_DEV_REG2, reg);
 	}
 #endif
 
 	/* ring for status responses */
-	hw->st_le = pci_alloc_consistent(hw->pdev, STATUS_LE_BYTES,
-					 &hw->st_dma);
+	hw->st_le = pci_alloc_consistent(pdev, STATUS_LE_BYTES, &hw->st_dma);
 	if (!hw->st_le)
 		goto err_out_iounmap;
 
@@ -4073,7 +4082,7 @@ err_out_free_netdev:
 	free_netdev(dev);
 err_out_free_pci:
 	sky2_write8(hw, B0_CTST, CS_RST_SET);
-	pci_free_consistent(hw->pdev, STATUS_LE_BYTES, hw->st_le, hw->st_dma);
+	pci_free_consistent(pdev, STATUS_LE_BYTES, hw->st_le, hw->st_dma);
 err_out_iounmap:
 	iounmap(hw->regs);
 err_out_free_hw:
@@ -4184,7 +4193,7 @@ static int sky2_resume(struct pci_dev *p
 
 	/* Re-enable all clocks */
 	if (hw->chip_id == CHIP_ID_YUKON_EX || hw->chip_id == CHIP_ID_YUKON_EC_U)
-		sky2_pci_write32(hw, PCI_DEV_REG3, 0);
+		pci_write_config_dword(pdev, PCI_DEV_REG3, 0);
 
 	sky2_reset(hw);
 
diff -puN drivers/net/sky2.h~sky2-use-pci_config-access-functions drivers/net/sky2.h
--- a/drivers/net/sky2.h~sky2-use-pci_config-access-functions
+++ a/drivers/net/sky2.h
@@ -2115,25 +2115,4 @@ static inline void gma_set_addr(struct s
 	gma_write16(hw, port, reg+4,(u16) addr[2] | ((u16) addr[3] << 8));
 	gma_write16(hw, port, reg+8,(u16) addr[4] | ((u16) addr[5] << 8));
 }
-
-/* PCI config space access */
-static inline u32 sky2_pci_read32(const struct sky2_hw *hw, unsigned reg)
-{
-	return sky2_read32(hw, Y2_CFG_SPC + reg);
-}
-
-static inline u16 sky2_pci_read16(const struct sky2_hw *hw, unsigned reg)
-{
-	return sky2_read16(hw, Y2_CFG_SPC + reg);
-}
-
-static inline void sky2_pci_write32(struct sky2_hw *hw, unsigned reg, u32 val)
-{
-	sky2_write32(hw, Y2_CFG_SPC + reg, val);
-}
-
-static inline void sky2_pci_write16(struct sky2_hw *hw, unsigned reg, u16 val)
-{
-	sky2_write16(hw, Y2_CFG_SPC + reg, val);
-}
 #endif
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
