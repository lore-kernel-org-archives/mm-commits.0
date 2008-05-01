From: akpm@linux-foundation.org
Subject: - istallion-tiocg-ssoftcar-handling-removal.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:51 -0700
Message-ID: <200805010929.m419TpOJ030715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755757AbYEAJaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     istallion: TIOCG/SSOFTCAR handling removal
has been removed from the -mm tree.  Its filename was
     istallion-tiocg-ssoftcar-handling-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: istallion: TIOCG/SSOFTCAR handling removal
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This is handled (and correctly) by the core code so does not belong
incorrectly in the driver.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/istallion.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN drivers/char/istallion.c~istallion-tiocg-ssoftcar-handling-removal drivers/char/istallion.c
--- a/drivers/char/istallion.c~istallion-tiocg-ssoftcar-handling-removal
+++ a/drivers/char/istallion.c
@@ -1682,16 +1682,6 @@ static int stli_ioctl(struct tty_struct 
 	rc = 0;
 
 	switch (cmd) {
-	case TIOCGSOFTCAR:
-		rc = put_user(((tty->termios->c_cflag & CLOCAL) ? 1 : 0),
-			(unsigned __user *) arg);
-		break;
-	case TIOCSSOFTCAR:
-		if ((rc = get_user(ival, (unsigned __user *) arg)) == 0)
-			tty->termios->c_cflag =
-				(tty->termios->c_cflag & ~CLOCAL) |
-				(ival ? CLOCAL : 0);
-		break;
 	case TIOCGSERIAL:
 		rc = stli_getserial(portp, argp);
 		break;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

