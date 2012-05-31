From: akpm@linux-foundation.org
Subject: [merged] mm-bootmem-remove-redundant-offset-check-when-finally-freeing-bootmem.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:03 -0700
Message-ID: <20120531191503.612B9A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:62539 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab2EaTPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:11 -0400
Received: by lbbgp10 with SMTP id gp10so85786lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: bootmem: remove redundant offset check when finally freeing bootmem
has been removed from the -mm tree.  Its filename was
     mm-bootmem-remove-redundant-offset-check-when-finally-freeing-bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: bootmem: remove redundant offset check when finally freeing bootmem

When bootmem releases an unaligned BITS_PER_LONG pages chunk of memory to
the page allocator, it checks the bitmap if there are still unreserved
pages in the chunk (set bits), but also if the offset in the chunk
indicates BITS_PER_LONG loop iterations already.

But since the consulted bitmap is only a one-word-excerpt of the full
per-node bitmap, there can not be more than BITS_PER_LONG bits set in it. 
The additional offset check is unnecessary.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/bootmem.c~mm-bootmem-remove-redundant-offset-check-when-finally-freeing-bootmem mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmem-remove-redundant-offset-check-when-finally-freeing-bootmem
+++ a/mm/bootmem.c
@@ -204,7 +204,7 @@ static unsigned long __init free_all_boo
 			unsigned long off = 0;
 
 			vec >>= start & (BITS_PER_LONG - 1);
-			while (vec && off < BITS_PER_LONG) {
+			while (vec) {
 				if (vec & 1) {
 					page = pfn_to_page(start + off);
 					__free_pages_bootmem(page, 0);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
mm-slab-remove-duplicate-check.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

