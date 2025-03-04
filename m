Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C0279F5
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 04:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741062877; cv=none; b=heFbuiy7U31SoZR5b8x5zIyoriMhiEAQKKaTfeID25WPBG8KaN+ImaRC6DWI2FDiaohXCyP1x062RoOFGkhMz+sDPx5QYm98B2Ebe54v9e4Kgn5Ky0t/BatiOBc6iunGKdcAdwpNSSed+2am03LOfjVveArdZzElHEJ+aU1Al2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741062877; c=relaxed/simple;
	bh=jqfB5FN4BZ9H5oU9p3VleUbcUXXCkGgFbvkzu/vXRVQ=;
	h=Date:To:From:Subject:Message-Id; b=O1JAfc2j9QfIJbiGpp/PLBlzcytQvBtf1vWkE86UOwdicP+owrrVKD9HsPsow5ivZQ64ikcu1IcTArMIQLQHfkxJLEiBd+YbB/GrzevhMHV30hzOND+5VVd2KNsLP0BjD8xFfd7GjU3/Wd3HthMYtWlwKOHsM+aFXw10sZzyIks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rp5DzBW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rp5DzBW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9501C4CEE5;
	Tue,  4 Mar 2025 04:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741062876;
	bh=jqfB5FN4BZ9H5oU9p3VleUbcUXXCkGgFbvkzu/vXRVQ=;
	h=Date:To:From:Subject:From;
	b=Rp5DzBW1jfG7pq0mMksR+ACDTdpBq/WBoYDxCYJIWYB0v7h6vMQH93QTDocj7iX82
	 k83wqq6Rzs17TLZ7LSqAdvNphTig3UzJ+OIoaonLcP3BtGPXNPw2Ufm+7DrenYA/NT
	 wZR/Bq7LEf1KU2XTygXgx+n0G82MrmzxN3/J8dJY=
Date: Mon, 03 Mar 2025 20:34:36 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + page_counter-track-failcnt-only-for-legacy-cgroups.patch added to mm-unstable branch
Message-Id: <20250304043436.D9501C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: page_counter: track failcnt only for legacy cgroups
has been added to the -mm mm-unstable branch.  Its filename is
     page_counter-track-failcnt-only-for-legacy-cgroups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/page_counter-track-failcnt-only-for-legacy-cgroups.patch

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
@@ -3622,6 +3629,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
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
memcg-dont-call-propagate_protected_usage-for-v1.patch
page_counter-track-failcnt-only-for-legacy-cgroups.patch
page_counter-reduce-struct-page_counter-size.patch

