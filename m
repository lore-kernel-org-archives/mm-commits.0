From: akpm@linux-foundation.org
Subject: + char-tty_ioctl-little-whitespace-cleanup.patch added to -mm tree
Date: Tue, 29 May 2007 17:08:33 -0700
Message-ID: <200705300008.l4U08XOB015003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752815AbXE3AIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 20:08:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: tty_ioctl, little whitespace cleanup
has been added to the -mm tree.  Its filename is
     char-tty_ioctl-little-whitespace-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: tty_ioctl, little whitespace cleanup
From: Jiri Slaby <jirislaby@gmail.com>

tty_ioctl, little whitespace cleanup

the point is to make
while (++i < n_baud_table);
clear and assign it to the do { } loop

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/char/tty_ioctl.c~char-tty_ioctl-little-whitespace-cleanup drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~char-tty_ioctl-little-whitespace-cleanup
+++ a/drivers/char/tty_ioctl.c
@@ -261,13 +261,12 @@ void tty_termios_encode_baud_rate(struct
 				termios->c_cflag |= (baud_bits[i] << IBSHIFT);
 			ifound = i;
 		}
-	}
-	while(++i < n_baud_table);
+	} while (++i < n_baud_table);
 	if (ofound == -1)
 		termios->c_cflag |= BOTHER;
 	/* Set exact input bits only if the input and output differ or the
 	   user already did */
-	if (ifound == -1 && (ibaud != obaud  || ibinput))
+	if (ifound == -1 && (ibaud != obaud || ibinput))
 		termios->c_cflag |= (BOTHER << IBSHIFT);
 }
 
@@ -560,7 +559,7 @@ static int set_sgttyb(struct tty_struct 
 		return -EFAULT;
 
 	mutex_lock(&tty->termios_mutex);
-	termios =  *tty->termios;
+	termios = *tty->termios;
 	termios.c_cc[VERASE] = tmp.sg_erase;
 	termios.c_cc[VKILL] = tmp.sg_kill;
 	set_sgflags(&termios, tmp.sg_flags);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-mxser_new-fix-sparse-warning.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
char-genrtc-use-wait_event_interruptible.patch
char-n_r3964-use-wait_event_interruptible.patch
char-ip2-use-msleep-for-sleeping.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
shrink_slab-handle-bad-shrinkers.patch
