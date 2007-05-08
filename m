From: akpm@linux-foundation.org
Subject: - serial-serial_core-use-pr_debug.patch removed from -mm tree
Date: Mon, 07 May 2007 17:01:38 -0700
Message-ID: <200705080001.l4801c46008784@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967313AbXEHABz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:01:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Serial: serial_core, use pr_debug
has been removed from the -mm tree.  Its filename was
     serial-serial_core-use-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Serial: serial_core, use pr_debug
From: Jiri Slaby <jirislaby@gmail.com>

serial_core, use pr_debug

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

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
@@ -552,7 +545,7 @@ static void uart_flush_buffer(struct tty
 		return;
 	}
 
-	DPRINTK("uart_flush_buffer(%d) called\n", tty->index);
+	pr_debug("uart_flush_buffer(%d) called\n", tty->index);
 
 	spin_lock_irqsave(&port->lock, flags);
 	uart_circ_clear(&state->info->xmit);
@@ -1224,7 +1217,7 @@ static void uart_close(struct tty_struct
 
 	port = state->port;
 
-	DPRINTK("uart_close(%d) called\n", port->line);
+	pr_debug("uart_close(%d) called\n", port->line);
 
 	mutex_lock(&state->mutex);
 
@@ -1343,7 +1336,7 @@ static void uart_wait_until_sent(struct 
 
 	expire = jiffies + timeout;
 
-	DPRINTK("uart_wait_until_sent(%d), jiffies=%lu, expire=%lu...\n",
+	pr_debug("uart_wait_until_sent(%d), jiffies=%lu, expire=%lu...\n",
 	        port->line, jiffies, expire);
 
 	/*
@@ -1372,7 +1365,7 @@ static void uart_hangup(struct tty_struc
 	struct uart_state *state = tty->driver_data;
 
 	BUG_ON(!kernel_locked());
-	DPRINTK("uart_hangup(%d)\n", state->port->line);
+	pr_debug("uart_hangup(%d)\n", state->port->line);
 
 	mutex_lock(&state->mutex);
 	if (state->info && state->info->flags & UIF_NORMAL_ACTIVE) {
@@ -1570,7 +1563,7 @@ static int uart_open(struct tty_struct *
 	int retval, line = tty->index;
 
 	BUG_ON(!kernel_locked());
-	DPRINTK("uart_open(%d) called\n", line);
+	pr_debug("uart_open(%d) called\n", line);
 
 	/*
 	 * tty->driver->num won't change, so we won't fail here with
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
misc-add-sensable-phantom-driver.patch
misc-add-sensable-phantom-driver-v3.patch
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
char-cyclades-use-is_cyc_z-macro.patch
char-cyclades-switch-to-pci-probing.patch
char-cyclades-depends-on-pci-or-isa.patch
char-cyclades-unexport-struct-cyclades_card.patch
char-cyclades-remove-useless-fileds-from-cyclades_card.patch
char-cyclades-irq-is-int.patch
char-cyclades-printk-cleanups.patch
char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch
char-cyclades-simplify-variables-initialization.patch
char-cyclades-get-rid-of-phys-addresses.patch
char-cyclades-make-info-card-a-pointer.patch
char-cyclades-remove-sleep_on.patch
char-cyclades-fix-blockmove.patch
char-cyclades-timers-cleanup.patch
char-cyclades-remove-unused-timestamps.patch
char-cyclades-remove-locking-macros.patch
char-cyclades-conditions-cleanup.patch
char-cyclades-conditions-cleanup-fix.patch
char-cyclades-fix-tty-device-unregister.patch
char-cyclades-dynamic-ports.patch
char-cyclades-probe-cleanup.patch
char-cyclades-probe-cleanup-fix.patch
char-cyclades-copyright-and-version-changes.patch
shrink_slab-handle-bad-shrinkers.patch
