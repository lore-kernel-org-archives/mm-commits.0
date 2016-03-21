From: akpm@linux-foundation.org
Subject: [merged]
 printk-set-may_schedule-for-some-of-console_trylock-callers.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:41:15 -0700
Message-ID: <56f0404b.9XkKIw1YxSwJXJl9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692AbcCUTVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, calvinowens@fb.com, davej@codemonkey.org.uk, jack@suse.com, kyle@kernel.org, pmladek@suse.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: set may_schedule for some of console_trylock() callers
has been removed from the -mm tree.  Its filename was
     printk-set-may_schedule-for-some-of-console_trylock-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: printk: set may_schedule for some of console_trylock() callers

console_unlock() allows to cond_resched() if its caller has set
`console_may_schedule' to 1, since 8d91f8b15361 ("printk: do
cond_resched() between lines while outputting to consoles").

The rules are:
-- console_lock() always sets `console_may_schedule' to 1
-- console_trylock() always sets `console_may_schedule' to 0

However, console_trylock() callers (among them is printk()) do not always
call printk() from atomic contexts, and some of them can cond_resched() in
console_unlock(), so console_trylock() can set `console_may_schedule' to 1
for such processes.

For !CONFIG_PREEMPT_COUNT kernels, however, console_trylock()
always sets `console_may_schedule' to 0.

It's possible to drop explicit preempt_disable()/preempt_enable()
in vprintk_emit(), because console_unlock() and console_trylock()
are now smart enough:
a) console_unlock() does not cond_resched() when it's unsafe
  (console_trylock() takes care of that)
b) console_unlock() does can_use_console() check.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Jan Kara <jack@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Kyle McMartin <kyle@kernel.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Calvin Owens <calvinowens@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN kernel/printk/printk.c~printk-set-may_schedule-for-some-of-console_trylock-callers kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-set-may_schedule-for-some-of-console_trylock-callers
+++ a/kernel/printk/printk.c
@@ -1758,20 +1758,12 @@ asmlinkage int vprintk_emit(int facility
 	if (!in_sched) {
 		lockdep_off();
 		/*
-		 * Disable preemption to avoid being preempted while holding
-		 * console_sem which would prevent anyone from printing to
-		 * console
-		 */
-		preempt_disable();
-
-		/*
 		 * Try to acquire and then immediately release the console
 		 * semaphore.  The release will print out buffers and wake up
 		 * /dev/kmsg and syslog() users.
 		 */
 		if (console_trylock())
 			console_unlock();
-		preempt_enable();
 		lockdep_on();
 	}
 
@@ -2122,7 +2114,20 @@ int console_trylock(void)
 		return 0;
 	}
 	console_locked = 1;
-	console_may_schedule = 0;
+	/*
+	 * When PREEMPT_COUNT disabled we can't reliably detect if it's
+	 * safe to schedule (e.g. calling printk while holding a spin_lock),
+	 * because preempt_disable()/preempt_enable() are just barriers there
+	 * and preempt_count() is always 0.
+	 *
+	 * RCU read sections have a separate preemption counter when
+	 * PREEMPT_RCU enabled thus we must take extra care and check
+	 * rcu_preempt_depth(), otherwise RCU read sections modify
+	 * preempt_count().
+	 */
+	console_may_schedule = !oops_in_progress &&
+			preemptible() &&
+			!rcu_preempt_depth();
 	return 1;
 }
 EXPORT_SYMBOL(console_trylock);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are


