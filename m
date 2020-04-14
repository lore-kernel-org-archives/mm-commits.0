From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2.patch added to
 -mm tree
Date: Tue, 14 Apr 2020 16:10:03 -0700
Message-ID: <20200414231003.GeDnD2_md%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731377AbgDNXKF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Apr 2020 19:10:05 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm/hugetlb: fix a typo in comment "manitained"->"maintained"
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm/hugetlb: fix a typo in comment "manitained"->"maintained"

There are some typos in comment, fix them.

line 83, s/mased on/based on
line 472, s/ruturns/returns
line 987, s/reverves/reserves
line 1489, s/ Otherwse/Otherwise
line 4431, s/a active/an active

Link: http://lkml.kernel.org/r/20200411022446.14937-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 +++++-----
 mm/mmap.c    |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2
+++ a/mm/hugetlb.c
@@ -85,7 +85,7 @@ static inline void unlock_or_release_sub
 	spin_unlock(&spool->lock);
 
 	/* If no pages are used, and no other handles to the subpool
-	 * remain, give up any reservations mased on minimum size and
+	 * remain, give up any reservations based on minimum size and
 	 * free the subpool */
 	if (free) {
 		if (spool->min_hpages != -1)
@@ -473,7 +473,7 @@ out_of_memory:
  *
  * Return the number of new huge pages added to the map.  This number is greater
  * than or equal to zero.  If file_region entries needed to be allocated for
- * this operation and we were not able to allocate, it ruturns -ENOMEM.
+ * this operation and we were not able to allocate, it returns -ENOMEM.
  * region_add of regions of length 1 never allocate file_regions and cannot
  * fail; region_chg will always allocate at least 1 entry and a region_add for
  * 1 page will only require at most 1 entry.
@@ -988,7 +988,7 @@ static bool vma_has_reserves(struct vm_a
 		 * We know VM_NORESERVE is not set.  Therefore, there SHOULD
 		 * be a region map for all pages.  The only situation where
 		 * there is no region map is if a hole was punched via
-		 * fallocate.  In this case, there really are no reverves to
+		 * fallocate.  In this case, there really are no reserves to
 		 * use.  This situation is indicated if chg != 0.
 		 */
 		if (chg)
@@ -1519,7 +1519,7 @@ static void prep_compound_gigantic_page(
 		 * For gigantic hugepages allocated through bootmem at
 		 * boot, it's safer to be consistent with the not-gigantic
 		 * hugepages and clear the PG_reserved bit from all tail pages
-		 * too.  Otherwse drivers using get_user_pages() to access tail
+		 * too.  Otherwise drivers using get_user_pages() to access tail
 		 * pages may get the reference counting wrong if they see
 		 * PG_reserved set on a tail page (despite the head page not
 		 * having PG_reserved set).  Enforcing this consistency between
@@ -4466,7 +4466,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	/*
 	 * entry could be a migration/hwpoison entry at this point, so this
 	 * check prevents the kernel from going below assuming that we have
-	 * a active hugepage in pagecache. This goto expects the 2nd page fault,
+	 * an active hugepage in pagecache. This goto expects the 2nd page fault,
 	 * and is_hugetlb_entry_(migration|hwpoisoned) check will properly
 	 * handle it.
 	 */
--- a/mm/mmap.c~mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2
+++ a/mm/mmap.c
@@ -1207,7 +1207,7 @@ struct vm_area_struct *vma_merge(struct
 }
 
 /*
- * Rough compatbility check to quickly see if it's even worth looking
+ * Rough compatibility check to quickly see if it's even worth looking
  * at sharing an anon_vma.
  *
  * They need to have the same vm_file, and the flags can only differ
_

Patches currently in -mm which might be from ethp@qq.com are

mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch
mm-ksm-fix-a-typo-in-comment-alreaady-already.patch
mm-ksm-fix-a-typo-in-comment-alreaady-already-v2.patch
mm-mmap-fix-a-typo-in-comment-compatbility-compatibility.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2.patch
mm-vmsan-fix-some-typos-in-comment.patch
mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic.patch
mm-memblock-fix-a-typo-in-comment-implict-implicit.patch
mm-list_lru-fix-a-typo-in-comment-numbesr-numbers.patch
mm-filemap-fix-a-typo-in-comment-unneccssary-unnecessary.patch
mm-frontswap-fix-some-typos-in-frontswapc.patch
mm-memcg-fix-some-typos-in-memcontrolc.patch
mm-fix-a-typo-in-comment-strucure-structure.patch
mm-slub-fix-a-typo-in-comment-disambiguiation-disambiguation.patch
mm-sparse-fix-a-typo-in-comment-convienence-convenience.patch
mm-page-writeback-fix-a-typo-in-comment-effictive-effective.patch
mm-memory-fix-a-typo-in-comment-attampt-attempt.patch
