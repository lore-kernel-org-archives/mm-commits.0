From: akpm@linux-foundation.org
Subject: + ne-mips-use-platform_driver-for-ne-on-rbtx49xx.patch added to -mm tree
Date: Sat, 28 Apr 2007 01:06:55 -0700
Message-ID: <200704280806.l3S86tKb017710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965536AbXD1IHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 04:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, jeff@garzik.org, ralf@linux-mips.org


The patch titled
     ne: MIPS: Use platform_driver for ne on RBTX49XX
has been added to the -mm tree.  Its filename is
     ne-mips-use-platform_driver-for-ne-on-rbtx49xx.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ne: MIPS: Use platform_driver for ne on RBTX49XX
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

This patch lets RBTX49XX boards use generic platform_driver interface for the
ne driver.

* Use platform_device to pass ioaddr and irq to the ne driver.
* Remove unnecessary ifdefs for RBTX49XX from the ne driver.
* Make the ne driver selectable on these boards regardless of CONFIG_ISA
* Add an ifdef for netcard_portlist[] to avoid unnecessary auto-probe.
  (I'm not sure M32R needs auto-probe but it is current behavior)

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c |   19 +++++++++
 arch/mips/tx4938/toshiba_rbtx4938/setup.c                  |   20 ++++++++++
 drivers/net/Kconfig                                        |    2 -
 drivers/net/ne.c                                           |   13 ++----
 4 files changed, 44 insertions(+), 10 deletions(-)

diff -puN arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c~ne-mips-use-platform_driver-for-ne-on-rbtx49xx arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
--- a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c~ne-mips-use-platform_driver-for-ne-on-rbtx49xx
+++ a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
@@ -1049,3 +1049,22 @@ static int __init toshiba_rbtx4927_rtc_i
 	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
 }
 device_initcall(toshiba_rbtx4927_rtc_init);
+
+static int __init rbtx4927_ne_init(void)
+{
+	struct resource res[] = {
+		{
+			.start	= RBTX4927_RTL_8019_BASE,
+			.end	= RBTX4927_RTL_8019_BASE + 0x20 - 1,
+			.flags	= IORESOURCE_IO,
+		}, {
+			.start	= RBTX4927_RTL_8019_IRQ,
+			.flags	= IORESOURCE_IRQ,
+		}
+	};
+	struct platform_device *dev =
+		platform_device_register_simple("ne", -1,
+						res, ARRAY_SIZE(res));
+	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+}
+device_initcall(rbtx4927_ne_init);
diff -puN arch/mips/tx4938/toshiba_rbtx4938/setup.c~ne-mips-use-platform_driver-for-ne-on-rbtx49xx arch/mips/tx4938/toshiba_rbtx4938/setup.c
--- a/arch/mips/tx4938/toshiba_rbtx4938/setup.c~ne-mips-use-platform_driver-for-ne-on-rbtx49xx
+++ a/arch/mips/tx4938/toshiba_rbtx4938/setup.c
@@ -20,6 +20,7 @@
 #include <linux/console.h>
 #include <linux/pci.h>
 #include <linux/pm.h>
+#include <linux/platform_device.h>
 
 #include <asm/wbflush.h>
 #include <asm/reboot.h>
@@ -1037,3 +1038,22 @@ static int __init tx4938_spi_proc_setup(
 
 __initcall(tx4938_spi_proc_setup);
 #endif
+
+static int __init rbtx4938_ne_init(void)
+{
+	struct resource res[] = {
+		{
+			.start	= RBTX4938_RTL_8019_BASE,
+			.end	= RBTX4938_RTL_8019_BASE + 0x20 - 1,
+			.flags	= IORESOURCE_IO,
+		}, {
+			.start	= RBTX4938_RTL_8019_IRQ,
+			.flags	= IORESOURCE_IRQ,
+		}
+	};
+	struct platform_device *dev =
+		platform_device_register_simple("ne", -1,
+						res, ARRAY_SIZE(res));
+	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+}
+device_initcall(rbtx4938_ne_init);
diff -puN drivers/net/Kconfig~ne-mips-use-platform_driver-for-ne-on-rbtx49xx drivers/net/Kconfig
--- a/drivers/net/Kconfig~ne-mips-use-platform_driver-for-ne-on-rbtx49xx
+++ a/drivers/net/Kconfig
@@ -1104,7 +1104,7 @@ config ETH16I
 
 config NE2000
 	tristate "NE2000/NE1000 support"
-	depends on NET_ISA || (Q40 && m) || M32R
+	depends on NET_ISA || (Q40 && m) || M32R || TOSHIBA_RBTX4927 || TOSHIBA_RBTX4938
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
diff -puN drivers/net/ne.c~ne-mips-use-platform_driver-for-ne-on-rbtx49xx drivers/net/ne.c
--- a/drivers/net/ne.c~ne-mips-use-platform_driver-for-ne-on-rbtx49xx
+++ a/drivers/net/ne.c
@@ -56,10 +56,6 @@ static const char version2[] =
 #include <asm/system.h>
 #include <asm/io.h>
 
-#if defined(CONFIG_TOSHIBA_RBTX4927) || defined(CONFIG_TOSHIBA_RBTX4938)
-#include <asm/tx4938/rbtx4938.h>
-#endif
-
 #include "8390.h"
 
 #define DRV_NAME "ne"
@@ -81,7 +77,10 @@ static const char version2[] =
 /* A zero-terminated list of I/O addresses to be probed at boot. */
 #ifndef MODULE
 static unsigned int netcard_portlist[] __initdata = {
-	0x300, 0x280, 0x320, 0x340, 0x360, 0x380, 0
+#if defined(CONFIG_ISA) || defined(CONFIG_M32R)
+	0x300, 0x280, 0x320, 0x340, 0x360, 0x380,
+#endif
+	0
 };
 #endif
 
@@ -227,10 +226,6 @@ struct net_device * __init ne_probe(int 
 	sprintf(dev->name, "eth%d", unit);
 	netdev_boot_setup_check(dev);
 
-#ifdef CONFIG_TOSHIBA_RBTX4938
-	dev->base_addr = RBTX4938_RTL_8019_BASE;
-	dev->irq = RBTX4938_RTL_8019_IRQ;
-#endif
 	err = do_ne_probe(dev);
 	if (err)
 		goto out;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-kbuild.patch
git-mips.patch
git-netdev-all.patch
ne-add-platform_driver.patch
ne-add-platform_driver-fix.patch
ne-mips-use-platform_driver-for-ne-on-rbtx49xx.patch
ne-mips-use-platform_driver-for-ne-on-rbtx49xx-fix.patch
mips-drop-unnecessary-config_isa-from-rbtx49xx.patch
serial_txx9-use-assigned-device-numbers.patch
serial_txx9-zap-changelog-from-source-code.patch
