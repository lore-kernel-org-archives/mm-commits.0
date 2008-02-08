From: akpm@linux-foundation.org
Subject: - atmel_serial-show-tty-name-in-proc-interrupts.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:47 -0800
Message-ID: <200802082018.m18KISLR010929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39649 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550AbYBHUzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:55:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, linux@maxim.org.za, marc.pignat@hevs.ch, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: show tty name in /proc/interrupts
has been removed from the -mm tree.  Its filename was
     atmel_serial-show-tty-name-in-proc-interrupts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: show tty name in /proc/interrupts
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

When possible, pass the tty name to request_irq() so that the user can easily
distinguish the different serial ports in /proc/interrupts.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Tested-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-show-tty-name-in-proc-interrupts drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-show-tty-name-in-proc-interrupts
+++ a/drivers/serial/atmel_serial.c
@@ -793,6 +793,7 @@ static void atmel_tasklet_func(unsigned 
 static int atmel_startup(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+	struct tty_struct *tty = port->info->tty;
 	int retval;
 
 	/*
@@ -806,7 +807,7 @@ static int atmel_startup(struct uart_por
 	 * Allocate the IRQ
 	 */
 	retval = request_irq(port->irq, atmel_interrupt, IRQF_SHARED,
-			"atmel_serial", port);
+			tty ? tty->name : "atmel_serial", port);
 	if (retval) {
 		printk("atmel_serial: atmel_startup - Can't get irq\n");
 		return retval;
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
