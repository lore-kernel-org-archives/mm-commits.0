From: akpm@linux-foundation.org
Subject: + cleanup-the-includes-of-linux-pcih.patch added to -mm tree
Date: Fri, 02 Mar 2007 14:33:28 -0800
Message-ID: <200703022233.l22MXS6N021050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44724 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030655AbXCBWdx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 17:33:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, greg@kroah.com


The patch titled
     Cleanup the includes of <linux/pci.h>
has been added to the -mm tree.  Its filename is
     cleanup-the-includes-of-linux-pcih.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Cleanup the includes of <linux/pci.h>
From: Jean Delvare <khali@linux-fr.org>

I noticed that many source files include <linux/pci.h> while they do not
appear to need it.  Here is an attempt to clean it all up.

In order to find all possibly affected files, I searched for all files
including <linux/pci.h> but without any other occurence of "pci" or "PCI". 
I removed the include statement from all of these, then I compiled an
allmodconfig kernel on both i386 and x86_64 and fixed the false positives
manually.

My tests covered 66% of the affected files, so there could be false
positives remaining.  Untested files are:

arch/alpha/kernel/err_common.c
arch/alpha/kernel/err_ev6.c
arch/alpha/kernel/err_ev7.c
arch/ia64/sn/kernel/huberror.c
arch/ia64/sn/kernel/xpnet.c
arch/m68knommu/kernel/dma.c
arch/mips/lib/iomap.c
arch/powerpc/platforms/pseries/ras.c
arch/ppc/8260_io/enet.c
arch/ppc/8260_io/fcc_enet.c
arch/ppc/8xx_io/enet.c
arch/ppc/syslib/ppc4xx_sgdma.c
arch/sh64/mach-cayman/iomap.c
arch/xtensa/kernel/xtensa_ksyms.c
arch/xtensa/platform-iss/setup.c
drivers/i2c/busses/i2c-at91.c
drivers/i2c/busses/i2c-mpc.c
drivers/media/video/saa711x.c
drivers/misc/hdpuftrs/hdpu_cpustate.c
drivers/misc/hdpuftrs/hdpu_nexus.c
drivers/net/au1000_eth.c
drivers/net/fec_8xx/fec_main.c
drivers/net/fec_8xx/fec_mii.c
drivers/net/fs_enet/fs_enet-main.c
drivers/net/fs_enet/mac-fcc.c
drivers/net/fs_enet/mac-fec.c
drivers/net/fs_enet/mac-scc.c
drivers/net/fs_enet/mii-bitbang.c
drivers/net/fs_enet/mii-fec.c
drivers/net/ibm_emac/ibm_emac_core.c
drivers/net/lasi_82596.c
drivers/parisc/hppb.c
drivers/sbus/sbus.c
drivers/video/g364fb.c
drivers/video/platinumfb.c
drivers/video/stifb.c
drivers/video/valkyriefb.c
include/asm-arm/arch-ixp4xx/dma.h
sound/oss/au1550_ac97.c
sound/ppc/beep.c

I would welcome test reports for these files.  I am fine with removing the
untested files from the patch if the general opinion is that these changes
aren't safe.  The tested part would still be nice to have.

Note that this patch depends on another header fixup patch I submitted
to LKML yesterday:
  [PATCH] scatterlist.h needs types.h
  http://lkml.org/lkml/2007/3/01/141

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/err_common.c               |    1 -
 arch/alpha/kernel/err_ev6.c                  |    1 -
 arch/alpha/kernel/err_ev7.c                  |    1 -
 arch/i386/kernel/cpu/cpufreq/speedstep-lib.c |    1 -
 arch/i386/kernel/cpu/cpufreq/speedstep-smi.c |    2 +-
 arch/ia64/sn/kernel/huberror.c               |    1 -
 arch/ia64/sn/kernel/xpnet.c                  |    1 -
 arch/m68knommu/kernel/dma.c                  |    1 -
 arch/mips/lib/iomap.c                        |    1 -
 arch/powerpc/platforms/pseries/ras.c         |    1 -
 arch/ppc/8260_io/enet.c                      |    1 -
 arch/ppc/8260_io/fcc_enet.c                  |    1 -
 arch/ppc/8xx_io/enet.c                       |    1 -
 arch/ppc/syslib/ppc4xx_sgdma.c               |    1 -
 arch/sh64/mach-cayman/iomap.c                |    1 -
 arch/xtensa/kernel/xtensa_ksyms.c            |    1 -
 arch/xtensa/platform-iss/setup.c             |    1 -
 drivers/ata/pata_winbond.c                   |    1 -
 drivers/atm/adummy.c                         |    1 -
 drivers/char/hw_random/via-rng.c             |    1 -
 drivers/char/pcmcia/synclink_cs.c            |    1 -
 drivers/char/tpm/tpm.h                       |    1 -
 drivers/char/watchdog/sc1200wdt.c            |    1 -
 drivers/char/watchdog/scx200_wdt.c           |    2 +-
 drivers/i2c/busses/i2c-at91.c                |    1 -
 drivers/i2c/busses/i2c-mpc.c                 |    1 -
 drivers/i2c/busses/i2c-pca-isa.c             |    1 -
 drivers/ieee1394/hosts.c                     |    1 -
 drivers/infiniband/core/cm.c                 |    1 -
 drivers/infiniband/core/iwcm.c               |    1 -
 drivers/infiniband/core/mad_priv.h           |    1 -
 drivers/infiniband/core/multicast.c          |    1 -
 drivers/infiniband/core/sa_query.c           |    1 -
 drivers/infiniband/core/user_mad.c           |    1 -
 drivers/infiniband/hw/ipath/ipath_fs.c       |    1 -
 drivers/infiniband/hw/ipath/ipath_layer.c    |    1 -
 drivers/infiniband/hw/ipath/ipath_stats.c    |    2 --
 drivers/infiniband/hw/ipath/ipath_sysfs.c    |    1 -
 drivers/infiniband/hw/mthca/mthca_memfree.h  |    1 -
 drivers/infiniband/ulp/ipoib/ipoib.h         |    1 -
 drivers/isdn/hisax/netjet.c                  |    1 -
 drivers/isdn/hysdn/hysdn_proclog.c           |    1 -
 drivers/media/dvb/cinergyT2/cinergyT2.c      |    2 +-
 drivers/media/video/adv7170.c                |    1 -
 drivers/media/video/adv7175.c                |    1 -
 drivers/media/video/bt819.c                  |    1 -
 drivers/media/video/bt856.c                  |    1 -
 drivers/media/video/bt866.c                  |    1 -
 drivers/media/video/cx88/cx88-tvaudio.c      |    1 -
 drivers/media/video/em28xx/em28xx-cards.c    |    1 -
 drivers/media/video/saa7111.c                |    1 -
 drivers/media/video/saa7114.c                |    1 -
 drivers/media/video/saa711x.c                |    1 -
 drivers/media/video/saa7185.c                |    1 -
 drivers/misc/hdpuftrs/hdpu_cpustate.c        |    1 -
 drivers/misc/hdpuftrs/hdpu_nexus.c           |    1 -
 drivers/mtd/devices/doc2000.c                |    1 -
 drivers/mtd/devices/doc2001.c                |    1 -
 drivers/mtd/devices/doc2001plus.c            |    1 -
 drivers/mtd/devices/docecc.c                 |    1 -
 drivers/mtd/inftlmount.c                     |    1 -
 drivers/mtd/nand/cs553x_nand.c               |    1 -
 drivers/mtd/nftlcore.c                       |    1 -
 drivers/net/atl1/atl1_param.c                |    1 -
 drivers/net/au1000_eth.c                     |    1 -
 drivers/net/fec_8xx/fec_main.c               |    1 -
 drivers/net/fec_8xx/fec_mii.c                |    1 -
 drivers/net/fs_enet/fs_enet-main.c           |    1 -
 drivers/net/fs_enet/mac-fcc.c                |    1 -
 drivers/net/fs_enet/mac-fec.c                |    1 -
 drivers/net/fs_enet/mac-scc.c                |    1 -
 drivers/net/fs_enet/mii-bitbang.c            |    1 -
 drivers/net/fs_enet/mii-fec.c                |    1 -
 drivers/net/ibm_emac/ibm_emac_core.c         |    1 -
 drivers/net/ixgb/ixgb_osdep.h                |    1 -
 drivers/net/lasi_82596.c                     |    1 -
 drivers/net/tokenring/madgemc.c              |    1 -
 drivers/net/tokenring/smctr.c                |    1 -
 drivers/net/tulip/21142.c                    |    1 -
 drivers/net/tulip/pnic.c                     |    1 -
 drivers/net/tulip/pnic2.c                    |    1 -
 drivers/net/tulip/timer.c                    |    1 -
 drivers/net/tulip/tulip.h                    |    1 +
 drivers/net/wan/lmc/lmc_media.c              |    1 -
 drivers/net/wan/lmc/lmc_proto.c              |    1 -
 drivers/net/wan/pc300_tty.c                  |    1 -
 drivers/parisc/hppb.c                        |    2 --
 drivers/pcmcia/cs.c                          |    1 -
 drivers/pcmcia/socket_sysfs.c                |    1 -
 drivers/sbus/sbus.c                          |    1 -
 drivers/scsi/aacraid/dpcsup.c                |    1 -
 drivers/scsi/aacraid/sa.c                    |    1 -
 drivers/scsi/aha1542.c                       |    1 -
 drivers/scsi/aic94xx/aic94xx_scb.c           |    1 -
 drivers/scsi/arcmsr/arcmsr_attr.c            |    1 -
 drivers/scsi/libsas/sas_expander.c           |    1 -
 drivers/scsi/libsrp.c                        |    1 -
 drivers/usb/net/kaweth.c                     |    1 -
 drivers/video/aty/radeon_i2c.c               |    1 -
 drivers/video/g364fb.c                       |    1 -
 drivers/video/platinumfb.c                   |    1 -
 drivers/video/stifb.c                        |    1 -
 drivers/video/valkyriefb.c                   |    1 -
 include/asm-arm/arch-ixp4xx/dma.h            |    1 -
 include/rdma/ib_mad.h                        |    2 --
 sound/core/init.c                            |    1 -
 sound/oss/au1550_ac97.c                      |    1 -
 sound/oss/soundcard.c                        |    1 +
 sound/pci/ca0106/ca0106_mixer.c              |    2 +-
 sound/pci/ca0106/ca0106_proc.c               |    2 +-
 sound/pci/cs46xx/dsp_spos.c                  |    1 -
 sound/pci/cs46xx/dsp_spos_scb_lib.c          |    1 -
 sound/pci/hda/hda_generic.c                  |    1 -
 sound/pci/hda/hda_proc.c                     |    1 -
 sound/pci/hda/patch_atihdmi.c                |    1 -
 sound/pci/hda/patch_si3054.c                 |    1 -
 sound/pci/hda/patch_via.c                    |    1 -
 sound/ppc/beep.c                             |    1 -
 118 files changed, 7 insertions(+), 119 deletions(-)

diff -puN arch/alpha/kernel/err_common.c~cleanup-the-includes-of-linux-pcih arch/alpha/kernel/err_common.c
--- a/arch/alpha/kernel/err_common.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/alpha/kernel/err_common.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/sched.h>
 
 #include <asm/io.h>
diff -puN arch/alpha/kernel/err_ev6.c~cleanup-the-includes-of-linux-pcih arch/alpha/kernel/err_ev6.c
--- a/arch/alpha/kernel/err_ev6.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/alpha/kernel/err_ev6.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/sched.h>
 
 #include <asm/io.h>
diff -puN arch/alpha/kernel/err_ev7.c~cleanup-the-includes-of-linux-pcih arch/alpha/kernel/err_ev7.c
--- a/arch/alpha/kernel/err_ev7.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/alpha/kernel/err_ev7.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/sched.h>
 
 #include <asm/io.h>
diff -puN arch/i386/kernel/cpu/cpufreq/speedstep-lib.c~cleanup-the-includes-of-linux-pcih arch/i386/kernel/cpu/cpufreq/speedstep-lib.c
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-lib.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/i386/kernel/cpu/cpufreq/speedstep-lib.c
@@ -13,7 +13,6 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/cpufreq.h>
-#include <linux/pci.h>
 #include <linux/slab.h>
 
 #include <asm/msr.h>
diff -puN arch/i386/kernel/cpu/cpufreq/speedstep-smi.c~cleanup-the-includes-of-linux-pcih arch/i386/kernel/cpu/cpufreq/speedstep-smi.c
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-smi.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/i386/kernel/cpu/cpufreq/speedstep-smi.c
@@ -17,10 +17,10 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/cpufreq.h>
-#include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <asm/ist.h>
+#include <asm/io.h>
 
 #include "speedstep-lib.h"
 
diff -puN arch/ia64/sn/kernel/huberror.c~cleanup-the-includes-of-linux-pcih arch/ia64/sn/kernel/huberror.c
--- a/arch/ia64/sn/kernel/huberror.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/ia64/sn/kernel/huberror.c
@@ -8,7 +8,6 @@
 
 #include <linux/types.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <asm/delay.h>
 #include <asm/sn/sn_sal.h>
 #include "ioerror.h"
diff -puN arch/ia64/sn/kernel/xpnet.c~cleanup-the-includes-of-linux-pcih arch/ia64/sn/kernel/xpnet.c
--- a/arch/ia64/sn/kernel/xpnet.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/ia64/sn/kernel/xpnet.c
@@ -24,7 +24,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/netdevice.h>
diff -puN arch/m68knommu/kernel/dma.c~cleanup-the-includes-of-linux-pcih arch/m68knommu/kernel/dma.c
--- a/arch/m68knommu/kernel/dma.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/m68knommu/kernel/dma.c
@@ -8,7 +8,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/string.h>
-#include <linux/pci.h>
 #include <asm/io.h>
 
 void *dma_alloc_coherent(struct device *dev, size_t size,
diff -puN arch/mips/lib/iomap.c~cleanup-the-includes-of-linux-pcih arch/mips/lib/iomap.c
--- a/arch/mips/lib/iomap.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/mips/lib/iomap.c
@@ -6,7 +6,6 @@
  * (C) Copyright 2007 MIPS Technologies, Inc.
  *     written by Ralf Baechle <ralf@linux-mips.org>
  */
-#include <linux/pci.h>
 #include <linux/module.h>
 #include <asm/io.h>
 
diff -puN arch/powerpc/platforms/pseries/ras.c~cleanup-the-includes-of-linux-pcih arch/powerpc/platforms/pseries/ras.c
--- a/arch/powerpc/platforms/pseries/ras.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/powerpc/platforms/pseries/ras.c
@@ -31,7 +31,6 @@
 #include <linux/timex.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/random.h>
diff -puN arch/ppc/8260_io/enet.c~cleanup-the-includes-of-linux-pcih arch/ppc/8260_io/enet.c
--- a/arch/ppc/8260_io/enet.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/ppc/8260_io/enet.c
@@ -32,7 +32,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
diff -puN arch/ppc/8260_io/fcc_enet.c~cleanup-the-includes-of-linux-pcih arch/ppc/8260_io/fcc_enet.c
--- a/arch/ppc/8260_io/fcc_enet.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/ppc/8260_io/fcc_enet.c
@@ -29,7 +29,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
diff -puN arch/ppc/8xx_io/enet.c~cleanup-the-includes-of-linux-pcih arch/ppc/8xx_io/enet.c
--- a/arch/ppc/8xx_io/enet.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/ppc/8xx_io/enet.c
@@ -30,7 +30,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
diff -puN arch/ppc/syslib/ppc4xx_sgdma.c~cleanup-the-includes-of-linux-pcih arch/ppc/syslib/ppc4xx_sgdma.c
--- a/arch/ppc/syslib/ppc4xx_sgdma.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/ppc/syslib/ppc4xx_sgdma.c
@@ -23,7 +23,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
diff -puN arch/sh64/mach-cayman/iomap.c~cleanup-the-includes-of-linux-pcih arch/sh64/mach-cayman/iomap.c
--- a/arch/sh64/mach-cayman/iomap.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/sh64/mach-cayman/iomap.c
@@ -9,7 +9,6 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  */
-#include <linux/pci.h>
 #include <asm/io.h>
 #include <asm/cayman.h>
 
diff -puN arch/xtensa/kernel/xtensa_ksyms.c~cleanup-the-includes-of-linux-pcih arch/xtensa/kernel/xtensa_ksyms.c
--- a/arch/xtensa/kernel/xtensa_ksyms.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/xtensa/kernel/xtensa_ksyms.c
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <asm/irq.h>
 #include <linux/in6.h>
-#include <linux/pci.h>
 #include <linux/ide.h>
 
 #include <asm/uaccess.h>
diff -puN arch/xtensa/platform-iss/setup.c~cleanup-the-includes-of-linux-pcih arch/xtensa/platform-iss/setup.c
--- a/arch/xtensa/platform-iss/setup.c~cleanup-the-includes-of-linux-pcih
+++ a/arch/xtensa/platform-iss/setup.c
@@ -20,7 +20,6 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/reboot.h>
-#include <linux/pci.h>
 #include <linux/kdev_t.h>
 #include <linux/types.h>
 #include <linux/major.h>
diff -puN drivers/ata/pata_winbond.c~cleanup-the-includes-of-linux-pcih drivers/ata/pata_winbond.c
--- a/drivers/ata/pata_winbond.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/ata/pata_winbond.c
@@ -8,7 +8,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
diff -puN drivers/atm/adummy.c~cleanup-the-includes-of-linux-pcih drivers/atm/adummy.c
--- a/drivers/atm/adummy.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/atm/adummy.c
@@ -6,7 +6,6 @@
 #include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
-#include <linux/pci.h>
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/string.h>
diff -puN drivers/char/hw_random/via-rng.c~cleanup-the-includes-of-linux-pcih drivers/char/hw_random/via-rng.c
--- a/drivers/char/hw_random/via-rng.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/char/hw_random/via-rng.c
@@ -26,7 +26,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/pci.h>
 #include <linux/hw_random.h>
 #include <asm/io.h>
 #include <asm/msr.h>
diff -puN drivers/char/pcmcia/synclink_cs.c~cleanup-the-includes-of-linux-pcih drivers/char/pcmcia/synclink_cs.c
--- a/drivers/char/pcmcia/synclink_cs.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/char/pcmcia/synclink_cs.c
@@ -42,7 +42,6 @@
 #include <linux/timer.h>
 #include <linux/time.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial.h>
diff -puN drivers/char/tpm/tpm.h~cleanup-the-includes-of-linux-pcih drivers/char/tpm/tpm.h
--- a/drivers/char/tpm/tpm.h~cleanup-the-includes-of-linux-pcih
+++ a/drivers/char/tpm/tpm.h
@@ -19,7 +19,6 @@
  * 
  */
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
diff -puN drivers/char/watchdog/sc1200wdt.c~cleanup-the-includes-of-linux-pcih drivers/char/watchdog/sc1200wdt.c
--- a/drivers/char/watchdog/sc1200wdt.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/char/watchdog/sc1200wdt.c
@@ -38,7 +38,6 @@
 #include <linux/init.h>
 #include <linux/pnp.h>
 #include <linux/fs.h>
-#include <linux/pci.h>
 
 #include <asm/semaphore.h>
 #include <asm/io.h>
diff -puN drivers/char/watchdog/scx200_wdt.c~cleanup-the-includes-of-linux-pcih drivers/char/watchdog/scx200_wdt.c
--- a/drivers/char/watchdog/scx200_wdt.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/char/watchdog/scx200_wdt.c
@@ -25,7 +25,7 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/fs.h>
-#include <linux/pci.h>
+#include <linux/ioport.h>
 #include <linux/scx200.h>
 
 #include <asm/uaccess.h>
diff -puN drivers/i2c/busses/i2c-at91.c~cleanup-the-includes-of-linux-pcih drivers/i2c/busses/i2c-at91.c
--- a/drivers/i2c/busses/i2c-at91.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/i2c/busses/i2c-at91.c
@@ -17,7 +17,6 @@
 #include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
diff -puN drivers/i2c/busses/i2c-mpc.c~cleanup-the-includes-of-linux-pcih drivers/i2c/busses/i2c-mpc.c
--- a/drivers/i2c/busses/i2c-mpc.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/i2c/busses/i2c-mpc.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
diff -puN drivers/i2c/busses/i2c-pca-isa.c~cleanup-the-includes-of-linux-pcih drivers/i2c/busses/i2c-pca-isa.c
--- a/drivers/i2c/busses/i2c-pca-isa.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/i2c/busses/i2c-pca-isa.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/wait.h>
 
 #include <linux/i2c.h>
diff -puN drivers/ieee1394/hosts.c~cleanup-the-includes-of-linux-pcih drivers/ieee1394/hosts.c
--- a/drivers/ieee1394/hosts.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/ieee1394/hosts.c
@@ -15,7 +15,6 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <linux/timer.h>
 #include <linux/jiffies.h>
 #include <linux/mutex.h>
diff -puN drivers/infiniband/core/cm.c~cleanup-the-includes-of-linux-pcih drivers/infiniband/core/cm.c
--- a/drivers/infiniband/core/cm.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/infiniband/core/cm.c
@@ -40,7 +40,6 @@
 #include <linux/err.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/random.h>
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
diff -puN drivers/infiniband/core/iwcm.c~cleanup-the-includes-of-linux-pcih drivers/infiniband/core/iwcm.c
--- a/drivers/infiniband/core/iwcm.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/infiniband/core/iwcm.c
@@ -39,7 +39,6 @@
 #include <linux/err.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
diff -puN drivers/infiniband/core/mad_priv.h~cleanup-the-includes-of-linux-pcih drivers/infiniband/core/mad_priv.h
--- a/drivers/infiniband/core/mad_priv.h~cleanup-the-includes-of-linux-pcih
+++ a/drivers/infiniband/core/mad_priv.h
@@ -39,7 +39,6 @@
 
 #include <linux/completion.h>
 #include <linux/err.h>
-#include <linux/pci.h>
 #include <linux/workqueue.h>
 #include <rdma/ib_mad.h>
 #include <rdma/ib_smi.h>
diff -puN drivers/infiniband/core/multicast.c~cleanup-the-includes-of-linux-pcih drivers/infiniband/core/multicast.c
--- a/drivers/infiniband/core/multicast.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/infiniband/core/multicast.c
@@ -34,7 +34,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/bitops.h>
 #include <linux/random.h>
 
diff -puN drivers/infiniband/core/sa_query.c~cleanup-the-includes-of-linux-pcih drivers/infiniband/core/sa_query.c
--- a/drivers/infiniband/core/sa_query.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/infiniband/core/sa_query.c
@@ -40,7 +40,6 @@
 #include <linux/random.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/kref.h>
 #include <linux/idr.h>
diff -puN drivers/infiniband/core/user_mad.c~cleanup-the-includes-of-linux-pcih drivers/infiniband/core/user_mad.c
--- a/drivers/infiniband/core/user_mad.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/infiniband/core/user_mad.c
@@ -40,7 +40,6 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/cdev.h>
-#include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/poll.h>
 #include <linux/rwsem.h>
diff -puN drivers/infiniband/hw/ipath/ipath_fs.c~cleanup-the-includes-of-linux-pcih drivers/infiniband/hw/ipath/ipath_fs.c
--- a/drivers/infiniband/hw/ipath/ipath_fs.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -38,7 +38,6 @@
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/namei.h>
-#include <linux/pci.h>
 
 #include "ipath_kernel.h"
 
diff -puN drivers/infiniband/hw/ipath/ipath_layer.c~cleanup-the-includes-of-linux-pcih drivers/infiniband/hw/ipath/ipath_layer.c
--- a/drivers/infiniband/hw/ipath/ipath_layer.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/infiniband/hw/ipath/ipath_layer.c
@@ -37,7 +37,6 @@
  */
 
 #include <linux/io.h>
-#include <linux/pci.h>
 #include <asm/byteorder.h>
 
 #include "ipath_kernel.h"
diff -puN drivers/infiniband/hw/ipath/ipath_stats.c~cleanup-the-includes-of-linux-pcih drivers/infiniband/hw/ipath/ipath_stats.c
--- a/drivers/infiniband/hw/ipath/ipath_stats.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/infiniband/hw/ipath/ipath_stats.c
@@ -31,8 +31,6 @@
  * SOFTWARE.
  */
 
-#include <linux/pci.h>
-
 #include "ipath_kernel.h"
 
 struct infinipath_stats ipath_stats;
diff -puN drivers/infiniband/hw/ipath/ipath_sysfs.c~cleanup-the-includes-of-linux-pcih drivers/infiniband/hw/ipath/ipath_sysfs.c
--- a/drivers/infiniband/hw/ipath/ipath_sysfs.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/infiniband/hw/ipath/ipath_sysfs.c
@@ -32,7 +32,6 @@
  */
 
 #include <linux/ctype.h>
-#include <linux/pci.h>
 
 #include "ipath_kernel.h"
 #include "ipath_common.h"
diff -puN drivers/infiniband/hw/mthca/mthca_memfree.h~cleanup-the-includes-of-linux-pcih drivers/infiniband/hw/mthca/mthca_memfree.h
--- a/drivers/infiniband/hw/mthca/mthca_memfree.h~cleanup-the-includes-of-linux-pcih
+++ a/drivers/infiniband/hw/mthca/mthca_memfree.h
@@ -38,7 +38,6 @@
 #define MTHCA_MEMFREE_H
 
 #include <linux/list.h>
-#include <linux/pci.h>
 #include <linux/mutex.h>
 
 #define MTHCA_ICM_CHUNK_LEN \
diff -puN drivers/infiniband/ulp/ipoib/ipoib.h~cleanup-the-includes-of-linux-pcih drivers/infiniband/ulp/ipoib/ipoib.h
--- a/drivers/infiniband/ulp/ipoib/ipoib.h~cleanup-the-includes-of-linux-pcih
+++ a/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -41,7 +41,6 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/workqueue.h>
-#include <linux/pci.h>
 #include <linux/kref.h>
 #include <linux/if_infiniband.h>
 #include <linux/mutex.h>
diff -puN drivers/isdn/hisax/netjet.c~cleanup-the-includes-of-linux-pcih drivers/isdn/hisax/netjet.c
--- a/drivers/isdn/hisax/netjet.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/isdn/hisax/netjet.c
@@ -19,7 +19,6 @@
 #include "isac.h"
 #include "hscx.h"
 #include "isdnl1.h"
-#include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/ppp_defs.h>
 #include <asm/io.h>
diff -puN drivers/isdn/hysdn/hysdn_proclog.c~cleanup-the-includes-of-linux-pcih drivers/isdn/hysdn/hysdn_proclog.c
--- a/drivers/isdn/hysdn/hysdn_proclog.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/isdn/hysdn/hysdn_proclog.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
-#include <linux/pci.h>
 #include <linux/smp_lock.h>
 
 #include "hysdn_defs.h"
diff -puN drivers/media/dvb/cinergyT2/cinergyT2.c~cleanup-the-includes-of-linux-pcih drivers/media/dvb/cinergyT2/cinergyT2.c
--- a/drivers/media/dvb/cinergyT2/cinergyT2.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/media/dvb/cinergyT2/cinergyT2.c
@@ -26,11 +26,11 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
-#include <linux/pci.h>
 #include <linux/input.h>
 #include <linux/dvb/frontend.h>
 #include <linux/mutex.h>
 #include <linux/mm.h>
+#include <asm/io.h>
 
 #include "dmxdev.h"
 #include "dvb_demux.h"
diff -puN drivers/media/video/adv7170.c~cleanup-the-includes-of-linux-pcih drivers/media/video/adv7170.c
--- a/drivers/media/video/adv7170.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/media/video/adv7170.c
@@ -37,7 +37,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff -puN drivers/media/video/adv7175.c~cleanup-the-includes-of-linux-pcih drivers/media/video/adv7175.c
--- a/drivers/media/video/adv7175.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/media/video/adv7175.c
@@ -33,7 +33,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff -puN drivers/media/video/bt819.c~cleanup-the-includes-of-linux-pcih drivers/media/video/bt819.c
--- a/drivers/media/video/bt819.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/media/video/bt819.c
@@ -37,7 +37,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff -puN drivers/media/video/bt856.c~cleanup-the-includes-of-linux-pcih drivers/media/video/bt856.c
--- a/drivers/media/video/bt856.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/media/video/bt856.c
@@ -37,7 +37,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff -puN drivers/media/video/bt866.c~cleanup-the-includes-of-linux-pcih drivers/media/video/bt866.c
--- a/drivers/media/video/bt866.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/media/video/bt866.c
@@ -37,7 +37,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff -puN drivers/media/video/cx88/cx88-tvaudio.c~cleanup-the-includes-of-linux-pcih drivers/media/video/cx88/cx88-tvaudio.c
--- a/drivers/media/video/cx88/cx88-tvaudio.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/media/video/cx88/cx88-tvaudio.c
@@ -43,7 +43,6 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/poll.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <linux/ioport.h>
 #include <linux/types.h>
diff -puN drivers/media/video/em28xx/em28xx-cards.c~cleanup-the-includes-of-linux-pcih drivers/media/video/em28xx/em28xx-cards.c
--- a/drivers/media/video/em28xx/em28xx-cards.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/media/video/em28xx/em28xx-cards.c
@@ -23,7 +23,6 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/usb.h>
diff -puN drivers/media/video/saa7111.c~cleanup-the-includes-of-linux-pcih drivers/media/video/saa7111.c
--- a/drivers/media/video/saa7111.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/media/video/saa7111.c
@@ -36,7 +36,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff -puN drivers/media/video/saa7114.c~cleanup-the-includes-of-linux-pcih drivers/media/video/saa7114.c
--- a/drivers/media/video/saa7114.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/media/video/saa7114.c
@@ -39,7 +39,6 @@
 #include <linux/slab.h>
 
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff -puN drivers/media/video/saa711x.c~cleanup-the-includes-of-linux-pcih drivers/media/video/saa711x.c
--- a/drivers/media/video/saa711x.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/media/video/saa711x.c
@@ -30,7 +30,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff -puN drivers/media/video/saa7185.c~cleanup-the-includes-of-linux-pcih drivers/media/video/saa7185.c
--- a/drivers/media/video/saa7185.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/media/video/saa7185.c
@@ -33,7 +33,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff -puN drivers/misc/hdpuftrs/hdpu_cpustate.c~cleanup-the-includes-of-linux-pcih drivers/misc/hdpuftrs/hdpu_cpustate.c
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -18,7 +18,6 @@
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/platform_device.h>
 #include <asm/uaccess.h>
diff -puN drivers/misc/hdpuftrs/hdpu_nexus.c~cleanup-the-includes-of-linux-pcih drivers/misc/hdpuftrs/hdpu_nexus.c
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -18,7 +18,6 @@
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
 #include <linux/hdpu_features.h>
-#include <linux/pci.h>
 
 #include <linux/platform_device.h>
 
diff -puN drivers/mtd/devices/doc2000.c~cleanup-the-includes-of-linux-pcih drivers/mtd/devices/doc2000.c
--- a/drivers/mtd/devices/doc2000.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/mtd/devices/doc2000.c
@@ -13,7 +13,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
diff -puN drivers/mtd/devices/doc2001.c~cleanup-the-includes-of-linux-pcih drivers/mtd/devices/doc2001.c
--- a/drivers/mtd/devices/doc2001.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/mtd/devices/doc2001.c
@@ -13,7 +13,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
diff -puN drivers/mtd/devices/doc2001plus.c~cleanup-the-includes-of-linux-pcih drivers/mtd/devices/doc2001plus.c
--- a/drivers/mtd/devices/doc2001plus.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/mtd/devices/doc2001plus.c
@@ -17,7 +17,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
diff -puN drivers/mtd/devices/docecc.c~cleanup-the-includes-of-linux-pcih drivers/mtd/devices/docecc.c
--- a/drivers/mtd/devices/docecc.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/mtd/devices/docecc.c
@@ -29,7 +29,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
diff -puN drivers/mtd/inftlmount.c~cleanup-the-includes-of-linux-pcih drivers/mtd/inftlmount.c
--- a/drivers/mtd/inftlmount.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/mtd/inftlmount.c
@@ -31,7 +31,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
diff -puN drivers/mtd/nand/cs553x_nand.c~cleanup-the-includes-of-linux-pcih drivers/mtd/nand/cs553x_nand.c
--- a/drivers/mtd/nand/cs553x_nand.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/mtd/nand/cs553x_nand.c
@@ -20,7 +20,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/nand_ecc.h>
diff -puN drivers/mtd/nftlcore.c~cleanup-the-includes-of-linux-pcih drivers/mtd/nftlcore.c
--- a/drivers/mtd/nftlcore.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/mtd/nftlcore.c
@@ -17,7 +17,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
diff -puN drivers/net/atl1/atl1_param.c~cleanup-the-includes-of-linux-pcih drivers/net/atl1/atl1_param.c
--- a/drivers/net/atl1/atl1_param.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/atl1/atl1_param.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <linux/moduleparam.h>
 #include "atl1.h"
 
diff -puN drivers/net/au1000_eth.c~cleanup-the-includes-of-linux-pcih drivers/net/au1000_eth.c
--- a/drivers/net/au1000_eth.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/au1000_eth.c
@@ -45,7 +45,6 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff -puN drivers/net/fec_8xx/fec_main.c~cleanup-the-includes-of-linux-pcih drivers/net/fec_8xx/fec_main.c
--- a/drivers/net/fec_8xx/fec_main.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/fec_8xx/fec_main.c
@@ -19,7 +19,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/fec_8xx/fec_mii.c~cleanup-the-includes-of-linux-pcih drivers/net/fec_8xx/fec_mii.c
--- a/drivers/net/fec_8xx/fec_mii.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/fec_8xx/fec_mii.c
@@ -19,7 +19,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/fs_enet/fs_enet-main.c~cleanup-the-includes-of-linux-pcih drivers/net/fs_enet/fs_enet-main.c
--- a/drivers/net/fs_enet/fs_enet-main.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/fs_enet/fs_enet-main.c
@@ -24,7 +24,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/fs_enet/mac-fcc.c~cleanup-the-includes-of-linux-pcih drivers/net/fs_enet/mac-fcc.c
--- a/drivers/net/fs_enet/mac-fcc.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/fs_enet/mac-fcc.c
@@ -21,7 +21,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/fs_enet/mac-fec.c~cleanup-the-includes-of-linux-pcih drivers/net/fs_enet/mac-fec.c
--- a/drivers/net/fs_enet/mac-fec.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/fs_enet/mac-fec.c
@@ -21,7 +21,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/fs_enet/mac-scc.c~cleanup-the-includes-of-linux-pcih drivers/net/fs_enet/mac-scc.c
--- a/drivers/net/fs_enet/mac-scc.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/fs_enet/mac-scc.c
@@ -21,7 +21,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/fs_enet/mii-bitbang.c~cleanup-the-includes-of-linux-pcih drivers/net/fs_enet/mii-bitbang.c
--- a/drivers/net/fs_enet/mii-bitbang.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/fs_enet/mii-bitbang.c
@@ -22,7 +22,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/fs_enet/mii-fec.c~cleanup-the-includes-of-linux-pcih drivers/net/fs_enet/mii-fec.c
--- a/drivers/net/fs_enet/mii-fec.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/fs_enet/mii-fec.c
@@ -21,7 +21,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/ibm_emac/ibm_emac_core.c~cleanup-the-includes-of-linux-pcih drivers/net/ibm_emac/ibm_emac_core.c
--- a/drivers/net/ibm_emac/ibm_emac_core.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/ibm_emac/ibm_emac_core.c
@@ -27,7 +27,6 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
diff -puN drivers/net/ixgb/ixgb_osdep.h~cleanup-the-includes-of-linux-pcih drivers/net/ixgb/ixgb_osdep.h
--- a/drivers/net/ixgb/ixgb_osdep.h~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/ixgb/ixgb_osdep.h
@@ -34,7 +34,6 @@
 #define _IXGB_OSDEP_H_
 
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <asm/io.h>
 #include <linux/interrupt.h>
diff -puN drivers/net/lasi_82596.c~cleanup-the-includes-of-linux-pcih drivers/net/lasi_82596.c
--- a/drivers/net/lasi_82596.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/lasi_82596.c
@@ -81,7 +81,6 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/types.h>
 #include <linux/bitops.h>
 
diff -puN drivers/net/tokenring/madgemc.c~cleanup-the-includes-of-linux-pcih drivers/net/tokenring/madgemc.c
--- a/drivers/net/tokenring/madgemc.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/tokenring/madgemc.c
@@ -23,7 +23,6 @@ static const char version[] = "madgemc.c
 #include <linux/mca.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/trdevice.h>
diff -puN drivers/net/tokenring/smctr.c~cleanup-the-includes-of-linux-pcih drivers/net/tokenring/smctr.c
--- a/drivers/net/tokenring/smctr.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/tokenring/smctr.c
@@ -41,7 +41,6 @@
 #include <linux/time.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/mca-legacy.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/tulip/21142.c~cleanup-the-includes-of-linux-pcih drivers/net/tulip/21142.c
--- a/drivers/net/tulip/21142.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/tulip/21142.c
@@ -14,7 +14,6 @@
 
 */
 
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include "tulip.h"
 
diff -puN drivers/net/tulip/pnic.c~cleanup-the-includes-of-linux-pcih drivers/net/tulip/pnic.c
--- a/drivers/net/tulip/pnic.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/tulip/pnic.c
@@ -15,7 +15,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/pci.h>
 #include <linux/jiffies.h>
 #include "tulip.h"
 
diff -puN drivers/net/tulip/pnic2.c~cleanup-the-includes-of-linux-pcih drivers/net/tulip/pnic2.c
--- a/drivers/net/tulip/pnic2.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/tulip/pnic2.c
@@ -76,7 +76,6 @@
 
 
 
-#include <linux/pci.h>
 #include "tulip.h"
 #include <linux/delay.h>
 
diff -puN drivers/net/tulip/timer.c~cleanup-the-includes-of-linux-pcih drivers/net/tulip/timer.c
--- a/drivers/net/tulip/timer.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/tulip/timer.c
@@ -14,7 +14,6 @@
 
 */
 
-#include <linux/pci.h>
 #include "tulip.h"
 
 
diff -puN drivers/net/tulip/tulip.h~cleanup-the-includes-of-linux-pcih drivers/net/tulip/tulip.h
--- a/drivers/net/tulip/tulip.h~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/tulip/tulip.h
@@ -22,6 +22,7 @@
 #include <linux/netdevice.h>
 #include <linux/timer.h>
 #include <linux/delay.h>
+#include <linux/pci.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff -puN drivers/net/wan/lmc/lmc_media.c~cleanup-the-includes-of-linux-pcih drivers/net/wan/lmc/lmc_media.c
--- a/drivers/net/wan/lmc/lmc_media.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/wan/lmc/lmc_media.c
@@ -8,7 +8,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/in.h>
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/wan/lmc/lmc_proto.c~cleanup-the-includes-of-linux-pcih drivers/net/wan/lmc/lmc_proto.c
--- a/drivers/net/wan/lmc/lmc_proto.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/wan/lmc/lmc_proto.c
@@ -27,7 +27,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/in.h>
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/wan/pc300_tty.c~cleanup-the-includes-of-linux-pcih drivers/net/wan/pc300_tty.c
--- a/drivers/net/wan/pc300_tty.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/net/wan/pc300_tty.c
@@ -38,7 +38,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/pci.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/init.h>
diff -puN drivers/parisc/hppb.c~cleanup-the-includes-of-linux-pcih drivers/parisc/hppb.c
--- a/drivers/parisc/hppb.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/parisc/hppb.c
@@ -22,8 +22,6 @@
 #include <asm/hardware.h>
 #include <asm/parisc-device.h>
 
-#include <linux/pci.h>
-
 struct hppb_card {
 	unsigned long hpa;
 	struct resource mmio_region;
diff -puN drivers/pcmcia/cs.c~cleanup-the-includes-of-linux-pcih drivers/pcmcia/cs.c
--- a/drivers/pcmcia/cs.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/pcmcia/cs.c
@@ -26,7 +26,6 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
-#include <linux/pci.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
diff -puN drivers/pcmcia/socket_sysfs.c~cleanup-the-includes-of-linux-pcih drivers/pcmcia/socket_sysfs.c
--- a/drivers/pcmcia/socket_sysfs.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/pcmcia/socket_sysfs.c
@@ -22,7 +22,6 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
-#include <linux/pci.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <asm/system.h>
diff -puN drivers/sbus/sbus.c~cleanup-the-includes-of-linux-pcih drivers/sbus/sbus.c
--- a/drivers/sbus/sbus.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/sbus/sbus.c
@@ -6,7 +6,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/device.h>
 
 #include <asm/system.h>
diff -puN drivers/scsi/aacraid/dpcsup.c~cleanup-the-includes-of-linux-pcih drivers/scsi/aacraid/dpcsup.c
--- a/drivers/scsi/aacraid/dpcsup.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/scsi/aacraid/dpcsup.c
@@ -32,7 +32,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/completion.h>
diff -puN drivers/scsi/aacraid/sa.c~cleanup-the-includes-of-linux-pcih drivers/scsi/aacraid/sa.c
--- a/drivers/scsi/aacraid/sa.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/scsi/aacraid/sa.c
@@ -31,7 +31,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/aha1542.c~cleanup-the-includes-of-linux-pcih drivers/scsi/aha1542.c
--- a/drivers/scsi/aha1542.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/scsi/aha1542.c
@@ -35,7 +35,6 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <linux/pci.h>
 #include <linux/isapnp.h>
 #include <linux/blkdev.h>
 #include <linux/mca.h>
diff -puN drivers/scsi/aic94xx/aic94xx_scb.c~cleanup-the-includes-of-linux-pcih drivers/scsi/aic94xx/aic94xx_scb.c
--- a/drivers/scsi/aic94xx/aic94xx_scb.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -24,7 +24,6 @@
  *
  */
 
-#include <linux/pci.h>
 #include <scsi/scsi_host.h>
 
 #include "aic94xx.h"
diff -puN drivers/scsi/arcmsr/arcmsr_attr.c~cleanup-the-includes-of-linux-pcih drivers/scsi/arcmsr/arcmsr_attr.c
--- a/drivers/scsi/arcmsr/arcmsr_attr.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -49,7 +49,6 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
diff -puN drivers/scsi/libsas/sas_expander.c~cleanup-the-includes-of-linux-pcih drivers/scsi/libsas/sas_expander.c
--- a/drivers/scsi/libsas/sas_expander.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/scsi/libsas/sas_expander.c
@@ -22,7 +22,6 @@
  *
  */
 
-#include <linux/pci.h>
 #include <linux/scatterlist.h>
 
 #include "sas_internal.h"
diff -puN drivers/scsi/libsrp.c~cleanup-the-includes-of-linux-pcih drivers/scsi/libsrp.c
--- a/drivers/scsi/libsrp.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/scsi/libsrp.c
@@ -22,7 +22,6 @@
 #include <linux/kfifo.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
-#include <linux/pci.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
diff -puN drivers/usb/net/kaweth.c~cleanup-the-includes-of-linux-pcih drivers/usb/net/kaweth.c
--- a/drivers/usb/net/kaweth.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/usb/net/kaweth.c
@@ -55,7 +55,6 @@
 #include <linux/usb.h>
 #include <linux/types.h>
 #include <linux/ethtool.h>
-#include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/wait.h>
 #include <asm/uaccess.h>
diff -puN drivers/video/aty/radeon_i2c.c~cleanup-the-includes-of-linux-pcih drivers/video/aty/radeon_i2c.c
--- a/drivers/video/aty/radeon_i2c.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/video/aty/radeon_i2c.c
@@ -1,7 +1,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
 #include <linux/fb.h>
 
 
diff -puN drivers/video/g364fb.c~cleanup-the-includes-of-linux-pcih drivers/video/g364fb.c
--- a/drivers/video/g364fb.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/video/g364fb.c
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 #include <linux/fb.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <asm/io.h>
 #include <asm/jazz.h>
 
diff -puN drivers/video/platinumfb.c~cleanup-the-includes-of-linux-pcih drivers/video/platinumfb.c
--- a/drivers/video/platinumfb.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/video/platinumfb.c
@@ -28,7 +28,6 @@
 #include <linux/interrupt.h>
 #include <linux/fb.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/nvram.h>
 #include <asm/io.h>
 #include <asm/prom.h>
diff -puN drivers/video/stifb.c~cleanup-the-includes-of-linux-pcih drivers/video/stifb.c
--- a/drivers/video/stifb.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/video/stifb.c
@@ -64,7 +64,6 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
-#include <linux/pci.h>
 
 #include <asm/grfioctl.h>	/* for HP-UX compatibility */
 #include <asm/uaccess.h>
diff -puN drivers/video/valkyriefb.c~cleanup-the-includes-of-linux-pcih drivers/video/valkyriefb.c
--- a/drivers/video/valkyriefb.c~cleanup-the-includes-of-linux-pcih
+++ a/drivers/video/valkyriefb.c
@@ -51,7 +51,6 @@
 #include <linux/fb.h>
 #include <linux/selection.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/nvram.h>
 #include <linux/adb.h>
 #include <linux/cuda.h>
diff -puN include/asm-arm/arch-ixp4xx/dma.h~cleanup-the-includes-of-linux-pcih include/asm-arm/arch-ixp4xx/dma.h
--- a/include/asm-arm/arch-ixp4xx/dma.h~cleanup-the-includes-of-linux-pcih
+++ a/include/asm-arm/arch-ixp4xx/dma.h
@@ -12,7 +12,6 @@
 #define __ASM_ARCH_DMA_H
 
 #include <linux/device.h>
-#include <linux/pci.h>
 #include <asm/page.h>
 #include <asm/sizes.h>
 #include <asm/hardware.h>
diff -puN include/rdma/ib_mad.h~cleanup-the-includes-of-linux-pcih include/rdma/ib_mad.h
--- a/include/rdma/ib_mad.h~cleanup-the-includes-of-linux-pcih
+++ a/include/rdma/ib_mad.h
@@ -39,8 +39,6 @@
 #if !defined( IB_MAD_H )
 #define IB_MAD_H
 
-#include <linux/pci.h>
-
 #include <rdma/ib_verbs.h>
 
 /* Management base version */
diff -puN sound/core/init.c~cleanup-the-includes-of-linux-pcih sound/core/init.c
--- a/sound/core/init.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/core/init.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/ctype.h>
-#include <linux/pci.h>
 #include <linux/pm.h>
 
 #include <sound/core.h>
diff -puN sound/oss/au1550_ac97.c~cleanup-the-includes-of-linux-pcih sound/oss/au1550_ac97.c
--- a/sound/oss/au1550_ac97.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/oss/au1550_ac97.c
@@ -47,7 +47,6 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/poll.h>
-#include <linux/pci.h>
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/smp_lock.h>
diff -puN sound/oss/soundcard.c~cleanup-the-includes-of-linux-pcih sound/oss/soundcard.c
--- a/sound/oss/soundcard.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/oss/soundcard.c
@@ -44,6 +44,7 @@
 #include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/device.h>
 
 /*
  * This ought to be moved into include/asm/dma.h
diff -puN sound/pci/ca0106/ca0106_mixer.c~cleanup-the-includes-of-linux-pcih sound/pci/ca0106/ca0106_mixer.c
--- a/sound/pci/ca0106/ca0106_mixer.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/pci/ca0106/ca0106_mixer.c
@@ -62,7 +62,6 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <sound/core.h>
@@ -71,6 +70,7 @@
 #include <sound/ac97_codec.h>
 #include <sound/info.h>
 #include <sound/tlv.h>
+#include <asm/io.h>
 
 #include "ca0106.h"
 
diff -puN sound/pci/ca0106/ca0106_proc.c~cleanup-the-includes-of-linux-pcih sound/pci/ca0106/ca0106_proc.c
--- a/sound/pci/ca0106/ca0106_proc.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/pci/ca0106/ca0106_proc.c
@@ -64,7 +64,6 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <sound/core.h>
@@ -73,6 +72,7 @@
 #include <sound/ac97_codec.h>
 #include <sound/info.h>
 #include <sound/asoundef.h>
+#include <asm/io.h>
 
 #include "ca0106.h"
 
diff -puN sound/pci/cs46xx/dsp_spos.c~cleanup-the-includes-of-linux-pcih sound/pci/cs46xx/dsp_spos.c
--- a/sound/pci/cs46xx/dsp_spos.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/pci/cs46xx/dsp_spos.c
@@ -23,7 +23,6 @@
 #include <sound/driver.h>
 #include <asm/io.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
 #include <linux/pm.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff -puN sound/pci/cs46xx/dsp_spos_scb_lib.c~cleanup-the-includes-of-linux-pcih sound/pci/cs46xx/dsp_spos_scb_lib.c
--- a/sound/pci/cs46xx/dsp_spos_scb_lib.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/pci/cs46xx/dsp_spos_scb_lib.c
@@ -24,7 +24,6 @@
 #include <sound/driver.h>
 #include <asm/io.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
 #include <linux/pm.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff -puN sound/pci/hda/hda_generic.c~cleanup-the-includes-of-linux-pcih sound/pci/hda/hda_generic.c
--- a/sound/pci/hda/hda_generic.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/pci/hda/hda_generic.c
@@ -23,7 +23,6 @@
 #include <sound/driver.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
diff -puN sound/pci/hda/hda_proc.c~cleanup-the-includes-of-linux-pcih sound/pci/hda/hda_proc.c
--- a/sound/pci/hda/hda_proc.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/pci/hda/hda_proc.c
@@ -23,7 +23,6 @@
 
 #include <sound/driver.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
diff -puN sound/pci/hda/patch_atihdmi.c~cleanup-the-includes-of-linux-pcih sound/pci/hda/patch_atihdmi.c
--- a/sound/pci/hda/patch_atihdmi.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/pci/hda/patch_atihdmi.c
@@ -25,7 +25,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
diff -puN sound/pci/hda/patch_si3054.c~cleanup-the-includes-of-linux-pcih sound/pci/hda/patch_si3054.c
--- a/sound/pci/hda/patch_si3054.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/pci/hda/patch_si3054.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
diff -puN sound/pci/hda/patch_via.c~cleanup-the-includes-of-linux-pcih sound/pci/hda/patch_via.c
--- a/sound/pci/hda/patch_via.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/pci/hda/patch_via.c
@@ -35,7 +35,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
diff -puN sound/ppc/beep.c~cleanup-the-includes-of-linux-pcih sound/ppc/beep.c
--- a/sound/ppc/beep.c~cleanup-the-includes-of-linux-pcih
+++ a/sound/ppc/beep.c
@@ -24,7 +24,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
-#include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <sound/core.h>
 #include <sound/control.h>
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
io_apic-needs-apicdefh.patch
parport-is-an-orphan.patch
git-dvb.patch
cleanup-the-includes-of-linux-pcih.patch
scatterlisth-needs-typesh.patch
