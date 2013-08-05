From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch removed from -mm
 tree
Date: Mon, 05 Aug 2013 12:05:37 -0700
Message-ID: <51fff781.mkWWMBTZUdswOWq7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab3HETFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:05:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, steven.t.hampson@intel.com, stable@vger.kernel.org, riel@redhat.com, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com, andi@firstfloor.org, oleg@redhat.com

Subject: [merged] mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch removed from -mm tree
To: oleg@redhat.com,andi@firstfloor.org,kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,riel@redhat.com,stable@vger.kernel.org,steven.t.hampson@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:05:37 -0700


The patch titled
     Subject: mm: mempolicy: fix mbind_range() && vma_adjust() interaction
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
linux-next.patch

