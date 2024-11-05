Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B6036127
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 03:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730778484; cv=none; b=pwcx1RG2YFzILp8rZuaRpO6ra2PNb5jPQWlvIrnPMRCjNBvBBTO2CA0T7fk+AkklaMcL8XLeNHwkV3tf/IBugQr5WVQuRspfvKPegimpsdKHYU0etK9LmWrLkbTLEuqAy0SVu1PkP69Z1drisO1C0HMT6F9n+Grg3B+STMpZ7IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730778484; c=relaxed/simple;
	bh=GelreDwFzQ+xisU8bSm3Oaq2d0H6HD+zespAP2Sk3X8=;
	h=Date:To:From:Subject:Message-Id; b=LadtvEcLMN2oU2kJPaUpeP6uJHOVGQn+dypSZF9ceBe0MGeMry1PCMSV9bcY2Xu9PseWQRCzP4U3L632dfLGmHJ5oU8asJYGTF6JtVjnU/TjMfWlj8NbK19KvvOewhZRymAfz5awjc4/t33pxj/EBMug82HzfdBe3dNGmIqvKvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vY/jcl7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vY/jcl7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101BEC4CECF;
	Tue,  5 Nov 2024 03:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730778484;
	bh=GelreDwFzQ+xisU8bSm3Oaq2d0H6HD+zespAP2Sk3X8=;
	h=Date:To:From:Subject:From;
	b=vY/jcl7rFi4TLMLpLLTUijVkXrFowhwcAwghVM34VBH3H5bx/0euLEV7RfrYASkac
	 jg3ADU8SY9Ue9EeoL8N+dqxoCi/v7xsOumm0xyJEl36RhP0nU9VaZRVid/q9uItKiH
	 ihT7lrr55zxqeQCqhRlCX0zuMuTt16pLKXrVzFck=
Date: Mon, 04 Nov 2024 19:48:03 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,lizefan.x@bytedance.com,hannes@cmpxchg.org,corbet@lwn.net,chris@chrisdown.name,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-hugetlb-add-hugetlb-counters-to-memcg.patch added to mm-unstable branch
Message-Id: <20241105034804.101BEC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg/hugetlb: add hugeTLB counters to memcg
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-hugetlb-add-hugetlb-counters-to-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-hugetlb-add-hugetlb-counters-to-memcg.patch

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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: memcg/hugetlb: add hugeTLB counters to memcg
Date: Fri, 1 Nov 2024 13:44:02 -0700

This patch introduces a new counter to memory.stat that tracks hugeTLB
usage, only if hugeTLB accounting is done to memory.current.  This feature
is enabled the same way hugeTLB accounting is enabled, via the
memory_hugetlb_accounting mount flag for cgroupsv2.

1. Why is this patch necessary?
Currently, memcg hugeTLB accounting is an opt-in feature [1] that adds
hugeTLB usage to memory.current.  However, the metric is not reported in
memory.stat.  Given that users often interpret memory.stat as a breakdown
of the value reported in memory.current, the disparity between the two
reports can be confusing.  This patch solves this problem by including the
metric in memory.stat as well, but only if it is also reported in
memory.current (it would also be confusing if the value was reported in
memory.stat, but not in memory.current)

Aside from the consistency between the two files, we also see benefits in
observability.  Userspace might be interested in the hugeTLB footprint of
cgroups for many reasons.  For instance, system admins might want to
verify that hugeTLB usage is distributed as expected across tasks: i.e. 
memory-intensive tasks are using more hugeTLB pages than tasks that don't
consume a lot of memory, or are seen to fault frequently.  Note that this
is separate from wanting to inspect the distribution for limiting purposes
(in which case, hugeTLB controller makes more sense).

2. We already have a hugeTLB controller. Why not use that?
It is true that hugeTLB tracks the exact value that we want.  In fact, by
enabling the hugeTLB controller, we get all of the observability benefits
that I mentioned above, and users can check the total hugeTLB usage,
verify if it is distributed as expected, etc.

With this said, there are 2 problems:
(a) They are still not reported in memory.stat, which means the
    disparity between the memcg reports are still there.
(b) We cannot reasonably expect users to enable the hugeTLB controller
    just for the sake of hugeTLB usage reporting, especially since
    they don't have any use for hugeTLB usage enforcing [2].

3. Implementation Details:
In the alloc / free hugetlb functions, we call lruvec_stat_mod_folio
regardless of whether memcg accounts hugetlb.  mem_cgroup_commit_charge
which is called from alloc_hugetlb_folio will set memcg for the folio only
if the CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING cgroup mount option is used, so
lruvec_stat_mod_folio accounts per-memcg hugetlb counters only if the
feature is enabled.  Regardless of whether memcg accounts for hugetlb, the
newly added global counter is updated and shown in /proc/vmstat.

The global counter is added because vmstats is the preferred framework for
cgroup stats.  It makes stat items consistent between global and cgroups. 
It also provides a per-node breakdown, which is useful.  Because it does
not use cgroup-specific hooks, we also keep generic MM code separate from
memcg code.

[1] https://lore.kernel.org/all/20231006184629.155543-1-nphamcs@gmail.com/
[2] Of course, we can't make a new patch for every feature that can be
    duplicated. However, since the existing solution of enabling the
    hugeTLB controller is an imperfect solution that still leaves a
    discrepancy between memory.stat and memory.curent, I think that it
    is reasonable to isolate the feature in this case.

Link: https://lkml.kernel.org/r/20241101204402.1885383-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    5 +++++
 include/linux/mmzone.h                  |    3 +++
 mm/hugetlb.c                            |    2 ++
 mm/memcontrol.c                         |   11 +++++++++++
 mm/vmstat.c                             |    3 +++
 5 files changed, 24 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~memcg-hugetlb-add-hugetlb-counters-to-memcg
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1646,6 +1646,11 @@ The following nested keys are defined.
 	  pgdemote_khugepaged
 		Number of pages demoted by khugepaged.
 
+	  hugetlb
+		Amount of memory used by hugetlb pages. This metric only shows
+		up if hugetlb usage is accounted for in memory.current (i.e.
+		cgroup is mounted with the memory_hugetlb_accounting option).
+
   memory.numa_stat
 	A read-only nested-keyed file which exists on non-root cgroups.
 
--- a/include/linux/mmzone.h~memcg-hugetlb-add-hugetlb-counters-to-memcg
+++ a/include/linux/mmzone.h
@@ -220,6 +220,9 @@ enum node_stat_item {
 	PGDEMOTE_KSWAPD,
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
+#ifdef CONFIG_HUGETLB_PAGE
+	NR_HUGETLB,
+#endif
 	NR_VM_NODE_STAT_ITEMS
 };
 
--- a/mm/hugetlb.c~memcg-hugetlb-add-hugetlb-counters-to-memcg
+++ a/mm/hugetlb.c
@@ -1925,6 +1925,7 @@ void free_huge_folio(struct folio *folio
 				     pages_per_huge_page(h), folio);
 	hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					  pages_per_huge_page(h), folio);
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, -pages_per_huge_page(h));
 	mem_cgroup_uncharge(folio);
 	if (restore_reserve)
 		h->resv_huge_pages++;
@@ -3093,6 +3094,7 @@ struct folio *alloc_hugetlb_folio(struct
 
 	if (!memcg_charge_ret)
 		mem_cgroup_commit_charge(folio, memcg);
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 	mem_cgroup_put(memcg);
 
 	return folio;
--- a/mm/memcontrol.c~memcg-hugetlb-add-hugetlb-counters-to-memcg
+++ a/mm/memcontrol.c
@@ -315,6 +315,9 @@ static const unsigned int memcg_node_sta
 	PGDEMOTE_KSWAPD,
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
+#ifdef CONFIG_HUGETLB_PAGE
+	NR_HUGETLB,
+#endif
 };
 
 static const unsigned int memcg_stat_items[] = {
@@ -1362,6 +1365,9 @@ static const struct memory_stat memory_s
 	{ "unevictable",		NR_UNEVICTABLE			},
 	{ "slab_reclaimable",		NR_SLAB_RECLAIMABLE_B		},
 	{ "slab_unreclaimable",		NR_SLAB_UNRECLAIMABLE_B		},
+#ifdef CONFIG_HUGETLB_PAGE
+	{ "hugetlb",			NR_HUGETLB			},
+#endif
 
 	/* The memory events */
 	{ "workingset_refault_anon",	WORKINGSET_REFAULT_ANON		},
@@ -1457,6 +1463,11 @@ static void memcg_stat_format(struct mem
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
 
+#ifdef CONFIG_HUGETLB_PAGE
+		if (unlikely(memory_stats[i].idx == NR_HUGETLB) &&
+		    !(cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING))
+			continue;
+#endif
 		size = memcg_page_state_output(memcg, memory_stats[i].idx);
 		seq_buf_printf(s, "%s %llu\n", memory_stats[i].name, size);
 
--- a/mm/vmstat.c~memcg-hugetlb-add-hugetlb-counters-to-memcg
+++ a/mm/vmstat.c
@@ -1273,6 +1273,9 @@ const char * const vmstat_text[] = {
 	"pgdemote_kswapd",
 	"pgdemote_direct",
 	"pgdemote_khugepaged",
+#ifdef CONFIG_HUGETLB_PAGE
+	"nr_hugetlb",
+#endif
 	/* system-wide enum vm_stat_item counters */
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

memcg-hugetlb-add-hugetlb-counters-to-memcg.patch

