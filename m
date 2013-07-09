From: akpm@linux-foundation.org
Subject: + mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch added to -mm tree
Date: Tue, 09 Jul 2013 14:56:50 -0700
Message-ID: <51dc8722.UXYITu6Y/wcEF+Jg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3GIV4v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 17:56:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, steven.t.hampson@intel.com, stable@vger.kernel.org, riel@redhat.com, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com, andi@firstfloor.org, oleg@redhat.com

Subject: + mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch added to -mm tree
To: oleg@redhat.com,andi@firstfloor.org,kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,riel@redhat.com,stable@vger.kernel.org,steven.t.hampson@intel.com
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 14:56:50 -0700


The patch titled
     Subject: mm: mempolicy: fix mbind_range() && vma_adjust() interaction
has been added to the -mm tree.  Its filename is
     mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm: mempolicy: fix mbind_range() && vma_adjust() interaction

vma_adjust() does vma_set_policy(vma, vma_policy(next)) and this
is doubly wrong:

1. This leaks vma->vm_policy if it is not NULL and not equal to
   next->vm_policy.

   This can happen if vma_merge() expands "area", not prev (case 8).

2. This sets the wrong policy if vma_merge() joins prev and area,
   area is the vma the caller needs to update and it still has the
   old policy.

Revert 1444f92c "mm: merging memory blocks resets mempolicy" which
introduced these problems.

Change mbind_range() to recheck mpol_equal() after vma_merge() to
fix the problem 1444f92c tried to address.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steven T Hampson <steven.t.hampson@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    6 +++++-
 mm/mmap.c      |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-fix-mbind_range-vma_adjust-interaction mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-fix-mbind_range-vma_adjust-interaction
+++ a/mm/mempolicy.c
@@ -732,7 +732,10 @@ static int mbind_range(struct mm_struct
 		if (prev) {
 			vma = prev;
 			next = vma->vm_next;
-			continue;
+			if (mpol_equal(vma_policy(vma), new_pol))
+				continue;
+			/* vma_merge() joined vma && vma->next, case 8 */
+			goto replace;
 		}
 		if (vma->vm_start != vmstart) {
 			err = split_vma(vma->vm_mm, vma, vmstart, 1);
@@ -744,6 +747,7 @@ static int mbind_range(struct mm_struct
 			if (err)
 				goto out;
 		}
+ replace:
 		err = vma_replace_policy(vma, new_pol);
 		if (err)
 			goto out;
diff -puN mm/mmap.c~mm-mempolicy-fix-mbind_range-vma_adjust-interaction mm/mmap.c
--- a/mm/mmap.c~mm-mempolicy-fix-mbind_range-vma_adjust-interaction
+++ a/mm/mmap.c
@@ -865,7 +865,7 @@ again:			remove_next = 1 + (end > next->
 		if (next->anon_vma)
 			anon_vma_merge(vma, next);
 		mm->map_count--;
-		vma_set_policy(vma, vma_policy(next));
+		mpol_put(vma_policy(next));
 		kmem_cache_free(vm_area_cachep, next);
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
vfree-dont-schedule-free_work-if-llist_add-returns-false.patch
ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-sh-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch
ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch
ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch
ptrace-x86-introduce-ptrace_register_breakpoint.patch
ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch
ptrace-x86-cleanup-ptrace_set_debugreg.patch
ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch
ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch
linux-next.patch
mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

