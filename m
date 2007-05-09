From: akpm@linux-foundation.org
Subject: - mips-drop-unnecessary-config_isa-from-rbtx49xx.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:02 -0700
Message-ID: <200705090243.l492h26n008405@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967548AbXEICnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, jeff@garzik.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     MIPS: Drop unnecessary CONFIG_ISA from RBTX49XX
has been removed from the -mm tree.  Its filename was
     mips-drop-unnecessary-config_isa-from-rbtx49xx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MIPS: Drop unnecessary CONFIG_ISA from RBTX49XX
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Those boards do not need CONFIG_ISA if the ne driver could be selectable
without it.  Disable it and update a defconfig.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig                     |    2 -
 arch/mips/configs/rbhma4500_defconfig |   31 ------------------------
 2 files changed, 33 deletions(-)

diff -puN arch/mips/Kconfig~mips-drop-unnecessary-config_isa-from-rbtx49xx arch/mips/Kconfig
--- a/arch/mips/Kconfig~mips-drop-unnecessary-config_isa-from-rbtx49xx
+++ a/arch/mips/Kconfig
@@ -784,7 +784,6 @@ config TOSHIBA_RBTX4927
 	select HAS_TXX9_SERIAL
 	select HW_HAS_PCI
 	select I8259
-	select ISA
 	select SWAP_IO_SPACE
 	select SYS_HAS_CPU_TX49XX
 	select SYS_SUPPORTS_32BIT_KERNEL
@@ -806,7 +805,6 @@ config TOSHIBA_RBTX4938
 	select HAS_TXX9_SERIAL
 	select HW_HAS_PCI
 	select I8259
-	select ISA
 	select SWAP_IO_SPACE
 	select SYS_HAS_CPU_TX49XX
 	select SYS_SUPPORTS_32BIT_KERNEL
diff -puN arch/mips/configs/rbhma4500_defconfig~mips-drop-unnecessary-config_isa-from-rbtx49xx arch/mips/configs/rbhma4500_defconfig
--- a/arch/mips/configs/rbhma4500_defconfig~mips-drop-unnecessary-config_isa-from-rbtx49xx
+++ a/arch/mips/configs/rbhma4500_defconfig
@@ -245,7 +245,6 @@ CONFIG_DEFAULT_IOSCHED="anticipatory"
 #
 CONFIG_HW_HAS_PCI=y
 CONFIG_PCI=y
-CONFIG_ISA=y
 CONFIG_MMU=y
 
 #
@@ -573,7 +572,6 @@ CONFIG_MTD_CFI_UTIL=y
 #
 # Plug and Play support
 #
-# CONFIG_PNP is not set
 # CONFIG_PNPACPI is not set
 
 #
@@ -658,7 +656,6 @@ CONFIG_BLK_DEV_IT8213=m
 # CONFIG_BLK_DEV_VIA82CXXX is not set
 CONFIG_BLK_DEV_TC86C001=m
 # CONFIG_IDE_ARM is not set
-# CONFIG_IDE_CHIPSETS is not set
 CONFIG_BLK_DEV_IDEDMA=y
 # CONFIG_IDEDMA_IVB is not set
 # CONFIG_IDEDMA_AUTO is not set
@@ -677,11 +674,6 @@ CONFIG_RAID_ATTRS=m
 # CONFIG_ATA is not set
 
 #
-# Old CD-ROM drivers (not SCSI, not IDE)
-#
-# CONFIG_CD_NO_IDESCSI is not set
-
-#
 # Multi-device support (RAID and LVM)
 #
 # CONFIG_MD is not set
@@ -742,37 +734,20 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_SUNGEM is not set
 # CONFIG_CASSINI is not set
 # CONFIG_NET_VENDOR_3COM is not set
-# CONFIG_NET_VENDOR_SMC is not set
 # CONFIG_DM9000 is not set
-# CONFIG_NET_VENDOR_RACAL is not set
 
 #
 # Tulip family network device support
 #
 # CONFIG_NET_TULIP is not set
-# CONFIG_AT1700 is not set
-# CONFIG_DEPCA is not set
 # CONFIG_HP100 is not set
-CONFIG_NET_ISA=y
-# CONFIG_E2100 is not set
-# CONFIG_EWRK3 is not set
-# CONFIG_EEXPRESS is not set
-# CONFIG_EEXPRESS_PRO is not set
-# CONFIG_HPLAN_PLUS is not set
-# CONFIG_HPLAN is not set
-# CONFIG_LP486E is not set
-# CONFIG_ETH16I is not set
 CONFIG_NE2000=y
-# CONFIG_SEEQ8005 is not set
 CONFIG_NET_PCI=y
 # CONFIG_PCNET32 is not set
 # CONFIG_AMD8111_ETH is not set
 # CONFIG_ADAPTEC_STARFIRE is not set
-# CONFIG_AC3200 is not set
-# CONFIG_APRICOT is not set
 # CONFIG_B44 is not set
 # CONFIG_FORCEDETH is not set
-# CONFIG_CS89x0 is not set
 # CONFIG_DGRS is not set
 # CONFIG_EEPRO100 is not set
 # CONFIG_E100 is not set
@@ -833,8 +808,6 @@ CONFIG_NET_RADIO=y
 # Obsolete Wireless cards support (pre-802.11)
 #
 # CONFIG_STRIP is not set
-# CONFIG_ARLAN is not set
-# CONFIG_WAVELAN is not set
 
 #
 # Wireless 802.11b ISA/PCI cards support
@@ -920,9 +893,6 @@ CONFIG_KEYBOARD_ATKBD=y
 CONFIG_INPUT_MOUSE=y
 CONFIG_MOUSE_PS2=y
 # CONFIG_MOUSE_SERIAL is not set
-# CONFIG_MOUSE_INPORT is not set
-# CONFIG_MOUSE_LOGIBM is not set
-# CONFIG_MOUSE_PC110PAD is not set
 # CONFIG_MOUSE_VSXXXAA is not set
 # CONFIG_INPUT_JOYSTICK is not set
 # CONFIG_INPUT_TOUCHSCREEN is not set
@@ -1072,7 +1042,6 @@ CONFIG_FB_ATY_CT=y
 #
 CONFIG_VGA_CONSOLE=y
 # CONFIG_VGACON_SOFT_SCROLLBACK is not set
-# CONFIG_MDA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
 # CONFIG_FRAMEBUFFER_CONSOLE is not set
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-mips.patch
mips-make-resources-for-ds1742-static-__initdata.patch
