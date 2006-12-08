From: akpm@osdl.org
Subject: - char-mxser_new-testbit-for-bit-testing.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:07:19 -0800
Message-ID: <200612082007.kB8K7JDD002505@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57878 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426347AbWLHUHY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:07:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, testbit for bit testing
has been removed from the -mm tree.  Its filename was
     char-mxser_new-testbit-for-bit-testing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, testbit for bit testing
From: Jiri Slaby <jirislaby@gmail.com>

Use testbit like in tty subsystem for TTY_IO_ERROR testing.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-testbit-for-bit-testing drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-testbit-for-bit-testing
+++ a/drivers/char/mxser_new.c
@@ -461,7 +461,8 @@ static int mxser_block_til_ready(struct 
 	 * If non-blocking mode is set, or the port is not enabled,
 	 * then make the check up front and then exit.
 	 */
-	if ((filp->f_flags & O_NONBLOCK) || (tty->flags & (1 << TTY_IO_ERROR))) {
+	if ((filp->f_flags & O_NONBLOCK) ||
+			test_bit(TTY_IO_ERROR, &tty->flags)) {
 		port->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
@@ -1437,7 +1438,7 @@ static int mxser_tiocmget(struct tty_str
 
 	if (tty->index == MXSER_PORTS)
 		return -ENOIOCTLCMD;
-	if (tty->flags & (1 << TTY_IO_ERROR))
+	if (test_bit(TTY_IO_ERROR, &tty->flags))
 		return -EIO;
 
 	control = info->MCR;
@@ -1464,7 +1465,7 @@ static int mxser_tiocmset(struct tty_str
 
 	if (tty->index == MXSER_PORTS)
 		return -ENOIOCTLCMD;
-	if (tty->flags & (1 << TTY_IO_ERROR))
+	if (test_bit(TTY_IO_ERROR, &tty->flags))
 		return -EIO;
 
 	spin_lock_irqsave(&info->slock, flags);
@@ -1798,10 +1799,10 @@ static int mxser_ioctl(struct tty_struct
 	}
 	/* above add by Victor Yu. 01-05-2004 */
 
-	if ((cmd != TIOCGSERIAL) && (cmd != TIOCMIWAIT) && (cmd != TIOCGICOUNT)) {
-		if (tty->flags & (1 << TTY_IO_ERROR))
-			return -EIO;
-	}
+	if (cmd != TIOCGSERIAL && cmd != TIOCMIWAIT && cmd != TIOCGICOUNT &&
+			test_bit(TTY_IO_ERROR, &tty->flags))
+		return -EIO;
+
 	switch (cmd) {
 	case TCSBRK:		/* SVID version: non-zero arg --> no break */
 		retval = tty_check_change(tty);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-mxser_new-testbit-for-bit-testing.patch
char-mxser_new-correct-fail-paths.patch
char-mxser_new-dont-check-tty_unregister-retval.patch
char-mxser_new-compress-isa-finding.patch
char-mxser_new-register-tty-devices-on-the-fly.patch
char-mxser_new-compact-structures-round2.patch
char-mxser_new-reverse-if-else-paths-patch.patch
char-mxser_new-comments-cleanup.patch
char-mxser_new-correct-intr-handler-proto.patch
char-mxser_new-delete-ttys-and-termios.patch
char-mxser_new-pci-probing.patch
char-mxser_new-clean-macros.patch
maintainers-add-me-to-isicom-mxser.patch
mxser_new-correct-tty-driver-name.patch
mxser-workqueue-fixes.patch
char-stallion-use-pr_debug-macro.patch
char-stallion-remove-unneeded-casts.patch
char-stallion-kill-typedefs.patch
char-stallion-move-init-deinit.patch
char-stallion-uninline-functions.patch
char-stallion-mark-functions-as-init.patch
char-stallion-remove-many-prototypes.patch
char-isicom-expand-function.patch
char-isicom-rename-init-function.patch
char-isicom-remove-isa-code.patch
char-isicom-remove-unneeded-memset.patch
char-isicom-move-to-tty_register_device.patch
char-isicom-use-pci_request_region.patch
char-isicom-check-kmalloc-retval.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

