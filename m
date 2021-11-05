Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D56C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBE9C60E8B
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhKEUkN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhKEUkM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FCC66056B;
        Fri,  5 Nov 2021 20:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144652;
        bh=sbSbvXulVG76Pdn5K0qar18qXE+PpMEkpUnJ5PUvKEs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UyOKve9TzyKbcNUVOz5tUwWrg5OAtOfUrq1WEHZ/xMbonwK95eQQuHgQHjNfRMnH5
         epM/UrSuKdW5NOei3ia6/vqy5/LpXQYun47zGnRndJ+qHVnkPfeLeRjxiAy+jiVStL
         mU3mOTBJmoVfaoE7hlIC0JDxoYOI+1hJpJ92C8a0=
Date:   Fri, 05 Nov 2021 13:37:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@kernel.org, mkoutny@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject:  [patch 055/262] memcg: flush stats only if updated
Message-ID: <20211105203731.uHUWGR8SE%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Shakeel Butt <shakeelb@google.com>
Subject: memcg: flush stats only if updated

At the moment, the kernel flushes the memcg stats on every refault and
also on every reclaim iteration.  Although rstat maintains per-cpu update
tree but on the flush the kernel still has to go through all the cpu rstat
update tree to check if there is anything to flush.  This patch adds the
tracking on the stats update side to make flush side more clever by
skipping the flush if there is no update.

The stats update codepath is very sensitive performance wise for many
workloads and benchmarks.  So, we can not follow what the commit
aa48e47e3906 ("memcg: infrastructure to flush memcg stats") did which was
triggering async flush through queue_work() and caused a lot performance
regression reports.  That got reverted by the commit 1f828223b799 ("memcg:
flush lruvec stats in the refault").

In this patch we kept the stats update codepath very minimal and let the
stats reader side to flush the stats only when the updates are over a
specific threshold.  For now the threshold is (nr_cpus * CHARGE_BATCH).

To evaluate the impact of this patch, an 8 GiB tmpfs file is created on a
system with swap-on-zram and the file was pushed to swap through
memory.force_empty interface.  On reading the whole file, the memcg stat
flush in the refault code path is triggered.  With this patch, we observed
63% reduction in the read time of 8 GiB file.

Link: https://lkml.kernel.org/r/20211001190040.48086-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Reviewed-by: "Michal Koutn=C3=BD" <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   78 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 23 deletions(-)

--- a/mm/memcontrol.c~memcg-flush-stats-only-if-updated
+++ a/mm/memcontrol.c
@@ -103,11 +103,6 @@ static bool do_memsw_account(void)
 	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_noswap;
 }
=20
-/* memcg and lruvec stats flushing */
-static void flush_memcg_stats_dwork(struct work_struct *w);
-static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
-static DEFINE_SPINLOCK(stats_flush_lock);
-
 #define THRESHOLDS_EVENTS_TARGET 128
 #define SOFTLIMIT_EVENTS_TARGET 1024
=20
@@ -635,6 +630,56 @@ mem_cgroup_largest_soft_limit_node(struc
 	return mz;
 }
=20
+/*
+ * memcg and lruvec stats flushing
+ *
+ * Many codepaths leading to stats update or read are performance sensitiv=
e and
+ * adding stats flushing in such codepaths is not desirable. So, to optimi=
ze the
+ * flushing the kernel does:
+ *
+ * 1) Periodically and asynchronously flush the stats every 2 seconds to n=
ot let
+ *    rstat update tree grow unbounded.
+ *
+ * 2) Flush the stats synchronously on reader side only when there are mor=
e than
+ *    (MEMCG_CHARGE_BATCH * nr_cpus) update events. Though this optimizati=
on
+ *    will let stats be out of sync by atmost (MEMCG_CHARGE_BATCH * nr_cpu=
s) but
+ *    only for 2 seconds due to (1).
+ */
+static void flush_memcg_stats_dwork(struct work_struct *w);
+static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
+static DEFINE_SPINLOCK(stats_flush_lock);
+static DEFINE_PER_CPU(unsigned int, stats_updates);
+static atomic_t stats_flush_threshold =3D ATOMIC_INIT(0);
+
+static inline void memcg_rstat_updated(struct mem_cgroup *memcg)
+{
+	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	if (!(__this_cpu_inc_return(stats_updates) % MEMCG_CHARGE_BATCH))
+		atomic_inc(&stats_flush_threshold);
+}
+
+static void __mem_cgroup_flush_stats(void)
+{
+	if (!spin_trylock(&stats_flush_lock))
+		return;
+
+	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
+	atomic_set(&stats_flush_threshold, 0);
+	spin_unlock(&stats_flush_lock);
+}
+
+void mem_cgroup_flush_stats(void)
+{
+	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
+		__mem_cgroup_flush_stats();
+}
+
+static void flush_memcg_stats_dwork(struct work_struct *w)
+{
+	mem_cgroup_flush_stats();
+	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
+}
+
 /**
  * __mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -647,7 +692,7 @@ void __mod_memcg_state(struct mem_cgroup
 		return;
=20
 	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
-	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	memcg_rstat_updated(memcg);
 }
=20
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
@@ -675,10 +720,12 @@ void __mod_memcg_lruvec_state(struct lru
 	memcg =3D pn->memcg;
=20
 	/* Update memcg */
-	__mod_memcg_state(memcg, idx, val);
+	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
=20
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
+
+	memcg_rstat_updated(memcg);
 }
=20
 /**
@@ -780,7 +827,7 @@ void __count_memcg_events(struct mem_cgr
 		return;
=20
 	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
-	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	memcg_rstat_updated(memcg);
 }
=20
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
@@ -5341,21 +5388,6 @@ static void mem_cgroup_css_reset(struct
 	memcg_wb_domain_size_changed(memcg);
 }
=20
-void mem_cgroup_flush_stats(void)
-{
-	if (!spin_trylock(&stats_flush_lock))
-		return;
-
-	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
-	spin_unlock(&stats_flush_lock);
-}
-
-static void flush_memcg_stats_dwork(struct work_struct *w)
-{
-	mem_cgroup_flush_stats();
-	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
-}
-
 static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, in=
t cpu)
 {
 	struct mem_cgroup *memcg =3D mem_cgroup_from_css(css);
_
