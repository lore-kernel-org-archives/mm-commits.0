From: akpm@linux-foundation.org
Subject: - amiserial-switch-put-char-to-return-success-fail.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:13 -0700
Message-ID: <200805010930.m419UDM9030748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757454AbYEAJae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     amiserial: Switch put char to return success/fail
has been removed from the -mm tree.  Its filename was
     amiserial-switch-put-char-to-return-success-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: amiserial: Switch put char to return success/fail
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/char/amiserial.c~amiserial-switch-put-char-to-return-success-fail drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~amiserial-switch-put-char-to-return-success-fail
+++ a/drivers/char/amiserial.c
@@ -832,33 +832,34 @@ static void change_speed(struct async_st
 	local_irq_restore(flags);
 }
 
-static void rs_put_char(struct tty_struct *tty, unsigned char ch)
+static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct async_struct *info;
 	unsigned long flags;
 
 	if (!tty)
-		return;
+		return 0;
 
 	info = tty->driver_data;
 
 	if (serial_paranoia_check(info, tty->name, "rs_put_char"))
-		return;
+		return 0;
 
 	if (!info->xmit.buf)
-		return;
+		return 0;
 
 	local_irq_save(flags);
 	if (CIRC_SPACE(info->xmit.head,
 		       info->xmit.tail,
 		       SERIAL_XMIT_SIZE) == 0) {
 		local_irq_restore(flags);
-		return;
+		return 0;
 	}
 
 	info->xmit.buf[info->xmit.head++] = ch;
 	info->xmit.head &= SERIAL_XMIT_SIZE-1;
 	local_irq_restore(flags);
+	return 1;
 }
 
 static void rs_flush_chars(struct tty_struct *tty)
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

