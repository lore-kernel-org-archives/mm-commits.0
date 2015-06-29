From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-try-charging-a-page-before-setting-page-up-to-date.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:38:32 -0700
Message-ID: <5591acc8.rVNhnHvB976Psh15%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbbF2Uid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: Try charging a page before setting page up to date
has been removed from the -mm tree.  Its filename was
     mm-memcg-try-charging-a-page-before-setting-page-up-to-date.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm, memcg: Try charging a page before setting page up to date

Historically memcg overhead was high even if memcg was unused. This has
improved a lot but it still showed up in a profile summary as being a
problem.

/usr/src/linux-4.0-vanilla/mm/memcontrol.c                           6.6441   395842
  mem_cgroup_try_charge                                                        2.950%   175781
  __mem_cgroup_count_vm_event                                                  1.431%    85239
  mem_cgroup_page_lruvec                                                       0.456%    27156
  mem_cgroup_commit_charge                                                     0.392%    23342
  uncharge_list                                                                0.323%    19256
  mem_cgroup_update_lru_size                                                   0.278%    16538
  memcg_check_events                                                           0.216%    12858
  mem_cgroup_charge_statistics.isra.22                                         0.188%    11172
  try_charge                                                                   0.150%     8928
  commit_charge                                                                0.141%     8388
  get_mem_cgroup_from_mm                                                       0.121%     7184

That is showing that 6.64% of system CPU cycles were in memcontrol.c and
dominated by mem_cgroup_try_charge. The annotation shows that the bulk of
the cost was checking PageSwapCache which is expected to be cache hot but is
very expensive. The problem appears to be that __SetPageUptodate is called
just before the check which is a write barrier. It is required to make sure
struct page and page data is written before the PTE is updated and the data
visible to userspace. memcg charging does not require or need the barrier
but gets unfairly hit with the cost so this patch attempts the charging
before the barrier.  Aside from the accidental cost to memcg there is the
added benefit that the barrier is avoided if the page cannot be charged.
When applied the relevant profile summary is as follows.

/usr/src/linux-4.0-chargefirst-v2r1/mm/memcontrol.c                  3.7907   223277
  __mem_cgroup_count_vm_event                                                  1.143%    67312
  mem_cgroup_page_lruvec                                                       0.465%    27403
  mem_cgroup_commit_charge                                                     0.381%    22452
  uncharge_list                                                                0.332%    19543
  mem_cgroup_update_lru_size                                                   0.284%    16704
  get_mem_cgroup_from_mm                                                       0.271%    15952
  mem_cgroup_try_charge                                                        0.237%    13982
  memcg_check_events                                                           0.222%    13058
  mem_cgroup_charge_statistics.isra.22                                         0.185%    10920
  commit_charge                                                                0.140%     8235
  try_charge                                                                   0.131%     7716

That brings the overhead down to 3.79% and leaves the memcg fault accounting
to the root cgroup but it's an improvement. The difference in headline
performance of the page fault microbench is marginal as memcg is such a
small component of it.

pft faults
                                       4.0.0                  4.0.0
                                     vanilla            chargefirst
Hmean    faults/cpu-1 1443258.1051 (  0.00%) 1509075.7561 (  4.56%)
Hmean    faults/cpu-3 1340385.9270 (  0.00%) 1339160.7113 ( -0.09%)
Hmean    faults/cpu-5  875599.0222 (  0.00%)  874174.1255 ( -0.16%)
Hmean    faults/cpu-7  601146.6726 (  0.00%)  601370.9977 (  0.04%)
Hmean    faults/cpu-8  510728.2754 (  0.00%)  510598.8214 ( -0.03%)
Hmean    faults/sec-1 1432084.7845 (  0.00%) 1497935.5274 (  4.60%)
Hmean    faults/sec-3 3943818.1437 (  0.00%) 3941920.1520 ( -0.05%)
Hmean    faults/sec-5 3877573.5867 (  0.00%) 3869385.7553 ( -0.21%)
Hmean    faults/sec-7 3991832.0418 (  0.00%) 3992181.4189 (  0.01%)
Hmean    faults/sec-8 3987189.8167 (  0.00%) 3986452.2204 ( -0.02%)

It's only visible at single threaded. The overhead is there for higher
threads but other factors dominate.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/memory.c~mm-memcg-try-charging-a-page-before-setting-page-up-to-date mm/memory.c
--- a/mm/memory.c~mm-memcg-try-charging-a-page-before-setting-page-up-to-date
+++ a/mm/memory.c
@@ -2081,11 +2081,12 @@ static int wp_page_copy(struct mm_struct
 			goto oom;
 		cow_user_page(new_page, old_page, address, vma);
 	}
-	__SetPageUptodate(new_page);
 
 	if (mem_cgroup_try_charge(new_page, mm, GFP_KERNEL, &memcg))
 		goto oom_free_new;
 
+	__SetPageUptodate(new_page);
+
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 
 	/*
@@ -2689,6 +2690,10 @@ static int do_anonymous_page(struct mm_s
 	page = alloc_zeroed_user_highpage_movable(vma, address);
 	if (!page)
 		goto oom;
+
+	if (mem_cgroup_try_charge(page, mm, GFP_KERNEL, &memcg))
+		goto oom_free_page;
+
 	/*
 	 * The memory barrier inside __SetPageUptodate makes sure that
 	 * preceeding stores to the page contents become visible before
@@ -2696,9 +2701,6 @@ static int do_anonymous_page(struct mm_s
 	 */
 	__SetPageUptodate(page);
 
-	if (mem_cgroup_try_charge(page, mm, GFP_KERNEL, &memcg))
-		goto oom_free_page;
-
 	entry = mk_pte(page, vma->vm_page_prot);
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry));
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
memblock-introduce-a-for_each_reserved_mem_region-iterator.patch
mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-inline-some-helper-functions-fix2.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set-fix.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch
mm-meminit-remove-mminit_verify_page_links.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

