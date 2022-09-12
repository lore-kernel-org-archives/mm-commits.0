Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB04AC54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiILDbS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiILD32 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016B428701
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 932216116E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E823FC433D6;
        Mon, 12 Sep 2022 03:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953347;
        bh=dcDis4smMBZHMrv7FsBohtVNx5aUeGBxuSK4re8Wu0M=;
        h=Date:To:From:Subject:From;
        b=b+9K0NLYbRf8oo4+Yh0mJh0ByNFxhTOhuNtELFtBerggURg/UmoUaafyMvBh2wC9L
         T8koEW9jSDqjKL64miAXI/kAoH4Ot1+h1js96cFoBK7tuxn8DqXVgFGt+QhHK4TfdX
         Fb6VKTwUHt3ccdpbCdOStLq2dMcyJ8wtEcyst0HA=
Date:   Sun, 11 Sep 2022 20:29:06 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        zhongjiang-ali@linux.alibaba.com, weixugc@google.com,
        shy828301@gmail.com, shakeelb@google.com, riel@surriel.com,
        peterz@infradead.org, osalvador@suse.de, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        dave.hansen@linux.intel.com, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-tiering-adjust-hot-threshold-automatically.patch removed from -mm tree
Message-Id: <20220912032906.E823FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memory tiering: adjust hot threshold automatically
has been removed from the -mm tree.  Its filename was
     memory-tiering-adjust-hot-threshold-automatically.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: memory tiering: adjust hot threshold automatically
Date: Wed, 13 Jul 2022 16:39:53 +0800

The promotion hot threshold is workload and system configuration
dependent.  So in this patch, a method to adjust the hot threshold
automatically is implemented.  The basic idea is to control the number of
the candidate promotion pages to match the promotion rate limit.  If the
hint page fault latency of a page is less than the hot threshold, we will
try to promote the page, and the page is called the candidate promotion
page.

If the number of the candidate promotion pages in the statistics interval
is much more than the promotion rate limit, the hot threshold will be
decreased to reduce the number of the candidate promotion pages. 
Otherwise, the hot threshold will be increased to increase the number of
the candidate promotion pages.

To make the above method works, in each statistics interval, the total
number of the pages to check (on which the hint page faults occur) and the
hot/cold distribution need to be stable.  Because the page tables are
scanned linearly in NUMA balancing, but the hot/cold distribution isn't
uniform along the address usually, the statistics interval should be
larger than the NUMA balancing scan period.  So in the patch, the max scan
period is used as statistics interval and it works well in our tests.

Link: https://lkml.kernel.org/r/20220713083954.34196-4-ying.huang@intel.com
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

 include/linux/mmzone.h |    9 +++++++
 kernel/sched/core.c    |   14 +++++++++++
 kernel/sched/fair.c    |   46 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 64 insertions(+), 5 deletions(-)

--- a/include/linux/mmzone.h~memory-tiering-adjust-hot-threshold-automatically
+++ a/include/linux/mmzone.h
@@ -1004,6 +1004,15 @@ typedef struct pglist_data {
 	unsigned int nbp_rl_start;
 	/* number of promote candidate pages at start time of current rate limit period */
 	unsigned long nbp_rl_nr_cand;
+	/* promote threshold in ms */
+	unsigned int nbp_threshold;
+	/* start time in ms of current promote threshold adjustment period */
+	unsigned int nbp_th_start;
+	/*
+	 * number of promote candidate pages at stat time of current promote
+	 * threshold adjustment period
+	 */
+	unsigned long nbp_th_nr_cand;
 #endif
 	/* Fields commonly accessed by the page reclaim scanner */
 
--- a/kernel/sched/core.c~memory-tiering-adjust-hot-threshold-automatically
+++ a/kernel/sched/core.c
@@ -4396,6 +4396,17 @@ void set_numabalancing_state(bool enable
 }
 
 #ifdef CONFIG_PROC_SYSCTL
+static void reset_memory_tiering(void)
+{
+	struct pglist_data *pgdat;
+
+	for_each_online_pgdat(pgdat) {
+		pgdat->nbp_threshold = 0;
+		pgdat->nbp_th_nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
+		pgdat->nbp_th_start = jiffies_to_msecs(jiffies);
+	}
+}
+
 int sysctl_numa_balancing(struct ctl_table *table, int write,
 			  void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -4412,6 +4423,9 @@ int sysctl_numa_balancing(struct ctl_tab
 	if (err < 0)
 		return err;
 	if (write) {
+		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
+		    (state & NUMA_BALANCING_MEMORY_TIERING))
+			reset_memory_tiering();
 		sysctl_numa_balancing_mode = state;
 		__set_numabalancing_state(state);
 	}
--- a/kernel/sched/fair.c~memory-tiering-adjust-hot-threshold-automatically
+++ a/kernel/sched/fair.c
@@ -1527,6 +1527,35 @@ static bool numa_promotion_rate_limit(st
 	return false;
 }
 
+#define NUMA_MIGRATION_ADJUST_STEPS	16
+
+static void numa_promotion_adjust_threshold(struct pglist_data *pgdat,
+					    unsigned long rate_limit,
+					    unsigned int ref_th)
+{
+	unsigned int now, start, th_period, unit_th, th;
+	unsigned long nr_cand, ref_cand, diff_cand;
+
+	now = jiffies_to_msecs(jiffies);
+	th_period = sysctl_numa_balancing_scan_period_max;
+	start = pgdat->nbp_th_start;
+	if (now - start > th_period &&
+	    cmpxchg(&pgdat->nbp_th_start, start, now) == start) {
+		ref_cand = rate_limit *
+			sysctl_numa_balancing_scan_period_max / MSEC_PER_SEC;
+		nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
+		diff_cand = nr_cand - pgdat->nbp_th_nr_cand;
+		unit_th = ref_th * 2 / NUMA_MIGRATION_ADJUST_STEPS;
+		th = pgdat->nbp_threshold ? : ref_th;
+		if (diff_cand > ref_cand * 11 / 10)
+			th = max(th - unit_th, unit_th);
+		else if (diff_cand < ref_cand * 9 / 10)
+			th = min(th + unit_th, ref_th * 2);
+		pgdat->nbp_th_nr_cand = nr_cand;
+		pgdat->nbp_threshold = th;
+	}
+}
+
 bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
 				int src_nid, int dst_cpu)
 {
@@ -1541,19 +1570,26 @@ bool should_numa_migrate_memory(struct t
 	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING &&
 	    !node_is_toptier(src_nid)) {
 		struct pglist_data *pgdat;
-		unsigned long rate_limit, latency, th;
+		unsigned long rate_limit;
+		unsigned int latency, th, def_th;
 
 		pgdat = NODE_DATA(dst_nid);
-		if (pgdat_free_space_enough(pgdat))
+		if (pgdat_free_space_enough(pgdat)) {
+			/* workload changed, reset hot threshold */
+			pgdat->nbp_threshold = 0;
 			return true;
+		}
 
-		th = sysctl_numa_balancing_hot_threshold;
+		def_th = sysctl_numa_balancing_hot_threshold;
+		rate_limit = sysctl_numa_balancing_promote_rate_limit << \
+			(20 - PAGE_SHIFT);
+		numa_promotion_adjust_threshold(pgdat, rate_limit, def_th);
+
+		th = pgdat->nbp_threshold ? : def_th;
 		latency = numa_hint_fault_latency(page);
 		if (latency >= th)
 			return false;
 
-		rate_limit = sysctl_numa_balancing_promote_rate_limit << \
-			(20 - PAGE_SHIFT);
 		return !numa_promotion_rate_limit(pgdat, rate_limit,
 						  thp_nr_pages(page));
 	}
_

Patches currently in -mm which might be from ying.huang@intel.com are

migrate-fix-syscall-move_pages-return-value-for-failure.patch
migrate_pages-remove-unnecessary-list_safe_reset_next.patch
migrate_pages-fix-thp-failure-counting-for-enomem.patch
migrate_pages-fix-failure-counting-for-thp-subpages-retrying.patch
migrate_pages-fix-failure-counting-for-thp-on-enosys.patch
migrate_pages-fix-failure-counting-for-thp-splitting.patch
migrate_pages-fix-failure-counting-for-retry.patch

