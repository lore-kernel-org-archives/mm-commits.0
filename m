Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD593FD96E
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525414; cv=none; b=IYKpeEx5I8Z2o4OwNtxbjAtQEA4ENgwXtGvjeCzAbO6suSDxYE/+Y5GB/RcUl90z9rdiRGOjGjzCvIOpcI2vt84j7fr3pO5m7F/D6ecL2VullOO+dic0NwEeEL0lONlg5IzH+fUaGCqGt9Iyhcc3xro+KIO6o4d2JIo8/JJSqMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525414; c=relaxed/simple;
	bh=lrsk4ektXkMCYDZA845QFrX1um+nmli/ZECXWSoNuRs=;
	h=Date:To:From:Subject:Message-Id; b=KgnuqmTd8XYyFAX8byaSvqOodWREdlEkSO6pBzyxgY5skH8bdycE0mkbKSoqrBqaeJEeeiEqC4VjrFa7x0TZh68Y2AaeulHNnEYQQwwlqo5nlV8dD0E3NQUKMktZ0ah6QdXHOfWK1N6s14p94ymCYwUD9dV5DZ9Wa2tZu4Q3jQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=biQedumX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="biQedumX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B5A1F000FF;
	Fri,  9 Oct 2026 05:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525413;
	bh=KoNTDIkuwU2f5JPVoVBtl5pJ6qN+3O4fHNNMrE6PFiY=;
	h=Date:To:From:Subject;
	b=biQedumXwqgeEXTmH5/YYUc3MzL1BEGnu2uhXl5MGoeHx9Arko04Kui+ZyGC+SeU1
	 GQM19msbY5EvyePaPGHx4sX+yzKSPQU2DAyhKhwOjeu6yXKziJPzsLYk9s6I46QdbB
	 97Qxma5PSE+KlYGzzpwSam+pFxSSAAp0OvfE8h4M=
Date: Thu, 08 Oct 2026 22:56:52 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch removed from -mm tree
Message-Id: <20261009055653.17B5A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: group the write-hot fields of struct mem_cgroup
has been removed from the -mm tree.  Its filename was
     memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: group the write-hot fields of struct mem_cgroup
Date: Fri, 4 Sep 2026 20:05:19 -0700

These fields are written on the charge, reclaim and socket paths:

  socket_pressure       written by reclaim, read on every socket charge
  memory_events         bumped for this memcg and every ancestor, so a
                        busy child dirties the whole chain
  memory_events_local
  vmpressure            written on every reclaim iteration
  private_id_ref        written on every swap charge and uncharge
  kmem_stat
  high_irq_work, high_work

They are spread over the struct today and share cache lines with
read-mostly fields.  Put them in one cache line group.

socket_pressure is kept next to memory_events because
mem_cgroup_sk_under_memory_pressure() reads one and bumps the other.

Add memcg_struct_check() so the build fails if a field lands outside
its group.

No functional change.

Link: https://lore.kernel.org/20260905030522.1887837-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 include/linux/memcontrol.h |   58 ++++++++++++++++++++---------------
 mm/memcontrol.c            |   32 +++++++++++++++++++
 2 files changed, 66 insertions(+), 24 deletions(-)

--- a/include/linux/memcontrol.h~memcg-group-the-write-hot-fields-of-struct-mem_cgroup
+++ a/include/linux/memcontrol.h
@@ -185,7 +185,6 @@ struct mem_cgroup {
 
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
 	int private_id;
-	refcount_t private_id_ref;
 
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
@@ -195,14 +194,45 @@ struct mem_cgroup {
 		struct page_counter memsw;	/* v1 only */
 	};
 
+	/* Written on the charge, reclaim and socket paths. */
+	__cacheline_group_begin_aligned(memcg_write_hot);
+	/*
+	 * Hint of reclaim pressure for socket memory management. Note
+	 * that this indicator should NOT be used in legacy cgroup mode
+	 * where socket memory is accounted/charged separately.
+	 */
+	u64			socket_pressure;
+#if BITS_PER_LONG < 64
+	seqlock_t		socket_pressure_seqlock;
+#endif
+	/*
+	 * memory.events is bumped for this memcg and all its ancestors, so a
+	 * busy child dirties every ancestor.
+	 */
+	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
+	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
+
+	/* vmpressure notifications. Written on every reclaim iteration. */
+	struct vmpressure vmpressure;
+
+	/* Written on every swap charge and uncharge. */
+	refcount_t private_id_ref;
+
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	/* MEMCG_KMEM for nmi context */
+	atomic_t		kmem_stat;
+#endif
+
+	/* Range enforcement for interrupt charges */
+	struct work_struct high_work;
+
+	__cacheline_group_end_aligned(memcg_write_hot);
+
 	/* registered local peak watchers */
 	struct list_head memory_peaks;
 	struct list_head swap_peaks;
 	spinlock_t	 peaks_lock;
 
-	/* Range enforcement for interrupt charges */
-	struct work_struct high_work;
-
 #ifdef CONFIG_ZSWAP
 	unsigned long zswap_max;
 
@@ -213,9 +243,6 @@ struct mem_cgroup {
 	bool zswap_writeback;
 #endif
 
-	/* vmpressure notifications */
-	struct vmpressure vmpressure;
-
 	/*
 	 * Should the OOM killer kill all belonging tasks, had it kill one?
 	 */
@@ -231,23 +258,6 @@ struct mem_cgroup {
 	/* memory.stat */
 	struct memcg_vmstats	*vmstats;
 
-	/* memory.events */
-	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
-	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
-
-#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-	/* MEMCG_KMEM for nmi context */
-	atomic_t		kmem_stat;
-#endif
-	/*
-	 * Hint of reclaim pressure for socket memroy management. Note
-	 * that this indicator should NOT be used in legacy cgroup mode
-	 * where socket memory is accounted/charged separately.
-	 */
-	u64			socket_pressure;
-#if BITS_PER_LONG < 64
-	seqlock_t		socket_pressure_seqlock;
-#endif
 	int kmemcg_id;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
--- a/mm/memcontrol.c~memcg-group-the-write-hot-fields-of-struct-mem_cgroup
+++ a/mm/memcontrol.c
@@ -5700,6 +5700,36 @@ __setup("cgroup.memory=", cgroup_memory)
  * basically everything that doesn't depend on a specific mem_cgroup structure
  * should be initialized from here.
  */
+/*
+ * Fields are grouped by access pattern. Putting a field in the wrong group
+ * breaks the build here.
+ */
+static void __init memcg_struct_check(void)
+{
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      socket_pressure);
+#if BITS_PER_LONG < 64
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      socket_pressure_seqlock);
+#endif
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      memory_events);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      memory_events_local);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      vmpressure);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      private_id_ref);
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      kmem_stat);
+#endif
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      high_irq_work);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      high_work);
+}
+
 int __init mem_cgroup_init(void)
 {
 	unsigned int memcg_size;
@@ -5713,6 +5743,8 @@ int __init mem_cgroup_init(void)
 	 */
 	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S32_MAX / PAGE_SIZE);
 
+	memcg_struct_check();
+
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
 				  memcg_hotplug_cpu_dead);
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


