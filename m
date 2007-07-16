From: akpm@linux-foundation.org
Subject: - char-n_hdlc-allow-restartsys-retval-of-tty-write.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:36 -0700
Message-ID: <200707162054.l6GKsaYc001839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755738AbXGPVYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:24:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     Char: n_hdlc, allow RESTARTSYS retval of tty write
has been removed from the -mm tree.  Its filename was
     char-n_hdlc-allow-restartsys-retval-of-tty-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: n_hdlc, allow RESTARTSYS retval of tty write
From: Jiri Slaby <jirislaby@gmail.com>

Acked-by: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_hdlc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
char-stallion-remove-user-class-report-request.patch
char-istallion-initlocking-fixes-try-2.patch
stallion-remove-unneeded-lock_kernel.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
