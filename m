From: akpm@linux-foundation.org
Subject: - char-mxser-ioctl-cleanup.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:40 -0700
Message-ID: <200807252301.m6PN1e44003726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177AbYGYXC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser, ioctl cleanup
has been removed from the -mm tree.  Its filename was
     char-mxser-ioctl-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: mxser, ioctl cleanup
From: Jiri Slaby <jirislaby@gmail.com>

- remove break ctl from ioctl handler, it's never reached, since
  tty_ops->break_ctl is defined (mxser break handling is done in software)
- mark MOXA_GET_MAJOR as deprecated
- fix TIOCGICOUNT (some retval non-checks of put_user). Use copy_to_user
  to whole structure instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |   42 ++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff -puN drivers/char/mxser.c~char-mxser-ioctl-cleanup drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-ioctl-cleanup
+++ a/drivers/char/mxser.c
@@ -16,7 +16,6 @@
  *	Fed through a cleanup, indent and remove of non 2.6 code by Alan Cox
  *	<alan@redhat.com>. The original 1.8 code is available on www.moxa.com.
  *	- Fixed x86_64 cleanness
- *	- Fixed sleep with spinlock held in mxser_send_break
  */
 
 #include <linux/module.h>
@@ -1634,6 +1633,8 @@ static int mxser_ioctl_special(unsigned 
 
 	switch (cmd) {
 	case MOXA_GET_MAJOR:
+		printk(KERN_WARNING "mxser: '%s' uses deprecated ioctl %x, fix "
+				"your userspace\n", current->comm, cmd);
 		return put_user(ttymajor, (int __user *)argp);
 
 	case MOXA_CHKPORTENABLE:
@@ -1804,7 +1805,6 @@ static int mxser_ioctl(struct tty_struct
 {
 	struct mxser_port *info = tty->driver_data;
 	struct async_icount cnow;
-	struct serial_icounter_struct __user *p_cuser;
 	unsigned long flags;
 	void __user *argp = (void __user *)arg;
 	int retval;
@@ -1884,30 +1884,26 @@ static int mxser_ioctl(struct tty_struct
 	 * NB: both 1->0 and 0->1 transitions are counted except for
 	 *     RI where only 0->1 is counted.
 	 */
-	case TIOCGICOUNT:
+	case TIOCGICOUNT: {
+		struct serial_icounter_struct icnt = { 0 };
 		spin_lock_irqsave(&info->slock, flags);
 		cnow = info->icount;
 		spin_unlock_irqrestore(&info->slock, flags);
-		p_cuser = argp;
-		if (put_user(cnow.frame, &p_cuser->frame))
-			return -EFAULT;
-		if (put_user(cnow.brk, &p_cuser->brk))
-			return -EFAULT;
-		if (put_user(cnow.overrun, &p_cuser->overrun))
-			return -EFAULT;
-		if (put_user(cnow.buf_overrun, &p_cuser->buf_overrun))
-			return -EFAULT;
-		if (put_user(cnow.parity, &p_cuser->parity))
-			return -EFAULT;
-		if (put_user(cnow.rx, &p_cuser->rx))
-			return -EFAULT;
-		if (put_user(cnow.tx, &p_cuser->tx))
-			return -EFAULT;
-		put_user(cnow.cts, &p_cuser->cts);
-		put_user(cnow.dsr, &p_cuser->dsr);
-		put_user(cnow.rng, &p_cuser->rng);
-		put_user(cnow.dcd, &p_cuser->dcd);
-		return 0;
+
+		icnt.frame = cnow.frame;
+		icnt.brk = cnow.brk;
+		icnt.overrun = cnow.overrun;
+		icnt.buf_overrun = cnow.buf_overrun;
+		icnt.parity = cnow.parity;
+		icnt.rx = cnow.rx;
+		icnt.tx = cnow.tx;
+		icnt.cts = cnow.cts;
+		icnt.dsr = cnow.dsr;
+		icnt.rng = cnow.rng;
+		icnt.dcd = cnow.dcd;
+
+		return copy_to_user(argp, &icnt, sizeof(icnt)) ? -EFAULT : 0;
+	}
 	case MOXA_HighSpeedOn:
 		return put_user(info->baud_base != 115200 ? 1 : 0, (int __user *)argp);
 	case MOXA_SDS_RSTICOUNTER:
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
ath5k-fix-memory-corruption.patch
ath5k-kill-tasklets-on-shutdown.patch
ath5k-flush-work.patch
ath5k-fix-dma-operation.patch
ath5k-suspend-resume-fixes.patch
ath5k-fix-beacon-update-deadlock.patch
ath5k-mask-out-unneeded-interrupts.patch
ath5k-unify-resets.patch
mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch
mac80211-return-correct-error-return-from-ieee80211_wep_init.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

