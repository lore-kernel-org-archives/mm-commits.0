From: akpm@linux-foundation.org
Subject: [merged] char-riscom8-fix-shutdown-declaration.patch removed from -mm tree
Date: Thu, 27 Aug 2009 12:18:42 -0700
Message-ID: <200908271918.n7RJIgZc010751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbZH0TSn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 15:18:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Char: riscom8, fix shutdown declaration
has been removed from the -mm tree.  Its filename was
     char-riscom8-fix-shutdown-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: riscom8, fix shutdown declaration
From: Jiri Slaby <jirislaby@gmail.com>

tty_port_ops.shutdown takes only one parameter: tty port.  Remove the
second one and use port->tty where needed instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/riscom8.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/riscom8.c~char-riscom8-fix-shutdown-declaration drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~char-riscom8-fix-shutdown-declaration
+++ a/drivers/char/riscom8.c
@@ -934,7 +934,7 @@ static void rc_flush_buffer(struct tty_s
 	tty_wakeup(tty);
 }
 
-static void rc_close_port(struct tty_port *port, struct tty_struct *tty)
+static void rc_close_port(struct tty_port *port)
 {
 	unsigned long flags;
 	struct riscom_port *rp = container_of(port, struct riscom_port, port);
@@ -969,7 +969,7 @@ static void rc_close_port(struct tty_por
 				break;
 		}
 	}
-	rc_shutdown_port(tty, bp, rp);
+	rc_shutdown_port(port->tty, bp, rp);
 	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
memstick-move-dev_dbg.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

