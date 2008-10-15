From: akpm@linux-foundation.org
Subject: - serial-allow-8250-to-be-used-on-sparc.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:13:51 -0700
Message-ID: <200810152113.m9FLDpxS005631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753AbYJOV0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:26:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, alan@lxorguk.ukuu.org.uk, joy@entuzijast.net, mm-commits@vger.kernel.org


The patch titled
     serial: allow 8250 to be used on sparc
has been removed from the -mm tree.  Its filename was
     serial-allow-8250-to-be-used-on-sparc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: allow 8250 to be used on sparc
From: David Miller <davem@davemloft.net>

This requires three changes:

1) Remove !SPARC restriction in Kconfig.

2) Move Sparc specific serial drivers before 8250, so that serial
   console devices don't change names on us, even if 8250 finds
   devices.

3) Since the Sparc specific serial drivers try to use the
   same major/minor device namespace as 8250, some coordination
   is necessary.  Use the sunserial_*() layer routines to allocate
   minor number space within TTY_MAJOR when CONFIG_SPARC.

   This has no effect on other platforms.

Thanks to Josip Rodin for bringing up this issue and testing
plus debugging various revisions of this patch.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Josip Rodin <joy@entuzijast.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/serial.h |    6 ++++++
 drivers/serial/8250.c           |   18 +++++++++++++++++-
 drivers/serial/Kconfig          |    1 -
 drivers/serial/Makefile         |   15 ++++++++++-----
 4 files changed, 33 insertions(+), 7 deletions(-)

diff -puN /dev/null arch/sparc/include/asm/serial.h
--- /dev/null
+++ a/arch/sparc/include/asm/serial.h
@@ -0,0 +1,6 @@
+#ifndef __SPARC_SERIAL_H
+#define __SPARC_SERIAL_H
+
+#define BASE_BAUD ( 1843200 / 16 )
+
+#endif /* __SPARC_SERIAL_H */
diff -puN drivers/serial/8250.c~serial-allow-8250-to-be-used-on-sparc drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-allow-8250-to-be-used-on-sparc
+++ a/drivers/serial/8250.c
@@ -44,6 +44,10 @@
 
 #include "8250.h"
 
+#ifdef CONFIG_SPARC
+#include "suncore.h"
+#endif
+
 /*
  * Configuration:
  *   share_irqs - whether we pass IRQF_SHARED to request_irq().  This option
@@ -2728,7 +2732,6 @@ static struct uart_driver serial8250_reg
 	.dev_name		= "ttyS",
 	.major			= TTY_MAJOR,
 	.minor			= 64,
-	.nr			= UART_NR,
 	.cons			= SERIAL8250_CONSOLE,
 };
 
@@ -3010,7 +3013,12 @@ static int __init serial8250_init(void)
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
+#ifdef CONFIG_SPARC
+	ret = sunserial_register_minors(&serial8250_reg, UART_NR);
+#else
+	serial8250_reg.nr = UART_NR;
 	ret = uart_register_driver(&serial8250_reg);
+#endif
 	if (ret)
 		goto out;
 
@@ -3035,7 +3043,11 @@ static int __init serial8250_init(void)
 put_dev:
 	platform_device_put(serial8250_isa_devs);
 unreg_uart_drv:
+#ifdef CONFIG_SPARC
+	sunserial_unregister_minors(&serial8250_reg, UART_NR);
+#else
 	uart_unregister_driver(&serial8250_reg);
+#endif
 out:
 	return ret;
 }
@@ -3054,7 +3066,11 @@ static void __exit serial8250_exit(void)
 	platform_driver_unregister(&serial8250_isa_driver);
 	platform_device_unregister(isa_dev);
 
+#ifdef CONFIG_SPARC
+	sunserial_unregister_minors(&serial8250_reg, UART_NR);
+#else
 	uart_unregister_driver(&serial8250_reg);
+#endif
 }
 
 module_init(serial8250_init);
diff -puN drivers/serial/Kconfig~serial-allow-8250-to-be-used-on-sparc drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-allow-8250-to-be-used-on-sparc
+++ a/drivers/serial/Kconfig
@@ -9,7 +9,6 @@ menu "Serial drivers"
 # The new 8250/16550 serial drivers
 config SERIAL_8250
 	tristate "8250/16550 and compatible serial support"
-	depends on (BROKEN || !SPARC)
 	select SERIAL_CORE
 	---help---
 	  This selects whether you want to include the driver for the standard
diff -puN drivers/serial/Makefile~serial-allow-8250-to-be-used-on-sparc drivers/serial/Makefile
--- a/drivers/serial/Makefile~serial-allow-8250-to-be-used-on-sparc
+++ a/drivers/serial/Makefile
@@ -4,6 +4,16 @@
 
 obj-$(CONFIG_SERIAL_CORE) += serial_core.o
 obj-$(CONFIG_SERIAL_21285) += 21285.o
+
+# These Sparc drivers have to appear before others such as 8250
+# which share ttySx minor node space.  Otherwise console device
+# names change and other unplesantries.
+obj-$(CONFIG_SERIAL_SUNCORE) += suncore.o
+obj-$(CONFIG_SERIAL_SUNHV) += sunhv.o
+obj-$(CONFIG_SERIAL_SUNZILOG) += sunzilog.o
+obj-$(CONFIG_SERIAL_SUNSU) += sunsu.o
+obj-$(CONFIG_SERIAL_SUNSAB) += sunsab.o
+
 obj-$(CONFIG_SERIAL_8250) += 8250.o
 obj-$(CONFIG_SERIAL_8250_PNP) += 8250_pnp.o
 obj-$(CONFIG_SERIAL_8250_GSC) += 8250_gsc.o
@@ -31,12 +41,7 @@ obj-$(CONFIG_SERIAL_S3C2400) += s3c2400.
 obj-$(CONFIG_SERIAL_S3C2410) += s3c2410.o
 obj-$(CONFIG_SERIAL_S3C2412) += s3c2412.o
 obj-$(CONFIG_SERIAL_S3C2440) += s3c2440.o
-obj-$(CONFIG_SERIAL_SUNCORE) += suncore.o
-obj-$(CONFIG_SERIAL_SUNHV) += sunhv.o
-obj-$(CONFIG_SERIAL_SUNZILOG) += sunzilog.o
 obj-$(CONFIG_SERIAL_IP22_ZILOG) += ip22zilog.o
-obj-$(CONFIG_SERIAL_SUNSU) += sunsu.o
-obj-$(CONFIG_SERIAL_SUNSAB) += sunsab.o
 obj-$(CONFIG_SERIAL_MUX) += mux.o
 obj-$(CONFIG_SERIAL_68328) += 68328serial.o
 obj-$(CONFIG_SERIAL_68360) += 68360serial.o
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
compat-generic-compat-get-settimeofday.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
sparc64-use-iommu_num_pages-function-in-iommu-code.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
radeonfb-misc-cleanup-of-engine-and-dst-cache-handling.patch
radeonfb-accelerate-imageblit-and-other-improvements.patch
sysctl-simplify-strategy.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

