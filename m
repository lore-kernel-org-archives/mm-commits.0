From: akpm@linux-foundation.org
Subject: - char-moxa-centralize-board-readiness-warning-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:11:56 -0700
Message-ID: <200804300611.m3U6Buqw031051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758279AbYD3GL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:11:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, fix compiler warning
has been removed from the -mm tree.  Its filename was
     char-moxa-centralize-board-readiness-warning-fix.patch

This patch was dropped because it was folded into char-moxa-centralize-board-readiness.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, fix compiler warning
From: Jiri Slaby <jirislaby@gmail.com>

On CONFIG_MOXA_INTELLIO=y, this warning was emitted:
drivers/char/moxa.c: In function `moxa_init':
drivers/char/moxa.c:1000: warning: unused variable `i'

Move it into the conditional section where is only used.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/moxa.c~char-moxa-centralize-board-readiness-warning-fix drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-centralize-board-readiness-warning-fix
+++ a/drivers/char/moxa.c
@@ -826,7 +826,7 @@ static struct pci_driver moxa_pci_driver
 
 static int __init moxa_init(void)
 {
-	unsigned int i, isabrds = 0;
+	unsigned int isabrds = 0;
 	int retval = 0;
 
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
@@ -862,6 +862,7 @@ static int __init moxa_init(void)
 #ifdef MODULE
 	{
 	struct moxa_board_conf *brd = moxa_boards;
+	unsigned int i;
 	for (i = 0; i < MAX_BOARDS; i++) {
 		if (!baseaddr[i])
 			break;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown.patch
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

