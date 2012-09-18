From: akpm@linux-foundation.org
Subject: + hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach.patch added to -mm tree
Date: Tue, 18 Sep 2012 16:15:04 -0700
Message-ID: <20120918231504.B68481E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37430 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2IRXPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 19:15:06 -0400
Received: by yhl10 with SMTP id 10so61606yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 16:15:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, aarcange@redhat.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     Subject: hugetlb: do not use vma_hugecache_offset() for vma_prio_tree_foreach
has been added to the -mm tree.  Its filename is
     hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: hugetlb: do not use vma_hugecache_offset() for vma_prio_tree_foreach

0c176d5 ("mm: hugetlb: fix pgoff computation when unmapping page from
vma") fixed pgoff calculation but it has replaced it by
vma_hugecache_offset() which is not approapriate for offsets used for
vma_prio_tree_foreach() because that one expects index in page units
rather than in huge_page_shift.

Using vma_hugecache_offset() is not incorrect because the pgoff will fit
into the same vmas but it is confusing so the standard PAGE_SHIFT based
index calculation is used instead.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach
+++ a/mm/hugetlb.c
@@ -2480,7 +2480,8 @@ static int unmap_ref_private(struct mm_s
 	 * from page cache lookup which is in HPAGE_SIZE units.
 	 */
 	address = address & huge_page_mask(h);
-	pgoff = vma_hugecache_offset(h, vma, address);
+	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) +
+			vma->vm_pgoff;
 	mapping = vma->vm_file->f_dentry->d_inode->i_mapping;
 
 	/*
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool.patch
mm-memblock-reduce-overhead-in-binary-search.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch
mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch
memcg-trivial-fixes-for-documentation-cgroups-memorytxt.patch
memcg-cleanup-kmem-tcp-ifdefs.patch
memcg-move-mem_cgroup_is_root-upwards.patch
hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach.patch

