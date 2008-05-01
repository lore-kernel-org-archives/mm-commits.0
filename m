From: akpm@linux-foundation.org
Subject: - consoles-switch-to-int-put_char-method.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:31 -0700
Message-ID: <200805010930.m419UV8W030772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757050AbYEAJbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, adaplas@pol.net, alan@redhat.com, jirislaby@gmail.com, kelly@au.ibm.com, paulus@samba.org, samuel.thibault@ens-lyon.org, sfr@canb.auug.org.au, mm-commits@vge


The patch titled
     consoles: switch to int put_char method
has been removed from the -mm tree.  Its filename was
     consoles-switch-to-int-put_char-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: consoles: switch to int put_char method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kelly Daly <kelly@au.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/viocons.c |    5 +++--
 drivers/char/vt.c      |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/char/viocons.c~consoles-switch-to-int-put_char-method drivers/char/viocons.c
--- a/drivers/char/viocons.c~consoles-switch-to-int-put_char-method
+++ a/drivers/char/viocons.c
@@ -628,13 +628,13 @@ static int viotty_write(struct tty_struc
 /*
  * TTY put_char method
  */
-static void viotty_put_char(struct tty_struct *tty, unsigned char ch)
+static int viotty_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct port_info *pi;
 
 	pi = get_port_data(tty);
 	if (pi == NULL)
-		return;
+		return 0;
 
 	/* This will append '\r' as well if the char is '\n' */
 	if (viochar_is_console(pi))
@@ -642,6 +642,7 @@ static void viotty_put_char(struct tty_s
 
 	if (viopath_isactive(pi->lp))
 		internal_write(pi, &ch, 1);
+	return 1;
 }
 
 /*
diff -puN drivers/char/vt.c~consoles-switch-to-int-put_char-method drivers/char/vt.c
--- a/drivers/char/vt.c~consoles-switch-to-int-put_char-method
+++ a/drivers/char/vt.c
@@ -2642,11 +2642,11 @@ static int con_write(struct tty_struct *
 	return retval;
 }
 
-static void con_put_char(struct tty_struct *tty, unsigned char ch)
+static int con_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	if (in_interrupt())
-		return;	/* n_r3964 calls put_char() from interrupt context */
-	do_con_write(tty, &ch, 1);
+		return 0;	/* n_r3964 calls put_char() from interrupt context */
+	return do_con_write(tty, &ch, 1);
 }
 
 static int con_write_room(struct tty_struct *tty)
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

