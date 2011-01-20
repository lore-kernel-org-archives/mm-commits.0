From: akpm@linux-foundation.org
Subject: + kconfig-rename-config_embedded-to-config_expert.patch added to -mm tree
Date: Thu, 20 Jan 2011 12:32:25 -0800
Message-ID: <201101202032.p0KKWPA6000705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754686Ab1ATUdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 15:33:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, arnd@arndb.de, axboe@kernel.dk, davem@davemloft.net, david.woodhouse@intel.com, gregkh@suse.de, holt@sgi.com, linux-arch@vger.kernel.org, mingo@elte.hu


The patch titled
     kconfig: rename CONFIG_EMBEDDED to CONFIG_EXPERT
has been added to the -mm tree.  Its filename is
     kconfig-rename-config_embedded-to-config_expert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig: rename CONFIG_EMBEDDED to CONFIG_EXPERT
From: David Rientjes <rientjes@google.com>

The meaning of CONFIG_EMBEDDED has long since been obsoleted; the option
is used to configure any non-standard kernel with a much larger scope than
only small devices.

This patch renames the option to CONFIG_EXPERT in init/Kconfig and fixes
references to the option throughout the kernel.  A new CONFIG_EMBEDDED
option is added that automatically selects CONFIG_EXPERT when enabled and
can be used in the future to isolate options that should only be
considered for embedded systems (RISC architectures, SLOB, etc).

Calling the option "EXPERT" more accurately represents its intention: only
expert users who understand the impact of the configuration changes they
are making should enable it.

Reviewed-by: Ingo Molnar <mingo@elte.hu>
Acked-by: David Woodhouse <david.woodhouse@intel.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Greg KH <gregkh@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Robin Holt <holt@sgi.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/ag5evm_defconfig                 |    2 
 arch/arm/configs/am200epdkit_defconfig            |    2 
 arch/arm/configs/at572d940hfek_defconfig          |    2 
 arch/arm/configs/badge4_defconfig                 |    2 
 arch/arm/configs/bcmring_defconfig                |    2 
 arch/arm/configs/cm_x2xx_defconfig                |    2 
 arch/arm/configs/colibri_pxa270_defconfig         |    2 
 arch/arm/configs/collie_defconfig                 |    2 
 arch/arm/configs/corgi_defconfig                  |    2 
 arch/arm/configs/da8xx_omapl_defconfig            |    2 
 arch/arm/configs/davinci_all_defconfig            |    2 
 arch/arm/configs/dove_defconfig                   |    2 
 arch/arm/configs/ebsa110_defconfig                |    2 
 arch/arm/configs/edb7211_defconfig                |    2 
 arch/arm/configs/em_x270_defconfig                |    2 
 arch/arm/configs/ep93xx_defconfig                 |    2 
 arch/arm/configs/eseries_pxa_defconfig            |    2 
 arch/arm/configs/ezx_defconfig                    |    2 
 arch/arm/configs/footbridge_defconfig             |    2 
 arch/arm/configs/fortunet_defconfig               |    2 
 arch/arm/configs/h5000_defconfig                  |    2 
 arch/arm/configs/imote2_defconfig                 |    2 
 arch/arm/configs/ixp2000_defconfig                |    2 
 arch/arm/configs/ixp23xx_defconfig                |    2 
 arch/arm/configs/ixp4xx_defconfig                 |    2 
 arch/arm/configs/loki_defconfig                   |    2 
 arch/arm/configs/lpd7a400_defconfig               |    2 
 arch/arm/configs/lpd7a404_defconfig               |    2 
 arch/arm/configs/magician_defconfig               |    2 
 arch/arm/configs/mv78xx0_defconfig                |    2 
 arch/arm/configs/mx1_defconfig                    |    2 
 arch/arm/configs/mx21_defconfig                   |    2 
 arch/arm/configs/mx27_defconfig                   |    2 
 arch/arm/configs/mx3_defconfig                    |    2 
 arch/arm/configs/mx51_defconfig                   |    2 
 arch/arm/configs/nhk8815_defconfig                |    2 
 arch/arm/configs/omap1_defconfig                  |    2 
 arch/arm/configs/omap2plus_defconfig              |    2 
 arch/arm/configs/orion5x_defconfig                |    2 
 arch/arm/configs/pcm027_defconfig                 |    2 
 arch/arm/configs/pcontrol_g20_defconfig           |    2 
 arch/arm/configs/pleb_defconfig                   |    2 
 arch/arm/configs/pnx4008_defconfig                |    2 
 arch/arm/configs/simpad_defconfig                 |    2 
 arch/arm/configs/spitz_defconfig                  |    2 
 arch/arm/configs/stmp378x_defconfig               |    2 
 arch/arm/configs/stmp37xx_defconfig               |    2 
 arch/arm/configs/tct_hammer_defconfig             |    2 
 arch/arm/configs/trizeps4_defconfig               |    2 
 arch/arm/configs/u300_defconfig                   |    2 
 arch/arm/configs/viper_defconfig                  |    2 
 arch/arm/configs/xcep_defconfig                   |    2 
 arch/avr32/Kconfig                                |    4 
 arch/blackfin/configs/BF518F-EZBRD_defconfig      |    2 
 arch/blackfin/configs/BF526-EZBRD_defconfig       |    2 
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig |    2 
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig    |    2 
 arch/blackfin/configs/BF527-EZKIT_defconfig       |    2 
 arch/blackfin/configs/BF527-TLL6527M_defconfig    |    2 
 arch/blackfin/configs/BF533-EZKIT_defconfig       |    2 
 arch/blackfin/configs/BF533-STAMP_defconfig       |    2 
 arch/blackfin/configs/BF537-STAMP_defconfig       |    2 
 arch/blackfin/configs/BF538-EZKIT_defconfig       |    2 
 arch/blackfin/configs/BF548-EZKIT_defconfig       |    2 
 arch/blackfin/configs/BF561-ACVILON_defconfig     |    2 
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig   |    2 
 arch/blackfin/configs/BF561-EZKIT_defconfig       |    2 
 arch/blackfin/configs/BlackStamp_defconfig        |    2 
 arch/blackfin/configs/CM-BF527_defconfig          |    2 
 arch/blackfin/configs/CM-BF533_defconfig          |    2 
 arch/blackfin/configs/CM-BF537E_defconfig         |    2 
 arch/blackfin/configs/CM-BF537U_defconfig         |    2 
 arch/blackfin/configs/CM-BF548_defconfig          |    2 
 arch/blackfin/configs/CM-BF561_defconfig          |    2 
 arch/blackfin/configs/DNP5370_defconfig           |    2 
 arch/blackfin/configs/H8606_defconfig             |    2 
 arch/blackfin/configs/IP0X_defconfig              |    2 
 arch/blackfin/configs/PNAV-10_defconfig           |    2 
 arch/blackfin/configs/SRV1_defconfig              |    2 
 arch/blackfin/configs/TCM-BF518_defconfig         |    2 
 arch/blackfin/configs/TCM-BF537_defconfig         |    2 
 arch/cris/configs/artpec_3_defconfig              |    2 
 arch/cris/configs/etrax-100lx_v2_defconfig        |    2 
 arch/cris/configs/etraxfs_defconfig               |    2 
 arch/frv/defconfig                                |    2 
 arch/h8300/defconfig                              |    2 
 arch/m32r/configs/m32700ut.smp_defconfig          |    2 
 arch/m32r/configs/m32700ut.up_defconfig           |    2 
 arch/m32r/configs/mappi.nommu_defconfig           |    2 
 arch/m32r/configs/mappi.smp_defconfig             |    2 
 arch/m32r/configs/mappi.up_defconfig              |    2 
 arch/m32r/configs/mappi2.opsp_defconfig           |    2 
 arch/m32r/configs/mappi2.vdec2_defconfig          |    2 
 arch/m32r/configs/mappi3.smp_defconfig            |    2 
 arch/m32r/configs/oaks32r_defconfig               |    2 
 arch/m32r/configs/opsput_defconfig                |    2 
 arch/m32r/configs/usrv_defconfig                  |    2 
 arch/m68knommu/configs/m5208evb_defconfig         |    2 
 arch/m68knommu/configs/m5249evb_defconfig         |    2 
 arch/m68knommu/configs/m5272c3_defconfig          |    2 
 arch/m68knommu/configs/m5275evb_defconfig         |    2 
 arch/m68knommu/configs/m5307c3_defconfig          |    2 
 arch/m68knommu/configs/m5407c3_defconfig          |    2 
 arch/m68knommu/defconfig                          |    2 
 arch/microblaze/configs/mmu_defconfig             |    2 
 arch/microblaze/configs/nommu_defconfig           |    2 
 arch/mips/Kconfig.debug                           |    2 
 arch/mips/configs/ar7_defconfig                   |    2 
 arch/mips/configs/bcm47xx_defconfig               |    2 
 arch/mips/configs/bcm63xx_defconfig               |    2 
 arch/mips/configs/bigsur_defconfig                |    2 
 arch/mips/configs/capcella_defconfig              |    2 
 arch/mips/configs/cavium-octeon_defconfig         |    2 
 arch/mips/configs/cobalt_defconfig                |    2 
 arch/mips/configs/db1000_defconfig                |    2 
 arch/mips/configs/db1100_defconfig                |    2 
 arch/mips/configs/db1200_defconfig                |    2 
 arch/mips/configs/db1500_defconfig                |    2 
 arch/mips/configs/db1550_defconfig                |    2 
 arch/mips/configs/decstation_defconfig            |    2 
 arch/mips/configs/e55_defconfig                   |    2 
 arch/mips/configs/fuloong2e_defconfig             |    2 
 arch/mips/configs/gpr_defconfig                   |    2 
 arch/mips/configs/ip22_defconfig                  |    2 
 arch/mips/configs/ip27_defconfig                  |    2 
 arch/mips/configs/ip28_defconfig                  |    2 
 arch/mips/configs/ip32_defconfig                  |    2 
 arch/mips/configs/jazz_defconfig                  |    2 
 arch/mips/configs/jmr3927_defconfig               |    2 
 arch/mips/configs/lasat_defconfig                 |    2 
 arch/mips/configs/lemote2f_defconfig              |    2 
 arch/mips/configs/malta_defconfig                 |    2 
 arch/mips/configs/markeins_defconfig              |    2 
 arch/mips/configs/mipssim_defconfig               |    2 
 arch/mips/configs/mpc30x_defconfig                |    2 
 arch/mips/configs/msp71xx_defconfig               |    2 
 arch/mips/configs/mtx1_defconfig                  |    2 
 arch/mips/configs/pb1100_defconfig                |    2 
 arch/mips/configs/pb1200_defconfig                |    2 
 arch/mips/configs/pb1500_defconfig                |    2 
 arch/mips/configs/pb1550_defconfig                |    2 
 arch/mips/configs/pnx8335-stb225_defconfig        |    2 
 arch/mips/configs/pnx8550-jbs_defconfig           |    2 
 arch/mips/configs/pnx8550-stb810_defconfig        |    2 
 arch/mips/configs/powertv_defconfig               |    2 
 arch/mips/configs/rb532_defconfig                 |    2 
 arch/mips/configs/rbtx49xx_defconfig              |    2 
 arch/mips/configs/rm200_defconfig                 |    2 
 arch/mips/configs/sb1250-swarm_defconfig          |    2 
 arch/mips/configs/tb0219_defconfig                |    2 
 arch/mips/configs/tb0226_defconfig                |    2 
 arch/mips/configs/tb0287_defconfig                |    2 
 arch/mips/configs/workpad_defconfig               |    2 
 arch/mips/configs/wrppmc_defconfig                |    2 
 arch/mips/configs/yosemite_defconfig              |    2 
 arch/mn10300/configs/asb2303_defconfig            |    2 
 arch/mn10300/configs/asb2364_defconfig            |    2 
 arch/parisc/configs/a500_defconfig                |    2 
 arch/parisc/configs/c3000_defconfig               |    2 
 arch/powerpc/configs/40x/acadia_defconfig         |    2 
 arch/powerpc/configs/40x/ep405_defconfig          |    2 
 arch/powerpc/configs/40x/hcu4_defconfig           |    2 
 arch/powerpc/configs/40x/kilauea_defconfig        |    2 
 arch/powerpc/configs/40x/makalu_defconfig         |    2 
 arch/powerpc/configs/40x/walnut_defconfig         |    2 
 arch/powerpc/configs/44x/arches_defconfig         |    2 
 arch/powerpc/configs/44x/bamboo_defconfig         |    2 
 arch/powerpc/configs/44x/bluestone_defconfig      |    2 
 arch/powerpc/configs/44x/canyonlands_defconfig    |    2 
 arch/powerpc/configs/44x/ebony_defconfig          |    2 
 arch/powerpc/configs/44x/eiger_defconfig          |    2 
 arch/powerpc/configs/44x/icon_defconfig           |    2 
 arch/powerpc/configs/44x/iss476-smp_defconfig     |    2 
 arch/powerpc/configs/44x/katmai_defconfig         |    2 
 arch/powerpc/configs/44x/rainier_defconfig        |    2 
 arch/powerpc/configs/44x/redwood_defconfig        |    2 
 arch/powerpc/configs/44x/sam440ep_defconfig       |    2 
 arch/powerpc/configs/44x/sequoia_defconfig        |    2 
 arch/powerpc/configs/44x/taishan_defconfig        |    2 
 arch/powerpc/configs/44x/warp_defconfig           |    2 
 arch/powerpc/configs/52xx/cm5200_defconfig        |    2 
 arch/powerpc/configs/52xx/lite5200b_defconfig     |    2 
 arch/powerpc/configs/52xx/motionpro_defconfig     |    2 
 arch/powerpc/configs/52xx/pcm030_defconfig        |    2 
 arch/powerpc/configs/52xx/tqm5200_defconfig       |    2 
 arch/powerpc/configs/83xx/asp8347_defconfig       |    2 
 arch/powerpc/configs/83xx/kmeter1_defconfig       |    2 
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |    2 
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |    2 
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |    2 
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |    2 
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |    2 
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |    2 
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |    2 
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |    2 
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   |    2 
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |    2 
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |    2 
 arch/powerpc/configs/83xx/sbc834x_defconfig       |    2 
 arch/powerpc/configs/85xx/ksi8560_defconfig       |    2 
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |    2 
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |    2 
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |    2 
 arch/powerpc/configs/85xx/sbc8548_defconfig       |    2 
 arch/powerpc/configs/85xx/sbc8560_defconfig       |    2 
 arch/powerpc/configs/85xx/socrates_defconfig      |    2 
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |    2 
 arch/powerpc/configs/85xx/tqm8540_defconfig       |    2 
 arch/powerpc/configs/85xx/tqm8541_defconfig       |    2 
 arch/powerpc/configs/85xx/tqm8548_defconfig       |    2 
 arch/powerpc/configs/85xx/tqm8555_defconfig       |    2 
 arch/powerpc/configs/85xx/tqm8560_defconfig       |    2 
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig   |    2 
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig     |    2 
 arch/powerpc/configs/86xx/gef_sbc310_defconfig    |    2 
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    |    2 
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  |    2 
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  |    2 
 arch/powerpc/configs/86xx/sbc8641d_defconfig      |    2 
 arch/powerpc/configs/adder875_defconfig           |    2 
 arch/powerpc/configs/e55xx_smp_defconfig          |    2 
 arch/powerpc/configs/ep8248e_defconfig            |    2 
 arch/powerpc/configs/ep88xc_defconfig             |    2 
 arch/powerpc/configs/gamecube_defconfig           |    2 
 arch/powerpc/configs/holly_defconfig              |    2 
 arch/powerpc/configs/mgcoge_defconfig             |    2 
 arch/powerpc/configs/mgsuvd_defconfig             |    2 
 arch/powerpc/configs/mpc7448_hpc2_defconfig       |    2 
 arch/powerpc/configs/mpc8272_ads_defconfig        |    2 
 arch/powerpc/configs/mpc83xx_defconfig            |    2 
 arch/powerpc/configs/mpc85xx_defconfig            |    2 
 arch/powerpc/configs/mpc85xx_smp_defconfig        |    2 
 arch/powerpc/configs/mpc866_ads_defconfig         |    2 
 arch/powerpc/configs/mpc86xx_defconfig            |    2 
 arch/powerpc/configs/mpc885_ads_defconfig         |    2 
 arch/powerpc/configs/ppc40x_defconfig             |    2 
 arch/powerpc/configs/ppc44x_defconfig             |    2 
 arch/powerpc/configs/pq2fads_defconfig            |    2 
 arch/powerpc/configs/ps3_defconfig                |    2 
 arch/powerpc/configs/storcenter_defconfig         |    2 
 arch/powerpc/configs/tqm8xx_defconfig             |    2 
 arch/powerpc/configs/wii_defconfig                |    2 
 arch/powerpc/platforms/iseries/Kconfig            |    2 
 arch/powerpc/platforms/pseries/Kconfig            |    6 -
 arch/score/configs/spct6600_defconfig             |    2 
 arch/sh/Kconfig                                   |    2 
 arch/tile/Kconfig                                 |    2 
 arch/tile/Kconfig.debug                           |    2 
 arch/tile/configs/tile_defconfig                  |    2 
 arch/um/defconfig                                 |    2 
 arch/x86/Kconfig                                  |   20 +--
 arch/x86/Kconfig.cpu                              |    2 
 arch/x86/Kconfig.debug                            |    4 
 arch/xtensa/configs/common_defconfig              |    2 
 arch/xtensa/configs/iss_defconfig                 |    2 
 arch/xtensa/configs/s6105_defconfig               |    2 
 block/Kconfig                                     |    2 
 drivers/acpi/Kconfig                              |    2 
 drivers/ata/Kconfig                               |    2 
 drivers/base/Kconfig                              |    2 
 drivers/char/Kconfig                              |   10 -
 drivers/cpufreq/Kconfig                           |    2 
 drivers/firmware/Kconfig                          |    2 
 drivers/gpu/drm/Kconfig                           |    2 
 drivers/gpu/drm/drm_fb_helper.c                   |    4 
 drivers/gpu/drm/nouveau/Kconfig                   |    2 
 drivers/gpu/vga/Kconfig                           |    2 
 drivers/hid/Kconfig                               |   64 ++++++------
 drivers/hid/usbhid/Kconfig                        |    2 
 drivers/ide/Kconfig                               |    2 
 drivers/infiniband/hw/mthca/Kconfig               |    2 
 drivers/infiniband/ulp/ipoib/Kconfig              |    2 
 drivers/input/Kconfig                             |    6 -
 drivers/input/keyboard/Kconfig                    |    4 
 drivers/input/mouse/Kconfig                       |   10 -
 drivers/input/serio/Kconfig                       |    6 -
 drivers/input/touchscreen/Kconfig                 |   30 ++---
 drivers/media/common/tuners/Kconfig               |    2 
 drivers/media/dvb/frontends/Kconfig               |    2 
 drivers/media/video/Kconfig                       |    2 
 drivers/net/Kconfig                               |    2 
 drivers/pci/pcie/Kconfig                          |    2 
 drivers/pcmcia/Kconfig                            |   12 +-
 drivers/serial/Kconfig                            |    4 
 drivers/ssb/Kconfig                               |    2 
 drivers/usb/core/Kconfig                          |    6 -
 drivers/video/Kconfig                             |    2 
 drivers/video/console/Kconfig                     |    2 
 fs/Kconfig                                        |    2 
 fs/proc/Kconfig                                   |    6 -
 fs/sysfs/Kconfig                                  |    2 
 init/Kconfig                                      |   60 ++++++-----
 lib/Kconfig.debug                                 |    6 -
 lib/xz/Kconfig                                    |   12 +-
 net/mac80211/Kconfig                              |    6 -
 net/rfkill/Kconfig                                |    4 
 net/wireless/Kconfig                              |    2 
 usr/Kconfig                                       |   18 +--
 298 files changed, 431 insertions(+), 423 deletions(-)

diff -puN arch/arm/configs/ag5evm_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/ag5evm_defconfig
--- a/arch/arm/configs/ag5evm_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/ag5evm_defconfig
@@ -10,7 +10,7 @@ CONFIG_NAMESPACES=y
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_DEADLINE is not set
diff -puN arch/arm/configs/am200epdkit_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/am200epdkit_defconfig
--- a/arch/arm/configs/am200epdkit_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/am200epdkit_defconfig
@@ -3,7 +3,7 @@ CONFIG_LOCALVERSION="gum"
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_EPOLL is not set
 # CONFIG_SHMEM is not set
diff -puN arch/arm/configs/at572d940hfek_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/at572d940hfek_defconfig
--- a/arch/arm/configs/at572d940hfek_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/at572d940hfek_defconfig
@@ -17,7 +17,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
diff -puN arch/arm/configs/badge4_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/badge4_defconfig
--- a/arch/arm/configs/badge4_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/badge4_defconfig
@@ -1,6 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 CONFIG_ARCH_SA1100=y
diff -puN arch/arm/configs/bcmring_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/bcmring_defconfig
--- a/arch/arm/configs/bcmring_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/bcmring_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_ELF_CORE is not set
diff -puN arch/arm/configs/cm_x2xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/cm_x2xx_defconfig
--- a/arch/arm/configs/cm_x2xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/cm_x2xx_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
diff -puN arch/arm/configs/colibri_pxa270_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/colibri_pxa270_defconfig
--- a/arch/arm/configs/colibri_pxa270_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/colibri_pxa270_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/arm/configs/collie_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/collie_defconfig
--- a/arch/arm/configs/collie_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/collie_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BASE_FULL is not set
 # CONFIG_EPOLL is not set
 CONFIG_SLOB=y
diff -puN arch/arm/configs/corgi_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/corgi_defconfig
--- a/arch/arm/configs/corgi_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/corgi_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
 CONFIG_MODULES=y
diff -puN arch/arm/configs/da8xx_omapl_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/da8xx_omapl_defconfig
--- a/arch/arm/configs/da8xx_omapl_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/da8xx_omapl_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
diff -puN arch/arm/configs/davinci_all_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/davinci_all_defconfig
--- a/arch/arm/configs/davinci_all_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/davinci_all_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
diff -puN arch/arm/configs/dove_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/dove_defconfig
--- a/arch/arm/configs/dove_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/dove_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/arm/configs/ebsa110_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/ebsa110_defconfig
--- a/arch/arm/configs/ebsa110_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/ebsa110_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_ARCH_EBSA110=y
 CONFIG_PCCARD=m
diff -puN arch/arm/configs/edb7211_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/edb7211_defconfig
--- a/arch/arm/configs/edb7211_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/edb7211_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_ARCH_CLPS711X=y
 CONFIG_ARCH_EDB7211=y
diff -puN arch/arm/configs/em_x270_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/em_x270_defconfig
--- a/arch/arm/configs/em_x270_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/em_x270_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
diff -puN arch/arm/configs/ep93xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/ep93xx_defconfig
--- a/arch/arm/configs/ep93xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/ep93xx_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/arm/configs/eseries_pxa_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/eseries_pxa_defconfig
--- a/arch/arm/configs/eseries_pxa_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/eseries_pxa_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff -puN arch/arm/configs/ezx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/ezx_defconfig
--- a/arch/arm/configs/ezx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/ezx_defconfig
@@ -7,7 +7,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/arm/configs/footbridge_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/footbridge_defconfig
--- a/arch/arm/configs/footbridge_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/footbridge_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_MODULES=y
 CONFIG_ARCH_FOOTBRIDGE=y
diff -puN arch/arm/configs/fortunet_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/fortunet_defconfig
--- a/arch/arm/configs/fortunet_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/fortunet_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_ARCH_CLPS711X=y
 CONFIG_ARCH_FORTUNET=y
diff -puN arch/arm/configs/h5000_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/h5000_defconfig
--- a/arch/arm/configs/h5000_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/h5000_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/arm/configs/imote2_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/imote2_defconfig
--- a/arch/arm/configs/imote2_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/imote2_defconfig
@@ -6,7 +6,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/arm/configs/ixp2000_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/ixp2000_defconfig
--- a/arch/arm/configs/ixp2000_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/ixp2000_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/arm/configs/ixp23xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/ixp23xx_defconfig
--- a/arch/arm/configs/ixp23xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/ixp23xx_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/arm/configs/ixp4xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/ixp4xx_defconfig
--- a/arch/arm/configs/ixp4xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/ixp4xx_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/arm/configs/loki_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/loki_defconfig
--- a/arch/arm/configs/loki_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/loki_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/arm/configs/lpd7a400_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/lpd7a400_defconfig
--- a/arch/arm/configs/lpd7a400_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/lpd7a400_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
 # CONFIG_IOSCHED_DEADLINE is not set
diff -puN arch/arm/configs/lpd7a404_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/lpd7a404_defconfig
--- a/arch/arm/configs/lpd7a404_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/lpd7a404_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=16
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
 CONFIG_SLAB=y
diff -puN arch/arm/configs/magician_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/magician_defconfig
--- a/arch/arm/configs/magician_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/magician_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/arm/configs/mv78xx0_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/mv78xx0_defconfig
--- a/arch/arm/configs/mv78xx0_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/mv78xx0_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_PROFILING=y
diff -puN arch/arm/configs/mx1_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/mx1_defconfig
--- a/arch/arm/configs/mx1_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/mx1_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/arm/configs/mx21_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/mx21_defconfig
--- a/arch/arm/configs/mx21_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/mx21_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/arm/configs/mx27_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/mx27_defconfig
--- a/arch/arm/configs/mx27_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/mx27_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff -puN arch/arm/configs/mx3_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/mx3_defconfig
--- a/arch/arm/configs/mx3_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/mx3_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/arm/configs/mx51_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/mx51_defconfig
--- a/arch/arm/configs/mx51_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/mx51_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_RELAY=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_MODULES=y
diff -puN arch/arm/configs/nhk8815_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/nhk8815_defconfig
--- a/arch/arm/configs/nhk8815_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/nhk8815_defconfig
@@ -7,7 +7,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/arm/configs/omap1_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/omap1_defconfig
--- a/arch/arm/configs/omap1_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/omap1_defconfig
@@ -6,7 +6,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff -puN arch/arm/configs/omap2plus_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/omap2plus_defconfig
--- a/arch/arm/configs/omap2plus_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/omap2plus_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
diff -puN arch/arm/configs/orion5x_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/orion5x_defconfig
--- a/arch/arm/configs/orion5x_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/orion5x_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=y
diff -puN arch/arm/configs/pcm027_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/pcm027_defconfig
--- a/arch/arm/configs/pcm027_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/pcm027_defconfig
@@ -7,7 +7,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/arm/configs/pcontrol_g20_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/pcontrol_g20_defconfig
--- a/arch/arm/configs/pcontrol_g20_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/pcontrol_g20_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff -puN arch/arm/configs/pleb_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/pleb_defconfig
--- a/arch/arm/configs/pleb_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/pleb_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_SHMEM is not set
 CONFIG_MODULES=y
diff -puN arch/arm/configs/pnx4008_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/pnx4008_defconfig
--- a/arch/arm/configs/pnx4008_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/pnx4008_defconfig
@@ -5,7 +5,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_AUDIT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/arm/configs/simpad_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/simpad_defconfig
--- a/arch/arm/configs/simpad_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/simpad_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="oe1"
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/arm/configs/spitz_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/spitz_defconfig
--- a/arch/arm/configs/spitz_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/spitz_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
 CONFIG_MODULES=y
diff -puN arch/arm/configs/stmp378x_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/stmp378x_defconfig
--- a/arch/arm/configs/stmp378x_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/stmp378x_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/arm/configs/stmp37xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/stmp37xx_defconfig
--- a/arch/arm/configs/stmp37xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/stmp37xx_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/arm/configs/tct_hammer_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/tct_hammer_defconfig
--- a/arch/arm/configs/tct_hammer_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/tct_hammer_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_BUG is not set
 # CONFIG_ELF_CORE is not set
diff -puN arch/arm/configs/trizeps4_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/trizeps4_defconfig
--- a/arch/arm/configs/trizeps4_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/trizeps4_defconfig
@@ -7,7 +7,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/arm/configs/u300_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/u300_defconfig
--- a/arch/arm/configs/u300_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/u300_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_AIO is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_MODULES=y
diff -puN arch/arm/configs/viper_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/viper_defconfig
--- a/arch/arm/configs/viper_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/viper_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=13
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
 # CONFIG_SHMEM is not set
 CONFIG_SLAB=y
diff -puN arch/arm/configs/xcep_defconfig~kconfig-rename-config_embedded-to-config_expert arch/arm/configs/xcep_defconfig
--- a/arch/arm/configs/xcep_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/arm/configs/xcep_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SHMEM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff -puN arch/avr32/Kconfig~kconfig-rename-config_embedded-to-config_expert arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/avr32/Kconfig
@@ -1,8 +1,8 @@
 config AVR32
 	def_bool y
-	# With EMBEDDED=n, we get lots of stuff automatically selected
+	# With EXPERT=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
-	select EMBEDDED
+	select EXPERT
 	select HAVE_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
diff -puN arch/blackfin/configs/BF518F-EZBRD_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF518F-EZBRD_defconfig
--- a/arch/blackfin/configs/BF518F-EZBRD_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF518F-EZBRD_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BF526-EZBRD_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF526-EZBRD_defconfig
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BF527-AD7160-EVAL_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
--- a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
 # CONFIG_AIO is not set
 CONFIG_SLAB=y
diff -puN arch/blackfin/configs/BF527-EZKIT-V2_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF527-EZKIT-V2_defconfig
--- a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BF527-EZKIT_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF527-EZKIT_defconfig
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BF527-TLL6527M_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF527-TLL6527M_defconfig
--- a/arch/blackfin/configs/BF527-TLL6527M_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF527-TLL6527M_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BF533-EZKIT_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF533-EZKIT_defconfig
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BF533-STAMP_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF533-STAMP_defconfig
--- a/arch/blackfin/configs/BF533-STAMP_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BF537-STAMP_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF537-STAMP_defconfig
--- a/arch/blackfin/configs/BF537-STAMP_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BF538-EZKIT_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF538-EZKIT_defconfig
--- a/arch/blackfin/configs/BF538-EZKIT_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF538-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BF548-EZKIT_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF548-EZKIT_defconfig
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BF561-ACVILON_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF561-ACVILON_defconfig
--- a/arch/blackfin/configs/BF561-ACVILON_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF561-ACVILON_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BF561-EZKIT-SMP_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
--- a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BF561-EZKIT_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BF561-EZKIT_defconfig
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/BlackStamp_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/BlackStamp_defconfig
--- a/arch/blackfin/configs/BlackStamp_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/BlackStamp_defconfig
@@ -6,7 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/CM-BF527_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/CM-BF527_defconfig
--- a/arch/blackfin/configs/CM-BF527_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/CM-BF527_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/CM-BF533_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/CM-BF533_defconfig
--- a/arch/blackfin/configs/CM-BF533_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/CM-BF533_defconfig
@@ -7,7 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff -puN arch/blackfin/configs/CM-BF537E_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/CM-BF537E_defconfig
--- a/arch/blackfin/configs/CM-BF537E_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/CM-BF537E_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff -puN arch/blackfin/configs/CM-BF537U_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/CM-BF537U_defconfig
--- a/arch/blackfin/configs/CM-BF537U_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/CM-BF537U_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff -puN arch/blackfin/configs/CM-BF548_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/CM-BF548_defconfig
--- a/arch/blackfin/configs/CM-BF548_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/CM-BF548_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff -puN arch/blackfin/configs/CM-BF561_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/CM-BF561_defconfig
--- a/arch/blackfin/configs/CM-BF561_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/CM-BF561_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff -puN arch/blackfin/configs/DNP5370_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/DNP5370_defconfig
--- a/arch/blackfin/configs/DNP5370_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/DNP5370_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLOB=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_CFQ is not set
diff -puN arch/blackfin/configs/H8606_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/H8606_defconfig
--- a/arch/blackfin/configs/H8606_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/H8606_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/IP0X_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/IP0X_defconfig
--- a/arch/blackfin/configs/IP0X_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/IP0X_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_ELF_CORE is not set
diff -puN arch/blackfin/configs/PNAV-10_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/PNAV-10_defconfig
--- a/arch/blackfin/configs/PNAV-10_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/PNAV-10_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/SRV1_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/SRV1_defconfig
--- a/arch/blackfin/configs/SRV1_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/SRV1_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_ELF_CORE is not set
diff -puN arch/blackfin/configs/TCM-BF518_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/TCM-BF518_defconfig
--- a/arch/blackfin/configs/TCM-BF518_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/TCM-BF518_defconfig
@@ -7,7 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff -puN arch/blackfin/configs/TCM-BF537_defconfig~kconfig-rename-config_embedded-to-config_expert arch/blackfin/configs/TCM-BF537_defconfig
--- a/arch/blackfin/configs/TCM-BF537_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/blackfin/configs/TCM-BF537_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff -puN arch/cris/configs/artpec_3_defconfig~kconfig-rename-config_embedded-to-config_expert arch/cris/configs/artpec_3_defconfig
--- a/arch/cris/configs/artpec_3_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/cris/configs/artpec_3_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/cris/configs/etrax-100lx_v2_defconfig~kconfig-rename-config_embedded-to-config_expert arch/cris/configs/etrax-100lx_v2_defconfig
--- a/arch/cris/configs/etrax-100lx_v2_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/cris/configs/etrax-100lx_v2_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/cris/configs/etraxfs_defconfig~kconfig-rename-config_embedded-to-config_expert arch/cris/configs/etraxfs_defconfig
--- a/arch/cris/configs/etraxfs_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/cris/configs/etraxfs_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/frv/defconfig~kconfig-rename-config_embedded-to-config_expert arch/frv/defconfig
--- a/arch/frv/defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/frv/defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_MMU=y
 CONFIG_FRV_OUTOFLINE_ATOMIC_OPS=y
diff -puN arch/h8300/defconfig~kconfig-rename-config_embedded-to-config_expert arch/h8300/defconfig
--- a/arch/h8300/defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/h8300/defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
diff -puN arch/m32r/configs/m32700ut.smp_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m32r/configs/m32700ut.smp_defconfig
--- a/arch/m32r/configs/m32700ut.smp_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m32r/configs/m32700ut.smp_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff -puN arch/m32r/configs/m32700ut.up_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m32r/configs/m32700ut.up_defconfig
--- a/arch/m32r/configs/m32700ut.up_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m32r/configs/m32700ut.up_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff -puN arch/m32r/configs/mappi.nommu_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m32r/configs/mappi.nommu_defconfig
--- a/arch/m32r/configs/mappi.nommu_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m32r/configs/mappi.nommu_defconfig
@@ -3,7 +3,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff -puN arch/m32r/configs/mappi.smp_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m32r/configs/mappi.smp_defconfig
--- a/arch/m32r/configs/mappi.smp_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m32r/configs/mappi.smp_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff -puN arch/m32r/configs/mappi.up_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m32r/configs/mappi.up_defconfig
--- a/arch/m32r/configs/mappi.up_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m32r/configs/mappi.up_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff -puN arch/m32r/configs/mappi2.opsp_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m32r/configs/mappi2.opsp_defconfig
--- a/arch/m32r/configs/mappi2.opsp_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m32r/configs/mappi2.opsp_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff -puN arch/m32r/configs/mappi2.vdec2_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m32r/configs/mappi2.vdec2_defconfig
--- a/arch/m32r/configs/mappi2.vdec2_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m32r/configs/mappi2.vdec2_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff -puN arch/m32r/configs/mappi3.smp_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m32r/configs/mappi3.smp_defconfig
--- a/arch/m32r/configs/mappi3.smp_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m32r/configs/mappi3.smp_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff -puN arch/m32r/configs/oaks32r_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m32r/configs/oaks32r_defconfig
--- a/arch/m32r/configs/oaks32r_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m32r/configs/oaks32r_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff -puN arch/m32r/configs/opsput_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m32r/configs/opsput_defconfig
--- a/arch/m32r/configs/opsput_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m32r/configs/opsput_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff -puN arch/m32r/configs/usrv_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m32r/configs/usrv_defconfig
--- a/arch/m32r/configs/usrv_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m32r/configs/usrv_defconfig
@@ -5,7 +5,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/m68knommu/configs/m5208evb_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m68knommu/configs/m5208evb_defconfig
--- a/arch/m68knommu/configs/m5208evb_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m68knommu/configs/m5208evb_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff -puN arch/m68knommu/configs/m5249evb_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m68knommu/configs/m5249evb_defconfig
--- a/arch/m68knommu/configs/m5249evb_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m68knommu/configs/m5249evb_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff -puN arch/m68knommu/configs/m5272c3_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m68knommu/configs/m5272c3_defconfig
--- a/arch/m68knommu/configs/m5272c3_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m68knommu/configs/m5272c3_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff -puN arch/m68knommu/configs/m5275evb_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m68knommu/configs/m5275evb_defconfig
--- a/arch/m68knommu/configs/m5275evb_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m68knommu/configs/m5275evb_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff -puN arch/m68knommu/configs/m5307c3_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m68knommu/configs/m5307c3_defconfig
--- a/arch/m68knommu/configs/m5307c3_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m68knommu/configs/m5307c3_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff -puN arch/m68knommu/configs/m5407c3_defconfig~kconfig-rename-config_embedded-to-config_expert arch/m68knommu/configs/m5407c3_defconfig
--- a/arch/m68knommu/configs/m5407c3_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m68knommu/configs/m5407c3_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff -puN arch/m68knommu/defconfig~kconfig-rename-config_embedded-to-config_expert arch/m68knommu/defconfig
--- a/arch/m68knommu/defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/m68knommu/defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff -puN arch/microblaze/configs/mmu_defconfig~kconfig-rename-config_embedded-to-config_expert arch/microblaze/configs/mmu_defconfig
--- a/arch/microblaze/configs/mmu_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/microblaze/configs/mmu_defconfig
@@ -7,7 +7,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE="rootfs.cpio"
 CONFIG_INITRAMFS_COMPRESSION_GZIP=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_HOTPLUG is not set
diff -puN arch/microblaze/configs/nommu_defconfig~kconfig-rename-config_embedded-to-config_expert arch/microblaze/configs/nommu_defconfig
--- a/arch/microblaze/configs/nommu_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/microblaze/configs/nommu_defconfig
@@ -6,7 +6,7 @@ CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_HOTPLUG is not set
diff -puN arch/mips/Kconfig.debug~kconfig-rename-config_embedded-to-config_expert arch/mips/Kconfig.debug
--- a/arch/mips/Kconfig.debug~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/Kconfig.debug
@@ -7,7 +7,7 @@ config TRACE_IRQFLAGS_SUPPORT
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED
+	bool "Early printk" if EXPERT
 	depends on SYS_HAS_EARLY_PRINTK
 	default y
 	help
diff -puN arch/mips/configs/ar7_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/ar7_defconfig
--- a/arch/mips/configs/ar7_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/ar7_defconfig
@@ -14,7 +14,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff -puN arch/mips/configs/bcm47xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/bcm47xx_defconfig
--- a/arch/mips/configs/bcm47xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/bcm47xx_defconfig
@@ -21,7 +21,7 @@ CONFIG_CGROUP_CPUACCT=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/mips/configs/bcm63xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/bcm63xx_defconfig
--- a/arch/mips/configs/bcm63xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/bcm63xx_defconfig
@@ -10,7 +10,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_TINY_RCU=y
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff -puN arch/mips/configs/bigsur_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/bigsur_defconfig
--- a/arch/mips/configs/bigsur_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/bigsur_defconfig
@@ -26,7 +26,7 @@ CONFIG_PID_NS=y
 CONFIG_NET_NS=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
diff -puN arch/mips/configs/capcella_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/capcella_defconfig
--- a/arch/mips/configs/capcella_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/capcella_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/mips/configs/cavium-octeon_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/cavium-octeon_defconfig
--- a/arch/mips/configs/cavium-octeon_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/cavium-octeon_defconfig
@@ -15,7 +15,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/mips/configs/cobalt_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/cobalt_defconfig
--- a/arch/mips/configs/cobalt_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/cobalt_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/mips/configs/db1000_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/db1000_defconfig
--- a/arch/mips/configs/db1000_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/db1000_defconfig
@@ -11,7 +11,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff -puN arch/mips/configs/db1100_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/db1100_defconfig
--- a/arch/mips/configs/db1100_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/db1100_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff -puN arch/mips/configs/db1200_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/db1200_defconfig
--- a/arch/mips/configs/db1200_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/db1200_defconfig
@@ -12,7 +12,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff -puN arch/mips/configs/db1500_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/db1500_defconfig
--- a/arch/mips/configs/db1500_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/db1500_defconfig
@@ -10,7 +10,7 @@ CONFIG_LOCALVERSION="-db1500"
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff -puN arch/mips/configs/db1550_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/db1550_defconfig
--- a/arch/mips/configs/db1550_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/db1550_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff -puN arch/mips/configs/decstation_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/decstation_defconfig
--- a/arch/mips/configs/decstation_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/decstation_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
diff -puN arch/mips/configs/e55_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/e55_defconfig
--- a/arch/mips/configs/e55_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/e55_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/mips/configs/fuloong2e_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/fuloong2e_defconfig
--- a/arch/mips/configs/fuloong2e_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/fuloong2e_defconfig
@@ -17,7 +17,7 @@ CONFIG_NAMESPACES=y
 CONFIG_USER_NS=y
 CONFIG_PID_NS=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff -puN arch/mips/configs/gpr_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/gpr_defconfig
--- a/arch/mips/configs/gpr_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/gpr_defconfig
@@ -11,7 +11,7 @@ CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_MODULES=y
diff -puN arch/mips/configs/ip22_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/ip22_defconfig
--- a/arch/mips/configs/ip22_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/ip22_defconfig
@@ -17,7 +17,7 @@ CONFIG_IPC_NS=y
 CONFIG_USER_NS=y
 CONFIG_PID_NS=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_COMPAT_BRK is not set
diff -puN arch/mips/configs/ip27_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/ip27_defconfig
--- a/arch/mips/configs/ip27_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/ip27_defconfig
@@ -15,7 +15,7 @@ CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/mips/configs/ip28_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/ip28_defconfig
--- a/arch/mips/configs/ip28_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/ip28_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/mips/configs/ip32_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/ip32_defconfig
--- a/arch/mips/configs/ip32_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/ip32_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
diff -puN arch/mips/configs/jazz_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/jazz_defconfig
--- a/arch/mips/configs/jazz_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/jazz_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/mips/configs/jmr3927_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/jmr3927_defconfig
--- a/arch/mips/configs/jmr3927_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/jmr3927_defconfig
@@ -4,7 +4,7 @@ CONFIG_TOSHIBA_JMR3927=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
diff -puN arch/mips/configs/lasat_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/lasat_defconfig
--- a/arch/mips/configs/lasat_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/lasat_defconfig
@@ -8,7 +8,7 @@ CONFIG_HZ_1000=y
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
diff -puN arch/mips/configs/lemote2f_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/lemote2f_defconfig
--- a/arch/mips/configs/lemote2f_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/lemote2f_defconfig
@@ -21,7 +21,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
 CONFIG_MODULES=y
diff -puN arch/mips/configs/malta_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/malta_defconfig
--- a/arch/mips/configs/malta_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/malta_defconfig
@@ -15,7 +15,7 @@ CONFIG_UTS_NS=y
 CONFIG_IPC_NS=y
 CONFIG_PID_NS=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff -puN arch/mips/configs/markeins_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/markeins_defconfig
--- a/arch/mips/configs/markeins_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/markeins_defconfig
@@ -9,7 +9,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/mips/configs/mipssim_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/mipssim_defconfig
--- a/arch/mips/configs/mipssim_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/mipssim_defconfig
@@ -7,7 +7,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/mips/configs/mpc30x_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/mpc30x_defconfig
--- a/arch/mips/configs/mpc30x_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/mpc30x_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/mips/configs/msp71xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/msp71xx_defconfig
--- a/arch/mips/configs/msp71xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/msp71xx_defconfig
@@ -8,7 +8,7 @@ CONFIG_LOCALVERSION="-pmc"
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SHMEM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/mips/configs/mtx1_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/mtx1_defconfig
--- a/arch/mips/configs/mtx1_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/mtx1_defconfig
@@ -11,7 +11,7 @@ CONFIG_AUDIT=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
diff -puN arch/mips/configs/pb1100_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/pb1100_defconfig
--- a/arch/mips/configs/pb1100_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/pb1100_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff -puN arch/mips/configs/pb1200_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/pb1200_defconfig
--- a/arch/mips/configs/pb1200_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/pb1200_defconfig
@@ -12,7 +12,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff -puN arch/mips/configs/pb1500_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/pb1500_defconfig
--- a/arch/mips/configs/pb1500_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/pb1500_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff -puN arch/mips/configs/pb1550_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/pb1550_defconfig
--- a/arch/mips/configs/pb1550_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/pb1550_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff -puN arch/mips/configs/pnx8335-stb225_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/pnx8335-stb225_defconfig
--- a/arch/mips/configs/pnx8335-stb225_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/pnx8335-stb225_defconfig
@@ -11,7 +11,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/mips/configs/pnx8550-jbs_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/pnx8550-jbs_defconfig
--- a/arch/mips/configs/pnx8550-jbs_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/pnx8550-jbs_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/mips/configs/pnx8550-stb810_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/pnx8550-stb810_defconfig
--- a/arch/mips/configs/pnx8550-stb810_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/pnx8550-stb810_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
diff -puN arch/mips/configs/powertv_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/powertv_defconfig
--- a/arch/mips/configs/powertv_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/powertv_defconfig
@@ -14,7 +14,7 @@ CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PCSPKR_PLATFORM is not set
diff -puN arch/mips/configs/rb532_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/rb532_defconfig
--- a/arch/mips/configs/rb532_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/rb532_defconfig
@@ -13,7 +13,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff -puN arch/mips/configs/rbtx49xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/rbtx49xx_defconfig
--- a/arch/mips/configs/rbtx49xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/rbtx49xx_defconfig
@@ -12,7 +12,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_EPOLL is not set
diff -puN arch/mips/configs/rm200_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/rm200_defconfig
--- a/arch/mips/configs/rm200_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/rm200_defconfig
@@ -12,7 +12,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/mips/configs/sb1250-swarm_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/sb1250-swarm_defconfig
--- a/arch/mips/configs/sb1250-swarm_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/sb1250-swarm_defconfig
@@ -15,7 +15,7 @@ CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/mips/configs/tb0219_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/tb0219_defconfig
--- a/arch/mips/configs/tb0219_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/tb0219_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/mips/configs/tb0226_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/tb0226_defconfig
--- a/arch/mips/configs/tb0226_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/tb0226_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/mips/configs/tb0287_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/tb0287_defconfig
--- a/arch/mips/configs/tb0287_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/tb0287_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
diff -puN arch/mips/configs/workpad_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/workpad_defconfig
--- a/arch/mips/configs/workpad_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/workpad_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/mips/configs/wrppmc_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/wrppmc_defconfig
--- a/arch/mips/configs/wrppmc_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/wrppmc_defconfig
@@ -7,7 +7,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_EPOLL is not set
 CONFIG_SLAB=y
diff -puN arch/mips/configs/yosemite_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mips/configs/yosemite_defconfig
--- a/arch/mips/configs/yosemite_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mips/configs/yosemite_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/mn10300/configs/asb2303_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mn10300/configs/asb2303_defconfig
--- a/arch/mn10300/configs/asb2303_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mn10300/configs/asb2303_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff -puN arch/mn10300/configs/asb2364_defconfig~kconfig-rename-config_embedded-to-config_expert arch/mn10300/configs/asb2364_defconfig
--- a/arch/mn10300/configs/asb2364_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/mn10300/configs/asb2364_defconfig
@@ -15,7 +15,7 @@ CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
diff -puN arch/parisc/configs/a500_defconfig~kconfig-rename-config_embedded-to-config_expert arch/parisc/configs/a500_defconfig
--- a/arch/parisc/configs/a500_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/parisc/configs/a500_defconfig
@@ -8,7 +8,7 @@ CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff -puN arch/parisc/configs/c3000_defconfig~kconfig-rename-config_embedded-to-config_expert arch/parisc/configs/c3000_defconfig
--- a/arch/parisc/configs/c3000_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/parisc/configs/c3000_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff -puN arch/powerpc/configs/40x/acadia_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/40x/acadia_defconfig
--- a/arch/powerpc/configs/40x/acadia_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/40x/acadia_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/40x/ep405_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/40x/ep405_defconfig
--- a/arch/powerpc/configs/40x/ep405_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/40x/ep405_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/40x/hcu4_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/40x/hcu4_defconfig
--- a/arch/powerpc/configs/40x/hcu4_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/40x/hcu4_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/40x/kilauea_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/40x/kilauea_defconfig
--- a/arch/powerpc/configs/40x/kilauea_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/40x/kilauea_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/40x/makalu_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/40x/makalu_defconfig
--- a/arch/powerpc/configs/40x/makalu_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/40x/makalu_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/40x/walnut_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/40x/walnut_defconfig
--- a/arch/powerpc/configs/40x/walnut_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/40x/walnut_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/44x/arches_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/arches_defconfig
--- a/arch/powerpc/configs/44x/arches_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/arches_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/44x/bamboo_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/bamboo_defconfig
--- a/arch/powerpc/configs/44x/bamboo_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/bamboo_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/44x/bluestone_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/bluestone_defconfig
--- a/arch/powerpc/configs/44x/bluestone_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/bluestone_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_PCI_QUIRKS is not set
 # CONFIG_COMPAT_BRK is not set
diff -puN arch/powerpc/configs/44x/canyonlands_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/canyonlands_defconfig
--- a/arch/powerpc/configs/44x/canyonlands_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/canyonlands_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/44x/ebony_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/ebony_defconfig
--- a/arch/powerpc/configs/44x/ebony_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/ebony_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/44x/eiger_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/eiger_defconfig
--- a/arch/powerpc/configs/44x/eiger_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/eiger_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/44x/icon_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/icon_defconfig
--- a/arch/powerpc/configs/44x/icon_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/icon_defconfig
@@ -6,7 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/44x/iss476-smp_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/iss476-smp_defconfig
--- a/arch/powerpc/configs/44x/iss476-smp_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/iss476-smp_defconfig
@@ -7,7 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_PROFILING=y
diff -puN arch/powerpc/configs/44x/katmai_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/katmai_defconfig
--- a/arch/powerpc/configs/44x/katmai_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/katmai_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/44x/rainier_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/rainier_defconfig
--- a/arch/powerpc/configs/44x/rainier_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/rainier_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/44x/redwood_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/redwood_defconfig
--- a/arch/powerpc/configs/44x/redwood_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/redwood_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/44x/sam440ep_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/sam440ep_defconfig
--- a/arch/powerpc/configs/44x/sam440ep_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/sam440ep_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/44x/sequoia_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/sequoia_defconfig
--- a/arch/powerpc/configs/44x/sequoia_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/sequoia_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/44x/taishan_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/taishan_defconfig
--- a/arch/powerpc/configs/44x/taishan_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/taishan_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/44x/warp_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/44x/warp_defconfig
--- a/arch/powerpc/configs/44x/warp_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/44x/warp_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/52xx/cm5200_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/52xx/cm5200_defconfig
--- a/arch/powerpc/configs/52xx/cm5200_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/52xx/cm5200_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff -puN arch/powerpc/configs/52xx/lite5200b_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/52xx/lite5200b_defconfig
--- a/arch/powerpc/configs/52xx/lite5200b_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/52xx/lite5200b_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff -puN arch/powerpc/configs/52xx/motionpro_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/52xx/motionpro_defconfig
--- a/arch/powerpc/configs/52xx/motionpro_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/52xx/motionpro_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff -puN arch/powerpc/configs/52xx/pcm030_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/52xx/pcm030_defconfig
--- a/arch/powerpc/configs/52xx/pcm030_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/52xx/pcm030_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
diff -puN arch/powerpc/configs/52xx/tqm5200_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/52xx/tqm5200_defconfig
--- a/arch/powerpc/configs/52xx/tqm5200_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/52xx/tqm5200_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff -puN arch/powerpc/configs/83xx/asp8347_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/asp8347_defconfig
--- a/arch/powerpc/configs/83xx/asp8347_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/asp8347_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/83xx/kmeter1_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/kmeter1_defconfig
--- a/arch/powerpc/configs/83xx/kmeter1_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/kmeter1_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/83xx/mpc8313_rdb_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
--- a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/83xx/mpc8315_rdb_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
--- a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/83xx/mpc832x_mds_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/mpc832x_mds_defconfig
--- a/arch/powerpc/configs/83xx/mpc832x_mds_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/83xx/mpc832x_rdb_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
--- a/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/83xx/mpc834x_itx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/mpc834x_itx_defconfig
--- a/arch/powerpc/configs/83xx/mpc834x_itx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
--- a/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/83xx/mpc834x_mds_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/mpc834x_mds_defconfig
--- a/arch/powerpc/configs/83xx/mpc834x_mds_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/83xx/mpc836x_mds_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/mpc836x_mds_defconfig
--- a/arch/powerpc/configs/83xx/mpc836x_mds_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/83xx/mpc836x_rdk_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
--- a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/83xx/mpc837x_mds_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/mpc837x_mds_defconfig
--- a/arch/powerpc/configs/83xx/mpc837x_mds_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/83xx/mpc837x_rdb_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
--- a/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/83xx/sbc834x_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/83xx/sbc834x_defconfig
--- a/arch/powerpc/configs/83xx/sbc834x_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/83xx/sbc834x_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/85xx/ksi8560_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/ksi8560_defconfig
--- a/arch/powerpc/configs/85xx/ksi8560_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/ksi8560_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_KSI8560=y
 CONFIG_CPM2=y
diff -puN arch/powerpc/configs/85xx/mpc8540_ads_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/mpc8540_ads_defconfig
--- a/arch/powerpc/configs/85xx/mpc8540_ads_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_MPC8540_ADS=y
 CONFIG_NO_HZ=y
diff -puN arch/powerpc/configs/85xx/mpc8560_ads_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/mpc8560_ads_defconfig
--- a/arch/powerpc/configs/85xx/mpc8560_ads_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_MPC8560_ADS=y
 CONFIG_BINFMT_MISC=y
diff -puN arch/powerpc/configs/85xx/mpc85xx_cds_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
--- a/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_MPC85xx_CDS=y
 CONFIG_NO_HZ=y
diff -puN arch/powerpc/configs/85xx/sbc8548_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/sbc8548_defconfig
--- a/arch/powerpc/configs/85xx/sbc8548_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/sbc8548_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_SBC8548=y
diff -puN arch/powerpc/configs/85xx/sbc8560_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/sbc8560_defconfig
--- a/arch/powerpc/configs/85xx/sbc8560_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/sbc8560_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_SBC8560=y
diff -puN arch/powerpc/configs/85xx/socrates_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/socrates_defconfig
--- a/arch/powerpc/configs/85xx/socrates_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/socrates_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff -puN arch/powerpc/configs/85xx/stx_gp3_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/stx_gp3_defconfig
--- a/arch/powerpc/configs/85xx/stx_gp3_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/stx_gp3_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/85xx/tqm8540_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/tqm8540_defconfig
--- a/arch/powerpc/configs/85xx/tqm8540_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/tqm8540_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff -puN arch/powerpc/configs/85xx/tqm8541_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/tqm8541_defconfig
--- a/arch/powerpc/configs/85xx/tqm8541_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/tqm8541_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff -puN arch/powerpc/configs/85xx/tqm8548_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/tqm8548_defconfig
--- a/arch/powerpc/configs/85xx/tqm8548_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/tqm8548_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff -puN arch/powerpc/configs/85xx/tqm8555_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/tqm8555_defconfig
--- a/arch/powerpc/configs/85xx/tqm8555_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/tqm8555_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff -puN arch/powerpc/configs/85xx/tqm8560_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/tqm8560_defconfig
--- a/arch/powerpc/configs/85xx/tqm8560_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/tqm8560_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff -puN arch/powerpc/configs/85xx/xes_mpc85xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
--- a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
@@ -11,7 +11,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/86xx/gef_ppc9a_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/86xx/gef_ppc9a_defconfig
--- a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/86xx/gef_sbc310_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/86xx/gef_sbc310_defconfig
--- a/arch/powerpc/configs/86xx/gef_sbc310_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/86xx/gef_sbc310_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/86xx/gef_sbc610_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/86xx/gef_sbc610_defconfig
--- a/arch/powerpc/configs/86xx/gef_sbc610_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/86xx/gef_sbc610_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
--- a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_ELF_CORE is not set
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
--- a/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/86xx/sbc8641d_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/86xx/sbc8641d_defconfig
--- a/arch/powerpc/configs/86xx/sbc8641d_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/86xx/sbc8641d_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/adder875_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/adder875_defconfig
--- a/arch/powerpc/configs/adder875_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/adder875_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff -puN arch/powerpc/configs/e55xx_smp_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/e55xx_smp_defconfig
--- a/arch/powerpc/configs/e55xx_smp_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/e55xx_smp_defconfig
@@ -12,7 +12,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/ep8248e_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/ep8248e_defconfig
--- a/arch/powerpc/configs/ep8248e_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/ep8248e_defconfig
@@ -2,7 +2,7 @@ CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 # CONFIG_IOSCHED_CFQ is not set
diff -puN arch/powerpc/configs/ep88xc_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/ep88xc_defconfig
--- a/arch/powerpc/configs/ep88xc_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/ep88xc_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff -puN arch/powerpc/configs/gamecube_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/gamecube_defconfig
--- a/arch/powerpc/configs/gamecube_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/gamecube_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
 CONFIG_PERF_COUNTERS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
diff -puN arch/powerpc/configs/holly_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/holly_defconfig
--- a/arch/powerpc/configs/holly_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/holly_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_PPC_CHRP is not set
diff -puN arch/powerpc/configs/mgcoge_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/mgcoge_defconfig
--- a/arch/powerpc/configs/mgcoge_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/mgcoge_defconfig
@@ -3,7 +3,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 # CONFIG_IOSCHED_CFQ is not set
diff -puN arch/powerpc/configs/mgsuvd_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/mgsuvd_defconfig
--- a/arch/powerpc/configs/mgsuvd_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/mgsuvd_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BUG is not set
diff -puN arch/powerpc/configs/mpc7448_hpc2_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/mpc7448_hpc2_defconfig
--- a/arch/powerpc/configs/mpc7448_hpc2_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/mpc7448_hpc2_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_PPC_CHRP is not set
 # CONFIG_PPC_PMAC is not set
diff -puN arch/powerpc/configs/mpc8272_ads_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/mpc8272_ads_defconfig
--- a/arch/powerpc/configs/mpc8272_ads_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/mpc8272_ads_defconfig
@@ -2,7 +2,7 @@ CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PPC_CHRP is not set
 # CONFIG_PPC_PMAC is not set
diff -puN arch/powerpc/configs/mpc83xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/mpc83xx_defconfig
--- a/arch/powerpc/configs/mpc83xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/mpc83xx_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/mpc85xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/mpc85xx_defconfig
--- a/arch/powerpc/configs/mpc85xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/mpc85xx_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/mpc85xx_smp_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/mpc85xx_smp_defconfig
--- a/arch/powerpc/configs/mpc85xx_smp_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/mpc85xx_smp_defconfig
@@ -12,7 +12,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/mpc866_ads_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/mpc866_ads_defconfig
--- a/arch/powerpc/configs/mpc866_ads_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/mpc866_ads_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BUG is not set
diff -puN arch/powerpc/configs/mpc86xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/mpc86xx_defconfig
--- a/arch/powerpc/configs/mpc86xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/mpc86xx_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/mpc885_ads_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/mpc885_ads_defconfig
--- a/arch/powerpc/configs/mpc885_ads_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/mpc885_ads_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff -puN arch/powerpc/configs/ppc40x_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/ppc40x_defconfig
--- a/arch/powerpc/configs/ppc40x_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/ppc40x_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/ppc44x_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/ppc44x_defconfig
--- a/arch/powerpc/configs/ppc44x_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/ppc44x_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff -puN arch/powerpc/configs/pq2fads_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/pq2fads_defconfig
--- a/arch/powerpc/configs/pq2fads_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/pq2fads_defconfig
@@ -3,7 +3,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PPC_CHRP is not set
 # CONFIG_PPC_PMAC is not set
diff -puN arch/powerpc/configs/ps3_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/ps3_defconfig
--- a/arch/powerpc/configs/ps3_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/ps3_defconfig
@@ -8,7 +8,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_PERF_EVENTS is not set
 # CONFIG_COMPAT_BRK is not set
diff -puN arch/powerpc/configs/storcenter_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/storcenter_defconfig
--- a/arch/powerpc/configs/storcenter_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/storcenter_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff -puN arch/powerpc/configs/tqm8xx_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/tqm8xx_defconfig
--- a/arch/powerpc/configs/tqm8xx_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/tqm8xx_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff -puN arch/powerpc/configs/wii_defconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/configs/wii_defconfig
--- a/arch/powerpc/configs/wii_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/configs/wii_defconfig
@@ -7,7 +7,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
 CONFIG_PERF_COUNTERS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
diff -puN arch/powerpc/platforms/iseries/Kconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/platforms/iseries/Kconfig
--- a/arch/powerpc/platforms/iseries/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/platforms/iseries/Kconfig
@@ -2,7 +2,7 @@ config PPC_ISERIES
 	bool "IBM Legacy iSeries"
 	depends on PPC64 && PPC_BOOK3S
 	select PPC_INDIRECT_IO
-	select PPC_PCI_CHOICE if EMBEDDED
+	select PPC_PCI_CHOICE if EXPERT
 
 menu "iSeries device drivers"
 	depends on PPC_ISERIES
diff -puN arch/powerpc/platforms/pseries/Kconfig~kconfig-rename-config_embedded-to-config_expert arch/powerpc/platforms/pseries/Kconfig
--- a/arch/powerpc/platforms/pseries/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/powerpc/platforms/pseries/Kconfig
@@ -10,7 +10,7 @@ config PPC_PSERIES
 	select RTAS_ERROR_LOGGING
 	select PPC_UDBG_16550
 	select PPC_NATIVE
-	select PPC_PCI_CHOICE if EMBEDDED
+	select PPC_PCI_CHOICE if EXPERT
 	default y
 
 config PPC_SPLPAR
@@ -24,9 +24,9 @@ config PPC_SPLPAR
 	  two or more partitions.
 
 config EEH
-	bool "PCI Extended Error Handling (EEH)" if EMBEDDED
+	bool "PCI Extended Error Handling (EEH)" if EXPERT
 	depends on PPC_PSERIES && PCI
-	default y if !EMBEDDED
+	default y if !EXPERT
 
 config PSERIES_MSI
        bool
diff -puN arch/score/configs/spct6600_defconfig~kconfig-rename-config_embedded-to-config_expert arch/score/configs/spct6600_defconfig
--- a/arch/score/configs/spct6600_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/score/configs/spct6600_defconfig
@@ -9,7 +9,7 @@ CONFIG_LOG_BUF_SHIFT=12
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
diff -puN arch/sh/Kconfig~kconfig-rename-config_embedded-to-config_expert arch/sh/Kconfig
--- a/arch/sh/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/sh/Kconfig
@@ -1,6 +1,6 @@
 config SUPERH
 	def_bool y
-	select EMBEDDED
+	select EXPERT
 	select CLKDEV_LOOKUP
 	select HAVE_IDE if HAS_IOPORT
 	select HAVE_MEMBLOCK
diff -puN arch/tile/Kconfig~kconfig-rename-config_embedded-to-config_expert arch/tile/Kconfig
--- a/arch/tile/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/tile/Kconfig
@@ -220,7 +220,7 @@ config FORCE_MAX_ZONEORDER
 
 choice
 	depends on !TILEGX
-	prompt "Memory split" if EMBEDDED
+	prompt "Memory split" if EXPERT
 	default VMSPLIT_3G
 	---help---
 	  Select the desired split between kernel and user memory.
diff -puN arch/tile/Kconfig.debug~kconfig-rename-config_embedded-to-config_expert arch/tile/Kconfig.debug
--- a/arch/tile/Kconfig.debug~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/tile/Kconfig.debug
@@ -3,7 +3,7 @@ menu "Kernel hacking"
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED && DEBUG_KERNEL
+	bool "Early printk" if EXPERT && DEBUG_KERNEL
 	default y
 	help
 	  Write kernel log output directly via the hypervisor console.
diff -puN arch/tile/configs/tile_defconfig~kconfig-rename-config_embedded-to-config_expert arch/tile/configs/tile_defconfig
--- a/arch/tile/configs/tile_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/tile/configs/tile_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE="usr/contents.txt"
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_PROFILING=y
 CONFIG_MODULES=y
diff -puN arch/um/defconfig~kconfig-rename-config_embedded-to-config_expert arch/um/defconfig
--- a/arch/um/defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/um/defconfig
@@ -133,7 +133,7 @@ CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_BLK_DEV_INITRD is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
-# CONFIG_EMBEDDED is not set
+# CONFIG_EXPERT is not set
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
diff -puN arch/x86/Kconfig~kconfig-rename-config_embedded-to-config_expert arch/x86/Kconfig
--- a/arch/x86/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/x86/Kconfig
@@ -627,11 +627,11 @@ config APB_TIMER
          as it is off-chip. APB timers are always running regardless of CPU
          C states, they are used as per CPU clockevent device when possible.
 
-# Mark as embedded because too many people got it wrong.
+# Mark as expert because too many people got it wrong.
 # The code disables itself when not needed.
 config DMI
 	default y
-	bool "Enable DMI scanning" if EMBEDDED
+	bool "Enable DMI scanning" if EXPERT
 	---help---
 	  Enabled scanning of DMI to identify machine quirks. Say Y
 	  here unless you have verified that your setup is not
@@ -639,7 +639,7 @@ config DMI
 	  BIOS code.
 
 config GART_IOMMU
-	bool "GART IOMMU support" if EMBEDDED
+	bool "GART IOMMU support" if EXPERT
 	default y
 	select SWIOTLB
 	depends on X86_64 && PCI && AMD_NB
@@ -889,7 +889,7 @@ config X86_THERMAL_VECTOR
 	depends on X86_MCE_INTEL
 
 config VM86
-	bool "Enable VM86 support" if EMBEDDED
+	bool "Enable VM86 support" if EXPERT
 	default y
 	depends on X86_32
 	---help---
@@ -1073,7 +1073,7 @@ endchoice
 
 choice
 	depends on EXPERIMENTAL
-	prompt "Memory split" if EMBEDDED
+	prompt "Memory split" if EXPERT
 	default VMSPLIT_3G
 	depends on X86_32
 	---help---
@@ -1135,7 +1135,7 @@ config ARCH_DMA_ADDR_T_64BIT
 	def_bool X86_64 || HIGHMEM64G
 
 config DIRECT_GBPAGES
-	bool "Enable 1GB pages for kernel pagetables" if EMBEDDED
+	bool "Enable 1GB pages for kernel pagetables" if EXPERT
 	default y
 	depends on X86_64
 	---help---
@@ -1369,7 +1369,7 @@ config MATH_EMULATION
 
 config MTRR
 	def_bool y
-	prompt "MTRR (Memory Type Range Register) support" if EMBEDDED
+	prompt "MTRR (Memory Type Range Register) support" if EXPERT
 	---help---
 	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
 	  the Memory Type Range Registers (MTRRs) may be used to control
@@ -1435,7 +1435,7 @@ config MTRR_SANITIZER_SPARE_REG_NR_DEFAU
 
 config X86_PAT
 	def_bool y
-	prompt "x86 PAT support" if EMBEDDED
+	prompt "x86 PAT support" if EXPERT
 	depends on MTRR
 	---help---
 	  Use PAT attributes to setup page level cache control.
@@ -1539,7 +1539,7 @@ config KEXEC_JUMP
 	  code in physical address mode via KEXEC
 
 config PHYSICAL_START
-	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
+	hex "Physical address where the kernel is loaded" if (EXPERT || CRASH_DUMP)
 	default "0x1000000"
 	---help---
 	  This gives the physical address where the kernel is loaded.
@@ -1934,7 +1934,7 @@ config PCI_MMCONFIG
 	depends on X86_64 && PCI && ACPI
 
 config PCI_CNB20LE_QUIRK
-	bool "Read CNB20LE Host Bridge Windows" if EMBEDDED
+	bool "Read CNB20LE Host Bridge Windows" if EXPERT
 	default n
 	depends on PCI && EXPERIMENTAL
 	help
diff -puN arch/x86/Kconfig.cpu~kconfig-rename-config_embedded-to-config_expert arch/x86/Kconfig.cpu
--- a/arch/x86/Kconfig.cpu~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/x86/Kconfig.cpu
@@ -424,7 +424,7 @@ config X86_DEBUGCTLMSR
 	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386) && !UML
 
 menuconfig PROCESSOR_SELECT
-	bool "Supported processor vendors" if EMBEDDED
+	bool "Supported processor vendors" if EXPERT
 	---help---
 	  This lets you choose what x86 vendor support code your kernel
 	  will include.
diff -puN arch/x86/Kconfig.debug~kconfig-rename-config_embedded-to-config_expert arch/x86/Kconfig.debug
--- a/arch/x86/Kconfig.debug~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/x86/Kconfig.debug
@@ -31,7 +31,7 @@ config X86_VERBOSE_BOOTUP
 	  see errors. Disable this if you want silent bootup.
 
 config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED
+	bool "Early printk" if EXPERT
 	default y
 	---help---
 	  Write kernel log output directly into the VGA buffer or to a serial
@@ -138,7 +138,7 @@ config DEBUG_NX_TEST
 
 config DOUBLEFAULT
 	default y
-	bool "Enable doublefault exception handler" if EMBEDDED
+	bool "Enable doublefault exception handler" if EXPERT
 	depends on X86_32
 	---help---
 	  This option allows trapping of rare doublefault exceptions that
diff -puN arch/xtensa/configs/common_defconfig~kconfig-rename-config_embedded-to-config_expert arch/xtensa/configs/common_defconfig
--- a/arch/xtensa/configs/common_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/xtensa/configs/common_defconfig
@@ -32,7 +32,7 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_HOTPLUG is not set
 CONFIG_KOBJECT_UEVENT=y
 # CONFIG_IKCONFIG is not set
-# CONFIG_EMBEDDED is not set
+# CONFIG_EXPERT is not set
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
 # CONFIG_KALLSYMS_EXTRA_PASS is not set
diff -puN arch/xtensa/configs/iss_defconfig~kconfig-rename-config_embedded-to-config_expert arch/xtensa/configs/iss_defconfig
--- a/arch/xtensa/configs/iss_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/xtensa/configs/iss_defconfig
@@ -55,7 +55,7 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
diff -puN arch/xtensa/configs/s6105_defconfig~kconfig-rename-config_embedded-to-config_expert arch/xtensa/configs/s6105_defconfig
--- a/arch/xtensa/configs/s6105_defconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/arch/xtensa/configs/s6105_defconfig
@@ -55,7 +55,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
diff -puN block/Kconfig~kconfig-rename-config_embedded-to-config_expert block/Kconfig
--- a/block/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/block/Kconfig
@@ -2,7 +2,7 @@
 # Block layer core configuration
 #
 menuconfig BLOCK
-       bool "Enable the block layer" if EMBEDDED
+       bool "Enable the block layer" if EXPERT
        default y
        help
 	 Provide block layer support for the kernel.
diff -puN drivers/acpi/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/acpi/Kconfig
@@ -318,7 +318,7 @@ config ACPI_PCI_SLOT
 	  the module will be called pci_slot.
 
 config X86_PM_TIMER
-	bool "Power Management Timer Support" if EMBEDDED
+	bool "Power Management Timer Support" if EXPERT
 	depends on X86
 	default y
 	help
diff -puN drivers/ata/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/ata/Kconfig
@@ -783,7 +783,7 @@ config PATA_PCMCIA
 
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
-	depends on EMBEDDED || PPC || HAVE_PATA_PLATFORM
+	depends on EXPERT || PPC || HAVE_PATA_PLATFORM
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
diff -puN drivers/base/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/base/Kconfig
--- a/drivers/base/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/base/Kconfig
@@ -70,7 +70,7 @@ config PREVENT_FIRMWARE_BUILD
 	  If unsure say Y here.
 
 config FW_LOADER
-	tristate "Userspace firmware loading support" if EMBEDDED
+	tristate "Userspace firmware loading support" if EXPERT
 	default y
 	---help---
 	  This option is provided for the case where no in-kernel-tree modules
diff -puN drivers/char/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/char/Kconfig
--- a/drivers/char/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/char/Kconfig
@@ -5,7 +5,7 @@
 menu "Character devices"
 
 config VT
-	bool "Virtual terminal" if EMBEDDED
+	bool "Virtual terminal" if EXPERT
 	depends on !S390
 	select INPUT
 	default y
@@ -39,13 +39,13 @@ config VT
 config CONSOLE_TRANSLATIONS
 	depends on VT
 	default y
-	bool "Enable character translations in console" if EMBEDDED
+	bool "Enable character translations in console" if EXPERT
 	---help---
 	  This enables support for font mapping and Unicode translation
 	  on virtual consoles.
 
 config VT_CONSOLE
-	bool "Support for console on virtual terminal" if EMBEDDED
+	bool "Support for console on virtual terminal" if EXPERT
 	depends on VT
 	default y
 	---help---
@@ -429,7 +429,7 @@ config SGI_MBCS
 source "drivers/serial/Kconfig"
 
 config UNIX98_PTYS
-	bool "Unix98 PTY support" if EMBEDDED
+	bool "Unix98 PTY support" if EXPERT
 	default y
 	---help---
 	  A pseudo terminal (PTY) is a software device consisting of two
@@ -495,7 +495,7 @@ config LEGACY_PTY_COUNT
 
 config TTY_PRINTK
 	bool "TTY driver to output user messages via printk"
-	depends on EMBEDDED
+	depends on EXPERT
 	default n
 	---help---
 	  If you say Y here, the support for writing user messages (i.e.
diff -puN drivers/cpufreq/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/cpufreq/Kconfig
--- a/drivers/cpufreq/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/cpufreq/Kconfig
@@ -71,7 +71,7 @@ config CPU_FREQ_DEFAULT_GOV_PERFORMANCE
 
 config CPU_FREQ_DEFAULT_GOV_POWERSAVE
 	bool "powersave"
-	depends on EMBEDDED
+	depends on EXPERT
 	select CPU_FREQ_GOV_POWERSAVE
 	help
 	  Use the CPUFreq governor 'powersave' as default. This sets
diff -puN drivers/firmware/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/firmware/Kconfig
--- a/drivers/firmware/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/firmware/Kconfig
@@ -27,7 +27,7 @@ config EDD_OFF
 	  using the kernel parameter 'edd={on|skipmbr|off}'.
 
 config FIRMWARE_MEMMAP
-    bool "Add firmware-provided memory map to sysfs" if EMBEDDED
+    bool "Add firmware-provided memory map to sysfs" if EXPERT
     default X86
     help
       Add the firmware-provided (unmodified) memory map to /sys/firmware/memmap.
diff -puN drivers/gpu/drm/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/gpu/drm/Kconfig
--- a/drivers/gpu/drm/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/gpu/drm/Kconfig
@@ -23,7 +23,7 @@ config DRM_KMS_HELPER
 	tristate
 	depends on DRM
 	select FB
-	select FRAMEBUFFER_CONSOLE if !EMBEDDED
+	select FRAMEBUFFER_CONSOLE if !EXPERT
 	help
 	  FB and CRTC helpers for KMS drivers.
 
diff -puN drivers/gpu/drm/drm_fb_helper.c~kconfig-rename-config_embedded-to-config_expert drivers/gpu/drm/drm_fb_helper.c
--- a/drivers/gpu/drm/drm_fb_helper.c~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/gpu/drm/drm_fb_helper.c
@@ -1533,11 +1533,11 @@ bool drm_fb_helper_hotplug_event(struct 
 }
 EXPORT_SYMBOL(drm_fb_helper_hotplug_event);
 
-/* The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EMBEDDED)
+/* The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EXPERT)
  * but the module doesn't depend on any fb console symbols.  At least
  * attempt to load fbcon to avoid leaving the system without a usable console.
  */
-#if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EMBEDDED)
+#if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EXPERT)
 static int __init drm_fb_helper_modinit(void)
 {
 	const char *name = "fbcon";
diff -puN drivers/gpu/drm/nouveau/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/gpu/drm/nouveau/Kconfig
--- a/drivers/gpu/drm/nouveau/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/gpu/drm/nouveau/Kconfig
@@ -8,7 +8,7 @@ config DRM_NOUVEAU
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select FB
-	select FRAMEBUFFER_CONSOLE if !EMBEDDED
+	select FRAMEBUFFER_CONSOLE if !EXPERT
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
 	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
 	help
diff -puN drivers/gpu/vga/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/gpu/vga/Kconfig
--- a/drivers/gpu/vga/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/gpu/vga/Kconfig
@@ -1,5 +1,5 @@
 config VGA_ARB
-	bool "VGA Arbitration" if EMBEDDED
+	bool "VGA Arbitration" if EXPERT
 	default y
 	depends on PCI
 	help
diff -puN drivers/hid/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/hid/Kconfig
--- a/drivers/hid/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/hid/Kconfig
@@ -62,9 +62,9 @@ config HID_3M_PCT
 	Support for 3M PCT touch screens.
 
 config HID_A4TECH
-	tristate "A4 tech mice" if EMBEDDED
+	tristate "A4 tech mice" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for A4 tech X5 and WOP-35 / Trust 450L mice.
 
@@ -77,9 +77,9 @@ config HID_ACRUX_FF
 	game controllers.
 
 config HID_APPLE
-	tristate "Apple {i,Power,Mac}Books" if EMBEDDED
+	tristate "Apple {i,Power,Mac}Books" if EXPERT
 	depends on (USB_HID || BT_HIDP)
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for some Apple devices which less or more break
 	HID specification.
@@ -88,9 +88,9 @@ config HID_APPLE
 	MacBooks, MacBook Pros and Apple Aluminum.
 
 config HID_BELKIN
-	tristate "Belkin Flip KVM and Wireless keyboard" if EMBEDDED
+	tristate "Belkin Flip KVM and Wireless keyboard" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.
 
@@ -101,16 +101,16 @@ config HID_CANDO
 	Support for Cando dual touch panel.
 
 config HID_CHERRY
-	tristate "Cherry Cymotion keyboard" if EMBEDDED
+	tristate "Cherry Cymotion keyboard" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Cherry Cymotion keyboard.
 
 config HID_CHICONY
-	tristate "Chicony Tactical pad" if EMBEDDED
+	tristate "Chicony Tactical pad" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Chicony Tactical pad.
 
@@ -130,9 +130,9 @@ config HID_PRODIKEYS
 	  and some additional multimedia keys.
 
 config HID_CYPRESS
-	tristate "Cypress mouse and barcode readers" if EMBEDDED
+	tristate "Cypress mouse and barcode readers" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for cypress mouse and barcode readers.
 
@@ -174,16 +174,16 @@ config HID_ELECOM
 	Support for the ELECOM BM084 (bluetooth mouse).
 
 config HID_EZKEY
-	tristate "Ezkey BTC 8193 keyboard" if EMBEDDED
+	tristate "Ezkey BTC 8193 keyboard" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Ezkey BTC 8193 keyboard.
 
 config HID_KYE
-	tristate "Kye/Genius Ergo Mouse" if EMBEDDED
+	tristate "Kye/Genius Ergo Mouse" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Kye/Genius Ergo Mouse.
 
@@ -212,16 +212,16 @@ config HID_TWINHAN
 	Support for Twinhan IR remote control.
 
 config HID_KENSINGTON
-	tristate "Kensington Slimblade Trackball" if EMBEDDED
+	tristate "Kensington Slimblade Trackball" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Kensington Slimblade Trackball.
 
 config HID_LOGITECH
-	tristate "Logitech devices" if EMBEDDED
+	tristate "Logitech devices" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Logitech devices that are not fully compliant with HID standard.
 
@@ -276,9 +276,9 @@ config HID_MAGICMOUSE
 	Apple Wireless "Magic" Mouse.
 
 config HID_MICROSOFT
-	tristate "Microsoft non-fully HID-compliant devices" if EMBEDDED
+	tristate "Microsoft non-fully HID-compliant devices" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Microsoft devices that are not fully compliant with HID standard.
 
@@ -289,9 +289,9 @@ config HID_MOSART
 	Support for MosArt dual-touch panels.
 
 config HID_MONTEREY
-	tristate "Monterey Genius KB29E keyboard" if EMBEDDED
+	tristate "Monterey Genius KB29E keyboard" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Monterey Genius KB29E.
 
@@ -365,8 +365,8 @@ config HID_PICOLCD
 	  - IR
 
 config HID_PICOLCD_FB
-	bool "Framebuffer support" if EMBEDDED
-	default !EMBEDDED
+	bool "Framebuffer support" if EXPERT
+	default !EXPERT
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=FB || FB=y
 	select FB_DEFERRED_IO
@@ -379,8 +379,8 @@ config HID_PICOLCD_FB
 	  frambuffer device.
 
 config HID_PICOLCD_BACKLIGHT
-	bool "Backlight control" if EMBEDDED
-	default !EMBEDDED
+	bool "Backlight control" if EXPERT
+	default !EXPERT
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=y
 	---help---
@@ -388,16 +388,16 @@ config HID_PICOLCD_BACKLIGHT
 	  class.
 
 config HID_PICOLCD_LCD
-	bool "Contrast control" if EMBEDDED
-	default !EMBEDDED
+	bool "Contrast control" if EXPERT
+	default !EXPERT
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=LCD_CLASS_DEVICE || LCD_CLASS_DEVICE=y
 	---help---
 	  Provide access to PicoLCD's LCD contrast via lcd class.
 
 config HID_PICOLCD_LEDS
-	bool "GPO via leds class" if EMBEDDED
-	default !EMBEDDED
+	bool "GPO via leds class" if EXPERT
+	default !EXPERT
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=LEDS_CLASS || LEDS_CLASS=y
 	---help---
diff -puN drivers/hid/usbhid/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/hid/usbhid/Kconfig
--- a/drivers/hid/usbhid/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/hid/usbhid/Kconfig
@@ -45,7 +45,7 @@ config USB_HIDDEV
 	  If unsure, say Y.
 
 menu "USB HID Boot Protocol drivers"
-	depends on USB!=n && USB_HID!=y && EMBEDDED
+	depends on USB!=n && USB_HID!=y && EXPERT
 
 config USB_KBD
 	tristate "USB HIDBP Keyboard (simple Boot) support"
diff -puN drivers/ide/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/ide/Kconfig
--- a/drivers/ide/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/ide/Kconfig
@@ -134,7 +134,7 @@ config BLK_DEV_IDECD
 	  module will be called ide-cd.
 
 config BLK_DEV_IDECD_VERBOSE_ERRORS
-	bool "Verbose error logging for IDE/ATAPI CDROM driver" if EMBEDDED
+	bool "Verbose error logging for IDE/ATAPI CDROM driver" if EXPERT
 	depends on BLK_DEV_IDECD
 	default y
 	help
diff -puN drivers/infiniband/hw/mthca/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/infiniband/hw/mthca/Kconfig
--- a/drivers/infiniband/hw/mthca/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/infiniband/hw/mthca/Kconfig
@@ -7,7 +7,7 @@ config INFINIBAND_MTHCA
 	  ("Tavor") and the MT25208 PCI Express HCA ("Arbel").
 
 config INFINIBAND_MTHCA_DEBUG
-	bool "Verbose debugging output" if EMBEDDED
+	bool "Verbose debugging output" if EXPERT
 	depends on INFINIBAND_MTHCA
 	default y
 	---help---
diff -puN drivers/infiniband/ulp/ipoib/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/infiniband/ulp/ipoib/Kconfig
--- a/drivers/infiniband/ulp/ipoib/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/infiniband/ulp/ipoib/Kconfig
@@ -24,7 +24,7 @@ config INFINIBAND_IPOIB_CM
 	  unless you limit mtu for these destinations to 2044.
 
 config INFINIBAND_IPOIB_DEBUG
-	bool "IP-over-InfiniBand debugging" if EMBEDDED
+	bool "IP-over-InfiniBand debugging" if EXPERT
 	depends on INFINIBAND_IPOIB
 	default y
 	---help---
diff -puN drivers/input/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/input/Kconfig
--- a/drivers/input/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/input/Kconfig
@@ -6,7 +6,7 @@ menu "Input device support"
 	depends on !S390
 
 config INPUT
-	tristate "Generic input layer (needed for keyboard, mouse, ...)" if EMBEDDED
+	tristate "Generic input layer (needed for keyboard, mouse, ...)" if EXPERT
 	default y
 	help
 	  Say Y here if you have any input device (mouse, keyboard, tablet,
@@ -67,7 +67,7 @@ config INPUT_SPARSEKMAP
 comment "Userland interfaces"
 
 config INPUT_MOUSEDEV
-	tristate "Mouse interface" if EMBEDDED
+	tristate "Mouse interface" if EXPERT
 	default y
 	help
 	  Say Y here if you want your mouse to be accessible as char devices
@@ -150,7 +150,7 @@ config INPUT_EVBUG
 	  module will be called evbug.
 
 config INPUT_APMPOWER
-	tristate "Input Power Event -> APM Bridge" if EMBEDDED
+	tristate "Input Power Event -> APM Bridge" if EXPERT
 	depends on INPUT && APM_EMULATION
 	help
 	  Say Y here if you want suspend key events to trigger a user
diff -puN drivers/input/keyboard/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/input/keyboard/Kconfig
--- a/drivers/input/keyboard/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/input/keyboard/Kconfig
@@ -2,7 +2,7 @@
 # Input core configuration
 #
 menuconfig INPUT_KEYBOARD
-	bool "Keyboards" if EMBEDDED || !X86
+	bool "Keyboards" if EXPERT || !X86
 	default y
 	help
 	  Say Y here, and a list of supported keyboards will be displayed.
@@ -57,7 +57,7 @@ config KEYBOARD_ATARI
 	  module will be called atakbd.
 
 config KEYBOARD_ATKBD
-	tristate "AT keyboard" if EMBEDDED || !X86
+	tristate "AT keyboard" if EXPERT || !X86
 	default y
 	select SERIO
 	select SERIO_LIBPS2
diff -puN drivers/input/mouse/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/input/mouse/Kconfig
--- a/drivers/input/mouse/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/input/mouse/Kconfig
@@ -39,7 +39,7 @@ config MOUSE_PS2
 	  module will be called psmouse.
 
 config MOUSE_PS2_ALPS
-	bool "ALPS PS/2 mouse protocol extension" if EMBEDDED
+	bool "ALPS PS/2 mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2
 	help
@@ -49,7 +49,7 @@ config MOUSE_PS2_ALPS
 	  If unsure, say Y.
 
 config MOUSE_PS2_LOGIPS2PP
-	bool "Logitech PS/2++ mouse protocol extension" if EMBEDDED
+	bool "Logitech PS/2++ mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2
 	help
@@ -59,7 +59,7 @@ config MOUSE_PS2_LOGIPS2PP
 	  If unsure, say Y.
 
 config MOUSE_PS2_SYNAPTICS
-	bool "Synaptics PS/2 mouse protocol extension" if EMBEDDED
+	bool "Synaptics PS/2 mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2
 	help
@@ -69,7 +69,7 @@ config MOUSE_PS2_SYNAPTICS
 	  If unsure, say Y.
 
 config MOUSE_PS2_LIFEBOOK
-	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EMBEDDED
+	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2 && X86 && DMI
 	help
@@ -79,7 +79,7 @@ config MOUSE_PS2_LIFEBOOK
 	  If unsure, say Y.
 
 config MOUSE_PS2_TRACKPOINT
-	bool "IBM Trackpoint PS/2 mouse protocol extension" if EMBEDDED
+	bool "IBM Trackpoint PS/2 mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2
 	help
diff -puN drivers/input/serio/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/input/serio/Kconfig
--- a/drivers/input/serio/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/input/serio/Kconfig
@@ -2,7 +2,7 @@
 # Input core configuration
 #
 config SERIO
-	tristate "Serial I/O support" if EMBEDDED || !X86
+	tristate "Serial I/O support" if EXPERT || !X86
 	default y
 	help
 	  Say Yes here if you have any input device that uses serial I/O to
@@ -19,7 +19,7 @@ config SERIO
 if SERIO
 
 config SERIO_I8042
-	tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
+	tristate "i8042 PC Keyboard controller" if EXPERT || !X86
 	default y
 	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
 		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
@@ -168,7 +168,7 @@ config SERIO_MACEPS2
 	  module will be called maceps2.
 
 config SERIO_LIBPS2
-	tristate "PS/2 driver library" if EMBEDDED
+	tristate "PS/2 driver library" if EXPERT
 	depends on SERIO_I8042 || SERIO_I8042=n
 	help
 	  Say Y here if you are using a driver for device connected
diff -puN drivers/input/touchscreen/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/input/touchscreen/Kconfig
--- a/drivers/input/touchscreen/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/input/touchscreen/Kconfig
@@ -540,62 +540,62 @@ config TOUCHSCREEN_MC13783
 
 config TOUCHSCREEN_USB_EGALAX
 	default y
-	bool "eGalax, eTurboTouch CT-410/510/700 device support" if EMBEDDED
+	bool "eGalax, eTurboTouch CT-410/510/700 device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_PANJIT
 	default y
-	bool "PanJit device support" if EMBEDDED
+	bool "PanJit device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_3M
 	default y
-	bool "3M/Microtouch EX II series device support" if EMBEDDED
+	bool "3M/Microtouch EX II series device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_ITM
 	default y
-	bool "ITM device support" if EMBEDDED
+	bool "ITM device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_ETURBO
 	default y
-	bool "eTurboTouch (non-eGalax compatible) device support" if EMBEDDED
+	bool "eTurboTouch (non-eGalax compatible) device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_GUNZE
 	default y
-	bool "Gunze AHL61 device support" if EMBEDDED
+	bool "Gunze AHL61 device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_DMC_TSC10
 	default y
-	bool "DMC TSC-10/25 device support" if EMBEDDED
+	bool "DMC TSC-10/25 device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_IRTOUCH
 	default y
-	bool "IRTOUCHSYSTEMS/UNITOP device support" if EMBEDDED
+	bool "IRTOUCHSYSTEMS/UNITOP device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_IDEALTEK
 	default y
-	bool "IdealTEK URTC1000 device support" if EMBEDDED
+	bool "IdealTEK URTC1000 device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_GENERAL_TOUCH
 	default y
-	bool "GeneralTouch Touchscreen device support" if EMBEDDED
+	bool "GeneralTouch Touchscreen device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_GOTOP
 	default y
-	bool "GoTop Super_Q2/GogoPen/PenPower tablet device support" if EMBEDDED
+	bool "GoTop Super_Q2/GogoPen/PenPower tablet device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_JASTEC
 	default y
-	bool "JASTEC/DigiTech DTR-02U USB touch controller device support" if EMBEDDED
+	bool "JASTEC/DigiTech DTR-02U USB touch controller device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_E2I
@@ -605,17 +605,17 @@ config TOUCHSCREEN_USB_E2I
 
 config TOUCHSCREEN_USB_ZYTRONIC
 	default y
-	bool "Zytronic controller" if EMBEDDED
+	bool "Zytronic controller" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_ETT_TC45USB
 	default y
-	bool "ET&T USB series TC4UM/TC5UH touchscreen controller support" if EMBEDDED
+	bool "ET&T USB series TC4UM/TC5UH touchscreen controller support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_NEXIO
 	default y
-	bool "NEXIO/iNexio device support" if EMBEDDED
+	bool "NEXIO/iNexio device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_TOUCHIT213
diff -puN drivers/media/common/tuners/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/media/common/tuners/Kconfig
--- a/drivers/media/common/tuners/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/media/common/tuners/Kconfig
@@ -34,7 +34,7 @@ config MEDIA_TUNER
 config MEDIA_TUNER_CUSTOMISE
 	bool "Customize analog and hybrid tuner modules to build"
 	depends on MEDIA_TUNER
-	default y if EMBEDDED
+	default y if EXPERT
 	help
 	  This allows the user to deselect tuner drivers unnecessary
 	  for their hardware from the build. Use this option with care
diff -puN drivers/media/dvb/frontends/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/media/dvb/frontends/Kconfig
--- a/drivers/media/dvb/frontends/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/media/dvb/frontends/Kconfig
@@ -1,7 +1,7 @@
 config DVB_FE_CUSTOMISE
 	bool "Customise the frontend modules to build"
 	depends on DVB_CORE
-	default y if EMBEDDED
+	default y if EXPERT
 	help
 	  This allows the user to select/deselect frontend drivers for their
 	  hardware from the build.
diff -puN drivers/media/video/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/media/video/Kconfig
@@ -78,7 +78,7 @@ config VIDEO_FIXED_MINOR_RANGES
 
 config VIDEO_HELPER_CHIPS_AUTO
 	bool "Autoselect pertinent encoders/decoders and other helper chips"
-	default y if !EMBEDDED
+	default y if !EXPERT
 	---help---
 	  Most video cards may require additional modules to encode or
 	  decode audio/video standards. This option will autoselect
diff -puN drivers/net/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/net/Kconfig
--- a/drivers/net/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/net/Kconfig
@@ -2864,7 +2864,7 @@ config MLX4_CORE
 	default n
 
 config MLX4_DEBUG
-	bool "Verbose debugging output" if (MLX4_CORE && EMBEDDED)
+	bool "Verbose debugging output" if (MLX4_CORE && EXPERT)
 	depends on MLX4_CORE
 	default y
 	---help---
diff -puN drivers/pci/pcie/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/pci/pcie/Kconfig
--- a/drivers/pci/pcie/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/pci/pcie/Kconfig
@@ -31,7 +31,7 @@ source "drivers/pci/pcie/aer/Kconfig"
 # PCI Express ASPM
 #
 config PCIEASPM
-	bool "PCI Express ASPM control" if EMBEDDED
+	bool "PCI Express ASPM control" if EXPERT
 	depends on PCI && PCIEPORTBUS
 	default y
 	help
diff -puN drivers/pcmcia/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/pcmcia/Kconfig
--- a/drivers/pcmcia/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/pcmcia/Kconfig
@@ -69,7 +69,7 @@ comment "PC-card bridges"
 config YENTA
 	tristate "CardBus yenta-compatible bridge support"
 	depends on PCI
-	select CARDBUS if !EMBEDDED
+	select CARDBUS if !EXPERT
 	select PCCARD_NONSTATIC if PCMCIA != n
 	---help---
 	  This option enables support for CardBus host bridges.  Virtually
@@ -84,27 +84,27 @@ config YENTA
 
 config YENTA_O2
 	default y
-	bool "Special initialization for O2Micro bridges" if EMBEDDED
+	bool "Special initialization for O2Micro bridges" if EXPERT
 	depends on YENTA
 
 config YENTA_RICOH
 	default y
-	bool "Special initialization for Ricoh bridges" if EMBEDDED
+	bool "Special initialization for Ricoh bridges" if EXPERT
 	depends on YENTA
 
 config YENTA_TI
 	default y
-	bool "Special initialization for TI and EnE bridges" if EMBEDDED
+	bool "Special initialization for TI and EnE bridges" if EXPERT
 	depends on YENTA
 
 config YENTA_ENE_TUNE
 	default y
-	bool "Auto-tune EnE bridges for CB cards" if EMBEDDED
+	bool "Auto-tune EnE bridges for CB cards" if EXPERT
 	depends on YENTA_TI && CARDBUS
 
 config YENTA_TOSHIBA
 	default y
-	bool "Special initialization for Toshiba ToPIC bridges" if EMBEDDED
+	bool "Special initialization for Toshiba ToPIC bridges" if EXPERT
 	depends on YENTA
 
 config PD6729
diff -puN drivers/serial/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/serial/Kconfig
@@ -81,7 +81,7 @@ config SERIAL_8250_GSC
 	default SERIAL_8250
 
 config SERIAL_8250_PCI
-	tristate "8250/16550 PCI device support" if EMBEDDED
+	tristate "8250/16550 PCI device support" if EXPERT
 	depends on SERIAL_8250 && PCI
 	default SERIAL_8250
 	help
@@ -90,7 +90,7 @@ config SERIAL_8250_PCI
 	  Saves about 9K.
 
 config SERIAL_8250_PNP
-	tristate "8250/16550 PNP device support" if EMBEDDED
+	tristate "8250/16550 PNP device support" if EXPERT
 	depends on SERIAL_8250 && PNP
 	default SERIAL_8250
 	help
diff -puN drivers/ssb/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/ssb/Kconfig
--- a/drivers/ssb/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/ssb/Kconfig
@@ -82,7 +82,7 @@ config SSB_SDIOHOST
 
 config SSB_SILENT
 	bool "No SSB kernel messages"
-	depends on SSB && EMBEDDED
+	depends on SSB && EXPERT
 	help
 	  This option turns off all Sonics Silicon Backplane printks.
 	  Note that you won't be able to identify problems, once
diff -puN drivers/usb/core/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/usb/core/Kconfig
--- a/drivers/usb/core/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/usb/core/Kconfig
@@ -123,9 +123,9 @@ config USB_OTG
 
 config USB_OTG_WHITELIST
 	bool "Rely on OTG Targeted Peripherals List"
-	depends on USB_OTG || EMBEDDED
+	depends on USB_OTG || EXPERT
 	default y if USB_OTG
-	default n if EMBEDDED
+	default n if EXPERT
 	help
 	  If you say Y here, the "otg_whitelist.h" file will be used as a
 	  product whitelist, so USB peripherals not listed there will be
@@ -141,7 +141,7 @@ config USB_OTG_WHITELIST
 
 config USB_OTG_BLACKLIST_HUB
 	bool "Disable external hubs"
-	depends on USB_OTG || EMBEDDED
+	depends on USB_OTG || EXPERT
 	help
 	  If you say Y here, then Linux will refuse to enumerate
 	  external hubs.  OTG hosts are allowed to reduce hardware
diff -puN drivers/video/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/video/Kconfig
--- a/drivers/video/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/video/Kconfig
@@ -1227,7 +1227,7 @@ config FB_CARILLO_RANCH
 
 config FB_INTEL
 	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL && EMBEDDED
+	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL && EXPERT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
diff -puN drivers/video/console/Kconfig~kconfig-rename-config_embedded-to-config_expert drivers/video/console/Kconfig
--- a/drivers/video/console/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/drivers/video/console/Kconfig
@@ -5,7 +5,7 @@
 menu "Console display driver support"
 
 config VGA_CONSOLE
-	bool "VGA text console" if EMBEDDED || !X86
+	bool "VGA text console" if EXPERT || !X86
 	depends on !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !SUPERH && !BLACKFIN && !AVR32 && !MN10300 && (!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER)
 	default y
 	help
diff -puN fs/Kconfig~kconfig-rename-config_embedded-to-config_expert fs/Kconfig
--- a/fs/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/fs/Kconfig
@@ -50,7 +50,7 @@ config EXPORTFS
 	tristate
 
 config FILE_LOCKING
-	bool "Enable POSIX file locking API" if EMBEDDED
+	bool "Enable POSIX file locking API" if EXPERT
 	default y
 	help
 	  This option enables standard file locking support, required
diff -puN fs/proc/Kconfig~kconfig-rename-config_embedded-to-config_expert fs/proc/Kconfig
--- a/fs/proc/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/fs/proc/Kconfig
@@ -1,5 +1,5 @@
 config PROC_FS
-	bool "/proc file system support" if EMBEDDED
+	bool "/proc file system support" if EXPERT
 	default y
 	help
 	  This is a virtual file system providing information about the status
@@ -40,7 +40,7 @@ config PROC_VMCORE
         Exports the dump image of crashed kernel in ELF format.
 
 config PROC_SYSCTL
-	bool "Sysctl support (/proc/sys)" if EMBEDDED
+	bool "Sysctl support (/proc/sys)" if EXPERT
 	depends on PROC_FS
 	select SYSCTL
 	default y
@@ -61,7 +61,7 @@ config PROC_SYSCTL
 config PROC_PAGE_MONITOR
  	default y
 	depends on PROC_FS && MMU
-	bool "Enable /proc page monitoring" if EMBEDDED
+	bool "Enable /proc page monitoring" if EXPERT
  	help
 	  Various /proc files exist to monitor process memory utilization:
 	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
diff -puN fs/sysfs/Kconfig~kconfig-rename-config_embedded-to-config_expert fs/sysfs/Kconfig
--- a/fs/sysfs/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/fs/sysfs/Kconfig
@@ -1,5 +1,5 @@
 config SYSFS
-	bool "sysfs file system support" if EMBEDDED
+	bool "sysfs file system support" if EXPERT
 	default y
 	help
 	The sysfs filesystem is a virtual filesystem that the kernel uses to
diff -puN init/Kconfig~kconfig-rename-config_embedded-to-config_expert init/Kconfig
--- a/init/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/init/Kconfig
@@ -745,8 +745,8 @@ config DEBUG_BLK_CGROUP
 endif # CGROUPS
 
 menuconfig NAMESPACES
-	bool "Namespaces support" if EMBEDDED
-	default !EMBEDDED
+	bool "Namespaces support" if EXPERT
+	default !EXPERT
 	help
 	  Provides the way to make tasks work with different objects using
 	  the same id. For example same IPC id may refer to different objects
@@ -899,23 +899,31 @@ config SYSCTL
 config ANON_INODES
 	bool
 
-menuconfig EMBEDDED
-	bool "Configure standard kernel features (for small systems)"
+menuconfig EXPERT
+	bool "Configure standard kernel features (expert users)"
 	help
 	  This option allows certain base kernel options and settings
           to be disabled or tweaked. This is for specialized
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
+config EMBEDDED
+	bool "Embedded system"
+	select EXPERT
+	help
+	  This option should be enabled if compiling the kernel for
+	  an embedded system so certain expert options are available
+	  for configuration.
+
 config UID16
-	bool "Enable 16-bit UID system calls" if EMBEDDED
+	bool "Enable 16-bit UID system calls" if EXPERT
 	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
 	default y
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
 
 config SYSCTL_SYSCALL
-	bool "Sysctl syscall support" if EMBEDDED
+	bool "Sysctl syscall support" if EXPERT
 	depends on PROC_SYSCTL
 	default y
 	select SYSCTL
@@ -932,7 +940,7 @@ config SYSCTL_SYSCALL
 	  If unsure say Y here.
 
 config KALLSYMS
-	 bool "Load all symbols for debugging/ksymoops" if EMBEDDED
+	 bool "Load all symbols for debugging/ksymoops" if EXPERT
 	 default y
 	 help
 	   Say Y here to let the kernel print out symbolic crash information and
@@ -963,7 +971,7 @@ config KALLSYMS_EXTRA_PASS
 
 
 config HOTPLUG
-	bool "Support for hot-pluggable devices" if EMBEDDED
+	bool "Support for hot-pluggable devices" if EXPERT
 	default y
 	help
 	  This option is provided for the case where no hotplug or uevent
@@ -973,7 +981,7 @@ config HOTPLUG
 
 config PRINTK
 	default y
-	bool "Enable support for printk" if EMBEDDED
+	bool "Enable support for printk" if EXPERT
 	help
 	  This option enables normal printk support. Removing it
 	  eliminates most of the message strings from the kernel image
@@ -982,7 +990,7 @@ config PRINTK
 	  strongly discouraged.
 
 config BUG
-	bool "BUG() support" if EMBEDDED
+	bool "BUG() support" if EXPERT
 	default y
 	help
           Disabling this option eliminates support for BUG and WARN, reducing
@@ -993,12 +1001,12 @@ config BUG
 
 config ELF_CORE
 	default y
-	bool "Enable ELF core dumps" if EMBEDDED
+	bool "Enable ELF core dumps" if EXPERT
 	help
 	  Enable support for generating core dumps. Disabling saves about 4k.
 
 config PCSPKR_PLATFORM
-	bool "Enable PC-Speaker support" if EMBEDDED
+	bool "Enable PC-Speaker support" if EXPERT
 	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
 	default y
 	help
@@ -1007,14 +1015,14 @@ config PCSPKR_PLATFORM
 
 config BASE_FULL
 	default y
-	bool "Enable full-sized data structures for core" if EMBEDDED
+	bool "Enable full-sized data structures for core" if EXPERT
 	help
 	  Disabling this option reduces the size of miscellaneous core
 	  kernel data structures. This saves memory on small machines,
 	  but may reduce performance.
 
 config FUTEX
-	bool "Enable futex support" if EMBEDDED
+	bool "Enable futex support" if EXPERT
 	default y
 	select RT_MUTEXES
 	help
@@ -1023,7 +1031,7 @@ config FUTEX
 	  run glibc-based applications correctly.
 
 config EPOLL
-	bool "Enable eventpoll support" if EMBEDDED
+	bool "Enable eventpoll support" if EXPERT
 	default y
 	select ANON_INODES
 	help
@@ -1031,7 +1039,7 @@ config EPOLL
 	  support for epoll family of system calls.
 
 config SIGNALFD
-	bool "Enable signalfd() system call" if EMBEDDED
+	bool "Enable signalfd() system call" if EXPERT
 	select ANON_INODES
 	default y
 	help
@@ -1041,7 +1049,7 @@ config SIGNALFD
 	  If unsure, say Y.
 
 config TIMERFD
-	bool "Enable timerfd() system call" if EMBEDDED
+	bool "Enable timerfd() system call" if EXPERT
 	select ANON_INODES
 	default y
 	help
@@ -1051,7 +1059,7 @@ config TIMERFD
 	  If unsure, say Y.
 
 config EVENTFD
-	bool "Enable eventfd() system call" if EMBEDDED
+	bool "Enable eventfd() system call" if EXPERT
 	select ANON_INODES
 	default y
 	help
@@ -1061,7 +1069,7 @@ config EVENTFD
 	  If unsure, say Y.
 
 config SHMEM
-	bool "Use full shmem filesystem" if EMBEDDED
+	bool "Use full shmem filesystem" if EXPERT
 	default y
 	depends on MMU
 	help
@@ -1072,7 +1080,7 @@ config SHMEM
 	  which may be appropriate on small systems without swap.
 
 config AIO
-	bool "Enable AIO support" if EMBEDDED
+	bool "Enable AIO support" if EXPERT
 	default y
 	help
 	  This option enables POSIX asynchronous I/O which may by used
@@ -1149,16 +1157,16 @@ endmenu
 
 config VM_EVENT_COUNTERS
 	default y
-	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
+	bool "Enable VM event counters for /proc/vmstat" if EXPERT
 	help
 	  VM event counters are needed for event counts to be shown.
 	  This option allows the disabling of the VM event counters
-	  on EMBEDDED systems.  /proc/vmstat will only show page counts
+	  on EXPERT systems.  /proc/vmstat will only show page counts
 	  if VM event counters are disabled.
 
 config PCI_QUIRKS
 	default y
-	bool "Enable PCI quirk workarounds" if EMBEDDED
+	bool "Enable PCI quirk workarounds" if EXPERT
 	depends on PCI
 	help
 	  This enables workarounds for various PCI chipset
@@ -1167,7 +1175,7 @@ config PCI_QUIRKS
 
 config SLUB_DEBUG
 	default y
-	bool "Enable SLUB debugging support" if EMBEDDED
+	bool "Enable SLUB debugging support" if EXPERT
 	depends on SLUB && SYSFS
 	help
 	  SLUB has extensive debug support features. Disabling these can
@@ -1211,7 +1219,7 @@ config SLUB
 	   a slab allocator.
 
 config SLOB
-	depends on EMBEDDED
+	depends on EXPERT
 	bool "SLOB (Simple Allocator)"
 	help
 	   SLOB replaces the stock allocator with a drastically simpler
@@ -1222,7 +1230,7 @@ endchoice
 
 config MMAP_ALLOW_UNINITIALIZED
 	bool "Allow mmapped anonymous memory to be uninitialized"
-	depends on EMBEDDED && !MMU
+	depends on EXPERT && !MMU
 	default n
 	help
 	  Normally, and according to the Linux spec, anonymous memory obtained
diff -puN lib/Kconfig.debug~kconfig-rename-config_embedded-to-config_expert lib/Kconfig.debug
--- a/lib/Kconfig.debug~kconfig-rename-config_embedded-to-config_expert
+++ a/lib/Kconfig.debug
@@ -657,7 +657,7 @@ config DEBUG_HIGHMEM
 	  Disable for production systems.
 
 config DEBUG_BUGVERBOSE
-	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EMBEDDED
+	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
 	depends on BUG
 	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
 		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300
@@ -729,8 +729,8 @@ config DEBUG_WRITECOUNT
 	  If unsure, say N.
 
 config DEBUG_MEMORY_INIT
-	bool "Debug memory initialisation" if EMBEDDED
-	default !EMBEDDED
+	bool "Debug memory initialisation" if EXPERT
+	default !EXPERT
 	help
 	  Enable this for additional checks during memory initialisation.
 	  The sanity checks verify aspects of the VM such as the memory model
diff -puN lib/xz/Kconfig~kconfig-rename-config_embedded-to-config_expert lib/xz/Kconfig
--- a/lib/xz/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/lib/xz/Kconfig
@@ -7,37 +7,37 @@ config XZ_DEC
 	  CRC32 is supported. See Documentation/xz.txt for more information.
 
 config XZ_DEC_X86
-	bool "x86 BCJ filter decoder" if EMBEDDED
+	bool "x86 BCJ filter decoder" if EXPERT
 	default y
 	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_POWERPC
-	bool "PowerPC BCJ filter decoder" if EMBEDDED
+	bool "PowerPC BCJ filter decoder" if EXPERT
 	default y
 	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
-	bool "IA-64 BCJ filter decoder" if EMBEDDED
+	bool "IA-64 BCJ filter decoder" if EXPERT
 	default y
 	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARM
-	bool "ARM BCJ filter decoder" if EMBEDDED
+	bool "ARM BCJ filter decoder" if EXPERT
 	default y
 	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARMTHUMB
-	bool "ARM-Thumb BCJ filter decoder" if EMBEDDED
+	bool "ARM-Thumb BCJ filter decoder" if EXPERT
 	default y
 	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_SPARC
-	bool "SPARC BCJ filter decoder" if EMBEDDED
+	bool "SPARC BCJ filter decoder" if EXPERT
 	default y
 	depends on XZ_DEC
 	select XZ_DEC_BCJ
diff -puN net/mac80211/Kconfig~kconfig-rename-config_embedded-to-config_expert net/mac80211/Kconfig
--- a/net/mac80211/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/net/mac80211/Kconfig
@@ -20,7 +20,7 @@ config MAC80211_HAS_RC
 	def_bool n
 
 config MAC80211_RC_PID
-	bool "PID controller based rate control algorithm" if EMBEDDED
+	bool "PID controller based rate control algorithm" if EXPERT
 	select MAC80211_HAS_RC
 	---help---
 	  This option enables a TX rate control algorithm for
@@ -28,14 +28,14 @@ config MAC80211_RC_PID
 	  rate.
 
 config MAC80211_RC_MINSTREL
-	bool "Minstrel" if EMBEDDED
+	bool "Minstrel" if EXPERT
 	select MAC80211_HAS_RC
 	default y
 	---help---
 	  This option enables the 'minstrel' TX rate control algorithm
 
 config MAC80211_RC_MINSTREL_HT
-	bool "Minstrel 802.11n support" if EMBEDDED
+	bool "Minstrel 802.11n support" if EXPERT
 	depends on MAC80211_RC_MINSTREL
 	default y
 	---help---
diff -puN net/rfkill/Kconfig~kconfig-rename-config_embedded-to-config_expert net/rfkill/Kconfig
--- a/net/rfkill/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/net/rfkill/Kconfig
@@ -18,7 +18,7 @@ config RFKILL_LEDS
 	default y
 
 config RFKILL_INPUT
-	bool "RF switch input support" if EMBEDDED
+	bool "RF switch input support" if EXPERT
 	depends on RFKILL
 	depends on INPUT = y || RFKILL = INPUT
-	default y if !EMBEDDED
+	default y if !EXPERT
diff -puN net/wireless/Kconfig~kconfig-rename-config_embedded-to-config_expert net/wireless/Kconfig
--- a/net/wireless/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/net/wireless/Kconfig
@@ -95,7 +95,7 @@ config CFG80211_DEBUGFS
 	  If unsure, say N.
 
 config CFG80211_INTERNAL_REGDB
-	bool "use statically compiled regulatory rules database" if EMBEDDED
+	bool "use statically compiled regulatory rules database" if EXPERT
 	default n
 	depends on CFG80211
 	---help---
diff -puN usr/Kconfig~kconfig-rename-config_embedded-to-config_expert usr/Kconfig
--- a/usr/Kconfig~kconfig-rename-config_embedded-to-config_expert
+++ a/usr/Kconfig
@@ -46,7 +46,7 @@ config INITRAMFS_ROOT_GID
 	  If you are not sure, leave it set to "0".
 
 config RD_GZIP
-	bool "Support initial ramdisks compressed using gzip" if EMBEDDED
+	bool "Support initial ramdisks compressed using gzip" if EXPERT
 	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_GZIP
@@ -55,8 +55,8 @@ config RD_GZIP
 	  If unsure, say Y.
 
 config RD_BZIP2
-	bool "Support initial ramdisks compressed using bzip2" if EMBEDDED
-	default !EMBEDDED
+	bool "Support initial ramdisks compressed using bzip2" if EXPERT
+	default !EXPERT
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_BZIP2
 	help
@@ -64,8 +64,8 @@ config RD_BZIP2
 	  If unsure, say N.
 
 config RD_LZMA
-	bool "Support initial ramdisks compressed using LZMA" if EMBEDDED
-	default !EMBEDDED
+	bool "Support initial ramdisks compressed using LZMA" if EXPERT
+	default !EXPERT
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZMA
 	help
@@ -73,8 +73,8 @@ config RD_LZMA
 	  If unsure, say N.
 
 config RD_XZ
-	bool "Support initial ramdisks compressed using XZ" if EMBEDDED
-	default !EMBEDDED
+	bool "Support initial ramdisks compressed using XZ" if EXPERT
+	default !EXPERT
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_XZ
 	help
@@ -82,8 +82,8 @@ config RD_XZ
 	  If unsure, say N.
 
 config RD_LZO
-	bool "Support initial ramdisks compressed using LZO" if EMBEDDED
-	default !EMBEDDED
+	bool "Support initial ramdisks compressed using LZO" if EXPERT
+	default !EXPERT
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZO
 	help
_

Patches currently in -mm which might be from rientjes@google.com are

kconfig-rename-config_embedded-to-config_expert.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
jbd-remove-dependency-on-__gfp_nofail.patch

