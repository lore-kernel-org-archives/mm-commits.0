From: akpm@osdl.org
Subject: + char-isicom-support-higher-rates.patch added to -mm tree
Date: Mon, 18 Dec 2006 15:28:16 -0800
Message-ID: <200612182328.kBINSGnf016125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58129 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbWLRX2S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 18:28:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: isicom, support higher rates
has been added to the -mm tree.  Its filename is
     char-isicom-support-higher-rates.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: isicom, support higher rates
From: Jiri Slaby <jirislaby@gmail.com>

Add support for higher baud rates (coming from original isi driver).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-support-higher-rates drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-support-higher-rates
+++ a/drivers/char/isicom.c
@@ -183,7 +183,7 @@ static DEFINE_TIMER(tx, isicom_tx, 0, 0)
 /*   baud index mappings from linux defns to isi */
 
 static signed char linuxb_to_isib[] = {
-	-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 13, 15, 16, 17, 18, 19
+	-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 13, 15, 16, 17, 18, 19, 20, 21
 };
 
 struct	isi_board {
@@ -709,7 +709,8 @@ static void isicom_config_port(struct is
 		 *  respectively.
 		 */
 
-		if (baud < 1 || baud > 2)
+		/* 1,2,3,4 => 57.6, 115.2, 230, 460 kbps resp. */
+		if (baud < 1 || baud > 4)
 			port->tty->termios->c_cflag &= ~CBAUDEX;
 		else
 			baud += 15;
@@ -725,6 +726,10 @@ static void isicom_config_port(struct is
 			baud++; /*  57.6 Kbps */
 		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
 			baud +=2; /*  115  Kbps */
+		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+			baud += 3; /* 230 kbps*/
+		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+			baud += 4; /* 460 kbps*/
 	}
 	if (linuxb_to_isib[baud] == -1) {
 		/* hang up */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-fix-probe-race.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
shrink_slab-handle-bad-shrinkers.patch

