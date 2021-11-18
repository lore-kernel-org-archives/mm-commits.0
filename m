Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EF4C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD3E861A81
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhKRVlT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 16:41:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231343AbhKRVlT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 16:41:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5EB16120A;
        Thu, 18 Nov 2021 21:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637271499;
        bh=DW/tKWIfhNHu7cLau8pgxR62D2hnnc8DfdQVrrA5s/Y=;
        h=Date:From:To:Subject:From;
        b=pph7mooixHAS7gM3dkDqHOa9oxfvuOk7kerLiVfgpiW8pi2UyRmlV2gJq7HKL7ewb
         Mpcft4lt7yp1qeCqGITe4ee/bUMuTqcsKrpcfw2tmelio4Ibrx5Qf0IAOEKGz+V6IO
         uvoQqv6kH9zFovDanzwoNKkkXqYGeK4Mq84/bGKQ=
Date:   Thu, 18 Nov 2021 13:38:18 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + memcg-better-bounds-on-the-memcg-stats-updates.patch
 added to -mm tree
Message-ID: <20211118213818.g0-lwoeA9%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     memcg-better-bounds-on-the-memcg-stats-updates.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-better-bounds-on-the-me=
mcg-stats-updates.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-better-bounds-on-the-me=
mcg-stats-updates.patch

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
@@ -807,7 +813,7 @@ void __count_memcg_events(struct mem_cgr
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

memcg-better-bounds-on-the-memcg-stats-updates.patch

