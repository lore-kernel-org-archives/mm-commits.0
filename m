From: akpm@linux-foundation.org
Subject: + mm-vmalloc-remove-useless-variable-in-vmap_block.patch added to -mm tree
Date: Wed, 07 Aug 2013 14:05:28 -0700
Message-ID: <5202b698.rirANKTNRZ/yHc1T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100Ab3HGVF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 17:05:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.con, liwanp@linux.vnet.ibm.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com

Subject: + mm-vmalloc-remove-useless-variable-in-vmap_block.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,liwanp@linux.vnet.ibm.com,zhangyanfei@cn.fujitsu.con
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 14:05:28 -0700


The patch titled
     Subject: mm, vmalloc: remove useless variable in vmap_block
has been added to the -mm tree.  Its filename is
     mm-vmalloc-remove-useless-variable-in-vmap_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-remove-useless-variable-in-vmap_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-remove-useless-variable-in-vmap_block.patch

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
Subject: mm, vmalloc: remove useless variable in vmap_block

vbq in vmap_block isn't used. So remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.con>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-remove-useless-variable-in-vmap_block mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-remove-useless-variable-in-vmap_block
+++ a/mm/vmalloc.c
@@ -752,7 +752,6 @@ struct vmap_block_queue {
 struct vmap_block {
 	spinlock_t lock;
 	struct vmap_area *va;
-	struct vmap_block_queue *vbq;
 	unsigned long free, dirty;
 	DECLARE_BITMAP(dirty_map, VMAP_BBMAP_BITS);
 	struct list_head free_list;
@@ -830,7 +829,6 @@ static struct vmap_block *new_vmap_block
 	radix_tree_preload_end();
 
 	vbq = &get_cpu_var(vmap_block_queue);
-	vb->vbq = vbq;
 	spin_lock(&vbq->lock);
 	list_add_rcu(&vb->free_list, &vbq->free);
 	spin_unlock(&vbq->lock);
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

