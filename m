From: akpm@linux-foundation.org
Subject: + vmscan-zone_reclaim-dont-call-disable_swap_token.patch added to -mm tree
Date: Wed, 30 Jun 2010 16:00:40 -0700
Message-ID: <201006302300.o5UN0eKx031601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477Ab0F3XA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 19:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: zone_reclaim don't call disable_swap_token()
has been added to the -mm tree.  Its filename is
     vmscan-zone_reclaim-dont-call-disable_swap_token.patch

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
Subject: vmscan: zone_reclaim don't call disable_swap_token()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Swap token don't works when zone reclaim is enabled since it was born. 
Because __zone_reclaim() always call disable_swap_token() unconditionally.

This kill swap token feature completely.  As far as I know, nobody want to
that.  Remove it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-zone_reclaim-dont-call-disable_swap_token mm/vmscan.c
--- a/mm/vmscan.c~vmscan-zone_reclaim-dont-call-disable_swap_token
+++ a/mm/vmscan.c
@@ -2590,7 +2590,6 @@ static int __zone_reclaim(struct zone *z
 	};
 	unsigned long slab_reclaimable;
 
-	disable_swap_token();
 	cond_resched();
 	/*
 	 * We need to be able to allocate from the reserves for RECLAIM_SWAP
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mempolicy-fix-dangling-reference-to-tmpfs-superblock-mpol.patch
acpi-fix-unused-function-warning.patch
mm-use-memdup_user.patch
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
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch
mm-use-for_each_online_cpu-in-vmstat.patch
mempolicy-reduce-stack-size-of-migrate_pages.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
vmscan-zone_reclaim-dont-call-disable_swap_token.patch
reiser4.patch

