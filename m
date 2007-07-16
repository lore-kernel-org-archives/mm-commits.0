From: akpm@linux-foundation.org
Subject: - introduce-config_virt_to_bus.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:18 -0700
Message-ID: <200707162054.l6GKsIIS001790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761009AbXGPVeh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:34:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, davem@davemloft.net, viro@ftp.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Introduce CONFIG_VIRT_TO_BUS
has been removed from the -mm tree.  Its filename was
     introduce-config_virt_to_bus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Introduce CONFIG_VIRT_TO_BUS
From: Stephen Rothwell <sfr@canb.auug.org.au>

Make some offending drivers depend on it and set CONFIG_ARCH_NO_VIRT_TO_BUS
for ppc64 so that we don't build those drivers.

This gets PowerPC allmodconfig and allyesconfig much closer to building.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ftp.linux.org.uk>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig        |    3 +++
 drivers/atm/Kconfig         |    8 ++++----
 drivers/block/Kconfig       |    2 +-
 drivers/message/i2o/Kconfig |    1 +
 drivers/net/wan/Kconfig     |    2 +-
 drivers/scsi/Kconfig        |    2 +-
 mm/Kconfig                  |    4 ++++
 sound/oss/Kconfig           |    5 +++--
 8 files changed, 18 insertions(+), 9 deletions(-)

diff -puN arch/powerpc/Kconfig~introduce-config_virt_to_bus arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~introduce-config_virt_to_bus
+++ a/arch/powerpc/Kconfig
@@ -66,6 +66,9 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config ARCH_NO_VIRT_TO_BUS
+	def_bool PPC64
+
 config PPC
 	bool
 	default y
diff -puN drivers/atm/Kconfig~introduce-config_virt_to_bus drivers/atm/Kconfig
--- a/drivers/atm/Kconfig~introduce-config_virt_to_bus
+++ a/drivers/atm/Kconfig
@@ -142,7 +142,7 @@ config ATM_ENI_BURST_RX_2W
 
 config ATM_FIRESTREAM
 	tristate "Fujitsu FireStream (FS50/FS155) "
-	depends on PCI
+	depends on PCI && VIRT_TO_BUS
 	help
 	  Driver for the Fujitsu FireStream 155 (MB86697) and
 	  FireStream 50 (MB86695) ATM PCI chips.
@@ -152,7 +152,7 @@ config ATM_FIRESTREAM
 
 config ATM_ZATM
 	tristate "ZeitNet ZN1221/ZN1225"
-	depends on PCI
+	depends on PCI && VIRT_TO_BUS
 	help
 	  Driver for the ZeitNet ZN1221 (MMF) and ZN1225 (UTP-5) 155 Mbps ATM
 	  adapters.
@@ -240,7 +240,7 @@ config ATM_IDT77252_USE_SUNI
 
 config ATM_AMBASSADOR
 	tristate "Madge Ambassador (Collage PCI 155 Server)"
-	depends on PCI
+	depends on PCI && VIRT_TO_BUS
 	select BITREVERSE
 	help
 	  This is a driver for ATMizer based ATM card produced by Madge
@@ -265,7 +265,7 @@ config ATM_AMBASSADOR_DEBUG
 
 config ATM_HORIZON
 	tristate "Madge Horizon [Ultra] (Collage PCI 25 and Collage PCI 155 Client)"
-	depends on PCI
+	depends on PCI && VIRT_TO_BUS
 	help
 	  This is a driver for the Horizon chipset ATM adapter cards once
 	  produced by Madge Networks Ltd. Say Y (or M to compile as a module
diff -puN drivers/block/Kconfig~introduce-config_virt_to_bus drivers/block/Kconfig
--- a/drivers/block/Kconfig~introduce-config_virt_to_bus
+++ a/drivers/block/Kconfig
@@ -113,7 +113,7 @@ source "drivers/block/paride/Kconfig"
 
 config BLK_CPQ_DA
 	tristate "Compaq SMART2 support"
-	depends on PCI
+	depends on PCI && VIRT_TO_BUS
 	help
 	  This is the driver for Compaq Smart Array controllers.  Everyone
 	  using these boards should say Y here.  See the file
diff -puN drivers/message/i2o/Kconfig~introduce-config_virt_to_bus drivers/message/i2o/Kconfig
--- a/drivers/message/i2o/Kconfig~introduce-config_virt_to_bus
+++ a/drivers/message/i2o/Kconfig
@@ -54,6 +54,7 @@ config I2O_EXT_ADAPTEC_DMA64
 
 config I2O_CONFIG
 	tristate "I2O Configuration support"
+	depends on VIRT_TO_BUS
 	---help---
 	  Say Y for support of the configuration interface for the I2O adapters.
 	  If you have a RAID controller from Adaptec and you want to use the
diff -puN drivers/net/wan/Kconfig~introduce-config_virt_to_bus drivers/net/wan/Kconfig
--- a/drivers/net/wan/Kconfig~introduce-config_virt_to_bus
+++ a/drivers/net/wan/Kconfig
@@ -61,7 +61,7 @@ config COSA
 #
 config LANMEDIA
 	tristate "LanMedia Corp. SSI/V.35, T1/E1, HSSI, T3 boards"
-	depends on PCI
+	depends on PCI && VIRT_TO_BUS
 	---help---
 	  Driver for the following Lan Media family of serial boards:
 
diff -puN drivers/scsi/Kconfig~introduce-config_virt_to_bus drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~introduce-config_virt_to_bus
+++ a/drivers/scsi/Kconfig
@@ -545,7 +545,7 @@ config SCSI_HPTIOP
 
 config SCSI_BUSLOGIC
 	tristate "BusLogic SCSI support"
-	depends on (PCI || ISA || MCA) && SCSI && ISA_DMA_API
+	depends on (PCI || ISA || MCA) && SCSI && ISA_DMA_API && VIRT_TO_BUS
 	---help---
 	  This is support for BusLogic MultiMaster and FlashPoint SCSI Host
 	  Adapters. Consult the SCSI-HOWTO, available from
diff -puN mm/Kconfig~introduce-config_virt_to_bus mm/Kconfig
--- a/mm/Kconfig~introduce-config_virt_to_bus
+++ a/mm/Kconfig
@@ -168,3 +168,7 @@ config NR_QUICK
 	depends on QUICKLIST
 	default "2" if (SUPERH && !SUPERH64)
 	default "1"
+
+config VIRT_TO_BUS
+	def_bool y
+	depends on !ARCH_NO_VIRT_TO_BUS
diff -puN sound/oss/Kconfig~introduce-config_virt_to_bus sound/oss/Kconfig
--- a/sound/oss/Kconfig~introduce-config_virt_to_bus
+++ a/sound/oss/Kconfig
@@ -348,7 +348,7 @@ config MSND_FIFOSIZE
 
 config SOUND_VIA82CXXX
 	tristate "VIA 82C686 Audio Codec"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE
+	depends on SOUND_PRIME && PCI && OSS_OBSOLETE && VIRT_TO_BUS
 	help
 	  Say Y here to include support for the audio codec found on VIA
 	  82Cxxx-based chips. Typically these are built into a motherboard.
@@ -368,7 +368,7 @@ config MIDI_VIA82CXXX
 
 config SOUND_OSS
 	tristate "OSS sound modules"
-	depends on SOUND_PRIME && ISA_DMA_API
+	depends on SOUND_PRIME && ISA_DMA_API && VIRT_TO_BUS
 	help
 	  OSS is the Open Sound System suite of sound card drivers.  They make
 	  sound programming easier since they provide a common API.  Say Y or
@@ -417,6 +417,7 @@ config SOUND_CS4232
 config SOUND_SSCAPE
 	tristate "Ensoniq SoundScape support"
 	depends on SOUND_OSS
+	depends on VIRT_TO_BUS
 	help
 	  Answer Y if you have a sound card based on the Ensoniq SoundScape
 	  chipset. Such cards are being manufactured at least by Ensoniq, Spea
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
git-powerpc.patch
git-kbuild.patch
