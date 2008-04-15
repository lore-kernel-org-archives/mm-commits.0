From: akpm@linux-foundation.org
Subject: + char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch added to -mm tree
Date: Mon, 14 Apr 2008 19:04:24 -0700
Message-ID: <200804150204.m3F24Ow7005612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759781AbYDOCFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 22:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     char: switch gs, cyclades and esp to return int for put_char
has been added to the -mm tree.  Its filename is
     char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch

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
Subject: char: switch gs, cyclades and esp to return int for put_char
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c        |    9 +++++----
 drivers/char/esp.c             |    9 ++++++---
 drivers/char/generic_serial.c  |   11 ++++++-----
 include/linux/generic_serial.h |    2 +-
 4 files changed, 18 insertions(+), 13 deletions(-)

diff -puN drivers/char/cyclades.c~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char
+++ a/drivers/char/cyclades.c
@@ -2815,7 +2815,7 @@ static int cy_write(struct tty_struct *t
  * done stuffing characters into the driver.  If there is no room
  * in the queue, the character is ignored.
  */
-static void cy_put_char(struct tty_struct *tty, unsigned char ch)
+static int cy_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
@@ -2825,15 +2825,15 @@ static void cy_put_char(struct tty_struc
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_put_char"))
-		return;
+		return 0;
 
 	if (!info->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->card->card_lock, flags);
 	if (info->xmit_cnt >= (int)(SERIAL_XMIT_SIZE - 1)) {
 		spin_unlock_irqrestore(&info->card->card_lock, flags);
-		return;
+		return 0;
 	}
 
 	info->xmit_buf[info->xmit_head++] = ch;
@@ -2842,6 +2842,7 @@ static void cy_put_char(struct tty_struc
 	info->idle_stats.xmit_bytes++;
 	info->idle_stats.xmit_idle = jiffies;
 	spin_unlock_irqrestore(&info->card->card_lock, flags);
+	return 1;
 }				/* cy_put_char */
 
 /*
diff -puN drivers/char/esp.c~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char drivers/char/esp.c
--- a/drivers/char/esp.c~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char
+++ a/drivers/char/esp.c
@@ -1156,24 +1156,27 @@ static void change_speed(struct esp_stru
 	spin_unlock_irqrestore(&info->lock, flags);
 }
 
-static void rs_put_char(struct tty_struct *tty, unsigned char ch)
+static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
 	unsigned long flags;
+	int ret = 0;
 
 	if (serial_paranoia_check(info, tty->name, "rs_put_char"))
-		return;
+		return 0;
 
 	if (!info->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->lock, flags);
 	if (info->xmit_cnt < ESP_XMIT_SIZE - 1) {
 		info->xmit_buf[info->xmit_head++] = ch;
 		info->xmit_head &= ESP_XMIT_SIZE-1;
 		info->xmit_cnt++;
+		ret = 1;
 	}
 	spin_unlock_irqrestore(&info->lock, flags);
+	return ret;
 }
 
 static void rs_flush_chars(struct tty_struct *tty)
diff -puN drivers/char/generic_serial.c~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char drivers/char/generic_serial.c
--- a/drivers/char/generic_serial.c~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char
+++ a/drivers/char/generic_serial.c
@@ -49,19 +49,19 @@ static int gs_debug;
 module_param(gs_debug, int, 0644);
 
 
-void gs_put_char(struct tty_struct * tty, unsigned char ch)
+int gs_put_char(struct tty_struct * tty, unsigned char ch)
 {
 	struct gs_port *port;
 
 	func_enter (); 
 
-	if (!tty) return;
+	if (!tty) return 0;
 
 	port = tty->driver_data;
 
-	if (!port) return;
+	if (!port) return 0;
 
-	if (! (port->flags & ASYNC_INITIALIZED)) return;
+	if (! (port->flags & ASYNC_INITIALIZED)) return 0;
 
 	/* Take a lock on the serial tranmit buffer! */
 	mutex_lock(& port->port_write_mutex);
@@ -69,7 +69,7 @@ void gs_put_char(struct tty_struct * tty
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
 		/* Sorry, buffer is full, drop character. Update statistics???? -- REW */
 		mutex_unlock(&port->port_write_mutex);
-		return;
+		return 0;
 	}
 
 	port->xmit_buf[port->xmit_head++] = ch;
@@ -78,6 +78,7 @@ void gs_put_char(struct tty_struct * tty
 
 	mutex_unlock(&port->port_write_mutex);
 	func_exit ();
+	return 1;
 }
 
 
diff -puN include/linux/generic_serial.h~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char include/linux/generic_serial.h
--- a/include/linux/generic_serial.h~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char
+++ a/include/linux/generic_serial.h
@@ -78,7 +78,7 @@ struct gs_port {
 #define GS_DEBUG_WRITE   0x00000040
 
 #ifdef __KERNEL__
-void gs_put_char(struct tty_struct *tty, unsigned char ch);
+int gs_put_char(struct tty_struct *tty, unsigned char ch);
 int  gs_write(struct tty_struct *tty, 
              const unsigned char *buf, int count);
 int  gs_write_room(struct tty_struct *tty);
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

