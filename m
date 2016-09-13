From: akpm@linux-foundation.org
Subject: + treewide-remove-redundant-include-linux-kconfigh.patch added to -mm tree
Date: Tue, 13 Sep 2016 15:12:09 -0700
Message-ID: <57d879b9.lbpRDJFiFtjL8ul4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35288 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755957AbcIMWMK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2016 18:12:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: remove redundant #include <linux/kconfig.h>
has been added to the -mm tree.  Its filename is
     treewide-remove-redundant-include-linux-kconfigh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/treewide-remove-redundant-include-linux-kconfigh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/treewide-remove-redundant-include-linux-kconfigh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: treewide: remove redundant #include <linux/kconfig.h>

Kernel source files need not include <linux/kconfig.h> explicitly
because the top Makefile forces to include it with:

  -include $(srctree)/include/linux/kconfig.h

This commit removes explicit includes except the following:

  * arch/s390/include/asm/facilities_src.h
  * tools/testing/radix-tree/linux/kernel.h

These two are used for host programs.

Link: http://lkml.kernel.org/r/1473656164-11929-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/trusted_foundations.h       |    1 -
 arch/arm64/include/asm/alternative.h             |    1 -
 arch/mips/include/asm/mach-loongson64/loongson.h |    1 -
 arch/mips/math-emu/cp1emu.c                      |    1 -
 arch/mips/net/bpf_jit.c                          |    1 -
 drivers/char/virtio_console.c                    |    1 -
 drivers/input/rmi4/rmi_bus.c                     |    1 -
 drivers/input/rmi4/rmi_driver.c                  |    1 -
 drivers/input/rmi4/rmi_f01.c                     |    1 -
 drivers/input/rmi4/rmi_f11.c                     |    1 -
 drivers/irqchip/irq-bcm6345-l1.c                 |    1 -
 drivers/irqchip/irq-bcm7038-l1.c                 |    1 -
 drivers/irqchip/irq-bcm7120-l2.c                 |    1 -
 drivers/irqchip/irq-brcmstb-l2.c                 |    1 -
 drivers/media/dvb-frontends/af9013.h             |    1 -
 drivers/media/dvb-frontends/af9033.h             |    2 --
 drivers/media/dvb-frontends/ascot2e.h            |    1 -
 drivers/media/dvb-frontends/atbm8830.h           |    1 -
 drivers/media/dvb-frontends/au8522.h             |    1 -
 drivers/media/dvb-frontends/cx22702.h            |    1 -
 drivers/media/dvb-frontends/cx24113.h            |    2 --
 drivers/media/dvb-frontends/cx24116.h            |    1 -
 drivers/media/dvb-frontends/cx24117.h            |    1 -
 drivers/media/dvb-frontends/cx24120.h            |    1 -
 drivers/media/dvb-frontends/cx24123.h            |    1 -
 drivers/media/dvb-frontends/cxd2820r.h           |    1 -
 drivers/media/dvb-frontends/cxd2841er.h          |    1 -
 drivers/media/dvb-frontends/dib3000mc.h          |    2 --
 drivers/media/dvb-frontends/dib7000m.h           |    2 --
 drivers/media/dvb-frontends/dib7000p.h           |    2 --
 drivers/media/dvb-frontends/drxd.h               |    1 -
 drivers/media/dvb-frontends/drxk.h               |    1 -
 drivers/media/dvb-frontends/ds3000.h             |    1 -
 drivers/media/dvb-frontends/dvb_dummy_fe.h       |    1 -
 drivers/media/dvb-frontends/ec100.h              |    1 -
 drivers/media/dvb-frontends/hd29l2.h             |    1 -
 drivers/media/dvb-frontends/helene.h             |    1 -
 drivers/media/dvb-frontends/horus3a.h            |    1 -
 drivers/media/dvb-frontends/ix2505v.h            |    1 -
 drivers/media/dvb-frontends/lg2160.h             |    1 -
 drivers/media/dvb-frontends/lgdt3305.h           |    1 -
 drivers/media/dvb-frontends/lgs8gl5.h            |    1 -
 drivers/media/dvb-frontends/lgs8gxx.h            |    1 -
 drivers/media/dvb-frontends/lnbh24.h             |    2 --
 drivers/media/dvb-frontends/lnbh25.h             |    1 -
 drivers/media/dvb-frontends/lnbp21.h             |    2 --
 drivers/media/dvb-frontends/lnbp22.h             |    2 --
 drivers/media/dvb-frontends/m88rs2000.h          |    1 -
 drivers/media/dvb-frontends/mb86a20s.h           |    1 -
 drivers/media/dvb-frontends/s5h1409.h            |    1 -
 drivers/media/dvb-frontends/s5h1411.h            |    1 -
 drivers/media/dvb-frontends/s5h1432.h            |    1 -
 drivers/media/dvb-frontends/s921.h               |    1 -
 drivers/media/dvb-frontends/si21xx.h             |    1 -
 drivers/media/dvb-frontends/sp2.h                |    1 -
 drivers/media/dvb-frontends/stb6000.h            |    1 -
 drivers/media/dvb-frontends/stv0288.h            |    1 -
 drivers/media/dvb-frontends/stv0367.h            |    1 -
 drivers/media/dvb-frontends/stv0900.h            |    1 -
 drivers/media/dvb-frontends/stv6110.h            |    1 -
 drivers/media/dvb-frontends/tda10048.h           |    1 -
 drivers/media/dvb-frontends/tda18271c2dd.h       |    2 --
 drivers/media/dvb-frontends/ts2020.h             |    1 -
 drivers/media/dvb-frontends/zl10036.h            |    1 -
 drivers/media/dvb-frontends/zl10039.h            |    2 --
 drivers/media/pci/cx23885/altera-ci.h            |    2 --
 drivers/media/tuners/fc0011.h                    |    1 -
 drivers/media/tuners/fc0012.h                    |    1 -
 drivers/media/tuners/fc0013.h                    |    1 -
 drivers/media/tuners/max2165.h                   |    2 --
 drivers/media/tuners/mc44s803.h                  |    2 --
 drivers/media/tuners/mxl5005s.h                  |    2 --
 drivers/media/tuners/r820t.h                     |    1 -
 drivers/media/tuners/si2157.h                    |    1 -
 drivers/media/tuners/tda18212.h                  |    1 -
 drivers/media/tuners/tda18218.h                  |    1 -
 drivers/media/tuners/xc5000.h                    |    1 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h    |    1 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h    |    1 -
 drivers/media/usb/dvb-usb/dibusb-common.c        |    1 -
 drivers/media/usb/hdpvr/hdpvr-video.c            |    1 -
 drivers/mtd/mtdcore.c                            |    1 -
 drivers/mtd/mtdpart.c                            |    1 -
 drivers/net/dsa/b53/b53_mmap.c                   |    1 -
 drivers/net/ethernet/sun/ldmvsw.c                |    1 -
 drivers/net/ethernet/wiznet/w5100.c              |    1 -
 drivers/net/ethernet/wiznet/w5300.c              |    1 -
 drivers/usb/early/ehci-dbgp.c                    |    1 -
 drivers/usb/gadget/udc/bcm63xx_udc.c             |    1 -
 drivers/usb/host/pci-quirks.c                    |    1 -
 fs/lockd/procfs.h                                |    2 --
 include/linux/export.h                           |    1 -
 include/linux/gpio/driver.h                      |    1 -
 net/batman-adv/debugfs.h                         |    2 --
 sound/soc/intel/common/sst-acpi.h                |    1 -
 tools/testing/nvdimm/config_check.c              |    1 -
 96 files changed, 112 deletions(-)

diff -puN arch/arm/include/asm/trusted_foundations.h~treewide-remove-redundant-include-linux-kconfigh arch/arm/include/asm/trusted_foundations.h
--- a/arch/arm/include/asm/trusted_foundations.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/arch/arm/include/asm/trusted_foundations.h
@@ -26,7 +26,6 @@
 #ifndef __ASM_ARM_TRUSTED_FOUNDATIONS_H
 #define __ASM_ARM_TRUSTED_FOUNDATIONS_H
 
-#include <linux/kconfig.h>
 #include <linux/printk.h>
 #include <linux/bug.h>
 #include <linux/of.h>
diff -puN arch/arm64/include/asm/alternative.h~treewide-remove-redundant-include-linux-kconfigh arch/arm64/include/asm/alternative.h
--- a/arch/arm64/include/asm/alternative.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/arch/arm64/include/asm/alternative.h
@@ -7,7 +7,6 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/init.h>
-#include <linux/kconfig.h>
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/stringify.h>
diff -puN arch/mips/include/asm/mach-loongson64/loongson.h~treewide-remove-redundant-include-linux-kconfigh arch/mips/include/asm/mach-loongson64/loongson.h
--- a/arch/mips/include/asm/mach-loongson64/loongson.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/arch/mips/include/asm/mach-loongson64/loongson.h
@@ -14,7 +14,6 @@
 #include <linux/io.h>
 #include <linux/init.h>
 #include <linux/irq.h>
-#include <linux/kconfig.h>
 #include <boot_param.h>
 
 /* loongson internal northbridge initialization */
diff -puN arch/mips/math-emu/cp1emu.c~treewide-remove-redundant-include-linux-kconfigh arch/mips/math-emu/cp1emu.c
--- a/arch/mips/math-emu/cp1emu.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/arch/mips/math-emu/cp1emu.c
@@ -35,7 +35,6 @@
  */
 #include <linux/sched.h>
 #include <linux/debugfs.h>
-#include <linux/kconfig.h>
 #include <linux/percpu-defs.h>
 #include <linux/perf_event.h>
 
diff -puN arch/mips/net/bpf_jit.c~treewide-remove-redundant-include-linux-kconfigh arch/mips/net/bpf_jit.c
--- a/arch/mips/net/bpf_jit.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/arch/mips/net/bpf_jit.c
@@ -14,7 +14,6 @@
 #include <linux/errno.h>
 #include <linux/filter.h>
 #include <linux/if_vlan.h>
-#include <linux/kconfig.h>
 #include <linux/moduleloader.h>
 #include <linux/netdevice.h>
 #include <linux/string.h>
diff -puN drivers/char/virtio_console.c~treewide-remove-redundant-include-linux-kconfigh drivers/char/virtio_console.c
--- a/drivers/char/virtio_console.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/char/virtio_console.c
@@ -38,7 +38,6 @@
 #include <linux/workqueue.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
-#include <linux/kconfig.h>
 #include "../tty/hvc/hvc_console.h"
 
 #define is_rproc_enabled IS_ENABLED(CONFIG_REMOTEPROC)
diff -puN drivers/input/rmi4/rmi_bus.c~treewide-remove-redundant-include-linux-kconfigh drivers/input/rmi4/rmi_bus.c
--- a/drivers/input/rmi4/rmi_bus.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/input/rmi4/rmi_bus.c
@@ -9,7 +9,6 @@
 
 #include <linux/kernel.h>
 #include <linux/device.h>
-#include <linux/kconfig.h>
 #include <linux/list.h>
 #include <linux/pm.h>
 #include <linux/rmi.h>
diff -puN drivers/input/rmi4/rmi_driver.c~treewide-remove-redundant-include-linux-kconfigh drivers/input/rmi4/rmi_driver.c
--- a/drivers/input/rmi4/rmi_driver.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/input/rmi4/rmi_driver.c
@@ -17,7 +17,6 @@
 #include <linux/bitmap.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
-#include <linux/kconfig.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/of.h>
diff -puN drivers/input/rmi4/rmi_f01.c~treewide-remove-redundant-include-linux-kconfigh drivers/input/rmi4/rmi_f01.c
--- a/drivers/input/rmi4/rmi_f01.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/input/rmi4/rmi_f01.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kconfig.h>
 #include <linux/rmi.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
diff -puN drivers/input/rmi4/rmi_f11.c~treewide-remove-redundant-include-linux-kconfigh drivers/input/rmi4/rmi_f11.c
--- a/drivers/input/rmi4/rmi_f11.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/input/rmi4/rmi_f11.c
@@ -12,7 +12,6 @@
 #include <linux/device.h>
 #include <linux/input.h>
 #include <linux/input/mt.h>
-#include <linux/kconfig.h>
 #include <linux/rmi.h>
 #include <linux/slab.h>
 #include <linux/of.h>
diff -puN drivers/irqchip/irq-bcm6345-l1.c~treewide-remove-redundant-include-linux-kconfigh drivers/irqchip/irq-bcm6345-l1.c
--- a/drivers/irqchip/irq-bcm6345-l1.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/irqchip/irq-bcm6345-l1.c
@@ -52,7 +52,6 @@
 
 #include <linux/bitops.h>
 #include <linux/cpumask.h>
-#include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff -puN drivers/irqchip/irq-bcm7038-l1.c~treewide-remove-redundant-include-linux-kconfigh drivers/irqchip/irq-bcm7038-l1.c
--- a/drivers/irqchip/irq-bcm7038-l1.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/irqchip/irq-bcm7038-l1.c
@@ -12,7 +12,6 @@
 #define pr_fmt(fmt)	KBUILD_MODNAME	": " fmt
 
 #include <linux/bitops.h>
-#include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff -puN drivers/irqchip/irq-bcm7120-l2.c~treewide-remove-redundant-include-linux-kconfigh drivers/irqchip/irq-bcm7120-l2.c
--- a/drivers/irqchip/irq-bcm7120-l2.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/irqchip/irq-bcm7120-l2.c
@@ -13,7 +13,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
diff -puN drivers/irqchip/irq-brcmstb-l2.c~treewide-remove-redundant-include-linux-kconfigh drivers/irqchip/irq-brcmstb-l2.c
--- a/drivers/irqchip/irq-brcmstb-l2.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/irqchip/irq-brcmstb-l2.c
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/kconfig.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
 #include <linux/of.h>
diff -puN drivers/media/dvb-frontends/af9013.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/af9013.h
--- a/drivers/media/dvb-frontends/af9013.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/af9013.h
@@ -25,7 +25,6 @@
 #ifndef AF9013_H
 #define AF9013_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 /* AF9013/5 GPIOs (mostly guessed)
diff -puN drivers/media/dvb-frontends/af9033.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/af9033.h
--- a/drivers/media/dvb-frontends/af9033.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/af9033.h
@@ -22,8 +22,6 @@
 #ifndef AF9033_H
 #define AF9033_H
 
-#include <linux/kconfig.h>
-
 /*
  * I2C address (TODO: are these in 8-bit format?)
  * 0x38, 0x3a, 0x3c, 0x3e
diff -puN drivers/media/dvb-frontends/ascot2e.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/ascot2e.h
--- a/drivers/media/dvb-frontends/ascot2e.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/ascot2e.h
@@ -22,7 +22,6 @@
 #ifndef __DVB_ASCOT2E_H__
 #define __DVB_ASCOT2E_H__
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
diff -puN drivers/media/dvb-frontends/atbm8830.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/atbm8830.h
--- a/drivers/media/dvb-frontends/atbm8830.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/atbm8830.h
@@ -22,7 +22,6 @@
 #ifndef __ATBM8830_H__
 #define __ATBM8830_H__
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
diff -puN drivers/media/dvb-frontends/au8522.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/au8522.h
--- a/drivers/media/dvb-frontends/au8522.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/au8522.h
@@ -22,7 +22,6 @@
 #ifndef __AU8522_H__
 #define __AU8522_H__
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 enum au8522_if_freq {
diff -puN drivers/media/dvb-frontends/cx22702.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/cx22702.h
--- a/drivers/media/dvb-frontends/cx22702.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/cx22702.h
@@ -28,7 +28,6 @@
 #ifndef CX22702_H
 #define CX22702_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct cx22702_config {
diff -puN drivers/media/dvb-frontends/cx24113.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/cx24113.h
--- a/drivers/media/dvb-frontends/cx24113.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/cx24113.h
@@ -22,8 +22,6 @@
 #ifndef CX24113_H
 #define CX24113_H
 
-#include <linux/kconfig.h>
-
 struct dvb_frontend;
 
 struct cx24113_config {
diff -puN drivers/media/dvb-frontends/cx24116.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/cx24116.h
--- a/drivers/media/dvb-frontends/cx24116.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/cx24116.h
@@ -21,7 +21,6 @@
 #ifndef CX24116_H
 #define CX24116_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct cx24116_config {
diff -puN drivers/media/dvb-frontends/cx24117.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/cx24117.h
--- a/drivers/media/dvb-frontends/cx24117.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/cx24117.h
@@ -22,7 +22,6 @@
 #ifndef CX24117_H
 #define CX24117_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct cx24117_config {
diff -puN drivers/media/dvb-frontends/cx24120.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/cx24120.h
--- a/drivers/media/dvb-frontends/cx24120.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/cx24120.h
@@ -20,7 +20,6 @@
 #ifndef CX24120_H
 #define CX24120_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include <linux/firmware.h>
 
diff -puN drivers/media/dvb-frontends/cx24123.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/cx24123.h
--- a/drivers/media/dvb-frontends/cx24123.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/cx24123.h
@@ -21,7 +21,6 @@
 #ifndef CX24123_H
 #define CX24123_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct cx24123_config {
diff -puN drivers/media/dvb-frontends/cxd2820r.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/cxd2820r.h
--- a/drivers/media/dvb-frontends/cxd2820r.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/cxd2820r.h
@@ -22,7 +22,6 @@
 #ifndef CXD2820R_H
 #define CXD2820R_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 #define CXD2820R_GPIO_D (0 << 0) /* disable */
diff -puN drivers/media/dvb-frontends/cxd2841er.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/cxd2841er.h
--- a/drivers/media/dvb-frontends/cxd2841er.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/cxd2841er.h
@@ -22,7 +22,6 @@
 #ifndef CXD2841ER_H
 #define CXD2841ER_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 enum cxd2841er_xtal {
diff -puN drivers/media/dvb-frontends/dib3000mc.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/dib3000mc.h
--- a/drivers/media/dvb-frontends/dib3000mc.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/dib3000mc.h
@@ -13,8 +13,6 @@
 #ifndef DIB3000MC_H
 #define DIB3000MC_H
 
-#include <linux/kconfig.h>
-
 #include "dibx000_common.h"
 
 struct dib3000mc_config {
diff -puN drivers/media/dvb-frontends/dib7000m.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/dib7000m.h
--- a/drivers/media/dvb-frontends/dib7000m.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/dib7000m.h
@@ -1,8 +1,6 @@
 #ifndef DIB7000M_H
 #define DIB7000M_H
 
-#include <linux/kconfig.h>
-
 #include "dibx000_common.h"
 
 struct dib7000m_config {
diff -puN drivers/media/dvb-frontends/dib7000p.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/dib7000p.h
--- a/drivers/media/dvb-frontends/dib7000p.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/dib7000p.h
@@ -1,8 +1,6 @@
 #ifndef DIB7000P_H
 #define DIB7000P_H
 
-#include <linux/kconfig.h>
-
 #include "dibx000_common.h"
 
 struct dib7000p_config {
diff -puN drivers/media/dvb-frontends/drxd.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/drxd.h
--- a/drivers/media/dvb-frontends/drxd.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/drxd.h
@@ -24,7 +24,6 @@
 #ifndef _DRXD_H_
 #define _DRXD_H_
 
-#include <linux/kconfig.h>
 #include <linux/types.h>
 #include <linux/i2c.h>
 
diff -puN drivers/media/dvb-frontends/drxk.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/drxk.h
--- a/drivers/media/dvb-frontends/drxk.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/drxk.h
@@ -1,7 +1,6 @@
 #ifndef _DRXK_H_
 #define _DRXK_H_
 
-#include <linux/kconfig.h>
 #include <linux/types.h>
 #include <linux/i2c.h>
 
diff -puN drivers/media/dvb-frontends/ds3000.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/ds3000.h
--- a/drivers/media/dvb-frontends/ds3000.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/ds3000.h
@@ -22,7 +22,6 @@
 #ifndef DS3000_H
 #define DS3000_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct ds3000_config {
diff -puN drivers/media/dvb-frontends/dvb_dummy_fe.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/dvb_dummy_fe.h
--- a/drivers/media/dvb-frontends/dvb_dummy_fe.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/dvb_dummy_fe.h
@@ -22,7 +22,6 @@
 #ifndef DVB_DUMMY_FE_H
 #define DVB_DUMMY_FE_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/dvb-frontends/ec100.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/ec100.h
--- a/drivers/media/dvb-frontends/ec100.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/ec100.h
@@ -22,7 +22,6 @@
 #ifndef EC100_H
 #define EC100_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct ec100_config {
diff -puN drivers/media/dvb-frontends/hd29l2.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/hd29l2.h
--- a/drivers/media/dvb-frontends/hd29l2.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/hd29l2.h
@@ -23,7 +23,6 @@
 #ifndef HD29L2_H
 #define HD29L2_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct hd29l2_config {
diff -puN drivers/media/dvb-frontends/helene.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/helene.h
--- a/drivers/media/dvb-frontends/helene.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/helene.h
@@ -21,7 +21,6 @@
 #ifndef __DVB_HELENE_H__
 #define __DVB_HELENE_H__
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
diff -puN drivers/media/dvb-frontends/horus3a.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/horus3a.h
--- a/drivers/media/dvb-frontends/horus3a.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/horus3a.h
@@ -22,7 +22,6 @@
 #ifndef __DVB_HORUS3A_H__
 #define __DVB_HORUS3A_H__
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
diff -puN drivers/media/dvb-frontends/ix2505v.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/ix2505v.h
--- a/drivers/media/dvb-frontends/ix2505v.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/ix2505v.h
@@ -20,7 +20,6 @@
 #ifndef DVB_IX2505V_H
 #define DVB_IX2505V_H
 
-#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/dvb-frontends/lg2160.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/lg2160.h
--- a/drivers/media/dvb-frontends/lg2160.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/lg2160.h
@@ -22,7 +22,6 @@
 #ifndef _LG2160_H_
 #define _LG2160_H_
 
-#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/dvb-frontends/lgdt3305.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/lgdt3305.h
--- a/drivers/media/dvb-frontends/lgdt3305.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/lgdt3305.h
@@ -22,7 +22,6 @@
 #ifndef _LGDT3305_H_
 #define _LGDT3305_H_
 
-#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/dvb-frontends/lgs8gl5.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/lgs8gl5.h
--- a/drivers/media/dvb-frontends/lgs8gl5.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/lgs8gl5.h
@@ -23,7 +23,6 @@
 #ifndef LGS8GL5_H
 #define LGS8GL5_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct lgs8gl5_config {
diff -puN drivers/media/dvb-frontends/lgs8gxx.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/lgs8gxx.h
--- a/drivers/media/dvb-frontends/lgs8gxx.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/lgs8gxx.h
@@ -26,7 +26,6 @@
 #ifndef __LGS8GXX_H__
 #define __LGS8GXX_H__
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
diff -puN drivers/media/dvb-frontends/lnbh24.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/lnbh24.h
--- a/drivers/media/dvb-frontends/lnbh24.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/lnbh24.h
@@ -23,8 +23,6 @@
 #ifndef _LNBH24_H
 #define _LNBH24_H
 
-#include <linux/kconfig.h>
-
 /* system register bits */
 #define LNBH24_OLF	0x01
 #define LNBH24_OTF	0x02
diff -puN drivers/media/dvb-frontends/lnbh25.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/lnbh25.h
--- a/drivers/media/dvb-frontends/lnbh25.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/lnbh25.h
@@ -22,7 +22,6 @@
 #define LNBH25_H
 
 #include <linux/i2c.h>
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 /* 22 kHz tone enabled. Tone output controlled by DSQIN pin */
diff -puN drivers/media/dvb-frontends/lnbp21.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/lnbp21.h
--- a/drivers/media/dvb-frontends/lnbp21.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/lnbp21.h
@@ -27,8 +27,6 @@
 #ifndef _LNBP21_H
 #define _LNBP21_H
 
-#include <linux/kconfig.h>
-
 /* system register bits */
 /* [RO] 0=OK; 1=over current limit flag */
 #define LNBP21_OLF	0x01
diff -puN drivers/media/dvb-frontends/lnbp22.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/lnbp22.h
--- a/drivers/media/dvb-frontends/lnbp22.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/lnbp22.h
@@ -28,8 +28,6 @@
 #ifndef _LNBP22_H
 #define _LNBP22_H
 
-#include <linux/kconfig.h>
-
 /* Enable */
 #define LNBP22_EN	  0x10
 /* Voltage selection */
diff -puN drivers/media/dvb-frontends/m88rs2000.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/m88rs2000.h
--- a/drivers/media/dvb-frontends/m88rs2000.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/m88rs2000.h
@@ -20,7 +20,6 @@
 #ifndef M88RS2000_H
 #define M88RS2000_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/dvb-frontends/mb86a20s.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/mb86a20s.h
--- a/drivers/media/dvb-frontends/mb86a20s.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/mb86a20s.h
@@ -16,7 +16,6 @@
 #ifndef MB86A20S_H
 #define MB86A20S_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 /**
diff -puN drivers/media/dvb-frontends/s5h1409.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/s5h1409.h
--- a/drivers/media/dvb-frontends/s5h1409.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/s5h1409.h
@@ -22,7 +22,6 @@
 #ifndef __S5H1409_H__
 #define __S5H1409_H__
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct s5h1409_config {
diff -puN drivers/media/dvb-frontends/s5h1411.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/s5h1411.h
--- a/drivers/media/dvb-frontends/s5h1411.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/s5h1411.h
@@ -22,7 +22,6 @@
 #ifndef __S5H1411_H__
 #define __S5H1411_H__
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 #define S5H1411_I2C_TOP_ADDR (0x32 >> 1)
diff -puN drivers/media/dvb-frontends/s5h1432.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/s5h1432.h
--- a/drivers/media/dvb-frontends/s5h1432.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/s5h1432.h
@@ -22,7 +22,6 @@
 #ifndef __S5H1432_H__
 #define __S5H1432_H__
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 #define S5H1432_I2C_TOP_ADDR (0x02 >> 1)
diff -puN drivers/media/dvb-frontends/s921.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/s921.h
--- a/drivers/media/dvb-frontends/s921.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/s921.h
@@ -17,7 +17,6 @@
 #ifndef S921_H
 #define S921_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct s921_config {
diff -puN drivers/media/dvb-frontends/si21xx.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/si21xx.h
--- a/drivers/media/dvb-frontends/si21xx.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/si21xx.h
@@ -1,7 +1,6 @@
 #ifndef SI21XX_H
 #define SI21XX_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/dvb-frontends/sp2.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/sp2.h
--- a/drivers/media/dvb-frontends/sp2.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/sp2.h
@@ -17,7 +17,6 @@
 #ifndef SP2_H
 #define SP2_H
 
-#include <linux/kconfig.h>
 #include "dvb_ca_en50221.h"
 
 /*
diff -puN drivers/media/dvb-frontends/stb6000.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/stb6000.h
--- a/drivers/media/dvb-frontends/stb6000.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/stb6000.h
@@ -23,7 +23,6 @@
 #ifndef __DVB_STB6000_H__
 #define __DVB_STB6000_H__
 
-#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/dvb-frontends/stv0288.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/stv0288.h
--- a/drivers/media/dvb-frontends/stv0288.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/stv0288.h
@@ -27,7 +27,6 @@
 #ifndef STV0288_H
 #define STV0288_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/dvb-frontends/stv0367.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/stv0367.h
--- a/drivers/media/dvb-frontends/stv0367.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/stv0367.h
@@ -26,7 +26,6 @@
 #ifndef STV0367_H
 #define STV0367_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/dvb-frontends/stv0900.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/stv0900.h
--- a/drivers/media/dvb-frontends/stv0900.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/stv0900.h
@@ -26,7 +26,6 @@
 #ifndef STV0900_H
 #define STV0900_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/dvb-frontends/stv6110.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/stv6110.h
--- a/drivers/media/dvb-frontends/stv6110.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/stv6110.h
@@ -25,7 +25,6 @@
 #ifndef __DVB_STV6110_H__
 #define __DVB_STV6110_H__
 
-#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/dvb-frontends/tda10048.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/tda10048.h
--- a/drivers/media/dvb-frontends/tda10048.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/tda10048.h
@@ -22,7 +22,6 @@
 #ifndef TDA10048_H
 #define TDA10048_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 #include <linux/firmware.h>
 
diff -puN drivers/media/dvb-frontends/tda18271c2dd.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/tda18271c2dd.h
--- a/drivers/media/dvb-frontends/tda18271c2dd.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/tda18271c2dd.h
@@ -1,8 +1,6 @@
 #ifndef _TDA18271C2DD_H_
 #define _TDA18271C2DD_H_
 
-#include <linux/kconfig.h>
-
 #if IS_REACHABLE(CONFIG_DVB_TDA18271C2DD)
 struct dvb_frontend *tda18271c2dd_attach(struct dvb_frontend *fe,
 					 struct i2c_adapter *i2c, u8 adr);
diff -puN drivers/media/dvb-frontends/ts2020.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/ts2020.h
--- a/drivers/media/dvb-frontends/ts2020.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/ts2020.h
@@ -22,7 +22,6 @@
 #ifndef TS2020_H
 #define TS2020_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 struct ts2020_config {
diff -puN drivers/media/dvb-frontends/zl10036.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/zl10036.h
--- a/drivers/media/dvb-frontends/zl10036.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/zl10036.h
@@ -21,7 +21,6 @@
 #ifndef DVB_ZL10036_H
 #define DVB_ZL10036_H
 
-#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/dvb-frontends/zl10039.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/dvb-frontends/zl10039.h
--- a/drivers/media/dvb-frontends/zl10039.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/dvb-frontends/zl10039.h
@@ -22,8 +22,6 @@
 #ifndef ZL10039_H
 #define ZL10039_H
 
-#include <linux/kconfig.h>
-
 #if IS_REACHABLE(CONFIG_DVB_ZL10039)
 struct dvb_frontend *zl10039_attach(struct dvb_frontend *fe,
 					u8 i2c_addr,
diff -puN drivers/media/pci/cx23885/altera-ci.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/pci/cx23885/altera-ci.h
--- a/drivers/media/pci/cx23885/altera-ci.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/pci/cx23885/altera-ci.h
@@ -20,8 +20,6 @@
 #ifndef __ALTERA_CI_H
 #define __ALTERA_CI_H
 
-#include <linux/kconfig.h>
-
 #define ALT_DATA	0x000000ff
 #define ALT_TDI		0x00008000
 #define ALT_TDO		0x00004000
diff -puN drivers/media/tuners/fc0011.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/tuners/fc0011.h
--- a/drivers/media/tuners/fc0011.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/tuners/fc0011.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_FC0011_H_
 #define LINUX_FC0011_H_
 
-#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 
diff -puN drivers/media/tuners/fc0012.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/tuners/fc0012.h
--- a/drivers/media/tuners/fc0012.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/tuners/fc0012.h
@@ -21,7 +21,6 @@
 #ifndef _FC0012_H_
 #define _FC0012_H_
 
-#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 #include "fc001x-common.h"
 
diff -puN drivers/media/tuners/fc0013.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/tuners/fc0013.h
--- a/drivers/media/tuners/fc0013.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/tuners/fc0013.h
@@ -22,7 +22,6 @@
 #ifndef _FC0013_H_
 #define _FC0013_H_
 
-#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 #include "fc001x-common.h"
 
diff -puN drivers/media/tuners/max2165.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/tuners/max2165.h
--- a/drivers/media/tuners/max2165.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/tuners/max2165.h
@@ -22,8 +22,6 @@
 #ifndef __MAX2165_H__
 #define __MAX2165_H__
 
-#include <linux/kconfig.h>
-
 struct dvb_frontend;
 struct i2c_adapter;
 
diff -puN drivers/media/tuners/mc44s803.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/tuners/mc44s803.h
--- a/drivers/media/tuners/mc44s803.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/tuners/mc44s803.h
@@ -22,8 +22,6 @@
 #ifndef MC44S803_H
 #define MC44S803_H
 
-#include <linux/kconfig.h>
-
 struct dvb_frontend;
 struct i2c_adapter;
 
diff -puN drivers/media/tuners/mxl5005s.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/tuners/mxl5005s.h
--- a/drivers/media/tuners/mxl5005s.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/tuners/mxl5005s.h
@@ -23,8 +23,6 @@
 #ifndef __MXL5005S_H
 #define __MXL5005S_H
 
-#include <linux/kconfig.h>
-
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/tuners/r820t.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/tuners/r820t.h
--- a/drivers/media/tuners/r820t.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/tuners/r820t.h
@@ -21,7 +21,6 @@
 #ifndef R820T_H
 #define R820T_H
 
-#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 enum r820t_chip {
diff -puN drivers/media/tuners/si2157.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/tuners/si2157.h
--- a/drivers/media/tuners/si2157.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/tuners/si2157.h
@@ -17,7 +17,6 @@
 #ifndef SI2157_H
 #define SI2157_H
 
-#include <linux/kconfig.h>
 #include <media/media-device.h>
 #include "dvb_frontend.h"
 
diff -puN drivers/media/tuners/tda18212.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/tuners/tda18212.h
--- a/drivers/media/tuners/tda18212.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/tuners/tda18212.h
@@ -21,7 +21,6 @@
 #ifndef TDA18212_H
 #define TDA18212_H
 
-#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 struct tda18212_config {
diff -puN drivers/media/tuners/tda18218.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/tuners/tda18218.h
--- a/drivers/media/tuners/tda18218.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/tuners/tda18218.h
@@ -21,7 +21,6 @@
 #ifndef TDA18218_H
 #define TDA18218_H
 
-#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 
 struct tda18218_config {
diff -puN drivers/media/tuners/xc5000.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/tuners/xc5000.h
--- a/drivers/media/tuners/xc5000.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/tuners/xc5000.h
@@ -22,7 +22,6 @@
 #ifndef __XC5000_H__
 #define __XC5000_H__
 
-#include <linux/kconfig.h>
 #include <linux/firmware.h>
 
 struct dvb_frontend;
diff -puN drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
@@ -21,7 +21,6 @@
 #ifndef __MXL111SF_DEMOD_H__
 #define __MXL111SF_DEMOD_H__
 
-#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 #include "mxl111sf.h"
 
diff -puN drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h~treewide-remove-redundant-include-linux-kconfigh drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
@@ -21,7 +21,6 @@
 #ifndef __MXL111SF_TUNER_H__
 #define __MXL111SF_TUNER_H__
 
-#include <linux/kconfig.h>
 #include "dvb_frontend.h"
 #include "mxl111sf.h"
 
diff -puN drivers/media/usb/dvb-usb/dibusb-common.c~treewide-remove-redundant-include-linux-kconfigh drivers/media/usb/dvb-usb/dibusb-common.c
--- a/drivers/media/usb/dvb-usb/dibusb-common.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -9,7 +9,6 @@
  * see Documentation/dvb/README.dvb-usb for more information
  */
 
-#include <linux/kconfig.h>
 #include "dibusb.h"
 
 /* Max transfer size done by I2C transfer functions */
diff -puN drivers/media/usb/hdpvr/hdpvr-video.c~treewide-remove-redundant-include-linux-kconfigh drivers/media/usb/hdpvr/hdpvr-video.c
--- a/drivers/media/usb/hdpvr/hdpvr-video.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kconfig.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff -puN drivers/mtd/mtdcore.c~treewide-remove-redundant-include-linux-kconfigh drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/mtd/mtdcore.c
@@ -39,7 +39,6 @@
 #include <linux/gfp.h>
 #include <linux/slab.h>
 #include <linux/reboot.h>
-#include <linux/kconfig.h>
 #include <linux/leds.h>
 
 #include <linux/mtd/mtd.h>
diff -puN drivers/mtd/mtdpart.c~treewide-remove-redundant-include-linux-kconfigh drivers/mtd/mtdpart.c
--- a/drivers/mtd/mtdpart.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/mtd/mtdpart.c
@@ -30,7 +30,6 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/err.h>
-#include <linux/kconfig.h>
 
 #include "mtdcore.h"
 
diff -puN drivers/net/dsa/b53/b53_mmap.c~treewide-remove-redundant-include-linux-kconfigh drivers/net/dsa/b53/b53_mmap.c
--- a/drivers/net/dsa/b53/b53_mmap.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/net/dsa/b53/b53_mmap.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kconfig.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
diff -puN drivers/net/ethernet/sun/ldmvsw.c~treewide-remove-redundant-include-linux-kconfigh drivers/net/ethernet/sun/ldmvsw.c
--- a/drivers/net/ethernet/sun/ldmvsw.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/net/ethernet/sun/ldmvsw.c
@@ -11,7 +11,6 @@
 #include <linux/highmem.h>
 #include <linux/if_vlan.h>
 #include <linux/init.h>
-#include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff -puN drivers/net/ethernet/wiznet/w5100.c~treewide-remove-redundant-include-linux-kconfigh drivers/net/ethernet/wiznet/w5100.c
--- a/drivers/net/ethernet/wiznet/w5100.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/net/ethernet/wiznet/w5100.c
@@ -9,7 +9,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/kconfig.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
diff -puN drivers/net/ethernet/wiznet/w5300.c~treewide-remove-redundant-include-linux-kconfigh drivers/net/ethernet/wiznet/w5300.c
--- a/drivers/net/ethernet/wiznet/w5300.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/net/ethernet/wiznet/w5300.c
@@ -10,7 +10,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/kconfig.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
diff -puN drivers/usb/early/ehci-dbgp.c~treewide-remove-redundant-include-linux-kconfigh drivers/usb/early/ehci-dbgp.c
--- a/drivers/usb/early/ehci-dbgp.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/usb/early/ehci-dbgp.c
@@ -20,7 +20,6 @@
 #include <linux/usb/ehci_def.h>
 #include <linux/delay.h>
 #include <linux/serial_core.h>
-#include <linux/kconfig.h>
 #include <linux/kgdb.h>
 #include <linux/kthread.h>
 #include <asm/io.h>
diff -puN drivers/usb/gadget/udc/bcm63xx_udc.c~treewide-remove-redundant-include-linux-kconfigh drivers/usb/gadget/udc/bcm63xx_udc.c
--- a/drivers/usb/gadget/udc/bcm63xx_udc.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/usb/gadget/udc/bcm63xx_udc.c
@@ -21,7 +21,6 @@
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
-#include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
diff -puN drivers/usb/host/pci-quirks.c~treewide-remove-redundant-include-linux-kconfigh drivers/usb/host/pci-quirks.c
--- a/drivers/usb/host/pci-quirks.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/drivers/usb/host/pci-quirks.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
diff -puN fs/lockd/procfs.h~treewide-remove-redundant-include-linux-kconfigh fs/lockd/procfs.h
--- a/fs/lockd/procfs.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/fs/lockd/procfs.h
@@ -6,8 +6,6 @@
 #ifndef _LOCKD_PROCFS_H
 #define _LOCKD_PROCFS_H
 
-#include <linux/kconfig.h>
-
 #if IS_ENABLED(CONFIG_PROC_FS)
 int lockd_create_procfs(void);
 void lockd_remove_procfs(void);
diff -puN include/linux/export.h~treewide-remove-redundant-include-linux-kconfigh include/linux/export.h
--- a/include/linux/export.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/include/linux/export.h
@@ -78,7 +78,6 @@ extern struct module __this_module;
 
 #elif defined(CONFIG_TRIM_UNUSED_KSYMS)
 
-#include <linux/kconfig.h>
 #include <generated/autoksyms.h>
 
 #define __EXPORT_SYMBOL(sym, sec)				\
diff -puN include/linux/gpio/driver.h~treewide-remove-redundant-include-linux-kconfigh include/linux/gpio/driver.h
--- a/include/linux/gpio/driver.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/include/linux/gpio/driver.h
@@ -9,7 +9,6 @@
 #include <linux/irqdomain.h>
 #include <linux/lockdep.h>
 #include <linux/pinctrl/pinctrl.h>
-#include <linux/kconfig.h>
 
 struct gpio_desc;
 struct of_phandle_args;
diff -puN net/batman-adv/debugfs.h~treewide-remove-redundant-include-linux-kconfigh net/batman-adv/debugfs.h
--- a/net/batman-adv/debugfs.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/net/batman-adv/debugfs.h
@@ -20,8 +20,6 @@
 
 #include "main.h"
 
-#include <linux/kconfig.h>
-
 struct net_device;
 
 #define BATADV_DEBUGFS_SUBDIR "batman_adv"
diff -puN sound/soc/intel/common/sst-acpi.h~treewide-remove-redundant-include-linux-kconfigh sound/soc/intel/common/sst-acpi.h
--- a/sound/soc/intel/common/sst-acpi.h~treewide-remove-redundant-include-linux-kconfigh
+++ a/sound/soc/intel/common/sst-acpi.h
@@ -12,7 +12,6 @@
  *
  */
 
-#include <linux/kconfig.h>
 #include <linux/stddef.h>
 #include <linux/acpi.h>
 
diff -puN tools/testing/nvdimm/config_check.c~treewide-remove-redundant-include-linux-kconfigh tools/testing/nvdimm/config_check.c
--- a/tools/testing/nvdimm/config_check.c~treewide-remove-redundant-include-linux-kconfigh
+++ a/tools/testing/nvdimm/config_check.c
@@ -1,4 +1,3 @@
-#include <linux/kconfig.h>
 #include <linux/bug.h>
 
 void check(void)
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

treewide-remove-redundant-include-linux-kconfigh.patch

