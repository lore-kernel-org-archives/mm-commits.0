Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED5B2F746D
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622312; cv=none; b=optrCjcNfSEFfSf7EpbvHVtFSV4WE0LT+f+bZBvmLhgfazjZigSgHr9XXXZKEeYFCv034ZlSpyY5Ng5L5PhqDSEmk0XqgKOJtoMjaRF9hG9umzxazS2w3o2+9QYiv/TP/iAP5g/yvwBPibteV7NWqutaGpUbv1xGptXezfhk8Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622312; c=relaxed/simple;
	bh=KqTb/iB/0fm3uvn9ImK08JI5aV5c1xemfCl6V5a7SFQ=;
	h=Date:To:From:Subject:Message-Id; b=AZ0dbaBBbvvPMSstL00oyuA3DkL7PTLotK3pX1Krg3cp/xB0J/GMQ7bDlhekvC3UYjGVXCfQqngamXKN0i3ZEdvZp/IERdJ3y+PP+8T+7c3QU67RbWaMpn5DtOV7SDw2XZjIL5ffpK6hDHvGtP92jg2FJeOwvEXoC1kNb5tjYxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DwWEha04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DwWEha04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D381F000E9;
	Tue, 25 Aug 2026 01:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622310;
	bh=/jbSNcWECG1G3T3T8wWJF7MiwH12q1xj8luvHzuADuo=;
	h=Date:To:From:Subject;
	b=DwWEha04nMxX28z+kv2Bw8giarMWwEWhn2kSELgvzeZz3mGQeBO9OE7o9r1DXCsLR
	 +monDzXWV5OvwBeFh5v76cOAuBJWzg2no3BCy6La5H6S255hPpBBW4l1puEdenWtnr
	 U6UiPEj4qePG3VLbd/VKrhIPnyyb6dVLdmW+qjMQ=
Date: Mon, 24 Aug 2026 18:45:10 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,husong@kylinos.cn,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch removed from -mm tree
Message-Id: <20260825014510.84D381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h
has been removed from the -mm tree.  Its filename was
     memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h
Date: Thu, 23 Jul 2026 11:24:33 +0800

Patch series "mm: vmscan: fix node reclaim ignoring swappiness parameter",
v4.

The per-node proactive reclaim interface
(/sys/devices/system/node/nodeX/reclaim) accepts a swappiness parameter,
but it is silently ignored when CONFIG_MEMCG is disabled.  The root cause
is that sc_swappiness() has separate implementations for CONFIG_MEMCG and
!CONFIG_MEMCG, and the latter never checks proactive_swappiness.

Patch 1 moves mem_cgroup_swappiness() and vm_swappiness out of the public
include/linux/swap.h into the mm-private mm/swap.h, and makes the helper
handle both CONFIG_MEMCG and !CONFIG_MEMCG in a single inline function. 
This is a prerequisite for unifying sc_swappiness().

Patch 2 consolidates sc_swappiness() into a single definition that works
regardless of CONFIG_MEMCG, fixing the node reclaim swappiness bug.


This patch (of 2):

The per-memcg swappiness knob is v1-only; v2 always uses global
vm_swappiness and ignores the per-cgroup field.

Both mem_cgroup_swappiness() and vm_swappiness are only used within mm/
(memcontrol.c, memcontrol-v1.c, vmscan.c), so move them out of the public
include/linux/swap.h into the mm-private mm/swap.h.  This keeps unrelated
declarations out of include/linux/swap.h.

Guard memcg->swappiness with CONFIG_MEMCG_V1 as well, so v2-only
kernels drop the unused field.

No functional change for v1; v2-only kernels drop the unused field.

Link: https://lore.kernel.org/20260723032434.2016749-1-ridong.chen@linux.dev
Link: https://lore.kernel.org/20260723032434.2016749-2-ridong.chen@linux.dev
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Song Hu <husong@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 include/linux/swap.h       |   19 -------------------
 mm/memcontrol.c            |    4 ++--
 mm/swap.h                  |   14 ++++++++++++++
 4 files changed, 18 insertions(+), 23 deletions(-)

--- a/include/linux/memcontrol.h~memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph
+++ a/include/linux/memcontrol.h
@@ -239,8 +239,6 @@ struct mem_cgroup {
 	 */
 	bool oom_group;
 
-	int swappiness;
-
 	/* memory.events and memory.events.local */
 	struct cgroup_file events_file;
 	struct cgroup_file events_local_file;
@@ -318,6 +316,8 @@ struct mem_cgroup {
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
+
+	int swappiness;
 #endif /* CONFIG_MEMCG_V1 */
 
 	struct mem_cgroup_per_node *nodeinfo[];
--- a/include/linux/swap.h~memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph
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
--- a/mm/memcontrol.c~memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph
+++ a/mm/memcontrol.c
@@ -63,6 +63,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
 #include "internal.h"
+#include "swap.h"
 #include "swap_table.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -4176,11 +4177,10 @@ mem_cgroup_css_alloc(struct cgroup_subsy
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
 		memcg->memsw.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
--- a/mm/swap.h~memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph
+++ a/mm/swap.h
@@ -4,6 +4,8 @@
 
 #include <linux/atomic.h> /* for atomic_long_t */
 #include <linux/mm.h> /* for PAGE_SHIFT */
+#include <linux/memcontrol.h> /* for mem_cgroup_swappiness() */
+
 struct mempolicy;
 struct swap_iocb;
 struct swap_memcg_table;
@@ -76,6 +78,18 @@ enum swap_cluster_flags {
 	CLUSTER_FLAG_MAX,
 };
 
+extern int vm_swappiness;
+
+static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG_V1
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
+	    !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
+		return READ_ONCE(memcg->swappiness);
+#endif
+	return READ_ONCE(vm_swappiness);
+}
+
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
_

Patches currently in -mm which might be from chenridong@xiaomi.com are


