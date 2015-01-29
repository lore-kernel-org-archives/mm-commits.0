From: akpm@linux-foundation.org
Subject: + vmstat-reduce-time-interval-to-stat-update-on-idle-cpu.patch
 added to -mm tree
Date: Thu, 29 Jan 2015 13:18:20 -0800
Message-ID: <54caa39c.raq36zhydjMijro1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbbA2VSV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jan 2015 16:18:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, mhocko@suse.cz, vinmenon@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: Reduce time interval to stat update on idle cpu
has been added to the -mm tree.  Its filename is
     vmstat-reduce-time-interval-to-stat-update-on-idle-cpu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-reduce-time-interval-to-stat-update-on-idle-cpu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-reduce-time-interval-to-stat-update-on-idle-cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: vmstat: Reduce time interval to stat update on idle cpu

It was noted that the vm stat shepherd runs every 2 seconds and that the
vmstat update is then scheduled 2 seconds in the future.

This yields an interval of double the time interval which is not desired.

Change the shepherd so that it does not delay the vmstat update on the
other cpu.  We stil have to use schedule_delayed_work since we are using a
delayed_work_struct but we can set the delay to 0.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmstat.c~vmstat-reduce-time-interval-to-stat-update-on-idle-cpu mm/vmstat.c
--- a/mm/vmstat.c~vmstat-reduce-time-interval-to-stat-update-on-idle-cpu
+++ a/mm/vmstat.c
@@ -1437,8 +1437,8 @@ static void vmstat_shepherd(struct work_
 		if (need_update(cpu) &&
 			cpumask_test_and_clear_cpu(cpu, cpu_stat_off))
 
-			schedule_delayed_work_on(cpu, &per_cpu(vmstat_work, cpu),
-				__round_jiffies_relative(sysctl_stat_interval, cpu));
+			schedule_delayed_work_on(cpu,
+				&per_cpu(vmstat_work, cpu), 0);
 
 	put_online_cpus();
 
_

Patches currently in -mm which might be from cl@linux.com are

mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch
mm-dont-use-compound_head-in-virt_to_head_page.patch
mm-dont-use-compound_head-in-virt_to_head_page-v3.patch
mm-slub-fix-typo.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
slub-never-fail-to-shrink-cache.patch
slub-fix-kmem_cache_shrink-return-value.patch
slub-make-dead-caches-discard-free-slabs-immediately.patch
vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch
vmstat-reduce-time-interval-to-stat-update-on-idle-cpu.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
cpumask-always-use-nr_cpu_ids-in-formatting-and-parsing-functions.patch
lib-vsprintf-implement-bitmap-printing-through-%pb.patch
cpumask-nodemask-implement-cpumask-nodemask_pr_args.patch
slub-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
linux-next.patch

