From: akpm@google.com
Subject: [merged] tty-serial-fix-locking-imbalance.patch removed from -mm tree
Date: Tue, 04 Oct 2011 12:29:48 -0700
Message-ID: <201110041929.p94JTmBv017526@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:33411 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1JDTah (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 15:30:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: TTY: serial, fix locking imbalance
has been removed from the -mm tree.  Its filename was
     tty-serial-fix-locking-imbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: TTY: serial, fix locking imbalance

linux-next commit "TTY: serial, move locking in uart_close" moved the
lock, but omitted to update branches which unlock the lock.  Now they try
to unlock the lock without holding it.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/serial_core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/tty/serial/serial_core.c~tty-serial-fix-locking-imbalance drivers/tty/serial/serial_core.c
--- a/drivers/tty/serial/serial_core.c~tty-serial-fix-locking-imbalance
+++ a/drivers/tty/serial/serial_core.c
@@ -1262,7 +1262,7 @@ static void uart_close(struct tty_struct
 
 	if (tty_hung_up_p(filp)) {
 		spin_unlock_irqrestore(&port->lock, flags);
-		goto done;
+		return;
 	}
 
 	if ((tty->count == 1) && (port->count != 1)) {
@@ -1284,7 +1284,7 @@ static void uart_close(struct tty_struct
 	}
 	if (port->count) {
 		spin_unlock_irqrestore(&port->lock, flags);
-		goto done;
+		return;
 	}
 
 	/*
@@ -1347,7 +1347,6 @@ static void uart_close(struct tty_struct
 	wake_up_interruptible(&port->open_wait);
 	wake_up_interruptible(&port->close_wait);
 
-done:
 	mutex_unlock(&port->mutex);
 }
 
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch

