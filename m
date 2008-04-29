From: akpm@linux-foundation.org
Subject: + tty-add-throttle-unthrottle-helpers.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:27:07 -0700
Message-ID: <200804291927.m3TJR7ZW005694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbYD2T2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, arjan@infradead.org


The patch titled
     tty: add throttle/unthrottle helpers
has been added to the -mm tree.  Its filename is
     tty-add-throttle-unthrottle-helpers.patch

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
Subject: tty: add throttle/unthrottle helpers
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Something Arjan suggested which allows us to clean up the code nicely

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_ldisc.c |    4 +---
 drivers/char/n_tty.c          |   14 ++++----------
 drivers/char/tty_ioctl.c      |   18 ++++++++++++++++++
 drivers/net/hamradio/6pack.c  |    4 +---
 drivers/net/hamradio/mkiss.c  |    4 +---
 drivers/net/ppp_async.c       |    4 +---
 drivers/net/ppp_synctty.c     |    4 +---
 include/linux/tty.h           |    2 ++
 include/linux/tty_driver.h    |    8 ++++++--
 9 files changed, 35 insertions(+), 27 deletions(-)

diff -puN drivers/bluetooth/hci_ldisc.c~tty-add-throttle-unthrottle-helpers drivers/bluetooth/hci_ldisc.c
--- a/drivers/bluetooth/hci_ldisc.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/bluetooth/hci_ldisc.c
@@ -370,9 +370,7 @@ static void hci_uart_tty_receive(struct 
 	hu->hdev->stat.byte_rx += count;
 	spin_unlock(&hu->rx_lock);
 
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
-					tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 static int hci_uart_register_dev(struct hci_uart *hu)
diff -puN drivers/char/n_tty.c~tty-add-throttle-unthrottle-helpers drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/char/n_tty.c
@@ -147,10 +147,8 @@ static void put_tty_queue(unsigned char 
 
 static void check_unthrottle(struct tty_struct *tty)
 {
-	if (tty->count &&
-	    test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
-	    tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	if (tty->count)
+		tty_unthrottle(tty);
 }
 
 /**
@@ -982,12 +980,8 @@ static void n_tty_receive_buf(struct tty
 	 * mode.  We don't want to throttle the driver if we're in
 	 * canonical mode and don't have a newline yet!
 	 */
-	if (tty->receive_room < TTY_THRESHOLD_THROTTLE) {
-		/* check TTY_THROTTLED first so it indicates our state */
-		if (!test_and_set_bit(TTY_THROTTLED, &tty->flags) &&
-		    tty->ops->throttle)
-			tty->ops->throttle(tty);
-	}
+	if (tty->receive_room < TTY_THRESHOLD_THROTTLE)
+		tty_throttle(tty);
 }
 
 int is_ignored(int sig)
diff -puN drivers/char/tty_ioctl.c~tty-add-throttle-unthrottle-helpers drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/char/tty_ioctl.c
@@ -67,6 +67,24 @@ void tty_driver_flush_buffer(struct tty_
 
 EXPORT_SYMBOL(tty_driver_flush_buffer);
 
+void tty_throttle(struct tty_struct *tty)
+{
+	/* check TTY_THROTTLED first so it indicates our state */
+	if (!test_and_set_bit(TTY_THROTTLED, &tty->flags) &&
+	    tty->ops->throttle)
+		tty->ops->throttle(tty);
+}
+
+EXPORT_SYMBOL(tty_throttle);
+
+void tty_unthrottle(struct tty_struct *tty)
+{
+	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
+	    tty->ops->unthrottle)
+		tty->ops->unthrottle(tty);
+}
+
+EXPORT_SYMBOL(tty_unthrottle);
 
 /**
  *	tty_wait_until_sent	-	wait for I/O to finish
diff -puN drivers/net/hamradio/6pack.c~tty-add-throttle-unthrottle-helpers drivers/net/hamradio/6pack.c
--- a/drivers/net/hamradio/6pack.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/net/hamradio/6pack.c
@@ -491,9 +491,7 @@ static void sixpack_receive_buf(struct t
 	sixpack_decode(sp, buf, count1);
 
 	sp_put(sp);
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 /*
diff -puN drivers/net/hamradio/mkiss.c~tty-add-throttle-unthrottle-helpers drivers/net/hamradio/mkiss.c
--- a/drivers/net/hamradio/mkiss.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/net/hamradio/mkiss.c
@@ -936,9 +936,7 @@ static void mkiss_receive_buf(struct tty
 	}
 
 	mkiss_put(ax);
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 /*
diff -puN drivers/net/ppp_async.c~tty-add-throttle-unthrottle-helpers drivers/net/ppp_async.c
--- a/drivers/net/ppp_async.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/net/ppp_async.c
@@ -361,9 +361,7 @@ ppp_asynctty_receive(struct tty_struct *
 	if (!skb_queue_empty(&ap->rqueue))
 		tasklet_schedule(&ap->tsk);
 	ap_put(ap);
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 static void
diff -puN drivers/net/ppp_synctty.c~tty-add-throttle-unthrottle-helpers drivers/net/ppp_synctty.c
--- a/drivers/net/ppp_synctty.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/net/ppp_synctty.c
@@ -401,9 +401,7 @@ ppp_sync_receive(struct tty_struct *tty,
 	if (!skb_queue_empty(&ap->rqueue))
 		tasklet_schedule(&ap->tsk);
 	sp_put(ap);
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 static void
diff -puN include/linux/tty.h~tty-add-throttle-unthrottle-helpers include/linux/tty.h
--- a/include/linux/tty.h~tty-add-throttle-unthrottle-helpers
+++ a/include/linux/tty.h
@@ -303,6 +303,8 @@ extern int tty_put_char(struct tty_struc
 extern int tty_chars_in_buffer(struct tty_struct *tty);
 extern int tty_write_room(struct tty_struct *tty);
 extern void tty_driver_flush_buffer(struct tty_struct *tty);
+extern void tty_throttle(struct tty_struct *tty);
+extern void tty_unthrottle(struct tty_struct *tty);
 
 extern int is_current_pgrp_orphaned(void);
 extern struct pid *tty_get_pgrp(struct tty_struct *tty);
diff -puN include/linux/tty_driver.h~tty-add-throttle-unthrottle-helpers include/linux/tty_driver.h
--- a/include/linux/tty_driver.h~tty-add-throttle-unthrottle-helpers
+++ a/include/linux/tty_driver.h
@@ -100,6 +100,8 @@
  * 	This routine notifies the tty driver that input buffers for
  * 	the line discipline are close to full, and it should somehow
  * 	signal that no more characters should be sent to the tty.
+ *
+ *	Optional: Always invoke via tty_throttle();
  * 
  * void (*unthrottle)(struct tty_struct * tty);
  *
@@ -107,12 +109,14 @@
  * 	that characters can now be sent to the tty without fear of
  * 	overrunning the input buffers of the line disciplines.
  * 
+ *	Optional: Always invoke via tty_unthrottle();
+ *
  * void (*stop)(struct tty_struct *tty);
  *
  * 	This routine notifies the tty driver that it should stop
  * 	outputting characters to the tty device.  
  *
- *	Optional:
+ *	Optional: 
  *
  *	Note: Call stop_tty not this method.
  * 
@@ -141,7 +145,7 @@
  *
  * 	If this routine is implemented, the high-level tty driver will
  * 	handle the following ioctls: TCSBRK, TCSBRKP, TIOCSBRK,
- * 	TIOCCBRK.
+ * 	TIOCCBRK. 
  *
  *	Optional: Required for TCSBRK/BRKP/etc handling.
  *
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
vt-fix-background-color-on-line-feed.patch
proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
edac-new-support-for-intel-3100-chipset.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
edac-fix-module-initialization-on-several-modules-2nd-time.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
libata-more-tsstcorp-pain-keep-in-sync-with-legacy-ide.patch
pata_atiixp-simplex-clear.patch
pata_via-fix-6410-misdetect.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
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
cyclades-coding-style-review.patch
cyclades-use-ioremap_nocache-for-clarity-as-proposed.patch
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
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework.patch
tty-the-big-operations-rework-broke-wan-x25_asy-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
strip-fix-up-strip-for-the-new-order.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
riscom8-coding-style.patch
epca-coding-style.patch
esp-clean-up-to-modern-coding-style.patch
toshiba-use-ioremap_cached.patch
isicom-fix-buffer-allocation.patch
tty-add-throttle-unthrottle-helpers.patch
ip2-switch-remaining-direct-call-of-ops-flush_buffer.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
maintainers-sort-ordering.patch
char-serial-switch-drivers-to-ioremap_nocache.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

