From: akpm@linux-foundation.org
Subject: - char-moxa-remove-useless-tty-functions.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:26 -0700
Message-ID: <200805010929.m419TQKB030679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756405AbYEAJ3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, remove useless tty functions
has been removed from the -mm tree.  Its filename was
     char-moxa-remove-useless-tty-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, remove useless tty functions
From: Jiri Slaby <jirislaby@gmail.com>

- moxa_flush_chars -- no code; ldics handle this well
- moxa_put_char -- only wrapper to moxa_write (same code), tty does this
  the same way if tty->driver->put_char is NULL

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-remove-useless-tty-functions drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-remove-useless-tty-functions
+++ a/drivers/char/moxa.c
@@ -193,8 +193,6 @@ static int moxa_write(struct tty_struct 
 static int moxa_write_room(struct tty_struct *);
 static void moxa_flush_buffer(struct tty_struct *);
 static int moxa_chars_in_buffer(struct tty_struct *);
-static void moxa_flush_chars(struct tty_struct *);
-static void moxa_put_char(struct tty_struct *, unsigned char);
 static void moxa_throttle(struct tty_struct *);
 static void moxa_unthrottle(struct tty_struct *);
 static void moxa_set_termios(struct tty_struct *, struct ktermios *);
@@ -391,8 +389,6 @@ static const struct tty_operations moxa_
 	.write_room = moxa_write_room,
 	.flush_buffer = moxa_flush_buffer,
 	.chars_in_buffer = moxa_chars_in_buffer,
-	.flush_chars = moxa_flush_chars,
-	.put_char = moxa_put_char,
 	.ioctl = moxa_ioctl,
 	.throttle = moxa_throttle,
 	.unthrottle = moxa_unthrottle,
@@ -1284,27 +1280,6 @@ static int moxa_chars_in_buffer(struct t
 	return chars;
 }
 
-static void moxa_flush_chars(struct tty_struct *tty)
-{
-	/*
-	 * Don't think I need this, because this is called to empty the TX
-	 * buffer for the 16450, 16550, etc.
-	 */
-}
-
-static void moxa_put_char(struct tty_struct *tty, unsigned char c)
-{
-	struct moxa_port *ch = tty->driver_data;
-
-	if (ch == NULL)
-		return;
-	spin_lock_bh(&moxa_lock);
-	MoxaPortWriteData(ch, &c, 1);
-	spin_unlock_bh(&moxa_lock);
-
-	ch->statusflags |= LOWWAIT;
-}
