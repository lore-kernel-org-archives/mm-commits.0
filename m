From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-fix-warning-in-alloc_huge_page-dequeue_huge_page_vma.patch removed from -mm tree
Date: Fri, 27 Apr 2012 12:35:04 -0700
Message-ID: <20120427193506.48B58A02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:36741 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760531Ab2D0TfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 15:35:08 -0400
Received: by qabg24 with SMTP id g24so97481qab.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 12:35:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, mgorman@suse.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix warning in alloc_huge_page/dequeue_huge_page_vma
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-warning-in-alloc_huge_page-dequeue_huge_page_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/hugetlb: fix warning in alloc_huge_page/dequeue_huge_page_vma

Fix a gcc warning (and bug?) introduced in cc9a6c877 ("cpuset: mm: reduce
large amounts of memory barrier related damage v3")

Local variable "page" can be uninitialized if the nodemask from vma policy
does not intersects with nodemask from cpuset.  Even if it doesn't happens
it is better to initialize this variable explicitly than to introduce
a kernel oops in a weird corner case.

mm/hugetlb.c: In function `alloc_huge_page':
mm/hugetlb.c:1135:5: warning: `page' may be used uninitialized in this function

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-warning-in-alloc_huge_page-dequeue_huge_page_vma mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-warning-in-alloc_huge_page-dequeue_huge_page_vma
+++ a/mm/hugetlb.c
@@ -532,7 +532,7 @@ static struct page *dequeue_huge_page_vm
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve)
 {
-	struct page *page;
+	struct page *page = NULL;
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
 	struct zonelist *zonelist;
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

