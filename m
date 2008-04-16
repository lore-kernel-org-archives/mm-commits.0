From: akpm@linux-foundation.org
Subject: - serial-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:54:55 -0700
Message-ID: <200804162254.m3GMsttU011066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758868AbYDPXB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 19:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, jacmet@sunsite.dk, mm-commits@vger.kernel.org


The patch titled
     serial: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     serial-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: serial: fix platform driver hotplug/coldplug
=46rom: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias i=
s
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable seri=
al
platform drivers, to re-enable auto loading.

NOTE that Kconfig for some of these drivers doesn't allow modular build=
s, and
thus doesn't match the driver source's unload support.  Presumably thei=
r
unload code is buggy and/or weakly tested...

[dbrownell@users.sourceforge.net: more drivers, registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    1 +
 drivers/serial/bfin_5xx.c     |    2 ++
 drivers/serial/imx.c          |    2 ++
 drivers/serial/mcf.c          |    1 +
 drivers/serial/mpc52xx_uart.c |    2 ++
 drivers/serial/mpsc.c         |    2 ++
 drivers/serial/netx-serial.c  |    2 ++
 drivers/serial/pnx8xxx_uart.c |    1 +
 drivers/serial/pxa.c          |    3 ++-
 drivers/serial/s3c2410.c      |    4 ++++
 drivers/serial/sa1100.c       |    2 ++
 drivers/serial/sc26xx.c       |    2 ++
 drivers/serial/sh-sci.c       |    1 +
 drivers/serial/uartlite.c     |    3 +++
 drivers/serial/vr41xx_siu.c   |    3 +++
 15 files changed, 30 insertions(+), 1 deletion(-)

diff -puN drivers/serial/atmel_serial.c~serial-fix-platform-driver-hotp=
lug-coldplug drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~serial-fix-platform-driver-hotplug-=
coldplug
+++ a/drivers/serial/atmel_serial.c
@@ -1577,3 +1577,4 @@ module_exit(atmel_serial_exit);
 MODULE_AUTHOR("Rick Bronson");
 MODULE_DESCRIPTION("Atmel AT91 / AT32 serial port driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:atmel_usart");
diff -puN drivers/serial/bfin_5xx.c~serial-fix-platform-driver-hotplug-=
coldplug drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~serial-fix-platform-driver-hotplug-cold=
plug
+++ a/drivers/serial/bfin_5xx.c
@@ -1243,6 +1243,7 @@ static struct platform_driver bfin_seria
 	.resume		=3D bfin_serial_resume,
 	.driver		=3D {
 		.name	=3D "bfin-uart",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -1301,3 +1302,4 @@ MODULE_AUTHOR("Aubrey.Li <aubrey.li@anal
 MODULE_DESCRIPTION("Blackfin generic serial port driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(BFIN_SERIAL_MAJOR);
+MODULE_ALIAS("platform:bfin-uart");
diff -puN drivers/serial/imx.c~serial-fix-platform-driver-hotplug-coldp=
lug drivers/serial/imx.c
--- a/drivers/serial/imx.c~serial-fix-platform-driver-hotplug-coldplug
+++ a/drivers/serial/imx.c
@@ -1090,6 +1090,7 @@ static struct platform_driver serial_imx
 	.resume		=3D serial_imx_resume,
 	.driver		=3D {
 	        .name	=3D "imx-uart",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -1124,3 +1125,4 @@ module_exit(imx_serial_exit);
 MODULE_AUTHOR("Sascha Hauer");
 MODULE_DESCRIPTION("IMX generic serial port driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:imx-uart");
diff -puN drivers/serial/mcf.c~serial-fix-platform-driver-hotplug-coldp=
lug drivers/serial/mcf.c
--- a/drivers/serial/mcf.c~serial-fix-platform-driver-hotplug-coldplug
+++ a/drivers/serial/mcf.c
@@ -649,5 +649,6 @@ module_exit(mcf_exit);
 MODULE_AUTHOR("Greg Ungerer <gerg@snapgear.com>");
 MODULE_DESCRIPTION("Freescale ColdFire UART driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:mcfuart");
=20
 /*********************************************************************=
*******/
diff -puN drivers/serial/mpc52xx_uart.c~serial-fix-platform-driver-hotp=
lug-coldplug drivers/serial/mpc52xx_uart.c
--- a/drivers/serial/mpc52xx_uart.c~serial-fix-platform-driver-hotplug-=
coldplug
+++ a/drivers/serial/mpc52xx_uart.c
@@ -1188,6 +1188,8 @@ mpc52xx_uart_resume(struct platform_devi
 }
 #endif
=20
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:mpc52xx-psc");
=20
 static struct platform_driver mpc52xx_uart_platform_driver =3D {
 	.probe		=3D mpc52xx_uart_probe,
diff -puN drivers/serial/mpsc.c~serial-fix-platform-driver-hotplug-cold=
plug drivers/serial/mpsc.c
--- a/drivers/serial/mpsc.c~serial-fix-platform-driver-hotplug-coldplug
+++ a/drivers/serial/mpsc.c
@@ -1964,6 +1964,7 @@ static struct platform_driver mpsc_drive
 	.remove	=3D mpsc_drv_remove,
 	.driver	=3D {
 		.name	=3D MPSC_CTLR_NAME,
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -2007,3 +2008,4 @@ MODULE_DESCRIPTION("Generic Marvell MPSC
 MODULE_VERSION(MPSC_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(MPSC_MAJOR);
+MODULE_ALIAS("platform:" MPSC_CTLR_NAME);
diff -puN drivers/serial/netx-serial.c~serial-fix-platform-driver-hotpl=
ug-coldplug drivers/serial/netx-serial.c
--- a/drivers/serial/netx-serial.c~serial-fix-platform-driver-hotplug-c=
oldplug
+++ a/drivers/serial/netx-serial.c
@@ -713,6 +713,7 @@ static struct platform_driver serial_net
=20
 	.driver		=3D {
 		.name   =3D DRIVER_NAME,
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -745,3 +746,4 @@ module_exit(netx_serial_exit);
 MODULE_AUTHOR("Sascha Hauer");
 MODULE_DESCRIPTION("NetX serial port driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff -puN drivers/serial/pnx8xxx_uart.c~serial-fix-platform-driver-hotp=
lug-coldplug drivers/serial/pnx8xxx_uart.c
--- a/drivers/serial/pnx8xxx_uart.c~serial-fix-platform-driver-hotplug-=
coldplug
+++ a/drivers/serial/pnx8xxx_uart.c
@@ -850,3 +850,4 @@ MODULE_AUTHOR("Embedded Alley Solutions,
 MODULE_DESCRIPTION("PNX8XXX SoCs serial port driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SERIAL_PNX8XXX_MAJOR);
+MODULE_ALIAS("platform:pnx8xxx-uart");
diff -puN drivers/serial/pxa.c~serial-fix-platform-driver-hotplug-coldp=
lug drivers/serial/pxa.c
--- a/drivers/serial/pxa.c~serial-fix-platform-driver-hotplug-coldplug
+++ a/drivers/serial/pxa.c
@@ -833,6 +833,7 @@ static struct platform_driver serial_pxa
 	.resume		=3D serial_pxa_resume,
 	.driver		=3D {
 	        .name	=3D "pxa2xx-uart",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -861,4 +862,4 @@ module_init(serial_pxa_init);
 module_exit(serial_pxa_exit);
=20
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS("platform:pxa2xx-uart");
diff -puN drivers/serial/s3c2410.c~serial-fix-platform-driver-hotplug-c=
oldplug drivers/serial/s3c2410.c
--- a/drivers/serial/s3c2410.c~serial-fix-platform-driver-hotplug-coldp=
lug
+++ a/drivers/serial/s3c2410.c
@@ -1935,3 +1935,7 @@ console_initcall(s3c24xx_serial_initcons
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("Samsung S3C2410/S3C2440/S3C2412 Serial port driver=
");
+MODULE_ALIAS("platform:s3c2400-uart");
+MODULE_ALIAS("platform:s3c2410-uart");
+MODULE_ALIAS("platform:s3c2412-uart");
+MODULE_ALIAS("platform:s3c2440-uart");
diff -puN drivers/serial/sa1100.c~serial-fix-platform-driver-hotplug-co=
ldplug drivers/serial/sa1100.c
--- a/drivers/serial/sa1100.c~serial-fix-platform-driver-hotplug-coldpl=
ug
+++ a/drivers/serial/sa1100.c
@@ -884,6 +884,7 @@ static struct platform_driver sa11x0_ser
 	.resume		=3D sa1100_serial_resume,
 	.driver		=3D {
 		.name	=3D "sa11x0-uart",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -917,3 +918,4 @@ MODULE_AUTHOR("Deep Blue Solutions Ltd")
 MODULE_DESCRIPTION("SA1100 generic serial port driver $Revision: 1.50 =
$");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SERIAL_SA1100_MAJOR);
+MODULE_ALIAS("platform:sa11x0-uart");
diff -puN drivers/serial/sc26xx.c~serial-fix-platform-driver-hotplug-co=
ldplug drivers/serial/sc26xx.c
--- a/drivers/serial/sc26xx.c~serial-fix-platform-driver-hotplug-coldpl=
ug
+++ a/drivers/serial/sc26xx.c
@@ -732,6 +732,7 @@ static struct platform_driver sc26xx_dri
 	.remove	=3D __devexit_p(sc26xx_driver_remove),
 	.driver	=3D {
 		.name	=3D "SC26xx",
+		.owner	=3D THIS_MODULE,
 	},
 };
=20
@@ -753,3 +754,4 @@ MODULE_AUTHOR("Thomas Bogend=C3=B6rfer");
 MODULE_DESCRIPTION("SC681/SC2692 serial driver");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:SC26xx");
diff -puN drivers/serial/sh-sci.c~serial-fix-platform-driver-hotplug-co=
ldplug drivers/serial/sh-sci.c
--- a/drivers/serial/sh-sci.c~serial-fix-platform-driver-hotplug-coldpl=
ug
+++ a/drivers/serial/sh-sci.c
@@ -1552,3 +1552,4 @@ module_init(sci_init);
 module_exit(sci_exit);
=20
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:sh-sci");
diff -puN drivers/serial/uartlite.c~serial-fix-platform-driver-hotplug-=
coldplug drivers/serial/uartlite.c
--- a/drivers/serial/uartlite.c~serial-fix-platform-driver-hotplug-cold=
plug
+++ a/drivers/serial/uartlite.c
@@ -561,6 +561,9 @@ static int __devexit ulite_remove(struct
 	return ulite_release(&pdev->dev);
 }
=20
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:uartlite");
+
 static struct platform_driver ulite_platform_driver =3D {
 	.probe	=3D ulite_probe,
 	.remove	=3D __devexit_p(ulite_remove),
diff -puN drivers/serial/vr41xx_siu.c~serial-fix-platform-driver-hotplu=
g-coldplug drivers/serial/vr41xx_siu.c
--- a/drivers/serial/vr41xx_siu.c~serial-fix-platform-driver-hotplug-co=
ldplug
+++ a/drivers/serial/vr41xx_siu.c
@@ -960,3 +960,6 @@ static void __exit vr41xx_siu_exit(void)
=20
 module_init(vr41xx_siu_init);
 module_exit(vr41xx_siu_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:SIU");
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch
git-alsa-tiwai.patch
macintosh-windfarm-fix-platform-driver-hotplug-coldplug.patch
input-fix-platform-driver-hotplug-coldplug.patch
ata-ide-fix-platform-driver-hotplug-coldplug.patch
mtd-maps-fix-platform-driver-hotplug-coldplug.patch
mtd-nand-fix-platform-driver-hotplug-coldplug.patch
net-drivers-fix-platform-driver-hotplug-coldplug.patch
scsi-fix-platform-driver-hotplug-coldplug.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
