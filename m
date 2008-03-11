From: akpm@linux-foundation.org
Subject: + tty_ioctl-locking-for-tty_wait_until_sent.patch added to -mm tree
Date: Mon, 10 Mar 2008 20:56:45 -0700
Message-ID: <200803110356.m2B3ujd8021018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754700AbYCKD6E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:58:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, ak@suse.de, alan@redhat.com


The patch titled
     tty_ioctl: locking for tty_wait_until_sent
has been added to the -mm tree.  Its filename is
     tty_ioctl-locking-for-tty_wait_until_sent.patch

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
Subject: tty_ioctl: locking for tty_wait_until_sent
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This function still depends on the big kernel lock in some cases.  Push
locking into the function ready for removal of the BKL from ioctl call paths.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/char/tty_ioctl.c~tty_ioctl-locking-for-tty_wait_until_sent drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty_ioctl-locking-for-tty_wait_until_sent
+++ a/drivers/char/tty_ioctl.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -61,11 +62,13 @@ void tty_wait_until_sent(struct tty_stru
 		return;
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
+	lock_kernel();
 	if (wait_event_interruptible_timeout(tty->write_wait,
-			!tty->driver->chars_in_buffer(tty), timeout) < 0)
-		return;
-	if (tty->driver->wait_until_sent)
-		tty->driver->wait_until_sent(tty, timeout);
+			!tty->driver->chars_in_buffer(tty), timeout) >= 0) {
+		if (tty->driver->wait_until_sent)
+			tty->driver->wait_until_sent(tty, timeout);
+	}
+	unlock_kernel();
 }
 EXPORT_SYMBOL(tty_wait_until_sent);
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
libata-isolate-and-rework-cable-logic.patch
pata_amd-fix-sparse-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
char-riscom-fix-rc_board-indexing.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
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
istallion-tiocg-ssoftcar-handling-removal.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

