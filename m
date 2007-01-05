From: akpm@osdl.org
Subject: + char-moxa-use-del_timer_sync.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:09:50 -0800
Message-ID: <200701052009.l05K9obr030996@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56848 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbXAEUJx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:09:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, use del_timer_sync
has been added to the -mm tree.  Its filename is
     char-moxa-use-del_timer_sync.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, use del_timer_sync
From: Jiri Slaby <jirislaby@gmail.com>

Use del_timer_sync in most timer deletions, we don't want to oops in the timer
function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-use-del_timer_sync drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-use-del_timer_sync
+++ a/drivers/char/moxa.c
@@ -424,10 +424,10 @@ static void __exit moxa_exit(void)
 	if (verbose)
 		printk("Unloading module moxa ...\n");
 
-	del_timer(&moxaTimer);
+	del_timer_sync(&moxaTimer);
 
 	for (i = 0; i < MAX_PORTS; i++)
-		del_timer(&moxaEmptyTimer[i]);
+		del_timer_sync(&moxaEmptyTimer[i]);
 
 	if (tty_unregister_driver(moxaDriver))
 		printk("Couldn't unregister MOXA Intellio family serial driver\n");
@@ -529,7 +529,7 @@ static void moxa_close(struct tty_struct
 	if (ch->asyncflags & ASYNC_INITIALIZED) {
 		setup_empty_event(tty);
 		tty_wait_until_sent(tty, 30 * HZ);	/* 30 seconds timeout */
-		del_timer(&moxaEmptyTimer[ch->port]);
+		del_timer_sync(&moxaEmptyTimer[ch->port]);
 	}
 	shut_down(ch);
 	MoxaPortFlushData(port, 2);
@@ -1004,7 +1004,7 @@ static void check_xmit_empty(unsigned lo
 	struct moxa_str *ch;
 
 	ch = (struct moxa_str *) data;
-	del_timer(&moxaEmptyTimer[ch->port]);
+	del_timer_sync(&moxaEmptyTimer[ch->port]);
 	if (ch->tty && (ch->statusflags & EMPTYWAIT)) {
 		if (MoxaPortTxQueue(ch->port) == 0) {
 			ch->statusflags &= ~EMPTYWAIT;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-put-pdev.patch
char-mxser_new-upgrade-to-1915.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
char-moxa-macros-cleanup.patch
char-moxa-use-del_timer_sync.patch
char-moxa-remove-moxa_pci_devinfo.patch
char-moxa-variables-cleanup.patch
char-moxa-remove-useless-vairables.patch
char-moxa-pci_probing-prepare.patch
char-moxa-pci-probing.patch
shrink_slab-handle-bad-shrinkers.patch
