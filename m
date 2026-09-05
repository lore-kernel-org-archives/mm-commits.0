Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A181E98EF
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 23:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788651289; cv=none; b=ppdmocV7r9YfvsYx/UEGJsahlcvFOLdcvpGeIVB3P9xqFRiFP0O0X9zLhteLXSMm4990AOS3WqA4KUi5SQnea6RMWuABxMX3UWyqYlozPFW99t3lyEJF1Xh4BuZ0ljZ6srSs66zmGkJF2Cpgwc4qXFDhTYkIXIUO+Wdzk9ID8Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788651289; c=relaxed/simple;
	bh=xDaH8LgkuCh7/jOqqeYP1QUF1hNowZwRkpuKLHp5hK8=;
	h=Date:To:From:Subject:Message-Id; b=uaQDs8Ko7cFQAaDlje6RmMnKO/v/S5RB3DGG4ahxgwmjpRelPGi07EAY2rLPeGktdXlNLbJ8Z20drjTyCKIArGUVv73ZwxSmqN/JjpYlr+5GNo31d9EcojuAvCmHSu7YGwMoyFL9wHJQd0die1ZoVD3EkGEmth7Mltro18r2wEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dSwJPLJV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dSwJPLJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFBC1F00A3A;
	Sat,  5 Sep 2026 23:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788651287;
	bh=wKBct2EOuFV47P7MCriXwno1VTRj8PV90rnGqfuVsNA=;
	h=Date:To:From:Subject;
	b=dSwJPLJVumQ4tgM+J/dRfjHnreGcOfQhydPsiJaDH6BpywMrVCzXPG2ie2qz6aako
	 +nu9c8wOpk0o+6uMK277Tn13+AtQ8SgO4CUYozdSBVbdbuzF1bgBEv7iVhNakSKSrX
	 4q784I5Zy0Gsxxi0hTVnWEjH81jePTdIvNNGjnlI=
Date: Sat, 05 Sep 2026 16:34:47 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch added to mm-new branch
Message-Id: <20260905233447.7FFBC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: group the read-mostly fields of struct mem_cgroup
has been added to the -mm mm-new branch.  Its filename is
     memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch

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
Subject: memcg: group the read-mostly fields of struct mem_cgroup
Date: Fri, 4 Sep 2026 20:05:21 -0700

These fields are set when the memcg is created and only read after
that:

  vmstats_percpu   read on every stat update
  vmstats
  zswap_max, zswap_writeback
  private_id       read on every eviction and refault
  kmemcg_id        read on every list_lru lookup
  oom_group

Put them in one cache line group at the end of the struct, right before
nodeinfo[].  nodeinfo[] is read-mostly too but it is a flexible array, so
it cannot sit inside a group.  The group ends without padding so the two
share a line.

This also drops the ____cacheline_aligned_in_smp on vmstats_percpu added
by commit c1afbd5de131 ("mm/memcontrol: avoid false sharing between
vmstats and events").  That only aligned the start of the field. 
cgwb_domain followed it on the same line and is written on every writeout
completion.  A group boundary covers both sides.

No functional change.

Link: https://lore.kernel.org/20260905030522.1887837-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   62 +++++++++++++++++++----------------
 mm/memcontrol.c            |   17 +++++++++
 2 files changed, 52 insertions(+), 27 deletions(-)

--- a/include/linux/memcontrol.h~memcg-group-the-read-mostly-fields-of-struct-mem_cgroup
+++ a/include/linux/memcontrol.h
@@ -183,9 +183,6 @@ struct obj_cgroup {
 struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
-	/* Private memcg ID. Used to ID objects that outlive the cgroup */
-	int private_id;
-
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
 
@@ -259,30 +256,6 @@ struct mem_cgroup {
 #endif
 	__cacheline_group_end_aligned(memcg_cold);
 
-#ifdef CONFIG_ZSWAP
-	unsigned long zswap_max;
-
-	/*
-	 * Prevent pages from this memcg from being written back from zswap to
-	 * swap, and from being swapped out on zswap store failures.
-	 */
-	bool zswap_writeback;
-#endif
-
-	/*
-	 * Should the OOM killer kill all belonging tasks, had it kill one?
-	 */
-	bool oom_group;
-
-	/* memory.stat */
-	struct memcg_vmstats	*vmstats;
-
-	int kmemcg_id;
-
-	/* Keep the hot per-CPU stats pointer away from memory event counters. */
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu
-		____cacheline_aligned_in_smp;
-
 #ifdef CONFIG_MEMCG_V1
 	/* v1 only. Not grouped: v1 is legacy, sorting it is not worth it. */
 
@@ -322,6 +295,41 @@ struct mem_cgroup {
 	int swappiness;
 #endif /* CONFIG_MEMCG_V1 */
 
+	/*
+	 * Set when the memcg is created and cleared when it is offlined.
+	 * Never written on a hot path.
+	 */
+	__cacheline_group_begin_aligned(memcg_read_mostly);
+	/* Read on every stat update */
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
+
+	/* memory.stat */
+	struct memcg_vmstats	*vmstats;
+
+#ifdef CONFIG_ZSWAP
+	unsigned long zswap_max;
+#endif
+
+	/* Private memcg ID. Used to ID objects that outlive the cgroup */
+	int private_id;
+
+	int kmemcg_id;
+
+	/*
+	 * Should the OOM killer kill all belonging tasks, had it kill one?
+	 */
+	bool oom_group;
+
+#ifdef CONFIG_ZSWAP
+	/*
+	 * Prevent pages from this memcg from being written back from zswap to
+	 * swap, and from being swapped out on zswap store failures.
+	 */
+	bool zswap_writeback;
+#endif
+	/* Not padded: nodeinfo[] is read-mostly too, let it share the line. */
+	__cacheline_group_end(memcg_read_mostly);
+
 	struct mem_cgroup_per_node *nodeinfo[];
 };
 
--- a/mm/memcontrol.c~memcg-group-the-read-mostly-fields-of-struct-mem_cgroup
+++ a/mm/memcontrol.c
@@ -5753,6 +5753,23 @@ static void __init memcg_struct_check(vo
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
 				      mm_list);
 #endif
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      vmstats_percpu);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      vmstats);
+#ifdef CONFIG_ZSWAP
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      zswap_max);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      zswap_writeback);
+#endif
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      private_id);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      kmemcg_id);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      oom_group);
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

