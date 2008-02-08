From: akpm@linux-foundation.org
Subject: - rocket-first-pass-at-termios-reporting.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:39 -0800
Message-ID: <200802082012.m18KCKcv010193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbYBHUvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:51:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     rocket: first pass at termios reporting
has been removed from the -mm tree.  Its filename was
     rocket-first-pass-at-termios-reporting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rocket: first pass at termios reporting
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Also removes a cflag comparison that caused some mode changes to get wrongly
ignored

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/char/rocket.c~rocket-first-pass-at-termios-reporting drivers/char/rocket.c
--- a/drivers/char/rocket.c~rocket-first-pass-at-termios-reporting
+++ a/drivers/char/rocket.c
@@ -715,11 +715,10 @@ static void configure_r_port(struct r_po
 	unsigned rocketMode;
 	int bits, baud, divisor;
 	CHANNEL_t *cp;
+	struct ktermios *t = info->tty->termios;
 
-	if (!info->tty || !info->tty->termios)
-		return;
 	cp = &info->channel;
-	cflag = info->tty->termios->c_cflag;
+	cflag = t->c_cflag;
 
 	/* Byte size and parity */
 	if ((cflag & CSIZE) == CS8) {
@@ -754,10 +753,7 @@ static void configure_r_port(struct r_po
 		baud = 9600;
 	divisor = ((rp_baud_base[info->board] + (baud >> 1)) / baud) - 1;
 	if ((divisor >= 8192 || divisor < 0) && old_termios) {
-		info->tty->termios->c_cflag &= ~CBAUD;
-		info->tty->termios->c_cflag |=
-		    (old_termios->c_cflag & CBAUD);
-		baud = tty_get_baud_rate(info->tty);
+		baud = tty_termios_baud_rate(old_termios);
 		if (!baud)
 			baud = 9600;
 		divisor = (rp_baud_base[info->board] / baud) - 1;
@@ -769,6 +765,9 @@ static void configure_r_port(struct r_po
 	info->cps = baud / bits;
 	sSetBaud(cp, divisor);
 
+	/* FIXME: Should really back compute a baud rate from the divisor */
+	tty_encode_baud_rate(info->tty, baud, baud);
+
 	if (cflag & CRTSCTS) {
 		info->intmask |= DELTA_CTS;
 		sEnCTSFlowCtl(cp);
@@ -1202,15 +1201,14 @@ static void rp_set_termios(struct tty_st
 
 	cflag = tty->termios->c_cflag;
 
-	if (cflag == old_termios->c_cflag)
-		return;
-
 	/*
 	 * This driver doesn't support CS5 or CS6
 	 */
 	if (((cflag & CSIZE) == CS5) || ((cflag & CSIZE) == CS6))
 		tty->termios->c_cflag =
 		    ((cflag & ~CSIZE) | (old_termios->c_cflag & CSIZE));
+	/* Or CMSPAR */
+	tty->termios->c_cflag &= ~CMSPAR;
 
 	configure_r_port(info, old_termios);
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
