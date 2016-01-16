From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-do-cond_resched-between-lines-while-outputting-to-consoles-fix.patch removed from -mm tree
Date: Fri, 15 Jan 2016 16:35:32 -0800
Message-ID: <56999054.d1c1d8GS43AC4v/h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161321AbcAPAfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:35:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, calvinowens@fb.com, davej@codemonkey.org.uk, jack@suse.com, kyle@kernel.org, sergey.senozhatsky.work@gmail.com, stable@vger.kernel.org, ying.huang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: clear console_may_schedule on panic flushing
has been removed from the -mm tree.  Its filename was
     printk-do-cond_resched-between-lines-while-outputting-to-consoles-fix.patch

This patch was dropped because it was folded into printk-do-cond_resched-between-lines-while-outputting-to-consoles.patch

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: printk: clear console_may_schedule on panic flushing

Commit "printk: do cond_resched() between lines while outputting to
consoles" made console flushing perform cond_resched() after each line
if the context allows as determined by whether the console lock was
acquired with console_lock().  The condition is carried in
console_may_schedule.

During panic, console lock status is ignored and the messages are
forcefully flushed which is implemented by performing console_trylock();
console_unlock(); sequence ignoring whether trylock succeeds or fails. 
This means that the emergency flushing, after trylock failure, may enter
flushing path with console_may_schedule set from the actual holder.

As a system may panic from any context, this can lead to
cond_resched() being invoked from a non-sleepable context triggering
an extra warning dump while panicking which is noisy and can be
confusing.  Besides, even when panicking from a sleepable context, we
don't want to be yielding during emergency message dumping.

Currently, the emergency dumping is opencoded in panic().  This patch
replaces the open coded implementation with a new function,
console_flush_on_panic() and makes it explicitly clear
console_may_schedule before starting the emergency flushing.

Link: http://lkml.kernel.org/g/878u3w95ke.fsf@yhuang-dev.intel.com
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: kernel test robot <ying.huang@linux.intel.com>
Cc: Calvin Owens <calvinowens@fb.com>
Cc: Jan Kara <jack@suse.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Kyle McMartin <kyle@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/console.h |    1 +
 kernel/panic.c          |    3 +--
 kernel/printk/printk.c  |   19 +++++++++++++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff -puN include/linux/console.h~printk-do-cond_resched-between-lines-while-outputting-to-consoles-fix include/linux/console.h
--- a/include/linux/console.h~printk-do-cond_resched-between-lines-while-outputting-to-consoles-fix
+++ a/include/linux/console.h
@@ -150,6 +150,7 @@ extern int console_trylock(void);
 extern void console_unlock(void);
 extern void console_conditional_schedule(void);
 extern void console_unblank(void);
+extern void console_flush_on_panic(void);
 extern struct tty_driver *console_device(int *);
 extern void console_stop(struct console *);
 extern void console_start(struct console *);
diff -puN kernel/panic.c~printk-do-cond_resched-between-lines-while-outputting-to-consoles-fix kernel/panic.c
--- a/kernel/panic.c~printk-do-cond_resched-between-lines-while-outputting-to-consoles-fix
+++ a/kernel/panic.c
@@ -180,8 +180,7 @@ void panic(const char *fmt, ...)
 	 * panic() is not being callled from OOPS.
 	 */
 	debug_locks_off();
-	console_trylock();
-	console_unlock();
+	console_flush_on_panic();
 
 	if (!panic_blink)
 		panic_blink = no_blink;
diff -puN kernel/printk/printk.c~printk-do-cond_resched-between-lines-while-outputting-to-consoles-fix kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-do-cond_resched-between-lines-while-outputting-to-consoles-fix
+++ a/kernel/printk/printk.c
@@ -2393,6 +2393,25 @@ void console_unblank(void)
 	console_unlock();
 }
 
+/**
+ * console_flush_on_panic - flush console content on panic
+ *
+ * Immediately output all pending messages no matter what.
+ */
+void console_flush_on_panic(void)
+{
+	/*
+	 * If someone else is holding the console lock, trylock will fail
+	 * and may_schedule may be set.  Ignore and proceed to unlock so
+	 * that messages are flushed out.  As this can be called from any
+	 * context and we don't want to get preempted while flushing,
+	 * ensure may_schedule is cleared.
+	 */
+	console_trylock();
+	console_may_schedule = 0;
+	console_unlock();
+}
+
 /*
  * Return the console tty driver structure and its associated index
  */
_

Patches currently in -mm which might be from tj@kernel.org are

cgroup-memcg-writeback-drop-spurious-rcu-locking-around-mem_cgroup_css_from_page.patch
printk-do-cond_resched-between-lines-while-outputting-to-consoles.patch

