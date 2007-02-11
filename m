From: akpm@linux-foundation.org
Subject: - char-moxa-use-del_timer_sync.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:37 -0800
Message-ID: <200702112252.l1BMqbMo016032@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60278 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbXBKWwj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, use del_timer_sync
has been removed from the -mm tree.  Its filename was
     char-moxa-use-del_timer_sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, use del_timer_sync
From: Jiri Slaby <jirislaby@gmail.com>

Use del_timer_sync in most timer deletions, we don't want to oops in the timer
function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
