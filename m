Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F82C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377833AbiATVZI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiATVZG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:25:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47637C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:25:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05023B81E69
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADE2C340E0;
        Thu, 20 Jan 2022 21:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713903;
        bh=z/FZ1JyCrVqX26KeUOtboHWW1QRuk/kM/00Coi06io8=;
        h=Date:From:To:Subject:From;
        b=rJj83e4Sl3gLUaKHmi8tO3BjoL+iMVJXYhdvoH7QmcEH46B05DNOkNGZncwVbb5OU
         NEMhxMy4gTTOb4wlwaXEvtvBaS0f/uA2Ij22BshiFy40pZIAf+5BxmXPxxZQn6k3Y+
         xcIPYTI7I708bK1qYSQ3Dj+/skZBQXoe2LKqif2M=
Date:   Thu, 20 Jan 2022 13:25:03 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged]
 memcg-better-bounds-on-the-memcg-stats-updates.patch removed from -mm tree
Message-ID: <20220120212503.LFxdZcm7P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: better bounds on the memcg stats updates
has been removed from the -mm tree.  Its filename was
     memcg-better-bounds-on-the-memcg-stats-updates.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
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

Patches currently in -mm which might be from shakeelb@google.com are


