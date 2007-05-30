From: akpm@linux-foundation.org
Subject: + char-ip2-use-msleep-for-sleeping.patch added to -mm tree
Date: Tue, 29 May 2007 17:08:39 -0700
Message-ID: <200705300008.l4U08dEV015013@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbXE3AIm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 20:08:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: ip2, use msleep for sleeping
has been added to the -mm tree.  Its filename is
     char-ip2-use-msleep-for-sleeping.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: ip2, use msleep for sleeping
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/i2ellis.c |   44 -----------------------------------
 1 files changed, 1 insertion(+), 43 deletions(-)

diff -puN drivers/char/ip2/i2ellis.c~char-ip2-use-msleep-for-sleeping drivers/char/ip2/i2ellis.c
--- a/drivers/char/ip2/i2ellis.c~char-ip2-use-msleep-for-sleeping
+++ a/drivers/char/ip2/i2ellis.c
@@ -43,8 +43,6 @@ static void iiEnableMailIrqIIEX(i2eBordS
 static void iiWriteMaskII(i2eBordStrPtr, unsigned char);
 static void iiWriteMaskIIEX(i2eBordStrPtr, unsigned char);
 
-static void ii2DelayTimer(unsigned int);
-static void ii2DelayWakeup(unsigned long id);
 static void ii2Nop(void);
 
 //***************
@@ -55,8 +53,6 @@ static int ii2Safe;         // Safe I/O 
 
 static int iiDelayed;	// Set when the iiResetDelay function is
 							// called. Cleared when ANY board is reset.
-static struct timer_list * pDelayTimer;   // Used by iiDelayTimer
-static wait_queue_head_t pDelayWait;    // Used by iiDelayTimer
 static rwlock_t Dl_spinlock;
 
 //********
@@ -86,9 +82,6 @@ static rwlock_t Dl_spinlock;
 static void
 iiEllisInit(void)
 {
-	pDelayTimer = kmalloc ( sizeof (struct timer_list), GFP_KERNEL );
-	init_timer(pDelayTimer);
-	init_waitqueue_head(&pDelayWait);
 	LOCK_INIT(&Dl_spinlock);
 }
 
@@ -106,7 +99,6 @@ iiEllisInit(void)
 static void
 iiEllisCleanup(void)
 {
-	kfree(pDelayTimer);
 }
 
 //******************************************************************************
@@ -560,19 +552,6 @@ iiInitialize(i2eBordStrPtr pB)
 	COMPLETE(pB, I2EE_GOOD);
 }
 
-//=======================================================
-// Delay Routines
-//
-// iiDelayIO
-// iiNop
-//=======================================================
-
-static void
-ii2DelayWakeup(unsigned long id)
-{
-	wake_up_interruptible ( &pDelayWait );
-}
-
 //******************************************************************************
 // Function:   ii2DelayTimer(mseconds)
 // Parameters: mseconds - number of milliseconds to delay
@@ -594,28 +573,7 @@ ii2DelayWakeup(unsigned long id)
 static void
 ii2DelayTimer(unsigned int mseconds)
 {
-	wait_queue_t wait;
-
-	init_waitqueue_entry(&wait, current);
-
-	init_timer ( pDelayTimer );
-
-	add_wait_queue(&pDelayWait, &wait);
-
-	set_current_state( TASK_INTERRUPTIBLE );
-
-	pDelayTimer->expires  = jiffies + ( mseconds + 9 ) / 10;
-	pDelayTimer->function = ii2DelayWakeup;
-	pDelayTimer->data     = 0;
-
-	add_timer ( pDelayTimer );
-
-	schedule();
-
-	set_current_state( TASK_RUNNING );
-	remove_wait_queue(&pDelayWait, &wait);
-
-	del_timer ( pDelayTimer );
+	msleep_interruptible(mseconds);
 }
 
 #if 0
_

Patches currently in -mm which might be from jirislaby@gmail.com are

rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-mxser_new-fix-sparse-warning.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
char-genrtc-use-wait_event_interruptible.patch
char-n_r3964-use-wait_event_interruptible.patch
char-ip2-use-msleep-for-sleeping.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
shrink_slab-handle-bad-shrinkers.patch
