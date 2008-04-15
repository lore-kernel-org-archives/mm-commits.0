From: akpm@linux-foundation.org
Subject: + synclink-series-switch-to-int-put_char-method.patch added to -mm tree
Date: Mon, 14 Apr 2008 19:04:36 -0700
Message-ID: <200804150204.m3F24aUv005630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760320AbYDOCFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 22:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, paulkf@microgate.com


The patch titled
     synclink series: switch to int put_char method
has been added to the -mm tree.  Its filename is
     synclink-series-switch-to-int-put_char-method.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink series: switch to int put_char method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Paul Fulghum <paulkf@microgate.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink.c    |   11 ++++++-----
 drivers/char/synclink_gt.c |   14 +++++++++-----
 drivers/char/synclinkmp.c  |   11 +++++++----
 3 files changed, 22 insertions(+), 14 deletions(-)

diff -puN drivers/char/synclink.c~synclink-series-switch-to-int-put_char-method drivers/char/synclink.c
--- a/drivers/char/synclink.c~synclink-series-switch-to-int-put_char-method
+++ a/drivers/char/synclink.c
@@ -2029,10 +2029,11 @@ static void mgsl_change_params(struct mg
  * 		
  * Return Value:	None
  */
-static void mgsl_put_char(struct tty_struct *tty, unsigned char ch)
+static int mgsl_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct mgsl_struct *info = (struct mgsl_struct *)tty->driver_data;
 	unsigned long flags;
+	int ret;
 
 	if ( debug_level >= DEBUG_LEVEL_INFO ) {
 		printk( "%s(%d):mgsl_put_char(%d) on %s\n",
@@ -2040,23 +2041,23 @@ static void mgsl_put_char(struct tty_str
 	}		
 	
 	if (mgsl_paranoia_check(info, tty->name, "mgsl_put_char"))
-		return;
+		return 0;
 
 	if (!tty || !info->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->irq_spinlock,flags);
 	
 	if ( (info->params.mode == MGSL_MODE_ASYNC ) || !info->tx_active ) {
-	
 		if (info->xmit_cnt < SERIAL_XMIT_SIZE - 1) {
 			info->xmit_buf[info->xmit_head++] = ch;
 			info->xmit_head &= SERIAL_XMIT_SIZE-1;
 			info->xmit_cnt++;
+			ret = 1;
 		}
 	}
-	
 	spin_unlock_irqrestore(&info->irq_spinlock,flags);
+	return ret;
 	
 }	/* end of mgsl_put_char() */
 
diff -puN drivers/char/synclink_gt.c~synclink-series-switch-to-int-put_char-method drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink-series-switch-to-int-put_char-method
+++ a/drivers/char/synclink_gt.c
@@ -151,7 +151,7 @@ static void hangup(struct tty_struct *tt
 static void set_termios(struct tty_struct *tty, struct ktermios *old_termios);
 
 static int  write(struct tty_struct *tty, const unsigned char *buf, int count);
-static void put_char(struct tty_struct *tty, unsigned char ch);
+static int put_char(struct tty_struct *tty, unsigned char ch);
 static void send_xchar(struct tty_struct *tty, char ch);
 static void wait_until_sent(struct tty_struct *tty, int timeout);
 static int  write_room(struct tty_struct *tty);
@@ -913,20 +913,24 @@ cleanup:
 	return ret;
 }
 
-static void put_char(struct tty_struct *tty, unsigned char ch)
+static int put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct slgt_info *info = tty->driver_data;
 	unsigned long flags;
+	int ret;
 
 	if (sanity_check(info, tty->name, "put_char"))
-		return;
+		return 0;
 	DBGINFO(("%s put_char(%d)\n", info->device_name, ch));
 	if (!info->tx_buf)
-		return;
+		return 0;
 	spin_lock_irqsave(&info->lock,flags);
-	if (!info->tx_active && (info->tx_count < info->max_frame_size))
+	if (!info->tx_active && (info->tx_count < info->max_frame_size)) {
 		info->tx_buf[info->tx_count++] = ch;
+		ret = 1;
+	}
 	spin_unlock_irqrestore(&info->lock,flags);
+	return ret;
 }
 
 static void send_xchar(struct tty_struct *tty, char ch)
diff -puN drivers/char/synclinkmp.c~synclink-series-switch-to-int-put_char-method drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~synclink-series-switch-to-int-put_char-method
+++ a/drivers/char/synclinkmp.c
@@ -519,7 +519,7 @@ static void hangup(struct tty_struct *tt
 static void set_termios(struct tty_struct *tty, struct ktermios *old_termios);
 
 static int  write(struct tty_struct *tty, const unsigned char *buf, int count);
-static void put_char(struct tty_struct *tty, unsigned char ch);
+static int put_char(struct tty_struct *tty, unsigned char ch);
 static void send_xchar(struct tty_struct *tty, char ch);
 static void wait_until_sent(struct tty_struct *tty, int timeout);
 static int  write_room(struct tty_struct *tty);
@@ -1045,10 +1045,11 @@ cleanup:
 
 /* Add a character to the transmit buffer.
  */
-static void put_char(struct tty_struct *tty, unsigned char ch)
+static int put_char(struct tty_struct *tty, unsigned char ch)
 {
 	SLMP_INFO *info = (SLMP_INFO *)tty->driver_data;
 	unsigned long flags;
+	int ret = 0;
 
 	if ( debug_level >= DEBUG_LEVEL_INFO ) {
 		printk( "%s(%d):%s put_char(%d)\n",
@@ -1056,10 +1057,10 @@ static void put_char(struct tty_struct *
 	}
 
 	if (sanity_check(info, tty->name, "put_char"))
-		return;
+		return 0;
 
 	if (!info->tx_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->lock,flags);
 
@@ -1071,10 +1072,12 @@ static void put_char(struct tty_struct *
 			if (info->tx_put >= info->max_frame_size)
 				info->tx_put -= info->max_frame_size;
 			info->tx_count++;
+			ret = 1;
 		}
 	}
 
 	spin_unlock_irqrestore(&info->lock,flags);
+	return ret;
 }
 
 /* Send a high-priority XON/XOFF character
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-libata-all.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-simplex-clear-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
parisc-new-termios-definitions.patch
aacraid-fix-unchecked-down_interruptible.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
serial-8250-tighten-test-for-using-backup-timer.patch
x86-geode-add-virtual-systems-architecture-detection.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
tty_ioctl-soft-carrier-handling.patch
tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch
sxc-fix-printk-warnings-on-sparc32.patch
istallion-tiocg-ssoftcar-handling-removal.patch
tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
s390-tty-prepare-for-put_char-to-return-success-fail.patch
serial-m68k-put_char-returns.patch
usb-gadget-switch-to-put_char-returning-int.patch
amiserial-switch-put-char-to-return-success-fail.patch
char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch
mxser-switch-to-put_char-being-int.patch
pcmcia-serial-to-int-put_char-method.patch
riscom-rocket-switch-to-int-put_char-method.patch
serial167-switch-to-int-put_char-method.patch
specialix-switch-to-int-put_char-method.patch
synclink-series-switch-to-int-put_char-method.patch
consoles-switch-to-int-put_char-method.patch
isdn-switch-to-int-put_char-method.patch
pty-prepare-for-tty-ops-changes.patch
pc300-update-to-tty_set_operations.patch
serial-switch-the-serial-core-to-int-put_char-methods.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
strip-fix-up-strip-for-the-new-order.patch
edac-new-support-for-intel-3100-chipset.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
edac-fix-module-initialization-on-several-modules-2nd-time.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

