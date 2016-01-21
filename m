From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-reign-in-the-config-space-madness.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 15:29:44 -0800
Message-ID: <56a169e8.96BSPJNEA50Po0Nk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbcAUX3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rein in the CONFIG space madness
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-reign-in-the-config-space-madness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: rein in the CONFIG space madness

What CONFIG_INET and CONFIG_LEGACY_KMEM guard inside the memory
controller code is insignificant, having these conditionals is not
worth the complication and fragility that comes with them.

[akpm@linux-foundation.org: rework mem_cgroup_css_free() statement ordering]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 +++------
 init/Kconfig               |   21 +------------
 mm/memcontrol.c            |   53 ++---------------------------------
 mm/vmpressure.c            |    2 -
 4 files changed, 12 insertions(+), 78 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-reign-in-the-config-space-madness include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-reign-in-the-config-space-madness
+++ a/include/linux/memcontrol.h
@@ -233,9 +233,11 @@ struct mem_cgroup {
 	 */
 	struct mem_cgroup_stat_cpu __percpu *stat;
 
-#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
+	unsigned long		socket_pressure;
+
+	/* Legacy tcp memory accounting */
 	struct cg_proto tcp_mem;
-#endif
+
 #ifndef CONFIG_SLOB
         /* Index in the kmem_cache->memcg_params.memcg_caches array */
 	int kmemcg_id;
@@ -254,10 +256,6 @@ struct mem_cgroup {
 	struct wb_domain cgwb_domain;
 #endif
 
-#ifdef CONFIG_INET
-	unsigned long		socket_pressure;
-#endif
-
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
@@ -712,15 +710,13 @@ void sock_update_memcg(struct sock *sk);
 void sock_release_memcg(struct sock *sk);
 bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
-#if defined(CONFIG_MEMCG) && defined(CONFIG_INET)
+#ifdef CONFIG_MEMCG
 extern struct static_key_false memcg_sockets_enabled_key;
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
-#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	if (memcg->tcp_mem.memory_pressure)
 		return true;
-#endif
 	do {
 		if (time_before(jiffies, memcg->socket_pressure))
 			return true;
diff -puN init/Kconfig~mm-memcontrol-reign-in-the-config-space-madness init/Kconfig
--- a/init/Kconfig~mm-memcontrol-reign-in-the-config-space-madness
+++ a/init/Kconfig
@@ -964,20 +964,6 @@ config MEMCG_SWAP_ENABLED
 	  For those who want to have the feature enabled by default should
 	  select this option (if, for some reason, they need to disable it
 	  then swapaccount=0 does the trick).
-config MEMCG_LEGACY_KMEM
-       bool
-config MEMCG_KMEM
-	bool "Legacy Memory Resource Controller Kernel Memory accounting"
-	depends on MEMCG
-	depends on SLUB || SLAB
-	select MEMCG_LEGACY_KMEM
-	help
-	  The Kernel Memory extension for Memory Resource Controller can limit
-	  the amount of memory used by kernel objects in the system. Those are
-	  fundamentally different from the entities handled by the standard
-	  Memory Controller, which are page-based, and can be swapped. Users of
-	  the kmem extension can use it to guarantee that no group of processes
-	  will ever exhaust kernel resources alone.
 
 config BLK_CGROUP
 	bool "IO controller"
@@ -1190,10 +1176,9 @@ config USER_NS
 	  to provide different user info for different servers.
 
 	  When user namespaces are enabled in the kernel it is
-	  recommended that the MEMCG and MEMCG_KMEM options also be
-	  enabled and that user-space use the memory control groups to
-	  limit the amount of memory a memory unprivileged users can
-	  use.
+	  recommended that the MEMCG option also be enabled and that
+	  user-space use the memory control groups to limit the amount
+	  of memory a memory unprivileged users can use.
 
 	  If unsure, say N.
 
diff -puN mm/memcontrol.c~mm-memcontrol-reign-in-the-config-space-madness mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-reign-in-the-config-space-madness
+++ a/mm/memcontrol.c
@@ -2842,11 +2842,9 @@ static u64 mem_cgroup_read_u64(struct cg
 	case _KMEM:
 		counter = &memcg->kmem;
 		break;
-#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
 	case _TCP:
 		counter = &memcg->tcp_mem.memory_allocated;
 		break;
-#endif
 	default:
 		BUG();
 	}
@@ -3006,7 +3004,6 @@ static void memcg_free_kmem(struct mem_c
 }
 #endif /* !CONFIG_SLOB */
 
-#ifdef CONFIG_MEMCG_LEGACY_KMEM
 static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
 				   unsigned long limit)
 {
@@ -3024,16 +3021,7 @@ out:
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
-#else
-static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
-				   unsigned long limit)
-{
-	return -EINVAL;
-}
-#endif /* CONFIG_MEMCG_LEGACY_KMEM */
 
-
-#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
 static int memcg_update_tcp_limit(struct mem_cgroup *memcg, unsigned long limit)
 {
 	int ret;
@@ -3068,12 +3056,6 @@ out:
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
-#else
-static int memcg_update_tcp_limit(struct mem_cgroup *memcg, unsigned long limit)
-{
-	return -EINVAL;
-}
-#endif /* CONFIG_MEMCG_LEGACY_KMEM && CONFIG_INET */
 
 /*
  * The user of this function is...
@@ -3136,11 +3118,9 @@ static ssize_t mem_cgroup_reset(struct k
 	case _KMEM:
 		counter = &memcg->kmem;
 		break;
-#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
 	case _TCP:
 		counter = &memcg->tcp_mem.memory_allocated;
 		break;
-#endif
 	default:
 		BUG();
 	}
@@ -4094,7 +4074,6 @@ static struct cftype mem_cgroup_legacy_f
 		.seq_show = memcg_numa_stat_show,
 	},
 #endif
-#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	{
 		.name = "kmem.limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
@@ -4127,7 +4106,6 @@ static struct cftype mem_cgroup_legacy_f
 		.seq_show = memcg_slab_show,
 	},
 #endif
-#ifdef CONFIG_INET
 	{
 		.name = "kmem.tcp.limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_TCP, RES_LIMIT),
@@ -4151,8 +4129,6 @@ static struct cftype mem_cgroup_legacy_f
 		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
-#endif
-#endif
 	{ },	/* terminate */
 };
 
@@ -4280,15 +4256,13 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->event_list);
 	spin_lock_init(&memcg->event_list_lock);
+	memcg->socket_pressure = jiffies;
 #ifndef CONFIG_SLOB
 	memcg->kmemcg_id = -1;
 #endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 #endif
-#ifdef CONFIG_INET
-	memcg->socket_pressure = jiffies;
-#endif
 	return &memcg->css;
 
 free_out:
@@ -4321,10 +4295,8 @@ mem_cgroup_css_online(struct cgroup_subs
 		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, &parent->memsw);
 		page_counter_init(&memcg->kmem, &parent->kmem);
-#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
 		page_counter_init(&memcg->tcp_mem.memory_allocated,
 				  &parent->tcp_mem.memory_allocated);
-#endif
 
 		/*
 		 * No need to take a reference to the parent because cgroup
@@ -4336,9 +4308,7 @@ mem_cgroup_css_online(struct cgroup_subs
 		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
-#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
 		page_counter_init(&memcg->tcp_mem.memory_allocated, NULL);
-#endif
 		/*
 		 * Deeper hierachy with use_hierarchy == false doesn't make
 		 * much sense so let cgroup subsystem know about this
@@ -4353,10 +4323,8 @@ mem_cgroup_css_online(struct cgroup_subs
 	if (ret)
 		return ret;
 
-#ifdef CONFIG_INET
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_inc(&memcg_sockets_enabled_key);
-#endif
 
 	/*
 	 * Make sure the memcg is initialized: mem_cgroup_iter()
@@ -4403,18 +4371,13 @@ static void mem_cgroup_css_free(struct c
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-#ifdef CONFIG_INET
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
-#endif
-
-	memcg_free_kmem(memcg);
 
-#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
 	if (memcg->tcp_mem.active)
 		static_branch_dec(&memcg_sockets_enabled_key);
-#endif
 
+	memcg_free_kmem(memcg);
 	__mem_cgroup_free(memcg);
 }
 
@@ -5613,8 +5576,6 @@ void mem_cgroup_replace_page(struct page
 	commit_charge(newpage, memcg, true);
 }
 
-#ifdef CONFIG_INET
-
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
 EXPORT_SYMBOL(memcg_sockets_enabled_key);
 
@@ -5640,10 +5601,8 @@ void sock_update_memcg(struct sock *sk)
 	memcg = mem_cgroup_from_task(current);
 	if (memcg == root_mem_cgroup)
 		goto out;
-#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcp_mem.active)
 		goto out;
-#endif
 	if (css_tryget_online(&memcg->css))
 		sk->sk_memcg = memcg;
 out:
@@ -5669,7 +5628,6 @@ bool mem_cgroup_charge_skmem(struct mem_
 {
 	gfp_t gfp_mask = GFP_KERNEL;
 
-#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		struct page_counter *counter;
 
@@ -5682,7 +5640,7 @@ bool mem_cgroup_charge_skmem(struct mem_
 		memcg->tcp_mem.memory_pressure = 1;
 		return false;
 	}
-#endif
+
 	/* Don't block in the packet receive path */
 	if (in_softirq())
 		gfp_mask = GFP_NOWAIT;
@@ -5701,19 +5659,16 @@ bool mem_cgroup_charge_skmem(struct mem_
  */
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
-#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		page_counter_uncharge(&memcg->tcp_mem.memory_allocated,
 				      nr_pages);
 		return;
 	}
-#endif
+
 	page_counter_uncharge(&memcg->memory, nr_pages);
 	css_put_many(&memcg->css, nr_pages);
 }
 
-#endif /* CONFIG_INET */
-
 static int __init cgroup_memory(char *s)
 {
 	char *token;
diff -puN mm/vmpressure.c~mm-memcontrol-reign-in-the-config-space-madness mm/vmpressure.c
--- a/mm/vmpressure.c~mm-memcontrol-reign-in-the-config-space-madness
+++ a/mm/vmpressure.c
@@ -275,7 +275,6 @@ void vmpressure(gfp_t gfp, struct mem_cg
 
 		level = vmpressure_calc_level(scanned, reclaimed);
 
-#ifdef CONFIG_INET
 		if (level > VMPRESSURE_LOW) {
 			/*
 			 * Let the socket buffer allocator know that
@@ -287,7 +286,6 @@ void vmpressure(gfp_t gfp, struct mem_cg
 			 */
 			memcg->socket_pressure = jiffies + HZ;
 		}
-#endif
 	}
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

