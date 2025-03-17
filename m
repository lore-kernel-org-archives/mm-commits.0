Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7181D8634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188522; cv=none; b=MgJyGW3nRnnr+hhQ0K3FXtJG0EfbjunMwF84cynrVky7rukxW1n3f/e3+Y2D1wGxEfl6RhiKdvM4IErkQI9xfgkw6p+9rgyXQeYxf+EcrjzqdTz3cWPcxj9k4qMzL4i0BW4q/dYMd32NffVLF0euUeHw6Z+UOSx92E2ch8KdXS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188522; c=relaxed/simple;
	bh=x9W55EpJ7u8QXDCTqKoZAMZVtENBjKddCi1/JjCAR3c=;
	h=Date:To:From:Subject:Message-Id; b=RLaeC5zgD8Z4tBo7wyVcoqVwIV5gMWnsGRxzvqL+23uTeZDOLUyJcje3IWhOQ2Z5ITVdBHN8Fzs62cSlbD3tZm94ITTkSQcQrAciTPcj1JcpOSb3Mpk3BoypqBtrA2vINEEgxD57wmxSE3mdYY3SPNFWeKlBAS/6ann7xM8UqMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dM+mO6xN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dM+mO6xN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4630EC4CEEE;
	Mon, 17 Mar 2025 05:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188522;
	bh=x9W55EpJ7u8QXDCTqKoZAMZVtENBjKddCi1/JjCAR3c=;
	h=Date:To:From:Subject:From;
	b=dM+mO6xNqA9YpHefgSKfTGo+BhVLNfduOBwQO1D19GFCK6bCtD4DOpky9xAKMR0Du
	 Rsa2vKVxUaIYxX5Cs6ttS7UDfyqT9rXbf+RqXwtGFqk4WOrYgHWBu67aU3xoOgGzdV
	 BUBjHK4KGdQb9PtOu9KaipVeSCsHkb0JqfZefuuA=
Date: Sun, 16 Mar 2025 22:15:21 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] page_counter-track-failcnt-only-for-legacy-cgroups.patch removed from -mm tree
Message-Id: <20250317051522.4630EC4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: page_counter: track failcnt only for legacy cgroups
has been removed from the -mm tree.  Its filename was
     page_counter-track-failcnt-only-for-legacy-cgroups.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: page_counter: track failcnt only for legacy cgroups
Date: Thu, 27 Feb 2025 23:58:07 -0800

Currently page_counter tracks failcnt for counters used by v1 and v2
controllers.  However failcnt is only exported for v1 deployment and thus
there is no need to maintain it in v2.  The oom report does expose failcnt
for memory and swap in v2 but v2 already maintains MEMCG_MAX and
MEMCG_SWAP_MAX event counters which can be used.

Link: https://lkml.kernel.org/r/20250228075808.207484-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    4 +++-
 mm/hugetlb_cgroup.c          |   31 ++++++++++++++-----------------
 mm/memcontrol.c              |   12 ++++++++++--
 mm/page_counter.c            |    4 +++-
 4 files changed, 30 insertions(+), 21 deletions(-)

--- a/include/linux/page_counter.h~page_counter-track-failcnt-only-for-legacy-cgroups
+++ a/include/linux/page_counter.h
@@ -28,12 +28,13 @@ struct page_counter {
 	unsigned long watermark;
 	/* Latest cg2 reset watermark */
 	unsigned long local_watermark;
-	unsigned long failcnt;
+	unsigned long failcnt; /* v1-only field */
 
 	/* Keep all the read most fields in a separete cacheline. */
 	CACHELINE_PADDING(_pad2_);
 
 	bool protection_support;
+	bool track_failcnt;
 	unsigned long min;
 	unsigned long low;
 	unsigned long high;
@@ -58,6 +59,7 @@ static inline void page_counter_init(str
 	counter->max = PAGE_COUNTER_MAX;
 	counter->parent = parent;
 	counter->protection_support = protection_support;
+	counter->track_failcnt = false;
 }
 
 static inline unsigned long page_counter_read(struct page_counter *counter)
--- a/mm/hugetlb_cgroup.c~page_counter-track-failcnt-only-for-legacy-cgroups
+++ a/mm/hugetlb_cgroup.c
@@ -101,10 +101,9 @@ static void hugetlb_cgroup_init(struct h
 	int idx;
 
 	for (idx = 0; idx < HUGE_MAX_HSTATE; idx++) {
-		struct page_counter *fault_parent = NULL;
-		struct page_counter *rsvd_parent = NULL;
+		struct page_counter *fault, *fault_parent = NULL;
+		struct page_counter *rsvd, *rsvd_parent = NULL;
 		unsigned long limit;
-		int ret;
 
 		if (parent_h_cgroup) {
 			fault_parent = hugetlb_cgroup_counter_from_cgroup(
@@ -112,24 +111,22 @@ static void hugetlb_cgroup_init(struct h
 			rsvd_parent = hugetlb_cgroup_counter_from_cgroup_rsvd(
 				parent_h_cgroup, idx);
 		}
-		page_counter_init(hugetlb_cgroup_counter_from_cgroup(h_cgroup,
-								     idx),
-				  fault_parent, false);
-		page_counter_init(
-			hugetlb_cgroup_counter_from_cgroup_rsvd(h_cgroup, idx),
-			rsvd_parent, false);
+		fault = hugetlb_cgroup_counter_from_cgroup(h_cgroup, idx);
+		rsvd = hugetlb_cgroup_counter_from_cgroup_rsvd(h_cgroup, idx);
+
+		page_counter_init(fault, fault_parent, false);
+		page_counter_init(rsvd, rsvd_parent, false);
+
+		if (!cgroup_subsys_on_dfl(hugetlb_cgrp_subsys)) {
+			fault->track_failcnt = true;
+			rsvd->track_failcnt = true;
+		}
 
 		limit = round_down(PAGE_COUNTER_MAX,
 				   pages_per_huge_page(&hstates[idx]));
 
-		ret = page_counter_set_max(
-			hugetlb_cgroup_counter_from_cgroup(h_cgroup, idx),
-			limit);
-		VM_BUG_ON(ret);
-		ret = page_counter_set_max(
-			hugetlb_cgroup_counter_from_cgroup_rsvd(h_cgroup, idx),
-			limit);
-		VM_BUG_ON(ret);
+		VM_BUG_ON(page_counter_set_max(fault, limit));
+		VM_BUG_ON(page_counter_set_max(rsvd, limit));
 	}
 }
 
--- a/mm/memcontrol.c~page_counter-track-failcnt-only-for-legacy-cgroups
+++ a/mm/memcontrol.c
@@ -1572,16 +1572,23 @@ void mem_cgroup_print_oom_meminfo(struct
 	/* Use static buffer, for the caller is holding oom_lock. */
 	static char buf[SEQ_BUF_SIZE];
 	struct seq_buf s;
+	unsigned long memory_failcnt;
 
 	lockdep_assert_held(&oom_lock);
 
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		memory_failcnt = atomic_long_read(&memcg->memory_events[MEMCG_MAX]);
+	else
+		memory_failcnt = memcg->memory.failcnt;
+
 	pr_info("memory: usage %llukB, limit %llukB, failcnt %lu\n",
 		K((u64)page_counter_read(&memcg->memory)),
-		K((u64)READ_ONCE(memcg->memory.max)), memcg->memory.failcnt);
+		K((u64)READ_ONCE(memcg->memory.max)), memory_failcnt);
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		pr_info("swap: usage %llukB, limit %llukB, failcnt %lu\n",
 			K((u64)page_counter_read(&memcg->swap)),
-			K((u64)READ_ONCE(memcg->swap.max)), memcg->swap.failcnt);
+			K((u64)READ_ONCE(memcg->swap.max)),
+			atomic_long_read(&memcg->memory_events[MEMCG_SWAP_MAX]));
 #ifdef CONFIG_MEMCG_V1
 	else {
 		pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %lu\n",
@@ -3631,6 +3638,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
+		memcg->memory.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
--- a/mm/page_counter.c~page_counter-track-failcnt-only-for-legacy-cgroups
+++ a/mm/page_counter.c
@@ -121,6 +121,7 @@ bool page_counter_try_charge(struct page
 {
 	struct page_counter *c;
 	bool protection = track_protection(counter);
+	bool track_failcnt = counter->track_failcnt;
 
 	for (c = counter; c; c = c->parent) {
 		long new;
@@ -146,7 +147,8 @@ bool page_counter_try_charge(struct page
 			 * inaccuracy in the failcnt which is only used
 			 * to report stats.
 			 */
-			data_race(c->failcnt++);
+			if (track_failcnt)
+				data_race(c->failcnt++);
 			*fail = c;
 			goto failed;
 		}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-add-hierarchical-effective-limits-for-v2.patch
memcg-avoid-refill_stock-for-root-memcg.patch
memcg-move-do_memsw_account-to-config_memcg_v1.patch

