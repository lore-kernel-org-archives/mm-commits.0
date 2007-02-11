From: akpm@linux-foundation.org
Subject: - char-moxa-timers-cleanup.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:23 -0800
Message-ID: <200702112252.l1BMqNGX016011@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60251 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932799AbXBKWwZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, timers cleanup
has been removed from the -mm tree.  Its filename was
     char-moxa-timers-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, timers cleanup
From: Jiri Slaby <jirislaby@gmail.com>

Use kernel macros and functions for timer encapsulation -- do not access
fileds directly.  Also del_timer on inactive is legal, so that noting if it
runs is senseless, delete these variables.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   54 ++++++++++--------------------------------
 1 file changed, 14 insertions(+), 40 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-timers-cleanup drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-timers-cleanup
+++ a/drivers/char/moxa.c
@@ -210,13 +210,6 @@ module_param_array(numports, int, NULL, 
 module_param(ttymajor, int, 0);
 module_param(verbose, bool, 0644);
 
-static struct tty_driver *moxaDriver;
-static struct moxa_str moxaChannels[MAX_PORTS];
-static int moxaTimer_on;
-static struct timer_list moxaTimer;
-static int moxaEmptyTimer_on[MAX_PORTS];
-static struct timer_list moxaEmptyTimer[MAX_PORTS];
-
 /*
  * static functions:
  */
@@ -300,6 +293,10 @@ static const struct tty_operations moxa_
 	.tiocmset = moxa_tiocmset,
 };
 
+static struct tty_driver *moxaDriver;
+static struct moxa_str moxaChannels[MAX_PORTS];
+static DEFINE_TIMER(moxaTimer, moxa_poll, 0, 0);
+static struct timer_list moxaEmptyTimer[MAX_PORTS];
 static DEFINE_SPINLOCK(moxa_lock);
 
 #ifdef CONFIG_PCI
@@ -372,17 +369,11 @@ static int __init moxa_init(void)
 		put_tty_driver(moxaDriver);
 		return -1;
 	}
-	for (i = 0; i < MAX_PORTS; i++) {
-		init_timer(&moxaEmptyTimer[i]);
-		moxaEmptyTimer[i].function = check_xmit_empty;
-		moxaEmptyTimer[i].data = (unsigned long) & moxaChannels[i];
-	}
+	for (i = 0; i < MAX_PORTS; i++)
+		setup_timer(&moxaEmptyTimer[i], check_xmit_empty,
+				(unsigned long)&moxaChannels[i]);
 
-	init_timer(&moxaTimer);
-	moxaTimer.function = moxa_poll;
-	moxaTimer.expires = jiffies + (HZ / 50);
-	moxaTimer_on = 1;
-	add_timer(&moxaTimer);
+	mod_timer(&moxaTimer, jiffies + HZ / 50);
 
 	/* Find the boards defined in source code */
 	numBoards = 0;
@@ -468,12 +459,10 @@ static void __exit moxa_exit(void)
 	if (verbose)
 		printk("Unloading module moxa ...\n");
 
-	if (moxaTimer_on)
-		del_timer(&moxaTimer);
+	del_timer(&moxaTimer);
 
 	for (i = 0; i < MAX_PORTS; i++)
-		if (moxaEmptyTimer_on[i])
-			del_timer(&moxaEmptyTimer[i]);
+		del_timer(&moxaEmptyTimer[i]);
 
 	if (tty_unregister_driver(moxaDriver))
 		printk("Couldn't unregister MOXA Intellio family serial driver\n");
@@ -589,7 +578,6 @@ static void moxa_close(struct tty_struct
 	if (ch->asyncflags & ASYNC_INITIALIZED) {
 		setup_empty_event(tty);
 		tty_wait_until_sent(tty, 30 * HZ);	/* 30 seconds timeout */
-		moxaEmptyTimer_on[ch->port] = 0;
 		del_timer(&moxaEmptyTimer[ch->port]);
 	}
 	shut_down(ch);
@@ -885,14 +873,10 @@ static void moxa_poll(unsigned long igno
 	struct tty_struct *tp;
 	int i, ports;
 
-	moxaTimer_on = 0;
 	del_timer(&moxaTimer);
 
 	if (MoxaDriverPoll() < 0) {
-		moxaTimer.function = moxa_poll;
-		moxaTimer.expires = jiffies + (HZ / 50);
-		moxaTimer_on = 1;
-		add_timer(&moxaTimer);
+		mod_timer(&moxaTimer, jiffies + HZ / 50);
 		return;
 	}
 	for (card = 0; card < MAX_BOARDS; card++) {
@@ -932,10 +916,7 @@ static void moxa_poll(unsigned long igno
 		}
 	}
 
-	moxaTimer.function = moxa_poll;
-	moxaTimer.expires = jiffies + (HZ / 50);
-	moxaTimer_on = 1;
-	add_timer(&moxaTimer);
+	mod_timer(&moxaTimer, jiffies + HZ / 50);
 }
 
 /******************************************************************************/
@@ -1062,11 +1043,7 @@ static void setup_empty_event(struct tty
 
 	spin_lock_irqsave(&moxa_lock, flags);
 	ch->statusflags |= EMPTYWAIT;
-	moxaEmptyTimer_on[ch->port] = 0;
-	del_timer(&moxaEmptyTimer[ch->port]);
-	moxaEmptyTimer[ch->port].expires = jiffies + HZ;
-	moxaEmptyTimer_on[ch->port] = 1;
-	add_timer(&moxaEmptyTimer[ch->port]);
+	mod_timer(&moxaEmptyTimer[ch->port], jiffies + HZ);
 	spin_unlock_irqrestore(&moxa_lock, flags);
 }
 
@@ -1075,7 +1052,6 @@ static void check_xmit_empty(unsigned lo
 	struct moxa_str *ch;
 
 	ch = (struct moxa_str *) data;
-	moxaEmptyTimer_on[ch->port] = 0;
 	del_timer(&moxaEmptyTimer[ch->port]);
 	if (ch->tty && (ch->statusflags & EMPTYWAIT)) {
 		if (MoxaPortTxQueue(ch->port) == 0) {
@@ -1083,9 +1059,7 @@ static void check_xmit_empty(unsigned lo
 			tty_wakeup(ch->tty);
 			return;
 		}
-		moxaEmptyTimer[ch->port].expires = jiffies + HZ;
-		moxaEmptyTimer_on[ch->port] = 1;
-		add_timer(&moxaEmptyTimer[ch->port]);
+		mod_timer(&moxaEmptyTimer[ch->port], jiffies + HZ);
 	} else
 		ch->statusflags &= ~EMPTYWAIT;
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
