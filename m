From: akpm@linux-foundation.org
Subject: +
 vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch added to
 -mm tree
Date: Mon, 26 Jan 2015 14:12:35 -0800
Message-ID: <54c6bbd3.rEDH/r0oZ4Prt+og%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766AbbAZWMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 17:12:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, cl@linux.com, hannes@cmpxchg.org, mgorman@suse.de, minchan@kernel.org, rientjes@google.com, vdavydov@parallels.com, vinmenon@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: do not use deferrable delayed work for vmstat_update
has been added to the -mm tree.  Its filename is
     vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch

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
Subject: vmstat: do not use deferrable delayed work for vmstat_update

Vinayak Menon has reported that an excessive number of tasks was throttled
in the direct reclaim inside too_many_isolated() because NR_ISOLATED_FILE
was relatively high compared to NR_INACTIVE_FILE.  However it turned out
that the real number of NR_ISOLATED_FILE was 0 and the per-cpu
vm_stat_diff wasn't transfered into the global counter.

vmstat_work which is responsible for the sync is defined as deferrable
delayed work which means that the defined timeout doesn't wake up an idle
CPU.  A CPU might stay in an idle state for a long time and general effort
is to keep such a CPU in this state as long as possible which might lead
to all sorts of troubles for vmstat consumers as can be seen with the
excessive direct reclaim throttling.

This patch basically reverts 39bf6270f524 ("VM statistics: Make timer
deferrable") but it shouldn't cause any problems for idle CPUs because
only CPUs with an active per-cpu drift are woken up since 7cc36bbddde5
("vmstat: on-demand vmstat workers v8") and CPUs which are idle for a
longer time shouldn't have per-cpu drift.

Fixes: 39bf6270f524 (VM statistics: Make timer deferrable)
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Vinayak Menon <vinmenon@codeaurora.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update mm/vmstat.c
--- a/mm/vmstat.c~vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update
+++ a/mm/vmstat.c
@@ -1452,7 +1452,7 @@ static void __init start_shepherd_timer(
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
+		INIT_DELAYED_WORK(per_cpu_ptr(&vmstat_work, cpu),
 			vmstat_update);
 
 	if (!alloc_cpumask_var(&cpu_stat_off, GFP_KERNEL))
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
memcg-remove-extra-newlines-from-memcg-oom-kill-log.patch
mm-vmscan-fix-highidx-argument-type.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-memcontrol-simplify-soft-limit-tree-init-code.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

