Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6ACC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39C6461A40
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhI3Vaq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 17:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229682AbhI3Vaq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 17:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE116615A2;
        Thu, 30 Sep 2021 21:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633037343;
        bh=Ps65yGeuTHPTZe7Ry/9j9ZszIkoXKC2rSjPZwCTH2M4=;
        h=Date:From:To:Subject:From;
        b=ENB12MQuvlaI1kxCmpkq57xzfuG2slWkWPsJKzAcmJJpTJfjii9QsGheTUWLc++qB
         FqUBYVAjO5USoEcQvazot7ncTFgMqgy26DffswZOX63RG0uy2garXEbfkPiso7Be6Q
         7KlJXe+qJVtsD1V8ztdmTi3FSIcB5YcFAB5z9MPY=
Date:   Thu, 30 Sep 2021 14:29:02 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + memcg-flush-stats-only-if-updated.patch added to -mm
 tree
Message-ID: <20210930212902.1Mvz1PuoQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: flush stats only if updated
has been added to the -mm tree.  Its filename is
     memcg-flush-stats-only-if-updated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-flush-stats-only-if-upd=
ated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-flush-stats-only-if-upd=
ated.patch

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
flush in the refault code path is triggered.  With this patch, we bserved
63% reduction in the read time of 8 GiB file.

Link: https://lkml.kernel.org/r/20210930044711.2892660-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutn=C3=BD" <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~memcg-flush-stats-only-if-updated
+++ a/mm/memcontrol.c
@@ -107,6 +107,8 @@ static bool do_memsw_account(void)
 static void flush_memcg_stats_dwork(struct work_struct *w);
 static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
 static DEFINE_SPINLOCK(stats_flush_lock);
+static DEFINE_PER_CPU(unsigned int, stats_updates);
+static atomic_t stats_flush_threshold =3D ATOMIC_INIT(0);
=20
 #define THRESHOLDS_EVENTS_TARGET 128
 #define SOFTLIMIT_EVENTS_TARGET 1024
@@ -635,6 +637,13 @@ mem_cgroup_largest_soft_limit_node(struc
 	return mz;
 }
=20
+static inline void memcg_rstat_updated(struct mem_cgroup *memcg)
+{
+	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	if (!(__this_cpu_inc_return(stats_updates) % MEMCG_CHARGE_BATCH))
+		atomic_inc(&stats_flush_threshold);
+}
+
 /**
  * __mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -647,7 +656,7 @@ void __mod_memcg_state(struct mem_cgroup
 		return;
=20
 	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
-	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	memcg_rstat_updated(memcg);
 }
=20
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
@@ -675,10 +684,12 @@ void __mod_memcg_lruvec_state(struct lru
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
@@ -780,7 +791,7 @@ void __count_memcg_events(struct mem_cgr
 		return;
=20
 	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
-	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	memcg_rstat_updated(memcg);
 }
=20
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
@@ -5341,15 +5352,22 @@ static void mem_cgroup_css_reset(struct
 	memcg_wb_domain_size_changed(memcg);
 }
=20
-void mem_cgroup_flush_stats(void)
+static void __mem_cgroup_flush_stats(void)
 {
 	if (!spin_trylock(&stats_flush_lock))
 		return;
=20
 	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
+	atomic_set(&stats_flush_threshold, 0);
 	spin_unlock(&stats_flush_lock);
 }
=20
+void mem_cgroup_flush_stats(void)
+{
+	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
+		__mem_cgroup_flush_stats();
+}
+
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
 	mem_cgroup_flush_stats();
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-flush-stats-only-if-updated.patch
memcg-unify-memcg-stat-flushing.patch

