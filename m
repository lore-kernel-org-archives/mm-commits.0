From: akpm@linux-foundation.org
Subject: +
 printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch added to -mm tree
Date: Wed, 23 Apr 2014 13:58:50 -0700
Message-ID: <5358298a.kGtSExKWSK0C0nLc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbaDWU6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Apr 2014 16:58:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz

Subject: + printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch added to -mm tree
To: jack@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 23 Apr 2014 13:58:50 -0700


The patch titled
     Subject: printk: release lockbuf_lock before calling console_trylock_for_printk()
has been added to the -mm tree.  Its filename is
     printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: printk: release lockbuf_lock before calling console_trylock_for_printk()

There's no reason to hold lockbuf_lock when entering
console_trylock_for_printk().

The first thing this function does is to call down_trylock(console_sem)
and if that fails it immediately unlocks lockbuf_lock.  So lockbuf_lock
isn't needed for that branch.  When down_trylock() succeeds, the rest of
console_trylock() is OK without lockbuf_lock (it is called without it from
other places), and the only remaining thing in
console_trylock_for_printk() is can_use_console() call.  For that call
console_sem is enough (it iterates all consoles and checks CON_ANYTIME
flag).

So we drop logbuf_lock before entering console_trylock_for_printk() which
simplifies the code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   49 +++++++++++++--------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff -puN kernel/printk/printk.c~printk-release-lockbuf_lock-before-calling-console_trylock_for_printk kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-release-lockbuf_lock-before-calling-console_trylock_for_printk
+++ a/kernel/printk/printk.c
@@ -249,9 +249,6 @@ static char __log_buf[__LOG_BUF_LEN] __a
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
-/* cpu currently holding logbuf_lock */
-static volatile unsigned int logbuf_cpu = UINT_MAX;
-
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
 {
@@ -1410,36 +1407,22 @@ static inline int can_use_console(unsign
  * messages from a 'printk'. Return true (and with the
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
- *
- * This gets called with the 'logbuf_lock' spinlock held and
- * interrupts disabled. It should return with 'lockbuf_lock'
- * released but interrupts still disabled.
  */
 static int console_trylock_for_printk(unsigned int cpu)
-	__releases(&logbuf_lock)
 {
-	int retval = 0, wake = 0;
-
-	if (console_trylock()) {
-		retval = 1;
-
-		/*
-		 * If we can't use the console, we need to release
-		 * the console semaphore by hand to avoid flushing
-		 * the buffer. We need to hold the console semaphore
-		 * in order to do this test safely.
-		 */
-		if (!can_use_console(cpu)) {
-			console_locked = 0;
-			wake = 1;
-			retval = 0;
-		}
-	}
-	logbuf_cpu = UINT_MAX;
-	raw_spin_unlock(&logbuf_lock);
-	if (wake)
+	if (!console_trylock())
+		return 0;
+	/*
+	 * If we can't use the console, we need to release the console
+	 * semaphore by hand to avoid flushing the buffer. We need to hold the
+	 * console semaphore in order to do this test safely.
+	 */
+	if (!can_use_console(cpu)) {
+		console_locked = 0;
 		up(&console_sem);
-	return retval;
+		return 0;
+	}
+	return 1;
 }
 
 int printk_delay_msec __read_mostly;
@@ -1572,6 +1555,9 @@ asmlinkage int vprintk_emit(int facility
 	unsigned long flags;
 	int this_cpu;
 	int printed_len = 0;
+	/* cpu currently holding logbuf_lock in this function */
+	static volatile unsigned int logbuf_cpu = UINT_MAX;
+
 
 	boot_delay_msec(level);
 	printk_delay();
@@ -1694,13 +1680,12 @@ asmlinkage int vprintk_emit(int facility
 						 dict, dictlen, text, text_len);
 	}
 
+	logbuf_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
 	 * users.
-	 *
-	 * The console_trylock_for_printk() function will release 'logbuf_lock'
-	 * regardless of whether it actually gets the console semaphore or not.
 	 */
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch
fanotify-create-fan_access-event-for-readdir.patch
fs-notify-markc-trivial-cleanup.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-split-code-for-making-free-space-in-the-log-buffer.patch
printk-ignore-too-long-messages.patch
printk-split-message-size-computation.patch
printk-shrink-too-long-messages.patch
printk-return-really-stored-message-length.patch
printk-remove-outdated-comment.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
printk-remove-separate-printk_sched-buffers-and-use-printk-buf-instead.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

