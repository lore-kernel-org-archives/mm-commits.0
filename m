Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8393279C0
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246454; cv=none; b=faq6ax01wY4dwJOPk8TtMGMRcGSFLlxbRttPS2BucG0gCmjem6ip/KfTaK46yQnU49EWS+P54yCLznHlYojMmDHGUPZQTr3+T6Xf+mkRe48BG+pkK1TYW8kQ4Z2M9cqdZwwC9BLIMgntILuBJux0w5GmwHuvcEw5RCGz1O7ZgvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246454; c=relaxed/simple;
	bh=JvY8oepfT+Tu8A+T/B7A5wSnBBceFc1ttm7j6QPzmGM=;
	h=Date:To:From:Subject:Message-Id; b=glAZI58yS0RfA9rNvGA5c9AJ5h+RLLjtWE9DPDG9BZkEVaHNv46mshLkN1x8e2UJTObC54YHEkgW1X5vPMEivj1Yz9QfebsrzOLADcCNRfmNcPL345L165exxpORZvRtnjd6F2nQ2icwcGHPVlEQYh28efc8lRcYHemSXvm37Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LoOwrl5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LoOwrl5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287E5C4CEC3;
	Mon,  2 Sep 2024 03:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246454;
	bh=JvY8oepfT+Tu8A+T/B7A5wSnBBceFc1ttm7j6QPzmGM=;
	h=Date:To:From:Subject:From;
	b=LoOwrl5aCBztYqU2A26fzkX7VEGaL8KLdBDKcHibrcr1vWPH6R3a0xLXCf2BHvvnw
	 zH8SaS14cqdEBmHauaftv1Et5eo3U2R7rxki9cLN5n1NRSjfOHNI7j9/CCSn0/GSYc
	 mb+iumEXfkXWnwkGIXSeQdGBnqa7VCm6/faar6IM=
Date: Sun, 01 Sep 2024 20:07:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,peterz@infradead.org,nphamcs@gmail.com,lizhijian@fujitsu.com,kent.overstreet@linux.dev,cerasuolodomenico@gmail.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch removed from -mm tree
Message-Id: <20240902030734.287E5C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-increase-the-valid-index-range-for-memcg-stats-v5
has been removed from the -mm tree.  Its filename was
     memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch

This patch was dropped because it was folded into memcg-increase-the-valid-index-range-for-memcg-stats.patch

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: memcg-increase-the-valid-index-range-for-memcg-stats-v5
Date: Tue, 30 Jul 2024 15:01:56 +0000

address a comment from Yosry Ahmed, renamed IS_INVALID(idx) to
BAD_STAT_IDX(index), also made it more relaxed (>= instead of ==).

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~memcg-increase-the-valid-index-range-for-memcg-stats-v5
+++ a/mm/memcontrol.c
@@ -320,7 +320,7 @@ static const unsigned int memcg_stat_ite
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
 #define MEMCG_VMSTAT_SIZE (NR_MEMCG_NODE_STAT_ITEMS + \
 			   ARRAY_SIZE(memcg_stat_items))
-#define IS_INVALID(index) ((index) == U8_MAX)
+#define BAD_STAT_IDX(index) ((u32)(index) >= U8_MAX)
 static u8 mem_cgroup_stats_index[MEMCG_NR_STAT] __read_mostly;
 
 static void init_memcg_stats(void)
@@ -372,7 +372,7 @@ unsigned long lruvec_page_state(struct l
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -395,7 +395,7 @@ unsigned long lruvec_page_state_local(st
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -627,7 +627,7 @@ unsigned long memcg_page_state(struct me
 	long x;
 	int i = memcg_stats_index(idx);
 
-	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	x = READ_ONCE(memcg->vmstats->state[i]);
@@ -668,7 +668,7 @@ void __mod_memcg_state(struct mem_cgroup
 	if (mem_cgroup_disabled())
 		return;
 
-	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
@@ -681,7 +681,7 @@ unsigned long memcg_page_state_local(str
 	long x;
 	int i = memcg_stats_index(idx);
 
-	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	x = READ_ONCE(memcg->vmstats->state_local[i]);
@@ -700,7 +700,7 @@ static void __mod_memcg_lruvec_state(str
 	struct mem_cgroup *memcg;
 	int i = memcg_stats_index(idx);
 
-	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -816,7 +816,7 @@ void __count_memcg_events(struct mem_cgr
 	if (mem_cgroup_disabled())
 		return;
 
-	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	memcg_stats_lock();
@@ -829,7 +829,7 @@ unsigned long memcg_events(struct mem_cg
 {
 	int i = memcg_events_index(event);
 
-	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, event))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, event))
 		return 0;
 
 	return READ_ONCE(memcg->vmstats->events[i]);
@@ -839,7 +839,7 @@ unsigned long memcg_events_local(struct
 {
 	int i = memcg_events_index(event);
 
-	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, event))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, event))
 		return 0;
 
 	return READ_ONCE(memcg->vmstats->events_local[i]);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

memcg-increase-the-valid-index-range-for-memcg-stats.patch
vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

