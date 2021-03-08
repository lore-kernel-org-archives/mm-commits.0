Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B386C4332B
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31D07652B7
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhCHXIZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:08:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231176AbhCHXIR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 18:08:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66E8265295;
        Mon,  8 Mar 2021 23:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615244896;
        bh=6aRTnVpIdnNhV1tEAM6+ILNlEOmphoXdtPYP4ymJbbI=;
        h=Date:From:To:Subject:From;
        b=CBM/TQ14fLWgp/cSOO751xA/W4YXEv/moeo5ZRCjPQ+RlxH36pVzqWdQbiJ43gDay
         SQmos+gWOLW6Kt2aOQJWWiSkdek6svfYOyTCAth3PcvK49LXbLMA00f9lHeMi8NMGJ
         7mcpiyWBKdki9ffU1z7rNoxER2VC75/mUvpCN+C0=
Date:   Mon, 08 Mar 2021 15:08:15 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org
Subject:  + mm-memcontrol-fix-cpuhotplug-statistics-flushing.patch
 added to -mm tree
Message-ID: <20210308230815.MoQsUtvug%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix cpuhotplug statistics flushing
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-cpuhotplug-statistics-flushing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-cpuhotplug-=
statistics-flushing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-cpuhotplug-=
statistics-flushing.patch

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
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fix cpuhotplug statistics flushing

Patch series "mm: memcontrol: switch to rstat", v3.

This series converts memcg stats tracking to the streamlined rstat
infrastructure provided by the cgroup core code.  rstat is already used by
the CPU controller and the IO controller.  This change is motivated by
recent accuracy problems in memcg's custom stats code, as well as the
benefits of sharing common infra with other controllers.

The current memcg implementation does batched tree aggregation on the
write side: local stat changes are cached in per-cpu counters, which are
then propagated upward in batches when a threshold (32 pages) is exceeded.
This is cheap, but the error introduced by the lazy upward propagation
adds up: 32 pages times CPUs times cgroups in the subtree.  We've had
complaints from service owners that the stats do not reliably track and
react to allocation behavior as expected, sometimes swallowing the results
of entire test applications.

The original memcg stat implementation used to do tree aggregation
exclusively on the read side: local stats would only ever be tracked in
per-cpu counters, and a memory.stat read would iterate the entire subtree
and sum those counters up.  This didn't keep up with the times:

- Cgroup trees are much bigger now.  We switched to lazily-freed
  cgroups, where deleted groups would hang around until their remaining
  page cache has been reclaimed.  This can result in large subtrees that
  are expensive to walk, while most of the groups are idle and their
  statistics don't change much anymore.

- Automated monitoring increased.  With the proliferation of userspace
  oom killing, proactive reclaim, and higher-resolution logging of
  workload trends in general, top-level stat files are polled at least
  once a second in many deployments.

- The lifetime of cgroups got shorter.  Where most cgroup setups in the
  past would have a few large policy-oriented cgroups for everything
  running on the system, newer cgroup deployments tend to create one group
  per application - which gets deleted again as the processes exit.  An
  aggregation scheme that doesn't retain child data inside the parents
  loses event history of the subtree.

Rstat addresses all three of those concerns through intelligent,
persistent read-side aggregation.  As statistics change at the local
level, rstat tracks - on a per-cpu basis - only those parts of a subtree
that have changes pending and require aggregation.  The actual aggregation
occurs on the colder read side - which can now skip over (potentially
large) numbers of recently idle cgroups.

=3D=3D=3D

The test_kmem cgroup selftest is currently failing due to excessive
cumulative vmstat drift from 100 subgroups:

    ok 1 test_kmem_basic
    memory.current =3D 8810496
    slab + anon + file + kernel_stack =3D 17074568
    slab =3D 6101384
    anon =3D 946176
    file =3D 0
    kernel_stack =3D 10027008
    not ok 2 test_kmem_memcg_deletion
    ok 3 test_kmem_proc_kpagecgroup
    ok 4 test_kmem_kernel_stacks
    ok 5 test_kmem_dead_cgroups
    ok 6 test_percpu_basic

As you can see, memory.stat items far exceed memory.current.  The kernel
stack alone is bigger than all of charged memory.  That's because the
memory of the test has been uncharged from memory.current, but the
negative vmstat deltas are still sitting in the percpu caches.

The test at this time isn't even counting percpu, pagetables etc.  yet,
which would further contribute to the error.  The last patch in the series
updates the test to include them - as well as reduces the vmstat
tolerances in general to only expect page_counter batching.

With all patches applied, the (now more stringent) test succeeds:

    ok 1 test_kmem_basic
    ok 2 test_kmem_memcg_deletion
    ok 3 test_kmem_proc_kpagecgroup
    ok 4 test_kmem_kernel_stacks
    ok 5 test_kmem_dead_cgroups
    ok 6 test_percpu_basic

=3D=3D=3D

A kernel build test confirms that overhead is comparable.  Two kernels are
built simultaneously in a nested tree with several idle siblings:

root - kernelbuild - one - two - three - four - build-a (defconfig, make -j=
16)
                                             `- build-b (defconfig, make -j=
16)
                                             `- idle-1
                                             `- ...
                                             `- idle-9

During the builds, kernelbuild/memory.stat is read once a second.

A perf diff shows that the changes in cycle distribution is
minimal. Top 10 kernel symbols:

     0.09%     +0.08%  [kernel.kallsyms]                       [k] __mod_me=
mcg_lruvec_state
     0.00%     +0.06%  [kernel.kallsyms]                       [k] cgroup_r=
stat_updated
     0.08%     -0.05%  [kernel.kallsyms]                       [k] __mod_me=
mcg_state.part.0
     0.16%     -0.04%  [kernel.kallsyms]                       [k] release_=
pages
     0.00%     +0.03%  [kernel.kallsyms]                       [k] __count_=
memcg_events
     0.01%     +0.03%  [kernel.kallsyms]                       [k] mem_cgro=
up_charge_statistics.constprop.0
     0.10%     -0.02%  [kernel.kallsyms]                       [k] get_mem_=
cgroup_from_mm
     0.05%     -0.02%  [kernel.kallsyms]                       [k] mem_cgro=
up_update_lru_size
     0.57%     +0.01%  [kernel.kallsyms]                       [k] asm_exc_=
page_fault


=3D=3D=3D

The on-demand aggregated stats are now fully accurate:

$ grep -e nr_inactive_file /proc/vmstat | awk '{print($1,$2*4096)}'; \
  grep -e inactive_file /sys/fs/cgroup/memory.stat

vanilla:                              patched:
nr_inactive_file 1574105088           nr_inactive_file 1027801088
   inactive_file 1577410560              inactive_file 1027801088

=3D=3D=3D


This patch (of 8):


The memcg hotunplug callback erroneously flushes counts on the local CPU,
not the counts of the CPU going away; those counts will be lost.

Flush the CPU that is actually going away.

Also simplify the code a bit by using mod_memcg_state() and
count_memcg_events() instead of open-coding the upward flush - this is
comparable to how vmstat.c handles hotunplug flushing.

Link: https://lkml.kernel.org/r/20210209163304.77088-1-hannes@cmpxchg.org
Link: https://lkml.kernel.org/r/20210209163304.77088-2-hannes@cmpxchg.org
Fixes: a983b5ebee572 ("mm: memcontrol: fix excessive complexity in memory.s=
tat reporting")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-cpuhotplug-statistics-flushing
+++ a/mm/memcontrol.c
@@ -2370,45 +2370,52 @@ static void drain_all_stock(struct mem_c
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
 	struct memcg_stock_pcp *stock;
-	struct mem_cgroup *memcg, *mi;
+	struct mem_cgroup *memcg;
=20
 	stock =3D &per_cpu(memcg_stock, cpu);
 	drain_stock(stock);
=20
 	for_each_mem_cgroup(memcg) {
+		struct memcg_vmstats_percpu *statc;
 		int i;
=20
+		statc =3D per_cpu_ptr(memcg->vmstats_percpu, cpu);
+
 		for (i =3D 0; i < MEMCG_NR_STAT; i++) {
 			int nid;
-			long x;
=20
-			x =3D this_cpu_xchg(memcg->vmstats_percpu->stat[i], 0);
-			if (x)
-				for (mi =3D memcg; mi; mi =3D parent_mem_cgroup(mi))
-					atomic_long_add(x, &memcg->vmstats[i]);
+			if (statc->stat[i]) {
+				mod_memcg_state(memcg, i, statc->stat[i]);
+				statc->stat[i] =3D 0;
+			}
=20
 			if (i >=3D NR_VM_NODE_STAT_ITEMS)
 				continue;
=20
 			for_each_node(nid) {
+				struct batched_lruvec_stat *lstatc;
 				struct mem_cgroup_per_node *pn;
+				long x;
=20
 				pn =3D mem_cgroup_nodeinfo(memcg, nid);
-				x =3D this_cpu_xchg(pn->lruvec_stat_cpu->count[i], 0);
-				if (x)
+				lstatc =3D per_cpu_ptr(pn->lruvec_stat_cpu, cpu);
+
+				x =3D lstatc->count[i];
+				lstatc->count[i] =3D 0;
+
+				if (x) {
 					do {
 						atomic_long_add(x, &pn->lruvec_stat[i]);
 					} while ((pn =3D parent_nodeinfo(pn, nid)));
+				}
 			}
 		}
=20
 		for (i =3D 0; i < NR_VM_EVENT_ITEMS; i++) {
-			long x;
-
-			x =3D this_cpu_xchg(memcg->vmstats_percpu->events[i], 0);
-			if (x)
-				for (mi =3D memcg; mi; mi =3D parent_mem_cgroup(mi))
-					atomic_long_add(x, &memcg->vmevents[i]);
+			if (statc->events[i]) {
+				count_memcg_events(memcg, i, statc->events[i]);
+				statc->events[i] =3D 0;
+			}
 		}
 	}
=20
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback.patch
mm-memcontrol-fix-cpuhotplug-statistics-flushing.patch
mm-memcontrol-kill-mem_cgroup_nodeinfo.patch
mm-memcontrol-privatize-memcg_page_state-query-functions.patch
cgroup-rstat-support-cgroup1.patch
cgroup-rstat-punt-root-level-optimization-to-individual-controllers.patch
mm-memcontrol-switch-to-rstat.patch
mm-memcontrol-consolidate-lruvec-stat-flushing.patch
kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch

