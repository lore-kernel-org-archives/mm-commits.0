From: akpm@linux-foundation.org
Subject: - mxser-switch-to-put_char-being-int.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:17 -0700
Message-ID: <200805010930.m419UHHZ030754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757689AbYEAJag (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mxser: switch to put_char being int
has been removed from the -mm tree.  Its filename was
     mxser-switch-to-put_char-being-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mxser: switch to put_char being int
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/mxser.c~mxser-switch-to-put_char-being-int drivers/char/mxser.c
--- a/drivers/char/mxser.c~mxser-switch-to-put_char-being-int
+++ a/drivers/char/mxser.c
@@ -1091,16 +1091,16 @@ static int mxser_write(struct tty_struct
 	return total;
 }
 
-static void mxser_put_char(struct tty_struct *tty, unsigned char ch)
+static int mxser_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
 
 	if (!info->xmit_buf)
-		return;
+		return 0;
 
 	if (info->xmit_cnt >= SERIAL_XMIT_SIZE - 1)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->slock, flags);
 	info->xmit_buf[info->xmit_head++] = ch;
@@ -1118,6 +1118,7 @@ static void mxser_put_char(struct tty_st
 			spin_unlock_irqrestore(&info->slock, flags);
 		}
 	}
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

