From: akpm@osdl.org
Subject: - lockdep-print-current-locks-on-in_atomic-warnings.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:20 -0800
Message-ID: <200612072304.kB7N4Kt8030038@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52036 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163838AbWLGXE0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: print current locks on in_atomic warnings
has been removed from the -mm tree.  Its filename was
     lockdep-print-current-locks-on-in_atomic-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: print current locks on in_atomic warnings
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Add debug_show_held_locks(current) to __might_sleep() and schedule(); this
makes finding the offending lock leak easier.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sched.c~lockdep-print-current-locks-on-in_atomic-warnings kernel/sched.c
--- a/kernel/sched.c~lockdep-print-current-locks-on-in_atomic-warnings
+++ a/kernel/sched.c
@@ -3333,6 +3333,7 @@ asmlinkage void __sched schedule(void)
 		printk(KERN_ERR "BUG: scheduling while atomic: "
 			"%s/0x%08x/%d\n",
 			current->comm, preempt_count(), current->pid);
+		debug_show_held_locks(current);
 		dump_stack();
 	}
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
@@ -6872,6 +6873,7 @@ void __might_sleep(char *file, int line)
 				" context at %s:%d\n", file, line);
 		printk("in_atomic():%d, irqs_disabled():%d\n",
 			in_atomic(), irqs_disabled());
+		debug_show_held_locks(current);
 		dump_stack();
 	}
 #endif
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
tty-signal-tty-locking-3270-fix.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch

