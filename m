From: akpm@linux-foundation.org
Subject: + mm-vmalloc-use-well-defined-find_last_bit-func.patch added to
 -mm tree
Date: Wed, 07 Aug 2013 14:05:29 -0700
Message-ID: <5202b699.WtX2QXkd2BKuPJpN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100Ab3HGVFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 17:05:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.con, liwanp@linux.vnet.ibm.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com

Subject: + mm-vmalloc-use-well-defined-find_last_bit-func.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,liwanp@linux.vnet.ibm.com,zhangyanfei@cn.fujitsu.con
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 14:05:29 -0700


The patch titled
     Subject: mm, vmalloc: use well-defined find_last_bit() func
has been added to the -mm tree.  Its filename is
     mm-vmalloc-use-well-defined-find_last_bit-func.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-use-well-defined-find_last_bit-func.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-use-well-defined-find_last_bit-func.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, vmalloc: use well-defined find_last_bit() func

Our intention in here is to find last_bit within the region to flush. 
There is well-defined function, find_last_bit() for this purpose and its
performance may be slightly better than current implementation.  So change
it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.con>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-use-well-defined-find_last_bit-func mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-use-well-defined-find_last_bit-func
+++ a/mm/vmalloc.c
@@ -1016,15 +1016,16 @@ void vm_unmap_aliases(void)
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(vb, &vbq->free, free_list) {
-			int i;
+			int i, j;
 
 			spin_lock(&vb->lock);
 			i = find_first_bit(vb->dirty_map, VMAP_BBMAP_BITS);
-			while (i < VMAP_BBMAP_BITS) {
+			if (i < VMAP_BBMAP_BITS) {
 				unsigned long s, e;
-				int j;
-				j = find_next_zero_bit(vb->dirty_map,
-					VMAP_BBMAP_BITS, i);
+
+				j = find_last_bit(vb->dirty_map,
+							VMAP_BBMAP_BITS);
+				j = j + 1; /* need exclusive index */
 
 				s = vb->va->va_start + (i << PAGE_SHIFT);
 				e = vb->va->va_start + (j << PAGE_SHIFT);
@@ -1034,10 +1035,6 @@ void vm_unmap_aliases(void)
 					start = s;
 				if (e > end)
 					end = e;
-
-				i = j;
-				i = find_next_bit(vb->dirty_map,
-							VMAP_BBMAP_BITS, i);
 			}
 			spin_unlock(&vb->lock);
 		}
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
mm-move-pgtable-related-functions-to-right-place.patch
swap-clean-up-ifdef-in-page_mapping.patch
mm-vmalloc-remove-useless-variable-in-vmap_block.patch
mm-vmalloc-use-well-defined-find_last_bit-func.patch

