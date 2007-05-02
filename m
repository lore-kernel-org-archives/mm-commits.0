From: akpm@linux-foundation.org
Subject: - serial-suppress-rts-assertion-with-disabled-crtscts.patch removed from -mm tree
Date: Wed, 02 May 2007 15:10:30 -0700
Message-ID: <200705022210.l42MAVQH031339@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993191AbXEBWKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 18:10:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kebkal@gmail.com, alan@lxorguk.ukuu.org.uk, lesha@evologics.de, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: suppress RTS assertion with disabled CRTSCTS
has been removed from the -mm tree.  Its filename was
     serial-suppress-rts-assertion-with-disabled-crtscts.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: serial: suppress RTS assertion with disabled CRTSCTS
From: "Oleksiy Kebkal" <kebkal@gmail.com>

This patch leaves RTS alone when CRTSCTS is not set.

Current behaviour doesn't give any possibility to

1.  preconfigure port setting, because open operation implies RTS
   assertion and initial serial port setting may be wrong.

2.  realize peculiar serial flow control required by some hardware
   especially in embedded devices.

Signed-off-by: Oleksiy Kebkal <lesha@evologics.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   42 ++++++++++++++++++++++-----------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff -puN drivers/serial/serial_core.c~serial-suppress-rts-assertion-with-disabled-crtscts drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-suppress-rts-assertion-with-disabled-crtscts
+++ a/drivers/serial/serial_core.c
@@ -185,11 +185,15 @@ static int uart_startup(struct uart_stat
 			uart_change_speed(state, NULL);
 
 			/*
-			 * Setup the RTS and DTR signals once the
-			 * port is open and ready to respond.
+			 * Setup the RTS (in the case of hardware flow control)
+			 * and DTR signals once the port is open and ready to
+			 * respond.
 			 */
-			if (info->tty->termios->c_cflag & CBAUD)
-				uart_set_mctrl(port, TIOCM_RTS | TIOCM_DTR);
+			if (info->tty->termios->c_cflag & CBAUD) {
+				uart_set_mctrl(port, TIOCM_DTR);
+				if (info->flags & UIF_CTS_FLOW)
+					uart_set_mctrl(port, TIOCM_RTS);
+			}
 		}
 
 		if (info->flags & UIF_CTS_FLOW) {
@@ -230,10 +234,14 @@ static void uart_shutdown(struct uart_st
 		info->flags &= ~UIF_INITIALIZED;
 
 		/*
-		 * Turn off DTR and RTS early.
+		 * Turn off DTR and RTS (in the case of hardware flow control)
+		 * early.
 		 */
-		if (!info->tty || (info->tty->termios->c_cflag & HUPCL))
-			uart_clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
+		if (!info->tty || (info->tty->termios->c_cflag & HUPCL)) {
+			uart_clear_mctrl(port, TIOCM_DTR);
+			if (info->flags & UIF_CTS_FLOW)
+				uart_clear_mctrl(port, TIOCM_RTS);
+               }
 
 		/*
 		 * clear delta_msr_wait queue to avoid mem leaks: we may free
@@ -1164,14 +1172,16 @@ static void uart_set_termios(struct tty_
 	uart_change_speed(state, old_termios);
 
 	/* Handle transition to B0 status */
-	if ((old_termios->c_cflag & CBAUD) && !(cflag & CBAUD))
-		uart_clear_mctrl(state->port, TIOCM_RTS | TIOCM_DTR);
+	if ((old_termios->c_cflag & CBAUD) && !(cflag & CBAUD)) {
+		uart_clear_mctrl(state->port, TIOCM_DTR);
+		if (state->info->flags & UIF_CTS_FLOW)
+			uart_clear_mctrl(state->port, TIOCM_RTS);
+       }
 
 	/* Handle transition away from B0 status */
 	if (!(old_termios->c_cflag & CBAUD) && (cflag & CBAUD)) {
 		unsigned int mask = TIOCM_DTR;
-		if (!(cflag & CRTSCTS) ||
-		    !test_bit(TTY_THROTTLED, &tty->flags))
+		if (!test_bit(TTY_THROTTLED, &tty->flags))
 			mask |= TIOCM_RTS;
 		uart_set_mctrl(state->port, mask);
 	}
@@ -1415,10 +1425,14 @@ static void uart_update_termios(struct u
 		uart_change_speed(state, NULL);
 
 		/*
-		 * And finally enable the RTS and DTR signals.
+		 * And finally enable the RTS (in the of case hardware flow
+		 * control) and DTR signals.
 		 */
-		if (tty->termios->c_cflag & CBAUD)
-			uart_set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
+		if (tty->termios->c_cflag & CBAUD) {
+			uart_set_mctrl(port, TIOCM_DTR);
+			if (state->info->flags & UIF_CTS_FLOW)
+				uart_set_mctrl(port, TIOCM_RTS);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from kebkal@gmail.com are
