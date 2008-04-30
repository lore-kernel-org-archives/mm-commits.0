From: akpm@linux-foundation.org
Subject: - misc-phantom-fix-poll.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:13 -0700
Message-ID: <200804300540.m3U5eDGx028941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbYD3FkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Misc, phantom, fix poll
has been removed from the -mm tree.  Its filename was
     misc-phantom-fix-poll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Misc, phantom, fix poll
From: Jiri Slaby <jirislaby@gmail.com>

Return ERR even if there are pending data, but hw is not running.  Do not
decrement count in poll, do it in ioctl, where data are actually read.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/misc/phantom.c~misc-phantom-fix-poll drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~misc-phantom-fix-poll
+++ a/drivers/misc/phantom.c
@@ -169,6 +169,7 @@ static long phantom_ioctl(struct file *f
 		for (i = 0; i < m; i++)
 			if (rs.mask & BIT(i))
 				rs.values[i] = ioread32(dev->iaddr + i);
+		atomic_set(&dev->counter, 0);
 		spin_unlock_irqrestore(&dev->regs_lock, flags);
 
 		if (copy_to_user(argp, &rs, sizeof(rs)))
@@ -254,11 +255,12 @@ static unsigned int phantom_poll(struct 
 
 	pr_debug("phantom_poll: %d\n", atomic_read(&dev->counter));
 	poll_wait(file, &dev->wait, wait);
-	if (atomic_read(&dev->counter)) {
+
+	if (!(dev->status & PHB_RUNNING))
+		mask = POLLERR;
+	else if (atomic_read(&dev->counter))
 		mask = POLLIN | POLLRDNORM;
-		atomic_dec(&dev->counter);
-	} else if ((dev->status & PHB_RUNNING) == 0)
-		mask = POLLIN | POLLRDNORM | POLLERR;
+
 	pr_debug("phantom_poll end: %x/%d\n", mask, atomic_read(&dev->counter));
 
 	return mask;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
char-moxa-remove-static-isa-support.patch
char-moxa-cleanup-module-param-passed-isa-init.patch
char-moxa-pci-io-space-fixup.patch
char-moxa-fix-tiocg-ssoftcar-param.patch
char-moxa-add-firmware-loading.patch
char-moxa-merge-c2xx-and-c320-firmware-loading.patch
char-moxa-remove-port-port.patch
char-moxa-remove-unused-port-entries.patch
char-moxa-centralize-board-readiness.patch
char-moxa-centralize-board-readiness-warning-fix.patch
char-moxa-timer-cleanup.patch
char-moxa-ioctl-cleanup.patch
char-moxa-merge-2-poll-functions.patch
char-moxa-cleanup-rx-tx.patch
char-moxa-serialise-timer.patch
char-moxa-rework-open-close.patch
char-moxa-little-cleanup.patch
char-moxa-remove-useless-tty-functions.patch
char-moxa-introduce-moxa_is_320-macro.patch
char-moxa-notify-about-board-readiness.patch
char-moxa-update-credits.patch
char-moxa-add-firmware-loading-fix.patch
char-espc-fix-possible-double-unlock.patch
char-ip2-macros-cleanup.patch
cyclades-coding-style-review.patch
cyclades-use-ioremap_nocache-for-clarity-as-proposed.patch
char-rio-fix-cirrus-defines.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch
tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
amiserial-switch-put-char-to-return-success-fail.patch
char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch
mxser-switch-to-put_char-being-int.patch
pcmcia-serial-to-int-put_char-method.patch
riscom-rocket-switch-to-int-put_char-method.patch
serial167-switch-to-int-put_char-method.patch
specialix-switch-to-int-put_char-method.patch
synclink-series-switch-to-int-put_char-method.patch
consoles-switch-to-int-put_char-method.patch
isicom-bring-into-coding-style.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-isicom-fix.patch
riscom8-coding-style.patch
epca-coding-style.patch
esp-clean-up-to-modern-coding-style.patch
isicom-fix-buffer-allocation.patch
char-serial-switch-drivers-to-ioremap_nocache.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

