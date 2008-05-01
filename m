From: akpm@linux-foundation.org
Subject: - usb-gadget-switch-to-put_char-returning-int.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:11 -0700
Message-ID: <200805010930.m419UBFk030745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758143AbYEAJan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, dbrownell@users.sourceforge.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     usb gadget: switch to put_char returning int
has been removed from the -mm tree.  Its filename was
     usb-gadget-switch-to-put_char-returning-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb gadget: switch to put_char returning int
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/serial.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/usb/gadget/serial.c~usb-gadget-switch-to-put_char-returning-int drivers/usb/gadget/serial.c
--- a/drivers/usb/gadget/serial.c~usb-gadget-switch-to-put_char-returning-int
+++ a/drivers/usb/gadget/serial.c
@@ -170,7 +170,7 @@ static int gs_open(struct tty_struct *tt
 static void gs_close(struct tty_struct *tty, struct file *file);
 static int gs_write(struct tty_struct *tty,
 	const unsigned char *buf, int count);
-static void gs_put_char(struct tty_struct *tty, unsigned char ch);
+static int gs_put_char(struct tty_struct *tty, unsigned char ch);
 static void gs_flush_chars(struct tty_struct *tty);
 static int gs_write_room(struct tty_struct *tty);
 static int gs_chars_in_buffer(struct tty_struct *tty);
@@ -883,14 +883,15 @@ exit:
 /*
  * gs_put_char
  */
-static void gs_put_char(struct tty_struct *tty, unsigned char ch)
+static int gs_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	unsigned long flags;
 	struct gs_port *port = tty->driver_data;
+	int ret = 0;
 
 	if (port == NULL) {
 		pr_err("gs_put_char: NULL port pointer\n");
-		return;
+		return 0;
 	}
 
 	gs_debug("gs_put_char: (%d,%p) char=0x%x, called from %p\n",
@@ -910,10 +911,11 @@ static void gs_put_char(struct tty_struc
 		goto exit;
 	}
 
-	gs_buf_put(port->port_write_buf, &ch, 1);
+	ret = gs_buf_put(port->port_write_buf, &ch, 1);
 
 exit:
 	spin_unlock_irqrestore(&port->port_lock, flags);
+	return ret;
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

