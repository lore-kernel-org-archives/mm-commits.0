From: akpm@linux-foundation.org
Subject: + fs-bio-integrityc-remove-dependency-on-__gfp_nofail.patch added to -mm tree
Date: Fri, 23 Jul 2010 12:37:12 -0700
Message-ID: <201007231937.o6NJbC3Y004337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177Ab0GWThq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Jul 2010 15:37:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, jens.axboe@oracle.com


The patch titled
     fs/bio-integrity.c: remove dependency on __GFP_NOFAIL
has been added to the -mm tree.  Its filename is
     fs-bio-integrityc-remove-dependency-on-__gfp_nofail.patch

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
Subject: fs/bio-integrity.c: remove dependency on __GFP_NOFAIL
From: David Rientjes <rientjes@google.com>

The kmalloc() in bio_integrity_prep() is failable, so remove __GFP_NOFAIL
from its mask.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/bio-integrity.c~fs-bio-integrityc-remove-dependency-on-__gfp_nofail fs/bio-integrity.c
--- a/fs/bio-integrity.c~fs-bio-integrityc-remove-dependency-on-__gfp_nofail
+++ a/fs/bio-integrity.c
@@ -413,7 +413,7 @@ int bio_integrity_prep(struct bio *bio)
 
 	/* Allocate kernel buffer for protection data */
 	len = sectors * blk_integrity_tuple_size(bi);
-	buf = kmalloc(len, GFP_NOIO | __GFP_NOFAIL | q->bounce_gfp);
+	buf = kmalloc(len, GFP_NOIO | q->bounce_gfp);
 	if (unlikely(buf == NULL)) {
 		printk(KERN_ERR "could not allocate integrity buffer\n");
 		return -EIO;
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

