From: akpm@linux-foundation.org
Subject: + rtc-remove-the-bkl.patch added to -mm tree
Date: Mon, 27 Oct 2008 13:56:25 -0700
Message-ID: <200810272056.m9RKuP88025438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbYJ0U4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 16:56:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidjon@xenontk.org, alan@lxorguk.ukuu.org.uk, corbet@lwn.net, david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     RTC: remove the BKL
has been added to the -mm tree.  Its filename is
     rtc-remove-the-bkl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: RTC: remove the BKL
From: David John <davidjon@xenontk.org>

Remove calls to the BKL since concurrent access is protected by the spin
lock rtc_lock.

Signed-off-by: David John <davidjon@xenontk.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN drivers/char/rtc.c~rtc-remove-the-bkl drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-remove-the-bkl
+++ a/drivers/char/rtc.c
@@ -48,9 +48,10 @@
  *		CONFIG_HPET_EMULATE_RTC
  *	1.12a	Maciej W. Rozycki: Handle memory-mapped chips properly.
  *	1.12ac	Alan Cox: Allow read access to the day of week register
+ *	1.12b	David John: Remove calls to the BKL.
  */
 
-#define RTC_VERSION		"1.12ac"
+#define RTC_VERSION		"1.12b"
 
 /*
  *	Note that *all* calls to CMOS_READ and CMOS_WRITE are done with
@@ -73,7 +74,6 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/sysctl.h>
 #include <linux/wait.h>
 #include <linux/bcd.h>
@@ -182,8 +182,8 @@ static int rtc_proc_open(struct inode *i
 
 /*
  * rtc_status is never changed by rtc_interrupt, and ioctl/open/close is
- * protected by the big kernel lock. However, ioctl can still disable the timer
- * in rtc_status and then with del_timer after the interrupt has read
+ * protected by the spin lock rtc_lock. However, ioctl can still disable the
+ * timer in rtc_status and then with del_timer after the interrupt has read
  * rtc_status but before mod_timer is called, which would then reenable the
  * timer (but you would need to have an awful timing before you'd trip on it)
  */
@@ -720,9 +720,7 @@ static int rtc_do_ioctl(unsigned int cmd
 static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
-	lock_kernel();
 	ret = rtc_do_ioctl(cmd, arg, 0);
-	unlock_kernel();
 	return ret;
 }
 
@@ -731,12 +729,8 @@ static long rtc_ioctl(struct file *file,
  *	Also clear the previous interrupt data on an open, and clean
  *	up things on a close.
  */
-
-/* We use rtc_lock to protect against concurrent opens. So the BKL is not
- * needed here. Or anywhere else in this driver. */
 static int rtc_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
 	spin_lock_irq(&rtc_lock);
 
 	if (rtc_status & RTC_IS_OPEN)
@@ -746,12 +740,10 @@ static int rtc_open(struct inode *inode,
 
 	rtc_irq_data = 0;
 	spin_unlock_irq(&rtc_lock);
-	unlock_kernel();
 	return 0;
 
 out_busy:
 	spin_unlock_irq(&rtc_lock);
-	unlock_kernel();
 	return -EBUSY;
 }
 
@@ -802,7 +794,6 @@ no_irq:
 }
 
 #ifdef RTC_IRQ
-/* Called without the kernel lock - fine */
 static unsigned int rtc_poll(struct file *file, poll_table *wait)
 {
 	unsigned long l;
_

Patches currently in -mm which might be from davidjon@xenontk.org are

rtc-remove-the-bkl.patch

