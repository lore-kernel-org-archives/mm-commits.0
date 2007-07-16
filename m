From: akpm@linux-foundation.org
Subject: - char-ip2-use-msleep-for-sleeping.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:05 -0700
Message-ID: <200707162055.l6GKt53S001882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48067 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760068AbXGPVJh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:09:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: ip2, use msleep for sleeping
has been removed from the -mm tree.  Its filename was
     char-ip2-use-msleep-for-sleeping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: ip2, use msleep for sleeping
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/i2ellis.c |   44 -----------------------------------
 1 file changed, 1 insertion(+), 43 deletions(-)

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

origin.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
char-stallion-remove-user-class-report-request.patch
char-istallion-initlocking-fixes-try-2.patch
stallion-remove-unneeded-lock_kernel.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
