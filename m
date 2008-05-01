From: akpm@linux-foundation.org
Subject: - riscom-rocket-switch-to-int-put_char-method.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:22 -0700
Message-ID: <200805010930.m419UMaH030760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757964AbYEAJah (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     riscom/rocket: switch to int put_char method
has been removed from the -mm tree.  Its filename was
     riscom-rocket-switch-to-int-put_char-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: riscom/rocket: switch to int put_char method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/riscom8.c |    9 ++++++---
 drivers/char/rocket.c  |    5 +++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/char/riscom8.c~riscom-rocket-switch-to-int-put_char-method drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~riscom-rocket-switch-to-int-put_char-method
+++ a/drivers/char/riscom8.c
@@ -1161,16 +1161,17 @@ static int rc_write(struct tty_struct * 
 	return total;
 }
 
-static void rc_put_char(struct tty_struct * tty, unsigned char ch)
+static int rc_put_char(struct tty_struct * tty, unsigned char ch)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	unsigned long flags;
+	int ret = 0;
 
 	if (rc_paranoia_check(port, tty->name, "rc_put_char"))
-		return;
+		return 0;
 
 	if (!tty || !port->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&riscom_lock, flags);
 	
@@ -1180,9 +1181,11 @@ static void rc_put_char(struct tty_struc
 	port->xmit_buf[port->xmit_head++] = ch;
 	port->xmit_head &= SERIAL_XMIT_SIZE - 1;
 	port->xmit_cnt++;
+	ret = 1;
 
 out:
 	spin_unlock_irqrestore(&riscom_lock, flags);
+	return ret;
 }
 
 static void rc_flush_chars(struct tty_struct * tty)
diff -puN drivers/char/rocket.c~riscom-rocket-switch-to-int-put_char-method drivers/char/rocket.c
--- a/drivers/char/rocket.c~riscom-rocket-switch-to-int-put_char-method
+++ a/drivers/char/rocket.c
@@ -1663,14 +1663,14 @@ static void rp_hangup(struct tty_struct 
  *  writing routines will write directly to transmit FIFO.
  *  Write buffer and counters protected by spinlocks
  */
-static void rp_put_char(struct tty_struct *tty, unsigned char ch)
+static int rp_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct r_port *info = (struct r_port *) tty->driver_data;
 	CHANNEL_t *cp;
 	unsigned long flags;
 
 	if (rocket_paranoia_check(info, "rp_put_char"))
-		return;
+		return 0;
 
 	/*
 	 * Grab the port write mutex, locking out other processes that try to
@@ -1699,6 +1699,7 @@ static void rp_put_char(struct tty_struc
 	}
 	spin_unlock_irqrestore(&info->slock, flags);
 	mutex_unlock(&info->write_mtx);
+	return 1;
 }
 
 /*
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

