From: akpm@linux-foundation.org
Subject: [folded-merged] sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:47:14 -0700
Message-ID: <20130429214714.9B6F631C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:44048 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab3D2VrP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:47:15 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so132368yen.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:47:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix
has been removed from the -mm tree.  Its filename was
     sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix.patch

This patch was dropped because it was folded into sparse-vmemmap-specify-vmemmap-population-range-in-bytes.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/vmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/s390/mm/vmem.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix
+++ a/arch/s390/mm/vmem.c
@@ -259,7 +259,7 @@ int __meminit vmemmap_populate(unsigned
 		}
 		address += PAGE_SIZE;
 	}
-	memset(start, 0, nr * sizeof(struct page));
+	memset((void *)start, 0, end - start);
 	ret = 0;
 out:
 	flush_tlb_kernel_range(start, end);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter.patch
memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators.patch
memcg-relax-memcg-iter-caching.patch
memcg-simplify-mem_cgroup_iter.patch
memcg-further-simplify-mem_cgroup_iter.patch
cgroup-remove-css_get_next.patch
memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch
mm-try-harder-to-allocate-vmemmap-blocks.patch
sparse-vmemmap-specify-vmemmap-population-range-in-bytes.patch
x86-64-remove-dead-debugging-code-for-pse-setups.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix.patch
x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch
memcg-avoid-accessing-memcg-after-releasing-reference.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0.patch
mm-memcg-give-exiting-processes-access-to-memory-reserves.patch
swap-redirty-page-if-page-write-fails-on-swap-file.patch
mm-nobootmem-clean-up-of-free_low_memory_core_early.patch
mm-nobootmem-do-memset-after-memblock_reserve.patch
mem-hotunplug-fix-kfree-of-bootmem-memory.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch
memcg-take-reference-before-releasing-rcu_read_lock.patch

