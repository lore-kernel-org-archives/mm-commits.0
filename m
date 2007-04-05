From: akpm@linux-foundation.org
Subject: - serial-allocate-minor-device-numbers-for.patch removed from -mm tree
Date: Thu, 05 Apr 2007 13:13:34 -0700
Message-ID: <200704052013.l35KDYuO025021@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50496 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767282AbXDEURC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 16:17:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial: allocate minor device numbers for serial_txx9 driver
has been removed from the -mm tree.  Its filename was
     serial-allocate-minor-device-numbers-for.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: serial: allocate minor device numbers for serial_txx9 driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The serial_txx9 driver have abused device numbers (major 4, minor 128) if
CONFIG_SERIAL_TXX9_STDSERIAL was not set.  This patch makes the driver
allocate minor numbers from major 204 (Low-density serial ports).  I
suppose a typical user of this driver set CONFIG_SERIAL_TXX9_STDSERIAL to Y
(i.e.  use "ttyS0"), so this patch would not cause big compatibility issue.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devices.txt    |    3 +++
 drivers/serial/serial_txx9.c |    8 +++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN Documentation/devices.txt~serial-allocate-minor-device-numbers-for Documentation/devices.txt
--- a/Documentation/devices.txt~serial-allocate-minor-device-numbers-for
+++ a/Documentation/devices.txt
@@ -2808,6 +2808,9 @@ Your cooperation is appreciated.
 		    ...
 		 190 = /dev/ttyUL3		Xilinx uartlite - port 3
 		 191 = /dev/xvc0		Xen virtual console - port 0
+		 192 = /dev/ttyTX0		TX39/49 serial port 0
+		    ...
+		 199 = /dev/ttyTX7		TX39/49 serial port 7
 
 205 char	Low-density serial ports (alternate device)
 		  0 = /dev/culu0		Callout device for ttyLU0
diff -puN drivers/serial/serial_txx9.c~serial-allocate-minor-device-numbers-for drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial-allocate-minor-device-numbers-for
+++ a/drivers/serial/serial_txx9.c
@@ -40,6 +40,7 @@
  *	1.07	Use CONFIG_SERIAL_TXX9_NR_UARTS.  Cleanup.
  *	1.08	Use platform_device.
  *		Fix and cleanup suspend/resume/initialization codes.
+ *	1.09	Use major 204 if CONFIG_SERIAL_TXX9_STDSERIAL was not set.
  */
 
 #if defined(CONFIG_SERIAL_TXX9_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
@@ -62,7 +63,7 @@
 
 #include <asm/io.h>
 
-static char *serial_version = "1.08";
+static char *serial_version = "1.09";
 static char *serial_name = "TX39/49 Serial driver";
 
 #define PASS_LIMIT	256
@@ -70,13 +71,14 @@ static char *serial_name = "TX39/49 Seri
 #if !defined(CONFIG_SERIAL_TXX9_STDSERIAL)
 /* "ttyS" is used for standard serial driver */
 #define TXX9_TTY_NAME "ttyTX"
-#define TXX9_TTY_MINOR_START	(64 + 64)	/* ttyTX0(128), ttyTX1(129) */
+#define TXX9_TTY_MINOR_START	192
+#define TXX9_TTY_MAJOR	204
 #else
 /* acts like standard serial driver */
 #define TXX9_TTY_NAME "ttyS"
 #define TXX9_TTY_MINOR_START	64
-#endif
 #define TXX9_TTY_MAJOR	TTY_MAJOR
+#endif
 
 /* flag aliases */
 #define UPF_TXX9_HAVE_CTS_LINE	UPF_BUGGY_UART
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-kbuild.patch
git-mips.patch
git-netdev-all.patch
fix-irq-problem-with-napi-netpoll.patch
serial-allocate-minor-device-numbers-for.patch
