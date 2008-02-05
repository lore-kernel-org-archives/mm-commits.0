From: akpm@linux-foundation.org
Subject: - avoid-waking-up-closed-serial-ports-on-resume.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:45 -0800
Message-ID: <200802052227.m15MRQJr011792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762600AbYBEWnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+lkml@arm.linux.org.uk, alan@lxorguk.ukuu.org.uk, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: avoid waking up closed serial ports on resume
has been removed from the -mm tree.  Its filename was
     avoid-waking-up-closed-serial-ports-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: avoid waking up closed serial ports on resume
From: Russell King <rmk+lkml@arm.linux.org.uk>

When we boot, serial ports remain in low power mode until they're used either
by userspace or for the kernel console.

However, if you suspend the system, and then resume, all serial ports will be
taken out of low power mode.  This is bad news for embedded devices where this
can mean higher power consumption.

Only bring a serial port out of low power mode if the port is being used as
the kernel console, or is in use by userspace.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/serial_core.c~avoid-waking-up-closed-serial-ports-on-resume drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~avoid-waking-up-closed-serial-ports-on-resume
+++ a/drivers/serial/serial_core.c
@@ -2029,8 +2029,6 @@ int uart_resume_port(struct uart_driver 
 	}
 	port->suspended = 0;
 
-	uart_change_pm(state, 0);
-
 	/*
 	 * Re-enable the console device after suspending.
 	 */
@@ -2049,6 +2047,7 @@ int uart_resume_port(struct uart_driver 
 		if (state->info && state->info->tty && termios.c_cflag == 0)
 			termios = *state->info->tty->termios;
 
+		uart_change_pm(state, 0);
 		port->ops->set_termios(port, &termios, NULL);
 		console_start(port->cons);
 	}
@@ -2057,6 +2056,7 @@ int uart_resume_port(struct uart_driver 
 		const struct uart_ops *ops = port->ops;
 		int ret;
 
+		uart_change_pm(state, 0);
 		ops->set_mctrl(port, 0);
 		ret = ops->startup(port);
 		if (ret == 0) {
_

Patches currently in -mm which might be from rmk+lkml@arm.linux.org.uk are

origin.patch
