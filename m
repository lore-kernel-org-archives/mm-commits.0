From: akpm@linux-foundation.org
Subject: + char-moxa-remove-useless-tty-functions.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:13:26 -0800
Message-ID: <200802272313.m1RNDQlR003307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763001AbYB0XN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:13:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk


The patch titled
     Char: moxa, remove useless tty functions
has been added to the -mm tree.  Its filename is
     char-moxa-remove-useless-tty-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1283,27 +1279,6 @@ static int moxa_chars_in_buffer(struct t
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
-
 static int moxa_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct moxa_port *ch;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
wdev-ath5k-typecheck-on-nondebug.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
char-moxa-remove-static-isa-support.patch
char-moxa-cleanup-module-param-passed-isa-init.patch
char-moxa-pci-io-space-fixup.patch
char-moxa-fix-tiocg-ssoftcar-param.patch
char-moxa-add-firmware-loading.patch
char-moxa-merge-c2xx-and-c320-firmware-loading.patch
char-moxa-remove-port-port.patch
char-moxa-remove-unused-port-entries.patch
char-moxa-centralize-board-readiness.patch
char-moxa-timer-cleanup.patch
char-moxa-ioctl-cleanup.patch
char-moxa-merge-2-poll-functions.patch
char-moxa-cleanup-rx-tx.patch
char-moxa-serialise-timer.patch
char-moxa-rework-open-close.patch
char-moxa-little-cleanup.patch
char-moxa-remove-useless-tty-functions.patch
char-moxa-introduce-moxa_is_320-macro.patch
char-moxa-notify-about-board-readiness.patch
char-moxa-update-credits.patch
char-moxa-add-firmware-loading-fix.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
