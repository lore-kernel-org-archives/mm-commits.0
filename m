Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79A0C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiANWFm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58478 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiANWFm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:05:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EC3EB8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5FAC36AE5;
        Fri, 14 Jan 2022 22:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197940;
        bh=oKn+aBO7BR0Xe5e3+yhIf2M8qlqSguFVow4JagZrtXg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EhnOAkvDYQNsZXCdGYtQF8TE2r08hPbJjd91QooGQhDPcM38Bxyh2IXD+UbpyyVmx
         2OzUmwxaeHOBbTDxKlzBr4zUQrYf9DHXUg7GIHMS8k3ECBXctwN4vY6X4F3+u6eal7
         FTPDswWbdyZ263M9rPheQigPV1daoD/yopHsytEI=
Date:   Fri, 14 Jan 2022 14:05:39 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@kernel.org, mkoutny@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject:  [patch 051/146] memcg: better bounds on the memcg stats
 updates
Message-ID: <20220114220539.4-Ius7f56%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Shakeel Butt <shakeelb@google.com>
Subject: memcg: better bounds on the memcg stats updates

The commit 11192d9c124d ("memcg: flush stats only if updated") added
tracking of memcg stats updates which is used by the readers to flush only
if the updates are over a certain threshold.  However each individual
update can correspond to a large value change for a given stat.  For
example adding or removing a hugepage to an LRU changes the stat by
thp_nr_pages (512 on x86_64).  Treating the update related to THP as one
can keep the stat off, in theory, by (thp_nr_pages * nr_cpus *
CHARGE_BATCH) before flush.

To handle such scenarios, this patch adds consideration of the stat update
value as well instead of just the update event.  In addition let the asyn
flusher unconditionally flush the stats to put time limit on the stats
skew and hopefully a lot less readers would need to flush.

Link: https://lkml.kernel.org/r/20211118065350.697046-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutn=C3=BD" <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~memcg-better-bounds-on-the-memcg-stats-updates
+++ a/mm/memcontrol.c
@@ -629,11 +629,17 @@ static DEFINE_SPINLOCK(stats_flush_lock)
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_threshold =3D ATOMIC_INIT(0);
=20
-static inline void memcg_rstat_updated(struct mem_cgroup *memcg)
+static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
+	unsigned int x;
+
 	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
-	if (!(__this_cpu_inc_return(stats_updates) % MEMCG_CHARGE_BATCH))
-		atomic_inc(&stats_flush_threshold);
+
+	x =3D __this_cpu_add_return(stats_updates, abs(val));
+	if (x > MEMCG_CHARGE_BATCH) {
+		atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
+		__this_cpu_write(stats_updates, 0);
+	}
 }
=20
 static void __mem_cgroup_flush_stats(void)
@@ -656,7 +662,7 @@ void mem_cgroup_flush_stats(void)
=20
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
-	mem_cgroup_flush_stats();
+	__mem_cgroup_flush_stats();
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
 }
=20
@@ -672,7 +678,7 @@ void __mod_memcg_state(struct mem_cgroup
 		return;
=20
 	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
-	memcg_rstat_updated(memcg);
+	memcg_rstat_updated(memcg, val);
 }
=20
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
@@ -705,7 +711,7 @@ void __mod_memcg_lruvec_state(struct lru
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
=20
-	memcg_rstat_updated(memcg);
+	memcg_rstat_updated(memcg, val);
 }
=20
 /**
@@ -789,7 +795,7 @@ void __count_memcg_events(struct mem_cgr
 		return;
=20
 	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
-	memcg_rstat_updated(memcg);
+	memcg_rstat_updated(memcg, count);
 }
=20
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
_
