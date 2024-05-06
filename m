Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5B438F91
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957155; cv=none; b=NAgPyQNP9szLkH6u5/ZzEFDMRaLWNh06epxy47T2XRw+MI+brbBLBTZZ0V5YMOE4eBm/jJH6hBGy2AT6fyH/8fez8rz+ubHs+Q3epAwRF+Vn3WojJjJnztGHJ4zd1Cn0J4HTzQ1IZhqPiURvE9c+X4BzV+eQSY6ar7naj+3k94k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957155; c=relaxed/simple;
	bh=6hBMcmAX8dEByvFg37JfUGnq6NZQCi9iriNUC1GHm5I=;
	h=Date:To:From:Subject:Message-Id; b=DeIE2vzs6RGN6m4B+WZRrfpzLRtNJM5cBB6M2/Tdo/lUmqajKpEQnJYHrOUp68fuGRMLarX9n//gtP/GCfQbJx7FxqXNyT6zQaN7bM63Z26a2dosgSegVROEXdp3Re/+VX/HXmadQ4vhDtu0ImNtbC3o6sEQWy8WHsVFJxVeG8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YPDiuxWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YPDiuxWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6594EC113CC;
	Mon,  6 May 2024 00:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957155;
	bh=6hBMcmAX8dEByvFg37JfUGnq6NZQCi9iriNUC1GHm5I=;
	h=Date:To:From:Subject:From;
	b=YPDiuxWuyyM8hTsOLnqdATnL/3hx+jkv7+dK/ETxI8pizPvyiq0XKjirUSN5YI8ES
	 9WePFT29wfFUqJw7H3ivT+PSKWjTN2eWZSLTujKjQ6GA0qxgt6GvVlCj5KD7AJH53f
	 b9EWqlL5X7huLqO2fIjCcZVuP8hazrlTasmRe1Js=
Date: Sun, 05 May 2024 17:59:14 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-warn-for-unexpected-events-and-stats.patch removed from -mm tree
Message-Id: <20240506005915.6594EC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: warn for unexpected events and stats
has been removed from the -mm tree.  Its filename was
     memcg-warn-for-unexpected-events-and-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: warn for unexpected events and stats
Date: Wed, 1 May 2024 10:26:16 -0700

To reduce memory usage by the memcg events and stats, the kernel uses
indirection table and only allocate stats and events which are being used
by the memcg code.  To make this more robust, let's add warnings where
unexpected stats and events indexes are used.

Link: https://lkml.kernel.org/r/20240501172617.678560-8-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

--- a/mm/memcontrol.c~memcg-warn-for-unexpected-events-and-stats
+++ a/mm/memcontrol.c
@@ -670,7 +670,7 @@ unsigned long lruvec_page_state(struct l
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-	if (i < 0)
+	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -686,14 +686,14 @@ unsigned long lruvec_page_state_local(st
 				      enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
-	long x = 0;
+	long x;
 	int i;
 
 	if (mem_cgroup_disabled())
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-	if (i < 0)
+	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -922,7 +922,7 @@ unsigned long memcg_page_state(struct me
 	long x;
 	int i = memcg_stats_index(idx);
 
-	if (i < 0)
+	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	x = READ_ONCE(memcg->vmstats->state[i]);
@@ -959,7 +959,10 @@ void __mod_memcg_state(struct mem_cgroup
 {
 	int i = memcg_stats_index(idx);
 
-	if (mem_cgroup_disabled() || i < 0)
+	if (mem_cgroup_disabled())
+		return;
+
+	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
@@ -972,7 +975,7 @@ static unsigned long memcg_page_state_lo
 	long x;
 	int i = memcg_stats_index(idx);
 
-	if (i < 0)
+	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
 	x = READ_ONCE(memcg->vmstats->state_local[i]);
@@ -991,7 +994,7 @@ static void __mod_memcg_lruvec_state(str
 	struct mem_cgroup *memcg;
 	int i = memcg_stats_index(idx);
 
-	if (i < 0)
+	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -1102,34 +1105,38 @@ void __mod_lruvec_kmem_state(void *p, en
 void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			  unsigned long count)
 {
-	int index = memcg_events_index(idx);
+	int i = memcg_events_index(idx);
 
-	if (mem_cgroup_disabled() || index < 0)
+	if (mem_cgroup_disabled())
+		return;
+
+	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	memcg_stats_lock();
-	__this_cpu_add(memcg->vmstats_percpu->events[index], count);
+	__this_cpu_add(memcg->vmstats_percpu->events[i], count);
 	memcg_rstat_updated(memcg, count);
 	memcg_stats_unlock();
 }
 
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
 {
-	int index = memcg_events_index(event);
+	int i = memcg_events_index(event);
 
-	if (index < 0)
+	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, event))
 		return 0;
-	return READ_ONCE(memcg->vmstats->events[index]);
+
+	return READ_ONCE(memcg->vmstats->events[i]);
 }
 
 static unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
 {
-	int index = memcg_events_index(event);
+	int i = memcg_events_index(event);
 
-	if (index < 0)
+	if (WARN_ONCE(i < 0, "%s: missing stat item %d\n", __func__, event))
 		return 0;
 
-	return READ_ONCE(memcg->vmstats->events_local[index]);
+	return READ_ONCE(memcg->vmstats->events_local[i]);
 }
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


