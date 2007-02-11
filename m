From: akpm@linux-foundation.org
Subject: - char-moxa-remove-unused-allocated-page.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:19 -0800
Message-ID: <200702112252.l1BMqJgA016005@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60243 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768AbXBKWwV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, remove unused allocated page
has been removed from the -mm tree.  Its filename was
     char-moxa-remove-unused-allocated-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, remove unused allocated page
From: Jiri Slaby <jirislaby@gmail.com>

moxaXmitBuff is almost unused -- only one byte from the whole PAGE_SIZE bytes
is used.  Do not alloc so much space for almost anything.  Also remove lock
protecting this page allocation.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-remove-unused-allocated-page drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-remove-unused-allocated-page
+++ a/drivers/char/moxa.c
@@ -212,12 +212,10 @@ module_param(verbose, bool, 0644);
 
 static struct tty_driver *moxaDriver;
 static struct moxa_str moxaChannels[MAX_PORTS];
-static unsigned char *moxaXmitBuff;
 static int moxaTimer_on;
 static struct timer_list moxaTimer;
 static int moxaEmptyTimer_on[MAX_PORTS];
 static struct timer_list moxaEmptyTimer[MAX_PORTS];
-static struct semaphore moxaBuffSem;
 
 /*
  * static functions:
@@ -343,7 +341,6 @@ static int __init moxa_init(void)
 	if (!moxaDriver)
 		return -ENOMEM;
 
-	init_MUTEX(&moxaBuffSem);
 	moxaDriver->owner = THIS_MODULE;
 	moxaDriver->name = "ttyMX";
 	moxaDriver->major = ttymajor;
@@ -360,8 +357,6 @@ static int __init moxa_init(void)
 	moxaDriver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(moxaDriver, &moxa_ops);
 
-	moxaXmitBuff = NULL;
-
 	for (i = 0, ch = moxaChannels; i < MAX_PORTS; i++, ch++) {
 		ch->type = PORT_16550A;
 		ch->port = i;
@@ -533,7 +528,6 @@ static int moxa_open(struct tty_struct *
 	struct moxa_str *ch;
 	int port;
 	int retval;
-	unsigned long page;
 
 	port = PORTNO(tty);
 	if (port == MAX_PORTS) {
@@ -543,21 +537,6 @@ static int moxa_open(struct tty_struct *
 		tty->driver_data = NULL;
 		return (-ENODEV);
 	}
-	down(&moxaBuffSem);
-	if (!moxaXmitBuff) {
-		page = get_zeroed_page(GFP_KERNEL);
-		if (!page) {
-			up(&moxaBuffSem);
-			return (-ENOMEM);
-		}
-		/* This test is guarded by the BuffSem so no longer needed
-		   delete me in 2.5 */
-		if (moxaXmitBuff)
-			free_page(page);
-		else
-			moxaXmitBuff = (unsigned char *) page;
-	}
-	up(&moxaBuffSem);
 
 	ch = &moxaChannels[port];
 	ch->count++;
@@ -739,8 +718,7 @@ static void moxa_put_char(struct tty_str
 		return;
 	port = ch->port;
 	spin_lock_irqsave(&moxa_lock, flags);
-	moxaXmitBuff[0] = c;
-	MoxaPortWriteData(port, moxaXmitBuff, 1);
+	MoxaPortWriteData(port, &c, 1);
 	spin_unlock_irqrestore(&moxa_lock, flags);
 	/************************************************
 	if ( !(ch->statusflags & LOWWAIT) && (MoxaPortTxFree(port) <= 100) )
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
