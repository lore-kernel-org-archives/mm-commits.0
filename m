From: akpm@linux-foundation.org
Subject: + s390-tty-prepare-for-put_char-to-return-success-fail.patch added to -mm tree
Date: Mon, 14 Apr 2008 19:04:16 -0700
Message-ID: <200804150204.m3F24GdU005600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759633AbYDOCFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 22:05:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, peter.oberparleiter@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     s390 tty: Prepare for put_char to return success/fail
has been added to the -mm tree.  Its filename is
     s390-tty-prepare-for-put_char-to-return-success-fail.patch

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
Subject: s390 tty: Prepare for put_char to return success/fail
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Put the changes into the drivers first.  This will still compile/work but
produce a warning if bisected so can still be debugged

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/con3215.c    |    5 +++--
 drivers/s390/char/sclp_tty.c   |    4 ++--
 drivers/s390/char/sclp_vt220.c |    6 +++++-
 drivers/s390/char/tty3270.c    |    3 ++-
 4 files changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/s390/char/con3215.c~s390-tty-prepare-for-put_char-to-return-success-fail drivers/s390/char/con3215.c
--- a/drivers/s390/char/con3215.c~s390-tty-prepare-for-put_char-to-return-success-fail
+++ a/drivers/s390/char/con3215.c
@@ -982,15 +982,16 @@ tty3215_write(struct tty_struct * tty,
 /*
  * Put character routine for 3215 ttys
  */
-static void
+static int
 tty3215_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct raw3215_info *raw;
 
 	if (!tty)
-		return;
+		return 0;
 	raw = (struct raw3215_info *) tty->driver_data;
 	raw3215_putchar(raw, ch);
+	return 1;
 }
 
 static void
diff -puN drivers/s390/char/sclp_tty.c~s390-tty-prepare-for-put_char-to-return-success-fail drivers/s390/char/sclp_tty.c
--- a/drivers/s390/char/sclp_tty.c~s390-tty-prepare-for-put_char-to-return-success-fail
+++ a/drivers/s390/char/sclp_tty.c
@@ -412,14 +412,14 @@ sclp_tty_write(struct tty_struct *tty, c
  * - including previous characters from sclp_tty_put_char() and strings from
  * sclp_write() without final '\n' - will be written.
  */
-static void
+static int
 sclp_tty_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	sclp_tty_chars[sclp_tty_chars_count++] = ch;
 	if (ch == '\n' || sclp_tty_chars_count >= SCLP_TTY_BUF_SIZE) {
 		sclp_tty_write_string(sclp_tty_chars, sclp_tty_chars_count);
 		sclp_tty_chars_count = 0;
-	}
+	} return 1;
 }
 
 /*
diff -puN drivers/s390/char/sclp_vt220.c~s390-tty-prepare-for-put_char-to-return-success-fail drivers/s390/char/sclp_vt220.c
--- a/drivers/s390/char/sclp_vt220.c~s390-tty-prepare-for-put_char-to-return-success-fail
+++ a/drivers/s390/char/sclp_vt220.c
@@ -524,11 +524,15 @@ sclp_vt220_close(struct tty_struct *tty,
  * NOTE: include/linux/tty_driver.h specifies that a character should be
  * ignored if there is no room in the queue. This driver implements a different
  * semantic in that it will block when there is no more room left.
+ *
+ * FIXME: putchar can currently be called from BH and other non blocking
+ * handlers so  this semantic isn't a good idea.
  */
-static void
+static int
 sclp_vt220_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	__sclp_vt220_write(&ch, 1, 0, 0, 1);
+	return 1;
 }
 
 /*
diff -puN drivers/s390/char/tty3270.c~s390-tty-prepare-for-put_char-to-return-success-fail drivers/s390/char/tty3270.c
--- a/drivers/s390/char/tty3270.c~s390-tty-prepare-for-put_char-to-return-success-fail
+++ a/drivers/s390/char/tty3270.c
@@ -965,7 +965,7 @@ tty3270_write_room(struct tty_struct *tt
  * Insert character into the screen at the current position with the
  * current color and highlight. This function does NOT do cursor movement.
  */
-static void
+static int
 tty3270_put_character(struct tty3270 *tp, char ch)
 {
 	struct tty3270_line *line;
@@ -986,6 +986,7 @@ tty3270_put_character(struct tty3270 *tp
 	cell->character = tp->view.ascebc[(unsigned int) ch];
 	cell->highlight = tp->highlight;
 	cell->f_color = tp->f_color;
+	return 1;
 }
 
 /*
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

