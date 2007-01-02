From: akpm@osdl.org
Subject: + char-moxa-remove-hangup-bottomhalf.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:52:54 -0800
Message-ID: <200701022152.l02Lqski031005@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35909 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbXABVxG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:53:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, remove hangup bottomhalf
has been added to the -mm tree.  Its filename is
     char-moxa-remove-hangup-bottomhalf.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, remove hangup bottomhalf
From: Jiri Slaby <jirislaby@gmail.com>

call tty_hangup directly, we do not need a bottomhalf for this.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |   25 +++----------------------
 1 files changed, 3 insertions(+), 22 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-remove-hangup-bottomhalf drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-remove-hangup-bottomhalf
+++ a/drivers/char/moxa.c
@@ -159,7 +159,6 @@ struct moxa_str {
 	int cflag;
 	wait_queue_head_t open_wait;
 	wait_queue_head_t close_wait;
-	struct work_struct tqueue;
 };
 
 struct mxser_mstatus {
@@ -178,9 +177,6 @@ static struct mxser_mstatus GMStatus[MAX
 #define EMPTYWAIT	0x4
 #define THROTTLE	0x8
 
-/* event */
-#define MOXA_EVENT_HANGUP	1
-
 #define SERIAL_DO_RESTART
 
 
@@ -213,7 +209,6 @@ module_param(verbose, bool, 0644);
 /*
  * static functions:
  */
-static void do_moxa_softint(struct work_struct *);
 static int moxa_open(struct tty_struct *, struct file *);
 static void moxa_close(struct tty_struct *, struct file *);
 static int moxa_write(struct tty_struct *, const unsigned char *, int);
@@ -354,7 +349,6 @@ static int __init moxa_init(void)
 	for (i = 0, ch = moxaChannels; i < MAX_PORTS; i++, ch++) {
 		ch->type = PORT_16550A;
 		ch->port = i;
-		INIT_WORK(&ch->tqueue, do_moxa_softint);
 		ch->close_delay = 5 * HZ / 10;
 		ch->closing_wait = 30 * HZ;
 		ch->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
@@ -482,20 +476,6 @@ static void __exit moxa_exit(void)
 module_init(moxa_init);
 module_exit(moxa_exit);
 
-static void do_moxa_softint(struct work_struct *work)
-{
-	struct moxa_str *ch = container_of(work, struct moxa_str, tqueue);
-	struct tty_struct *tty;
-
-	if (ch && (tty = ch->tty)) {
-		if (test_and_clear_bit(MOXA_EVENT_HANGUP, &ch->event)) {
-			tty_hangup(tty);	/* FIXME: module removal race here - AKPM */
-			wake_up_interruptible(&ch->open_wait);
-			ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
-		}
-	}
-}
-
 static int moxa_open(struct tty_struct *tty, struct file *filp)
 {
 	struct moxa_str *ch;
@@ -908,8 +888,9 @@ static void moxa_poll(unsigned long igno
 					if (MoxaPortDCDON(ch->port))
 						wake_up_interruptible(&ch->open_wait);
 					else {
-						set_bit(MOXA_EVENT_HANGUP, &ch->event);
-						schedule_work(&ch->tqueue);
+						tty_hangup(tp);
+						wake_up_interruptible(&ch->open_wait);
+						ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
 					}
 				}
 			}
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
