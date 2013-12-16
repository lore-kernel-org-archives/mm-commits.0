From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch removed from -mm tree
Date: Mon, 16 Dec 2013 12:39:42 -0800
Message-ID: <52af650e.B/4SlOuATgrJH/BU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3LPUjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 15:39:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [merged] mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,rientjes@google.com,stable@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 12:39:42 -0800


The patch titled
     Subject: mm: memcg: fix race condition between memcg teardown and swapin
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: fix race condition between memcg teardown and swapin

There is a race condition between a memcg being torn down and a swapin
triggered from a different memcg of a page that was recorded to belong to
the exiting memcg on swapout (with CONFIG_MEMCG_SWAP extension).  The
result is unreclaimable pages pointing to dead memcgs, which can lead to
anything from endless loops in later memcg teardown (the page is charged
to all hierarchical parents but is not on any LRU list) or crashes from
following the dangling memcg pointer.

Memcgs with tasks in them can not be torn down and usually charges don't
show up in memcgs without tasks.  Swapin with the CONFIG_MEMCG_SWAP
extension is the notable exception because it charges the cgroup that was
recorded as owner during swapout, which may be empty and in the process of
being torn down when a task in another memcg triggers the swapin:

  teardown:                 swapin:

                            lookup_swap_cgroup_id()
                            rcu_read_lock()
                            mem_cgroup_lookup()
                            css_tryget()
                            rcu_read_unlock()
  disable css_tryget()
  call_rcu()
    offline_css()
      reparent_charges()
                            res_counter_charge() (hierarchical!)
                            css_put()
                              css_free()
                            pc->mem_cgroup = dead memcg
                            add page to dead lru

Add a final reparenting step into css_free() to make sure any such raced
charges are moved out of the memcg before it's finally freed.

In the longer term it would be cleaner to have the css_tryget() and the
res_counter charge under the same RCU lock section so that the charge
reparenting is deferred until the last charge whose tryget succeeded is
visible.  But this will require more invasive changes that will be harder
to evaluate and backport into stable, so better defer them to a separate
change set.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN mm/memcontrol.c~mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin
+++ a/mm/memcontrol.c
@@ -6355,6 +6355,42 @@ static void mem_cgroup_css_offline(struc
 static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	/*
+	 * XXX: css_offline() would be where we should reparent all
+	 * memory to prepare the cgroup for destruction.  However,
+	 * memcg does not do css_tryget() and res_counter charging
+	 * under the same RCU lock region, which means that charging
+	 * could race with offlining.  Offlining only happens to
+	 * cgroups with no tasks in them but charges can show up
+	 * without any tasks from the swapin path when the target
+	 * memcg is looked up from the swapout record and not from the
+	 * current task as it usually is.  A race like this can leak
+	 * charges and put pages with stale cgroup pointers into
+	 * circulation:
+	 *
+	 * #0                        #1
+	 *                           lookup_swap_cgroup_id()
+	 *                           rcu_read_lock()
+	 *                           mem_cgroup_lookup()
+	 *                           css_tryget()
+	 *                           rcu_read_unlock()
+	 * disable css_tryget()
+	 * call_rcu()
+	 *   offline_css()
+	 *     reparent_charges()
+	 *                           res_counter_charge()
+	 *                           css_put()
+	 *                             css_free()
+	 *                           pc->mem_cgroup = dead memcg
+	 *                           add page to lru
+	 *
+	 * The bulk of the charges are still moved in offline_css() to
+	 * avoid pinning a lot of pages in case a long-term reference
+	 * like a swapout record is deferring the css_free() to long
+	 * after offlining.  But this makes sure we catch any charges
+	 * made after offlining:
+	 */
+	mem_cgroup_reparent_charges(memcg);
 
 	memcg_destroy_kmem(memcg);
 	__mem_cgroup_free(memcg);
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

