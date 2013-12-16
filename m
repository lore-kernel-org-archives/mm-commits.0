From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch removed
 from -mm tree
Date: Mon, 16 Dec 2013 12:39:22 -0800
Message-ID: <52af64fa.fAs0cMcu1R/iu+Sp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3LPUjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 15:39:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wdauchy@gmail.com, stable@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [merged] mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,rientjes@google.com,stable@vger.kernel.org,wdauchy@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 12:39:22 -0800


The patch titled
     Subject: mm: memcg: do not declare OOM from __GFP_NOFAIL allocations
has been removed from the -mm tree.  Its filename was
     mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: do not declare OOM from __GFP_NOFAIL allocations

84235de394d9 ("fs: buffer: move allocation failure loop into the
allocator") started recognizing __GFP_NOFAIL in memory cgroups but forgot
to disable the OOM killer.

Any task that does not fail allocation will also not enter the OOM
completion path.  So don't declare an OOM state in this case or it'll be
leaked and the task be able to bypass the limit until the next
userspace-triggered page fault cleans up the OOM state.

Reported-by: William Dauchy <wdauchy@gmail.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[3.12.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memcontrol.c~mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations
+++ a/mm/memcontrol.c
@@ -2696,6 +2696,9 @@ static int __mem_cgroup_try_charge(struc
 	if (unlikely(task_in_memcg_oom(current)))
 		goto bypass;
 
+	if (gfp_mask & __GFP_NOFAIL)
+		oom = false;
+
 	/*
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
proc-meminfo-provide-estimated-available-memory.patch
mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
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
memcg-oom-lock-mem_cgroup_print_oom_info.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

