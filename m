From: akpm@linux-foundation.org
Subject: - serial-m68k-put_char-returns.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:08 -0700
Message-ID: <200805010930.m419U8Kn030742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757500AbYEAJae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     serial m68k: put_char returns
has been removed from the -mm tree.  Its filename was
     serial-m68k-put_char-returns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial m68k: put_char returns
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/68328serial.c |    3 ++-
 drivers/serial/68360serial.c |    5 +++--
 drivers/serial/mcfserial.c   |    4 ++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/serial/68328serial.c~serial-m68k-put_char-returns drivers/serial/68328serial.c
--- a/drivers/serial/68328serial.c~serial-m68k-put_char-returns
+++ a/drivers/serial/68328serial.c
@@ -200,7 +200,7 @@ static void rs_stop(struct tty_struct *t
 	local_irq_restore(flags);
 }
 
-static void rs_put_char(char ch)
+static int rs_put_char(char ch)
 {
         int flags, loops = 0;
 
@@ -214,6 +214,7 @@ static void rs_put_char(char ch)
 	UTX_TXDATA = ch;
         udelay(5);
         local_irq_restore(flags);
+        return 1;
 }
 
 static void rs_start(struct tty_struct *tty)
diff -puN drivers/serial/68360serial.c~serial-m68k-put_char-returns drivers/serial/68360serial.c
--- a/drivers/serial/68360serial.c~serial-m68k-put_char-returns
+++ a/drivers/serial/68360serial.c
@@ -995,10 +995,10 @@ static void rs_360_put_char(struct tty_s
 	volatile QUICC_BD	*bdp;
 
 	if (serial_paranoia_check(info, tty->name, "rs_put_char"))
-		return;
+		return 0;
 
 	if (!tty)
-		return;
+		return 0;
 
 	bdp = info->tx_cur;
 	while (bdp->status & BD_SC_READY);
@@ -1016,6 +1016,7 @@ static void rs_360_put_char(struct tty_s
 		bdp++;
 
 	info->tx_cur = (QUICC_BD *)bdp;
+	return 1;
 
 }
 
diff -puN drivers/serial/mcfserial.c~serial-m68k-put_char-returns drivers/serial/mcfserial.c
--- a/drivers/serial/mcfserial.c~serial-m68k-put_char-returns
+++ a/drivers/serial/mcfserial.c
@@ -1897,7 +1897,7 @@ static struct tty_driver *mcfrs_console_
  *	This is used for console output.
  */
 
-void mcfrs_put_char(char ch)
+int mcfrs_put_char(char ch)
 {
 	volatile unsigned char	*uartp;
 	unsigned long		flags;
@@ -1921,7 +1921,7 @@ void mcfrs_put_char(char ch)
 		mcfrs_init_console(); /* try and get it back */
 	local_irq_restore(flags);
 
-	return;
+	return 1;
 }
 
 
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

