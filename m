Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6642B3FF8B6
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525415; cv=none; b=K2rqLYKEd/i7AwtNBgl6rz9O0mKDW3gukZb54Ip39UXX4uIZVxpAXAlmukFMeMLl30B3F57Qid9QLK4keowvP3ooSQ/1AmtJmLpb6SPVOfQ5YuENPJs1j7vMEWQod+Gz0680L1MeY/DURkdJSNR4VF2MuN6fb9Ku9Qa/it/xFcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525415; c=relaxed/simple;
	bh=ON5Y0uFk3B+RN/0/z7WkM8qjkis2zhxzv3SHmr4b8kU=;
	h=Date:To:From:Subject:Message-Id; b=XIjTOi0zVREpNFbljeK45UtYCONiPwlV0s7bYP7+7eKWB1yHaSKeSXWKPPOrWb+ewy/yILWW4akSnsEDYEIGQVRQdX+KHUufIByrRPyx0AGPEYOggCvxR7PZeWg1DnEMROaA0/CWmHDKf+CVZeTzxfhfa5Y3kHqv8B3ZApyJcEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vtPeJ2L6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vtPeJ2L6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6E81F00893;
	Fri,  9 Oct 2026 05:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525414;
	bh=xPackw/zNtqCaAGf4NYMXnzqPAtn3j3wvuKYbX9RYCg=;
	h=Date:To:From:Subject;
	b=vtPeJ2L6Vn12EMQh9FNvHe3U8S9rZtvb2nQuNkkAW4iyZ96GKwBVvWyIPPBf/vM60
	 ++DmBqTgdofbj/N/JTOzhERtOFB5l0rGkMQ9Sy0DAcP/PgaPGmuCM+/7uQY6xgffRP
	 6vKN9MpdB2rR2REOCIEh6fLn3b/T1i3mBkDnEvIQ=
Date: Thu, 08 Oct 2026 22:56:53 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-group-the-cold-fields-of-struct-mem_cgroup.patch removed from -mm tree
Message-Id: <20261009055654.3C6E81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: group the cold fields of struct mem_cgroup
has been removed from the -mm tree.  Its filename was
     memcg-group-the-cold-fields-of-struct-mem_cgroup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: group the cold fields of struct mem_cgroup
Date: Fri, 4 Sep 2026 20:05:20 -0700

These fields are only touched by the cgroup control paths:

  memory_peaks, swap_peaks, peaks_lock   memory.peak open/read/release
  events_file, events_local_file,
  swap_events_file                       cgroup_file_notify()
  cgwb_list, cgwb_domain, cgwb_frn       writeback setup and the
                                         foreign dirty slow path
  mm_list                                MGLRU mm list

They sit in the middle of the struct today.  The three cgroup_file members
alone are 192 bytes of notify state next to the vmstats pointer.  Put them
in one cache line group.

No functional change.

Link: https://lore.kernel.org/20260905030522.1887837-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 include/linux/memcontrol.h |   49 ++++++++++++++++++++---------------
 mm/memcontrol.c            |   25 +++++++++++++++++
 2 files changed, 53 insertions(+), 21 deletions(-)

--- a/include/linux/memcontrol.h~memcg-group-the-cold-fields-of-struct-mem_cgroup
+++ a/include/linux/memcontrol.h
@@ -228,11 +228,37 @@ struct mem_cgroup {
 
 	__cacheline_group_end_aligned(memcg_write_hot);
 
+	/*
+	 * Off the charge and fault paths.  Not write free: cgwb_domain is
+	 * written on every writeout completion and mm_list on fork, exit and
+	 * MGLRU aging.  They are grouped here so those writes cannot land on
+	 * a line that the fast paths read.
+	 */
+	__cacheline_group_begin_aligned(memcg_cold);
 	/* registered local peak watchers */
 	struct list_head memory_peaks;
 	struct list_head swap_peaks;
 	spinlock_t	 peaks_lock;
 
+	/* memory.events and memory.events.local */
+	struct cgroup_file events_file;
+	struct cgroup_file events_local_file;
+
+	/* handle for "memory.swap.events" */
+	struct cgroup_file swap_events_file;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
+	struct list_head cgwb_list;
+	struct wb_domain cgwb_domain;
+	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
+#endif
+
+#ifdef CONFIG_LRU_GEN_WALKS_MMU
+	/* per-memcg mm_struct list */
+	struct lru_gen_mm_list mm_list;
+#endif
+	__cacheline_group_end_aligned(memcg_cold);
+
 #ifdef CONFIG_ZSWAP
 	unsigned long zswap_max;
 
@@ -248,37 +274,18 @@ struct mem_cgroup {
 	 */
 	bool oom_group;
 
-	/* memory.events and memory.events.local */
-	struct cgroup_file events_file;
-	struct cgroup_file events_local_file;
-
-	/* handle for "memory.swap.events" */
-	struct cgroup_file swap_events_file;
-
 	/* memory.stat */
 	struct memcg_vmstats	*vmstats;
 
 	int kmemcg_id;
 
-#ifdef CONFIG_CGROUP_WRITEBACK
-	struct list_head cgwb_list;
-#endif
-
 	/* Keep the hot per-CPU stats pointer away from memory event counters. */
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu
 		____cacheline_aligned_in_smp;
 
-#ifdef CONFIG_CGROUP_WRITEBACK
-	struct wb_domain cgwb_domain;
-	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
-#endif
-
-#ifdef CONFIG_LRU_GEN_WALKS_MMU
-	/* per-memcg mm_struct list */
-	struct lru_gen_mm_list mm_list;
-#endif
-
 #ifdef CONFIG_MEMCG_V1
+	/* v1 only. Not grouped: v1 is legacy, sorting it is not worth it. */
+
 	/* Legacy consumer-oriented counters */
 	struct page_counter kmem;		/* v1 only */
 	struct page_counter tcpmem;		/* v1 only */
--- a/mm/memcontrol.c~memcg-group-the-cold-fields-of-struct-mem_cgroup
+++ a/mm/memcontrol.c
@@ -5728,6 +5728,31 @@ static void __init memcg_struct_check(vo
 				      high_irq_work);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
 				      high_work);
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      memory_peaks);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      swap_peaks);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      peaks_lock);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      events_file);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      events_local_file);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      swap_events_file);
+#ifdef CONFIG_CGROUP_WRITEBACK
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      cgwb_list);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      cgwb_domain);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      cgwb_frn);
+#endif
+#ifdef CONFIG_LRU_GEN_WALKS_MMU
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      mm_list);
+#endif
 }
 
 int __init mem_cgroup_init(void)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


