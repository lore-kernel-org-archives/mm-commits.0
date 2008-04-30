From: akpm@linux-foundation.org
Subject: - tty-bkl-pushdown-fix1.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:09:25 -0700
Message-ID: <200804300609.m3U69PUC030979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757420AbYD3GKG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:10:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     tty: BKL pushdown fix1
has been removed from the -mm tree.  Its filename was
     tty-bkl-pushdown-fix1.patch

This patch was dropped because it was folded into tty-bkl-pushdown.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: BKL pushdown fix1
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/compat_ioctl.c~tty-bkl-pushdown-fix1 fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~tty-bkl-pushdown-fix1
+++ a/fs/compat_ioctl.c
@@ -1046,7 +1046,7 @@ static int vt_check(struct file *file)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct vc_data *vc;
 	
-	if (file->f_op->ioctl != tty_ioctl)
+	if (file->f_op->unlocked_ioctl != tty_ioctl)
 		return -EINVAL;
 	                
 	tty = (struct tty_struct *)file->private_data;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown.patch
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

