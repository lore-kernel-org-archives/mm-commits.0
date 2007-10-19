From: akpm@linux-foundation.org
Subject: - remove-asm-bitopsh-includes.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:52:28 -0700
Message-ID: <200710192252.l9JMqSIR024278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966804AbXJSXGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     remove asm/bitops.h includes
has been removed from the -mm tree.  Its filename was
     remove-asm-bitopsh-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove asm/bitops.h includes
From: Jiri Slaby <jirislaby@gmail.com>

remove asm/bitops.h includes

including asm/bitops directly may cause compile errors. don't include it
and include linux/bitops instead. next patch will deny including asm header
directly.

Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/fls.c                        |    2 +-
 arch/frv/kernel/irq-mb93091.c               |    2 +-
 arch/frv/kernel/irq-mb93093.c               |    2 +-
 arch/frv/kernel/irq-mb93493.c               |    2 +-
 arch/frv/kernel/irq.c                       |    2 +-
 arch/mips/au1000/pb1200/irqmap.c            |    2 +-
 arch/mips/basler/excite/excite_irq.c        |    2 +-
 arch/mips/tx4938/common/setup.c             |    2 +-
 arch/powerpc/platforms/maple/setup.c        |    2 +-
 drivers/char/esp.c                          |    2 +-
 drivers/char/mxser.c                        |    2 +-
 drivers/char/mxser_new.c                    |    2 +-
 drivers/ide/ide-io.c                        |    2 +-
 drivers/media/dvb/ttpci/av7110_ir.c         |    2 +-
 drivers/net/bnx2.c                          |    2 +-
 drivers/net/cris/eth_v10.c                  |    2 +-
 drivers/net/cxgb3/adapter.h                 |    2 +-
 drivers/net/hamradio/dmascc.c               |    2 +-
 drivers/net/mac89x0.c                       |    2 +-
 drivers/net/spider_net.c                    |    2 +-
 drivers/net/tulip/uli526x.c                 |    2 +-
 drivers/net/wireless/bcm43xx/bcm43xx_leds.c |    2 +-
 drivers/pcmcia/m32r_pcc.c                   |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c                |    2 +-
 drivers/ps3/vuart.c                         |    2 +-
 drivers/rtc/rtc-pl031.c                     |    2 +-
 drivers/rtc/rtc-sa1100.c                    |    2 +-
 drivers/s390/cio/idset.c                    |    2 +-
 drivers/s390/net/claw.c                     |    2 +-
 drivers/scsi/ide-scsi.c                     |    2 +-
 drivers/serial/crisv10.c                    |    2 +-
 drivers/watchdog/at91rm9200_wdt.c           |    2 +-
 drivers/watchdog/ks8695_wdt.c               |    2 +-
 drivers/watchdog/omap_wdt.c                 |    2 +-
 drivers/watchdog/sa1100_wdt.c               |    2 +-
 include/asm-cris/posix_types.h              |    2 +-
 include/asm-ia64/cacheflush.h               |    2 +-
 include/asm-ia64/pgtable.h                  |    2 +-
 include/asm-ia64/smp.h                      |    2 +-
 include/asm-ia64/spinlock.h                 |    2 +-
 include/asm-m32r/pgtable.h                  |    2 +-
 include/asm-mips/fpu.h                      |    2 +-
 include/asm-parisc/pgtable.h                |    2 +-
 include/asm-powerpc/iommu.h                 |    2 +-
 include/asm-powerpc/mmu_context.h           |    2 +-
 include/asm-ppc/mmu_context.h               |    3 ++-
 include/asm-sparc64/smp.h                   |    2 +-
 include/asm-x86/pgtable_32.h                |    5 +----
 include/asm-x86/pgtable_64.h                |    2 +-
 include/asm-x86/smp_32.h                    |    2 +-
 include/asm-x86/topology_64.h               |    2 +-
 include/linux/of.h                          |    2 +-
 lib/hweight.c                               |    2 +-
 net/core/gen_estimator.c                    |    2 +-
 net/core/pktgen.c                           |    2 +-
 net/ipv4/fib_trie.c                         |    2 +-
 net/netfilter/xt_connbytes.c                |    2 +-
 57 files changed, 58 insertions(+), 60 deletions(-)

diff -puN arch/alpha/lib/fls.c~remove-asm-bitopsh-includes arch/alpha/lib/fls.c
--- a/arch/alpha/lib/fls.c~remove-asm-bitopsh-includes
+++ a/arch/alpha/lib/fls.c
@@ -3,7 +3,7 @@
  */
 
 #include <linux/module.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 
 /* This is fls(x)-1, except zero is held to zero.  This allows most
    efficent input into extbl, plus it allows easy handling of fls(0)=0.  */
diff -puN arch/frv/kernel/irq-mb93091.c~remove-asm-bitopsh-includes arch/frv/kernel/irq-mb93091.c
--- a/arch/frv/kernel/irq-mb93091.c~remove-asm-bitopsh-includes
+++ a/arch/frv/kernel/irq-mb93091.c
@@ -17,10 +17,10 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/irq.h>
+#include <linux/bitops.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
-#include <asm/bitops.h>
 #include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/irc-regs.h>
diff -puN arch/frv/kernel/irq-mb93093.c~remove-asm-bitopsh-includes arch/frv/kernel/irq-mb93093.c
--- a/arch/frv/kernel/irq-mb93093.c~remove-asm-bitopsh-includes
+++ a/arch/frv/kernel/irq-mb93093.c
@@ -17,10 +17,10 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/irq.h>
+#include <linux/bitops.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
-#include <asm/bitops.h>
 #include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/irc-regs.h>
diff -puN arch/frv/kernel/irq-mb93493.c~remove-asm-bitopsh-includes arch/frv/kernel/irq-mb93493.c
--- a/arch/frv/kernel/irq-mb93493.c~remove-asm-bitopsh-includes
+++ a/arch/frv/kernel/irq-mb93493.c
@@ -17,10 +17,10 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/irq.h>
+#include <linux/bitops.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
-#include <asm/bitops.h>
 #include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/irc-regs.h>
diff -puN arch/frv/kernel/irq.c~remove-asm-bitopsh-includes arch/frv/kernel/irq.c
--- a/arch/frv/kernel/irq.c~remove-asm-bitopsh-includes
+++ a/arch/frv/kernel/irq.c
@@ -24,12 +24,12 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/module.h>
+#include <linux/bitops.h>
 
 #include <asm/atomic.h>
 #include <asm/io.h>
 #include <asm/smp.h>
 #include <asm/system.h>
-#include <asm/bitops.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/delay.h>
diff -puN arch/mips/au1000/pb1200/irqmap.c~remove-asm-bitopsh-includes arch/mips/au1000/pb1200/irqmap.c
--- a/arch/mips/au1000/pb1200/irqmap.c~remove-asm-bitopsh-includes
+++ a/arch/mips/au1000/pb1200/irqmap.c
@@ -36,8 +36,8 @@
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/delay.h>
+#include <linux/bitops.h>
 
-#include <asm/bitops.h>
 #include <asm/bootinfo.h>
 #include <asm/io.h>
 #include <asm/mipsregs.h>
diff -puN arch/mips/basler/excite/excite_irq.c~remove-asm-bitopsh-includes arch/mips/basler/excite/excite_irq.c
--- a/arch/mips/basler/excite/excite_irq.c~remove-asm-bitopsh-includes
+++ a/arch/mips/basler/excite/excite_irq.c
@@ -29,7 +29,7 @@
 #include <linux/timex.h>
 #include <linux/slab.h>
 #include <linux/random.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include <asm/bootinfo.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff -puN arch/mips/tx4938/common/setup.c~remove-asm-bitopsh-includes arch/mips/tx4938/common/setup.c
--- a/arch/mips/tx4938/common/setup.c~remove-asm-bitopsh-includes
+++ a/arch/mips/tx4938/common/setup.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/irq.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include <asm/bootinfo.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff -puN arch/powerpc/platforms/maple/setup.c~remove-asm-bitopsh-includes arch/powerpc/platforms/maple/setup.c
--- a/arch/powerpc/platforms/maple/setup.c~remove-asm-bitopsh-includes
+++ a/arch/powerpc/platforms/maple/setup.c
@@ -41,13 +41,13 @@
 #include <linux/root_dev.h>
 #include <linux/serial.h>
 #include <linux/smp.h>
+#include <linux/bitops.h>
 
 #include <asm/processor.h>
 #include <asm/sections.h>
 #include <asm/prom.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
-#include <asm/bitops.h>
 #include <asm/io.h>
 #include <asm/kexec.h>
 #include <asm/pci-bridge.h>
diff -puN drivers/char/esp.c~remove-asm-bitopsh-includes drivers/char/esp.c
--- a/drivers/char/esp.c~remove-asm-bitopsh-includes
+++ a/drivers/char/esp.c
@@ -58,10 +58,10 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/bitops.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
-#include <asm/bitops.h>
 
 #include <asm/dma.h>
 #include <linux/slab.h>
diff -puN drivers/char/mxser.c~remove-asm-bitopsh-includes drivers/char/mxser.c
--- a/drivers/char/mxser.c~remove-asm-bitopsh-includes
+++ a/drivers/char/mxser.c
@@ -56,11 +56,11 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <linux/bitops.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/bitops.h>
 #include <asm/uaccess.h>
 
 #include "mxser.h"
diff -puN drivers/char/mxser_new.c~remove-asm-bitopsh-includes drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~remove-asm-bitopsh-includes
+++ a/drivers/char/mxser_new.c
@@ -39,11 +39,11 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <linux/bitops.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/bitops.h>
 #include <asm/uaccess.h>
 
 #include "mxser_new.h"
diff -puN drivers/ide/ide-io.c~remove-asm-bitopsh-includes drivers/ide/ide-io.c
--- a/drivers/ide/ide-io.c~remove-asm-bitopsh-includes
+++ a/drivers/ide/ide-io.c
@@ -47,12 +47,12 @@
 #include <linux/device.h>
 #include <linux/kmod.h>
 #include <linux/scatterlist.h>
+#include <linux/bitops.h>
 
 #include <asm/byteorder.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/bitops.h>
 
 static int __ide_end_request(ide_drive_t *drive, struct request *rq,
 			     int uptodate, unsigned int nr_bytes)
diff -puN drivers/media/dvb/ttpci/av7110_ir.c~remove-asm-bitopsh-includes drivers/media/dvb/ttpci/av7110_ir.c
--- a/drivers/media/dvb/ttpci/av7110_ir.c~remove-asm-bitopsh-includes
+++ a/drivers/media/dvb/ttpci/av7110_ir.c
@@ -27,7 +27,7 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 
 #include "av7110.h"
 #include "av7110_hw.h"
diff -puN drivers/net/bnx2.c~remove-asm-bitopsh-includes drivers/net/bnx2.c
--- a/drivers/net/bnx2.c~remove-asm-bitopsh-includes
+++ a/drivers/net/bnx2.c
@@ -26,7 +26,7 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <linux/delay.h>
diff -puN drivers/net/cris/eth_v10.c~remove-asm-bitopsh-includes drivers/net/cris/eth_v10.c
--- a/drivers/net/cris/eth_v10.c~remove-asm-bitopsh-includes
+++ a/drivers/net/cris/eth_v10.c
@@ -234,6 +234,7 @@
 #include <linux/spinlock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/bitops.h>
 
 #include <linux/if.h>
 #include <linux/mii.h>
@@ -247,7 +248,6 @@
 #include <asm/irq.h>
 #include <asm/dma.h>
 #include <asm/system.h>
-#include <asm/bitops.h>
 #include <asm/ethernet.h>
 #include <asm/cache.h>
 
diff -puN drivers/net/cxgb3/adapter.h~remove-asm-bitopsh-includes drivers/net/cxgb3/adapter.h
--- a/drivers/net/cxgb3/adapter.h~remove-asm-bitopsh-includes
+++ a/drivers/net/cxgb3/adapter.h
@@ -41,9 +41,9 @@
 #include <linux/timer.h>
 #include <linux/cache.h>
 #include <linux/mutex.h>
+#include <linux/bitops.h>
 #include "t3cdev.h"
 #include <asm/semaphore.h>
-#include <asm/bitops.h>
 #include <asm/io.h>
 
 typedef irqreturn_t(*intr_handler_t) (int, void *);
diff -puN drivers/net/hamradio/dmascc.c~remove-asm-bitopsh-includes drivers/net/hamradio/dmascc.c
--- a/drivers/net/hamradio/dmascc.c~remove-asm-bitopsh-includes
+++ a/drivers/net/hamradio/dmascc.c
@@ -21,6 +21,7 @@
 
 
 #include <linux/module.h>
+#include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/if_arp.h>
@@ -35,7 +36,6 @@
 #include <linux/sockios.h>
 #include <linux/workqueue.h>
 #include <asm/atomic.h>
-#include <asm/bitops.h>
 #include <asm/dma.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff -puN drivers/net/mac89x0.c~remove-asm-bitopsh-includes drivers/net/mac89x0.c
--- a/drivers/net/mac89x0.c~remove-asm-bitopsh-includes
+++ a/drivers/net/mac89x0.c
@@ -99,9 +99,9 @@ static char *version =
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>
+#include <linux/bitops.h>
 
 #include <asm/system.h>
-#include <asm/bitops.h>
 #include <asm/io.h>
 #include <asm/hwtest.h>
 #include <asm/macints.h>
diff -puN drivers/net/spider_net.c~remove-asm-bitopsh-includes drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~remove-asm-bitopsh-includes
+++ a/drivers/net/spider_net.c
@@ -46,7 +46,7 @@
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include <asm/pci-bridge.h>
 #include <net/checksum.h>
 
diff -puN drivers/net/tulip/uli526x.c~remove-asm-bitopsh-includes drivers/net/tulip/uli526x.c
--- a/drivers/net/tulip/uli526x.c~remove-asm-bitopsh-includes
+++ a/drivers/net/tulip/uli526x.c
@@ -34,9 +34,9 @@
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
+#include <linux/bitops.h>
 
 #include <asm/processor.h>
-#include <asm/bitops.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/uaccess.h>
diff -puN drivers/net/wireless/bcm43xx/bcm43xx_leds.c~remove-asm-bitopsh-includes drivers/net/wireless/bcm43xx/bcm43xx_leds.c
--- a/drivers/net/wireless/bcm43xx/bcm43xx_leds.c~remove-asm-bitopsh-includes
+++ a/drivers/net/wireless/bcm43xx/bcm43xx_leds.c
@@ -29,7 +29,7 @@
 #include "bcm43xx_radio.h"
 #include "bcm43xx.h"
 
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 
 
 static void bcm43xx_led_changestate(struct bcm43xx_led *led)
diff -puN drivers/pcmcia/m32r_pcc.c~remove-asm-bitopsh-includes drivers/pcmcia/m32r_pcc.c
--- a/drivers/pcmcia/m32r_pcc.c~remove-asm-bitopsh-includes
+++ a/drivers/pcmcia/m32r_pcc.c
@@ -22,9 +22,9 @@
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/bitops.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/bitops.h>
 #include <asm/system.h>
 #include <asm/addrspace.h>
 
diff -puN drivers/pcmcia/m8xx_pcmcia.c~remove-asm-bitopsh-includes drivers/pcmcia/m8xx_pcmcia.c
--- a/drivers/pcmcia/m8xx_pcmcia.c~remove-asm-bitopsh-includes
+++ a/drivers/pcmcia/m8xx_pcmcia.c
@@ -48,9 +48,9 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/fsl_devices.h>
+#include <linux/bitops.h>
 
 #include <asm/io.h>
-#include <asm/bitops.h>
 #include <asm/system.h>
 #include <asm/time.h>
 #include <asm/mpc8xx.h>
diff -puN drivers/ps3/vuart.c~remove-asm-bitopsh-includes drivers/ps3/vuart.c
--- a/drivers/ps3/vuart.c~remove-asm-bitopsh-includes
+++ a/drivers/ps3/vuart.c
@@ -22,11 +22,11 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
+#include <linux/bitops.h>
 #include <asm/ps3.h>
 
 #include <asm/firmware.h>
 #include <asm/lv1call.h>
-#include <asm/bitops.h>
 
 #include "vuart.h"
 
diff -puN drivers/rtc/rtc-pl031.c~remove-asm-bitopsh-includes drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~remove-asm-bitopsh-includes
+++ a/drivers/rtc/rtc-pl031.c
@@ -21,11 +21,11 @@
 #include <linux/interrupt.h>
 #include <linux/string.h>
 #include <linux/pm.h>
+#include <linux/bitops.h>
 
 #include <linux/amba/bus.h>
 
 #include <asm/io.h>
-#include <asm/bitops.h>
 #include <asm/hardware.h>
 #include <asm/irq.h>
 #include <asm/rtc.h>
diff -puN drivers/rtc/rtc-sa1100.c~remove-asm-bitopsh-includes drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~remove-asm-bitopsh-includes
+++ a/drivers/rtc/rtc-sa1100.c
@@ -29,8 +29,8 @@
 #include <linux/interrupt.h>
 #include <linux/string.h>
 #include <linux/pm.h>
+#include <linux/bitops.h>
 
-#include <asm/bitops.h>
 #include <asm/hardware.h>
 #include <asm/irq.h>
 #include <asm/rtc.h>
diff -puN drivers/s390/cio/idset.c~remove-asm-bitopsh-includes drivers/s390/cio/idset.c
--- a/drivers/s390/cio/idset.c~remove-asm-bitopsh-includes
+++ a/drivers/s390/cio/idset.c
@@ -6,7 +6,7 @@
  */
 
 #include <linux/slab.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include "idset.h"
 #include "css.h"
 
diff -puN drivers/s390/net/claw.c~remove-asm-bitopsh-includes drivers/s390/net/claw.c
--- a/drivers/s390/net/claw.c~remove-asm-bitopsh-includes
+++ a/drivers/s390/net/claw.c
@@ -59,13 +59,13 @@
  *    1.15  Changed for 2.6 Kernel  No longer compiles on 2.4 or lower
  *    1.25  Added Packing support
  */
-#include <asm/bitops.h>
 #include <asm/ccwdev.h>
 #include <asm/ccwgroup.h>
 #include <asm/debug.h>
 #include <asm/idals.h>
 #include <asm/io.h>
 
+#include <linux/bitops.h>
 #include <linux/ctype.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
diff -puN drivers/scsi/ide-scsi.c~remove-asm-bitopsh-includes drivers/scsi/ide-scsi.c
--- a/drivers/scsi/ide-scsi.c~remove-asm-bitopsh-includes
+++ a/drivers/scsi/ide-scsi.c
@@ -47,9 +47,9 @@
 #include <linux/scatterlist.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/bitops.h>
 
 #include <asm/io.h>
-#include <asm/bitops.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
diff -puN drivers/serial/crisv10.c~remove-asm-bitopsh-includes drivers/serial/crisv10.c
--- a/drivers/serial/crisv10.c~remove-asm-bitopsh-includes
+++ a/drivers/serial/crisv10.c
@@ -442,11 +442,11 @@ static char *serial_version = "$Revision
 #include <asm/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
+#include <linux/bitops.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/system.h>
-#include <asm/bitops.h>
 #include <linux/delay.h>
 
 #include <asm/arch/svinto.h>
diff -puN drivers/watchdog/at91rm9200_wdt.c~remove-asm-bitopsh-includes drivers/watchdog/at91rm9200_wdt.c
--- a/drivers/watchdog/at91rm9200_wdt.c~remove-asm-bitopsh-includes
+++ a/drivers/watchdog/at91rm9200_wdt.c
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -19,7 +20,6 @@
 #include <linux/platform_device.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
-#include <asm/bitops.h>
 #include <asm/uaccess.h>
 #include <asm/arch/at91_st.h>
 
diff -puN drivers/watchdog/ks8695_wdt.c~remove-asm-bitopsh-includes drivers/watchdog/ks8695_wdt.c
--- a/drivers/watchdog/ks8695_wdt.c~remove-asm-bitopsh-includes
+++ a/drivers/watchdog/ks8695_wdt.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -18,7 +19,6 @@
 #include <linux/platform_device.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
-#include <asm/bitops.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/arch/regs-timer.h>
diff -puN drivers/watchdog/omap_wdt.c~remove-asm-bitopsh-includes drivers/watchdog/omap_wdt.c
--- a/drivers/watchdog/omap_wdt.c~remove-asm-bitopsh-includes
+++ a/drivers/watchdog/omap_wdt.c
@@ -39,11 +39,11 @@
 #include <linux/platform_device.h>
 #include <linux/moduleparam.h>
 #include <linux/clk.h>
+#include <linux/bitops.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/hardware.h>
-#include <asm/bitops.h>
 
 #include <asm/arch/prcm.h>
 
diff -puN drivers/watchdog/sa1100_wdt.c~remove-asm-bitopsh-includes drivers/watchdog/sa1100_wdt.c
--- a/drivers/watchdog/sa1100_wdt.c~remove-asm-bitopsh-includes
+++ a/drivers/watchdog/sa1100_wdt.c
@@ -25,13 +25,13 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
+#include <linux/bitops.h>
 
 #ifdef CONFIG_ARCH_PXA
 #include <asm/arch/pxa-regs.h>
 #endif
 
 #include <asm/hardware.h>
-#include <asm/bitops.h>
 #include <asm/uaccess.h>
 
 #define OSCR_FREQ		CLOCK_TICK_RATE
diff -puN include/asm-cris/posix_types.h~remove-asm-bitopsh-includes include/asm-cris/posix_types.h
--- a/include/asm-cris/posix_types.h~remove-asm-bitopsh-includes
+++ a/include/asm-cris/posix_types.h
@@ -52,7 +52,7 @@ typedef struct {
 } __kernel_fsid_t;
 
 #ifdef __KERNEL__
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 
 #undef	__FD_SET
 #define __FD_SET(fd,fdsetp) set_bit(fd, (void *)(fdsetp))
diff -puN include/asm-ia64/cacheflush.h~remove-asm-bitopsh-includes include/asm-ia64/cacheflush.h
--- a/include/asm-ia64/cacheflush.h~remove-asm-bitopsh-includes
+++ a/include/asm-ia64/cacheflush.h
@@ -7,8 +7,8 @@
  */
 
 #include <linux/page-flags.h>
+#include <linux/bitops.h>
 
-#include <asm/bitops.h>
 #include <asm/page.h>
 
 /*
diff -puN include/asm-ia64/pgtable.h~remove-asm-bitopsh-includes include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~remove-asm-bitopsh-includes
+++ a/include/asm-ia64/pgtable.h
@@ -150,7 +150,7 @@
 # ifndef __ASSEMBLY__
 
 #include <linux/sched.h>	/* for mm_struct */
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
 #include <asm/processor.h>
diff -puN include/asm-ia64/smp.h~remove-asm-bitopsh-includes include/asm-ia64/smp.h
--- a/include/asm-ia64/smp.h~remove-asm-bitopsh-includes
+++ a/include/asm-ia64/smp.h
@@ -14,8 +14,8 @@
 #include <linux/threads.h>
 #include <linux/kernel.h>
 #include <linux/cpumask.h>
+#include <linux/bitops.h>
 
-#include <asm/bitops.h>
 #include <asm/io.h>
 #include <asm/param.h>
 #include <asm/processor.h>
diff -puN include/asm-ia64/spinlock.h~remove-asm-bitopsh-includes include/asm-ia64/spinlock.h
--- a/include/asm-ia64/spinlock.h~remove-asm-bitopsh-includes
+++ a/include/asm-ia64/spinlock.h
@@ -11,9 +11,9 @@
 
 #include <linux/compiler.h>
 #include <linux/kernel.h>
+#include <linux/bitops.h>
 
 #include <asm/atomic.h>
-#include <asm/bitops.h>
 #include <asm/intrinsics.h>
 #include <asm/system.h>
 
diff -puN include/asm-m32r/pgtable.h~remove-asm-bitopsh-includes include/asm-m32r/pgtable.h
--- a/include/asm-m32r/pgtable.h~remove-asm-bitopsh-includes
+++ a/include/asm-m32r/pgtable.h
@@ -21,9 +21,9 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/threads.h>
+#include <linux/bitops.h>
 #include <asm/processor.h>
 #include <asm/addrspace.h>
-#include <asm/bitops.h>
 #include <asm/page.h>
 
 struct mm_struct;
diff -puN include/asm-mips/fpu.h~remove-asm-bitopsh-includes include/asm-mips/fpu.h
--- a/include/asm-mips/fpu.h~remove-asm-bitopsh-includes
+++ a/include/asm-mips/fpu.h
@@ -12,12 +12,12 @@
 
 #include <linux/sched.h>
 #include <linux/thread_info.h>
+#include <linux/bitops.h>
 
 #include <asm/mipsregs.h>
 #include <asm/cpu.h>
 #include <asm/cpu-features.h>
 #include <asm/hazards.h>
-#include <asm/bitops.h>
 #include <asm/processor.h>
 #include <asm/current.h>
 
diff -puN include/asm-parisc/pgtable.h~remove-asm-bitopsh-includes include/asm-parisc/pgtable.h
--- a/include/asm-parisc/pgtable.h~remove-asm-bitopsh-includes
+++ a/include/asm-parisc/pgtable.h
@@ -11,9 +11,9 @@
  */
 
 #include <linux/mm.h>		/* for vm_area_struct */
+#include <linux/bitops.h>
 #include <asm/processor.h>
 #include <asm/cache.h>
-#include <asm/bitops.h>
 
 /*
  * kern_addr_valid(ADDR) tests if ADDR is pointing to valid kernel
diff -puN include/asm-powerpc/iommu.h~remove-asm-bitopsh-includes include/asm-powerpc/iommu.h
--- a/include/asm-powerpc/iommu.h~remove-asm-bitopsh-includes
+++ a/include/asm-powerpc/iommu.h
@@ -26,9 +26,9 @@
 #include <linux/spinlock.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/bitops.h>
 #include <asm/machdep.h>
 #include <asm/types.h>
-#include <asm/bitops.h>
 
 #define IOMMU_PAGE_SHIFT      12
 #define IOMMU_PAGE_SIZE       (ASM_CONST(1) << IOMMU_PAGE_SHIFT)
diff -puN include/asm-powerpc/mmu_context.h~remove-asm-bitopsh-includes include/asm-powerpc/mmu_context.h
--- a/include/asm-powerpc/mmu_context.h~remove-asm-bitopsh-includes
+++ a/include/asm-powerpc/mmu_context.h
@@ -8,7 +8,7 @@
 
 #ifndef CONFIG_PPC64
 #include <asm/atomic.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 
 /*
  * On 32-bit PowerPC 6xx/7xx/7xxx CPUs, we use a set of 16 VSIDs
diff -puN include/asm-ppc/mmu_context.h~remove-asm-bitopsh-includes include/asm-ppc/mmu_context.h
--- a/include/asm-ppc/mmu_context.h~remove-asm-bitopsh-includes
+++ a/include/asm-ppc/mmu_context.h
@@ -2,8 +2,9 @@
 #ifndef __PPC_MMU_CONTEXT_H
 #define __PPC_MMU_CONTEXT_H
 
+#include <linux/bitops.h>
+
 #include <asm/atomic.h>
-#include <asm/bitops.h>
 #include <asm/mmu.h>
 #include <asm/cputable.h>
 #include <asm-generic/mm_hooks.h>
diff -puN include/asm-sparc64/smp.h~remove-asm-bitopsh-includes include/asm-sparc64/smp.h
--- a/include/asm-sparc64/smp.h~remove-asm-bitopsh-includes
+++ a/include/asm-sparc64/smp.h
@@ -26,7 +26,7 @@
  *	Private routines/data
  */
  
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include <asm/atomic.h>
 #include <asm/percpu.h>
 
diff -puN include/asm-x86/pgtable_32.h~remove-asm-bitopsh-includes include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h~remove-asm-bitopsh-includes
+++ a/include/asm-x86/pgtable_32.h
@@ -17,10 +17,7 @@
 #include <linux/threads.h>
 #include <asm/paravirt.h>
 
-#ifndef _I386_BITOPS_H
-#include <asm/bitops.h>
-#endif
-
+#include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
diff -puN include/asm-x86/pgtable_64.h~remove-asm-bitopsh-includes include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h~remove-asm-bitopsh-includes
+++ a/include/asm-x86/pgtable_64.h
@@ -9,7 +9,7 @@
  * the x86-64 page table tree.
  */
 #include <asm/processor.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include <linux/threads.h>
 #include <asm/pda.h>
 
diff -puN include/asm-x86/smp_32.h~remove-asm-bitopsh-includes include/asm-x86/smp_32.h
--- a/include/asm-x86/smp_32.h~remove-asm-bitopsh-includes
+++ a/include/asm-x86/smp_32.h
@@ -11,7 +11,7 @@
 #endif
 
 #if defined(CONFIG_X86_LOCAL_APIC) && !defined(__ASSEMBLY__)
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include <asm/mpspec.h>
 #include <asm/apic.h>
 #ifdef CONFIG_X86_IO_APIC
diff -puN include/asm-x86/topology_64.h~remove-asm-bitopsh-includes include/asm-x86/topology_64.h
--- a/include/asm-x86/topology_64.h~remove-asm-bitopsh-includes
+++ a/include/asm-x86/topology_64.h
@@ -5,7 +5,7 @@
 #ifdef CONFIG_NUMA
 
 #include <asm/mpspec.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 
 extern cpumask_t cpu_online_map;
 
diff -puN include/linux/of.h~remove-asm-bitopsh-includes include/linux/of.h
--- a/include/linux/of.h~remove-asm-bitopsh-includes
+++ a/include/linux/of.h
@@ -16,8 +16,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 #include <linux/types.h>
+#include <linux/bitops.h>
 
-#include <asm/bitops.h>
 #include <asm/prom.h>
 
 /* flag descriptions */
diff -puN lib/hweight.c~remove-asm-bitopsh-includes lib/hweight.c
--- a/lib/hweight.c~remove-asm-bitopsh-includes
+++ a/lib/hweight.c
@@ -1,6 +1,6 @@
 #include <linux/module.h>
+#include <linux/bitops.h>
 #include <asm/types.h>
-#include <asm/bitops.h>
 
 /**
  * hweightN - returns the hamming weight of a N-bit word
diff -puN net/core/gen_estimator.c~remove-asm-bitopsh-includes net/core/gen_estimator.c
--- a/net/core/gen_estimator.c~remove-asm-bitopsh-includes
+++ a/net/core/gen_estimator.c
@@ -15,7 +15,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff -puN net/core/pktgen.c~remove-asm-bitopsh-includes net/core/pktgen.c
--- a/net/core/pktgen.c~remove-asm-bitopsh-includes
+++ a/net/core/pktgen.c
@@ -161,7 +161,7 @@
 #endif
 #include <asm/byteorder.h>
 #include <linux/rcupdate.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/uaccess.h>
diff -puN net/ipv4/fib_trie.c~remove-asm-bitopsh-includes net/ipv4/fib_trie.c
--- a/net/ipv4/fib_trie.c~remove-asm-bitopsh-includes
+++ a/net/ipv4/fib_trie.c
@@ -54,7 +54,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
diff -puN net/netfilter/xt_connbytes.c~remove-asm-bitopsh-includes net/netfilter/xt_connbytes.c
--- a/net/netfilter/xt_connbytes.c~remove-asm-bitopsh-includes
+++ a/net/netfilter/xt_connbytes.c
@@ -2,13 +2,13 @@
  * GPL (C) 2002 Martin Devera (devik@cdi.cz).
  */
 #include <linux/module.h>
+#include <linux/bitops.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_connbytes.h>
 #include <net/netfilter/nf_conntrack.h>
 
 #include <asm/div64.h>
-#include <asm/bitops.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
