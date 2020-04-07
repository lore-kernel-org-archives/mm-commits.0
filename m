From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-test_lockup-test-module-to-generate-lockups-fix.patch removed from -mm
 tree
Date: Mon, 06 Apr 2020 18:48:24 -0700
Message-ID: <20200407014824.ZnionByGr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGBs1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 21:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, gregkh@linuxfoundation.org, keescook@chromium.org, khlebnikov@yandex-team.ru, linux@roeck-us.net, mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org, sashal@kernel.org, sergey.senozhatsky@gmail.com


The patch titled
     Subject: lib/test_lockup: rename disable_irq to fix build error
has been removed from the -mm tree.  Its filename was
     lib-test_lockup-test-module-to-generate-lockups-fix.patch

This patch was dropped because it was folded into lib-test_lockup-test-module-to-generate-lockups.patch

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: lib/test_lockup: rename disable_irq to fix build error

mips:allmodconfig fails to build.

lib/test_lockup.c:87:13: error:
	'disable_irq' redeclared as different kind of symbol
   87 | static bool disable_irq;
      |             ^~~~~~~~~~~
In file included from arch/mips/include/asm/highmem.h:24,
                 from arch/mips/include/asm/pgtable-32.h:22,
                 from arch/mips/include/asm/pgtable.h:14,
                 from include/linux/mm.h:95,
                 from lib/test_lockup.c:15:
include/linux/interrupt.h:237:13: note:
	previous declaration of 'disable_irq' was here
  237 | extern void disable_irq(unsigned int irq);

Rename the variable to fix the problem.

Link: http://lkml.kernel.org/r/20200317133614.23152-1-linux@roeck-us.net
Fixes: 0e86238873f3 ("lib/test_lockup: test module to generate lockups")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_lockup.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/lib/test_lockup.c~lib-test_lockup-test-module-to-generate-lockups-fix
+++ a/lib/test_lockup.c
@@ -84,8 +84,8 @@ static unsigned long lock_wait_threshold
 module_param(lock_wait_threshold, ulong, 0400);
 MODULE_PARM_DESC(lock_wait_threshold, "print lock wait time longer than this in nanoseconds, default off");
 
-static bool disable_irq;
-module_param(disable_irq, bool, 0400);
+static bool test_disable_irq;
+module_param_named(disable_irq, test_disable_irq, bool, 0400);
 MODULE_PARM_DESC(disable_irq, "disable interrupts: generate hard-lockups");
 
 static bool disable_softirq;
@@ -179,7 +179,7 @@ static void test_lock(bool master, bool
 			down_write(&main_task->mm->mmap_sem);
 	}
 
-	if (disable_irq)
+	if (test_disable_irq)
 		local_irq_disable();
 
 	if (disable_softirq)
@@ -252,7 +252,7 @@ static void test_unlock(bool master, boo
 	if (disable_softirq)
 		local_bh_enable();
 
-	if (disable_irq)
+	if (test_disable_irq)
 		local_irq_enable();
 
 	if (lock_mmap_sem && master) {
@@ -479,8 +479,8 @@ static int __init test_lockup_init(void)
 	if ((wait_state != TASK_RUNNING ||
 	     (call_cond_resched && !reacquire_locks) ||
 	     (alloc_pages_nr && gfpflags_allow_blocking(alloc_pages_gfp))) &&
-	    (disable_irq || disable_softirq || disable_preempt || lock_rcu ||
-	     lock_spinlock_ptr || lock_rwlock_ptr)) {
+	    (test_disable_irq || disable_softirq || disable_preempt ||
+	     lock_rcu || lock_spinlock_ptr || lock_rwlock_ptr)) {
 		pr_err("refuse to sleep in atomic context\n");
 		return -EINVAL;
 	}
@@ -495,7 +495,7 @@ static int __init test_lockup_init(void)
 		  cooldown_secs, cooldown_nsecs, iterations, state,
 		  all_cpus ? "all_cpus " : "",
 		  iowait ? "iowait " : "",
-		  disable_irq ? "disable_irq " : "",
+		  test_disable_irq ? "disable_irq " : "",
 		  disable_softirq ? "disable_softirq " : "",
 		  disable_preempt ? "disable_preempt " : "",
 		  lock_rcu ? "lock_rcu " : "",
_

Patches currently in -mm which might be from linux@roeck-us.net are

lib-test_lockup-test-module-to-generate-lockups.patch
