From: akpm@linux-foundation.org
Subject: - update-zilog-timeout.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:05 -0700
Message-ID: <200707162054.l6GKs5Xn001778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43706 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764215AbXGPVgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:36:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ths@networkno.de, alan@lxorguk.ukuu.org.uk, pf@net.alphadv.de, ralf@linux-mips.org, rmk@arm.linux.org.uk, tbm@cyrius.com, mm-commits@vger.kernel.org


The patch titled
     Update zilog timeout
has been removed from the -mm tree.  Its filename was
     update-zilog-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Update zilog timeout
From: Thiemo Seufer <ths@networkno.de>

Update zilog timeout, thanks Peter Fuerst.

Signed-off-by: Thiemo Seufer <ths@networkno.de>
Cc: Martin Michlmayr <tbm@cyrius.com>
Cc: Peter Fuerst <pf@net.alphadv.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/ip22zilog.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/serial/ip22zilog.c~update-zilog-timeout drivers/serial/ip22zilog.c
--- a/drivers/serial/ip22zilog.c~update-zilog-timeout
+++ a/drivers/serial/ip22zilog.c
@@ -862,6 +862,7 @@ ip22zilog_set_termios(struct uart_port *
 	up->cflag = termios->c_cflag;
 
 	ip22zilog_maybe_update_regs(up, ZILOG_CHANNEL_FROM_PORT(port));
+	uart_update_timeout(port, termios->c_cflag, baud);
 
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
@@ -1017,6 +1018,8 @@ ip22serial_console_termios(struct consol
 	}
 
 	con->cflag = cflag | CS8;			/* 8N1 */
+
+	uart_update_timeout(&ip22zilog_port_table[con->index].port, cflag, baud);
 }
 
 static int __init ip22zilog_console_setup(struct console *con, char *options)
_

Patches currently in -mm which might be from ths@networkno.de are

origin.patch
