From: akpm@linux-foundation.org
Subject: + hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb-revert.patch added to -mm tree
Date: Mon, 30 Jul 2012 15:31:51 -0700
Message-ID: <20120730223152.9758C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48463 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab2G3Wbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 18:31:55 -0400
Received: by weyr1 with SMTP id r1so246742wey.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 15:31:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.cz


The patch titled
     Subject: hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb-revert
has been added to the -mm tree.  Its filename is
     hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb-revert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb-revert

This reverts the patch "hugetlb: avoid taking i_mmap_mutex in
unmap_single_vma() for hugetlb" from mmotm.

This patch is possibly a mistake and blocks the merging of a hugetlb fix
where page tables can get corrupted (https://lkml.org/lkml/2012/7/24/93).
The motivation of the patch appears to be two-fold.

First, it believes that the i_mmap_mutex is to protect against list
corruption of the page->lru lock but that is not quite accurate. The
i_mmap_mutex for shared page tables is meant to protect against races
when sharing and unsharing the page tables. For example, an important
use of i_mmap_mutex is to stabilise the page_count of the PMD page
during huge_pmd_unshare.

Second, it is protecting against a potential deadlock when
unmap_unsingle_page is called from unmap_mapping_range(). However, hugetlbfs
should never be in this path. It has its own setattr and truncate handlers
where are the paths that use unmap_mapping_range().

Unless Aneesh has another reason for the patch, it should be reverted
to preserve hugetlb page sharing locking.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb-revert mm/memory.c
--- a/mm/memory.c~hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb-revert
+++ a/mm/memory.c
@@ -1343,8 +1343,11 @@ static void unmap_single_vma(struct mmu_
 			 * Since no pte has actually been setup, it is
 			 * safe to do nothing in this case.
 			 */
-			if (vma->vm_file)
+			if (vma->vm_file) {
+				mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
 				__unmap_hugepage_range(tlb, vma, start, end, NULL);
+				mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+			}
 		} else
 			unmap_page_range(tlb, vma, start, end, details);
 	}
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-fix-wrong-argument-of-migrate_huge_pages-in-soft_offline_huge_page.patch
linux-next.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb-revert.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix.patch
mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch
mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch
mm-allow-pf_memalloc-from-softirq-context.patch
mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch
mm-ignore-mempolicies-when-using-alloc_no_watermark.patch
net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket.patch
netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch
netvm-allow-skb-allocation-to-use-pfmemalloc-reserves.patch
netvm-propagate-page-pfmemalloc-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch
mm-micro-optimise-slab-to-avoid-a-function-call.patch
nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch
mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch
mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch
netvm-prevent-a-stream-specific-deadlock.patch
selinux-tag-avc-cache-alloc-as-non-critical.patch
mm-methods-for-teaching-filesystems-about-pg_swapcache-pages.patch
mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch
mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o-fix.patch
mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages.patch
mm-swap-implement-generic-handler-for-swap_activate.patch
mm-add-support-for-direct_io-to-highmem-pages.patch
nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages.patch
nfs-disable-data-cache-revalidation-for-swapfiles.patch
nfs-enable-swap-on-nfs.patch
nfs-enable-swap-on-nfs-fix.patch
nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch
swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables.patch

