From: akpm@linux-foundation.org
Subject: - pc300-update-to-tty_set_operations.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:38 -0700
Message-ID: <200805010930.m419UcDZ030783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757454AbYEAJa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pc300: Update to tty_set_operations
has been removed from the -mm tree.  Its filename was
     pc300-update-to-tty_set_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pc300: Update to tty_set_operations
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This driver somehow escaped the tty operations changes way back when.  Update
it so that we can switch to tty->ops shortly.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/pc300_tty.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN drivers/net/wan/pc300_tty.c~pc300-update-to-tty_set_operations drivers/net/wan/pc300_tty.c
--- a/drivers/net/wan/pc300_tty.c~pc300-update-to-tty_set_operations
+++ a/drivers/net/wan/pc300_tty.c
@@ -178,6 +178,20 @@ static void cpc_tty_signal_on(pc300dev_t
 	CPC_TTY_UNLOCK(card,flags); 
 }
 
+
+static const struct tty_operations pc300_ops = {
+	.open = cpc_tty_open,
+	.close = cpc_tty_close,
+	.write = cpc_tty_write,
+	.write_room = cpc_tty_write_room,
+	.chars_in_buffer = cpc_tty_chars_in_buffer,
+	.tiocmset = pc300_tiocmset,
+	.tiocmget = pc300_tiocmget,
+	.flush_buffer = cpc_tty_flush_buffer,
+	.hangup = cpc_tty_hangup,
+};
+
+
 /*
  * PC300 TTY initialization routine
  *
@@ -225,15 +239,7 @@ void cpc_tty_init(pc300dev_t *pc300dev)
 		serial_drv.flags = TTY_DRIVER_REAL_RAW;
 
 		/* interface routines from the upper tty layer to the tty driver */
-		serial_drv.open = cpc_tty_open;
-		serial_drv.close = cpc_tty_close;
-		serial_drv.write = cpc_tty_write; 
-		serial_drv.write_room = cpc_tty_write_room; 
-		serial_drv.chars_in_buffer = cpc_tty_chars_in_buffer; 
-		serial_drv.tiocmset = pc300_tiocmset;
-		serial_drv.tiocmget = pc300_tiocmget;
-		serial_drv.flush_buffer = cpc_tty_flush_buffer; 
-		serial_drv.hangup = cpc_tty_hangup;
+		tty_set_operations(&serial_drv, &pc300_ops);
 
 		/* register the TTY driver */
 		if (tty_register_driver(&serial_drv)) { 
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

