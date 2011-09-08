From: akpm@linux-foundation.org
Subject: + tty-serial-fix-locking-imbalance.patch added to -mm tree
Date: Thu, 08 Sep 2011 16:55:29 -0700
Message-ID: <201109082355.p88NtTHe015878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755778Ab1IHXzi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2011 19:55:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, greg@kroah.com


The patch titled
     TTY: serial, fix locking imbalance
has been added to the -mm tree.  Its filename is
     tty-serial-fix-locking-imbalance.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: TTY: serial, fix locking imbalance
From: Jiri Slaby <jslaby@suse.cz>

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
tty-serial-fix-locking-imbalance.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error.patch

