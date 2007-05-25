From: akpm@linux-foundation.org
Subject: + char-n_hdlc-allow-restartsys-retval-of-tty-write.patch added to -mm tree
Date: Thu, 24 May 2007 17:08:07 -0700
Message-ID: <200705250008.l4P087Ct006891@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbXEYAIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 20:08:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, paulkf@microgate.com


The patch titled
     Char: n_hdlc, allow RESTARTSYS retval of tty write
has been added to the -mm tree.  Its filename is
     char-n_hdlc-allow-restartsys-retval-of-tty-write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: n_hdlc, allow RESTARTSYS retval of tty write
From: Jiri Slaby <jirislaby@gmail.com>

Acked-by: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_hdlc.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/char/n_hdlc.c~char-n_hdlc-allow-restartsys-retval-of-tty-write drivers/char/n_hdlc.c
--- a/drivers/char/n_hdlc.c~char-n_hdlc-allow-restartsys-retval-of-tty-write
+++ a/drivers/char/n_hdlc.c
@@ -400,7 +400,12 @@ static void n_hdlc_send_frames(struct n_
 		/* Send the next block of data to device */
 		tty->flags |= (1 << TTY_DO_WRITE_WAKEUP);
 		actual = tty->driver->write(tty, tbuf->buf, tbuf->count);
-		    
+
+		/* rollback was possible and has been done */
+		if (actual == -ERESTARTSYS) {
+			n_hdlc->tbuf = tbuf;
+			break;
+		}
 		/* if transmit error, throw frame away by */
 		/* pretending it was accepted by driver */
 		if (actual < 0)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-cyclades-fix-deadlock.patch
misc-phantom-move-to-unlocked_ioctl.patch
misc-phantom-take-care-of-pci-posting.patch
cinergyt2-fix-file-release-handler.patch
rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
shrink_slab-handle-bad-shrinkers.patch
