From: akpm@linux-foundation.org
Subject: + tty_set_ldisc-receive_room-fix.patch added to -mm tree
Date: Fri, 04 May 2007 15:04:10 -0700
Message-ID: <200705042204.l44M4AsJ020155@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161934AbXEDWER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 18:04:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk


The patch titled
     tty_set_ldisc() receive_room fix
has been added to the -mm tree.  Its filename is
     tty_set_ldisc-receive_room-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty_set_ldisc() receive_room fix
From: Paul Fulghum <paulkf@microgate.com>

Fix tty_set_ldisc in tty_io.c so that tty->receive_room is only cleared if
actually changing line disciplines.

Without this fix a problem occurs when requesting the line discipline to
change to the same line discipline.  In this case tty->receive_room is
cleared but ldisc->open() is not called to set tty->receive_room back to a
sane value.  The result is that tty->receive_room is stuck at 0 preventing
the tty flip buffer from passing receive data to the line discipline.

For example: a switch from N_TTY to N_TTY followed by a select() call for
read input results in data never being received because tty->receive_room
is stuck at zero.

A switch from N_TTY to N_TTY followed by a read() call works because the
read() call itself sets tty->receive_room correctly (but select does not).

Previously (< 2.6.18) this was not a problem because the tty flip buffer
pushed data to the line discipline without regard for tty->receive room.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/char/tty_io.c~tty_set_ldisc-receive_room-fix drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty_set_ldisc-receive_room-fix
+++ a/drivers/char/tty_io.c
@@ -934,13 +934,6 @@ restart:
 		return -EINVAL;
 
 	/*
-	 *	No more input please, we are switching. The new ldisc
-	 *	will update this value in the ldisc open function
-	 */
-
-	tty->receive_room = 0;
-
-	/*
 	 *	Problem: What do we do if this blocks ?
 	 */
 
@@ -951,6 +944,13 @@ restart:
 		return 0;
 	}
 
+	/*
+	 *	No more input please, we are switching. The new ldisc
+	 *	will update this value in the ldisc open function
+	 */
+
+	tty->receive_room = 0;
+
 	o_ldisc = tty->ldisc;
 	o_tty = tty->link;
 
_

Patches currently in -mm which might be from paulkf@microgate.com are

drivers-char-synclinkc-check-kmalloc-return-value.patch
synclink_gt-use-dynamic-tty-device-registration.patch
tty_set_ldisc-receive_room-fix.patch
tty-add-compat_ioctl.patch
tty-add-compat_ioctl-fix.patch
synclink_gt-add-compat_ioctl.patch
synclink_gt-add-compat_ioctl-fix.patch
