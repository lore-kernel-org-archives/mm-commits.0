Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88620C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71F32610E5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350502AbhICU6b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350474AbhICU63 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8296E60184;
        Fri,  3 Sep 2021 20:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702648;
        bh=UiuED2GilzXupQ8RXjMH7ITF0zvtLhNtw2BpJChB8BU=;
        h=Date:From:To:Subject:From;
        b=Jjyk5+FJs7j2bgpszUvEnjiUcLtolooNS9tw1bZuhcRDmqK1gsCNS5eKzz7SqQfq9
         64F5wJ8tUUih4VqTZwozf4CalMBTt+slLnIrHFkWgRoHezYHBnylI163gBB+1dqckZ
         Y0pogq1uXOqaL5ypIVT2UEtYDWJ1I/OI4dwJQihI=
Date:   Fri, 03 Sep 2021 13:57:28 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hdanton@sina.com,
        m.szyprowski@samsung.com, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, tj@kernel.org, ying.huang@intel.com
Subject:  [merged] memcg-infrastructure-to-flush-memcg-stats.patch
 removed from -mm tree
Message-ID: <20210903205728.s3i4yfRv5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: infrastructure to flush memcg stats
has been removed from the -mm tree.  Its filename was
     memcg-infrastructure-to-flush-memcg-stats.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Shakeel Butt <shakeelb@google.com>
Subject: memcg: infrastructure to flush memcg stats

At the moment memcg stats are read in four contexts:

1. memcg stat user interfaces
2. dirty throttling
3. page fault
4. memory reclaim

Currently the kernel flushes the stats for first two cases.  Flushing the
stats for remaining two casese may have performance impact.  Always
flushing the memcg stats on the page fault code path may negatively
impacts the performance of the applications.  In addition flushing in the
memory reclaim code path, though treated as slowpath, can become the
source of contention for the global lock taken for stat flushing because
when system or memcg is under memory pressure, many tasks may enter the
reclaim path.

This patch uses following mechanisms to solve these challenges:

1. Periodically flush the stats from root memcg every 2 seconds.  This
   will time limit the out of sync stats.

2. Asynchronously flush the stats after fixed number of stat updates.=20
   In the worst case the stat can be out of sync by O(nr_cpus * BATCH) for
   2 seconds.

3. For avoiding thundering herd to flush the stats particularly from
   the memory reclaim context, introduce memcg local spinlock and let only
   one flusher active at a time.  This could have been done through
   cgroup_rstat_lock lock but that lock is used by other subsystem and for
   userspace reading memcg stats.  So, it is better to keep flushers
   introduced by this patch decoupled from cgroup_rstat_lock.  However we
   would have to use irqsafe version of rstat flush but that is fine as
   this code path will be flushing for whole tree and do the work for
   everyone.  No one will be waiting for that worker.

[shakeelb@google.com: fix sleep-in-wrong context bug]
  Link: https://lkml.kernel.org/r/20210716212137.1391164-2-shakeelb@google.=
com
Link: https://lkml.kernel.org/r/20210714013948.270662-2-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++++
 mm/memcontrol.c            |   34 ++++++++++++++++++++++++++++++++++
 mm/vmscan.c                |    6 ++++++
 3 files changed, 46 insertions(+)

--- a/include/linux/memcontrol.h~memcg-infrastructure-to-flush-memcg-stats
+++ a/include/linux/memcontrol.h
@@ -1023,6 +1023,8 @@ static inline unsigned long lruvec_page_
 	return x;
 }
=20
+void mem_cgroup_flush_stats(void);
+
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item i=
dx,
 			      int val);
 void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
@@ -1438,6 +1440,10 @@ static inline unsigned long lruvec_page_
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
=20
+static inline void mem_cgroup_flush_stats(void)
+{
+}
+
 static inline void __mod_memcg_lruvec_state(struct lruvec *lruvec,
 					    enum node_stat_item idx, int val)
 {
--- a/mm/memcontrol.c~memcg-infrastructure-to-flush-memcg-stats
+++ a/mm/memcontrol.c
@@ -103,6 +103,14 @@ static bool do_memsw_account(void)
 	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_noswap;
 }
=20
+/* memcg and lruvec stats flushing */
+static void flush_memcg_stats_dwork(struct work_struct *w);
+static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
+static void flush_memcg_stats_work(struct work_struct *w);
+static DECLARE_WORK(stats_flush_work, flush_memcg_stats_work);
+static DEFINE_PER_CPU(unsigned int, stats_flush_threshold);
+static DEFINE_SPINLOCK(stats_flush_lock);
+
 #define THRESHOLDS_EVENTS_TARGET 128
 #define SOFTLIMIT_EVENTS_TARGET 1024
=20
@@ -674,6 +682,8 @@ void __mod_memcg_lruvec_state(struct lru
=20
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
+	if (!(__this_cpu_inc_return(stats_flush_threshold) % MEMCG_CHARGE_BATCH))
+		queue_work(system_unbound_wq, &stats_flush_work);
 }
=20
 /**
@@ -5240,6 +5250,10 @@ static int mem_cgroup_css_online(struct
 	/* Online state pins memcg ID, memcg ID pins CSS */
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
+
+	if (unlikely(mem_cgroup_is_root(memcg)))
+		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
+				   2UL*HZ);
 	return 0;
 }
=20
@@ -5331,6 +5345,26 @@ static void mem_cgroup_css_reset(struct
 	memcg_wb_domain_size_changed(memcg);
 }
=20
+void mem_cgroup_flush_stats(void)
+{
+	if (!spin_trylock(&stats_flush_lock))
+		return;
+
+	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
+	spin_unlock(&stats_flush_lock);
+}
+
+static void flush_memcg_stats_dwork(struct work_struct *w)
+{
+	mem_cgroup_flush_stats();
+	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
+}
+
+static void flush_memcg_stats_work(struct work_struct *w)
+{
+	mem_cgroup_flush_stats();
+}
+
 static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, in=
t cpu)
 {
 	struct mem_cgroup *memcg =3D mem_cgroup_from_css(css);
--- a/mm/vmscan.c~memcg-infrastructure-to-flush-memcg-stats
+++ a/mm/vmscan.c
@@ -2897,6 +2897,12 @@ static void shrink_node(pg_data_t *pgdat
 	target_lruvec =3D mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
=20
 again:
+	/*
+	 * Flush the memory cgroup stats, so that we read accurate per-memcg
+	 * lruvec stats for heuristics.
+	 */
+	mem_cgroup_flush_stats();
+
 	memset(&sc->nr, 0, sizeof(sc->nr));
=20
 	nr_reclaimed =3D sc->nr_reclaimed;
_

Patches currently in -mm which might be from shakeelb@google.com are


