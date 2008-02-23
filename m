From: akpm@linux-foundation.org
Subject: + documentation-atomic_add_unless-doesnt-imply-mb-on-failure.patch added to -mm tree
Date: Sat, 23 Feb 2008 13:13:42 -0800
Message-ID: <200802232113.m1NLDg7W015381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637AbYBWVOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 16:14:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, npiggin@suse.de


The patch titled
     documentation: atomic_add_unless() doesn't imply mb() on failure
has been added to the -mm tree.  Its filename is
     documentation-atomic_add_unless-doesnt-imply-mb-on-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation: atomic_add_unless() doesn't imply mb() on failure
From: Oleg Nesterov <oleg@tv-sign.ru>

A "typical" implementation of atomic_add_unless() can return 0 immediately
after the first atomic_read() (before doing cmpxchg).  In that case it
doesn't provide any barrier semantics.  See include/asm-ia64/atomic.h as an
example.

We should either change the implementation, or fix the docs.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/atomic_ops.txt      |    3 ++-
 Documentation/memory-barriers.txt |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN Documentation/atomic_ops.txt~documentation-atomic_add_unless-doesnt-imply-mb-on-failure Documentation/atomic_ops.txt
--- a/Documentation/atomic_ops.txt~documentation-atomic_add_unless-doesnt-imply-mb-on-failure
+++ a/Documentation/atomic_ops.txt
@@ -186,7 +186,8 @@ If the atomic value v is not equal to u,
 returns non zero. If v is equal to u then it returns zero. This is done as
 an atomic operation.
 
-atomic_add_unless requires explicit memory barriers around the operation.
+atomic_add_unless requires explicit memory barriers around the operation
+unless it fails (returns 0).
 
 atomic_inc_not_zero, equivalent to atomic_add_unless(v, 1, 0)
 
diff -puN Documentation/memory-barriers.txt~documentation-atomic_add_unless-doesnt-imply-mb-on-failure Documentation/memory-barriers.txt
--- a/Documentation/memory-barriers.txt~documentation-atomic_add_unless-doesnt-imply-mb-on-failure
+++ a/Documentation/memory-barriers.txt
@@ -1493,7 +1493,7 @@ explicit lock operations, described late
 	atomic_dec_and_test();
 	atomic_sub_and_test();
 	atomic_add_negative();
-	atomic_add_unless();
+	atomic_add_unless();	/* when succeeds (returns 1) */
 	test_and_set_bit();
 	test_and_clear_bit();
 	test_and_change_bit();
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-sched.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
timers-simplify-lockdep-stuff.patch
hrtimers-simplify-lockdep-stuff.patch
kill-double_spin_lock.patch
redo-locking-of-tty-pgrp.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
