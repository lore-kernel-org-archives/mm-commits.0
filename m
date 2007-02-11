From: akpm@linux-foundation.org
Subject: - char-isicom-support-higher-rates.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:43 -0800
Message-ID: <200702112250.l1BMoh3l015881@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60037 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738AbXBKWup (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, support higher rates
has been removed from the -mm tree.  Its filename was
     char-isicom-support-higher-rates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, support higher rates
From: Jiri Slaby <jirislaby@gmail.com>

Add support for higher baud rates (coming from original isi driver).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

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
@@ -710,7 +710,8 @@ static void isicom_config_port(struct is
 		 *  respectively.
 		 */
 
-		if (baud < 1 || baud > 2)
+		/* 1,2,3,4 => 57.6, 115.2, 230, 460 kbps resp. */
+		if (baud < 1 || baud > 4)
 			port->tty->termios->c_cflag &= ~CBAUDEX;
 		else
 			baud += 15;
@@ -726,6 +727,10 @@ static void isicom_config_port(struct is
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

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
