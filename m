From: akpm@linux-foundation.org
Subject: + tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:58:17 -0800
Message-ID: <200712120558.lBC5wH1n028590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752519AbXLLF6z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:58:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@skyrush.com, alan@lxorguk.ukuu.org.uk


The patch titled
     tty: enable the echoing of ^C in the N_TTY discipline
has been added to the -mm tree.  Its filename is
     tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: enable the echoing of ^C in the N_TTY discipline
From: Joe Peterson <joe@skyrush.com>

Turn on INTR/QUIT/SUSP echoing in the N_TTY line discipline (e.g.  ctrl-C
will appear as "^C" if stty echoctl is set and ctrl-C is set as INTR).

Linux seems to be the only unix-like OS (recently I've verified this on
Solaris, BSD, and Mac OS X) that does *not* behave this way, and I really
miss this as a good visual confirmation of the interrupt of a program in
the console or xterm.  I remember this fondly from many Unixs I've used
over the years as well.  Bringing this to Linux also seems like a good way
to make it yet more compliant with standard unix-like behavior.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/char/n_tty.c~tty-enable-the-echoing-of-c-in-the-n_tty-discipline drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-enable-the-echoing-of-c-in-the-n_tty-discipline
+++ a/drivers/char/n_tty.c
@@ -769,7 +769,22 @@ static inline void n_tty_receive_char(st
 		signal = SIGTSTP;
 		if (c == SUSP_CHAR(tty)) {
 send_signal:
-			isig(signal, tty, 0);
+			/*
+			 * Echo character, and then send the signal.
+			 * Note that we do not use isig() here because we want
+			 * the order to be:
+			 * 1) flush, 2) echo, 3) signal
+			 */
+			if (!L_NOFLSH(tty)) {
+				n_tty_flush_buffer(tty);
+				if (tty->driver->flush_buffer)
+					tty->driver->flush_buffer(tty);
+			}
+			if (L_ECHO(tty)) {
+				echo_char(c, tty);
+			}
+			if (tty->pgrp)
+				kill_pgrp(tty->pgrp, signal, 1);
 			return;
 		}
 	}
_

Patches currently in -mm which might be from joe@skyrush.com are

tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
