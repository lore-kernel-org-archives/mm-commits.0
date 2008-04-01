From: akpm@linux-foundation.org
Subject: + char-moxa-centralize-board-readiness-warning-fix.patch added to -mm tree
Date: Tue, 01 Apr 2008 12:28:35 -0700
Message-ID: <200804011928.m31JSZmG009379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756507AbYDAT2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 15:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, fix compiler warning
has been added to the -mm tree.  Its filename is
     char-moxa-centralize-board-readiness-warning-fix.patch

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

char-ip2-fix-sparse-warnings.patch
char-rio-fix-sparse-warnings.patch
git-hid.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
git-net.patch
capabilities-implement-per-process-securebits-fix.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
misc-phantom-consistent-whitespace.patch
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
char-rio-fix-cirrus-defines.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

