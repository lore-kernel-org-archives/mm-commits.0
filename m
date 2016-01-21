From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-flatten-struct-cg_proto.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:29:46 -0800
Message-ID: <56a169ea.c7YhR3t78JFtKFvI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbcAUX3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: flatten struct cg_proto
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-flatten-struct-cg_proto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: flatten struct cg_proto

There are no more external users of struct cg_proto, flatten the
structure into struct mem_cgroup.

Since using those struct members doesn't stand out as much anymore,
add cgroup2 static branches to make it clearer which code is legacy.

Suggested-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 ++++++--------
 mm/memcontrol.c            |   33 +++++++++++++++------------------
 2 files changed, 21 insertions(+), 26 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-flatten-struct-cg_proto include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-flatten-struct-cg_proto
+++ a/include/linux/memcontrol.h
@@ -85,12 +85,6 @@ enum mem_cgroup_events_target {
 	MEM_CGROUP_NTARGETS,
 };
 
-struct cg_proto {
-	struct page_counter	memory_allocated;	/* Current allocated memory. */
-	int			memory_pressure;
-	bool			active;
-};
-
 #ifdef CONFIG_MEMCG
 struct mem_cgroup_stat_cpu {
 	long count[MEM_CGROUP_STAT_NSTATS];
@@ -169,8 +163,11 @@ struct mem_cgroup {
 
 	/* Accounted resources */
 	struct page_counter memory;
+
+	/* Legacy consumer-oriented counters */
 	struct page_counter memsw;
 	struct page_counter kmem;
+	struct page_counter tcpmem;
 
 	/* Normal memory consumption range */
 	unsigned long low;
@@ -236,7 +233,8 @@ struct mem_cgroup {
 	unsigned long		socket_pressure;
 
 	/* Legacy tcp memory accounting */
-	struct cg_proto tcp_mem;
+	bool			tcpmem_active;
+	int			tcpmem_pressure;
 
 #ifndef CONFIG_SLOB
         /* Index in the kmem_cache->memcg_params.memcg_caches array */
@@ -715,7 +713,7 @@ extern struct static_key_false memcg_soc
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
-	if (memcg->tcp_mem.memory_pressure)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
 		return true;
 	do {
 		if (time_before(jiffies, memcg->socket_pressure))
diff -puN mm/memcontrol.c~mm-memcontrol-flatten-struct-cg_proto mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-flatten-struct-cg_proto
+++ a/mm/memcontrol.c
@@ -2843,7 +2843,7 @@ static u64 mem_cgroup_read_u64(struct cg
 		counter = &memcg->kmem;
 		break;
 	case _TCP:
-		counter = &memcg->tcp_mem.memory_allocated;
+		counter = &memcg->tcpmem;
 		break;
 	default:
 		BUG();
@@ -3028,11 +3028,11 @@ static int memcg_update_tcp_limit(struct
 
 	mutex_lock(&memcg_limit_mutex);
 
-	ret = page_counter_limit(&memcg->tcp_mem.memory_allocated, limit);
+	ret = page_counter_limit(&memcg->tcpmem, limit);
 	if (ret)
 		goto out;
 
-	if (!memcg->tcp_mem.active) {
+	if (!memcg->tcpmem_active) {
 		/*
 		 * The active flag needs to be written after the static_key
 		 * update. This is what guarantees that the socket activation
@@ -3050,7 +3050,7 @@ static int memcg_update_tcp_limit(struct
 		 * patched in yet.
 		 */
 		static_branch_inc(&memcg_sockets_enabled_key);
-		memcg->tcp_mem.active = true;
+		memcg->tcpmem_active = true;
 	}
 out:
 	mutex_unlock(&memcg_limit_mutex);
@@ -3119,7 +3119,7 @@ static ssize_t mem_cgroup_reset(struct k
 		counter = &memcg->kmem;
 		break;
 	case _TCP:
-		counter = &memcg->tcp_mem.memory_allocated;
+		counter = &memcg->tcpmem;
 		break;
 	default:
 		BUG();
@@ -4295,8 +4295,7 @@ mem_cgroup_css_online(struct cgroup_subs
 		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, &parent->memsw);
 		page_counter_init(&memcg->kmem, &parent->kmem);
-		page_counter_init(&memcg->tcp_mem.memory_allocated,
-				  &parent->tcp_mem.memory_allocated);
+		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
 
 		/*
 		 * No need to take a reference to the parent because cgroup
@@ -4308,7 +4307,7 @@ mem_cgroup_css_online(struct cgroup_subs
 		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
-		page_counter_init(&memcg->tcp_mem.memory_allocated, NULL);
+		page_counter_init(&memcg->tcpmem, NULL);
 		/*
 		 * Deeper hierachy with use_hierarchy == false doesn't make
 		 * much sense so let cgroup subsystem know about this
@@ -4374,7 +4373,7 @@ static void mem_cgroup_css_free(struct c
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
 
-	if (memcg->tcp_mem.active)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_active)
 		static_branch_dec(&memcg_sockets_enabled_key);
 
 	memcg_free_kmem(memcg);
@@ -5601,7 +5600,7 @@ void sock_update_memcg(struct sock *sk)
 	memcg = mem_cgroup_from_task(current);
 	if (memcg == root_mem_cgroup)
 		goto out;
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcp_mem.active)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcpmem_active)
 		goto out;
 	if (css_tryget_online(&memcg->css))
 		sk->sk_memcg = memcg;
@@ -5629,15 +5628,14 @@ bool mem_cgroup_charge_skmem(struct mem_
 	gfp_t gfp_mask = GFP_KERNEL;
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
-		struct page_counter *counter;
+		struct page_counter *fail;
 
-		if (page_counter_try_charge(&memcg->tcp_mem.memory_allocated,
-					    nr_pages, &counter)) {
-			memcg->tcp_mem.memory_pressure = 0;
+		if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
+			memcg->tcpmem_pressure = 0;
 			return true;
 		}
-		page_counter_charge(&memcg->tcp_mem.memory_allocated, nr_pages);
-		memcg->tcp_mem.memory_pressure = 1;
+		page_counter_charge(&memcg->tcpmem, nr_pages);
+		memcg->tcpmem_pressure = 1;
 		return false;
 	}
 
@@ -5660,8 +5658,7 @@ bool mem_cgroup_charge_skmem(struct mem_
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
-		page_counter_uncharge(&memcg->tcp_mem.memory_allocated,
-				      nr_pages);
+		page_counter_uncharge(&memcg->tcpmem, nr_pages);
 		return;
 	}
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

