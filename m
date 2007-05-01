From: akpm@linux-foundation.org
Subject: + serial-serial_core-use-pr_debug.patch added to -mm tree
Date: Tue, 01 May 2007 15:36:39 -0700
Message-ID: <200705012236.l41MadeG008298@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638AbXEAWg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 18:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, rmk@arm.linux.org.uk


The patch titled
     Serial: serial_core, use pr_debug
has been added to the -mm tree.  Its filename is
     serial-serial_core-use-pr_debug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Serial: serial_core, use pr_debug
From: Jiri Slaby <jirislaby@gmail.com>

serial_core, use pr_debug

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff -puN drivers/serial/serial_core.c~serial-serial_core-use-pr_debug drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-serial_core-use-pr_debug
+++ a/drivers/serial/serial_core.c
@@ -37,13 +37,6 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
-#undef	DEBUG
-#ifdef DEBUG
-#define DPRINTK(x...)	printk(x)
-#else
-#define DPRINTK(x...)	do { } while (0)
-#endif
-
 /*
  * This is used to lock changes in serial line configuration.
  */
@@ -560,7 +553,7 @@ static void uart_flush_buffer(struct tty
 		return;
 	}
 
-	DPRINTK("uart_flush_buffer(%d) called\n", tty->index);
+	pr_debug("uart_flush_buffer(%d) called\n", tty->index);
 
 	spin_lock_irqsave(&port->lock, flags);
 	uart_circ_clear(&state->info->xmit);
@@ -1234,7 +1227,7 @@ static void uart_close(struct tty_struct
 
 	port = state->port;
 
-	DPRINTK("uart_close(%d) called\n", port->line);
+	pr_debug("uart_close(%d) called\n", port->line);
 
 	mutex_lock(&state->mutex);
 
@@ -1353,7 +1346,7 @@ static void uart_wait_until_sent(struct 
 
 	expire = jiffies + timeout;
 
-	DPRINTK("uart_wait_until_sent(%d), jiffies=%lu, expire=%lu...\n",
+	pr_debug("uart_wait_until_sent(%d), jiffies=%lu, expire=%lu...\n",
 	        port->line, jiffies, expire);
 
 	/*
@@ -1382,7 +1375,7 @@ static void uart_hangup(struct tty_struc
 	struct uart_state *state = tty->driver_data;
 
 	BUG_ON(!kernel_locked());
-	DPRINTK("uart_hangup(%d)\n", state->port->line);
+	pr_debug("uart_hangup(%d)\n", state->port->line);
 
 	mutex_lock(&state->mutex);
 	if (state->info && state->info->flags & UIF_NORMAL_ACTIVE) {
@@ -1584,7 +1577,7 @@ static int uart_open(struct tty_struct *
 	int retval, line = tty->index;
 
 	BUG_ON(!kernel_locked());
-	DPRINTK("uart_open(%d) called\n", line);
+	pr_debug("uart_open(%d) called\n", line);
 
 	/*
 	 * tty->driver->num won't change, so we won't fail here with
_

Patches currently in -mm which might be from jirislaby@gmail.com are

input-ff-add-ff_raw-effect.patch
input-phantom-add-a-new-driver.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
char-mxser-schedule-for-removal.patch
char-isicom-use-pr_debug.patch
serial-serial_core-use-pr_debug.patch
shrink_slab-handle-bad-shrinkers.patch
