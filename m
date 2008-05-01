From: akpm@linux-foundation.org
Subject: - pcmcia-serial-to-int-put_char-method.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:19 -0700
Message-ID: <200805010930.m419UJH1030757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825AbYEAJax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, linux@dominikbrodowski.net, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     pcmcia: serial to int put_char method
has been removed from the -mm tree.  Its filename was
     pcmcia-serial-to-int-put_char-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: serial to int put_char method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Paul Fulghum <paulkf@microgate.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/synclink_cs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/pcmcia/synclink_cs.c~pcmcia-serial-to-int-put_char-method drivers/char/pcmcia/synclink_cs.c
--- a/drivers/char/pcmcia/synclink_cs.c~pcmcia-serial-to-int-put_char-method
+++ a/drivers/char/pcmcia/synclink_cs.c
@@ -1545,7 +1545,7 @@ static void mgslpc_change_params(MGSLPC_
 
 /* Add a character to the transmit buffer
  */
-static void mgslpc_put_char(struct tty_struct *tty, unsigned char ch)
+static int mgslpc_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
@@ -1556,10 +1556,10 @@ static void mgslpc_put_char(struct tty_s
 	}
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_put_char"))
-		return;
+		return 0;
 
 	if (!info->tx_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->lock,flags);
 
@@ -1572,6 +1572,7 @@ static void mgslpc_put_char(struct tty_s
 	}
 
 	spin_unlock_irqrestore(&info->lock,flags);
+	return 1;
 }
 
 /* Enable transmitter so remaining characters in the
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

