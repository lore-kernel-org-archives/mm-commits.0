From: akpm@linux-foundation.org
Subject: + consoles-switch-to-int-put_char-method.patch added to -mm tree
Date: Mon, 14 Apr 2008 19:04:38 -0700
Message-ID: <200804150204.m3F24cpg005633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760518AbYDOCFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 22:05:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, adaplas@pol.net, alan@redhat.com, jirislaby@gmail.com, kelly@au.ibm.com, paulus@samba.org, samuel.thibault@ens-lyon.org, sfr@canb.auug.org.au


The patch titled
     consoles: switch to int put_char method
has been added to the -mm tree.  Its filename is
     consoles-switch-to-int-put_char-method.patch

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
Subject: consoles: switch to int put_char method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kelly Daly <kelly@au.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/viocons.c |    5 +++--
 drivers/char/vt.c      |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/char/viocons.c~consoles-switch-to-int-put_char-method drivers/char/viocons.c
--- a/drivers/char/viocons.c~consoles-switch-to-int-put_char-method
+++ a/drivers/char/viocons.c
@@ -628,13 +628,13 @@ static int viotty_write(struct tty_struc
 /*
  * TTY put_char method
  */
-static void viotty_put_char(struct tty_struct *tty, unsigned char ch)
+static int viotty_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct port_info *pi;
 
 	pi = get_port_data(tty);
 	if (pi == NULL)
-		return;
+		return 0;
 
 	/* This will append '\r' as well if the char is '\n' */
 	if (viochar_is_console(pi))
@@ -642,6 +642,7 @@ static void viotty_put_char(struct tty_s
 
 	if (viopath_isactive(pi->lp))
 		internal_write(pi, &ch, 1);
+	return 1;
 }
 
 /*
diff -puN drivers/char/vt.c~consoles-switch-to-int-put_char-method drivers/char/vt.c
--- a/drivers/char/vt.c~consoles-switch-to-int-put_char-method
+++ a/drivers/char/vt.c
@@ -2641,11 +2641,11 @@ static int con_write(struct tty_struct *
 	return retval;
 }
 
-static void con_put_char(struct tty_struct *tty, unsigned char ch)
+static int con_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	if (in_interrupt())
-		return;	/* n_r3964 calls put_char() from interrupt context */
-	do_con_write(tty, &ch, 1);
+		return 0;	/* n_r3964 calls put_char() from interrupt context */
+	return do_con_write(tty, &ch, 1);
 }
 
 static int con_write_room(struct tty_struct *tty)
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

