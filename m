Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D44C001DB
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 23:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbjIBX3B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 19:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjIBX3A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 19:29:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0869C11A
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 16:28:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74FFFB80189
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 23:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE3CC433C7;
        Sat,  2 Sep 2023 23:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693697334;
        bh=BgzIRiTDcJLSoOu+AFfvppJjV6hWcrpk9xrnLoG49pc=;
        h=Date:To:From:Subject:From;
        b=HWpOHonRARmf/S5HMXY/26GkpsWbYmWAycnsQVp72SB9AcKOlgJqNADPUMReIWBCY
         BADGrdaUfvc2DsO+lE8KzXMbirDEzDMU6hMkg8SzCJmxgHoe/RGIOpWP8bMJxLvOSm
         Alk29igZd+aJgjFV8TWrrVG5RsCmmM0cO93kN1us=
Date:   Sat, 02 Sep 2023 16:28:53 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
        mhocko@kernel.org, longman@redhat.com, ivan@cloudflare.com,
        hannes@cmpxchg.org, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-use-non-unified-stats-flushing-for-userspace-reads.patch added to mm-unstable branch
Message-Id: <20230902232854.2AE3CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: use non-unified stats flushing for userspace reads
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-use-non-unified-stats-flushing-for-userspace-reads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-use-non-unified-stats-flushing-for-userspace-reads.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: use non-unified stats flushing for userspace reads
Date: Thu, 31 Aug 2023 16:56:11 +0000

Unified flushing allows for great concurrency for paths that attempt to
flush the stats, at the expense of potential staleness and a single
flusher paying the extra cost of flushing the full tree.

This tradeoff makes sense for in-kernel flushers that may observe high
concurrency (e.g.  reclaim, refault).  For userspace readers, stale stats
may be unexpected and problematic, especially when such stats are used for
critical paths such as userspace OOM handling.  Additionally, a userspace
reader will occasionally pay the cost of flushing the entire hierarchy,
which also causes problems in some cases [1].

Opt userspace reads out of unified flushing.  This makes the cost of
reading the stats more predictable (proportional to the size of the
subtree), as well as the freshness of the stats.  Userspace readers are
not expected to have similar concurrency to in-kernel flushers,
serializing them among themselves and among in-kernel flushers should be
okay.  Nonetheless, for extra safety, introduce a mutex when flushing for
userspace readers to make sure only a single userspace reader can compete
with in-kernel flushers at a time.  This takes away userspace ability to
directly influence or hurt in-kernel lock contention.

An alternative is to remove flushing from the stats reading path
completely, and rely on the periodic flusher.  This should be accompanied
by making the periodic flushing period tunable, and providing an interface
for userspace to force a flush, following a similar model to /proc/vmstat.
However, such a change will be hard to reverse if the implementation
needs to be changed because:

- The cost of reading stats will be very cheap and we won't be able to
  take that back easily.
- There are user-visible interfaces involved.

Hence, let's go with the change that's most reversible first and revisit
as needed.

This was tested on a machine with 256 cpus by running a synthetic test
script [2] that creates 50 top-level cgroups, each with 5 children (250
leaf cgroups).  Each leaf cgroup has 10 processes running that allocate
memory beyond the cgroup limit, invoking reclaim (which is an in-kernel
unified flusher).  Concurrently, one thread is spawned per-cgroup to read
the stats every second (including root, top-level, and leaf cgroups -- so
total 251 threads).  No significant regressions were observed in the total
run time, which means that userspace readers are not significantly
affecting in-kernel flushers:

Base (mm-unstable):

real	0m22.500s
user	0m9.399s
sys	73m41.381s

real	0m22.749s
user	0m15.648s
sys	73m13.113s

real	0m22.466s
user	0m10.000s
sys	73m11.933s

With this patch:

real	0m23.092s
user	0m10.110s
sys	75m42.774s

real	0m22.277s
user	0m10.443s
sys	72m7.182s

real	0m24.127s
user	0m12.617s
sys	78m52.765s

[1]https://lore.kernel.org/lkml/CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com/
[2]https://lore.kernel.org/lkml/CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com/

Link: https://lkml.kernel.org/r/20230831165611.2610118-5-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-use-non-unified-stats-flushing-for-userspace-reads
+++ a/mm/memcontrol.c
@@ -588,6 +588,7 @@ mem_cgroup_largest_soft_limit_node(struc
 static void flush_memcg_stats_dwork(struct work_struct *w);
 static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
 static DEFINE_PER_CPU(unsigned int, stats_updates);
+static DEFINE_MUTEX(stats_user_flush_mutex);
 static atomic_t stats_unified_flush_ongoing = ATOMIC_INIT(0);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
 static u64 flush_next_time;
@@ -656,6 +657,21 @@ static void do_stats_flush(struct mem_cg
 }
 
 /*
+ * mem_cgroup_user_flush_stats - do a stats flush for a user read
+ * @memcg: memory cgroup to flush
+ *
+ * Flush the subtree of @memcg. A mutex is used for userspace readers to gate
+ * the global rstat spinlock. This protects in-kernel flushers from userspace
+ * readers hogging the lock.
+ */
+static void mem_cgroup_user_flush_stats(struct mem_cgroup *memcg)
+{
+	mutex_lock(&stats_user_flush_mutex);
+	do_stats_flush(memcg);
+	mutex_unlock(&stats_user_flush_mutex);
+}
+
+/*
  * do_unified_stats_flush - do a unified flush of memory cgroup statistics
  *
  * A unified flush tries to flush the entire hierarchy, but skips if there is
@@ -1608,7 +1624,7 @@ static void memcg_stat_format(struct mem
 	 *
 	 * Current memory state:
 	 */
-	mem_cgroup_try_flush_stats();
+	mem_cgroup_user_flush_stats(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -4050,7 +4066,7 @@ static int memcg_numa_stat_show(struct s
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_try_flush_stats();
+	mem_cgroup_user_flush_stats(memcg);
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -4125,7 +4141,7 @@ static void memcg1_stat_format(struct me
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	mem_cgroup_try_flush_stats();
+	mem_cgroup_user_flush_stats(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -6649,7 +6665,7 @@ static int memory_numa_stat_show(struct
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_try_flush_stats();
+	mem_cgroup_user_flush_stats(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-properly-name-and-document-unified-stats-flushing.patch
mm-memcg-add-a-helper-for-non-unified-stats-flushing.patch
mm-memcg-let-non-unified-root-stats-flushes-help-unified-flushes.patch
mm-memcg-use-non-unified-stats-flushing-for-userspace-reads.patch

