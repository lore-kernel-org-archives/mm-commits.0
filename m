From: akpm@osdl.org
Subject: + char-moxa-remove-unused-allocated-page.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:52:42 -0800
Message-ID: <200701022152.l02LqgVf030989@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35890 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbXABVww (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:52:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, remove unused allocated page
has been added to the -mm tree.  Its filename is
     char-moxa-remove-unused-allocated-page.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, remove unused allocated page
From: Jiri Slaby <jirislaby@gmail.com>

moxaXmitBuff is almost unused -- only one byte from the whole PAGE_SIZE bytes
is used.  Do not alloc so much space for almost anything.  Also remove lock
protecting this page allocation.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |   24 +-----------------------
 1 files changed, 1 insertion(+), 23 deletions(-)

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
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
shrink_slab-handle-bad-shrinkers.patch
