Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D54C636C9
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 22:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05C36610F9
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 22:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhGOWwF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 18:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231548AbhGOWwE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 18:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B438C613DC;
        Thu, 15 Jul 2021 22:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626389351;
        bh=vEVJg1wkj8TYLBob6JosLpuC2cStcCsSdSdrqmxQRHc=;
        h=Date:From:To:Subject:From;
        b=A9JGEBVTCBSpLEDhHLKDQv7gwnE6zjcDgm8uVLYUUJINSItPfv19zC2VzJN9rvuyf
         6h04rFVF8j9/3epojp4WB3S3Z0X7UfX9OjDsc8STx8evn2eUr66cKckyfabkBpY5Ek
         UIbRSRqaCN9qlVCe92DvdFd1QxhVu49rMz5O4hPs=
Date:   Thu, 15 Jul 2021 15:49:10 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hdanton@sina.com,
        mhocko@kernel.org, mkoutny@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org,
        ying.huang@intel.com
Subject:  + memcg-infrastructure-to-flush-memcg-stats.patch added
 to -mm tree
Message-ID: <20210715224910.DoG3Xeflm%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     memcg-infrastructure-to-flush-memcg-stats.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-infrastructure-to-flush=
-memcg-stats.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-infrastructure-to-flush=
-memcg-stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
   introduced by this patch decoupled from cgroup_rstat_lock.

Link: https://lkml.kernel.org/r/20210714013948.270662-2-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
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
@@ -1013,6 +1013,8 @@ static inline unsigned long lruvec_page_
 	return x;
 }
=20
+void mem_cgroup_flush_stats(void);
+
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item i=
dx,
 			      int val);
 void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
@@ -1422,6 +1424,10 @@ static inline unsigned long lruvec_page_
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
@@ -685,6 +693,8 @@ void __mod_memcg_lruvec_state(struct lru
=20
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
+	if (!(__this_cpu_inc_return(stats_flush_threshold) % MEMCG_CHARGE_BATCH))
+		queue_work(system_unbound_wq, &stats_flush_work);
 }
=20
 /**
@@ -5248,6 +5258,10 @@ static int mem_cgroup_css_online(struct
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
@@ -5339,6 +5353,26 @@ static void mem_cgroup_css_reset(struct
 	memcg_wb_domain_size_changed(memcg);
 }
=20
+void mem_cgroup_flush_stats(void)
+{
+	if (!spin_trylock(&stats_flush_lock))
+		return;
+
+	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
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
@@ -2893,6 +2893,12 @@ static void shrink_node(pg_data_t *pgdat
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

memcg-switch-lruvec-stats-to-rstat.patch
memcg-infrastructure-to-flush-memcg-stats.patch

