From: akpm@linux-foundation.org
Subject: + mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch
 added to -mm tree
Date: Wed, 08 Jan 2014 12:49:19 -0800
Message-ID: <52cdb9cf.vHndWhdJLMAgsnrZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaAHUtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 15:49:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, n-horiguchi@ah.jp.nec.com, liwanp@linux.vnet.ibm.com, bob.liu@oracle.com, mhocko@suse.cz

Subject: + mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch added to -mm tree
To: mhocko@suse.cz,bob.liu@oracle.com,liwanp@linux.vnet.ibm.com,n-horiguchi@ah.jp.nec.com,sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 12:49:19 -0800


The patch titled
     Subject: mm: new_vma_page() cannot see NULL vma for hugetlb pages
has been added to the -mm tree.  Its filename is
     mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch

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
Subject: mm: new_vma_page() cannot see NULL vma for hugetlb pages

11c731e81bb0 ("mm/mempolicy: fix !vma in new_vma_page()") has removed
BUG_ON(!vma) from new_vma_page which is partially correct because
page_address_in_vma will return EFAULT for non-linear mappings and at
least shared shmem might be mapped this way.

The patch also tried to prevent NULL ptr for hugetlb pages which is not
correct AFAICS because hugetlb pages cannot be mapped as VM_NONLINEAR and
other conditions in page_address_in_vma seem to be legit and catch real
bugs.

This patch restores BUG_ON for PageHuge to catch potential issues when the
to-be-migrated page is not setup properly.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages mm/mempolicy.c
--- a/mm/mempolicy.c~mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages
+++ a/mm/mempolicy.c
@@ -1199,10 +1199,8 @@ static struct page *new_vma_page(struct
 	}
 
 	if (PageHuge(page)) {
-		if (vma)
-			return alloc_huge_page_noerr(vma, address, 1);
-		else
-			return NULL;
+		BUG_ON(!vma);
+		return alloc_huge_page_noerr(vma, address, 1);
 	}
 	/*
 	 * if !vma, alloc_page_vma() will use task or system default policy
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch
oom_kill-change-oom_killc-to-use-for_each_thread.patch
oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch
oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
x86-memblock-set-current-limit-to-max-low-memory-address.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
mm-init-use-memblock-apis-for-early-memory-allocations.patch
mm-printk-use-memblock-apis-for-early-memory-allocations.patch
mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch
mm-power-use-memblock-apis-for-early-memory-allocations.patch
lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch
lib-cpumaskc-use-memblock-apis-for-early-memory-allocations.patch
mm-sparse-use-memblock-apis-for-early-memory-allocations.patch
mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch
mm-page_cgroup-use-memblock-apis-for-early-memory-allocations.patch
mm-percpu-use-memblock-apis-for-early-memory-allocations.patch
mm-memory_hotplug-use-memblock-apis-for-early-memory-allocations.patch
drivers-firmware-memmapc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mm-initc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
memcg-oom-lock-mem_cgroup_print_oom_info.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
slab-clean-up-kmem_cache_create_memcg-error-handling.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
memcg-slab-clean-up-memcg-cache-initialization-destruction.patch
memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch
memcg-get-rid-of-kmem_cache_dup.patch
slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
memcg-remove-kmem_accounted_activated-flag.patch
memcg-rework-memcg_update_kmem_limit-synchronization.patch
mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
linux-next.patch

