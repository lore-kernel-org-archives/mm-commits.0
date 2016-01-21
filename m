From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 15:29:40 -0800
Message-ID: <56a169e4.Ku6acYqFp571SuqE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbcAUX3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, arnd@arndb.de, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: introduce CONFIG_MEMCG_LEGACY_KMEM
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-introduce-config_memcg_legacy_kmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: introduce CONFIG_MEMCG_LEGACY_KMEM

Let the user know that CONFIG_MEMCG_KMEM does not apply to the cgroup2
interface. This also makes legacy-only code sections stand out better.

[arnd@arndb.de: mm: memcontrol: only manage socket pressure for CONFIG_INET]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 init/Kconfig               |   10 +++++++++-
 mm/memcontrol.c            |   18 +++++++++---------
 mm/vmpressure.c            |    2 ++
 net/ipv4/Makefile          |    2 +-
 5 files changed, 23 insertions(+), 13 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-introduce-config_memcg_legacy_kmem include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-introduce-config_memcg_legacy_kmem
+++ a/include/linux/memcontrol.h
@@ -233,7 +233,7 @@ struct mem_cgroup {
 	 */
 	struct mem_cgroup_stat_cpu __percpu *stat;
 
-#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
+#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
 	struct cg_proto tcp_mem;
 #endif
 #ifndef CONFIG_SLOB
@@ -717,7 +717,7 @@ extern struct static_key_false memcg_soc
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	if (memcg->tcp_mem.memory_pressure)
 		return true;
 #endif
diff -puN init/Kconfig~mm-memcontrol-introduce-config_memcg_legacy_kmem init/Kconfig
--- a/init/Kconfig~mm-memcontrol-introduce-config_memcg_legacy_kmem
+++ a/init/Kconfig
@@ -964,10 +964,13 @@ config MEMCG_SWAP_ENABLED
 	  For those who want to have the feature enabled by default should
 	  select this option (if, for some reason, they need to disable it
 	  then swapaccount=0 does the trick).
+config MEMCG_LEGACY_KMEM
+       bool
 config MEMCG_KMEM
-	bool "Memory Resource Controller Kernel Memory accounting"
+	bool "Legacy Memory Resource Controller Kernel Memory accounting"
 	depends on MEMCG
 	depends on SLUB || SLAB
+	select MEMCG_LEGACY_KMEM
 	help
 	  The Kernel Memory extension for Memory Resource Controller can limit
 	  the amount of memory used by kernel objects in the system. Those are
@@ -1071,6 +1074,11 @@ config CGROUP_FREEZER
 	  Provides a way to freeze and unfreeze all tasks in a
 	  cgroup.
 
+	  This option affects the ORIGINAL cgroup interface. The cgroup2 memory
+	  controller includes important in-kernel memory consumers per default.
+
+	  If you're using cgroup2, say N.
+
 config CGROUP_HUGETLB
 	bool "HugeTLB controller"
 	depends on HUGETLB_PAGE
diff -puN mm/memcontrol.c~mm-memcontrol-introduce-config_memcg_legacy_kmem mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-introduce-config_memcg_legacy_kmem
+++ a/mm/memcontrol.c
@@ -3001,7 +3001,7 @@ static void memcg_free_kmem(struct mem_c
 }
 #endif /* !CONFIG_SLOB */
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
 				   unsigned long limit)
 {
@@ -3025,7 +3025,7 @@ static int memcg_update_kmem_limit(struc
 {
 	return -EINVAL;
 }
-#endif /* CONFIG_MEMCG_KMEM */
+#endif /* CONFIG_MEMCG_LEGACY_KMEM */
 
 
 /*
@@ -4039,7 +4039,7 @@ static struct cftype mem_cgroup_legacy_f
 		.seq_show = memcg_numa_stat_show,
 	},
 #endif
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	{
 		.name = "kmem.limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
@@ -4266,13 +4266,13 @@ mem_cgroup_css_online(struct cgroup_subs
 	if (ret)
 		return ret;
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_INET
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	ret = tcp_init_cgroup(memcg);
 	if (ret)
 		return ret;
 #endif
 
-#ifdef CONFIG_INET
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_inc(&memcg_sockets_enabled_key);
 #endif
@@ -4329,7 +4329,7 @@ static void mem_cgroup_css_free(struct c
 
 	memcg_free_kmem(memcg);
 
-#ifdef CONFIG_MEMCG_KMEM
+#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
 	tcp_destroy_cgroup(memcg);
 #endif
 
@@ -5558,7 +5558,7 @@ void sock_update_memcg(struct sock *sk)
 	memcg = mem_cgroup_from_task(current);
 	if (memcg == root_mem_cgroup)
 		goto out;
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcp_mem.active)
 		goto out;
 #endif
@@ -5587,7 +5587,7 @@ bool mem_cgroup_charge_skmem(struct mem_
 {
 	gfp_t gfp_mask = GFP_KERNEL;
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		struct page_counter *counter;
 
@@ -5619,7 +5619,7 @@ bool mem_cgroup_charge_skmem(struct mem_
  */
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		page_counter_uncharge(&memcg->tcp_mem.memory_allocated,
 				      nr_pages);
diff -puN mm/vmpressure.c~mm-memcontrol-introduce-config_memcg_legacy_kmem mm/vmpressure.c
--- a/mm/vmpressure.c~mm-memcontrol-introduce-config_memcg_legacy_kmem
+++ a/mm/vmpressure.c
@@ -275,6 +275,7 @@ void vmpressure(gfp_t gfp, struct mem_cg
 
 		level = vmpressure_calc_level(scanned, reclaimed);
 
+#ifdef CONFIG_INET
 		if (level > VMPRESSURE_LOW) {
 			/*
 			 * Let the socket buffer allocator know that
@@ -286,6 +287,7 @@ void vmpressure(gfp_t gfp, struct mem_cg
 			 */
 			memcg->socket_pressure = jiffies + HZ;
 		}
+#endif
 	}
 }
 
diff -puN net/ipv4/Makefile~mm-memcontrol-introduce-config_memcg_legacy_kmem net/ipv4/Makefile
--- a/net/ipv4/Makefile~mm-memcontrol-introduce-config_memcg_legacy_kmem
+++ a/net/ipv4/Makefile
@@ -56,7 +56,7 @@ obj-$(CONFIG_TCP_CONG_SCALABLE) += tcp_s
 obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
-obj-$(CONFIG_MEMCG_KMEM) += tcp_memcontrol.o
+obj-$(CONFIG_MEMCG_LEGACY_KMEM) += tcp_memcontrol.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

