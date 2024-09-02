Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5963EA76
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247685; cv=none; b=Ak8AFWCDZi2DI0wMWosbfKFqjtG+gu8pkCuVxX8UfA58Y20D/27Yg5vkbuhtbRb2zhoztWeu2HV+jZMGcUDyRGnpEKNQjaXh5hXqJWN0Ft5LI8A4lb3wh+jBU4HLWw61Z2rtVnOo0Ofmaf1WxRiJY8MFmGcEcNv937WAG16WpDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247685; c=relaxed/simple;
	bh=GJlCa+y01F/7tZ9ecArmPL2qK9puZHbamJ/cRkT7ckg=;
	h=Date:To:From:Subject:Message-Id; b=rHT1VSuKJwUAEUvO6VNl6QDvTxLPI0USvbf979Y6UpiQItTDkO4E72uo03/KQr0kgCV/14M2HJtcTAb1e94yxgcmjq8Uq+cQj1ZrLTYt2A6xzHQEnKBSpIKYNBgfIMPAUBvP8tEfOb2UYmBtoBt6C2VbiiBJcWS1BhBKFqGijMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uel1asyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uel1asyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31C3C4CEC2;
	Mon,  2 Sep 2024 03:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247684;
	bh=GJlCa+y01F/7tZ9ecArmPL2qK9puZHbamJ/cRkT7ckg=;
	h=Date:To:From:Subject:From;
	b=uel1asyuIpV9nYZXWJCrfN+fya0yn3qlO7l/7LKORihrN3xqGFCNUwHIWWS4uP9w6
	 T9+8vCEAMep6ZoLFSV57OUaaz8E9/x0TWGWdKWMfephcxxG8e+AqS0Ri80MKt7qcSG
	 keOeS2I16z+Yq9rjFPZgMYu4wR9ioWouUYtGxJoA=
Date: Sun, 01 Sep 2024 20:28:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,nphamcs@gmail.com,lizhijian@fujitsu.com,kent.overstreet@linux.dev,cerasuolodomenico@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-increase-the-valid-index-range-for-memcg-stats.patch removed from -mm tree
Message-Id: <20240902032804.C31C3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: increase the valid index range for memcg stats
has been removed from the -mm tree.  Its filename was
     memcg-increase-the-valid-index-range-for-memcg-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: increase the valid index range for memcg stats
Date: Wed, 24 Jul 2024 20:33:20 +0000

Patch series "Kernel stack usage histogram", v6.

Provide histogram of stack sizes for the exited threads:
Example outputs:
Intel:
$ grep kstack /proc/vmstat
kstack_1k 3
kstack_2k 188
kstack_4k 11391
kstack_8k 243
kstack_16k 0

ARM with 64K page_size:
$ grep kstack /proc/vmstat
kstack_1k 1
kstack_2k 340
kstack_4k 25212
kstack_8k 1659
kstack_16k 0
kstack_32k 0
kstack_64k 0


This patch (of 3):

At the moment the valid index for the indirection tables for memcg stats
and events is < S8_MAX.  These indirection tables are used in performance
critical codepaths.  With the latest addition to the vm_events, the
NR_VM_EVENT_ITEMS has gone over S8_MAX.  One way to resolve is to increase
the entry size of the indirection table from int8_t to int16_t but this
will increase the potential number of cachelines needed to access the
indirection table.

This patch took a different approach and make the valid index < U8_MAX. 
In this way the size of the indirection tables will remain same and we
only need to invalid index check from less than 0 to equal to U8_MAX.  In
this approach we have also removed a subtraction from the performance
critical codepaths.

[pasha.tatashin@soleen.com: v6]
Link: https://lkml.kernel.org/r/20240730150158.832783-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20240724203322.2765486-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20240724203322.2765486-2-pasha.tatashin@soleen.com
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

 mm/memcontrol.c |   50 +++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

--- a/mm/memcontrol.c~memcg-increase-the-valid-index-range-for-memcg-stats
+++ a/mm/memcontrol.c
@@ -320,24 +320,27 @@ static const unsigned int memcg_stat_ite
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
 #define MEMCG_VMSTAT_SIZE (NR_MEMCG_NODE_STAT_ITEMS + \
 			   ARRAY_SIZE(memcg_stat_items))
-static int8_t mem_cgroup_stats_index[MEMCG_NR_STAT] __read_mostly;
+#define BAD_STAT_IDX(index) ((u32)(index) >= U8_MAX)
+static u8 mem_cgroup_stats_index[MEMCG_NR_STAT] __read_mostly;
 
 static void init_memcg_stats(void)
 {
-	int8_t i, j = 0;
+	u8 i, j = 0;
 
-	BUILD_BUG_ON(MEMCG_NR_STAT >= S8_MAX);
+	BUILD_BUG_ON(MEMCG_NR_STAT >= U8_MAX);
 
-	for (i = 0; i < NR_MEMCG_NODE_STAT_ITEMS; ++i)
-		mem_cgroup_stats_index[memcg_node_stat_items[i]] = ++j;
+	memset(mem_cgroup_stats_index, U8_MAX, sizeof(mem_cgroup_stats_index));
 
-	for (i = 0; i < ARRAY_SIZE(memcg_stat_items); ++i)
-		mem_cgroup_stats_index[memcg_stat_items[i]] = ++j;
+	for (i = 0; i < NR_MEMCG_NODE_STAT_ITEMS; ++i, ++j)
+		mem_cgroup_stats_index[memcg_node_stat_items[i]] = j;
+
+	for (i = 0; i < ARRAY_SIZE(memcg_stat_items); ++i, ++j)
+		mem_cgroup_stats_index[memcg_stat_items[i]] = j;
 }
 
 static inline int memcg_stats_index(int idx)
 {
-	return mem_cgroup_stats_index[idx] - 1;
+	return mem_cgroup_stats_index[idx];
 }
 
 struct lruvec_stats_percpu {
@@ -369,7 +372,7 @@ unsigned long lruvec_page_state(struct l
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -392,7 +395,7 @@ unsigned long lruvec_page_state_local(st
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -435,21 +438,24 @@ static const unsigned int memcg_vm_event
 };
 
 #define NR_MEMCG_EVENTS ARRAY_SIZE(memcg_vm_event_stat)
-static int8_t mem_cgroup_events_index[NR_VM_EVENT_ITEMS] __read_mostly;
+static u8 mem_cgroup_events_index[NR_VM_EVENT_ITEMS] __read_mostly;
 
 static void init_memcg_events(void)
 {
-	int8_t i;
+	u8 i;
+
+	BUILD_BUG_ON(NR_VM_EVENT_ITEMS >= U8_MAX);
 
-	BUILD_BUG_ON(NR_VM_EVENT_ITEMS >= S8_MAX);
+	memset(mem_cgroup_events_index, U8_MAX,
+	       sizeof(mem_cgroup_events_index));
 
 	for (i = 0; i < NR_MEMCG_EVENTS; ++i)
-		mem_cgroup_events_index[memcg_vm_event_stat[i]] = i + 1;
+		mem_cgroup_events_index[memcg_vm_event_stat[i]] = i;
 }
 
 static inline int memcg_events_index(enum vm_event_item idx)
 {
-	return mem_cgroup_events_index[idx] - 1;
+	return mem_cgroup_events_index[idx];
 }
 
 struct memcg_vmstats_percpu {
@@ -621,7 +627,7 @@ unsigned long memcg_page_state(struct me
 	long x;
 	int i = memcg_stats_index(idx);
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	x = READ_ONCE(memcg->vmstats->state[i]);
@@ -662,7 +668,7 @@ void __mod_memcg_state(struct mem_cgroup
 	if (mem_cgroup_disabled())
 		return;
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
@@ -675,7 +681,7 @@ unsigned long memcg_page_state_local(str
 	long x;
 	int i = memcg_stats_index(idx);
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	x = READ_ONCE(memcg->vmstats->state_local[i]);
@@ -694,7 +700,7 @@ static void __mod_memcg_lruvec_state(str
 	struct mem_cgroup *memcg;
 	int i = memcg_stats_index(idx);
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -810,7 +816,7 @@ void __count_memcg_events(struct mem_cgr
 	if (mem_cgroup_disabled())
 		return;
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	memcg_stats_lock();
@@ -823,7 +829,7 @@ unsigned long memcg_events(struct mem_cg
 {
 	int i = memcg_events_index(event);
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, event))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, event))
 		return 0;
 
 	return READ_ONCE(memcg->vmstats->events[i]);
@@ -833,7 +839,7 @@ unsigned long memcg_events_local(struct
 {
 	int i = memcg_events_index(event);
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, event))
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, event))
 		return 0;
 
 	return READ_ONCE(memcg->vmstats->events_local[i]);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


