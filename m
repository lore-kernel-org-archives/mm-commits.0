Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A551E98EF
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 23:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788651284; cv=none; b=dGWslCiotlOf6LuUXOaANlrGFG705haKZObYLM7asxREYsa3eXzYM9V4l6Ai9fi/PmZGPNrekuzywt1fA4ONjyaaeTWhZ1KUhj2mvuM2focCwLzI71Fk0yo2KeKJYKiXfy6F84hd9VlaipCw03xL6D5/HzMt+h1JuKIoPhuAlX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788651284; c=relaxed/simple;
	bh=kC3ae6CLuK6fjFy9vEvLP698mBcrogjZv/dRs2PeL/Q=;
	h=Date:To:From:Subject:Message-Id; b=iyH3t4+jeLXPLNvPlKJholfxJG1fQq5s0ws96EiHPmOYUsqLrDVLpUjtz9E+tYrIoiHLpcYT/PuyhBeba74XBWZglFNziLs62OMAIsDM4d1fnr0grFXu2bWnFAQ6ZYxgzNrM27pMdZVXPLgEKeCbHacK30LrKBNIXbdEbfwlN+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W7a3+cSD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W7a3+cSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1FF1F00A3A;
	Sat,  5 Sep 2026 23:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788651282;
	bh=waTxK5lhO5rODyj0swth9dLiQKmz7XkhlRfK/dvsakE=;
	h=Date:To:From:Subject;
	b=W7a3+cSDfiKr8DU1Ex6Huz6/37ENwyFd0i5Z+ljbfvypbioxIRB8Se7ZwhGJlB14u
	 TqteOkqFZ646nA4Osmr/r8IIErQgAFt45K0w+HB3YiZkHkFG/teJcgwKEmiKfErx52
	 gO2zMf3F5Lnp/I4Km+7tiueM5MwsV2Cp8XthBzoM=
Date: Sat, 05 Sep 2026 16:34:42 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch added to mm-new branch
Message-Id: <20260905233442.8C1FF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: group the write-hot fields of struct mem_cgroup
has been added to the -mm mm-new branch.  Its filename is
     memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
memcg-remove-v1-soft-limit-reclaim.patch
memcg-remove-mem_cgroup_shrink_node.patch
memcg-remove-the-soft-limit-reclaim-tracepoints.patch
memcg-remove-the-soft-limit-rbtree.patch
memcg-remove-lru_gen_soft_reclaim.patch
memcg-remove-the-per-node-soft-limit-tree-fields.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch
memcg-move-per-node-objcg-to-the-read-mostly-fields.patch
memcg-split-mem_cgroup_private_id-into-two-fields.patch
memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch
memcg-group-the-cold-fields-of-struct-mem_cgroup.patch
memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch
memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

