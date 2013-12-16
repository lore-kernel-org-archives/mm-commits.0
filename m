From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch
 removed from -mm tree
Date: Mon, 16 Dec 2013 12:39:44 -0800
Message-ID: <52af6510.kTakORjgxNfHrjtk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3LPUjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 15:39:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [merged] mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,rientjes@google.com,stable@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 12:39:44 -0800


The patch titled
     Subject: mm: memcg: do not allow task about to OOM kill to bypass the limit
has been removed from the -mm tree.  Its filename was
     mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: do not allow task about to OOM kill to bypass the limit

4942642080ea ("mm: memcg: handle non-error OOM situations more
gracefully") allowed tasks that already entered a memcg OOM condition to
bypass the memcg limit on subsequent allocation attempts hoping this would
expedite finishing the page fault and executing the kill.

David Rientjes is worried that this breaks memcg isolation guarantees and
since there is no evidence that the bypass actually speeds up fault
processing just change it so that these subsequent charge attempts fail
outright.  The notable exception being __GFP_NOFAIL charges which are
required to bypass the limit regardless.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-bt: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit
+++ a/mm/memcontrol.c
@@ -2694,7 +2694,7 @@ static int __mem_cgroup_try_charge(struc
 		goto bypass;
 
 	if (unlikely(task_in_memcg_oom(current)))
-		goto bypass;
+		goto nomem;
 
 	if (gfp_mask & __GFP_NOFAIL)
 		oom = false;
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

