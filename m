Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E92C25B0F
	for <mm-commits@archiver.kernel.org>; Mon, 15 Aug 2022 00:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiHOAjs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 14 Aug 2022 20:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiHOAjr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 14 Aug 2022 20:39:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2561C6272
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 17:39:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 860DBCE0BDB
        for <mm-commits@vger.kernel.org>; Mon, 15 Aug 2022 00:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EF6C433D6;
        Mon, 15 Aug 2022 00:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660523982;
        bh=4oHzf20kV1fQDvG3svkiCaToTOB63U/mqJHZfkrZxe0=;
        h=Date:To:From:Subject:From;
        b=MCfRmJm4aOyYO06M/DU0i/OAtw8WR4O2Gx/D/24HSqhNa6RlpRuFJnU/7Dnr5UAgr
         o1mrwgUbKmu4F/U5xdU7lIJV5cWurQz1pHTZdxld6FtaHnN59VWP5RxY33CH8YXPJm
         NOL6TiJR7y04vIJUa1p5H371qecJR66UJ5OfEvIY=
Date:   Sun, 14 Aug 2022 17:39:42 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        zhongjiang-ali@linux.alibaba.com, weixugc@google.com,
        shy828301@gmail.com, shakeelb@google.com, riel@surriel.com,
        peterz@infradead.org, osalvador@suse.de, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        dave.hansen@linux.intel.com, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tiering-rate-limit-numa-migration-throughput.patch added to mm-unstable branch
Message-Id: <20220815003942.B8EF6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory tiering: rate limit NUMA migration throughput
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tiering-rate-limit-numa-migration-throughput.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tiering-rate-limit-numa-migration-throughput.patch

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
From: Huang Ying <ying.huang@intel.com>
Subject: memory tiering: rate limit NUMA migration throughput
Date: Wed, 13 Jul 2022 16:39:52 +0800

In NUMA balancing memory tiering mode, if there are hot pages in slow
memory node and cold pages in fast memory node, we need to promote/demote
hot/cold pages between the fast and cold memory nodes.

A choice is to promote/demote as fast as possible.  But the CPU cycles and
memory bandwidth consumed by the high promoting/demoting throughput will
hurt the latency of some workload because of accessing inflating and slow
memory bandwidth contention.

A way to resolve this issue is to restrict the max promoting/demoting
throughput.  It will take longer to finish the promoting/demoting.  But
the workload latency will be better.  This is implemented in this patch as
the page promotion rate limit mechanism.

The number of the candidate pages to be promoted to the fast memory node
via NUMA balancing is counted, if the count exceeds the limit specified by
the users, the NUMA balancing promotion will be stopped until the next
second.

A new sysctl knob kernel.numa_balancing_promote_rate_limit_MBps is added
for the users to specify the limit.

Link: https://lkml.kernel.org/r/20220713083954.34196-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: osalvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zhong Jiang <zhongjiang-ali@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |   11 ++++++
 include/linux/mmzone.h                      |    7 +++
 include/linux/sched/sysctl.h                |    1 
 kernel/sched/fair.c                         |   33 ++++++++++++++++--
 kernel/sysctl.c                             |    8 ++++
 mm/vmstat.c                                 |    1 
 6 files changed, 59 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~memory-tiering-rate-limit-numa-migration-throughput
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -635,6 +635,17 @@ different types of memory (represented a
 place the hot pages in the fast memory.  This is implemented based on
 unmapping and page fault too.
 
+numa_balancing_promote_rate_limit_MBps
+======================================
+
+Too high promotion/demotion throughput between different memory types
+may hurt application latency.  This can be used to rate limit the
+promotion throughput.  The per-node max promotion throughput in MB/s
+will be limited to be no more than the set value.
+
+A rule of thumb is to set this to less than 1/10 of the PMEM node
+write bandwidth.
+
 oops_all_cpu_backtrace
 ======================
 
--- a/include/linux/mmzone.h~memory-tiering-rate-limit-numa-migration-throughput
+++ a/include/linux/mmzone.h
@@ -221,6 +221,7 @@ enum node_stat_item {
 #endif
 #ifdef CONFIG_NUMA_BALANCING
 	PGPROMOTE_SUCCESS,	/* promote successfully */
+	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
 #endif
 	NR_VM_NODE_STAT_ITEMS
 };
@@ -998,6 +999,12 @@ typedef struct pglist_data {
 	struct deferred_split deferred_split_queue;
 #endif
 
+#ifdef CONFIG_NUMA_BALANCING
+	/* start time in ms of current promote rate limit period */
+	unsigned int nbp_rl_start;
+	/* number of promote candidate pages at start time of current rate limit period */
+	unsigned long nbp_rl_nr_cand;
+#endif
 	/* Fields commonly accessed by the page reclaim scanner */
 
 	/*
--- a/include/linux/sched/sysctl.h~memory-tiering-rate-limit-numa-migration-throughput
+++ a/include/linux/sched/sysctl.h
@@ -27,6 +27,7 @@ enum sched_tunable_scaling {
 
 #ifdef CONFIG_NUMA_BALANCING
 extern int sysctl_numa_balancing_mode;
+extern unsigned int sysctl_numa_balancing_promote_rate_limit;
 #else
 #define sysctl_numa_balancing_mode	0
 #endif
--- a/kernel/sched/fair.c~memory-tiering-rate-limit-numa-migration-throughput
+++ a/kernel/sched/fair.c
@@ -1097,6 +1097,9 @@ unsigned int sysctl_numa_balancing_scan_
 /* The page with hint page fault latency < threshold in ms is considered hot */
 unsigned int sysctl_numa_balancing_hot_threshold = MSEC_PER_SEC;
 
+/* Restrict the NUMA promotion throughput (MB/s) for each target node. */
+unsigned int sysctl_numa_balancing_promote_rate_limit = 65536;
+
 struct numa_group {
 	refcount_t refcount;
 
@@ -1501,6 +1504,29 @@ static int numa_hint_fault_latency(struc
 	return (time - last_time) & PAGE_ACCESS_TIME_MASK;
 }
 
+/*
+ * For memory tiering mode, too high promotion/demotion throughput may
+ * hurt application latency.  So we provide a mechanism to rate limit
+ * the number of pages that are tried to be promoted.
+ */
+static bool numa_promotion_rate_limit(struct pglist_data *pgdat,
+				      unsigned long rate_limit, int nr)
+{
+	unsigned long nr_cand;
+	unsigned int now, start;
+
+	now = jiffies_to_msecs(jiffies);
+	mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE, nr);
+	nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
+	start = pgdat->nbp_rl_start;
+	if (now - start > MSEC_PER_SEC &&
+	    cmpxchg(&pgdat->nbp_rl_start, start, now) == start)
+		pgdat->nbp_rl_nr_cand = nr_cand;
+	if (nr_cand - pgdat->nbp_rl_nr_cand >= rate_limit)
+		return true;
+	return false;
+}
+
 bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
 				int src_nid, int dst_cpu)
 {
@@ -1515,7 +1541,7 @@ bool should_numa_migrate_memory(struct t
 	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING &&
 	    !node_is_toptier(src_nid)) {
 		struct pglist_data *pgdat;
-		unsigned long latency, th;
+		unsigned long rate_limit, latency, th;
 
 		pgdat = NODE_DATA(dst_nid);
 		if (pgdat_free_space_enough(pgdat))
@@ -1526,7 +1552,10 @@ bool should_numa_migrate_memory(struct t
 		if (latency >= th)
 			return false;
 
-		return true;
+		rate_limit = sysctl_numa_balancing_promote_rate_limit << \
+			(20 - PAGE_SHIFT);
+		return !numa_promotion_rate_limit(pgdat, rate_limit,
+						  thp_nr_pages(page));
 	}
 
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
--- a/kernel/sysctl.c~memory-tiering-rate-limit-numa-migration-throughput
+++ a/kernel/sysctl.c
@@ -1641,6 +1641,14 @@ static struct ctl_table kern_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_FOUR,
 	},
+	{
+		.procname	= "numa_balancing_promote_rate_limit_MBps",
+		.data		= &sysctl_numa_balancing_promote_rate_limit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
 #endif /* CONFIG_NUMA_BALANCING */
 	{
 		.procname	= "panic",
--- a/mm/vmstat.c~memory-tiering-rate-limit-numa-migration-throughput
+++ a/mm/vmstat.c
@@ -1252,6 +1252,7 @@ const char * const vmstat_text[] = {
 #endif
 #ifdef CONFIG_NUMA_BALANCING
 	"pgpromote_success",
+	"pgpromote_candidate",
 #endif
 
 	/* enum writeback_stat_item counters */
_

Patches currently in -mm which might be from ying.huang@intel.com are

memory-tiering-hot-page-selection-with-hint-page-fault-latency.patch
memory-tiering-rate-limit-numa-migration-throughput.patch
memory-tiering-adjust-hot-threshold-automatically.patch

