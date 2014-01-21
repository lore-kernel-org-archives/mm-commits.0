From: akpm@linux-foundation.org
Subject: +
 memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter.patch
 added to -mm tree
Date: Tue, 21 Jan 2014 11:41:22 -0800
Message-ID: <52decd62.3qumuqTCQTjvMmmX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaAUTlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 14:41:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz

Subject: + memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter.patch added to -mm tree
To: mhocko@suse.cz,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 11:41:22 -0800


The patch titled
     Subject: memcg: fix css reference leak and endless loop in mem_cgroup_iter
has been added to the -mm tree.  Its filename is
     memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter.patch

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
Subject: memcg: fix css reference leak and endless loop in mem_cgroup_iter

19f39402864e ("memcg: simplify mem_cgroup_iter") has reorganized
mem_cgroup_iter code in order to simplify it.  A part of that change was
dropping an optimization which didn't call css_tryget on the root of the
walked tree.  The patch however didn't change the css_put part in
mem_cgroup_iter which excludes root.

This wasn't an issue at the time because __mem_cgroup_iter_next bailed out
for root early without taking a reference as cgroup iterators
(css_next_descendant_pre) didn't visit root themselves.

Nevertheless cgroup iterators have been reworked to visit root by
bd8815a6d802 ("cgroup: make css_for_each_descendant() and friends include
the origin css in the iteration") when the root bypass have been dropped
in __mem_cgroup_iter_next.  This means that css_put is not called for root
and so css along with mem_cgroup and other cgroup internal object tied by
css lifetime are never freed.

Fix the issue by reintroducing root check in __mem_cgroup_iter_next and do
not take css reference for it.

This reference counting magic protects us also from another issue, an
endless loop reported by Hugh Dickins when reclaim races with root removal
and css_tryget called by iterator internally would fail.  There would be
no other nodes to visit so __mem_cgroup_iter_next would return NULL and
mem_cgroup_iter would interpret it as "start looping from root again" and
so mem_cgroup_iter would loop forever internally.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter
+++ a/mm/memcontrol.c
@@ -1076,14 +1076,22 @@ skip_node:
 	 * skipped and we should continue the tree walk.
 	 * last_visited css is safe to use because it is
 	 * protected by css_get and the tree walk is rcu safe.
+	 *
+	 * We do not take a reference on the root of the tree walk
+	 * because we might race with the root removal when it would
+	 * be the only node in the iterated hierarchy and mem_cgroup_iter
+	 * would end up in an endless loop because it expects that at
+	 * least one valid node will be returned. Root cannot disappear
+	 * because caller of the iterator should hold it already so
+	 * skipping css reference should be safe.
 	 */
 	if (next_css) {
-		if ((next_css->flags & CSS_ONLINE) && css_tryget(next_css))
+		if ((next_css->flags & CSS_ONLINE) &&
+				(next_css == &root->css || css_tryget(next_css)))
 			return mem_cgroup_from_css(next_css);
-		else {
-			prev_css = next_css;
-			goto skip_node;
-		}
+
+		prev_css = next_css;
+		goto skip_node;
 	}
 
 	return NULL;
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
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
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
mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch
mm-memcg-fix-last_dead_count-memory-wastage.patch
mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized.patch
mm-oom-prefer-thread-group-leaders-for-display-purposes.patch
memcg-fix-endless-loop-caused-by-mem_cgroup_iter.patch
memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
linux-next.patch

