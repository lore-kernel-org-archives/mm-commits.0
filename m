From: akpm@linux-foundation.org
Subject: + char-riscom8-fix-shutdown-declaration.patch added to -mm tree
Date: Mon, 24 Aug 2009 13:12:52 -0700
Message-ID: <200908242012.n7OKCqf1031015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752386AbZHXUMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 16:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, greg@kroah.com


The patch titled
     Char: riscom8, fix shutdown declaration
has been added to the -mm tree.  Its filename is
     char-riscom8-fix-shutdown-declaration.patch

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

linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
char-riscom8-fix-shutdown-declaration.patch
kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch
kcore-use-registerd-physmem-information-fix2.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
reiser4.patch

