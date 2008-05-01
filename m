From: akpm@linux-foundation.org
Subject: - serial-switch-the-serial-core-to-int-put_char-methods.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:40 -0700
Message-ID: <200805010930.m419Ue1g030791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbYEAJbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: switch the serial core to int put_char methods
has been removed from the -mm tree.  Its filename was
     serial-switch-the-serial-core-to-int-put_char-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: switch the serial core to int put_char methods
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/serial/serial_core.c~serial-switch-the-serial-core-to-int-put_char-methods drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-switch-the-serial-core-to-int-put_char-methods
+++ a/drivers/serial/serial_core.c
@@ -422,6 +422,7 @@ uart_get_divisor(struct uart_port *port,
 
 EXPORT_SYMBOL(uart_get_divisor);
 
+/* FIXME: Consistent locking policy */
 static void
 uart_change_speed(struct uart_state *state, struct ktermios *old_termios)
 {
@@ -454,27 +455,30 @@ uart_change_speed(struct uart_state *sta
 	port->ops->set_termios(port, termios, old_termios);
 }
 
-static inline void
+static inline int
 __uart_put_char(struct uart_port *port, struct circ_buf *circ, unsigned char c)
 {
 	unsigned long flags;
+	int ret = 0;
 
 	if (!circ->buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&port->lock, flags);
 	if (uart_circ_chars_free(circ) != 0) {
 		circ->buf[circ->head] = c;
 		circ->head = (circ->head + 1) & (UART_XMIT_SIZE - 1);
+		ret = 1;
 	}
 	spin_unlock_irqrestore(&port->lock, flags);
+	return ret;
 }
 
-static void uart_put_char(struct tty_struct *tty, unsigned char ch)
+static int uart_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct uart_state *state = tty->driver_data;
 
-	__uart_put_char(state->port, &state->info->xmit, ch);
+	return __uart_put_char(state->port, &state->info->xmit, ch);
 }
 
 static void uart_flush_chars(struct tty_struct *tty)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

