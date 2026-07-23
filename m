Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8469D8634C
	for <mm-commits@vger.kernel.org>; Thu, 23 Jul 2026 01:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784771602; cv=none; b=GIatxMAOjfWyMQRA58IbTNDQmWDa2wPgWbt6XlC9hbS0xJcqeVqUWUBc10IKwgGMK4gnAxtvp39LgsRAyv7OxXq79CKXjO/PHrOQz1HuPUozJNQeza0q5c3oggeSd4LI6dP7cr96vvpZDdzdbqsCdXtXZKlHKGv+hO+cSUyy1oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784771602; c=relaxed/simple;
	bh=7LwxFow3pX5t1jnEr85sVWh7AQJrkXHVlFqulwUCBAY=;
	h=Date:To:From:Subject:Message-Id; b=JcgLKHdDDMdbxQgZ2Gw7r4jnfcTW07sSLE+gT/hr2HzttGdDHA2hkwggRx7UNCyTjTrUpjbWKS9pNUtNmkxpPGs3TFpj3kPR5m774fPOseoVO1PKdHJinlRzYalxqgmzcQC6wAvXm7ohYpM3dvNOrpl+d9N7iOpHUgCmwUUYxLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AHSa6p/h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AHSa6p/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE1C1F000E9;
	Thu, 23 Jul 2026 01:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784771600;
	bh=pRSIT9FoehJdAFAHKCfXYJmdaL1CmuSAxyDhCJpIGU8=;
	h=Date:To:From:Subject;
	b=AHSa6p/hdoNydWNBjTJLf215vhJ/Q8pL63lgG9YY57UtT8xswfDRNIq75J567IGZF
	 9a42GWucV91L5V869cRHP3AJzzygAkUwIopRMpy9zBwSX1A4BYS9hHZUKy+fvgYFbH
	 6tHLFMI7JPjAeLYeo9CPd7nykb1o95+gPKSrMXEg=
Date: Wed, 22 Jul 2026 18:53:19 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,husong@kylinos.cn,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch added to mm-new branch
Message-Id: <20260723015320.0BE1C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h
has been added to the -mm mm-new branch.  Its filename is
     memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch

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
Subject: memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h
Date: Thu, 16 Jul 2026 11:17:28 +0800

Patch series "mm: fix node reclaim swappiness handling", v2.

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

Guard memcg->swappiness with CONFIG_MEMCG_V1 as well, so v2-only kernels
drop the unused field.

Link: https://lore.kernel.org/20260716031729.1064007-1-ridong.chen@linux.dev
Link: https://lore.kernel.org/20260716031729.1064007-2-ridong.chen@linux.dev
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Reviewed-by: Song Hu <husong@kylinos.cn>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 include/linux/swap.h       |   19 -------------------
 mm/memcontrol.c            |    4 ++--
 mm/swap.h                  |   20 ++++++++++++++++++++
 4 files changed, 24 insertions(+), 23 deletions(-)

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
@@ -473,25 +472,7 @@ static inline int add_swap_extent(struct
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
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
--- a/mm/swap.h~memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph
+++ a/mm/swap.h
@@ -4,6 +4,7 @@
 
 #include <linux/atomic.h> /* for atomic_long_t */
 #include <linux/mm.h> /* for PAGE_SHIFT */
+#include <linux/memcontrol.h> /* for mem_cgroup_swappiness() */
 
 struct mempolicy;
 struct swap_iocb;
@@ -99,6 +100,25 @@ struct swap_ops {
 	void (*submit_read)(struct swap_io_ctx *ctx);
 };
 
+extern int vm_swappiness;
+
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
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch
mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch
mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch
memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch
mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

