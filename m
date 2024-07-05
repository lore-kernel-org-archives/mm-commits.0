Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BA7D51D
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141620; cv=none; b=FkSaoadiMZPTI/ESF4/BU1vEnNCa/8kA+v16ZjTHPrjUTBp1MTJHi6ELUlSn+rwl2IffhdHkG6e8/PQfuVKvZezYVJYVHmYqeIPRyh9I4D+q+Kp0wEBmlgsJ2ZMnZptRLSWLAYucdzWGdG27HfW4MyITresIL8n0u4n9azO8Jd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141620; c=relaxed/simple;
	bh=erSm5TsKjHLG4MQ06AGMAm2EWqVe26ewvrphJGTTEd4=;
	h=Date:To:From:Subject:Message-Id; b=Y0py4qlc4/TuOUSAAKXmn9SfdDoRABfNI/BE92P5mihE7pExF1oytcfGgK0Fgnc/0YlUpFbABSs0UE4IL5pynKykJJ7VXRaTF6JIJn6YFOpRA/ye/sTj2QjgGCsxRswrXpBkpFtCLTAf7YXMIQVMwuSmOYtUrTa5Y9B17htXjjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JHkr54a6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JHkr54a6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BCAC3277B;
	Fri,  5 Jul 2024 01:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141620;
	bh=erSm5TsKjHLG4MQ06AGMAm2EWqVe26ewvrphJGTTEd4=;
	h=Date:To:From:Subject:From;
	b=JHkr54a6XaiRlgBQMc+glYp2FI/ZrITSl0WU0j0QrMfJeX6ve+xRBebThh14vP9Kj
	 Wj+LBt9JKacBWs9Uar6zW1BdcHrmxhe5T2jNEI+Jd5reRaku5EbG+d7eRo9LWrzCun
	 SMnNmit7j0EpRucxCa1II4BBqDXtf+BFe1thg8cs=
Date: Thu, 04 Jul 2024 18:07:00 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-factor-out-legacy-socket-memory-accounting-code.patch removed from -mm tree
Message-Id: <20240705010700.94BCAC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: factor out legacy socket memory accounting code
has been removed from the -mm tree.  Its filename was
     mm-memcg-factor-out-legacy-socket-memory-accounting-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: factor out legacy socket memory accounting code
Date: Fri, 28 Jun 2024 21:03:10 +0000

Move out the legacy cgroup v1 socket memory accounting code into
mm/memcontrol-v1.c.

This commit introduces three new functions: memcg1_tcpmem_active(),
memcg1_charge_skmem() and memcg1_uncharge_skmem(), which contain all
cgroup v1-specific code and become trivial if CONFIG_MEMCG_V1 isn't set.

Note, that !!memcg->tcpmem_pressure check in
mem_cgroup_under_socket_pressure() can't be easily moved into
memcontrol-v1.h without including memcontrol-v1.h from memcontrol.h which
isn't a good idea, so it's better to just #ifdef it.

Link: https://lkml.kernel.org/r/20240628210317.272856-3-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 ++
 mm/memcontrol-v1.c         |   17 +++++++++++++++++
 mm/memcontrol-v1.h         |   16 ++++++++++++++++
 mm/memcontrol.c            |   22 +++++-----------------
 4 files changed, 40 insertions(+), 17 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-factor-out-legacy-socket-memory-accounting-code
+++ a/include/linux/memcontrol.h
@@ -1650,8 +1650,10 @@ void mem_cgroup_sk_alloc(struct sock *sk
 void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
+#ifdef CONFIG_MEMCG_V1
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return !!memcg->tcpmem_pressure;
+#endif /* CONFIG_MEMCG_V1 */
 	do {
 		if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
 			return true;
--- a/mm/memcontrol.c~mm-memcg-factor-out-legacy-socket-memory-accounting-code
+++ a/mm/memcontrol.c
@@ -3753,7 +3753,7 @@ static void mem_cgroup_css_free(struct c
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
 
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_active)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg1_tcpmem_active(memcg))
 		static_branch_dec(&memcg_sockets_enabled_key);
 
 #if defined(CONFIG_MEMCG_KMEM)
@@ -4979,7 +4979,7 @@ void mem_cgroup_sk_alloc(struct sock *sk
 	memcg = mem_cgroup_from_task(current);
 	if (mem_cgroup_is_root(memcg))
 		goto out;
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcpmem_active)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg1_tcpmem_active(memcg))
 		goto out;
 	if (css_tryget(&memcg->css))
 		sk->sk_memcg = memcg;
@@ -5005,20 +5005,8 @@ void mem_cgroup_sk_free(struct sock *sk)
 bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 			     gfp_t gfp_mask)
 {
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
-		struct page_counter *fail;
-
-		if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
-			memcg->tcpmem_pressure = 0;
-			return true;
-		}
-		memcg->tcpmem_pressure = 1;
-		if (gfp_mask & __GFP_NOFAIL) {
-			page_counter_charge(&memcg->tcpmem, nr_pages);
-			return true;
-		}
-		return false;
-	}
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return memcg1_charge_skmem(memcg, nr_pages, gfp_mask);
 
 	if (try_charge(memcg, gfp_mask, nr_pages) == 0) {
 		mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
@@ -5036,7 +5024,7 @@ bool mem_cgroup_charge_skmem(struct mem_
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
-		page_counter_uncharge(&memcg->tcpmem, nr_pages);
+		memcg1_uncharge_skmem(memcg, nr_pages);
 		return;
 	}
 
--- a/mm/memcontrol-v1.c~mm-memcg-factor-out-legacy-socket-memory-accounting-code
+++ a/mm/memcontrol-v1.c
@@ -2925,6 +2925,23 @@ void memcg1_account_kmem(struct mem_cgro
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
+bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
+			 gfp_t gfp_mask)
+{
+	struct page_counter *fail;
+
+	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
+		memcg->tcpmem_pressure = 0;
+		return true;
+	}
+	memcg->tcpmem_pressure = 1;
+	if (gfp_mask & __GFP_NOFAIL) {
+		page_counter_charge(&memcg->tcpmem, nr_pages);
+		return true;
+	}
+	return false;
+}
+
 static int __init memcg1_init(void)
 {
 	int node;
--- a/mm/memcontrol-v1.h~mm-memcg-factor-out-legacy-socket-memory-accounting-code
+++ a/mm/memcontrol-v1.h
@@ -103,6 +103,17 @@ void memcg1_check_events(struct mem_cgro
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
+static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
+{
+	return memcg->tcpmem_active;
+}
+bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
+			 gfp_t gfp_mask);
+static inline void memcg1_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	page_counter_uncharge(&memcg->tcpmem, nr_pages);
+}
+
 extern struct cftype memsw_files[];
 extern struct cftype mem_cgroup_legacy_files[];
 
@@ -122,6 +133,11 @@ static inline void memcg1_check_events(s
 static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
 
 static inline void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages) {}
+static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg) { return false; }
+static inline bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
+				       gfp_t gfp_mask) { return true; }
+static inline void memcg1_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages) {}
+
 extern struct cftype memsw_files[];
 extern struct cftype mem_cgroup_legacy_files[];
 #endif	/* CONFIG_MEMCG_V1 */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

