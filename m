From: akpm@linux-foundation.org
Subject: - char-tty_ioctl-little-whitespace-cleanup.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:58 -0700
Message-ID: <200707162054.l6GKsw0p001867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758803AbXGPVPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: tty_ioctl, little whitespace cleanup
has been removed from the -mm tree.  Its filename was
     char-tty_ioctl-little-whitespace-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 3 insertions(+), 4 deletions(-)

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
