From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:34:46 -0800
Message-ID: <56997406.UNf5sG8em9Gg5IW3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbcAOWer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: account socket memory in unified hierarchy memory controller
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: account socket memory in unified hierarchy memory controller

Socket memory can be a significant share of overall memory consumed by
common workloads.  In order to provide reasonable resource isolation in
the unified hierarchy, this type of memory needs to be included in the
tracking/accounting of a cgroup under active memory resource control.

Overhead is only incurred when a non-root control group is created AND the
memory controller is instructed to track and account the memory footprint
of that group.  cgroup.memory=nosocket can be specified on the boot
commandline to override any runtime configuration and forcibly exclude
socket memory from active memory resource control.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 
 include/linux/memcontrol.h          |    9 +
 mm/memcontrol.c                     |  122 ++++++++++++++++++++------
 3 files changed, 110 insertions(+), 25 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller
+++ a/Documentation/kernel-parameters.txt
@@ -608,6 +608,10 @@ bytes respectively. Such letter suffixes
 			cut the overhead, others just disable the usage. So
 			only cgroup_disable=memory is actually worthy}
 
+	cgroup.memory=	[KNL] Pass options to the cgroup memory controller.
+			Format: <string>
+			nosocket -- Disable socket memory accounting.
+
 	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
 			Format: { "0" | "1" }
 			See security/selinux/Kconfig help text.
diff -puN include/linux/memcontrol.h~mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller
+++ a/include/linux/memcontrol.h
@@ -170,6 +170,9 @@ struct mem_cgroup {
 	unsigned long low;
 	unsigned long high;
 
+	/* Range enforcement for interrupt charges */
+	struct work_struct high_work;
+
 	unsigned long soft_limit;
 
 	/* vmpressure notifications */
@@ -680,12 +683,16 @@ void sock_update_memcg(struct sock *sk);
 void sock_release_memcg(struct sock *sk);
 bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
-#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
+#if defined(CONFIG_MEMCG) && defined(CONFIG_INET)
 extern struct static_key memcg_sockets_enabled_key;
 #define mem_cgroup_sockets_enabled static_key_false(&memcg_sockets_enabled_key)
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
+#ifdef CONFIG_MEMCG_KMEM
 	return memcg->tcp_mem.memory_pressure;
+#else
+	return false;
+#endif
 }
 #else
 #define mem_cgroup_sockets_enabled 0
diff -puN mm/memcontrol.c~mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller
+++ a/mm/memcontrol.c
@@ -80,6 +80,9 @@ struct mem_cgroup *root_mem_cgroup __rea
 
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 
+/* Socket memory accounting disabled? */
+static bool cgroup_memory_nosocket;
+
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
 int do_swap_account __read_mostly;
@@ -1945,6 +1948,26 @@ static int memcg_cpu_hotplug_callback(st
 	return NOTIFY_OK;
 }
 
+static void reclaim_high(struct mem_cgroup *memcg,
+			 unsigned int nr_pages,
+			 gfp_t gfp_mask)
+{
+	do {
+		if (page_counter_read(&memcg->memory) <= memcg->high)
+			continue;
+		mem_cgroup_events(memcg, MEMCG_HIGH, 1);
+		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
+	} while ((memcg = parent_mem_cgroup(memcg)));
+}
+
+static void high_work_func(struct work_struct *work)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = container_of(work, struct mem_cgroup, high_work);
+	reclaim_high(memcg, CHARGE_BATCH, GFP_KERNEL);
+}
+
 /*
  * Scheduled by try_charge() to be executed from the userland return path
  * and reclaims memory over the high limit.
@@ -1952,20 +1975,13 @@ static int memcg_cpu_hotplug_callback(st
 void mem_cgroup_handle_over_high(void)
 {
 	unsigned int nr_pages = current->memcg_nr_pages_over_high;
-	struct mem_cgroup *memcg, *pos;
+	struct mem_cgroup *memcg;
 
 	if (likely(!nr_pages))
 		return;
 
-	pos = memcg = get_mem_cgroup_from_mm(current->mm);
-
-	do {
-		if (page_counter_read(&pos->memory) <= pos->high)
-			continue;
-		mem_cgroup_events(pos, MEMCG_HIGH, 1);
-		try_to_free_mem_cgroup_pages(pos, nr_pages, GFP_KERNEL, true);
-	} while ((pos = parent_mem_cgroup(pos)));
-
+	memcg = get_mem_cgroup_from_mm(current->mm);
+	reclaim_high(memcg, nr_pages, GFP_KERNEL);
 	css_put(&memcg->css);
 	current->memcg_nr_pages_over_high = 0;
 }
@@ -2100,6 +2116,11 @@ done_restock:
 	 */
 	do {
 		if (page_counter_read(&memcg->memory) > memcg->high) {
+			/* Don't bother a random interrupted task */
+			if (in_interrupt()) {
+				schedule_work(&memcg->high_work);
+				break;
+			}
 			current->memcg_nr_pages_over_high += batch;
 			set_notify_resume(current);
 			break;
@@ -4150,6 +4171,8 @@ static void __mem_cgroup_free(struct mem
 {
 	int node;
 
+	cancel_work_sync(&memcg->high_work);
+
 	mem_cgroup_remove_from_trees(memcg);
 
 	for_each_node(node)
@@ -4196,6 +4219,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		page_counter_init(&memcg->kmem, NULL);
 	}
 
+	INIT_WORK(&memcg->high_work, high_work_func);
 	memcg->last_scanned_node = MAX_NUMNODES;
 	INIT_LIST_HEAD(&memcg->oom_notify);
 	memcg->move_charge_at_immigrate = 0;
@@ -4267,6 +4291,11 @@ mem_cgroup_css_online(struct cgroup_subs
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_INET
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
+		static_key_slow_inc(&memcg_sockets_enabled_key);
+#endif
+
 	/*
 	 * Make sure the memcg is initialized: mem_cgroup_iter()
 	 * orders reading memcg->initialized against its callers
@@ -4313,6 +4342,10 @@ static void mem_cgroup_css_free(struct c
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	memcg_destroy_kmem(memcg);
+#ifdef CONFIG_INET
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
+		static_key_slow_dec(&memcg_sockets_enabled_key);
+#endif
 	__mem_cgroup_free(memcg);
 }
 
@@ -5533,8 +5566,7 @@ void mem_cgroup_replace_page(struct page
 	commit_charge(newpage, memcg, true);
 }
 
-/* Writing them here to avoid exposing memcg's inner layout */
-#if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
+#ifdef CONFIG_INET
 
 struct static_key memcg_sockets_enabled_key;
 EXPORT_SYMBOL(memcg_sockets_enabled_key);
@@ -5559,10 +5591,15 @@ void sock_update_memcg(struct sock *sk)
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(current);
-	if (memcg != root_mem_cgroup &&
-	    memcg->tcp_mem.active &&
-	    css_tryget_online(&memcg->css))
+	if (memcg == root_mem_cgroup)
+		goto out;
+#ifdef CONFIG_MEMCG_KMEM
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcp_mem.active)
+		goto out;
+#endif
+	if (css_tryget_online(&memcg->css))
 		sk->sk_memcg = memcg;
+out:
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(sock_update_memcg);
@@ -5583,15 +5620,30 @@ void sock_release_memcg(struct sock *sk)
  */
 bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
-	struct page_counter *counter;
+	gfp_t gfp_mask = GFP_KERNEL;
 
-	if (page_counter_try_charge(&memcg->tcp_mem.memory_allocated,
-				    nr_pages, &counter)) {
-		memcg->tcp_mem.memory_pressure = 0;
-		return true;
+#ifdef CONFIG_MEMCG_KMEM
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		struct page_counter *counter;
+
+		if (page_counter_try_charge(&memcg->tcp_mem.memory_allocated,
+					    nr_pages, &counter)) {
+			memcg->tcp_mem.memory_pressure = 0;
+			return true;
+		}
+		page_counter_charge(&memcg->tcp_mem.memory_allocated, nr_pages);
+		memcg->tcp_mem.memory_pressure = 1;
+		return false;
 	}
-	page_counter_charge(&memcg->tcp_mem.memory_allocated, nr_pages);
-	memcg->tcp_mem.memory_pressure = 1;
+#endif
+	/* Don't block in the packet receive path */
+	if (in_softirq())
+		gfp_mask = GFP_NOWAIT;
+
+	if (try_charge(memcg, gfp_mask, nr_pages) == 0)
+		return true;
+
+	try_charge(memcg, gfp_mask|__GFP_NOFAIL, nr_pages);
 	return false;
 }
 
@@ -5602,10 +5654,32 @@ bool mem_cgroup_charge_skmem(struct mem_
  */
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
-	page_counter_uncharge(&memcg->tcp_mem.memory_allocated, nr_pages);
+#ifdef CONFIG_MEMCG_KMEM
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		page_counter_uncharge(&memcg->tcp_mem.memory_allocated,
+				      nr_pages);
+		return;
+	}
+#endif
+	page_counter_uncharge(&memcg->memory, nr_pages);
+	css_put_many(&memcg->css, nr_pages);
 }
 
-#endif
+#endif /* CONFIG_INET */
+
+static int __init cgroup_memory(char *s)
+{
+	char *token;
+
+	while ((token = strsep(&s, ",")) != NULL) {
+		if (!*token)
+			continue;
+		if (!strcmp(token, "nosocket"))
+			cgroup_memory_nosocket = true;
+	}
+	return 0;
+}
+__setup("cgroup.memory=", cgroup_memory);
 
 /*
  * subsys_initcall() for memory controller.
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch
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
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

