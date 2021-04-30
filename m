Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2445DC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2C7F61434
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhD3FXu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3FXt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:23:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7A1961423;
        Fri, 30 Apr 2021 05:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760182;
        bh=xQ3AIGte4uH07jaFgD/zRC5UvPUUT+tkpGph6Aqvj1I=;
        h=Date:From:To:Subject:From;
        b=gF6Jez0qGEycmfqrnMNnjLr6Dhqc5mWlw4SrEUvCz4vPOP5TfIOCvL62BCWDJfjrT
         8I5svpnh0iiIaMw7E4YhBLfD1YCTVIv6gzzmiEagn845MpLTxAT6QO+bnfIGvaUn/V
         inoFlAHfT//9cC5zsI5TC0monRF66mskND6kxTXw=
Date:   Thu, 29 Apr 2021 22:23:01 -0700
From:   akpm@linux-foundation.org
To:     bsingharora@gmail.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mkoutny@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, tj@kernel.org
Subject:  [folded-merged] mm-memcontrol-switch-to-rstat-fix-2.patch
 removed from -mm tree
Message-ID: <20210430052301.59CZmREOB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: switch to rstat fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-switch-to-rstat-fix-2.patch

This patch was dropped because it was folded into mm-memcontrol-switch-to-rstat.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: switch to rstat fix

Fix a sleep in atomic section problem: wb_writeback() takes a spinlock and
calls wb_over_bg_thresh() -> mem_cgroup_wb_stats, but the regular rstat
flushing function called from in there does lockbreaking and may sleep. 
Switch to the atomic variant, cgroup_rstat_irqsafe().

To be consistent with other memcg flush calls, but without adding another
memcg wrapper, inline and drop memcg_flush_vmstats() instead.

Link: https://lkml.kernel.org/r/20210315234100.64307-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-switch-to-rstat-fix-2
+++ a/mm/memcontrol.c
@@ -757,11 +757,6 @@ mem_cgroup_largest_soft_limit_node(struc
 	return mz;
 }
 
-static void memcg_flush_vmstats(struct mem_cgroup *memcg)
-{
-	cgroup_rstat_flush(memcg->css.cgroup);
-}
-
 /**
  * __mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -1572,7 +1567,7 @@ static char *memory_stat_format(struct m
 	 *
 	 * Current memory state:
 	 */
-	memcg_flush_vmstats(memcg);
+	cgroup_rstat_flush(memcg->css.cgroup);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -3523,7 +3518,7 @@ static unsigned long mem_cgroup_usage(st
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		memcg_flush_vmstats(memcg);
+		cgroup_rstat_flush(memcg->css.cgroup);
 		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
@@ -3925,7 +3920,7 @@ static int memcg_numa_stat_show(struct s
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	memcg_flush_vmstats(memcg);
+	cgroup_rstat_flush(memcg->css.cgroup);
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -3997,7 +3992,7 @@ static int memcg_stat_show(struct seq_fi
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	memcg_flush_vmstats(memcg);
+	cgroup_rstat_flush(memcg->css.cgroup);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4500,7 +4495,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	memcg_flush_vmstats(memcg);
+	cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
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
mm-page_counter-mitigate-consequences-of-a-page_counter-underflow.patch

