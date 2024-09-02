Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603872D057
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247855; cv=none; b=hOji2Zi3vR22LEJAUo2+Zr0EPp5StlL1cFjT1hMAU47rkxg+wuBx1upYz63tr5tdJI3PCW9ycdEPhaVVWdV5FgtA4/9DD0PYfBUDRf5pHgj8a04f8q5kwem+m+PPafaTJBqCLiV1r1uI01D9ZPmZ09qfrHhxmVYLv0PfeuIikQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247855; c=relaxed/simple;
	bh=SZFXh4xEmQjn3IZdn+fb8VVHIpQi2uz0DwOSbj1yfP8=;
	h=Date:To:From:Subject:Message-Id; b=X4W7OMEOyuTu8oZcoE1rns8AA0KhFc2uYKSCE8kQcyGLfELVKoSnYfqy2HZAgKT2+IgwF46Zha5h78z7cjjVFQURhc91XpmcbsUh9rztlzo2a6Vts5n7j0wAI589MrEIEVoDzlCYg3uRzIL2wol2z/gc4rnTq5NlO7XYvzqS7yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=No3qcck0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="No3qcck0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6D6C4CEC2;
	Mon,  2 Sep 2024 03:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247855;
	bh=SZFXh4xEmQjn3IZdn+fb8VVHIpQi2uz0DwOSbj1yfP8=;
	h=Date:To:From:Subject:From;
	b=No3qcck0gBPv0tR5ZjnlG9VJtUPK5IuPSD7ne/GGQSCVDuJvfWk9TbQ6xCBgXHB1y
	 1TKZ+JOBMLBdwk/EtDoRtR7r7rk9BO9oMHNaMNuGSNTvUvYCm0Xg0uATW52ipqwmAR
	 wp4DerhZwRqMLjPKPA0Z/G6GX84U/p0JWF3jR73E=
Date: Sun, 01 Sep 2024 20:30:54 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch removed from -mm tree
Message-Id: <20240902033055.2B6D6C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: allocate v1 event percpu only on v1 deployment
has been removed from the -mm tree.  Its filename was
     memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: allocate v1 event percpu only on v1 deployment
Date: Wed, 14 Aug 2024 22:04:52 -0700

Currently memcg->events_percpu gets allocated on v2 deployments.  Let's
move the allocation to v1 only codebase.  This is not needed in v2.

Link: https://lkml.kernel.org/r/20240815050453.1298138-7-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 ++-
 mm/memcontrol-v1.c         |   19 +++++++++++++++++++
 mm/memcontrol-v1.h         |   26 +++++++-------------------
 3 files changed, 28 insertions(+), 20 deletions(-)

--- a/include/linux/memcontrol.h~memcg-allocate-v1-event-percpu-only-on-v1-deployment
+++ a/include/linux/memcontrol.h
@@ -255,7 +255,6 @@ struct mem_cgroup {
 	struct list_head objcg_list;
 
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
-	struct memcg1_events_percpu __percpu *events_percpu;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
@@ -277,6 +276,8 @@ struct mem_cgroup {
 	struct page_counter kmem;		/* v1 only */
 	struct page_counter tcpmem;		/* v1 only */
 
+	struct memcg1_events_percpu __percpu *events_percpu;
+
 	unsigned long soft_limit;
 
 	/* protected by memcg_oom_lock */
--- a/mm/memcontrol-v1.c~memcg-allocate-v1-event-percpu-only-on-v1-deployment
+++ a/mm/memcontrol-v1.c
@@ -1442,6 +1442,12 @@ static void mem_cgroup_threshold(struct
 	}
 }
 
+/* Cgroup1: threshold notifications & softlimit tree updates */
+struct memcg1_events_percpu {
+	unsigned long nr_page_events;
+	unsigned long targets[MEM_CGROUP_NTARGETS];
+};
+
 static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
 {
 	/* pagein of a big page is an event. So, ignore page size */
@@ -3033,6 +3039,19 @@ bool memcg1_charge_skmem(struct mem_cgro
 	return false;
 }
 
+bool memcg1_alloc_events(struct mem_cgroup *memcg)
+{
+	memcg->events_percpu = alloc_percpu_gfp(struct memcg1_events_percpu,
+						GFP_KERNEL_ACCOUNT);
+	return !!memcg->events_percpu;
+}
+
+void memcg1_free_events(struct mem_cgroup *memcg)
+{
+	if (memcg->events_percpu)
+		free_percpu(memcg->events_percpu);
+}
+
 static int __init memcg1_init(void)
 {
 	int node;
--- a/mm/memcontrol-v1.h~memcg-allocate-v1-event-percpu-only-on-v1-deployment
+++ a/mm/memcontrol-v1.h
@@ -55,12 +55,6 @@ enum mem_cgroup_events_target {
 	MEM_CGROUP_NTARGETS,
 };
 
-/* Cgroup1: threshold notifications & softlimit tree updates */
-struct memcg1_events_percpu {
-	unsigned long nr_page_events;
-	unsigned long targets[MEM_CGROUP_NTARGETS];
-};
-
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 
 void drain_all_stock(struct mem_cgroup *root_memcg);
@@ -72,21 +66,12 @@ unsigned long memcg_page_state_output(st
 unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
-static inline bool memcg1_alloc_events(struct mem_cgroup *memcg)
-{
-	memcg->events_percpu = alloc_percpu_gfp(struct memcg1_events_percpu,
-						GFP_KERNEL_ACCOUNT);
-	return !!memcg->events_percpu;
-}
-
-static inline void memcg1_free_events(struct mem_cgroup *memcg)
-{
-	if (memcg->events_percpu)
-		free_percpu(memcg->events_percpu);
-}
-
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
+
+bool memcg1_alloc_events(struct mem_cgroup *memcg);
+void memcg1_free_events(struct mem_cgroup *memcg);
+
 void memcg1_memcg_init(struct mem_cgroup *memcg);
 void memcg1_remove_from_trees(struct mem_cgroup *memcg);
 
@@ -139,6 +124,9 @@ extern struct cftype mem_cgroup_legacy_f
 
 #else	/* CONFIG_MEMCG_V1 */
 
+static inline bool memcg1_alloc_events(struct mem_cgroup *memcg) { return true; }
+static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
+
 static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
 static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


