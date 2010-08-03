From: akpm@linux-foundation.org
Subject: + lib-div64c-document-that-div64_u64-is-not-precise-on-32bit-platforms.patch added to -mm tree
Date: Tue, 03 Aug 2010 15:29:08 -0700
Message-ID: <201008032229.o73MT8dP014829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993Ab0HCW3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2010 18:29:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, behlendorf1@llnl.gov, bwoodard@llnl.gov, jeremy@goop.org, mgrondona@llnl.gov


The patch titled
     lib/div64.c: document that div64_u64() is not precise on 32bit platforms
has been added to the -mm tree.  Its filename is
     lib-div64c-document-that-div64_u64-is-not-precise-on-32bit-platforms.patch

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
Subject: lib/div64.c: document that div64_u64() is not precise on 32bit platforms
From: Oleg Nesterov <oleg@redhat.com>

We have a bug report which blames div64_u64() on 32bit platforms.

However, the code obviously doesn't even try to pretend it can do the
64bit division precisely.  If there is something in the high word of
divisor, div64_u64() just shifts both arguments and throws out the low
bits.

Add a small comment to avoid the confusion.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Woodard <bwoodard@llnl.gov>
Cc: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark Grondona <mgrondona@llnl.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/div64.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN lib/div64.c~lib-div64c-document-that-div64_u64-is-not-precise-on-32bit-platforms lib/div64.c
--- a/lib/div64.c~lib-div64c-document-that-div64_u64-is-not-precise-on-32bit-platforms
+++ a/lib/div64.c
@@ -77,7 +77,10 @@ s64 div_s64_rem(s64 dividend, s32 diviso
 EXPORT_SYMBOL(div_s64_rem);
 #endif
 
-/* 64bit divisor, dividend and result. dynamic precision */
+/*
+ * 64bit divisor, dividend and result. Dynamic precision, unless
+ * divisor fits in u32 result is not exactly correct.
+ */
 #ifndef div64_u64
 u64 div64_u64(u64 dividend, u64 divisor)
 {
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-improve-commentary-in-dump_tasks.patch
oom-dump_tasks-use-find_lock_task_mm-too-dump_tasks-use-find_lock_task_mm-too-fix.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch
oom-dont-try-to-kill-oom_unkillable-child.patch
oom-oom_kill_process-doesnt-select-kthread-child.patch
oom-make-oom_unkillable_task-helper-function.patch
oom-oom_kill_process-needs-to-check-that-p-is-unkillable.patch
oom-proc-pid-oom_score-treat-kernel-thread-honestly.patch
oom-kill-duplicate-oom_disable-check.patch
oom-move-oom_disable-check-from-oom_kill_task-to-out_of_memory.patch
oom-cleanup-has_intersects_mems_allowed.patch
oom-remove-child-mm-check-from-oom_kill_process.patch
oom-give-the-dying-task-a-higher-priority.patch
oom-multi-threaded-process-coredump-dont-make-deadlock.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
sys_personality-remove-the-bogus-checks-in-sys_personality-__set_personality-path.patch
x86-ia64-smp-use-workqueues-unconditionally-during-do_boot_cpu.patch
lib-div64c-document-that-div64_u64-is-not-precise-on-32bit-platforms.patch
memcg-use-find_lock_task_mm-in-memory-cgroups-oom.patch
ptrace-optimize-exit_ptrace-for-the-likely-case.patch
pids-alloc_pidmap-remove-the-unnecessary-boundary-checks.patch
aio-do-not-return-erestartsys-and-friends-from-aio.patch

