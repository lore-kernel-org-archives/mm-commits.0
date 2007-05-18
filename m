From: akpm@linux-foundation.org
Subject: - ns16550a-restore-hs-settings-in-excr2-on-resume.patch removed from -mm tree
Date: Fri, 18 May 2007 00:07:15 -0700
Message-ID: <200705180707.l4I77Efj010261@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33852 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754921AbXERHKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:10:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, alan@redhat.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     NS16550A: restore HS settings in EXCR2 on resume
has been removed from the -mm tree.  Its filename was
     ns16550a-restore-hs-settings-in-excr2-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NS16550A: restore HS settings in EXCR2 on resume
From: David Woodhouse <dwmw2@infradead.org>

After a suspend/resume cycle, the UART may have been reset into low-speed
mode -- either because it's actually been reset, or because the firmware
pokes at the old-style divisor registers.  If we detected it as a NS16550A
SuperIO chip in the first place and set baud_base to 921600, then we should
do so again in the resume path.

This patch adds that code to serial8250_resume_port(), and also makes
serial8250_resume() actually call serial8250_resume_port() for each port
instead of just calling uart_resume_port() directly.  And thus fixes serial
port operation after suspend/resume.

It also fixes a bogus comment where we write the EXCR2 register with a
comment saying /* EXCR1 */

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff -puN drivers/serial/8250.c~ns16550a-restore-hs-settings-in-excr2-on-resume drivers/serial/8250.c
--- a/drivers/serial/8250.c~ns16550a-restore-hs-settings-in-excr2-on-resume
+++ a/drivers/serial/8250.c
@@ -894,7 +894,7 @@ static void autoconfig_16550a(struct uar
 			quot = serial_dl_read(up);
 			quot <<= 3;
 
-			status1 = serial_in(up, 0x04); /* EXCR1 */
+			status1 = serial_in(up, 0x04); /* EXCR2 */
 			status1 &= ~0xB0; /* Disable LOCK, mask out PRESL[01] */
 			status1 |= 0x10;  /* 1.625 divisor for baud_base --> 921600 */
 			serial_outp(up, 0x04, status1);
@@ -2622,7 +2622,22 @@ void serial8250_suspend_port(int line)
  */
 void serial8250_resume_port(int line)
 {
-	uart_resume_port(&serial8250_reg, &serial8250_ports[line].port);
+	struct uart_8250_port *up = &serial8250_ports[line];
+
+	if (up->capabilities & UART_NATSEMI) {
+		unsigned char tmp;
+
+		/* Ensure it's still in high speed mode */
+		serial_outp(up, UART_LCR, 0xE0);
+
+		tmp = serial_in(up, 0x04); /* EXCR2 */
+		tmp &= ~0xB0; /* Disable LOCK, mask out PRESL[01] */
+		tmp |= 0x10;  /* 1.625 divisor for baud_base --> 921600 */
+		serial_outp(up, 0x04, tmp);
+
+		serial_outp(up, UART_LCR, 0);
+	}
+	uart_resume_port(&serial8250_reg, &up->port);
 }
 
 /*
@@ -2700,7 +2715,7 @@ static int serial8250_resume(struct plat
 		struct uart_8250_port *up = &serial8250_ports[i];
 
 		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev)
-			uart_resume_port(&serial8250_reg, &up->port);
+			serial8250_resume_port(i);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
git-ubi.patch
git-battery.patch
missing-const-from-reiserfs-min_key-declaration.patch
add-lzo1x-compression-support-to-the-kernel.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
mismatching-declarations-of-revision-strings-in-hisax.patch
