From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-warning-in-alloc_huge_page-dequeue_huge_page_vma.patch added to -mm tree
Date: Tue, 17 Apr 2012 13:57:33 -0700
Message-ID: <20120417205735.B4667A038B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41143 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2DQU5h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Apr 2012 16:57:37 -0400
Received: by yenq2 with SMTP id q2so779812yen.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Apr 2012 13:57:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, mgorman@suse.de, rientjes@google.com


The patch titled
     Subject: mm/hugetlb: fix warning in alloc_huge_page/dequeue_huge_page_vma
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-warning-in-alloc_huge_page-dequeue_huge_page_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -535,7 +535,7 @@ static struct page *dequeue_huge_page_vm
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve)
 {
-	struct page *page;
+	struct page *page = NULL;
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
 	struct zonelist *zonelist;
_
Subject: Subject: mm/hugetlb: fix warning in alloc_huge_page/dequeue_huge_page_vma

Patches currently in -mm which might be from khlebnikov@openvz.org are

mm-hugetlb-fix-warning-in-alloc_huge_page-dequeue_huge_page_vma.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch

