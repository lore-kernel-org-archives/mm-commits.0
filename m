From: akpm@linux-foundation.org
Subject: - orion-use-mv643xx_eth-driver-mbus-window-handling.patch removed from -mm tree
Date: Fri, 09 May 2008 12:59:55 -0700
Message-ID: <200805091959.m49JxuLN023156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbYEIUAC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 16:00:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, buytenh@marvell.com, nico@marvell.com, rmk+kernel@arm.linux.org.uk, tzachi@marvell.com, mm-commits@vger.kernel.org


The patch titled
     arm: orion: use mv643xx_eth driver mbus window handling
has been removed from the -mm tree.  Its filename was
     orion-use-mv643xx_eth-driver-mbus-window-handling.patch

This patch was dropped because it's already in git-orion

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: orion: use mv643xx_eth driver mbus window handling
From: Lennert Buytenhek <buytenh@wantstofly.org>

Make the Orion 5x platform code use the mbus window handling code that's in
the mv643xx_eth driver, instead of programming the GigE block's mbus window
registers by hand.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Reviewed-by: Tzachi Perelstein <tzachi@marvell.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-orion5x/addr-map.c |   47 -----------------------------
 arch/arm/mach-orion5x/common.c   |    8 ++++
 arch/arm/mach-orion5x/common.h   |    1 
 3 files changed, 7 insertions(+), 49 deletions(-)

diff -puN arch/arm/mach-orion5x/addr-map.c~orion-use-mv643xx_eth-driver-mbus-window-handling arch/arm/mach-orion5x/addr-map.c
--- a/arch/arm/mach-orion5x/addr-map.c~orion-use-mv643xx_eth-driver-mbus-window-handling
+++ a/arch/arm/mach-orion5x/addr-map.c
@@ -81,17 +81,6 @@
 #define CPU_WIN_REMAP_LO(n)	ORION5X_BRIDGE_REG(0x008 | ((n) << 4))
 #define CPU_WIN_REMAP_HI(n)	ORION5X_BRIDGE_REG(0x00c | ((n) << 4))
 
-/*
- * Gigabit Ethernet Address Decode Windows registers
- */
-#define ETH_WIN_BASE(win)	ORION5X_ETH_REG(0x200 + ((win) * 8))
-#define ETH_WIN_SIZE(win)	ORION5X_ETH_REG(0x204 + ((win) * 8))
-#define ETH_WIN_REMAP(win)	ORION5X_ETH_REG(0x280 + ((win) * 4))
-#define ETH_WIN_EN		ORION5X_ETH_REG(0x290)
-#define ETH_WIN_PROT		ORION5X_ETH_REG(0x294)
-#define ETH_MAX_WIN		6
-#define ETH_MAX_REMAP_WIN	4
-
 
 struct mbus_dram_target_info orion5x_mbus_dram_info;
 
@@ -202,39 +191,3 @@ void __init orion5x_setup_pcie_wa_win(u3
 {
 	setup_cpu_win(7, base, size, TARGET_PCIE, ATTR_PCIE_WA, -1);
 }
-
-void __init orion5x_setup_eth_wins(void)
-{
-	int i;
-
-	/*
-	 * First, disable and clear windows
-	 */
-	for (i = 0; i < ETH_MAX_WIN; i++) {
-		orion5x_write(ETH_WIN_BASE(i), 0);
-		orion5x_write(ETH_WIN_SIZE(i), 0);
-		orion5x_setbits(ETH_WIN_EN, 1 << i);
-		orion5x_clrbits(ETH_WIN_PROT, 0x3 << (i * 2));
-		if (i < ETH_MAX_REMAP_WIN)
-			orion5x_write(ETH_WIN_REMAP(i), 0);
-	}
-
-	/*
-	 * Setup windows for DDR banks.
-	 */
-	for (i = 0; i < DDR_MAX_CS; i++) {
-		u32 base, size;
-		size = orion5x_read(DDR_SIZE_CS(i));
-		base = orion5x_read(DDR_BASE_CS(i));
-		if (size & DDR_BANK_EN) {
-			base = DDR_REG_TO_BASE(base);
-			size = DDR_REG_TO_SIZE(size);
-			orion5x_write(ETH_WIN_SIZE(i), (size-1) & 0xffff0000);
-			orion5x_write(ETH_WIN_BASE(i), (base & 0xffff0000) |
-					(ATTR_DDR_CS(i) << 8) |
-					TARGET_DDR);
-			orion5x_clrbits(ETH_WIN_EN, 1 << i);
-			orion5x_setbits(ETH_WIN_PROT, 0x3 << (i * 2));
-		}
-	}
-}
diff -puN arch/arm/mach-orion5x/common.c~orion-use-mv643xx_eth-driver-mbus-window-handling arch/arm/mach-orion5x/common.c
--- a/arch/arm/mach-orion5x/common.c~orion-use-mv643xx_eth-driver-mbus-window-handling
+++ a/arch/arm/mach-orion5x/common.c
@@ -190,6 +190,10 @@ static struct platform_device orion5x_eh
  * (The Orion and Discovery (MV643xx) families use the same Ethernet driver)
  ****************************************************************************/
 
+struct mv643xx_eth_shared_platform_data orion5x_eth_shared_data = {
+	.dram		= &orion5x_mbus_dram_info,
+};
+
 static struct resource orion5x_eth_shared_resources[] = {
 	{
 		.start	= ORION5X_ETH_PHYS_BASE + 0x2000,
@@ -201,6 +205,9 @@ static struct resource orion5x_eth_share
 static struct platform_device orion5x_eth_shared = {
 	.name		= MV643XX_ETH_SHARED_NAME,
 	.id		= 0,
+	.dev		= {
+		.platform_data	= &orion5x_eth_shared_data,
+	},
 	.num_resources	= 1,
 	.resource	= orion5x_eth_shared_resources,
 };
@@ -360,7 +367,6 @@ void __init orion5x_init(void)
 	 * Setup Orion address map
 	 */
 	orion5x_setup_cpu_mbus_bridge();
-	orion5x_setup_eth_wins();
 
 	/*
 	 * Register devices.
diff -puN arch/arm/mach-orion5x/common.h~orion-use-mv643xx_eth-driver-mbus-window-handling arch/arm/mach-orion5x/common.h
--- a/arch/arm/mach-orion5x/common.h~orion-use-mv643xx_eth-driver-mbus-window-handling
+++ a/arch/arm/mach-orion5x/common.h
@@ -22,7 +22,6 @@ void orion5x_setup_dev0_win(u32 base, u3
 void orion5x_setup_dev1_win(u32 base, u32 size);
 void orion5x_setup_dev2_win(u32 base, u32 size);
 void orion5x_setup_pcie_wa_win(u32 base, u32 size);
-void orion5x_setup_eth_wins(void);
 
 /*
  * Shared code used internally by other Orion core functions.
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

orion-use-mv643xx_eth-driver-mbus-window-handling.patch
orion-pass-proper-t_clk-into-mv643xx_eth.patch
orion-clean-up-addr-mapc-after-window-setting-code-purge.patch
leds-add-pca9532-platform-data-for-thecus-n2100.patch
git-orion.patch

