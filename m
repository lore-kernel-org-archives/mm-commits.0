From: akpm@linux-foundation.org
Subject: - serial-add-back-early_serial_setup-back-to-head-file.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:51:59 -0700
Message-ID: <200707181851.l6IIpxVh023627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934339AbXGRSwr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:52:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, dhowells@redhat.com, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     serial: add early_serial_setup() back to header file
has been removed from the -mm tree.  Its filename was
     serial-add-back-early_serial_setup-back-to-head-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial: add early_serial_setup() back to header file
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

early_serial_setup is removed from serial.h, but foget to put in
serial_8250.h

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/setup.c                   |    1 +
 arch/mips/basler/excite/excite_setup.c    |    1 +
 arch/mips/gt64120/wrppmc/setup.c          |    1 +
 arch/mips/mips-boards/atlas/atlas_setup.c |    1 +
 arch/mips/mips-boards/sead/sead_setup.c   |    1 +
 arch/mips/mipssim/sim_setup.c             |    1 +
 arch/mips/pmc-sierra/msp71xx/msp_serial.c |    1 +
 arch/mips/pmc-sierra/yosemite/setup.c     |    1 +
 arch/ppc/platforms/4xx/bamboo.c           |    1 +
 arch/ppc/platforms/4xx/bubinga.c          |    1 +
 arch/ppc/platforms/4xx/cpci405.c          |    1 +
 arch/ppc/platforms/4xx/ebony.c            |    1 +
 arch/ppc/platforms/4xx/luan.c             |    1 +
 arch/ppc/platforms/4xx/ocotea.c           |    1 +
 arch/ppc/platforms/4xx/taishan.c          |    1 +
 arch/ppc/platforms/4xx/yucca.c            |    1 +
 arch/ppc/platforms/85xx/sbc8560.c         |    1 +
 arch/ppc/platforms/chestnut.c             |    1 +
 arch/ppc/platforms/ev64260.c              |    1 +
 arch/ppc/platforms/radstone_ppc7d.c       |    1 +
 arch/ppc/platforms/spruce.c               |    1 +
 drivers/parisc/superio.c                  |    1 +
 drivers/serial/8250_hp300.c               |    1 +
 include/linux/serial_8250.h               |    2 ++
 24 files changed, 25 insertions(+)

diff -puN arch/frv/kernel/setup.c~serial-add-back-early_serial_setup-back-to-head-file arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/frv/kernel/setup.c
@@ -29,6 +29,7 @@
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
+#include <linux/serial_8250.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
diff -puN arch/mips/basler/excite/excite_setup.c~serial-add-back-early_serial_setup-back-to-head-file arch/mips/basler/excite/excite_setup.c
--- a/arch/mips/basler/excite/excite_setup.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/mips/basler/excite/excite_setup.c
@@ -26,6 +26,7 @@
 #include <linux/tty.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
+#include <linux/serial_8250.h>
 #include <linux/ioport.h>
 #include <linux/spinlock.h>
 #include <asm/bootinfo.h>
diff -puN arch/mips/gt64120/wrppmc/setup.c~serial-add-back-early_serial_setup-back-to-head-file arch/mips/gt64120/wrppmc/setup.c
--- a/arch/mips/gt64120/wrppmc/setup.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/mips/gt64120/wrppmc/setup.c
@@ -14,6 +14,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/pm.h>
 
 #include <asm/io.h>
diff -puN arch/mips/mips-boards/atlas/atlas_setup.c~serial-add-back-early_serial_setup-back-to-head-file arch/mips/mips-boards/atlas/atlas_setup.c
--- a/arch/mips/mips-boards/atlas/atlas_setup.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/mips/mips-boards/atlas/atlas_setup.c
@@ -22,6 +22,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/cpu.h>
 #include <asm/bootinfo.h>
diff -puN arch/mips/mips-boards/sead/sead_setup.c~serial-add-back-early_serial_setup-back-to-head-file arch/mips/mips-boards/sead/sead_setup.c
--- a/arch/mips/mips-boards/sead/sead_setup.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/mips/mips-boards/sead/sead_setup.c
@@ -23,6 +23,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/cpu.h>
 #include <asm/bootinfo.h>
diff -puN arch/mips/mipssim/sim_setup.c~serial-add-back-early_serial_setup-back-to-head-file arch/mips/mipssim/sim_setup.c
--- a/arch/mips/mipssim/sim_setup.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/mips/mipssim/sim_setup.c
@@ -26,6 +26,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/cpu.h>
 #include <asm/bootinfo.h>
diff -puN arch/mips/pmc-sierra/msp71xx/msp_serial.c~serial-add-back-early_serial_setup-back-to-head-file arch/mips/pmc-sierra/msp71xx/msp_serial.c
--- a/arch/mips/pmc-sierra/msp71xx/msp_serial.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/mips/pmc-sierra/msp71xx/msp_serial.c
@@ -32,6 +32,7 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/serial.h>
+#include <linux/serial_8250.h>
 
 #include <msp_prom.h>
 #include <msp_int.h>
diff -puN arch/mips/pmc-sierra/yosemite/setup.c~serial-add-back-early_serial_setup-back-to-head-file arch/mips/pmc-sierra/yosemite/setup.c
--- a/arch/mips/pmc-sierra/yosemite/setup.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/mips/pmc-sierra/yosemite/setup.c
@@ -39,6 +39,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/time.h>
 #include <asm/bootinfo.h>
diff -puN arch/ppc/platforms/4xx/bamboo.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/4xx/bamboo.c
--- a/arch/ppc/platforms/4xx/bamboo.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/4xx/bamboo.c
@@ -29,6 +29,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/ethtool.h>
 
 #include <asm/system.h>
diff -puN arch/ppc/platforms/4xx/bubinga.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/4xx/bubinga.c
--- a/arch/ppc/platforms/4xx/bubinga.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/4xx/bubinga.c
@@ -21,6 +21,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/system.h>
 #include <asm/pci-bridge.h>
diff -puN arch/ppc/platforms/4xx/cpci405.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/4xx/cpci405.c
--- a/arch/ppc/platforms/4xx/cpci405.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/4xx/cpci405.c
@@ -23,6 +23,7 @@
 #include <asm/todc.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <asm/ocp.h>
 #include <asm/ibm_ocp_pci.h>
 #include <platforms/4xx/ibm405gp.h>
diff -puN arch/ppc/platforms/4xx/ebony.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/4xx/ebony.c
--- a/arch/ppc/platforms/4xx/ebony.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/4xx/ebony.c
@@ -32,6 +32,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff -puN arch/ppc/platforms/4xx/luan.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/4xx/luan.c
--- a/arch/ppc/platforms/4xx/luan.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/4xx/luan.c
@@ -30,6 +30,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff -puN arch/ppc/platforms/4xx/ocotea.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/4xx/ocotea.c
--- a/arch/ppc/platforms/4xx/ocotea.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/4xx/ocotea.c
@@ -30,6 +30,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff -puN arch/ppc/platforms/4xx/taishan.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/4xx/taishan.c
--- a/arch/ppc/platforms/4xx/taishan.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/4xx/taishan.c
@@ -30,6 +30,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/platform_device.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/nand.h>
diff -puN arch/ppc/platforms/4xx/yucca.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/4xx/yucca.c
--- a/arch/ppc/platforms/4xx/yucca.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/4xx/yucca.c
@@ -31,6 +31,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff -puN arch/ppc/platforms/85xx/sbc8560.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/85xx/sbc8560.c
--- a/arch/ppc/platforms/85xx/sbc8560.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/85xx/sbc8560.c
@@ -26,6 +26,7 @@
 #include <linux/serial.h>
 #include <linux/tty.h>	/* for linux/serial_core.h */
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/initrd.h>
 #include <linux/module.h>
 #include <linux/fsl_devices.h>
diff -puN arch/ppc/platforms/chestnut.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/chestnut.c
--- a/arch/ppc/platforms/chestnut.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/chestnut.c
@@ -25,6 +25,7 @@
 #include <linux/ide.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/mtd/physmap.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff -puN arch/ppc/platforms/ev64260.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/ev64260.c
--- a/arch/ppc/platforms/ev64260.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/ev64260.c
@@ -35,6 +35,7 @@
 #include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #else
 #include <linux/mv643xx.h>
 #endif
diff -puN arch/ppc/platforms/radstone_ppc7d.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/radstone_ppc7d.c
--- a/arch/ppc/platforms/radstone_ppc7d.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/radstone_ppc7d.c
@@ -35,6 +35,7 @@
 #include <linux/serial.h>
 #include <linux/tty.h>		/* for linux/serial_core.h */
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/mv643xx.h>
 #include <linux/netdevice.h>
 #include <linux/platform_device.h>
diff -puN arch/ppc/platforms/spruce.c~serial-add-back-early_serial_setup-back-to-head-file arch/ppc/platforms/spruce.c
--- a/arch/ppc/platforms/spruce.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/arch/ppc/platforms/spruce.c
@@ -27,6 +27,7 @@
 #include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff -puN drivers/parisc/superio.c~serial-add-back-early_serial_setup-back-to-head-file drivers/parisc/superio.c
--- a/drivers/parisc/superio.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/drivers/parisc/superio.c
@@ -73,6 +73,7 @@
 #include <linux/termios.h>
 #include <linux/tty.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/delay.h>
 
 #include <asm/io.h>
diff -puN drivers/serial/8250_hp300.c~serial-add-back-early_serial_setup-back-to-head-file drivers/serial/8250_hp300.c
--- a/drivers/serial/8250_hp300.c~serial-add-back-early_serial_setup-back-to-head-file
+++ a/drivers/serial/8250_hp300.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/delay.h>
 #include <linux/dio.h>
 #include <linux/console.h>
diff -puN include/linux/serial_8250.h~serial-add-back-early_serial_setup-back-to-head-file include/linux/serial_8250.h
--- a/include/linux/serial_8250.h~serial-add-back-early_serial_setup-back-to-head-file
+++ a/include/linux/serial_8250.h
@@ -60,6 +60,8 @@ void serial8250_unregister_port(int line
 void serial8250_suspend_port(int line);
 void serial8250_resume_port(int line);
 
+extern int early_serial_setup(struct uart_port *port);
+
 extern int serial8250_find_port(struct uart_port *p);
 extern int serial8250_find_port_for_earlycon(void);
 extern int setup_early_serial8250_console(char *cmdline);
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
x86_64-get-mp_bus_to_node-as-early.patch
