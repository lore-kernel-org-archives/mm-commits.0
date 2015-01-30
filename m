From: akpm@linux-foundation.org
Subject: + taint-on-lockdep-warning-with-new-taint_lockdep.patch added to
 -mm tree
Date: Fri, 30 Jan 2015 15:48:06 -0800
Message-ID: <54cc1836.nsH7YRMcWafcyFpQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbbA3Xsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:48:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sp@datera.io, mingo@redhat.com, peterz@infradead.org, sp@daterainc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lockdep: taint on lockdep warning with new TAINT_LOCKDEP
has been added to the -mm tree.  Its filename is
     taint-on-lockdep-warning-with-new-taint_lockdep.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/taint-on-lockdep-warning-with-new-taint_lockdep.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/taint-on-lockdep-warning-with-new-taint_lockdep.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Slava Pestov <sp@datera.io>
Subject: lockdep: taint on lockdep warning with new TAINT_LOCKDEP

This helps when writing automated tests, since they can fail the test if
the kernel was tainted instead of manually scraping dmesg for interesting
strings.

Signed-off-by: Slava Pestov <sp@daterainc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h   |    1 +
 kernel/locking/lockdep.c |   31 +++++++++++++++++++++++++++++++
 kernel/panic.c           |    2 ++
 3 files changed, 34 insertions(+)

diff -puN include/linux/kernel.h~taint-on-lockdep-warning-with-new-taint_lockdep include/linux/kernel.h
--- a/include/linux/kernel.h~taint-on-lockdep-warning-with-new-taint_lockdep
+++ a/include/linux/kernel.h
@@ -471,6 +471,7 @@ extern enum system_states {
 #define TAINT_OOT_MODULE		12
 #define TAINT_UNSIGNED_MODULE		13
 #define TAINT_SOFTLOCKUP		14
+#define TAINT_LOCKDEP			15
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff -puN kernel/locking/lockdep.c~taint-on-lockdep-warning-with-new-taint_lockdep kernel/locking/lockdep.c
--- a/kernel/locking/lockdep.c~taint-on-lockdep-warning-with-new-taint_lockdep
+++ a/kernel/locking/lockdep.c
@@ -382,6 +382,8 @@ static unsigned long stack_trace[MAX_STA
 
 static void print_lockdep_off(const char *bug_msg)
 {
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk(KERN_DEBUG "%s\n", bug_msg);
 	printk(KERN_DEBUG "turning off the locking correctness validator.\n");
 #ifdef CONFIG_LOCK_STAT
@@ -739,6 +741,9 @@ register_lock_class(struct lockdep_map *
  	 */
 	if (!static_obj(lock->key)) {
 		debug_locks_off();
+
+		add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 		printk("INFO: trying to register non-static key.\n");
 		printk("the code is fine but needs lockdep annotation.\n");
 		printk("turning off the locking correctness validator.\n");
@@ -1190,6 +1195,8 @@ static noinline int print_circular_bug(s
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	if (!save_trace(&this->trace))
 		return 0;
 
@@ -1492,6 +1499,8 @@ print_bad_irq_dependency(struct task_str
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("======================================================\n");
 	printk("[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
@@ -1722,6 +1731,8 @@ print_deadlock_bug(struct task_struct *c
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=============================================\n");
 	printk("[ INFO: possible recursive locking detected ]\n");
@@ -2226,6 +2237,8 @@ print_usage_bug(struct task_struct *curr
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=================================\n");
 	printk("[ INFO: inconsistent lock state ]\n");
@@ -2291,6 +2304,8 @@ print_irq_inversion_bug(struct task_stru
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=========================================================\n");
 	printk("[ INFO: possible irq lock inversion dependency detected ]\n");
@@ -3014,6 +3029,8 @@ print_lock_nested_lock_not_held(struct t
 	if (debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("==================================\n");
 	printk("[ BUG: Nested lock was not taken ]\n");
@@ -3219,6 +3236,8 @@ print_unlock_imbalance_bug(struct task_s
 	if (debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=====================================\n");
 	printk("[ BUG: bad unlock balance detected! ]\n");
@@ -3664,6 +3683,8 @@ print_lock_contention_bug(struct task_st
 	if (debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=================================\n");
 	printk("[ BUG: bad contention detected! ]\n");
@@ -4040,6 +4061,8 @@ print_freed_lock_bug(struct task_struct
 	if (debug_locks_silent)
 		return;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=========================\n");
 	printk("[ BUG: held lock freed! ]\n");
@@ -4098,6 +4121,8 @@ static void print_held_locks_bug(void)
 	if (debug_locks_silent)
 		return;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=====================================\n");
 	printk("[ BUG: %s/%d still has locks held! ]\n",
@@ -4197,6 +4222,9 @@ asmlinkage __visible void lockdep_sys_ex
 	if (unlikely(curr->lockdep_depth)) {
 		if (!debug_locks_off())
 			return;
+
+		add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 		printk("\n");
 		printk("================================================\n");
 		printk("[ BUG: lock held when returning to user space! ]\n");
@@ -4216,6 +4244,9 @@ void lockdep_rcu_suspicious(const char *
 	if (!debug_locks_off())
 		return;
 #endif /* #ifdef CONFIG_PROVE_RCU_REPEATEDLY */
+
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	/* Note: the following can be executed concurrently, so be careful. */
 	printk("\n");
 	printk("===============================\n");
diff -puN kernel/panic.c~taint-on-lockdep-warning-with-new-taint_lockdep kernel/panic.c
--- a/kernel/panic.c~taint-on-lockdep-warning-with-new-taint_lockdep
+++ a/kernel/panic.c
@@ -226,6 +226,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_OOT_MODULE,		'O', ' ' },
 	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
 	{ TAINT_SOFTLOCKUP,		'L', ' ' },
+	{ TAINT_LOCKDEP,		'K', ' ' },
 };
 
 /**
@@ -246,6 +247,7 @@ static const struct tnt tnts[] = {
  *  'O' - Out-of-tree module has been loaded.
  *  'E' - Unsigned module has been loaded.
  *  'L' - A soft lockup has previously occurred.
+ *  'K' - Lockdep warning was generated.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
_

Patches currently in -mm which might be from sp@datera.io are

taint-on-lockdep-warning-with-new-taint_lockdep.patch

