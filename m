From: akpm@linux-foundation.org
Subject: [merged]
 vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:38:57 -0800
Message-ID: <54dd0151.+Y7+PetLyTZDzNIv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbbBLTi6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, cl@linux.com, hannes@cmpxchg.org, mgorman@suse.de, minchan@kernel.org, rientjes@google.com, vdavydov@parallels.com, vinmenon@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: do not use deferrable delayed work for vmstat_update
has been removed from the -mm tree.  Its filename was
     vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: vmstat: do not use deferrable delayed work for vmstat_update

Vinayak Menon has reported that an excessive number of tasks was throttled
in the direct reclaim inside too_many_isolated() because NR_ISOLATED_FILE
was relatively high compared to NR_INACTIVE_FILE.  However it turned out
that the real number of NR_ISOLATED_FILE was 0 and the per-cpu
vm_stat_diff wasn't transferred into the global counter.

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

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
memcg-cleanup-static-keys-decrement.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

