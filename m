Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FFF446DB
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 21:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721854949; cv=none; b=YMfpAJwkZ7MzA46IpSQmqDaqbCHf9sYdfUL2FaYXO2d5cCxdKwfvNDt0YGqwE/VjZLbe1AbFf5qDl3RE9+gLp1tAMkNH6ndWwWBUN56PMPsISQ2r6LcONFGclydj/GGyPx/sgbYmX9qTH7hp2S0poMQNKJCnL/RYd0angrBtleo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721854949; c=relaxed/simple;
	bh=L0vv19KKjsXNX4Baybb4zIf5UVcQNwp0VKVq80wm5E8=;
	h=Date:To:From:Subject:Message-Id; b=kMyuiFQC5DjAY9y1+cwlpVvHbdAqwnBKMHbpm4inWZ7xxgF5IxA2mCYaurCmbAZNSxeFdbB6RquWtWAXuZOJSygKWOYdElO3wrpj7nhMppjcWfQxRNXbR/O2ounOCE7hjnh4ujl15S7JKQGjnkQ/GWfAppjtnvkllgonhP6NV68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bygkM07j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bygkM07j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97812C32786;
	Wed, 24 Jul 2024 21:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721854948;
	bh=L0vv19KKjsXNX4Baybb4zIf5UVcQNwp0VKVq80wm5E8=;
	h=Date:To:From:Subject:From;
	b=bygkM07jf5pE4WDfv+Udu+SsozM0aElIBvCSC2fBh09qUFCXOQdbHeUHaBd9ImA/A
	 qKrNqi6UOkK4Tiio/bLv0eBHcSd+HVWfrGcfkM3w04FE4aQpsA+QeGHoXtJnrcu913
	 wN44ut28yhEWNsQSsPInRM2sV/zf2odSaeViwpwI=
Date: Wed, 24 Jul 2024 14:02:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,nphamcs@gmail.com,lizhijian@fujitsu.com,kent.overstreet@linux.dev,cerasuolodomenico@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-increase-the-valid-index-range-for-memcg-stats.patch added to mm-unstable branch
Message-Id: <20240724210228.97812C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: increase the valid index range for memcg stats
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-increase-the-valid-index-range-for-memcg-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-increase-the-valid-index-range-for-memcg-stats.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: increase the valid index range for memcg stats
Date: Wed, 24 Jul 2024 20:33:20 +0000

Patch series "Kernel stack usage histogram", v5.

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
@@ -322,24 +322,27 @@ static const unsigned int memcg_stat_ite
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
 #define MEMCG_VMSTAT_SIZE (NR_MEMCG_NODE_STAT_ITEMS + \
 			   ARRAY_SIZE(memcg_stat_items))
-static int8_t mem_cgroup_stats_index[MEMCG_NR_STAT] __read_mostly;
+#define IS_INVALID(index) ((index) == U8_MAX)
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
@@ -371,7 +374,7 @@ unsigned long lruvec_page_state(struct l
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -394,7 +397,7 @@ unsigned long lruvec_page_state_local(st
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -437,21 +440,24 @@ static const unsigned int memcg_vm_event
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
@@ -623,7 +629,7 @@ unsigned long memcg_page_state(struct me
 	long x;
 	int i = memcg_stats_index(idx);
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	x = READ_ONCE(memcg->vmstats->state[i]);
@@ -664,7 +670,7 @@ void __mod_memcg_state(struct mem_cgroup
 	if (mem_cgroup_disabled())
 		return;
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
@@ -677,7 +683,7 @@ unsigned long memcg_page_state_local(str
 	long x;
 	int i = memcg_stats_index(idx);
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	x = READ_ONCE(memcg->vmstats->state_local[i]);
@@ -696,7 +702,7 @@ static void __mod_memcg_lruvec_state(str
 	struct mem_cgroup *memcg;
 	int i = memcg_stats_index(idx);
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -812,7 +818,7 @@ void __count_memcg_events(struct mem_cgr
 	if (mem_cgroup_disabled())
 		return;
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
+	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	memcg_stats_lock();
@@ -825,7 +831,7 @@ unsigned long memcg_events(struct mem_cg
 {
 	int i = memcg_events_index(event);
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, event))
+	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, event))
 		return 0;
 
 	return READ_ONCE(memcg->vmstats->events[i]);
@@ -835,7 +841,7 @@ unsigned long memcg_events_local(struct
 {
 	int i = memcg_events_index(event);
 
-	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, event))
+	if (WARN_ONCE(IS_INVALID(i), "%s: missing stat item %d\n", __func__, event))
 		return 0;
 
 	return READ_ONCE(memcg->vmstats->events_local[i]);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-increase-the-valid-index-range-for-memcg-stats.patch

