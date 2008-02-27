From: akpm@linux-foundation.org
Subject: + char-moxa-serialise-timer.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:13:19 -0800
Message-ID: <200802272313.m1RNDJYO003289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762198AbYB0XNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:13:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk


The patch titled
     Char: moxa, serialise timer
has been added to the -mm tree.  Its filename is
     char-moxa-serialise-timer.patch

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
Subject: Char: moxa, serialise timer
From: Jiri Slaby <jirislaby@gmail.com>

- del timer after we are sure it won't be fired again
- make timer scheduling atomic
- don't reschedule timer when all cards have gone

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-serialise-timer drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-serialise-timer
+++ a/drivers/char/moxa.c
@@ -846,10 +846,11 @@ static int moxa_init_board(struct moxa_b
 	if (ret)
 		goto err_free;
 
+	spin_lock_bh(&moxa_lock);
 	brd->ready = 1;
-
 	if (!timer_pending(&moxaTimer))
 		mod_timer(&moxaTimer, jiffies + HZ / 50);
+	spin_unlock_bh(&moxa_lock);
 
 	return 0;
 err_free:
@@ -1040,13 +1041,6 @@ static void __exit moxa_exit(void)
 {
 	int i;
 
-	del_timer_sync(&moxaTimer);
-
-	if (tty_unregister_driver(moxaDriver))
-		printk(KERN_ERR "Couldn't unregister MOXA Intellio family "
-				"serial driver\n");
-	put_tty_driver(moxaDriver);
-
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&moxa_pci_driver);
 #endif
@@ -1054,6 +1048,13 @@ static void __exit moxa_exit(void)
 	for (i = 0; i < MAX_BOARDS; i++) /* ISA boards */
 		if (moxa_boards[i].ready)
 			moxa_board_deinit(&moxa_boards[i]);
+
+	del_timer_sync(&moxaTimer);
+
+	if (tty_unregister_driver(moxaDriver))
+		printk(KERN_ERR "Couldn't unregister MOXA Intellio family "
+				"serial driver\n");
+	put_tty_driver(moxaDriver);
 }
 
 module_init(moxa_init);
@@ -1431,7 +1432,7 @@ static void moxa_poll(unsigned long igno
 {
 	struct moxa_board_conf *brd;
 	u16 __iomem *ip;
-	unsigned int card, port;
+	unsigned int card, port, served = 0;
 
 	spin_lock(&moxa_lock);
 	for (card = 0; card < MAX_BOARDS; card++) {
@@ -1439,6 +1440,8 @@ static void moxa_poll(unsigned long igno
 		if (!brd->ready)
 			continue;
 
+		served++;
+
 		ip = NULL;
 		if (readb(brd->intPend) == 0xff)
 			ip = brd->intTable + readb(brd->intNdx);
@@ -1459,9 +1462,10 @@ static void moxa_poll(unsigned long igno
 		}
 	}
 	moxaLowWaterChk = 0;
-	spin_unlock(&moxa_lock);
 
-	mod_timer(&moxaTimer, jiffies + HZ / 50);
+	if (served)
+		mod_timer(&moxaTimer, jiffies + HZ / 50);
+	spin_unlock(&moxa_lock);
 }
 
 /******************************************************************************/
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
wdev-ath5k-typecheck-on-nondebug.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
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
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
