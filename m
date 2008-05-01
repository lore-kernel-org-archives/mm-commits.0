From: akpm@linux-foundation.org
Subject: - specialix-switch-to-int-put_char-method.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:27 -0700
Message-ID: <200805010930.m419URcZ030766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758469AbYEAJat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     specialix: Switch to int put_char method
has been removed from the -mm tree.  Its filename was
     specialix-switch-to-int-put_char-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: specialix: Switch to int put_char method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/specialix.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/char/specialix.c~specialix-switch-to-int-put_char-method drivers/char/specialix.c
--- a/drivers/char/specialix.c~specialix-switch-to-int-put_char-method
+++ a/drivers/char/specialix.c
@@ -1690,7 +1690,7 @@ static int sx_write(struct tty_struct * 
 }
 
 
-static void sx_put_char(struct tty_struct * tty, unsigned char ch)
+static int sx_put_char(struct tty_struct * tty, unsigned char ch)
 {
 	struct specialix_port *port = (struct specialix_port *)tty->driver_data;
 	unsigned long flags;
@@ -1700,12 +1700,12 @@ static void sx_put_char(struct tty_struc
 
 	if (sx_paranoia_check(port, tty->name, "sx_put_char")) {
 		func_exit();
-		return;
+		return 0;
 	}
 	dprintk (SX_DEBUG_TX, "check tty: %p %p\n", tty, port->xmit_buf);
 	if (!port->xmit_buf) {
 		func_exit();
-		return;
+		return 0;
 	}
 	bp = port_Board(port);
 	spin_lock_irqsave(&port->lock, flags);
@@ -1715,7 +1715,7 @@ static void sx_put_char(struct tty_struc
 		spin_unlock_irqrestore(&port->lock, flags);
 		dprintk (SX_DEBUG_TX, "Exit size\n");
 		func_exit();
-		return;
+		return 0;
 	}
 	dprintk (SX_DEBUG_TX, "Handle xmit: %p %p\n", port, port->xmit_buf);
 	port->xmit_buf[port->xmit_head++] = ch;
@@ -1724,6 +1724,7 @@ static void sx_put_char(struct tty_struc
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	func_exit();
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

