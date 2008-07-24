From: akpm@linux-foundation.org
Subject: - vt-hold-console_sem-across-sysfs-operations.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:28:40 -0700
Message-ID: <200807242328.m6ONSe98011291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618AbYGXX2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, aris@ruivo.org, mm-commits@vger.kernel.org


The patch titled
     vt: hold console_sem across sysfs operations
has been removed from the -mm tree.  Its filename was
     vt-hold-console_sem-across-sysfs-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: hold console_sem across sysfs operations
From: Jiri Slaby <jirislaby@gmail.com>

Hold console sem while creating/destroying sysfs files.  Serialisation is
so far done by BKL held in tty release_dev and chrdev_open, but no other
locks are held in open path.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Aristeu Rozanski <aris@ruivo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/vt.c~vt-hold-console_sem-across-sysfs-operations drivers/char/vt.c
--- a/drivers/char/vt.c~vt-hold-console_sem-across-sysfs-operations
+++ a/drivers/char/vt.c
@@ -2749,8 +2749,8 @@ static int con_open(struct tty_struct *t
 				tty->termios->c_iflag |= IUTF8;
 			else
 				tty->termios->c_iflag &= ~IUTF8;
-			release_console_sem();
 			vcs_make_sysfs(tty);
+			release_console_sem();
 			return ret;
 		}
 	}
@@ -2775,8 +2775,8 @@ static void con_close(struct tty_struct 
 		if (vc)
 			vc->vc_tty = NULL;
 		tty->driver_data = NULL;
-		release_console_sem();
 		vcs_remove_sysfs(tty);
+		release_console_sem();
 		mutex_unlock(&tty_mutex);
 		/*
 		 * tty_mutex is released, but we still hold BKL, so there is
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
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
drivers-misc-phantom-note-pci.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

