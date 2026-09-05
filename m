Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699091E98EF
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 23:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788651286; cv=none; b=ptOA2UUd92Nf7xUsF1R/L6voXcZuwYoamz5Yo9UUUP6WkEho6t3cJ3p5IjnpYrlykoWoJrlXMw+cgQI1fumXaMp7FigOphnUs7qK7MfotnmipwiH27ZOWqDpT7juvXfWgAvIPjtdHnlu79utEggW5hPaARA2UbXLOTAxOTnrQeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788651286; c=relaxed/simple;
	bh=9kXqweTCNCkIFGj0cSMs61SHqbUCaOaYXCRX0T7WL0U=;
	h=Date:To:From:Subject:Message-Id; b=XBAjMGi6+FVbjnElBr3jKIpFrnQjTqVjcJzihuahZRhdy3zpvdFvfYJd12Lcg6ZprKphvPWfhjgoGOwnGJc90JaLpfUr2VAfdqQT1kgwfNmcQfCk7qYEt8bQRXNC1P/VvpmSNznxW5NchAcTg7SkHqtk1YqLJ8DuLPP6FllGfxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uMD1eRxh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uMD1eRxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0630D1F00A3A;
	Sat,  5 Sep 2026 23:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788651285;
	bh=DI54Wr/kSVjx8fEs0vJhLf06QIG8UWPCWqlR5xzoLjk=;
	h=Date:To:From:Subject;
	b=uMD1eRxhP3bRbrQyuAWoKJDQkHBP3G9rV9z8h7GOZHk8Y1/kKOo9cOtUfNQAm+RZc
	 BtDw5JhM4qHGBsFNMbapnmLp/jSO5mtTnwpuZP55DJ/Zzd/MiFcy7xsUXED+413iEi
	 8LtUES3+0veHjEvN7M8UCRsSu0jUc1Ldz91g4j+I=
Date: Sat, 05 Sep 2026 16:34:44 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-group-the-cold-fields-of-struct-mem_cgroup.patch added to mm-new branch
Message-Id: <20260905233445.0630D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: group the cold fields of struct mem_cgroup
has been added to the -mm mm-new branch.  Its filename is
     memcg-group-the-cold-fields-of-struct-mem_cgroup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-group-the-cold-fields-of-struct-mem_cgroup.patch

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

