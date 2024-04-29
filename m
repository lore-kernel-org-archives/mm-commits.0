Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684F08663E
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 17:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714411160; cv=none; b=tzNwd5chU9UkyKDSUsuhYnG/a3dz60HPyUwrTnFRoGBxJ222v1d2fF2uMv+qQE+gx/4r/JhN46cmAj92kWeXWeo2KqFdvRkNSttHM1QrKciaWMyjAJbXYXaotRXgaqw15QI78SfV6hoK9ae0HQGEc6LsP2FQjOypOVOu6eYljWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714411160; c=relaxed/simple;
	bh=n/jw6+gOv0LqiU3ub7wCgjngp+P4wJy/3BOyIcA1kBY=;
	h=Date:To:From:Subject:Message-Id; b=AOj+i0htjzIZ9dOxqZq97INam5lnrLDueYkIP65irgkxDdDGrG0NycrAYHiW4ib1AxlXa9RBTn9MjlABNeM/7MpJG1ATX/GNdZFIAByApwhEL+YibfyfC1DAzvu/YO5RLPanoVN7k0CzO+nX+el4tZ9qcmCzZHTfgGuLwBaYOjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BFPViSPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BFPViSPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9615C113CD;
	Mon, 29 Apr 2024 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714411159;
	bh=n/jw6+gOv0LqiU3ub7wCgjngp+P4wJy/3BOyIcA1kBY=;
	h=Date:To:From:Subject:From;
	b=BFPViSPsj/Ma1APWhZzjcghdbD4SsgwU1SoXezxsngnnXVSXInvOpPWJrrmB9V4nv
	 EdEdiZX43Sclp9+gSmVt36i9A/V9+vmm5cIXHgYpAQ86r1CjTBibJU7VTFS81USjy2
	 OjiVRI4T5b/jRFKEZxQsWe2VX6FHcNHl/mbN4Zo0=
Date: Mon, 29 Apr 2024 10:19:18 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-pr_warn_once-for-unexpected-events-and-stats.patch added to mm-unstable branch
Message-Id: <20240429171919.B9615C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: pr_warn_once for unexpected events and stats
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-pr_warn_once-for-unexpected-events-and-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-pr_warn_once-for-unexpected-events-and-stats.patch

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
Subject: memcg: pr_warn_once for unexpected events and stats
Date: Fri, 26 Apr 2024 17:37:31 -0700

To reduce memory usage by the memcg events and stats, the kernel uses
indirection table and only allocate stats and events which are being used
by the memcg code.  To make this more robust, let's add warnings where
unexpected stats and events indexes are used.

Link: https://lkml.kernel.org/r/20240427003733.3898961-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~memcg-pr_warn_once-for-unexpected-events-and-stats
+++ a/mm/memcontrol.c
@@ -670,9 +670,11 @@ unsigned long lruvec_page_state(struct l
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-	if (i >= 0) {
+	if (likely(i >= 0)) {
 		pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 		x = READ_ONCE(pn->lruvec_stats->state[i]);
+	} else {
+		pr_warn_once("%s: stat item index: %d\n", __func__, idx);
 	}
 #ifdef CONFIG_SMP
 	if (x < 0)
@@ -692,9 +694,11 @@ unsigned long lruvec_page_state_local(st
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-	if (i >= 0) {
+	if (likely(i >= 0)) {
 		pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 		x = READ_ONCE(pn->lruvec_stats->state_local[i]);
+	} else {
+		pr_warn_once("%s: stat item index: %d\n", __func__, idx);
 	}
 #ifdef CONFIG_SMP
 	if (x < 0)
@@ -921,8 +925,10 @@ unsigned long memcg_page_state(struct me
 	long x;
 	int i = memcg_stats_index(idx);
 
-	if (i < 0)
+	if (unlikely(i < 0)) {
+		pr_warn_once("%s: stat item index: %d\n", __func__, idx);
 		return 0;
+	}
 
 	x = READ_ONCE(memcg->vmstats->state[i]);
 #ifdef CONFIG_SMP
@@ -958,8 +964,13 @@ void __mod_memcg_state(struct mem_cgroup
 {
 	int i = memcg_stats_index(idx);
 
-	if (mem_cgroup_disabled() || i < 0)
+	if (mem_cgroup_disabled())
+		return;
+
+	if (unlikely(i < 0)) {
+		pr_warn_once("%s: stat item index: %d\n", __func__, idx);
 		return;
+	}
 
 	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
 	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
@@ -971,8 +982,10 @@ static unsigned long memcg_page_state_lo
 	long x;
 	int i = memcg_stats_index(idx);
 
-	if (i < 0)
+	if (unlikely(i < 0)) {
+		pr_warn_once("%s: stat item index: %d\n", __func__, idx);
 		return 0;
+	}
 
 	x = READ_ONCE(memcg->vmstats->state_local[i]);
 #ifdef CONFIG_SMP
@@ -990,8 +1003,10 @@ static void __mod_memcg_lruvec_state(str
 	struct mem_cgroup *memcg;
 	int i = memcg_stats_index(idx);
 
-	if (i < 0)
+	if (unlikely(i < 0)) {
+		pr_warn_once("%s: stat item index: %d\n", __func__, idx);
 		return;
+	}
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	memcg = pn->memcg;
@@ -1103,8 +1118,13 @@ void __count_memcg_events(struct mem_cgr
 {
 	int index = memcg_events_index(idx);
 
-	if (mem_cgroup_disabled() || index < 0)
+	if (mem_cgroup_disabled())
+		return;
+
+	if (unlikely(index < 0)) {
+		pr_warn_once("%s: event item index: %d\n", __func__, idx);
 		return;
+	}
 
 	memcg_stats_lock();
 	__this_cpu_add(memcg->vmstats_percpu->events[index], count);
@@ -1116,8 +1136,11 @@ static unsigned long memcg_events(struct
 {
 	int index = memcg_events_index(event);
 
-	if (index < 0)
+	if (unlikely(index < 0)) {
+		pr_warn_once("%s: event item index: %d\n", __func__, event);
 		return 0;
+	}
+
 	return READ_ONCE(memcg->vmstats->events[index]);
 }
 
@@ -1125,8 +1148,10 @@ static unsigned long memcg_events_local(
 {
 	int index = memcg_events_index(event);
 
-	if (index < 0)
+	if (unlikely(index < 0)) {
+		pr_warn_once("%s: event item index: %d\n", __func__, event);
 		return 0;
+	}
 
 	return READ_ONCE(memcg->vmstats->events_local[index]);
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-simple-cleanup-of-stats-update-functions.patch
memcg-reduce-memory-size-of-mem_cgroup_events_index.patch
memcg-dynamically-allocate-lruvec_stats.patch
memcg-reduce-memory-for-the-lruvec-and-memcg-stats.patch
memcg-cleanup-__mod_memcg_lruvec_state.patch
memcg-pr_warn_once-for-unexpected-events-and-stats.patch
memcg-use-proper-type-for-mod_memcg_state.patch
mm-cleanup-workingset_nodes-in-workingset.patch

