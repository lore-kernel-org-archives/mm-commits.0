Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A072B1C3BF7
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 21:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783717761; cv=none; b=OHz/jAD6W0aLpa3q3GRDPk5iCN7/HdgH4q9f+7P4eq6sF3PbiWC3L+pYZUhIGb4ZBKfyyVRuk1hEdofsZeXeoLVTHvbzGcY7frGPM83RVBxkQtXNoWYhWQ09Yw8v9HwhhI8REXG0RI2Mh54yRq+ZgaT0BqkM3t30BllZjM5Bn3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783717761; c=relaxed/simple;
	bh=Y4cjf3ZpYe+N9SXJhHmoW1yqoMUugdY4YvOVQo+4aaM=;
	h=Date:To:From:Subject:Message-Id; b=CgBy1leypax8XblcAwm9TZBQqOzQ1YIYDrQQxrOHSvOIwfHnoJklI5rp8vJbxmdaQ5luJIPXTX48C48raUVqo4jzKwhrRm3jZd+tTYgqkncWCGaibWmiYHedip5mhQ6cZ7cLikBFVkMZd+IEBZvsCSGhs9FyhttqCjcjeI1inZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J+nVXTfK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J+nVXTfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522461F000E9;
	Fri, 10 Jul 2026 21:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783717759;
	bh=s445dqB+pA7BaO1EuUCVta6A+9W1TcVHfL289VGJ4JU=;
	h=Date:To:From:Subject;
	b=J+nVXTfKkhbYPCWY0FppugO3rQmQT9V6wNIgQ6TXBPh8VrtdESjLHcy8fL0DDvBRe
	 DUQkxWIzRHF7F1tjKp3tgyJS0Mo0sOZf+GXFbCHUdSPRCW2yGVRsv+qL2CR1ID+PhD
	 c4qCn9/g+BEY2rY0Wqt+h6Et2Tbt/Qf+BbHzB9xM=
Date: Fri, 10 Jul 2026 14:09:18 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-move-mem_cgroup_swappiness-to-memcontrolh.patch added to mm-new branch
Message-Id: <20260710210919.522461F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: move mem_cgroup_swappiness to memcontrol.h
has been added to the -mm mm-new branch.  Its filename is
     memcg-move-mem_cgroup_swappiness-to-memcontrolh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-move-mem_cgroup_swappiness-to-memcontrolh.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: memcg: move mem_cgroup_swappiness to memcontrol.h
Date: Fri, 10 Jul 2026 19:12:24 +0800

The per-memcg swappiness knob is v1-only; v2 always uses global
vm_swappiness and ignores the per-cgroup field.

Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper to
memcontrol.h where it belongs.

No functional change for v1; v2-only kernels drop the unused field.

Link: https://lore.kernel.org/20260710111224.2355668-1-ridong.chen@linux.dev
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   25 +++++++++++++++++++++++--
 include/linux/swap.h       |   19 -------------------
 mm/memcontrol.c            |    3 +--
 3 files changed, 24 insertions(+), 23 deletions(-)

--- a/include/linux/memcontrol.h~memcg-move-mem_cgroup_swappiness-to-memcontrolh
+++ a/include/linux/memcontrol.h
@@ -239,8 +239,6 @@ struct mem_cgroup {
 	 */
 	bool oom_group;
 
-	int swappiness;
-
 	/* memory.events and memory.events.local */
 	struct cgroup_file events_file;
 	struct cgroup_file events_local_file;
@@ -318,6 +316,9 @@ struct mem_cgroup {
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
+
+	int swappiness;
+
 #endif /* CONFIG_MEMCG_V1 */
 
 	struct mem_cgroup_per_node *nodeinfo[];
@@ -365,6 +366,9 @@ enum objext_flags {
 
 #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
 
+/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
+extern int vm_swappiness;
+
 #ifdef CONFIG_MEMCG
 /*
  * After the initialization objcg->memcg is always pointing at
@@ -1440,6 +1444,23 @@ static inline void mem_cgroup_flush_work
 static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
+static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG_V1
+	/* Cgroup2 doesn't have per-cgroup swappiness */
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return READ_ONCE(vm_swappiness);
+
+	/* root ? */
+	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
+		return READ_ONCE(vm_swappiness);
+
+	return READ_ONCE(memcg->swappiness);
+#else
+	return READ_ONCE(vm_swappiness);
+#endif
+}
+
 /*
  * Extended information for slab objects stored as an array in page->memcg_data
  * if MEMCG_DATA_OBJEXTS is set.
--- a/include/linux/swap.h~memcg-move-mem_cgroup_swappiness-to-memcontrolh
+++ a/include/linux/swap.h
@@ -309,7 +309,6 @@ static inline bool lru_cache_disabled(vo
 }
 
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
-extern int vm_swappiness;
 long remove_mapping(struct address_space *mapping, struct folio *folio);
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
@@ -468,25 +467,7 @@ static inline int add_swap_extent(struct
 }
 #endif /* CONFIG_SWAP */
 #ifdef CONFIG_MEMCG
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
-{
-	/* Cgroup2 doesn't have per-cgroup swappiness */
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return READ_ONCE(vm_swappiness);
-
-	/* root ? */
-	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
-		return READ_ONCE(vm_swappiness);
-
-	return READ_ONCE(memcg->swappiness);
-}
-
 void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
-#else
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
-{
-	return READ_ONCE(vm_swappiness);
-}
 #endif
 
 #if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
--- a/mm/memcontrol.c~memcg-move-mem_cgroup_swappiness-to-memcontrolh
+++ a/mm/memcontrol.c
@@ -4174,11 +4174,10 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
-		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
-
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
+		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

memcg-move-mem_cgroup_swappiness-to-memcontrolh.patch

