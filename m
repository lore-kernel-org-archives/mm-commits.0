From: akpm@linux-foundation.org
Subject: - 8250-fix-possible-deadlock-between-serial8250_handle_port-and-serial8250_interrupt.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:39:15 -0700
Message-ID: <200704252039.l3PKdFSi012289@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993136AbXDYUj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:39:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, alex.williamson@hp.com, davej@codemonkey.org.uk, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     8250: fix possible deadlock between serial8250_handle_port() and serial8250_interrupt()
has been removed from the -mm tree.  Its filename was
     8250-fix-possible-deadlock-between-serial8250_handle_port-and-serial8250_interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 8250: fix possible deadlock between serial8250_handle_port() and serial8250_interrupt()
From: Jiri Kosina <jkosina@suse.cz>

Commit 40b36daa introduced possibility that serial8250_backup_timeout() ->
serial8250_handle_port() locks port.lock without disabling irqs, thus
allowing deadlock against interrupt handler (port.lock is acquired in
serial8250_interrupt()).

Spotted by lockdep.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alex Williamson <alex.williamson@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250.c~8250-fix-possible-deadlock-between-serial8250_handle_port-and-serial8250_interrupt drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-fix-possible-deadlock-between-serial8250_handle_port-and-serial8250_interrupt
+++ a/drivers/serial/8250.c
@@ -1334,8 +1334,9 @@ static inline void
 serial8250_handle_port(struct uart_8250_port *up)
 {
 	unsigned int status;
+	unsigned long flags;
 
-	spin_lock(&up->port.lock);
+	spin_lock_irqsave(&up->port.lock, flags);
 
 	status = serial_inp(up, UART_LSR);
 
@@ -1347,7 +1348,7 @@ serial8250_handle_port(struct uart_8250_
 	if (status & UART_LSR_THRE)
 		transmit_chars(up);
 
-	spin_unlock(&up->port.lock);
+	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
 /*
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
git-hid.patch
git-ipwireless_cs.patch
