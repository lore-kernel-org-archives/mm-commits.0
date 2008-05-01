From: akpm@linux-foundation.org
Subject: - serial167-switch-to-int-put_char-method.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:24 -0700
Message-ID: <200805010930.m419UOUN030763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757700AbYEAJbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, geert@linux-m68k.org, jdike@addtoit.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     serial167: switch to int put_char method
has been removed from the -mm tree.  Its filename was
     serial167-switch-to-int-put_char-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial167: switch to int put_char method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/serial167.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/serial167.c~serial167-switch-to-int-put_char-method drivers/char/serial167.c
--- a/drivers/char/serial167.c~serial167-switch-to-int-put_char-method
+++ a/drivers/char/serial167.c
@@ -1060,7 +1060,7 @@ static void config_setup(struct cyclades
 
 }				/* config_setup */
 
-static void cy_put_char(struct tty_struct *tty, unsigned char ch)
+static int cy_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
 	unsigned long flags;
@@ -1070,7 +1070,7 @@ static void cy_put_char(struct tty_struc
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_put_char"))
-		return;
+		return 0;
 
 	if (!info->xmit_buf)
 		return;
@@ -1078,13 +1078,14 @@ static void cy_put_char(struct tty_struc
 	local_irq_save(flags);
 	if (info->xmit_cnt >= PAGE_SIZE - 1) {
 		local_irq_restore(flags);
-		return;
+		return 0;
 	}
 
 	info->xmit_buf[info->xmit_head++] = ch;
 	info->xmit_head &= PAGE_SIZE - 1;
 	info->xmit_cnt++;
 	local_irq_restore(flags);
+	return 1;
 }				/* cy_put_char */
 
 static void cy_flush_chars(struct tty_struct *tty)
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

