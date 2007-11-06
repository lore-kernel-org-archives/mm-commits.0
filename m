From: akpm@linux-foundation.org
Subject: - serial-fix-compile-warning-about-putc.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:00 -0800
Message-ID: <200711060552.lA65q0Yq007148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbXKFFwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:52:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     serial: fix compile warning about putc
has been removed from the -mm tree.  Its filename was
     serial-fix-compile-warning-about-putc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial: fix compile warning about putc
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

drivers/serial/8250_early.c:80: warning: conflicting types for built-in function `putc'

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_early.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250_early.c~serial-fix-compile-warning-about-putc drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~serial-fix-compile-warning-about-putc
+++ a/drivers/serial/8250_early.c
@@ -76,7 +76,7 @@ static void __init wait_for_xmitr(struct
 	}
 }
 
-static void __init putc(struct uart_port *port, int c)
+static void __init serial_putc(struct uart_port *port, int c)
 {
 	wait_for_xmitr(port);
 	serial_out(port, UART_TX, c);
@@ -91,7 +91,7 @@ static void __init early_serial8250_writ
 	ier = serial_in(port, UART_IER);
 	serial_out(port, UART_IER, 0);
 
-	uart_console_write(port, s, count, putc);
+	uart_console_write(port, s, count, serial_putc);
 
 	/* Wait for transmitter to become empty and restore the IER */
 	wait_for_xmitr(port);
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
x86_64-do-not-clear-cpu_index-set-by-store_cpu_info.patch
x86-typo-about-sequence-of-cpu_index-and-cpu_online-in.patch
x86-check-boundary-in-count-setup_resource-called-by.patch
kernel-printkc-concerns-about-the-console-handover.patch
