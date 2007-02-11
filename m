From: akpm@linux-foundation.org
Subject: - char-moxa-remove-hangup-bottomhalf.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:25 -0800
Message-ID: <200702112252.l1BMqPIC016014@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60256 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800AbXBKWw1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, remove hangup bottomhalf
has been removed from the -mm tree.  Its filename was
     char-moxa-remove-hangup-bottomhalf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, remove hangup bottomhalf
From: Jiri Slaby <jirislaby@gmail.com>

Call tty_hangup directly, we do not need a bottomhalf for this.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

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
