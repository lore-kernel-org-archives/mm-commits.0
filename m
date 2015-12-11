From: akpm@linux-foundation.org
Subject: + mm-memcontrol-flatten-struct-cg_proto.patch added to -mm tree
Date: Fri, 11 Dec 2015 15:52:42 -0800
Message-ID: <566b61ca.1H9joyo8GNjCPzn8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbLKXwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Dec 2015 18:52:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: flatten struct cg_proto
has been added to the -mm tree.  Its filename is
     mm-memcontrol-flatten-struct-cg_proto.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-flatten-struct-cg_proto.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-flatten-struct-cg_proto.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: flatten struct cg_proto

There are no more external users of struct cg_proto, flatten the
structure into struct mem_cgroup.

Since using those struct members doesn't stand out as much anymore,
add cgroup2 static branches to make it clearer which code is legacy.

Suggested-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

index 47995b4..a3869bf 100644
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
@@ -2822,7 +2822,7 @@ static u64 mem_cgroup_read_u64(struct cg
 		counter = &memcg->kmem;
 		break;
 	case _TCP:
-		counter = &memcg->tcp_mem.memory_allocated;
+		counter = &memcg->tcpmem;
 		break;
 	default:
 		BUG();
@@ -3007,11 +3007,11 @@ static int memcg_update_tcp_limit(struct
 
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
@@ -3029,7 +3029,7 @@ static int memcg_update_tcp_limit(struct
 		 * patched in yet.
 		 */
 		static_branch_inc(&memcg_sockets_enabled_key);
-		memcg->tcp_mem.active = true;
+		memcg->tcpmem_active = true;
 	}
 out:
 	mutex_unlock(&memcg_limit_mutex);
@@ -3098,7 +3098,7 @@ static ssize_t mem_cgroup_reset(struct k
 		counter = &memcg->kmem;
 		break;
 	case _TCP:
-		counter = &memcg->tcp_mem.memory_allocated;
+		counter = &memcg->tcpmem;
 		break;
 	default:
 		BUG();
@@ -4273,8 +4273,7 @@ mem_cgroup_css_online(struct cgroup_subs
 		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, &parent->memsw);
 		page_counter_init(&memcg->kmem, &parent->kmem);
-		page_counter_init(&memcg->tcp_mem.memory_allocated,
-				  &parent->tcp_mem.memory_allocated);
+		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
 
 		/*
 		 * No need to take a reference to the parent because cgroup
@@ -4286,7 +4285,7 @@ mem_cgroup_css_online(struct cgroup_subs
 		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
-		page_counter_init(&memcg->tcp_mem.memory_allocated, NULL);
+		page_counter_init(&memcg->tcpmem, NULL);
 		/*
 		 * Deeper hierachy with use_hierarchy == false doesn't make
 		 * much sense so let cgroup subsystem know about this
@@ -4345,7 +4344,7 @@ static void mem_cgroup_css_free(struct c
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
 
-	if (memcg->tcp_mem.active)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_active)
 		static_branch_dec(&memcg_sockets_enabled_key);
 
 	memcg_free_kmem(memcg);
@@ -5572,7 +5571,7 @@ void sock_update_memcg(struct sock *sk)
 	memcg = mem_cgroup_from_task(current);
 	if (memcg == root_mem_cgroup)
 		goto out;
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcp_mem.active)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcpmem_active)
 		goto out;
 	if (css_tryget_online(&memcg->css))
 		sk->sk_memcg = memcg;
@@ -5600,15 +5599,14 @@ bool mem_cgroup_charge_skmem(struct mem_
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
 
@@ -5631,8 +5629,7 @@ bool mem_cgroup_charge_skmem(struct mem_
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

maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-memcontrol-export-root_mem_cgroup.patch
net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch
net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix.patch
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch

