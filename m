Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE4415B984
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714664167; cv=none; b=ukORT5R3lI6x0kID4UJoI/wOfbz3wyjHuGWKnlkgKHuRMiHWpj1zXAXLDW+JgRXq7z9D6ATQKHpyLp7JkSqr4QVhYFvqdfMAuHg/9EKJrAtST1e+osyT5TxPLSnld26uvm6LIlh4YFDin9PNqKGPlEFfLzD5ejO9cT+GHjtGadc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714664167; c=relaxed/simple;
	bh=xW5BgkUw7d/exCPwIPhIAFnhHPygcC0uqZ3djD3rj5M=;
	h=Date:To:From:Subject:Message-Id; b=ZIyDL7XvJqkorw1FZb6m+f49QVsBH6xMHOIFsWhIqnLFpc+eBc9eVHt3uwXo81utITw6t5cRwvfEW2/8eemDmLwjN5VLRq4JJB59JYsW8ZOYN1VfY1DYtG6Ae4Rycqi92p5/QqUYPeQ7yLHzzC9ES1D9qlil76KzmcWwRz5rv3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=07P9X1tu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="07P9X1tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C555EC4AF14;
	Thu,  2 May 2024 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714664167;
	bh=xW5BgkUw7d/exCPwIPhIAFnhHPygcC0uqZ3djD3rj5M=;
	h=Date:To:From:Subject:From;
	b=07P9X1tuOuHLYRMpbwXcKNJM8Gxj3BtFHk18Lm4XT4oN/+ukhRDPWMyeqaopj6LK8
	 aYtHJALtksO48afmgVrewPKn70ztpd8pB8aPeAGmV1VqgUMiLkhnm3dqw0T2S+eegB
	 aS+lAqGR9hWII3AY63FglHGaXRu42JtyMir1HWfI=
Date: Thu, 02 May 2024 08:36:05 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-warn-for-unexpected-events-and-stats.patch added to mm-unstable branch
Message-Id: <20240502153606.C555EC4AF14@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: warn for unexpected events and stats
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-warn-for-unexpected-events-and-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-warn-for-unexpected-events-and-stats.patch

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

memcg-simple-cleanup-of-stats-update-functions.patch
memcg-reduce-memory-size-of-mem_cgroup_events_index.patch
memcg-dynamically-allocate-lruvec_stats.patch
memcg-reduce-memory-for-the-lruvec-and-memcg-stats.patch
memcg-cleanup-__mod_memcg_lruvec_state.patch
mm-cleanup-workingset_nodes-in-workingset.patch
memcg-warn-for-unexpected-events-and-stats.patch
memcg-use-proper-type-for-mod_memcg_state.patch

