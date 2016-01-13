From: akpm@linux-foundation.org
Subject: + mm-memcontrol-add-sock-to-cgroup2-memorystat.patch added to -mm tree
Date: Wed, 13 Jan 2016 14:49:51 -0800
Message-ID: <5696d48f.5WLWsnoIfYhAnXim%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbcAMWtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jan 2016 17:49:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: add "sock" to cgroup2 memory.stat
has been added to the -mm tree.  Its filename is
     mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-add-sock-to-cgroup2-memorystat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: add "sock" to cgroup2 memory.stat

Provide statistics on how much of a cgroup's memory footprint is made up
of socket buffers from network connections owned by the group.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 ++++-
 mm/memcontrol.c            |    6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-add-sock-to-cgroup2-memorystat include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-add-sock-to-cgroup2-memorystat
+++ a/include/linux/memcontrol.h
@@ -50,6 +50,9 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_WRITEBACK,	/* # of pages under writeback */
 	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
 	MEM_CGROUP_STAT_NSTATS,
+	/* default hierarchy stats */
+	MEMCG_SOCK,
+	MEMCG_NR_STAT,
 };
 
 struct mem_cgroup_reclaim_cookie {
@@ -87,7 +90,7 @@ enum mem_cgroup_events_target {
 
 #ifdef CONFIG_MEMCG
 struct mem_cgroup_stat_cpu {
-	long count[MEM_CGROUP_STAT_NSTATS];
+	long count[MEMCG_NR_STAT];
 	unsigned long events[MEMCG_NR_EVENTS];
 	unsigned long nr_page_events;
 	unsigned long targets[MEM_CGROUP_NTARGETS];
diff -puN mm/memcontrol.c~mm-memcontrol-add-sock-to-cgroup2-memorystat mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-add-sock-to-cgroup2-memorystat
+++ a/mm/memcontrol.c
@@ -5118,6 +5118,8 @@ static int memory_stat_show(struct seq_f
 		   tree_stat(memcg, MEM_CGROUP_STAT_RSS) * PAGE_SIZE);
 	seq_printf(m, "file %lu\n",
 		   tree_stat(memcg, MEM_CGROUP_STAT_CACHE) * PAGE_SIZE);
+	seq_printf(m, "sock %lu\n",
+		   tree_stat(memcg, MEMCG_SOCK) * PAGE_SIZE);
 
 	/* Per-consumer breakdowns */
 
@@ -5619,6 +5621,8 @@ bool mem_cgroup_charge_skmem(struct mem_
 	if (in_softirq())
 		gfp_mask = GFP_NOWAIT;
 
+	this_cpu_add(memcg->stat->count[MEMCG_SOCK], nr_pages);
+
 	if (try_charge(memcg, gfp_mask, nr_pages) == 0)
 		return true;
 
@@ -5638,6 +5642,8 @@ void mem_cgroup_uncharge_skmem(struct me
 		return;
 	}
 
+	this_cpu_sub(memcg->stat->count[MEMCG_SOCK], nr_pages);
+
 	page_counter_uncharge(&memcg->memory, nr_pages);
 	css_put_many(&memcg->css, nr_pages);
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-memcontrol-export-root_mem_cgroup.patch
net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch
net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix.patch
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

