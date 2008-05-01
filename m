From: akpm@linux-foundation.org
Subject: - tty_ioctl-locking-for-tty_wait_until_sent.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:36 -0700
Message-ID: <200805010928.m419Sa7N030592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757454AbYEAJ3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     tty_ioctl: locking for tty_wait_until_sent
has been removed from the -mm tree.  Its filename was
     tty_ioctl-locking-for-tty_wait_until_sent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty_ioctl: locking for tty_wait_until_sent
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This function still depends on the big kernel lock in some cases.  Push
locking into the function ready for removal of the BKL from ioctl call paths.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
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
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

