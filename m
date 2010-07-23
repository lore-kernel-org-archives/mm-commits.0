From: akpm@linux-foundation.org
Subject: + jbd-remove-dependency-on-__gfp_nofail.patch added to -mm tree
Date: Fri, 23 Jul 2010 12:40:09 -0700
Message-ID: <201007231940.o6NJe9Y7004488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872Ab0GWTlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Jul 2010 15:41:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, adilger@sun.com, jkosina@suse.cz


The patch titled
     jbd: remove dependency on __GFP_NOFAIL
has been added to the -mm tree.  Its filename is
     jbd-remove-dependency-on-__gfp_nofail.patch

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
Subject: jbd: remove dependency on __GFP_NOFAIL
From: David Rientjes <rientjes@google.com>

The kzalloc() in start_this_handle() is failable, so remove __GFP_NOFAIL
from its mask.

If this is in the direct reclaim path, then current has PF_MEMALLOC which
allows it to allocate with memory reserves in lowmem situations.

Using GFP_NOFS with __GFP_NOFAIL is always dangerous because the oom
killer cannot be invoked for GFP_NOFS, so the potential for infinitely
looping in the page allocator is even greater the way it is currently
written.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/transaction.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/jbd/transaction.c~jbd-remove-dependency-on-__gfp_nofail fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-remove-dependency-on-__gfp_nofail
+++ a/fs/jbd/transaction.c
@@ -99,8 +99,7 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kzalloc(sizeof(*new_transaction),
-						GFP_NOFS|__GFP_NOFAIL);
+		new_transaction = kzalloc(sizeof(*new_transaction), GFP_NOFS);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
_

Patches currently in -mm which might be from rientjes@google.com are

ptrace-dont-run-write_locktasklist_lock-if-the-parent-doesnt-ptrace-other-processes.patch
linux-next.patch
avr32-invoke-oom-killer-from-page-fault.patch
infiniband-remove-dependency-on-__gfp_nofail.patch
fs-bio-integrityc-remove-dependency-on-__gfp_nofail.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-improve-commentary-in-dump_tasks.patch
oom-dump_tasks-use-find_lock_task_mm-too-dump_tasks-use-find_lock_task_mm-too-fix.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-move-sysctl-declarations-to-oomh.patch
oom-remove-unnecessary-code-and-cleanup.patch
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch
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
jbd-remove-dependency-on-__gfp_nofail.patch

