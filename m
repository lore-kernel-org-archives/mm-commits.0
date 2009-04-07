From: akpm@linux-foundation.org
Subject: [merged] replace-all-dma_32bit_mask-macro-with-dma_bit_mask32.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:57 -0700
Message-ID: <200904071907.n37J7vdX011560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531AbZDGTJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:09:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanghy@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: replace all DMA_32BIT_MASK macro with DMA_BIT_MASK(32)
has been removed from the -mm tree.  Its filename was
     replace-all-dma_32bit_mask-macro-with-dma_bit_mask32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: replace all DMA_32BIT_MASK macro with DMA_BIT_MASK(32)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Replace all DMA_32BIT_MASK macro with DMA_BIT_MASK(32)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-davinci/board-evm.c             |    4 +-
 arch/arm/mach-davinci/usb.c                   |    4 +-
 arch/arm/mach-kirkwood/common.c               |    2 -
 arch/arm/mach-orion5x/common.c                |    2 -
 arch/arm/plat-iop/adma.c                      |    2 -
 arch/avr32/boards/hammerhead/flash.c          |    4 +-
 arch/avr32/mach-at32ap/at32ap700x.c           |    8 ++--
 arch/ia64/kernel/pci-dma.c                    |    2 -
 arch/mips/alchemy/common/platform.c           |   30 ++++++++--------
 arch/mips/alchemy/devboards/pb1200/platform.c |    4 +-
 arch/mips/nxp/pnx833x/common/platform.c       |   12 +++---
 arch/mips/nxp/pnx8550/common/platform.c       |    8 ++--
 arch/mips/pmc-sierra/msp71xx/msp_usb.c        |    8 ++--
 arch/powerpc/kernel/dma.c                     |    2 -
 arch/powerpc/kernel/of_platform.c             |    2 -
 arch/powerpc/platforms/iseries/iommu.c        |    4 +-
 arch/powerpc/platforms/ps3/system-bus.c       |    2 -
 arch/x86/include/asm/dma-mapping.h            |    4 +-
 arch/x86/kernel/pci-dma.c                     |    4 +-
 arch/x86/kernel/pci-nommu.c                   |    2 -
 drivers/ata/ahci.c                            |    6 +--
 drivers/ata/pata_cs5520.c                     |    4 +-
 drivers/ata/pata_ixp4xx_cf.c                  |    2 -
 drivers/ata/pdc_adma.c                        |    4 +-
 drivers/ata/sata_inic162x.c                   |    4 +-
 drivers/ata/sata_mv.c                         |    6 +--
 drivers/ata/sata_qstor.c                      |    6 +--
 drivers/ata/sata_sil24.c                      |    6 +--
 drivers/ata/sata_vsc.c                        |    4 +-
 drivers/atm/he.c                              |    2 -
 drivers/atm/lanai.c                           |    4 +-
 drivers/block/DAC960.c                        |    8 ++--
 drivers/block/cciss.c                         |    2 -
 drivers/block/sx8.c                           |    2 -
 drivers/block/umem.c                          |    2 -
 drivers/crypto/hifn_795x.c                    |    2 -
 drivers/crypto/ixp4xx_crypto.c                |    2 -
 drivers/dma/ioat.c                            |    4 +-
 drivers/firmware/dcdbas.c                     |    2 -
 drivers/ide/cs5520.c                          |    2 -
 drivers/ide/setup-pci.c                       |    2 -
 drivers/ieee1394/pcilynx.c                    |    2 -
 drivers/infiniband/hw/amso1100/c2.c           |    2 -
 drivers/infiniband/hw/ipath/ipath_driver.c    |    4 +-
 drivers/infiniband/hw/mthca/mthca_main.c      |    4 +-
 drivers/infiniband/hw/nes/nes.c               |    4 +-
 drivers/media/dvb/dm1105/dm1105.c             |    2 -
 drivers/media/dvb/pluto2/pluto2.c             |    2 -
 drivers/media/video/bt8xx/bttv-driver.c       |    2 -
 drivers/media/video/cx88/cx88-alsa.c          |    2 -
 drivers/media/video/cx88/cx88-mpeg.c          |    2 -
 drivers/media/video/cx88/cx88-video.c         |    2 -
 drivers/media/video/meye.c                    |    2 -
 drivers/media/video/saa7134/saa7134-core.c    |    2 -
 drivers/memstick/host/jmb38x_ms.c             |    2 -
 drivers/message/fusion/mptbase.c              |    4 +-
 drivers/message/i2o/memory.c                  |    2 -
 drivers/message/i2o/pci.c                     |    2 -
 drivers/misc/tifm_7xx1.c                      |    2 -
 drivers/mmc/host/sdhci-pci.c                  |    2 -
 drivers/net/8139cp.c                          |    6 +--
 drivers/net/acenic.c                          |    2 -
 drivers/net/amd8111e.c                        |    2 -
 drivers/net/atl1e/atl1e_main.c                |    4 +-
 drivers/net/atlx/atl1.c                       |    2 -
 drivers/net/atlx/atl2.c                       |    4 +-
 drivers/net/bnx2.c                            |    2 -
 drivers/net/bnx2x_main.c                      |    2 -
 drivers/net/cassini.c                         |    2 -
 drivers/net/chelsio/cxgb2.c                   |    2 -
 drivers/net/cxgb3/cxgb3_main.c                |    2 -
 drivers/net/e100.c                            |    2 -
 drivers/net/e1000/e1000_main.c                |    4 +-
 drivers/net/e1000e/netdev.c                   |    8 ++--
 drivers/net/enic/enic_main.c                  |    4 +-
 drivers/net/hp100.c                           |    2 -
 drivers/net/igb/igb_main.c                    |    4 +-
 drivers/net/ioc3-eth.c                        |    2 -
 drivers/net/ipg.c                             |    2 -
 drivers/net/ixgb/ixgb_main.c                  |    4 +-
 drivers/net/ixgbe/ixgbe_main.c                |    8 ++--
 drivers/net/jme.c                             |    4 +-
 drivers/net/mlx4/main.c                       |    4 +-
 drivers/net/myri10ge/myri10ge.c               |    4 +-
 drivers/net/niu.c                             |    4 +-
 drivers/net/ns83820.c                         |    2 -
 drivers/net/qla3xxx.c                         |    4 +-
 drivers/net/qlge/qlge_main.c                  |    4 +-
 drivers/net/r6040.c                           |    4 +-
 drivers/net/r8169.c                           |    8 ++--
 drivers/net/s2io.c                            |    2 -
 drivers/net/sc92031.c                         |    4 +-
 drivers/net/sis190.c                          |    2 -
 drivers/net/sis900.c                          |    2 -
 drivers/net/skge.c                            |    4 +-
 drivers/net/sky2.c                            |    2 -
 drivers/net/smsc9420.c                        |    2 -
 drivers/net/sungem.c                          |    2 -
 drivers/net/tehuti.c                          |    4 +-
 drivers/net/tehuti.h                          |    4 --
 drivers/net/tg3.c                             |   10 ++---
 drivers/net/tlan.c                            |    2 -
 drivers/net/tokenring/lanstreamer.c           |    2 -
 drivers/net/tulip/dmfe.c                      |    2 -
 drivers/net/tulip/uli526x.c                   |    2 -
 drivers/net/tulip/winbond-840.c               |    2 -
 drivers/net/typhoon.c                         |    2 -
 drivers/net/via-rhine.c                       |    2 -
 drivers/net/wan/wanxl.c                       |    4 +-
 drivers/net/wireless/adm8211.c                |    4 +-
 drivers/net/wireless/ath5k/base.c             |    2 -
 drivers/net/wireless/b43/dma.c                |    8 ++--
 drivers/net/wireless/b43legacy/dma.c          |    8 ++--
 drivers/net/wireless/ipw2x00/ipw2100.c        |    2 -
 drivers/net/wireless/ipw2x00/ipw2200.c        |    4 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |    4 +-
 drivers/net/wireless/prism54/islpci_hotplug.c |    2 -
 drivers/net/wireless/rt2x00/rt2x00pci.c       |    2 -
 drivers/pci/intel-iommu.c                     |    8 ++--
 drivers/rapidio/rio-scan.c                    |    4 +-
 drivers/scsi/3w-9xxx.c                        |    4 +-
 drivers/scsi/3w-xxxx.h                        |    2 -
 drivers/scsi/BusLogic.c                       |    6 +--
 drivers/scsi/a100u2w.c                        |    2 -
 drivers/scsi/aacraid/aachba.c                 |    4 +-
 drivers/scsi/aacraid/commsup.c                |    6 +--
 drivers/scsi/aacraid/linit.c                  |    6 +--
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c        |    6 +--
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c        |    4 +-
 drivers/scsi/aic94xx/aic94xx_init.c           |    4 +-
 drivers/scsi/arcmsr/arcmsr_hba.c              |    2 -
 drivers/scsi/atp870u.c                        |    2 -
 drivers/scsi/dpt_i2o.c                        |    6 +--
 drivers/scsi/eata.c                           |    2 -
 drivers/scsi/gdth.c                           |    4 +-
 drivers/scsi/hptiop.c                         |    2 -
 drivers/scsi/initio.c                         |    2 -
 drivers/scsi/ipr.c                            |    2 -
 drivers/scsi/ips.c                            |    2 -
 drivers/scsi/lasi700.c                        |    2 -
 drivers/scsi/lpfc/lpfc_init.c                 |    2 -
 drivers/scsi/megaraid.c                       |    4 +-
 drivers/scsi/megaraid/megaraid_mbox.c         |    4 +-
 drivers/scsi/megaraid/megaraid_sas.c          |    4 +-
 drivers/scsi/mvsas.c                          |    6 +--
 drivers/scsi/nsp32.c                          |    2 -
 drivers/scsi/qla1280.c                        |    4 +-
 drivers/scsi/qla2xxx/qla_os.c                 |    4 +-
 drivers/scsi/qla4xxx/ql4_os.c                 |    4 +-
 drivers/scsi/sni_53c710.c                     |    2 -
 drivers/scsi/stex.c                           |    4 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c           |    2 -
 drivers/scsi/sym53c8xx_2/sym_hipd.h           |    2 -
 drivers/staging/agnx/pci.c                    |    4 +-
 drivers/staging/altpciechdma/altpciechdma.c   |    4 +-
 drivers/staging/sxg/sxg.c                     |    4 +-
 drivers/usb/host/ehci-ps3.c                   |    2 -
 drivers/usb/host/ohci-ps3.c                   |    2 -
 drivers/uwb/whci.c                            |    4 +-
 include/linux/dma-mapping.h                   |    2 -
 lib/swiotlb.c                                 |    2 -
 sound/pci/ad1889.c                            |    4 +-
 sound/pci/au88x0/au88x0.c                     |    4 +-
 sound/pci/aw2/aw2-alsa.c                      |    4 +-
 sound/pci/ca0106/ca0106_main.c                |    4 +-
 sound/pci/cs5535audio/cs5535audio.c           |    4 +-
 sound/pci/mixart/mixart.c                     |    2 -
 sound/pci/pcxhr/pcxhr.c                       |    2 -
 sound/soc/blackfin/bf5xx-ac97-pcm.c           |    4 +-
 sound/soc/blackfin/bf5xx-i2s-pcm.c            |    4 +-
 sound/soc/omap/omap-pcm.c                     |    2 -
 sound/soc/pxa/pxa2xx-pcm.c                    |    4 +-
 sound/soc/s3c24xx/s3c24xx-pcm.c               |    2 -
 173 files changed, 309 insertions(+), 313 deletions(-)

diff -puN arch/arm/mach-davinci/board-evm.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/arm/mach-davinci/board-evm.c
--- a/arch/arm/mach-davinci/board-evm.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/arm/mach-davinci/board-evm.c
@@ -118,7 +118,7 @@ static struct resource ide_resources[] =
 	},
 };
 
-static u64 ide_dma_mask = DMA_32BIT_MASK;
+static u64 ide_dma_mask = DMA_BIT_MASK(32);
 
 static struct platform_device ide_dev = {
 	.name           = "palm_bk3710",
@@ -127,7 +127,7 @@ static struct platform_device ide_dev = 
 	.num_resources  = ARRAY_SIZE(ide_resources),
 	.dev = {
 		.dma_mask		= &ide_dma_mask,
-		.coherent_dma_mask      = DMA_32BIT_MASK,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
 	},
 };
 
diff -puN arch/arm/mach-davinci/usb.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/arm/mach-davinci/usb.c
--- a/arch/arm/mach-davinci/usb.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/arm/mach-davinci/usb.c
@@ -64,7 +64,7 @@ static struct resource usb_resources[] =
 	},
 };
 
-static u64 usb_dmamask = DMA_32BIT_MASK;
+static u64 usb_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device usb_dev = {
 	.name           = "musb_hdrc",
@@ -72,7 +72,7 @@ static struct platform_device usb_dev = 
 	.dev = {
 		.platform_data		= &usb_data,
 		.dma_mask		= &usb_dmamask,
-		.coherent_dma_mask      = DMA_32BIT_MASK,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
 	},
 	.resource       = usb_resources,
 	.num_resources  = ARRAY_SIZE(usb_resources),
diff -puN arch/arm/mach-kirkwood/common.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/arm/mach-kirkwood/common.c
--- a/arch/arm/mach-kirkwood/common.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/arm/mach-kirkwood/common.c
@@ -508,7 +508,7 @@ static struct mv_xor_platform_shared_dat
 	.dram		= &kirkwood_mbus_dram_info,
 };
 
-static u64 kirkwood_xor_dmamask = DMA_32BIT_MASK;
+static u64 kirkwood_xor_dmamask = DMA_BIT_MASK(32);
 
 
 /*****************************************************************************
diff -puN arch/arm/mach-orion5x/common.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/arm/mach-orion5x/common.c
--- a/arch/arm/mach-orion5x/common.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/arm/mach-orion5x/common.c
@@ -463,7 +463,7 @@ static struct platform_device orion5x_xo
 	.resource	= orion5x_xor_shared_resources,
 };
 
-static u64 orion5x_xor_dmamask = DMA_32BIT_MASK;
+static u64 orion5x_xor_dmamask = DMA_BIT_MASK(32);
 
 static struct resource orion5x_xor0_resources[] = {
 	[0] = {
diff -puN arch/arm/plat-iop/adma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/arm/plat-iop/adma.c
--- a/arch/arm/plat-iop/adma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/arm/plat-iop/adma.c
@@ -119,7 +119,7 @@ static struct resource iop3xx_aau_resour
 	}
 };
 
-static u64 iop3xx_adma_dmamask = DMA_32BIT_MASK;
+static u64 iop3xx_adma_dmamask = DMA_BIT_MASK(32);
 
 static struct iop_adma_platform_data iop3xx_dma_0_data = {
 	.hw_id = DMA0_ID,
diff -puN arch/avr32/boards/hammerhead/flash.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/avr32/boards/hammerhead/flash.c
--- a/arch/avr32/boards/hammerhead/flash.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/avr32/boards/hammerhead/flash.c
@@ -280,13 +280,13 @@ static struct resource hh_fpga0_resource
 	},
 };
 
-static u64 hh_fpga0_dma_mask = DMA_32BIT_MASK;
+static u64 hh_fpga0_dma_mask = DMA_BIT_MASK(32);
 static struct platform_device hh_fpga0_device = {
 	.name		= "hh_fpga",
 	.id		= 0,
 	.dev		= {
 		.dma_mask = &hh_fpga0_dma_mask,
-		.coherent_dma_mask = DMA_32BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 	.resource	= hh_fpga0_resource,
 	.num_resources	= ARRAY_SIZE(hh_fpga0_resource),
diff -puN arch/avr32/mach-at32ap/at32ap700x.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/avr32/mach-at32ap/at32ap700x.c
--- a/arch/avr32/mach-at32ap/at32ap700x.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/avr32/mach-at32ap/at32ap700x.c
@@ -60,26 +60,26 @@
  * don't ... tc, smc, pio, rtc, watchdog, pwm, ps2, and more.
  */
 #define DEFINE_DEV(_name, _id)					\
-static u64 _name##_id##_dma_mask = DMA_32BIT_MASK;		\
+static u64 _name##_id##_dma_mask = DMA_BIT_MASK(32);		\
 static struct platform_device _name##_id##_device = {		\
 	.name		= #_name,				\
 	.id		= _id,					\
 	.dev		= {					\
 		.dma_mask = &_name##_id##_dma_mask,		\
-		.coherent_dma_mask = DMA_32BIT_MASK,		\
+		.coherent_dma_mask = DMA_BIT_MASK(32),		\
 	},							\
 	.resource	= _name##_id##_resource,		\
 	.num_resources	= ARRAY_SIZE(_name##_id##_resource),	\
 }
 #define DEFINE_DEV_DATA(_name, _id)				\
-static u64 _name##_id##_dma_mask = DMA_32BIT_MASK;		\
+static u64 _name##_id##_dma_mask = DMA_BIT_MASK(32);		\
 static struct platform_device _name##_id##_device = {		\
 	.name		= #_name,				\
 	.id		= _id,					\
 	.dev		= {					\
 		.dma_mask = &_name##_id##_dma_mask,		\
 		.platform_data	= &_name##_id##_data,		\
-		.coherent_dma_mask = DMA_32BIT_MASK,		\
+		.coherent_dma_mask = DMA_BIT_MASK(32),		\
 	},							\
 	.resource	= _name##_id##_resource,		\
 	.num_resources	= ARRAY_SIZE(_name##_id##_resource),	\
diff -puN arch/ia64/kernel/pci-dma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/ia64/kernel/pci-dma.c
--- a/arch/ia64/kernel/pci-dma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/ia64/kernel/pci-dma.c
@@ -37,7 +37,7 @@ int force_iommu __read_mostly;
    to i386. */
 struct device fallback_dev = {
 	.init_name = "fallback device",
-	.coherent_dma_mask = DMA_32BIT_MASK,
+	.coherent_dma_mask = DMA_BIT_MASK(32),
 	.dma_mask = &fallback_dev.coherent_dma_mask,
 };
 
diff -puN arch/mips/alchemy/common/platform.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/mips/alchemy/common/platform.c
--- a/arch/mips/alchemy/common/platform.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/mips/alchemy/common/platform.c
@@ -80,14 +80,14 @@ static struct resource au1xxx_usb_ohci_r
 };
 
 /* The dmamask must be set for OHCI to work */
-static u64 ohci_dmamask = DMA_32BIT_MASK;
+static u64 ohci_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device au1xxx_usb_ohci_device = {
 	.name		= "au1xxx-ohci",
 	.id		= 0,
 	.dev = {
 		.dma_mask		= &ohci_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(au1xxx_usb_ohci_resources),
 	.resource	= au1xxx_usb_ohci_resources,
@@ -109,14 +109,14 @@ static struct resource au1100_lcd_resour
 	}
 };
 
-static u64 au1100_lcd_dmamask = DMA_32BIT_MASK;
+static u64 au1100_lcd_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device au1100_lcd_device = {
 	.name           = "au1100-lcd",
 	.id             = 0,
 	.dev = {
 		.dma_mask               = &au1100_lcd_dmamask,
-		.coherent_dma_mask      = DMA_32BIT_MASK,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
 	},
 	.num_resources  = ARRAY_SIZE(au1100_lcd_resources),
 	.resource       = au1100_lcd_resources,
@@ -138,14 +138,14 @@ static struct resource au1xxx_usb_ehci_r
 	},
 };
 
-static u64 ehci_dmamask = DMA_32BIT_MASK;
+static u64 ehci_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device au1xxx_usb_ehci_device = {
 	.name		= "au1xxx-ehci",
 	.id		= 0,
 	.dev = {
 		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(au1xxx_usb_ehci_resources),
 	.resource	= au1xxx_usb_ehci_resources,
@@ -165,14 +165,14 @@ static struct resource au1xxx_usb_gdt_re
 	},
 };
 
-static u64 udc_dmamask = DMA_32BIT_MASK;
+static u64 udc_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device au1xxx_usb_gdt_device = {
 	.name		= "au1xxx-udc",
 	.id		= 0,
 	.dev = {
 		.dma_mask		= &udc_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(au1xxx_usb_gdt_resources),
 	.resource	= au1xxx_usb_gdt_resources,
@@ -192,14 +192,14 @@ static struct resource au1xxx_usb_otg_re
 	},
 };
 
-static u64 uoc_dmamask = DMA_32BIT_MASK;
+static u64 uoc_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device au1xxx_usb_otg_device = {
 	.name		= "au1xxx-uoc",
 	.id		= 0,
 	.dev = {
 		.dma_mask		= &uoc_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(au1xxx_usb_otg_resources),
 	.resource	= au1xxx_usb_otg_resources,
@@ -218,20 +218,20 @@ static struct resource au1200_lcd_resour
 	}
 };
 
-static u64 au1200_lcd_dmamask = DMA_32BIT_MASK;
+static u64 au1200_lcd_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device au1200_lcd_device = {
 	.name           = "au1200-lcd",
 	.id             = 0,
 	.dev = {
 		.dma_mask               = &au1200_lcd_dmamask,
-		.coherent_dma_mask      = DMA_32BIT_MASK,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
 	},
 	.num_resources  = ARRAY_SIZE(au1200_lcd_resources),
 	.resource       = au1200_lcd_resources,
 };
 
-static u64 au1xxx_mmc_dmamask =  DMA_32BIT_MASK;
+static u64 au1xxx_mmc_dmamask =  DMA_BIT_MASK(32);
 
 extern struct au1xmmc_platform_data au1xmmc_platdata[2];
 
@@ -263,7 +263,7 @@ static struct platform_device au1200_mmc
 	.id = 0,
 	.dev = {
 		.dma_mask		= &au1xxx_mmc_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= &au1xmmc_platdata[0],
 	},
 	.num_resources	= ARRAY_SIZE(au1200_mmc0_resources),
@@ -299,7 +299,7 @@ static struct platform_device au1200_mmc
 	.id = 1,
 	.dev = {
 		.dma_mask		= &au1xxx_mmc_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= &au1xmmc_platdata[1],
 	},
 	.num_resources	= ARRAY_SIZE(au1200_mmc1_resources),
diff -puN arch/mips/alchemy/devboards/pb1200/platform.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/mips/alchemy/devboards/pb1200/platform.c
--- a/arch/mips/alchemy/devboards/pb1200/platform.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/mips/alchemy/devboards/pb1200/platform.c
@@ -119,14 +119,14 @@ static struct resource ide_resources[] =
 	}
 };
 
-static u64 ide_dmamask = DMA_32BIT_MASK;
+static u64 ide_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device ide_device = {
 	.name		= "au1200-ide",
 	.id		= 0,
 	.dev = {
 		.dma_mask 		= &ide_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(ide_resources),
 	.resource	= ide_resources
diff -puN arch/mips/nxp/pnx833x/common/platform.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/mips/nxp/pnx833x/common/platform.c
--- a/arch/mips/nxp/pnx833x/common/platform.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/mips/nxp/pnx833x/common/platform.c
@@ -42,7 +42,7 @@
 #include <irq-mapping.h>
 #include <pnx833x.h>
 
-static u64 uart_dmamask     = DMA_32BIT_MASK;
+static u64 uart_dmamask     = DMA_BIT_MASK(32);
 
 static struct resource pnx833x_uart_resources[] = {
 	[0] = {
@@ -101,14 +101,14 @@ static struct platform_device pnx833x_ua
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &uart_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= pnx8xxx_ports,
 	},
 	.num_resources	= ARRAY_SIZE(pnx833x_uart_resources),
 	.resource	= pnx833x_uart_resources,
 };
 
-static u64 ehci_dmamask     = DMA_32BIT_MASK;
+static u64 ehci_dmamask     = DMA_BIT_MASK(32);
 
 static struct resource pnx833x_usb_ehci_resources[] = {
 	[0] = {
@@ -128,7 +128,7 @@ static struct platform_device pnx833x_us
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(pnx833x_usb_ehci_resources),
 	.resource	= pnx833x_usb_ehci_resources,
@@ -198,7 +198,7 @@ static struct platform_device pnx833x_i2
 };
 #endif
 
-static u64 ethernet_dmamask = DMA_32BIT_MASK;
+static u64 ethernet_dmamask = DMA_BIT_MASK(32);
 
 static struct resource pnx833x_ethernet_resources[] = {
 	[0] = {
@@ -218,7 +218,7 @@ static struct platform_device pnx833x_et
 	.id   = -1,
 	.dev  = {
 		.dma_mask          = &ethernet_dmamask,
-		.coherent_dma_mask = DMA_32BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 	.num_resources = ARRAY_SIZE(pnx833x_ethernet_resources),
 	.resource      = pnx833x_ethernet_resources,
diff -puN arch/mips/nxp/pnx8550/common/platform.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/mips/nxp/pnx8550/common/platform.c
--- a/arch/mips/nxp/pnx8550/common/platform.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/mips/nxp/pnx8550/common/platform.c
@@ -92,16 +92,16 @@ struct pnx8xxx_port pnx8xxx_ports[] = {
 };
 
 /* The dmamask must be set for OHCI to work */
-static u64 ohci_dmamask = DMA_32BIT_MASK;
+static u64 ohci_dmamask = DMA_BIT_MASK(32);
 
-static u64 uart_dmamask = DMA_32BIT_MASK;
+static u64 uart_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device pnx8550_usb_ohci_device = {
 	.name		= "pnx8550-ohci",
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &ohci_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(pnx8550_usb_ohci_resources),
 	.resource	= pnx8550_usb_ohci_resources,
@@ -112,7 +112,7 @@ static struct platform_device pnx8550_ua
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &uart_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data = pnx8xxx_ports,
 	},
 	.num_resources	= ARRAY_SIZE(pnx8550_uart_resources),
diff -puN arch/mips/pmc-sierra/msp71xx/msp_usb.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/mips/pmc-sierra/msp71xx/msp_usb.c
--- a/arch/mips/pmc-sierra/msp71xx/msp_usb.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/mips/pmc-sierra/msp71xx/msp_usb.c
@@ -49,14 +49,14 @@ static struct resource msp_usbhost_resou
 	},
 };
 
-static u64 msp_usbhost_dma_mask = DMA_32BIT_MASK;
+static u64 msp_usbhost_dma_mask = DMA_BIT_MASK(32);
 
 static struct platform_device msp_usbhost_device = {
 	.name	= "pmcmsp-ehci",
 	.id	= 0,
 	.dev	= {
 		.dma_mask = &msp_usbhost_dma_mask,
-		.coherent_dma_mask = DMA_32BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 	.num_resources 	= ARRAY_SIZE(msp_usbhost_resources),
 	.resource	= msp_usbhost_resources,
@@ -77,14 +77,14 @@ static struct resource msp_usbdev_resour
 	},
 };
 
-static u64 msp_usbdev_dma_mask = DMA_32BIT_MASK;
+static u64 msp_usbdev_dma_mask = DMA_BIT_MASK(32);
 
 static struct platform_device msp_usbdev_device = {
 	.name	= "msp71xx_udc",
 	.id	= 0,
 	.dev	= {
 		.dma_mask = &msp_usbdev_dma_mask,
-		.coherent_dma_mask = DMA_32BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(msp_usbdev_resources),
 	.resource	= msp_usbdev_resources,
diff -puN arch/powerpc/kernel/dma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/powerpc/kernel/dma.c
--- a/arch/powerpc/kernel/dma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/powerpc/kernel/dma.c
@@ -94,7 +94,7 @@ static int dma_direct_dma_supported(stru
 	 * done via some global so platforms can set the limit in case
 	 * they have limited DMA windows
 	 */
-	return mask >= DMA_32BIT_MASK;
+	return mask >= DMA_BIT_MASK(32);
 #else
 	return 1;
 #endif
diff -puN arch/powerpc/kernel/of_platform.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/powerpc/kernel/of_platform.c
--- a/arch/powerpc/kernel/of_platform.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/powerpc/kernel/of_platform.c
@@ -76,7 +76,7 @@ struct of_device* of_platform_device_cre
 		return NULL;
 
 	dev->dma_mask = 0xffffffffUL;
-	dev->dev.coherent_dma_mask = DMA_32BIT_MASK;
+	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 
 	dev->dev.bus = &of_platform_bus_type;
 
diff -puN arch/powerpc/platforms/iseries/iommu.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/powerpc/platforms/iseries/iommu.c
--- a/arch/powerpc/platforms/iseries/iommu.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/powerpc/platforms/iseries/iommu.c
@@ -202,7 +202,7 @@ static struct iommu_table vio_iommu_tabl
 void *iseries_hv_alloc(size_t size, dma_addr_t *dma_handle, gfp_t flag)
 {
 	return iommu_alloc_coherent(NULL, &vio_iommu_table, size, dma_handle,
-				DMA_32BIT_MASK, flag, -1);
+				DMA_BIT_MASK(32), flag, -1);
 }
 EXPORT_SYMBOL_GPL(iseries_hv_alloc);
 
@@ -217,7 +217,7 @@ dma_addr_t iseries_hv_map(void *vaddr, s
 {
 	return iommu_map_page(NULL, &vio_iommu_table, virt_to_page(vaddr),
 			      (unsigned long)vaddr % PAGE_SIZE, size,
-			      DMA_32BIT_MASK, direction, NULL);
+			      DMA_BIT_MASK(32), direction, NULL);
 }
 
 void iseries_hv_unmap(dma_addr_t dma_handle, size_t size,
diff -puN arch/powerpc/platforms/ps3/system-bus.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/powerpc/platforms/ps3/system-bus.c
--- a/arch/powerpc/platforms/ps3/system-bus.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/powerpc/platforms/ps3/system-bus.c
@@ -689,7 +689,7 @@ static void ps3_ioc0_unmap_sg(struct dev
 
 static int ps3_dma_supported(struct device *_dev, u64 mask)
 {
-	return mask >= DMA_32BIT_MASK;
+	return mask >= DMA_BIT_MASK(32);
 }
 
 static struct dma_mapping_ops ps3_sb_dma_ops = {
diff -puN arch/x86/include/asm/dma-mapping.h~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -238,7 +238,7 @@ static inline unsigned long dma_alloc_co
 
 	dma_mask = dev->coherent_dma_mask;
 	if (!dma_mask)
-		dma_mask = (gfp & GFP_DMA) ? DMA_24BIT_MASK : DMA_32BIT_MASK;
+		dma_mask = (gfp & GFP_DMA) ? DMA_24BIT_MASK : DMA_BIT_MASK(32);
 
 	return dma_mask;
 }
@@ -250,7 +250,7 @@ static inline gfp_t dma_alloc_coherent_g
 	if (dma_mask <= DMA_24BIT_MASK)
 		gfp |= GFP_DMA;
 #ifdef CONFIG_X86_64
-	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
+	if (dma_mask <= DMA_BIT_MASK(32) && !(gfp & GFP_DMA))
 		gfp |= GFP_DMA32;
 #endif
        return gfp;
diff -puN arch/x86/kernel/pci-dma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/x86/kernel/pci-dma.c
@@ -40,7 +40,7 @@ EXPORT_SYMBOL(bad_dma_address);
    to older i386. */
 struct device x86_dma_fallback_dev = {
 	.init_name = "fallback device",
-	.coherent_dma_mask = DMA_32BIT_MASK,
+	.coherent_dma_mask = DMA_BIT_MASK(32),
 	.dma_mask = &x86_dma_fallback_dev.coherent_dma_mask,
 };
 EXPORT_SYMBOL(x86_dma_fallback_dev);
@@ -148,7 +148,7 @@ again:
 	if (!is_buffer_dma_capable(dma_mask, addr, size)) {
 		__free_pages(page, get_order(size));
 
-		if (dma_mask < DMA_32BIT_MASK && !(flag & GFP_DMA)) {
+		if (dma_mask < DMA_BIT_MASK(32) && !(flag & GFP_DMA)) {
 			flag = (flag & ~GFP_DMA32) | GFP_DMA;
 			goto again;
 		}
diff -puN arch/x86/kernel/pci-nommu.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 arch/x86/kernel/pci-nommu.c
--- a/arch/x86/kernel/pci-nommu.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/arch/x86/kernel/pci-nommu.c
@@ -15,7 +15,7 @@ static int
 check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 {
 	if (hwdev && !is_buffer_dma_capable(*hwdev->dma_mask, bus, size)) {
-		if (*hwdev->dma_mask >= DMA_32BIT_MASK)
+		if (*hwdev->dma_mask >= DMA_BIT_MASK(32))
 			printk(KERN_ERR
 			    "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
 				name, (long long)bus, size,
diff -puN drivers/ata/ahci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/ata/ahci.c
@@ -2408,7 +2408,7 @@ static int ahci_configure_dma_masks(stru
 	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (rc) {
-			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (rc) {
 				dev_printk(KERN_ERR, &pdev->dev,
 					   "64-bit DMA enable failed\n");
@@ -2416,13 +2416,13 @@ static int ahci_configure_dma_masks(stru
 			}
 		}
 	} else {
-		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_printk(KERN_ERR, &pdev->dev,
 				   "32-bit DMA enable failed\n");
 			return rc;
 		}
-		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_printk(KERN_ERR, &pdev->dev,
 				   "32-bit consistent DMA enable failed\n");
diff -puN drivers/ata/pata_cs5520.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/ata/pata_cs5520.c
--- a/drivers/ata/pata_cs5520.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/ata/pata_cs5520.c
@@ -203,11 +203,11 @@ static int __devinit cs5520_init_one(str
 		return -ENODEV;
 	}
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_ERR DRV_NAME ": unable to configure DMA mask.\n");
 		return -ENODEV;
 	}
-	if (pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_ERR DRV_NAME ": unable to configure consistent DMA mask.\n");
 		return -ENODEV;
 	}
diff -puN drivers/ata/pata_ixp4xx_cf.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/ata/pata_ixp4xx_cf.c
--- a/drivers/ata/pata_ixp4xx_cf.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/ata/pata_ixp4xx_cf.c
@@ -157,7 +157,7 @@ static __devinit int ixp4xx_pata_probe(s
 		return -ENOMEM;
 
 	/* acquire resources and fill host */
-	pdev->dev.coherent_dma_mask = DMA_32BIT_MASK;
+	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 
 	data->cs0 = devm_ioremap(&pdev->dev, cs0->start, 0x1000);
 	data->cs1 = devm_ioremap(&pdev->dev, cs1->start, 0x1000);
diff -puN drivers/ata/pdc_adma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/ata/pdc_adma.c
--- a/drivers/ata/pdc_adma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/ata/pdc_adma.c
@@ -607,13 +607,13 @@ static int adma_set_dma_masks(struct pci
 {
 	int rc;
 
-	rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc) {
 		dev_printk(KERN_ERR, &pdev->dev,
 			"32-bit DMA enable failed\n");
 		return rc;
 	}
-	rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc) {
 		dev_printk(KERN_ERR, &pdev->dev,
 			"32-bit consistent DMA enable failed\n");
diff -puN drivers/ata/sata_inic162x.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/ata/sata_inic162x.c
--- a/drivers/ata/sata_inic162x.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/ata/sata_inic162x.c
@@ -861,14 +861,14 @@ static int inic_init_one(struct pci_dev 
 	}
 
 	/* Set dma_mask.  This devices doesn't support 64bit addressing. */
-	rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc) {
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "32-bit DMA enable failed\n");
 		return rc;
 	}
 
-	rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc) {
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "32-bit consistent DMA enable failed\n");
diff -puN drivers/ata/sata_mv.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/ata/sata_mv.c
@@ -3916,7 +3916,7 @@ static int pci_go_64(struct pci_dev *pde
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (rc) {
-			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (rc) {
 				dev_printk(KERN_ERR, &pdev->dev,
 					   "64-bit DMA enable failed\n");
@@ -3924,13 +3924,13 @@ static int pci_go_64(struct pci_dev *pde
 			}
 		}
 	} else {
-		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_printk(KERN_ERR, &pdev->dev,
 				   "32-bit DMA enable failed\n");
 			return rc;
 		}
-		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_printk(KERN_ERR, &pdev->dev,
 				   "32-bit consistent DMA enable failed\n");
diff -puN drivers/ata/sata_qstor.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/ata/sata_qstor.c
--- a/drivers/ata/sata_qstor.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/ata/sata_qstor.c
@@ -587,7 +587,7 @@ static int qs_set_dma_masks(struct pci_d
 	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (rc) {
-			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (rc) {
 				dev_printk(KERN_ERR, &pdev->dev,
 					   "64-bit DMA enable failed\n");
@@ -595,13 +595,13 @@ static int qs_set_dma_masks(struct pci_d
 			}
 		}
 	} else {
-		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_printk(KERN_ERR, &pdev->dev,
 				"32-bit DMA enable failed\n");
 			return rc;
 		}
-		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_printk(KERN_ERR, &pdev->dev,
 				"32-bit consistent DMA enable failed\n");
diff -puN drivers/ata/sata_sil24.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/ata/sata_sil24.c
--- a/drivers/ata/sata_sil24.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/ata/sata_sil24.c
@@ -1300,7 +1300,7 @@ static int sil24_init_one(struct pci_dev
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (rc) {
-			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (rc) {
 				dev_printk(KERN_ERR, &pdev->dev,
 					   "64-bit DMA enable failed\n");
@@ -1308,13 +1308,13 @@ static int sil24_init_one(struct pci_dev
 			}
 		}
 	} else {
-		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_printk(KERN_ERR, &pdev->dev,
 				   "32-bit DMA enable failed\n");
 			return rc;
 		}
-		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_printk(KERN_ERR, &pdev->dev,
 				   "32-bit consistent DMA enable failed\n");
diff -puN drivers/ata/sata_vsc.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/ata/sata_vsc.c
--- a/drivers/ata/sata_vsc.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/ata/sata_vsc.c
@@ -399,10 +399,10 @@ static int __devinit vsc_sata_init_one(s
 	/*
 	 * Use 32 bit DMA mask, because 64 bit address support is poor.
 	 */
-	rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc)
 		return rc;
-	rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc)
 		return rc;
 
diff -puN drivers/atm/he.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/atm/he.c
--- a/drivers/atm/he.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/atm/he.c
@@ -358,7 +358,7 @@ he_init_one(struct pci_dev *pci_dev, con
 
 	if (pci_enable_device(pci_dev))
 		return -EIO;
-	if (pci_set_dma_mask(pci_dev, DMA_32BIT_MASK) != 0) {
+	if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32)) != 0) {
 		printk(KERN_WARNING "he: no suitable dma available\n");
 		err = -EIO;
 		goto init_one_failure;
diff -puN drivers/atm/lanai.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/atm/lanai.c
--- a/drivers/atm/lanai.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/atm/lanai.c
@@ -1957,12 +1957,12 @@ static int __devinit lanai_pci_start(str
 		return -ENXIO;
 	}
 	pci_set_master(pci);
-	if (pci_set_dma_mask(pci, DMA_32BIT_MASK) != 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(32)) != 0) {
 		printk(KERN_WARNING DEV_LABEL
 		    "(itf %d): No suitable DMA available.\n", lanai->number);
 		return -EBUSY;
 	}
-	if (pci_set_consistent_dma_mask(pci, DMA_32BIT_MASK) != 0) {
+	if (pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32)) != 0) {
 		printk(KERN_WARNING DEV_LABEL
 		    "(itf %d): No suitable DMA available.\n", lanai->number);
 		return -EBUSY;
diff -puN drivers/block/DAC960.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/block/DAC960.c
@@ -1169,9 +1169,9 @@ static bool DAC960_V1_EnableMemoryMailbo
   int i;
 
   
-  if (pci_set_dma_mask(Controller->PCIDevice, DMA_32BIT_MASK))
+  if (pci_set_dma_mask(Controller->PCIDevice, DMA_BIT_MASK(32)))
 	return DAC960_Failure(Controller, "DMA mask out of range");
-  Controller->BounceBufferLimit = DMA_32BIT_MASK;
+  Controller->BounceBufferLimit = DMA_BIT_MASK(32);
 
   if ((hw_type == DAC960_PD_Controller) || (hw_type == DAC960_P_Controller)) {
     CommandMailboxesSize =  0;
@@ -1374,8 +1374,8 @@ static bool DAC960_V2_EnableMemoryMailbo
 
 	if (!pci_set_dma_mask(Controller->PCIDevice, DMA_BIT_MASK(64)))
 		Controller->BounceBufferLimit = DMA_BIT_MASK(64);
-	else if (!pci_set_dma_mask(Controller->PCIDevice, DMA_32BIT_MASK))
-		Controller->BounceBufferLimit = DMA_32BIT_MASK;
+	else if (!pci_set_dma_mask(Controller->PCIDevice, DMA_BIT_MASK(32)))
+		Controller->BounceBufferLimit = DMA_BIT_MASK(32);
 	else
 		return DAC960_Failure(Controller, "DMA mask out of range");
 
diff -puN drivers/block/cciss.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/block/cciss.c
--- a/drivers/block/cciss.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/block/cciss.c
@@ -3639,7 +3639,7 @@ static int __devinit cciss_init_one(stru
 	/* configure PCI DMA stuff */
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))
 		dac = 1;
-	else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK))
+	else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
 		dac = 0;
 	else {
 		printk(KERN_ERR "cciss: no suitable DMA available\n");
diff -puN drivers/block/sx8.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/block/sx8.c
--- a/drivers/block/sx8.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/block/sx8.c
@@ -1597,7 +1597,7 @@ static int carm_init_one (struct pci_dev
 		pci_dac = 1;
 	} else {
 #endif
-		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			printk(KERN_ERR DRV_NAME "(%s): DMA mask failure\n",
 				pci_name(pdev));
diff -puN drivers/block/umem.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/block/umem.c
--- a/drivers/block/umem.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/block/umem.c
@@ -830,7 +830,7 @@ static int __devinit mm_pci_probe(struct
 	  "Micro Memory(tm) controller found (PCI Mem Module (Battery Backup))\n");
 
 	if (pci_set_dma_mask(dev, DMA_BIT_MASK(64)) &&
-	    pci_set_dma_mask(dev, DMA_32BIT_MASK)) {
+	    pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
 		dev_printk(KERN_WARNING, &dev->dev, "NO suitable DMA found\n");
 		return  -ENOMEM;
 	}
diff -puN drivers/crypto/hifn_795x.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/crypto/hifn_795x.c
--- a/drivers/crypto/hifn_795x.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/crypto/hifn_795x.c
@@ -2575,7 +2575,7 @@ static int hifn_probe(struct pci_dev *pd
 		return err;
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err)
 		goto err_out_disable_pci_device;
 
diff -puN drivers/crypto/ixp4xx_crypto.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/crypto/ixp4xx_crypto.c
--- a/drivers/crypto/ixp4xx_crypto.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/crypto/ixp4xx_crypto.c
@@ -209,7 +209,7 @@ static struct platform_device pseudo_dev
 	.id   = 0,
 	.num_resources = 0,
 	.dev  = {
-		.coherent_dma_mask = DMA_32BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.release = dev_release,
 	}
 };
diff -puN drivers/dma/ioat.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/dma/ioat.c
--- a/drivers/dma/ioat.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/dma/ioat.c
@@ -100,13 +100,13 @@ static int __devinit ioat_probe(struct p
 
 	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (err)
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err)
 		goto err_set_dma_mask;
 
 	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err)
 		goto err_set_dma_mask;
 
diff -puN drivers/firmware/dcdbas.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/firmware/dcdbas.c
--- a/drivers/firmware/dcdbas.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/firmware/dcdbas.c
@@ -545,7 +545,7 @@ static int __devinit dcdbas_probe(struct
 	 * BIOS SMI calls require buffer addresses be in 32-bit address space.
 	 * This is done by setting the DMA mask below.
 	 */
-	dcdbas_pdev->dev.coherent_dma_mask = DMA_32BIT_MASK;
+	dcdbas_pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	dcdbas_pdev->dev.dma_mask = &dcdbas_pdev->dev.coherent_dma_mask;
 
 	error = sysfs_create_group(&dev->dev.kobj, &dcdbas_attr_group);
diff -puN drivers/ide/cs5520.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/ide/cs5520.c
--- a/drivers/ide/cs5520.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/ide/cs5520.c
@@ -122,7 +122,7 @@ static int __devinit cs5520_init_one(str
 		return -ENODEV;
 	}
 	pci_set_master(dev);
-	if (pci_set_dma_mask(dev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
 		printk(KERN_WARNING "%s: No suitable DMA available.\n",
 			d->name);
 		return -ENODEV;
diff -puN drivers/ide/setup-pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/ide/setup-pci.c
--- a/drivers/ide/setup-pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/ide/setup-pci.c
@@ -208,7 +208,7 @@ static int ide_pci_enable(struct pci_dev
 	 * a DMA mask field to the struct ide_port_info if we need it
 	 * (or let lower level driver set the DMA mask)
 	 */
-	ret = pci_set_dma_mask(dev, DMA_32BIT_MASK);
+	ret = pci_set_dma_mask(dev, DMA_BIT_MASK(32));
 	if (ret < 0) {
 		printk(KERN_ERR "%s %s: can't set DMA mask\n",
 			d->name, pci_name(dev));
diff -puN drivers/ieee1394/pcilynx.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/ieee1394/pcilynx.c
--- a/drivers/ieee1394/pcilynx.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/ieee1394/pcilynx.c
@@ -1171,7 +1171,7 @@ static int __devinit add_card(struct pci
 
         error = -ENXIO;
 
-        if (pci_set_dma_mask(dev, DMA_32BIT_MASK))
+        if (pci_set_dma_mask(dev, DMA_BIT_MASK(32)))
                 FAIL("DMA address limits not supported for PCILynx hardware");
         if (pci_enable_device(dev))
                 FAIL("failed to enable PCILynx hardware");
diff -puN drivers/infiniband/hw/amso1100/c2.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/infiniband/hw/amso1100/c2.c
--- a/drivers/infiniband/hw/amso1100/c2.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/infiniband/hw/amso1100/c2.c
@@ -995,7 +995,7 @@ static int __devinit c2_probe(struct pci
 			goto bail2;
 		}
 	} else {
-		ret = pci_set_dma_mask(pcidev, DMA_32BIT_MASK);
+		ret = pci_set_dma_mask(pcidev, DMA_BIT_MASK(32));
 		if (ret < 0) {
 			printk(KERN_ERR PFX "32b DMA configuration failed\n");
 			goto bail2;
diff -puN drivers/infiniband/hw/ipath/ipath_driver.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -477,7 +477,7 @@ static int __devinit ipath_init_one(stru
 		 * do not setup 64 bit maps on systems with 2GB or less
 		 * memory installed.
 		 */
-		ret = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (ret) {
 			dev_info(&pdev->dev,
 				"Unable to set DMA mask for unit %u: %d\n",
@@ -486,7 +486,7 @@ static int __devinit ipath_init_one(stru
 		}
 		else {
 			ipath_dbg("No 64bit DMA mask, used 32 bit mask\n");
-			ret = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (ret)
 				dev_info(&pdev->dev,
 					"Unable to set DMA consistent mask "
diff -puN drivers/infiniband/hw/mthca/mthca_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/infiniband/hw/mthca/mthca_main.c
--- a/drivers/infiniband/hw/mthca/mthca_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/infiniband/hw/mthca/mthca_main.c
@@ -1019,7 +1019,7 @@ static int __mthca_init_one(struct pci_d
 	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (err) {
 		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask.\n");
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting.\n");
 			goto err_free_res;
@@ -1029,7 +1029,7 @@ static int __mthca_init_one(struct pci_d
 	if (err) {
 		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit "
 			 "consistent PCI DMA mask.\n");
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "Can't set consistent PCI DMA mask, "
 				"aborting.\n");
diff -puN drivers/infiniband/hw/nes/nes.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/infiniband/hw/nes/nes.c
--- a/drivers/infiniband/hw/nes/nes.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/infiniband/hw/nes/nes.c
@@ -489,12 +489,12 @@ static int __devinit nes_probe(struct pc
 			goto bail2;
 		}
 	} else {
-		ret = pci_set_dma_mask(pcidev, DMA_32BIT_MASK);
+		ret = pci_set_dma_mask(pcidev, DMA_BIT_MASK(32));
 		if (ret < 0) {
 			printk(KERN_ERR PFX "32b DMA mask configuration failed\n");
 			goto bail2;
 		}
-		ret = pci_set_consistent_dma_mask(pcidev, DMA_32BIT_MASK);
+		ret = pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32));
 		if (ret) {
 			printk(KERN_ERR PFX "32b DMA consistent mask configuration failed\n");
 			goto bail2;
diff -puN drivers/media/dvb/dm1105/dm1105.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/media/dvb/dm1105/dm1105.c
--- a/drivers/media/dvb/dm1105/dm1105.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/media/dvb/dm1105/dm1105.c
@@ -662,7 +662,7 @@ static int __devinit dm1105_probe(struct
 	if (ret < 0)
 		goto err_kfree;
 
-	ret = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret < 0)
 		goto err_pci_disable_device;
 
diff -puN drivers/media/dvb/pluto2/pluto2.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/media/dvb/pluto2/pluto2.c
--- a/drivers/media/dvb/pluto2/pluto2.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/media/dvb/pluto2/pluto2.c
@@ -616,7 +616,7 @@ static int __devinit pluto2_probe(struct
 	/* enable interrupts */
 	pci_write_config_dword(pdev, 0x6c, 0x8000);
 
-	ret = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret < 0)
 		goto err_pci_disable_device;
 
diff -puN drivers/media/video/bt8xx/bttv-driver.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/media/video/bt8xx/bttv-driver.c
--- a/drivers/media/video/bt8xx/bttv-driver.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/media/video/bt8xx/bttv-driver.c
@@ -4320,7 +4320,7 @@ static int __devinit bttv_probe(struct p
 		       btv->c.nr);
 		return -EIO;
 	}
-	if (pci_set_dma_mask(dev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
 		printk(KERN_WARNING "bttv%d: No suitable DMA available.\n",
 		       btv->c.nr);
 		return -EIO;
diff -puN drivers/media/video/cx88/cx88-alsa.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/media/video/cx88/cx88-alsa.c
--- a/drivers/media/video/cx88/cx88-alsa.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/media/video/cx88/cx88-alsa.c
@@ -745,7 +745,7 @@ static int __devinit snd_cx88_create(str
 		return err;
 	}
 
-	if (!pci_dma_supported(pci,DMA_32BIT_MASK)) {
+	if (!pci_dma_supported(pci,DMA_BIT_MASK(32))) {
 		dprintk(0, "%s/1: Oops: no 32bit PCI DMA ???\n",core->name);
 		err = -EIO;
 		cx88_core_put(core,pci);
diff -puN drivers/media/video/cx88/cx88-mpeg.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/media/video/cx88/cx88-mpeg.c
--- a/drivers/media/video/cx88/cx88-mpeg.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/media/video/cx88/cx88-mpeg.c
@@ -455,7 +455,7 @@ static int cx8802_init_common(struct cx8
 	if (pci_enable_device(dev->pci))
 		return -EIO;
 	pci_set_master(dev->pci);
-	if (!pci_dma_supported(dev->pci,DMA_32BIT_MASK)) {
+	if (!pci_dma_supported(dev->pci,DMA_BIT_MASK(32))) {
 		printk("%s/2: Oops: no 32bit PCI DMA ???\n",dev->core->name);
 		return -EIO;
 	}
diff -puN drivers/media/video/cx88/cx88-video.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/media/video/cx88/cx88-video.c
--- a/drivers/media/video/cx88/cx88-video.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/media/video/cx88/cx88-video.c
@@ -1836,7 +1836,7 @@ static int __devinit cx8800_initdev(stru
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 
 	pci_set_master(pci_dev);
-	if (!pci_dma_supported(pci_dev,DMA_32BIT_MASK)) {
+	if (!pci_dma_supported(pci_dev,DMA_BIT_MASK(32))) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n",core->name);
 		err = -EIO;
 		goto fail_core;
diff -puN drivers/media/video/meye.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/media/video/meye.c
--- a/drivers/media/video/meye.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/media/video/meye.c
@@ -117,7 +117,7 @@ static int ptable_alloc(void)
 	memset(meye.mchip_ptable, 0, sizeof(meye.mchip_ptable));
 
 	/* give only 32 bit DMA addresses */
-	if (dma_set_mask(&meye.mchip_dev->dev, DMA_32BIT_MASK))
+	if (dma_set_mask(&meye.mchip_dev->dev, DMA_BIT_MASK(32)))
 		return -1;
 
 	meye.mchip_ptable_toc = dma_alloc_coherent(&meye.mchip_dev->dev,
diff -puN drivers/media/video/saa7134/saa7134-core.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/media/video/saa7134/saa7134-core.c
--- a/drivers/media/video/saa7134/saa7134-core.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/media/video/saa7134/saa7134-core.c
@@ -911,7 +911,7 @@ static int __devinit saa7134_initdev(str
 	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 	pci_set_master(pci_dev);
-	if (!pci_dma_supported(pci_dev, DMA_32BIT_MASK)) {
+	if (!pci_dma_supported(pci_dev, DMA_BIT_MASK(32))) {
 		printk("%s: Oops: no 32bit PCI DMA ???\n",dev->name);
 		err = -EIO;
 		goto fail1;
diff -puN drivers/memstick/host/jmb38x_ms.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -877,7 +877,7 @@ static int jmb38x_ms_probe(struct pci_de
 	int pci_dev_busy = 0;
 	int rc, cnt;
 
-	rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc)
 		return rc;
 
diff -puN drivers/message/fusion/mptbase.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/message/fusion/mptbase.c
@@ -1539,8 +1539,8 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 		    ": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
 		    ioc->name));
-	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)
-	    && !pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+	    && !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 		    ": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
 		    ioc->name));
diff -puN drivers/message/i2o/memory.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/message/i2o/memory.c
--- a/drivers/message/i2o/memory.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/message/i2o/memory.c
@@ -187,7 +187,7 @@ int i2o_dma_alloc(struct device *dev, st
 	mutex_lock(&mem_lock);
 	if ((sizeof(dma_addr_t) > 4) && (pdev->dma_mask == DMA_BIT_MASK(64))) {
 		dma_64 = 1;
-		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 			mutex_unlock(&mem_lock);
 			return -ENOMEM;
 		}
diff -puN drivers/message/i2o/pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/message/i2o/pci.c
--- a/drivers/message/i2o/pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/message/i2o/pci.c
@@ -334,7 +334,7 @@ static int __devinit i2o_pci_probe(struc
 		return rc;
 	}
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_WARNING "i2o: no suitable DMA found for %s\n",
 		       pci_name(pdev));
 		rc = -ENODEV;
diff -puN drivers/misc/tifm_7xx1.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/misc/tifm_7xx1.c
--- a/drivers/misc/tifm_7xx1.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/misc/tifm_7xx1.c
@@ -324,7 +324,7 @@ static int tifm_7xx1_probe(struct pci_de
 	int pci_dev_busy = 0;
 	int rc;
 
-	rc = pci_set_dma_mask(dev, DMA_32BIT_MASK);
+	rc = pci_set_dma_mask(dev, DMA_BIT_MASK(32));
 	if (rc)
 		return rc;
 
diff -puN drivers/mmc/host/sdhci-pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/mmc/host/sdhci-pci.c
--- a/drivers/mmc/host/sdhci-pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/mmc/host/sdhci-pci.c
@@ -380,7 +380,7 @@ static int sdhci_pci_enable_dma(struct s
 			"doesn't fully claim to support it.\n");
 	}
 
-	ret = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret)
 		return ret;
 
diff -puN drivers/net/8139cp.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/8139cp.c
--- a/drivers/net/8139cp.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/8139cp.c
@@ -1530,7 +1530,7 @@ static void cp_get_ethtool_stats (struct
 
 	/* begin NIC statistics dump */
 	cpw32(StatsAddr + 4, (u64)dma >> 32);
-	cpw32(StatsAddr, ((u64)dma & DMA_32BIT_MASK) | DumpStats);
+	cpw32(StatsAddr, ((u64)dma & DMA_BIT_MASK(32)) | DumpStats);
 	cpr32(StatsAddr);
 
 	for (i = 0; i < 1000; i++) {
@@ -1935,13 +1935,13 @@ static int cp_init_one (struct pci_dev *
 	} else {
 		pci_using_dac = 0;
 
-		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_err(&pdev->dev,
 				   "No usable DMA configuration, aborting.\n");
 			goto err_out_res;
 		}
-		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_err(&pdev->dev,
 				   "No usable consistent DMA configuration, "
diff -puN drivers/net/acenic.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/acenic.c
--- a/drivers/net/acenic.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/acenic.c
@@ -1163,7 +1163,7 @@ static int __devinit ace_init(struct net
 	 */
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		ap->pci_using_dac = 1;
-	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		ap->pci_using_dac = 0;
 	} else {
 		ecode = -ENODEV;
diff -puN drivers/net/amd8111e.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/amd8111e.c
--- a/drivers/net/amd8111e.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/amd8111e.c
@@ -1871,7 +1871,7 @@ static int __devinit amd8111e_probe_one(
 	}
 
 	/* Initialize DMA */
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) < 0) {
 		printk(KERN_ERR "amd8111e: DMA not supported,"
 			"exiting.\n");
 		goto err_free_reg;
diff -puN drivers/net/atl1e/atl1e_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/atl1e/atl1e_main.c
--- a/drivers/net/atl1e/atl1e_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/atl1e/atl1e_main.c
@@ -2326,8 +2326,8 @@ static int __devinit atl1e_probe(struct 
 	 * various kernel subsystems to support the mechanics required by a
 	 * fixed-high-32-bit system.
 	 */
-	if ((pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0) ||
-	    (pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK) != 0)) {
+	if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) ||
+	    (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)) {
 		dev_err(&pdev->dev, "No usable DMA configuration,aborting\n");
 		goto err_dma;
 	}
diff -puN drivers/net/atlx/atl1.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/atlx/atl1.c
--- a/drivers/net/atlx/atl1.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/atlx/atl1.c
@@ -2929,7 +2929,7 @@ static int __devinit atl1_probe(struct p
 	 * various kernel subsystems to support the mechanics required by a
 	 * fixed-high-32-bit system.
 	 */
-	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err) {
 		dev_err(&pdev->dev, "no usable DMA configuration\n");
 		goto err_dma;
diff -puN drivers/net/atlx/atl2.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/atlx/atl2.c
--- a/drivers/net/atlx/atl2.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/atlx/atl2.c
@@ -1358,8 +1358,8 @@ static int __devinit atl2_probe(struct p
 	 * until the kernel has the proper infrastructure to support 64-bit DMA
 	 * on these devices.
 	 */
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) &&
-		pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) &&
+		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_ERR "atl2: No usable DMA configuration, aborting\n");
 		goto err_dma;
 	}
diff -puN drivers/net/bnx2.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/bnx2.c
--- a/drivers/net/bnx2.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/bnx2.c
@@ -7486,7 +7486,7 @@ bnx2_init_board(struct pci_dev *pdev, st
 				"pci_set_consistent_dma_mask failed, aborting.\n");
 			goto err_out_unmap;
 		}
-	} else if ((rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK)) != 0) {
+	} else if ((rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) != 0) {
 		dev_err(&pdev->dev, "System does not support DMA, aborting.\n");
 		goto err_out_unmap;
 	}
diff -puN drivers/net/bnx2x_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/bnx2x_main.c
--- a/drivers/net/bnx2x_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/bnx2x_main.c
@@ -10988,7 +10988,7 @@ static int __devinit bnx2x_init_dev(stru
 			goto err_out_release;
 		}
 
-	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0) {
+	} else if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) {
 		printk(KERN_ERR PFX "System does not support DMA,"
 		       " aborting\n");
 		rc = -EIO;
diff -puN drivers/net/cassini.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/cassini.c
--- a/drivers/net/cassini.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/cassini.c
@@ -5085,7 +5085,7 @@ static int __devinit cas_init_one(struct
 		}
 
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "No usable DMA configuration, "
 			       "aborting.\n");
diff -puN drivers/net/chelsio/cxgb2.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/chelsio/cxgb2.c
--- a/drivers/net/chelsio/cxgb2.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/chelsio/cxgb2.c
@@ -1066,7 +1066,7 @@ static int __devinit init_one(struct pci
 			goto out_disable_pdev;
 		}
 
-	} else if ((err = pci_set_dma_mask(pdev, DMA_32BIT_MASK)) != 0) {
+	} else if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) != 0) {
 		CH_ERR("%s: no usable DMA configuration\n", pci_name(pdev));
 		goto out_disable_pdev;
 	}
diff -puN drivers/net/cxgb3/cxgb3_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -3046,7 +3046,7 @@ static int __devinit init_one(struct pci
 			       "coherent allocations\n");
 			goto out_disable_device;
 		}
-	} else if ((err = pci_set_dma_mask(pdev, DMA_32BIT_MASK)) != 0) {
+	} else if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) != 0) {
 		dev_err(&pdev->dev, "no usable DMA configuration\n");
 		goto out_disable_device;
 	}
diff -puN drivers/net/e100.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/e100.c
--- a/drivers/net/e100.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/e100.c
@@ -2604,7 +2604,7 @@ static int __devinit e100_probe(struct p
 		goto err_out_disable_pdev;
 	}
 
-	if ((err = pci_set_dma_mask(pdev, DMA_32BIT_MASK))) {
+	if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
 		DPRINTK(PROBE, ERR, "No usable DMA configuration, aborting.\n");
 		goto err_out_free_res;
 	}
diff -puN drivers/net/e1000/e1000_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/e1000/e1000_main.c
@@ -966,9 +966,9 @@ static int __devinit e1000_probe(struct 
 	    !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
-			err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (err) {
 				E1000_ERR("No usable DMA configuration, "
 					  "aborting\n");
diff -puN drivers/net/e1000e/netdev.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/e1000e/netdev.c
@@ -2203,7 +2203,7 @@ static void e1000_configure_tx(struct e1
 	/* Setup the HW Tx Head and Tail descriptor pointers */
 	tdba = tx_ring->dma;
 	tdlen = tx_ring->count * sizeof(struct e1000_tx_desc);
-	ew32(TDBAL, (tdba & DMA_32BIT_MASK));
+	ew32(TDBAL, (tdba & DMA_BIT_MASK(32)));
 	ew32(TDBAH, (tdba >> 32));
 	ew32(TDLEN, tdlen);
 	ew32(TDH, 0);
@@ -2459,7 +2459,7 @@ static void e1000_configure_rx(struct e1
 	 * the Base and Length of the Rx Descriptor Ring
 	 */
 	rdba = rx_ring->dma;
-	ew32(RDBAL, (rdba & DMA_32BIT_MASK));
+	ew32(RDBAL, (rdba & DMA_BIT_MASK(32)));
 	ew32(RDBAH, (rdba >> 32));
 	ew32(RDLEN, rdlen);
 	ew32(RDH, 0);
@@ -4769,10 +4769,10 @@ static int __devinit e1000_probe(struct 
 		if (!err)
 			pci_using_dac = 1;
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			err = pci_set_consistent_dma_mask(pdev,
-							  DMA_32BIT_MASK);
+							  DMA_BIT_MASK(32));
 			if (err) {
 				dev_err(&pdev->dev, "No usable DMA "
 					"configuration, aborting\n");
diff -puN drivers/net/enic/enic_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/enic/enic_main.c
--- a/drivers/net/enic/enic_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/enic/enic_main.c
@@ -1687,13 +1687,13 @@ static int __devinit enic_probe(struct p
 
 	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(40));
 	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			printk(KERN_ERR PFX
 				"No usable DMA configuration, aborting.\n");
 			goto err_out_release_regions;
 		}
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			printk(KERN_ERR PFX
 				"Unable to obtain 32-bit DMA "
diff -puN drivers/net/hp100.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/hp100.c
--- a/drivers/net/hp100.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/hp100.c
@@ -580,7 +580,7 @@ static int __devinit hp100_probe1(struct
 			 * Also, we can have EISA Busmaster cards (not tested),
 			 * so beware !!! - Jean II */
 			if((bus == HP100_BUS_PCI) &&
-			   (pci_set_dma_mask(pci_dev, DMA_32BIT_MASK))) {
+			   (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32)))) {
 				/* Gracefully fallback to shared memory */
 				goto busmasterfail;
 			}
diff -puN drivers/net/igb/igb_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/igb/igb_main.c
--- a/drivers/net/igb/igb_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/igb/igb_main.c
@@ -1160,9 +1160,9 @@ static int __devinit igb_probe(struct pc
 		if (!err)
 			pci_using_dac = 1;
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
-			err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (err) {
 				dev_err(&pdev->dev, "No usable DMA "
 					"configuration, aborting\n");
diff -puN drivers/net/ioc3-eth.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/ioc3-eth.c
--- a/drivers/net/ioc3-eth.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/ioc3-eth.c
@@ -1236,7 +1236,7 @@ static int __devinit ioc3_probe(struct p
 			goto out;
 		}
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			printk(KERN_ERR "%s: No usable DMA configuration, "
 			       "aborting.\n", pci_name(pdev));
diff -puN drivers/net/ipg.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/ipg.c
--- a/drivers/net/ipg.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/ipg.c
@@ -2242,7 +2242,7 @@ static int __devinit ipg_probe(struct pc
 
 	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(40));
 	if (rc < 0) {
-		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc < 0) {
 			printk(KERN_ERR "%s: DMA config failed.\n",
 			       pci_name(pdev));
diff -puN drivers/net/ixgb/ixgb_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/ixgb/ixgb_main.c
--- a/drivers/net/ixgb/ixgb_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/ixgb/ixgb_main.c
@@ -369,8 +369,8 @@ ixgb_probe(struct pci_dev *pdev, const s
 	    !(err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))) {
 		pci_using_dac = 1;
 	} else {
-		if ((err = pci_set_dma_mask(pdev, DMA_32BIT_MASK)) ||
-		    (err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK))) {
+		if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) ||
+		    (err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))) {
 			printk(KERN_ERR
 			 "ixgb: No usable DMA configuration, aborting\n");
 			goto err_dma_mask;
diff -puN drivers/net/ixgbe/ixgbe_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/ixgbe/ixgbe_main.c
--- a/drivers/net/ixgbe/ixgbe_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/ixgbe/ixgbe_main.c
@@ -1643,7 +1643,7 @@ static void ixgbe_configure_tx(struct ix
 		tdba = ring->dma;
 		tdlen = ring->count * sizeof(union ixgbe_adv_tx_desc);
 		IXGBE_WRITE_REG(hw, IXGBE_TDBAL(j),
-		                (tdba & DMA_32BIT_MASK));
+		                (tdba & DMA_BIT_MASK(32)));
 		IXGBE_WRITE_REG(hw, IXGBE_TDBAH(j), (tdba >> 32));
 		IXGBE_WRITE_REG(hw, IXGBE_TDLEN(j), tdlen);
 		IXGBE_WRITE_REG(hw, IXGBE_TDH(j), 0);
@@ -1782,7 +1782,7 @@ static void ixgbe_configure_rx(struct ix
 	for (i = 0; i < adapter->num_rx_queues; i++) {
 		rdba = adapter->rx_ring[i].dma;
 		j = adapter->rx_ring[i].reg_idx;
-		IXGBE_WRITE_REG(hw, IXGBE_RDBAL(j), (rdba & DMA_32BIT_MASK));
+		IXGBE_WRITE_REG(hw, IXGBE_RDBAL(j), (rdba & DMA_BIT_MASK(32)));
 		IXGBE_WRITE_REG(hw, IXGBE_RDBAH(j), (rdba >> 32));
 		IXGBE_WRITE_REG(hw, IXGBE_RDLEN(j), rdlen);
 		IXGBE_WRITE_REG(hw, IXGBE_RDH(j), 0);
@@ -4513,9 +4513,9 @@ static int __devinit ixgbe_probe(struct 
 	    !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
-			err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (err) {
 				dev_err(&pdev->dev, "No usable DMA "
 				        "configuration, aborting\n");
diff -puN drivers/net/jme.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/jme.c
--- a/drivers/net/jme.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/jme.c
@@ -2600,8 +2600,8 @@ jme_pci_dma64(struct pci_dev *pdev)
 		if (!pci_set_consistent_dma_mask(pdev, DMA_40BIT_MASK))
 			return 1;
 
-	if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK))
-		if (!pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK))
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
+		if (!pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
 			return 0;
 
 	return -1;
diff -puN drivers/net/mlx4/main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/mlx4/main.c
--- a/drivers/net/mlx4/main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/mlx4/main.c
@@ -1079,7 +1079,7 @@ static int __mlx4_init_one(struct pci_de
 	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (err) {
 		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask.\n");
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting.\n");
 			goto err_release_bar2;
@@ -1089,7 +1089,7 @@ static int __mlx4_init_one(struct pci_de
 	if (err) {
 		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit "
 			 "consistent PCI DMA mask.\n");
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "Can't set consistent PCI DMA mask, "
 				"aborting.\n");
diff -puN drivers/net/myri10ge/myri10ge.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/myri10ge/myri10ge.c
--- a/drivers/net/myri10ge/myri10ge.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/myri10ge/myri10ge.c
@@ -1130,7 +1130,7 @@ myri10ge_submit_8rx(struct mcp_kreq_ethe
 	__be32 low;
 
 	low = src->addr_low;
-	src->addr_low = htonl(DMA_32BIT_MASK);
+	src->addr_low = htonl(DMA_BIT_MASK(32));
 	myri10ge_pio_copy(dst, src, 4 * sizeof(*src));
 	mb();
 	myri10ge_pio_copy(dst + 4, src + 4, 4 * sizeof(*src));
@@ -3798,7 +3798,7 @@ static int myri10ge_probe(struct pci_dev
 		dev_err(&pdev->dev,
 			"64-bit pci address mask was refused, "
 			"trying 32-bit\n");
-		status = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		status = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	}
 	if (status != 0) {
 		dev_err(&pdev->dev, "Error %d setting DMA mask\n", status);
diff -puN drivers/net/niu.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/niu.c
--- a/drivers/net/niu.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/niu.c
@@ -9889,8 +9889,8 @@ static int __devinit niu_pci_init_one(st
 			goto err_out_release_parent;
 		}
 	}
-	if (err || dma_mask == DMA_32BIT_MASK) {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	if (err || dma_mask == DMA_BIT_MASK(32)) {
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, PFX "No usable DMA configuration, "
 				"aborting.\n");
diff -puN drivers/net/ns83820.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/ns83820.c
--- a/drivers/net/ns83820.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/ns83820.c
@@ -1975,7 +1975,7 @@ static int __devinit ns83820_init_one(st
 	if (sizeof(dma_addr_t) == 8 &&
 	 	!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
-	} else if (!pci_set_dma_mask(pci_dev, DMA_32BIT_MASK)) {
+	} else if (!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32))) {
 		using_dac = 0;
 	} else {
 		dev_warn(&pci_dev->dev, "pci_set_dma_mask failed!\n");
diff -puN drivers/net/qla3xxx.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/qla3xxx.c
--- a/drivers/net/qla3xxx.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/qla3xxx.c
@@ -3937,9 +3937,9 @@ static int __devinit ql3xxx_probe(struct
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-	} else if (!(err = pci_set_dma_mask(pdev, DMA_32BIT_MASK))) {
+	} else if (!(err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
 		pci_using_dac = 0;
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	}
 
 	if (err) {
diff -puN drivers/net/qlge/qlge_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/qlge/qlge_main.c
--- a/drivers/net/qlge/qlge_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/qlge/qlge_main.c
@@ -3730,9 +3730,9 @@ static int __devinit ql_init_device(stru
 		set_bit(QL_DMA64, &qdev->flags);
 		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (!err)
-		       err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		       err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	}
 
 	if (err) {
diff -puN drivers/net/r6040.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/r6040.c
--- a/drivers/net/r6040.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/r6040.c
@@ -1085,13 +1085,13 @@ static int __devinit r6040_init_one(stru
 		goto err_out;
 
 	/* this should always be supported */
-	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err) {
 		printk(KERN_ERR DRV_NAME ": 32-bit PCI DMA addresses"
 				"not supported by the card\n");
 		goto err_out;
 	}
-	err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err) {
 		printk(KERN_ERR DRV_NAME ": 32-bit PCI DMA addresses"
 				"not supported by the card\n");
diff -puN drivers/net/r8169.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/r8169.c
--- a/drivers/net/r8169.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/r8169.c
@@ -1148,7 +1148,7 @@ static void rtl8169_update_counters(stru
 		return;
 
 	RTL_W32(CounterAddrHigh, (u64)paddr >> 32);
-	cmd = (u64)paddr & DMA_32BIT_MASK;
+	cmd = (u64)paddr & DMA_BIT_MASK(32);
 	RTL_W32(CounterAddrLow, cmd);
 	RTL_W32(CounterAddrLow, cmd | CounterDump);
 
@@ -2050,7 +2050,7 @@ rtl8169_init_one(struct pci_dev *pdev, c
 		tp->cp_cmd |= PCIDAC;
 		dev->features |= NETIF_F_HIGHDMA;
 	} else {
-		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc < 0) {
 			if (netif_msg_probe(tp)) {
 				dev_err(&pdev->dev,
@@ -2343,9 +2343,9 @@ static void rtl_set_rx_tx_desc_registers
 	 * Switching from MMIO to I/O access fixes the issue as well.
 	 */
 	RTL_W32(TxDescStartAddrHigh, ((u64) tp->TxPhyAddr) >> 32);
-	RTL_W32(TxDescStartAddrLow, ((u64) tp->TxPhyAddr) & DMA_32BIT_MASK);
+	RTL_W32(TxDescStartAddrLow, ((u64) tp->TxPhyAddr) & DMA_BIT_MASK(32));
 	RTL_W32(RxDescAddrHigh, ((u64) tp->RxPhyAddr) >> 32);
-	RTL_W32(RxDescAddrLow, ((u64) tp->RxPhyAddr) & DMA_32BIT_MASK);
+	RTL_W32(RxDescAddrLow, ((u64) tp->RxPhyAddr) & DMA_BIT_MASK(32));
 }
 
 static u16 rtl_rw_cpluscmd(void __iomem *ioaddr)
diff -puN drivers/net/s2io.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/s2io.c
--- a/drivers/net/s2io.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/s2io.c
@@ -7786,7 +7786,7 @@ s2io_init_nic(struct pci_dev *pdev, cons
 			pci_disable_device(pdev);
 			return -ENOMEM;
 		}
-	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		DBG_PRINT(INIT_DBG, "s2io_init_nic: Using 32bit DMA\n");
 	} else {
 		pci_disable_device(pdev);
diff -puN drivers/net/sc92031.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/sc92031.c
--- a/drivers/net/sc92031.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/sc92031.c
@@ -1427,11 +1427,11 @@ static int __devinit sc92031_probe(struc
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (unlikely(err < 0))
 		goto out_set_dma_mask;
 
-	err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (unlikely(err < 0))
 		goto out_set_dma_mask;
 
diff -puN drivers/net/sis190.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/sis190.c
--- a/drivers/net/sis190.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/sis190.c
@@ -1467,7 +1467,7 @@ static struct net_device * __devinit sis
 		goto err_pci_disable_2;
 	}
 
-	rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc < 0) {
 		net_probe(tp, KERN_ERR "%s: DMA configuration failed.\n",
 			  pci_name(pdev));
diff -puN drivers/net/sis900.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/sis900.c
--- a/drivers/net/sis900.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/sis900.c
@@ -432,7 +432,7 @@ static int __devinit sis900_probe(struct
 	ret = pci_enable_device(pci_dev);
 	if(ret) return ret;
 
-	i = pci_set_dma_mask(pci_dev, DMA_32BIT_MASK);
+	i = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
 	if(i){
 		printk(KERN_ERR "sis900.c: architecture does not support "
 			"32bit PCI busmaster DMA\n");
diff -puN drivers/net/skge.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/skge.c
--- a/drivers/net/skge.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/skge.c
@@ -3915,9 +3915,9 @@ static int __devinit skge_probe(struct p
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
 		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-	} else if (!(err = pci_set_dma_mask(pdev, DMA_32BIT_MASK))) {
+	} else if (!(err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
 		using_dac = 0;
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	}
 
 	if (err) {
diff -puN drivers/net/sky2.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/sky2.c
--- a/drivers/net/sky2.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/sky2.c
@@ -4383,7 +4383,7 @@ static int __devinit sky2_probe(struct p
 			goto err_out_free_regions;
 		}
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "no usable DMA configuration\n");
 			goto err_out_free_regions;
diff -puN drivers/net/smsc9420.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/smsc9420.c
--- a/drivers/net/smsc9420.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/smsc9420.c
@@ -1598,7 +1598,7 @@ smsc9420_probe(struct pci_dev *pdev, con
 		goto out_free_netdev_2;
 	}
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_ERR "No usable DMA configuration, aborting.\n");
 		goto out_free_regions_3;
 	}
diff -puN drivers/net/sungem.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/sungem.c
--- a/drivers/net/sungem.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/sungem.c
@@ -3045,7 +3045,7 @@ static int __devinit gem_init_one(struct
 	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			printk(KERN_ERR PFX "No usable DMA configuration, "
 			       "aborting.\n");
diff -puN drivers/net/tehuti.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/tehuti.c
--- a/drivers/net/tehuti.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/tehuti.c
@@ -1945,8 +1945,8 @@ bdx_probe(struct pci_dev *pdev, const st
 	    !(err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))) {
 		pci_using_dac = 1;
 	} else {
-		if ((err = pci_set_dma_mask(pdev, DMA_32BIT_MASK)) ||
-		    (err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK))) {
+		if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) ||
+		    (err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))) {
 			printk(KERN_ERR "tehuti: No usable DMA configuration"
 					", aborting\n");
 			goto err_dma;
diff -puN drivers/net/tehuti.h~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/tehuti.h
--- a/drivers/net/tehuti.h~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/tehuti.h
@@ -99,10 +99,6 @@
 #define READ_REG(pp, reg)         readl(pp->pBdxRegs + reg)
 #define WRITE_REG(pp, reg, val)   writel(val, pp->pBdxRegs + reg)
 
-#ifndef DMA_32BIT_MASK
-#   define DMA_32BIT_MASK  0x00000000ffffffffULL
-#endif
-
 #ifndef NET_IP_ALIGN
 #   define NET_IP_ALIGN 2
 #endif
diff -puN drivers/net/tg3.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/tg3.c
--- a/drivers/net/tg3.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/tg3.c
@@ -13228,7 +13228,7 @@ static int __devinit tg3_init_one(struct
 	 * do DMA address check in tg3_start_xmit().
 	 */
 	if (tp->tg3_flags2 & TG3_FLG2_IS_5788)
-		persist_dma_mask = dma_mask = DMA_32BIT_MASK;
+		persist_dma_mask = dma_mask = DMA_BIT_MASK(32);
 	else if (tp->tg3_flags & TG3_FLAG_40BIT_DMA_BUG) {
 		persist_dma_mask = dma_mask = DMA_BIT_MASK(40);
 #ifdef CONFIG_HIGHMEM
@@ -13238,7 +13238,7 @@ static int __devinit tg3_init_one(struct
 		persist_dma_mask = dma_mask = DMA_BIT_MASK(64);
 
 	/* Configure DMA attributes. */
-	if (dma_mask > DMA_32BIT_MASK) {
+	if (dma_mask > DMA_BIT_MASK(32)) {
 		err = pci_set_dma_mask(pdev, dma_mask);
 		if (!err) {
 			dev->features |= NETIF_F_HIGHDMA;
@@ -13251,8 +13251,8 @@ static int __devinit tg3_init_one(struct
 			}
 		}
 	}
-	if (err || dma_mask == DMA_32BIT_MASK) {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	if (err || dma_mask == DMA_BIT_MASK(32)) {
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			printk(KERN_ERR PFX "No usable DMA configuration, "
 			       "aborting.\n");
@@ -13393,7 +13393,7 @@ static int __devinit tg3_init_one(struct
 	       (tp->tg3_flags2 & TG3_FLG2_TSO_CAPABLE) != 0);
 	printk(KERN_INFO "%s: dma_rwctrl[%08x] dma_mask[%d-bit]\n",
 	       dev->name, tp->dma_rwctrl,
-	       (pdev->dma_mask == DMA_32BIT_MASK) ? 32 :
+	       (pdev->dma_mask == DMA_BIT_MASK(32)) ? 32 :
 	        (((u64) pdev->dma_mask == DMA_BIT_MASK(40)) ? 40 : 64));
 
 	return 0;
diff -puN drivers/net/tlan.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/tlan.c
--- a/drivers/net/tlan.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/tlan.c
@@ -570,7 +570,7 @@ static int __devinit TLan_probe1(struct 
 
 		priv->adapter = &board_info[ent->driver_data];
 
-		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			printk(KERN_ERR "TLAN: No suitable PCI mapping available.\n");
 			goto err_out_free_dev;
diff -puN drivers/net/tokenring/lanstreamer.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/tokenring/lanstreamer.c
--- a/drivers/net/tokenring/lanstreamer.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/tokenring/lanstreamer.c
@@ -267,7 +267,7 @@ static int __devinit streamer_init_one(s
 #endif
 #endif
 
-	rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc) {
 		printk(KERN_ERR "%s: No suitable PCI mapping available.\n",
 				dev->name);
diff -puN drivers/net/tulip/dmfe.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/tulip/dmfe.c
--- a/drivers/net/tulip/dmfe.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/tulip/dmfe.c
@@ -383,7 +383,7 @@ static int __devinit dmfe_init_one (stru
 		return -ENOMEM;
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_WARNING DRV_NAME
 			": 32-bit PCI DMA not available.\n");
 		err = -ENODEV;
diff -puN drivers/net/tulip/uli526x.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/tulip/uli526x.c
--- a/drivers/net/tulip/uli526x.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/tulip/uli526x.c
@@ -282,7 +282,7 @@ static int __devinit uli526x_init_one (s
 		return -ENOMEM;
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_WARNING DRV_NAME ": 32-bit PCI DMA not available.\n");
 		err = -ENODEV;
 		goto err_out_free;
diff -puN drivers/net/tulip/winbond-840.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/tulip/winbond-840.c
--- a/drivers/net/tulip/winbond-840.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/tulip/winbond-840.c
@@ -375,7 +375,7 @@ static int __devinit w840_probe1 (struct
 
 	irq = pdev->irq;
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_WARNING "Winbond-840: Device %s disabled due to DMA limitations.\n",
 		       pci_name(pdev));
 		return -EIO;
diff -puN drivers/net/typhoon.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/typhoon.c
--- a/drivers/net/typhoon.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/typhoon.c
@@ -2406,7 +2406,7 @@ typhoon_init_one(struct pci_dev *pdev, c
 		goto error_out_disable;
 	}
 
-	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if(err < 0) {
 		printk(ERR_PFX "%s: No usable DMA configuration\n",
 		       pci_name(pdev));
diff -puN drivers/net/via-rhine.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/via-rhine.c
--- a/drivers/net/via-rhine.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/via-rhine.c
@@ -686,7 +686,7 @@ static int __devinit rhine_init_one(stru
 		goto err_out;
 
 	/* this should always be supported */
-	rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc) {
 		printk(KERN_ERR "32-bit PCI DMA addresses not supported by "
 		       "the card!?\n");
diff -puN drivers/net/wan/wanxl.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/wan/wanxl.c
--- a/drivers/net/wan/wanxl.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/wan/wanxl.c
@@ -633,8 +633,8 @@ static int __devinit wanxl_pci_init_one(
 	/* FIXME when PCI/DMA subsystems are fixed.
 	   We set both dma_mask and consistent_dma_mask back to 32 bits
 	   to indicate the card can do 32-bit DMA addressing */
-	if (pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK) ||
-	    pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) ||
+	    pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_ERR "wanXL: No usable DMA configuration\n");
 		wanxl_pci_remove_one(pdev);
 		return -EIO;
diff -puN drivers/net/wireless/adm8211.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/wireless/adm8211.c
--- a/drivers/net/wireless/adm8211.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/wireless/adm8211.c
@@ -1804,8 +1804,8 @@ static int __devinit adm8211_probe(struc
 		return err; /* someone else grabbed it? don't disable it */
 	}
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) ||
-	    pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
+	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_ERR "%s (adm8211): No suitable DMA available\n",
 		       pci_name(pdev));
 		goto err_free_reg;
diff -puN drivers/net/wireless/ath5k/base.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/wireless/ath5k/base.c
@@ -445,7 +445,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* XXX 32-bit addressing only */
-	ret = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
 		dev_err(&pdev->dev, "32-bit DMA not available\n");
 		goto err_dis;
diff -puN drivers/net/wireless/b43/dma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/wireless/b43/dma.c
--- a/drivers/net/wireless/b43/dma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/wireless/b43/dma.c
@@ -777,7 +777,7 @@ static u64 supported_dma_mask(struct b43
 	b43_write32(dev, mmio_base + B43_DMA32_TXCTL, B43_DMA32_TXADDREXT_MASK);
 	tmp = b43_read32(dev, mmio_base + B43_DMA32_TXCTL);
 	if (tmp & B43_DMA32_TXADDREXT_MASK)
-		return DMA_32BIT_MASK;
+		return DMA_BIT_MASK(32);
 
 	return DMA_30BIT_MASK;
 }
@@ -786,7 +786,7 @@ static enum b43_dmatype dma_mask_to_engi
 {
 	if (dmamask == DMA_30BIT_MASK)
 		return B43_DMA_30BIT;
-	if (dmamask == DMA_32BIT_MASK)
+	if (dmamask == DMA_BIT_MASK(32))
 		return B43_DMA_32BIT;
 	if (dmamask == DMA_BIT_MASK(64))
 		return B43_DMA_64BIT;
@@ -1000,11 +1000,11 @@ static int b43_dma_set_mask(struct b43_w
 		if (!err)
 			break;
 		if (mask == DMA_BIT_MASK(64)) {
-			mask = DMA_32BIT_MASK;
+			mask = DMA_BIT_MASK(32);
 			fallback = 1;
 			continue;
 		}
-		if (mask == DMA_32BIT_MASK) {
+		if (mask == DMA_BIT_MASK(32)) {
 			mask = DMA_30BIT_MASK;
 			fallback = 1;
 			continue;
diff -puN drivers/net/wireless/b43legacy/dma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/wireless/b43legacy/dma.c
--- a/drivers/net/wireless/b43legacy/dma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/wireless/b43legacy/dma.c
@@ -854,7 +854,7 @@ static u64 supported_dma_mask(struct b43
 	tmp = b43legacy_read32(dev, mmio_base +
 			       B43legacy_DMA32_TXCTL);
 	if (tmp & B43legacy_DMA32_TXADDREXT_MASK)
-		return DMA_32BIT_MASK;
+		return DMA_BIT_MASK(32);
 
 	return DMA_30BIT_MASK;
 }
@@ -863,7 +863,7 @@ static enum b43legacy_dmatype dma_mask_t
 {
 	if (dmamask == DMA_30BIT_MASK)
 		return B43legacy_DMA_30BIT;
-	if (dmamask == DMA_32BIT_MASK)
+	if (dmamask == DMA_BIT_MASK(32))
 		return B43legacy_DMA_32BIT;
 	if (dmamask == DMA_BIT_MASK(64))
 		return B43legacy_DMA_64BIT;
@@ -1043,11 +1043,11 @@ static int b43legacy_dma_set_mask(struct
 		if (!err)
 			break;
 		if (mask == DMA_BIT_MASK(64)) {
-			mask = DMA_32BIT_MASK;
+			mask = DMA_BIT_MASK(32);
 			fallback = 1;
 			continue;
 		}
-		if (mask == DMA_32BIT_MASK) {
+		if (mask == DMA_BIT_MASK(32)) {
 			mask = DMA_30BIT_MASK;
 			fallback = 1;
 			continue;
diff -puN drivers/net/wireless/ipw2x00/ipw2100.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/wireless/ipw2x00/ipw2100.c
--- a/drivers/net/wireless/ipw2x00/ipw2100.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -6207,7 +6207,7 @@ static int ipw2100_pci_init_one(struct p
 	pci_set_master(pci_dev);
 	pci_set_drvdata(pci_dev, priv);
 
-	err = pci_set_dma_mask(pci_dev, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_set_dma_mask.\n");
diff -puN drivers/net/wireless/ipw2x00/ipw2200.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/wireless/ipw2x00/ipw2200.c
--- a/drivers/net/wireless/ipw2x00/ipw2200.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11631,9 +11631,9 @@ static int __devinit ipw_pci_probe(struc
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err) {
 		printk(KERN_WARNING DRV_NAME ": No suitable DMA available.\n");
 		goto out_pci_disable_device;
diff -puN drivers/net/wireless/iwlwifi/iwl3945-base.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/wireless/iwlwifi/iwl3945-base.c
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4998,9 +4998,9 @@ static int iwl3945_pci_probe(struct pci_
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err) {
 		IWL_WARN(priv, "No suitable DMA available.\n");
 		goto out_pci_disable_device;
diff -puN drivers/net/wireless/prism54/islpci_hotplug.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/wireless/prism54/islpci_hotplug.c
--- a/drivers/net/wireless/prism54/islpci_hotplug.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/wireless/prism54/islpci_hotplug.c
@@ -120,7 +120,7 @@ prism54_probe(struct pci_dev *pdev, cons
 	}
 
 	/* enable PCI DMA */
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_ERR "%s: 32-bit PCI DMA not supported", DRV_NAME);
 		goto do_pci_disable_device;
         }
diff -puN drivers/net/wireless/rt2x00/rt2x00pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/net/wireless/rt2x00/rt2x00pci.c
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -288,7 +288,7 @@ int rt2x00pci_probe(struct pci_dev *pci_
 	if (pci_set_mwi(pci_dev))
 		ERROR_PROBE("MWI not available.\n");
 
-	if (dma_set_mask(&pci_dev->dev, DMA_32BIT_MASK)) {
+	if (dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32))) {
 		ERROR_PROBE("PCI DMA not supported.\n");
 		retval = -EIO;
 		goto exit_disable_device;
diff -puN drivers/pci/intel-iommu.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/pci/intel-iommu.c
@@ -56,7 +56,7 @@
 #define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
 
 #define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT)
-#define DMA_32BIT_PFN		IOVA_PFN(DMA_32BIT_MASK)
+#define DMA_32BIT_PFN		IOVA_PFN(DMA_BIT_MASK(32))
 #define DMA_64BIT_PFN		IOVA_PFN(DMA_BIT_MASK(64))
 
 /* global iommu list, set NULL for ignored DMAR units */
@@ -2080,15 +2080,15 @@ __intel_alloc_iova(struct device *dev, s
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct iova *iova = NULL;
 
-	if (dma_mask <= DMA_32BIT_MASK || dmar_forcedac)
+	if (dma_mask <= DMA_BIT_MASK(32) || dmar_forcedac)
 		iova = iommu_alloc_iova(domain, size, dma_mask);
 	else {
 		/*
 		 * First try to allocate an io virtual address in
-		 * DMA_32BIT_MASK and if that fails then try allocating
+		 * DMA_BIT_MASK(32) and if that fails then try allocating
 		 * from higher range
 		 */
-		iova = iommu_alloc_iova(domain, size, DMA_32BIT_MASK);
+		iova = iommu_alloc_iova(domain, size, DMA_BIT_MASK(32));
 		if (!iova)
 			iova = iommu_alloc_iova(domain, size, dma_mask);
 	}
diff -puN drivers/rapidio/rio-scan.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/rapidio/rio-scan.c
@@ -381,9 +381,9 @@ static struct rio_dev *rio_setup_device(
 	rdev->dev.release = rio_release_dev;
 	rio_dev_get(rdev);
 
-	rdev->dma_mask = DMA_32BIT_MASK;
+	rdev->dma_mask = DMA_BIT_MASK(32);
 	rdev->dev.dma_mask = &rdev->dma_mask;
-	rdev->dev.coherent_dma_mask = DMA_32BIT_MASK;
+	rdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 
 	if ((rdev->pef & RIO_PEF_INB_DOORBELL) &&
 	    (rdev->dst_ops & RIO_DST_OPS_DOORBELL))
diff -puN drivers/scsi/3w-9xxx.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/3w-9xxx.c
@@ -2018,8 +2018,8 @@ static int __devinit twa_probe(struct pc
 
 	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
 	    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
-		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)
-		    || pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+		    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 			TW_PRINTK(host, TW_DRIVER, 0x23, "Failed to set dma mask");
 			retval = -ENODEV;
 			goto out_disable_device;
diff -puN drivers/scsi/3w-xxxx.h~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/3w-xxxx.h
--- a/drivers/scsi/3w-xxxx.h~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/3w-xxxx.h
@@ -234,7 +234,7 @@ static unsigned char tw_sense_table[][4]
 #define TW_IOCTL_TIMEOUT                      25 /* 25 seconds */
 #define TW_IOCTL_CHRDEV_TIMEOUT               60 /* 60 seconds */
 #define TW_IOCTL_CHRDEV_FREE                  -1
-#define TW_DMA_MASK			      DMA_32BIT_MASK
+#define TW_DMA_MASK			      DMA_BIT_MASK(32)
 #define TW_MAX_CDB_LEN			      16
 
 /* Bitmask macros to eliminate bitfields */
diff -puN drivers/scsi/BusLogic.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/BusLogic.c
--- a/drivers/scsi/BusLogic.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/BusLogic.c
@@ -667,7 +667,7 @@ static int __init BusLogic_InitializeMul
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK ))
+		if (pci_set_dma_mask(PCI_Device, DMA_BIT_MASK(32) ))
 			continue;
 
 		Bus = PCI_Device->bus->number;
@@ -834,7 +834,7 @@ static int __init BusLogic_InitializeMul
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
+		if (pci_set_dma_mask(PCI_Device, DMA_BIT_MASK(32)))
 			continue;
 
 		Bus = PCI_Device->bus->number;
@@ -888,7 +888,7 @@ static int __init BusLogic_InitializeFla
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
+		if (pci_set_dma_mask(PCI_Device, DMA_BIT_MASK(32)))
 			continue;
 
 		Bus = PCI_Device->bus->number;
diff -puN drivers/scsi/a100u2w.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/a100u2w.c
--- a/drivers/scsi/a100u2w.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/a100u2w.c
@@ -1094,7 +1094,7 @@ static int __devinit inia100_probe_one(s
 
 	if (pci_enable_device(pdev))
 		goto out;
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_WARNING "Unable to set 32bit DMA "
 				    "on inia100 adapter, ignoring.\n");
 		goto out_disable_device;
diff -puN drivers/scsi/aacraid/aachba.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/aacraid/aachba.c
@@ -1407,8 +1407,8 @@ int aac_get_adapter_info(struct aac_dev*
 			if (!dev->in_reset)
 				printk(KERN_INFO"%s%d: 64 Bit DAC enabled\n",
 					dev->name, dev->id);
-		} else if (!pci_set_dma_mask(dev->pdev, DMA_32BIT_MASK) &&
-			!pci_set_consistent_dma_mask(dev->pdev, DMA_32BIT_MASK)) {
+		} else if (!pci_set_dma_mask(dev->pdev, DMA_BIT_MASK(32)) &&
+			!pci_set_consistent_dma_mask(dev->pdev, DMA_BIT_MASK(32))) {
 			printk(KERN_INFO"%s%d: DMA mask set failed, 64 Bit DAC disabled\n",
 				dev->name, dev->id);
 			dev->dac_support = 0;
diff -puN drivers/scsi/aacraid/commsup.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/aacraid/commsup.c
@@ -1210,14 +1210,14 @@ static int _aac_reset_adapter(struct aac
 		  ((retval = pci_set_consistent_dma_mask(aac->pdev, DMA_31BIT_MASK))))
 			goto out;
 	} else {
-		if (((retval = pci_set_dma_mask(aac->pdev, DMA_32BIT_MASK))) ||
-		  ((retval = pci_set_consistent_dma_mask(aac->pdev, DMA_32BIT_MASK))))
+		if (((retval = pci_set_dma_mask(aac->pdev, DMA_BIT_MASK(32)))) ||
+		  ((retval = pci_set_consistent_dma_mask(aac->pdev, DMA_BIT_MASK(32)))))
 			goto out;
 	}
 	if ((retval = (*(aac_get_driver_ident(index)->init))(aac)))
 		goto out;
 	if (quirks & AAC_QUIRK_31BIT)
-		if ((retval = pci_set_dma_mask(aac->pdev, DMA_32BIT_MASK)))
+		if ((retval = pci_set_dma_mask(aac->pdev, DMA_BIT_MASK(32))))
 			goto out;
 	if (jafo) {
 		aac->thread = kthread_run(aac_command_thread, aac, aac->name);
diff -puN drivers/scsi/aacraid/linit.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/aacraid/linit.c
@@ -1095,8 +1095,8 @@ static int __devinit aac_probe_one(struc
 		goto out;
 	error = -ENODEV;
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) ||
-			pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK))
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
+			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
 		goto out_disable_pdev;
 	/*
 	 * If the quirk31 bit is set, the adapter needs adapter
@@ -1154,7 +1154,7 @@ static int __devinit aac_probe_one(struc
 	 * address space.
 	 */
 	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
-		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK))
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
 			goto out_deinit;
 
 	aac->maximum_num_channels = aac_drivers[index].channels;
diff -puN drivers/scsi/aic7xxx/aic79xx_osm_pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -197,13 +197,13 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 		if (required_mask > DMA_BIT_MASK(39) &&
 		    dma_set_mask(dev, DMA_BIT_MASK(64)) == 0)
 			ahd->flags |= AHD_64BIT_ADDRESSING;
-		else if (required_mask > DMA_32BIT_MASK &&
+		else if (required_mask > DMA_BIT_MASK(32) &&
 			 dma_set_mask(dev, DMA_BIT_MASK(39)) == 0)
 			ahd->flags |= AHD_39BIT_ADDRESSING;
 		else
-			dma_set_mask(dev, DMA_32BIT_MASK);
+			dma_set_mask(dev, DMA_BIT_MASK(32));
 	} else {
-		dma_set_mask(dev, DMA_32BIT_MASK);
+		dma_set_mask(dev, DMA_BIT_MASK(32));
 	}
 	ahd->dev_softc = pci;
 	error = ahd_pci_config(ahd, entry);
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -241,10 +241,10 @@ ahc_linux_pci_dev_probe(struct pci_dev *
 	if (sizeof(dma_addr_t) > 4
 	    && ahc->features & AHC_LARGE_SCBS
 	    && dma_set_mask(dev, mask_39bit) == 0
-	    && dma_get_required_mask(dev) > DMA_32BIT_MASK) {
+	    && dma_get_required_mask(dev) > DMA_BIT_MASK(32)) {
 		ahc->flags |= AHC_39BIT_ADDRESSING;
 	} else {
-		if (dma_set_mask(dev, DMA_32BIT_MASK)) {
+		if (dma_set_mask(dev, DMA_BIT_MASK(32))) {
 			ahc_free(ahc);
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
                 	return (-ENODEV);
diff -puN drivers/scsi/aic94xx/aic94xx_init.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -793,8 +793,8 @@ static int __devinit asd_pci_probe(struc
 	if (!pci_set_dma_mask(dev, DMA_BIT_MASK(64))
 	    && !pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(64)))
 		;
-	else if (!pci_set_dma_mask(dev, DMA_32BIT_MASK)
-		 && !pci_set_consistent_dma_mask(dev, DMA_32BIT_MASK))
+	else if (!pci_set_dma_mask(dev, DMA_BIT_MASK(32))
+		 && !pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(32)))
 		;
 	else {
 		asd_printk("no suitable DMA mask for %s\n", pci_name(dev));
diff -puN drivers/scsi/arcmsr/arcmsr_hba.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -395,7 +395,7 @@ static int arcmsr_probe(struct pci_dev *
 
 	error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (error) {
-		error = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (error) {
 			printk(KERN_WARNING
 			       "scsi%d: No suitable DMA mask available\n",
diff -puN drivers/scsi/atp870u.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/atp870u.c
--- a/drivers/scsi/atp870u.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/atp870u.c
@@ -2568,7 +2568,7 @@ static int atp870u_probe(struct pci_dev 
 	if (pci_enable_device(pdev))
 		goto err_eio;
 
-        if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+        if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
                 printk(KERN_INFO "atp870u: use 32bit DMA mask.\n");
         } else {
                 printk(KERN_ERR "atp870u: DMA mask required but not available.\n");
diff -puN drivers/scsi/dpt_i2o.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/dpt_i2o.c
@@ -1015,14 +1015,14 @@ static int adpt_install_hba(struct scsi_
 	 */
 	if (sizeof(dma_addr_t) > 4 &&
 	    pci_set_dma_mask(pDev, DMA_BIT_MASK(64)) == 0) {
-		if (dma_get_required_mask(&pDev->dev) > DMA_32BIT_MASK)
+		if (dma_get_required_mask(&pDev->dev) > DMA_BIT_MASK(32))
 			dma64 = 1;
 	}
-	if (!dma64 && pci_set_dma_mask(pDev, DMA_32BIT_MASK) != 0)
+	if (!dma64 && pci_set_dma_mask(pDev, DMA_BIT_MASK(32)) != 0)
 		return -EINVAL;
 
 	/* adapter only supports message blocks below 4GB */
-	pci_set_consistent_dma_mask(pDev, DMA_32BIT_MASK);
+	pci_set_consistent_dma_mask(pDev, DMA_BIT_MASK(32));
 
 	base_addr0_phys = pci_resource_start(pDev,0);
 	hba_map0_area_size = pci_resource_len(pDev,0);
diff -puN drivers/scsi/eata.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/eata.c
--- a/drivers/scsi/eata.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/eata.c
@@ -1426,7 +1426,7 @@ static int port_detect(unsigned long por
 
 	if (ha->pdev) {
 		pci_set_master(ha->pdev);
-		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK))
+		if (pci_set_dma_mask(ha->pdev, DMA_BIT_MASK(32)))
 			printk("%s: warning, pci_set_dma_mask failed.\n",
 			       ha->board_name);
 	}
diff -puN drivers/scsi/gdth.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/gdth.c
@@ -5023,7 +5023,7 @@ static int __devinit gdth_pci_probe_one(
 	/* 64-bit DMA only supported from FW >= x.43 */
 	if (!(ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) ||
 	    !ha->dma64_support) {
-		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 			printk(KERN_WARNING "GDT-PCI %d: "
 				"Unable to set 32-bit DMA\n", ha->hanum);
 				goto out_free_coal_stat;
@@ -5032,7 +5032,7 @@ static int __devinit gdth_pci_probe_one(
 		shp->max_cmd_len = 16;
 		if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 			printk("GDT-PCI %d: 64-bit DMA enabled\n", ha->hanum);
-		} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+		} else if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 			printk(KERN_WARNING "GDT-PCI %d: "
 				"Unable to set 64/32-bit DMA\n", ha->hanum);
 			goto out_free_coal_stat;
diff -puN drivers/scsi/hptiop.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/hptiop.c
@@ -959,7 +959,7 @@ static int __devinit hptiop_probe(struct
 
 	/* Enable 64bit DMA if possible */
 	if (pci_set_dma_mask(pcidev, DMA_BIT_MASK(64))) {
-		if (pci_set_dma_mask(pcidev, DMA_32BIT_MASK)) {
+		if (pci_set_dma_mask(pcidev, DMA_BIT_MASK(32))) {
 			printk(KERN_ERR "hptiop: fail to set dma_mask\n");
 			goto disable_pci_device;
 		}
diff -puN drivers/scsi/initio.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/initio.c
--- a/drivers/scsi/initio.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/initio.c
@@ -2856,7 +2856,7 @@ static int initio_probe_one(struct pci_d
 		reg = 0;
 	bios_seg = (bios_seg << 8) + ((u16) ((reg & 0xFF00) >> 8));
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_WARNING  "i91u: Could not set 32 bit DMA mask\n");
 		error = -ENODEV;
 		goto out_disable_device;
diff -puN drivers/scsi/ipr.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/ipr.c
@@ -7498,7 +7498,7 @@ static int __devinit ipr_probe_ioa(struc
 
 	pci_set_master(pdev);
 
-	rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Failed to set PCI DMA mask\n");
 		goto cleanup_nomem;
diff -puN drivers/scsi/ips.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/ips.c
@@ -7051,7 +7051,7 @@ ips_init_phase1(struct pci_dev *pci_dev,
 	    !pci_set_dma_mask(ha->pcidev, DMA_BIT_MASK(64))) {
 		(ha)->flags |= IPS_HA_ENH_SG;
 	} else {
-		if (pci_set_dma_mask(ha->pcidev, DMA_32BIT_MASK) != 0) {
+		if (pci_set_dma_mask(ha->pcidev, DMA_BIT_MASK(32)) != 0) {
 			printk(KERN_WARNING "Unable to set DMA Mask\n");
 			return ips_abort_init(ha, index);
 		}
diff -puN drivers/scsi/lasi700.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/lasi700.c
--- a/drivers/scsi/lasi700.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/lasi700.c
@@ -108,7 +108,7 @@ lasi700_probe(struct parisc_device *dev)
 	}
 
 	hostdata->dev = &dev->dev;
-	dma_set_mask(&dev->dev, DMA_32BIT_MASK);
+	dma_set_mask(&dev->dev, DMA_BIT_MASK(32));
 	hostdata->base = ioremap_nocache(base, 0x100);
 	hostdata->differential = 0;
 
diff -puN drivers/scsi/lpfc/lpfc_init.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -2661,7 +2661,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	pci_try_set_mwi(pdev);
 
 	if (pci_set_dma_mask(phba->pcidev, DMA_BIT_MASK(64)) != 0)
-		if (pci_set_dma_mask(phba->pcidev, DMA_32BIT_MASK) != 0)
+		if (pci_set_dma_mask(phba->pcidev, DMA_BIT_MASK(32)) != 0)
 			goto out_idr_remove;
 
 	/*
diff -puN drivers/scsi/megaraid.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/megaraid.c
@@ -2021,7 +2021,7 @@ make_local_pdev(adapter_t *adapter, stru
 
 	memcpy(*pdev, adapter->dev, sizeof(struct pci_dev));
 
-	if( pci_set_dma_mask(*pdev, DMA_32BIT_MASK) != 0 ) {
+	if( pci_set_dma_mask(*pdev, DMA_BIT_MASK(32)) != 0 ) {
 		kfree(*pdev);
 		return -1;
 	}
@@ -4796,7 +4796,7 @@ megaraid_probe_one(struct pci_dev *pdev,
 		pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 		adapter->has_64bit_addr = 1;
 	} else  {
-		pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		adapter->has_64bit_addr = 0;
 	}
 		
diff -puN drivers/scsi/megaraid/megaraid_mbox.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/megaraid/megaraid_mbox.c
@@ -473,7 +473,7 @@ megaraid_probe_one(struct pci_dev *pdev,
 
 	// Setup the default DMA mask. This would be changed later on
 	// depending on hardware capabilities
-	if (pci_set_dma_mask(adapter->pdev, DMA_32BIT_MASK) != 0) {
+	if (pci_set_dma_mask(adapter->pdev, DMA_BIT_MASK(32)) != 0) {
 
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid: pci_set_dma_mask failed:%d\n", __LINE__));
@@ -904,7 +904,7 @@ megaraid_init_mbox(adapter_t *adapter)
 			con_log(CL_ANN, (KERN_WARNING
 				"megaraid: DMA mask for 64-bit failed\n"));
 
-			if (pci_set_dma_mask (adapter->pdev, DMA_32BIT_MASK)) {
+			if (pci_set_dma_mask (adapter->pdev, DMA_BIT_MASK(32))) {
 				con_log(CL_ANN, (KERN_WARNING
 					"megaraid: 32-bit DMA mask failed\n"));
 				goto out_free_sysfs_res;
diff -puN drivers/scsi/megaraid/megaraid_sas.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -2499,11 +2499,11 @@ megasas_set_dma_mask(struct pci_dev *pde
 	if (IS_DMA64) {
 		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0) {
 
-			if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0)
+			if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
 				goto fail_set_dma_mask;
 		}
 	} else {
-		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0)
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
 			goto fail_set_dma_mask;
 	}
 	return 0;
diff -puN drivers/scsi/mvsas.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/mvsas.c
--- a/drivers/scsi/mvsas.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/mvsas.c
@@ -878,7 +878,7 @@ static int pci_go_64(struct pci_dev *pde
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (rc) {
-			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 			if (rc) {
 				dev_printk(KERN_ERR, &pdev->dev,
 					   "64-bit DMA enable failed\n");
@@ -886,13 +886,13 @@ static int pci_go_64(struct pci_dev *pde
 			}
 		}
 	} else {
-		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_printk(KERN_ERR, &pdev->dev,
 				   "32-bit DMA enable failed\n");
 			return rc;
 		}
-		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 			dev_printk(KERN_ERR, &pdev->dev,
 				   "32-bit consistent DMA enable failed\n");
diff -puN drivers/scsi/nsp32.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/nsp32.c
@@ -2672,7 +2672,7 @@ static int nsp32_detect(struct pci_dev *
 	/*
 	 * setup DMA 
 	 */
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) {
 		nsp32_msg (KERN_ERR, "failed to set PCI DMA mask");
 		goto scsi_unregister;
 	}
diff -puN drivers/scsi/qla1280.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/qla1280.c
@@ -4276,7 +4276,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 
 #ifdef QLA_64BIT_PTR
 	if (pci_set_dma_mask(ha->pdev, DMA_BIT_MASK(64))) {
-		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
+		if (pci_set_dma_mask(ha->pdev, DMA_BIT_MASK(32))) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no);
 			error = -ENODEV;
@@ -4286,7 +4286,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",
 			ha->host_no);
 #else
-	if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(ha->pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_WARNING "scsi(%li): Unable to set a "
 		       "suitable DMA mask - aborting\n", ha->host_no);
 		error = -ENODEV;
diff -puN drivers/scsi/qla2xxx/qla_os.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/qla2xxx/qla_os.c
@@ -1188,8 +1188,8 @@ qla2x00_config_dma_addressing(struct qla
 		}
 	}
 
-	dma_set_mask(&ha->pdev->dev, DMA_32BIT_MASK);
-	pci_set_consistent_dma_mask(ha->pdev, DMA_32BIT_MASK);
+	dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(32));
+	pci_set_consistent_dma_mask(ha->pdev, DMA_BIT_MASK(32));
 }
 
 static void
diff -puN drivers/scsi/qla4xxx/ql4_os.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/qla4xxx/ql4_os.c
--- a/drivers/scsi/qla4xxx/ql4_os.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/qla4xxx/ql4_os.c
@@ -1375,10 +1375,10 @@ static void qla4xxx_config_dma_addressin
 				  "Failed to set 64 bit PCI consistent mask; "
 				   "using 32 bit.\n");
 			retval = pci_set_consistent_dma_mask(ha->pdev,
-							     DMA_32BIT_MASK);
+							     DMA_BIT_MASK(32));
 		}
 	} else
-		retval = pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK);
+		retval = pci_set_dma_mask(ha->pdev, DMA_BIT_MASK(32));
 }
 
 static int qla4xxx_slave_alloc(struct scsi_device *sdev)
diff -puN drivers/scsi/sni_53c710.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/sni_53c710.c
--- a/drivers/scsi/sni_53c710.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/sni_53c710.c
@@ -83,7 +83,7 @@ static int __init snirm710_probe(struct 
 	}
 
 	hostdata->dev = &dev->dev;
-	dma_set_mask(&dev->dev, DMA_32BIT_MASK);
+	dma_set_mask(&dev->dev, DMA_BIT_MASK(32));
 	hostdata->base = ioremap_nocache(base, 0x100);
 	hostdata->differential = 0;
 
diff -puN drivers/scsi/stex.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/stex.c
--- a/drivers/scsi/stex.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/stex.c
@@ -1398,9 +1398,9 @@ static int stex_set_dma_mask(struct pci_
 	if (!pci_set_dma_mask(pdev,  DMA_BIT_MASK(64))
 		&& !pci_set_consistent_dma_mask(pdev,  DMA_BIT_MASK(64)))
 		return 0;
-	ret = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (!ret)
-		ret = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	return ret;
 }
 
diff -puN drivers/scsi/sym53c8xx_2/sym_glue.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1349,7 +1349,7 @@ static struct Scsi_Host * __devinit sym_
 	if ((SYM_CONF_DMA_ADDRESSING_MODE > 0) && (np->features & FE_DAC) &&
 			!pci_set_dma_mask(pdev, DMA_DAC_MASK)) {
 		set_dac(np);
-	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	} else if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printf_warning("%s: No suitable DMA available\n", sym_name(np));
 		goto attach_failed;
 	}
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.h~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/scsi/sym53c8xx_2/sym_hipd.h
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1080,7 +1080,7 @@ int sym_hcb_attach(struct Scsi_Host *sho
  */
 
 #if   SYM_CONF_DMA_ADDRESSING_MODE == 0
-#define DMA_DAC_MASK	DMA_32BIT_MASK
+#define DMA_DAC_MASK	DMA_BIT_MASK(32)
 #define sym_build_sge(np, data, badd, len)	\
 do {						\
 	(data)->addr = cpu_to_scr(badd);	\
diff -puN drivers/staging/agnx/pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/staging/agnx/pci.c
--- a/drivers/staging/agnx/pci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/staging/agnx/pci.c
@@ -477,8 +477,8 @@ static int __devinit agnx_pci_probe(stru
 		return err;
 	}
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) ||
-	    pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
+	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_ERR PFX "No suitable DMA available\n");
 		goto err_free_reg;
 	}
diff -puN drivers/staging/altpciechdma/altpciechdma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/staging/altpciechdma/altpciechdma.c
--- a/drivers/staging/altpciechdma/altpciechdma.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/staging/altpciechdma/altpciechdma.c
@@ -855,9 +855,9 @@ static int __devinit probe(struct pci_de
 		printk(KERN_DEBUG "Using a 64-bit DMA mask.\n");
 	} else
 #endif
-	if (!pci_set_dma_mask(dev, DMA_32BIT_MASK)) {
+	if (!pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
 		printk(KERN_DEBUG "Could not set 64-bit DMA mask.\n");
-		pci_set_consistent_dma_mask(dev, DMA_32BIT_MASK);
+		pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(32));
 		/* use 32-bit DMA */
 		printk(KERN_DEBUG "Using a 32-bit DMA mask.\n");
 	} else {
diff -puN drivers/staging/sxg/sxg.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/staging/sxg/sxg.c
--- a/drivers/staging/sxg/sxg.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/staging/sxg/sxg.c
@@ -937,13 +937,13 @@ static int sxg_entry_probe(struct pci_de
 	if (!(err = pci_set_dma_mask(pcidev, DMA_BIT_MASK(64)))) {
 		DBG_ERROR("pci_set_dma_mask(DMA_BIT_MASK(64)) successful\n");
 	} else {
-		if ((err = pci_set_dma_mask(pcidev, DMA_32BIT_MASK))) {
+		if ((err = pci_set_dma_mask(pcidev, DMA_BIT_MASK(32)))) {
 			DBG_ERROR
 			    ("No usable DMA configuration, aborting  err[%x]\n",
 			     err);
 			return err;
 		}
-		DBG_ERROR("pci_set_dma_mask(DMA_32BIT_MASK) successful\n");
+		DBG_ERROR("pci_set_dma_mask(DMA_BIT_MASK(32)) successful\n");
 	}
 
 	DBG_ERROR("Call pci_request_regions\n");
diff -puN drivers/usb/host/ehci-ps3.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/usb/host/ehci-ps3.c
--- a/drivers/usb/host/ehci-ps3.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/usb/host/ehci-ps3.c
@@ -81,7 +81,7 @@ static int ps3_ehci_probe(struct ps3_sys
 	int result;
 	struct usb_hcd *hcd;
 	unsigned int virq;
-	static u64 dummy_mask = DMA_32BIT_MASK;
+	static u64 dummy_mask = DMA_BIT_MASK(32);
 
 	if (usb_disabled()) {
 		result = -ENODEV;
diff -puN drivers/usb/host/ohci-ps3.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/usb/host/ohci-ps3.c
--- a/drivers/usb/host/ohci-ps3.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/usb/host/ohci-ps3.c
@@ -80,7 +80,7 @@ static int ps3_ohci_probe(struct ps3_sys
 	int result;
 	struct usb_hcd *hcd;
 	unsigned int virq;
-	static u64 dummy_mask = DMA_32BIT_MASK;
+	static u64 dummy_mask = DMA_BIT_MASK(32);
 
 	if (usb_disabled()) {
 		result = -ENODEV;
diff -puN drivers/uwb/whci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 drivers/uwb/whci.c
--- a/drivers/uwb/whci.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/drivers/uwb/whci.c
@@ -162,8 +162,8 @@ static int whci_probe(struct pci_dev *pc
 	err = -ENXIO;
 	if (!pci_set_dma_mask(pci, DMA_BIT_MASK(64)))
 		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(64));
-	else if (!pci_set_dma_mask(pci, DMA_32BIT_MASK))
-		pci_set_consistent_dma_mask(pci, DMA_32BIT_MASK);
+	else if (!pci_set_dma_mask(pci, DMA_BIT_MASK(32)))
+		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32));
 	else
 		goto error_dma;
 
diff -puN include/linux/dma-mapping.h~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/include/linux/dma-mapping.h
@@ -115,7 +115,7 @@ static inline u64 dma_get_mask(struct de
 {
 	if (dev && dev->dma_mask && *dev->dma_mask)
 		return *dev->dma_mask;
-	return DMA_32BIT_MASK;
+	return DMA_BIT_MASK(32);
 }
 
 extern u64 dma_get_required_mask(struct device *dev);
diff -puN lib/swiotlb.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 lib/swiotlb.c
--- a/lib/swiotlb.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/lib/swiotlb.c
@@ -549,7 +549,7 @@ swiotlb_alloc_coherent(struct device *hw
 	dma_addr_t dev_addr;
 	void *ret;
 	int order = get_order(size);
-	u64 dma_mask = DMA_32BIT_MASK;
+	u64 dma_mask = DMA_BIT_MASK(32);
 
 	if (hwdev && hwdev->coherent_dma_mask)
 		dma_mask = hwdev->coherent_dma_mask;
diff -puN sound/pci/ad1889.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 sound/pci/ad1889.c
--- a/sound/pci/ad1889.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/sound/pci/ad1889.c
@@ -909,8 +909,8 @@ snd_ad1889_create(struct snd_card *card,
 		return err;
 
 	/* check PCI availability (32bit DMA) */
-	if (pci_set_dma_mask(pci, DMA_32BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_32BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(32)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32)) < 0) {
 		printk(KERN_ERR PFX "error setting 32-bit DMA mask.\n");
 		pci_disable_device(pci);
 		return -ENXIO;
diff -puN sound/pci/au88x0/au88x0.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 sound/pci/au88x0/au88x0.c
--- a/sound/pci/au88x0/au88x0.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/sound/pci/au88x0/au88x0.c
@@ -151,8 +151,8 @@ snd_vortex_create(struct snd_card *card,
 	// check PCI availability (DMA).
 	if ((err = pci_enable_device(pci)) < 0)
 		return err;
-	if (pci_set_dma_mask(pci, DMA_32BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_32BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(32)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32)) < 0) {
 		printk(KERN_ERR "error to set DMA mask\n");
 		pci_disable_device(pci);
 		return -ENXIO;
diff -puN sound/pci/aw2/aw2-alsa.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 sound/pci/aw2/aw2-alsa.c
--- a/sound/pci/aw2/aw2-alsa.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/sound/pci/aw2/aw2-alsa.c
@@ -279,8 +279,8 @@ static int __devinit snd_aw2_create(stru
 	pci_set_master(pci);
 
 	/* check PCI availability (32bit DMA) */
-	if ((pci_set_dma_mask(pci, DMA_32BIT_MASK) < 0) ||
-	    (pci_set_consistent_dma_mask(pci, DMA_32BIT_MASK) < 0)) {
+	if ((pci_set_dma_mask(pci, DMA_BIT_MASK(32)) < 0) ||
+	    (pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32)) < 0)) {
 		printk(KERN_ERR "aw2: Impossible to set 32bit mask DMA\n");
 		pci_disable_device(pci);
 		return -ENXIO;
diff -puN sound/pci/ca0106/ca0106_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 sound/pci/ca0106/ca0106_main.c
--- a/sound/pci/ca0106/ca0106_main.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/sound/pci/ca0106/ca0106_main.c
@@ -1589,8 +1589,8 @@ static int __devinit snd_ca0106_create(i
 	err = pci_enable_device(pci);
 	if (err < 0)
 		return err;
-	if (pci_set_dma_mask(pci, DMA_32BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_32BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(32)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32)) < 0) {
 		printk(KERN_ERR "error to set 32bit mask DMA\n");
 		pci_disable_device(pci);
 		return -ENXIO;
diff -puN sound/pci/cs5535audio/cs5535audio.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 sound/pci/cs5535audio/cs5535audio.c
--- a/sound/pci/cs5535audio/cs5535audio.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/sound/pci/cs5535audio/cs5535audio.c
@@ -285,8 +285,8 @@ static int __devinit snd_cs5535audio_cre
 	if ((err = pci_enable_device(pci)) < 0)
 		return err;
 
-	if (pci_set_dma_mask(pci, DMA_32BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_32BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(32)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32)) < 0) {
 		printk(KERN_WARNING "unable to get 32bit dma\n");
 		err = -ENXIO;
 		goto pcifail;
diff -puN sound/pci/mixart/mixart.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 sound/pci/mixart/mixart.c
--- a/sound/pci/mixart/mixart.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/sound/pci/mixart/mixart.c
@@ -1291,7 +1291,7 @@ static int __devinit snd_mixart_probe(st
 	pci_set_master(pci);
 
 	/* check if we can restrict PCI DMA transfers to 32 bits */
-	if (pci_set_dma_mask(pci, DMA_32BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(32)) < 0) {
 		snd_printk(KERN_ERR "architecture does not support 32bit PCI busmaster DMA\n");
 		pci_disable_device(pci);
 		return -ENXIO;
diff -puN sound/pci/pcxhr/pcxhr.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 sound/pci/pcxhr/pcxhr.c
--- a/sound/pci/pcxhr/pcxhr.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/sound/pci/pcxhr/pcxhr.c
@@ -1449,7 +1449,7 @@ static int __devinit pcxhr_probe(struct 
 	pci_set_master(pci);
 
 	/* check if we can restrict PCI DMA transfers to 32 bits */
-	if (pci_set_dma_mask(pci, DMA_32BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(32)) < 0) {
 		snd_printk(KERN_ERR "architecture does not support "
 			   "32bit PCI busmaster DMA\n");
 		pci_disable_device(pci);
diff -puN sound/soc/blackfin/bf5xx-ac97-pcm.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 sound/soc/blackfin/bf5xx-ac97-pcm.c
--- a/sound/soc/blackfin/bf5xx-ac97-pcm.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/sound/soc/blackfin/bf5xx-ac97-pcm.c
@@ -413,7 +413,7 @@ static void bf5xx_pcm_free_dma_buffers(s
 		sport_done(sport_handle);
 }
 
-static u64 bf5xx_pcm_dmamask = DMA_32BIT_MASK;
+static u64 bf5xx_pcm_dmamask = DMA_BIT_MASK(32);
 
 int bf5xx_pcm_ac97_new(struct snd_card *card, struct snd_soc_dai *dai,
 	struct snd_pcm *pcm)
@@ -424,7 +424,7 @@ int bf5xx_pcm_ac97_new(struct snd_card *
 	if (!card->dev->dma_mask)
 		card->dev->dma_mask = &bf5xx_pcm_dmamask;
 	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_32BIT_MASK;
+		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
 
 	if (dai->playback.channels_min) {
 		ret = bf5xx_pcm_preallocate_dma_buffer(pcm,
diff -puN sound/soc/blackfin/bf5xx-i2s-pcm.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 sound/soc/blackfin/bf5xx-i2s-pcm.c
--- a/sound/soc/blackfin/bf5xx-i2s-pcm.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/sound/soc/blackfin/bf5xx-i2s-pcm.c
@@ -245,7 +245,7 @@ static void bf5xx_pcm_free_dma_buffers(s
 		sport_done(sport_handle);
 }
 
-static u64 bf5xx_pcm_dmamask = DMA_32BIT_MASK;
+static u64 bf5xx_pcm_dmamask = DMA_BIT_MASK(32);
 
 int bf5xx_pcm_i2s_new(struct snd_card *card, struct snd_soc_dai *dai,
 	struct snd_pcm *pcm)
@@ -256,7 +256,7 @@ int bf5xx_pcm_i2s_new(struct snd_card *c
 	if (!card->dev->dma_mask)
 		card->dev->dma_mask = &bf5xx_pcm_dmamask;
 	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_32BIT_MASK;
+		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
 
 	if (dai->playback.channels_min) {
 		ret = bf5xx_pcm_preallocate_dma_buffer(pcm,
diff -puN sound/soc/omap/omap-pcm.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 sound/soc/omap/omap-pcm.c
--- a/sound/soc/omap/omap-pcm.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/sound/soc/omap/omap-pcm.c
@@ -327,7 +327,7 @@ int omap_pcm_new(struct snd_card *card, 
 	if (!card->dev->dma_mask)
 		card->dev->dma_mask = &omap_pcm_dmamask;
 	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_32BIT_MASK;
+		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
 
 	if (dai->playback.channels_min) {
 		ret = omap_pcm_preallocate_dma_buffer(pcm,
diff -puN sound/soc/pxa/pxa2xx-pcm.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 sound/soc/pxa/pxa2xx-pcm.c
--- a/sound/soc/pxa/pxa2xx-pcm.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/sound/soc/pxa/pxa2xx-pcm.c
@@ -81,7 +81,7 @@ static struct snd_pcm_ops pxa2xx_pcm_ops
 	.mmap		= pxa2xx_pcm_mmap,
 };
 
-static u64 pxa2xx_pcm_dmamask = DMA_32BIT_MASK;
+static u64 pxa2xx_pcm_dmamask = DMA_BIT_MASK(32);
 
 static int pxa2xx_soc_pcm_new(struct snd_card *card, struct snd_soc_dai *dai,
 	struct snd_pcm *pcm)
@@ -91,7 +91,7 @@ static int pxa2xx_soc_pcm_new(struct snd
 	if (!card->dev->dma_mask)
 		card->dev->dma_mask = &pxa2xx_pcm_dmamask;
 	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_32BIT_MASK;
+		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
 
 	if (dai->playback.channels_min) {
 		ret = pxa2xx_pcm_preallocate_dma_buffer(pcm,
diff -puN sound/soc/s3c24xx/s3c24xx-pcm.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32 sound/soc/s3c24xx/s3c24xx-pcm.c
--- a/sound/soc/s3c24xx/s3c24xx-pcm.c~replace-all-dma_32bit_mask-macro-with-dma_bit_mask32
+++ a/sound/soc/s3c24xx/s3c24xx-pcm.c
@@ -419,7 +419,7 @@ static void s3c24xx_pcm_free_dma_buffers
 	}
 }
 
-static u64 s3c24xx_pcm_dmamask = DMA_32BIT_MASK;
+static u64 s3c24xx_pcm_dmamask = DMA_BIT_MASK(32);
 
 static int s3c24xx_pcm_new(struct snd_card *card,
 	struct snd_soc_dai *dai, struct snd_pcm *pcm)
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

origin.patch

