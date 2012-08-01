From: akpm@linux-foundation.org
Subject: [merged] memcg-rename-config-variables.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:54 -0700
Message-ID: <20120801201354.E21A51E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:56 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: rename config variables
has been removed from the -mm tree.  Its filename was
     memcg-rename-config-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg: rename config variables

Sanity:

CONFIG_CGROUP_MEM_RES_CTLR -> CONFIG_MEMCG
CONFIG_CGROUP_MEM_RES_CTLR_SWAP -> CONFIG_MEMCG_SWAP
CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED -> CONFIG_MEMCG_SWAP_ENABLED
CONFIG_CGROUP_MEM_RES_CTLR_KMEM -> CONFIG_MEMCG_KMEM

[mhocko@suse.cz: fix missed bits]
Cc: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt      |   10 +++++-----
 arch/powerpc/configs/chroma_defconfig |    4 ++--
 arch/s390/defconfig                   |    2 +-
 arch/sh/configs/apsh4ad0a_defconfig   |    2 +-
 arch/sh/configs/sdk7786_defconfig     |    4 ++--
 arch/sh/configs/se7206_defconfig      |    2 +-
 arch/sh/configs/shx3_defconfig        |    2 +-
 arch/sh/configs/urquell_defconfig     |    4 ++--
 arch/tile/configs/tilegx_defconfig    |    4 ++--
 arch/tile/configs/tilepro_defconfig   |    4 ++--
 arch/um/defconfig                     |    8 ++++----
 include/linux/cgroup_subsys.h         |    2 +-
 include/linux/memcontrol.h            |   14 +++++++-------
 include/linux/mmzone.h                |    8 ++++----
 include/linux/page_cgroup.h           |   10 +++++-----
 include/linux/sched.h                 |    2 +-
 include/linux/swap.h                  |    6 +++---
 include/net/sock.h                    |    4 ++--
 init/Kconfig                          |   14 +++++++-------
 kernel/fork.c                         |    2 +-
 mm/Makefile                           |    2 +-
 mm/hwpoison-inject.c                  |    2 +-
 mm/memcontrol.c                       |   20 ++++++++++----------
 mm/memory-failure.c                   |    2 +-
 mm/mmzone.c                           |    2 +-
 mm/oom_kill.c                         |    2 +-
 mm/page_cgroup.c                      |    2 +-
 mm/vmscan.c                           |    4 ++--
 net/core/sock.c                       |    2 +-
 net/ipv4/Makefile                     |    2 +-
 net/ipv4/sysctl_net_ipv4.c            |    4 ++--
 net/ipv4/tcp_ipv4.c                   |    2 +-
 net/ipv6/tcp_ipv6.c                   |    2 +-
 33 files changed, 78 insertions(+), 78 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-rename-config-variables Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-rename-config-variables
+++ a/Documentation/cgroups/memory.txt
@@ -187,12 +187,12 @@ the cgroup that brought it in -- this wi
 But see section 8.2: when moving a task to another cgroup, its pages may
 be recharged to the new cgroup, if move_charge_at_immigrate has been chosen.
 
-Exception: If CONFIG_CGROUP_CGROUP_MEM_RES_CTLR_SWAP is not used.
+Exception: If CONFIG_CGROUP_CGROUP_MEMCG_SWAP is not used.
 When you do swapoff and make swapped-out pages of shmem(tmpfs) to
 be backed into memory in force, charges for pages are accounted against the
 caller of swapoff rather than the users of shmem.
 
-2.4 Swap Extension (CONFIG_CGROUP_MEM_RES_CTLR_SWAP)
+2.4 Swap Extension (CONFIG_MEMCG_SWAP)
 
 Swap Extension allows you to record charge for swap. A swapped-in page is
 charged back to original page allocator if possible.
@@ -259,7 +259,7 @@ When oom event notifier is registered, e
   per-zone-per-cgroup LRU (cgroup's private LRU) is just guarded by
   zone->lru_lock, it has no lock of its own.
 
-2.7 Kernel Memory Extension (CONFIG_CGROUP_MEM_RES_CTLR_KMEM)
+2.7 Kernel Memory Extension (CONFIG_MEMCG_KMEM)
 
 With the Kernel memory extension, the Memory Controller is able to limit
 the amount of kernel memory used by the system. Kernel memory is fundamentally
@@ -286,8 +286,8 @@ per cgroup, instead of globally.
 
 a. Enable CONFIG_CGROUPS
 b. Enable CONFIG_RESOURCE_COUNTERS
-c. Enable CONFIG_CGROUP_MEM_RES_CTLR
-d. Enable CONFIG_CGROUP_MEM_RES_CTLR_SWAP (to use swap extension)
+c. Enable CONFIG_MEMCG
+d. Enable CONFIG_MEMCG_SWAP (to use swap extension)
 
 1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
 # mount -t tmpfs none /sys/fs/cgroup
diff -puN arch/powerpc/configs/chroma_defconfig~memcg-rename-config-variables arch/powerpc/configs/chroma_defconfig
--- a/arch/powerpc/configs/chroma_defconfig~memcg-rename-config-variables
+++ a/arch/powerpc/configs/chroma_defconfig
@@ -21,8 +21,8 @@ CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
-CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
+CONFIG_CGROUP_MEMCG=y
+CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_NAMESPACES=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
diff -puN arch/s390/defconfig~memcg-rename-config-variables arch/s390/defconfig
--- a/arch/s390/defconfig~memcg-rename-config-variables
+++ a/arch/s390/defconfig
@@ -13,7 +13,7 @@ CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
+CONFIG_CGROUP_MEMCG=y
 CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
diff -puN arch/sh/configs/apsh4ad0a_defconfig~memcg-rename-config-variables arch/sh/configs/apsh4ad0a_defconfig
--- a/arch/sh/configs/apsh4ad0a_defconfig~memcg-rename-config-variables
+++ a/arch/sh/configs/apsh4ad0a_defconfig
@@ -11,7 +11,7 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
+CONFIG_CGROUP_MEMCG=y
 CONFIG_BLK_CGROUP=y
 CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
diff -puN arch/sh/configs/sdk7786_defconfig~memcg-rename-config-variables arch/sh/configs/sdk7786_defconfig
--- a/arch/sh/configs/sdk7786_defconfig~memcg-rename-config-variables
+++ a/arch/sh/configs/sdk7786_defconfig
@@ -18,8 +18,8 @@ CONFIG_CPUSETS=y
 # CONFIG_PROC_PID_CPUSET is not set
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
-CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
+CONFIG_CGROUP_MEMCG=y
+CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
diff -puN arch/sh/configs/se7206_defconfig~memcg-rename-config-variables arch/sh/configs/se7206_defconfig
--- a/arch/sh/configs/se7206_defconfig~memcg-rename-config-variables
+++ a/arch/sh/configs/se7206_defconfig
@@ -11,7 +11,7 @@ CONFIG_CGROUP_DEBUG=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
+CONFIG_CGROUP_MEMCG=y
 CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
 CONFIG_UTS_NS=y
diff -puN arch/sh/configs/shx3_defconfig~memcg-rename-config-variables arch/sh/configs/shx3_defconfig
--- a/arch/sh/configs/shx3_defconfig~memcg-rename-config-variables
+++ a/arch/sh/configs/shx3_defconfig
@@ -13,7 +13,7 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
+CONFIG_CGROUP_MEMCG=y
 CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
 CONFIG_UTS_NS=y
diff -puN arch/sh/configs/urquell_defconfig~memcg-rename-config-variables arch/sh/configs/urquell_defconfig
--- a/arch/sh/configs/urquell_defconfig~memcg-rename-config-variables
+++ a/arch/sh/configs/urquell_defconfig
@@ -15,8 +15,8 @@ CONFIG_CPUSETS=y
 # CONFIG_PROC_PID_CPUSET is not set
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
-CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
+CONFIG_CGROUP_MEMCG=y
+CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_DEV_INITRD=y
diff -puN arch/tile/configs/tilegx_defconfig~memcg-rename-config-variables arch/tile/configs/tilegx_defconfig
--- a/arch/tile/configs/tilegx_defconfig~memcg-rename-config-variables
+++ a/arch/tile/configs/tilegx_defconfig
@@ -18,8 +18,8 @@ CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
-CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
+CONFIG_CGROUP_MEMCG=y
+CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
diff -puN arch/tile/configs/tilepro_defconfig~memcg-rename-config-variables arch/tile/configs/tilepro_defconfig
--- a/arch/tile/configs/tilepro_defconfig~memcg-rename-config-variables
+++ a/arch/tile/configs/tilepro_defconfig
@@ -17,8 +17,8 @@ CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
-CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
+CONFIG_CGROUP_MEMCG=y
+CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
diff -puN arch/um/defconfig~memcg-rename-config-variables arch/um/defconfig
--- a/arch/um/defconfig~memcg-rename-config-variables
+++ a/arch/um/defconfig
@@ -155,10 +155,10 @@ CONFIG_CPUSETS=y
 CONFIG_PROC_PID_CPUSET=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEM_RES_CTLR=y
-CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
-# CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED is not set
-# CONFIG_CGROUP_MEM_RES_CTLR_KMEM is not set
+CONFIG_CGROUP_MEMCG=y
+CONFIG_CGROUP_MEMCG_SWAP=y
+# CONFIG_CGROUP_MEMCG_SWAP_ENABLED is not set
+# CONFIG_CGROUP_MEMCG_KMEM is not set
 CONFIG_CGROUP_SCHED=y
 CONFIG_FAIR_GROUP_SCHED=y
 # CONFIG_CFS_BANDWIDTH is not set
diff -puN include/linux/cgroup_subsys.h~memcg-rename-config-variables include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~memcg-rename-config-variables
+++ a/include/linux/cgroup_subsys.h
@@ -31,7 +31,7 @@ SUBSYS(cpuacct)
 
 /* */
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 SUBSYS(mem_cgroup)
 #endif
 
diff -puN include/linux/memcontrol.h~memcg-rename-config-variables include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-rename-config-variables
+++ a/include/linux/memcontrol.h
@@ -38,7 +38,7 @@ struct mem_cgroup_reclaim_cookie {
 	unsigned int generation;
 };
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 /*
  * All "charge" functions with gfp_mask should use GFP_KERNEL or
  * (gfp_mask & GFP_RECLAIM_MASK). In current implementatin, memcg doesn't
@@ -124,7 +124,7 @@ extern void mem_cgroup_print_oom_info(st
 extern void mem_cgroup_replace_page_cache(struct page *oldpage,
 					struct page *newpage);
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#ifdef CONFIG_MEMCG_SWAP
 extern int do_swap_account;
 #endif
 
@@ -193,7 +193,7 @@ void mem_cgroup_split_huge_fixup(struct 
 bool mem_cgroup_bad_page_check(struct page *page);
 void mem_cgroup_print_bad_page(struct page *page);
 #endif
-#else /* CONFIG_CGROUP_MEM_RES_CTLR */
+#else /* CONFIG_MEMCG */
 struct mem_cgroup;
 
 static inline int mem_cgroup_newpage_charge(struct page *page,
@@ -384,9 +384,9 @@ static inline void mem_cgroup_replace_pa
 				struct page *newpage)
 {
 }
-#endif /* CONFIG_CGROUP_MEM_RES_CTLR */
+#endif /* CONFIG_MEMCG */
 
-#if !defined(CONFIG_CGROUP_MEM_RES_CTLR) || !defined(CONFIG_DEBUG_VM)
+#if !defined(CONFIG_MEMCG) || !defined(CONFIG_DEBUG_VM)
 static inline bool
 mem_cgroup_bad_page_check(struct page *page)
 {
@@ -406,7 +406,7 @@ enum {
 };
 
 struct sock;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 void sock_update_memcg(struct sock *sk);
 void sock_release_memcg(struct sock *sk);
 #else
@@ -416,6 +416,6 @@ static inline void sock_update_memcg(str
 static inline void sock_release_memcg(struct sock *sk)
 {
 }
-#endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
+#endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN include/linux/mmzone.h~memcg-rename-config-variables include/linux/mmzone.h
--- a/include/linux/mmzone.h~memcg-rename-config-variables
+++ a/include/linux/mmzone.h
@@ -201,7 +201,7 @@ struct zone_reclaim_stat {
 struct lruvec {
 	struct list_head lists[NR_LRU_LISTS];
 	struct zone_reclaim_stat reclaim_stat;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 	struct zone *zone;
 #endif
 };
@@ -671,7 +671,7 @@ typedef struct pglist_data {
 	int nr_zones;
 #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
 	struct page *node_mem_map;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 	struct page_cgroup *node_page_cgroup;
 #endif
 #endif
@@ -736,7 +736,7 @@ extern void lruvec_init(struct lruvec *l
 
 static inline struct zone *lruvec_zone(struct lruvec *lruvec)
 {
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 	return lruvec->zone;
 #else
 	return container_of(lruvec, struct zone, lruvec);
@@ -1052,7 +1052,7 @@ struct mem_section {
 
 	/* See declaration of similar field in struct zone */
 	unsigned long *pageblock_flags;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 	/*
 	 * If !SPARSEMEM, pgdat doesn't have page_cgroup pointer. We use
 	 * section. (see memcontrol.h/page_cgroup.h about this.)
diff -puN include/linux/page_cgroup.h~memcg-rename-config-variables include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-rename-config-variables
+++ a/include/linux/page_cgroup.h
@@ -12,7 +12,7 @@ enum {
 #ifndef __GENERATING_BOUNDS_H
 #include <generated/bounds.h>
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 #include <linux/bit_spinlock.h>
 
 /*
@@ -82,7 +82,7 @@ static inline void unlock_page_cgroup(st
 	bit_spin_unlock(PCG_LOCK, &pc->flags);
 }
 
-#else /* CONFIG_CGROUP_MEM_RES_CTLR */
+#else /* CONFIG_MEMCG */
 struct page_cgroup;
 
 static inline void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
@@ -102,11 +102,11 @@ static inline void __init page_cgroup_in
 {
 }
 
-#endif /* CONFIG_CGROUP_MEM_RES_CTLR */
+#endif /* CONFIG_MEMCG */
 
 #include <linux/swap.h>
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#ifdef CONFIG_MEMCG_SWAP
 extern unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
 					unsigned short old, unsigned short new);
 extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id);
@@ -138,7 +138,7 @@ static inline void swap_cgroup_swapoff(i
 	return;
 }
 
-#endif /* CONFIG_CGROUP_MEM_RES_CTLR_SWAP */
+#endif /* CONFIG_MEMCG_SWAP */
 
 #endif /* !__GENERATING_BOUNDS_H */
 
diff -puN include/linux/sched.h~memcg-rename-config-variables include/linux/sched.h
--- a/include/linux/sched.h~memcg-rename-config-variables
+++ a/include/linux/sched.h
@@ -1584,7 +1584,7 @@ struct task_struct {
 	/* bitmask and counter of trace recursion */
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
+#ifdef CONFIG_MEMCG /* memcg uses this to do batch job */
 	struct memcg_batch_info {
 		int do_batch;	/* incremented when batch uncharge started */
 		struct mem_cgroup *memcg; /* target memcg of uncharge */
diff -puN include/linux/swap.h~memcg-rename-config-variables include/linux/swap.h
--- a/include/linux/swap.h~memcg-rename-config-variables
+++ a/include/linux/swap.h
@@ -301,7 +301,7 @@ static inline void scan_unevictable_unre
 
 extern int kswapd_run(int nid);
 extern void kswapd_stop(int nid);
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 extern int mem_cgroup_swappiness(struct mem_cgroup *mem);
 #else
 static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
@@ -309,7 +309,7 @@ static inline int mem_cgroup_swappiness(
 	return vm_swappiness;
 }
 #endif
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#ifdef CONFIG_MEMCG_SWAP
 extern void mem_cgroup_uncharge_swap(swp_entry_t ent);
 #else
 static inline void mem_cgroup_uncharge_swap(swp_entry_t ent)
@@ -360,7 +360,7 @@ extern int reuse_swap_page(struct page *
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 extern void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
 #else
diff -puN include/net/sock.h~memcg-rename-config-variables include/net/sock.h
--- a/include/net/sock.h~memcg-rename-config-variables
+++ a/include/net/sock.h
@@ -913,7 +913,7 @@ struct proto {
 #ifdef SOCK_REFCNT_DEBUG
 	atomic_t		socks;
 #endif
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 	/*
 	 * cgroup specific init/deinit functions. Called once for all
 	 * protocols that implement it, from cgroups populate function.
@@ -994,7 +994,7 @@ inline void sk_refcnt_debug_release(cons
 #define sk_refcnt_debug_release(sk) do { } while (0)
 #endif /* SOCK_REFCNT_DEBUG */
 
-#if defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM) && defined(CONFIG_NET)
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_NET)
 extern struct static_key memcg_socket_limit_enabled;
 static inline struct cg_proto *parent_cg_proto(struct proto *proto,
 					       struct cg_proto *cg_proto)
diff -puN init/Kconfig~memcg-rename-config-variables init/Kconfig
--- a/init/Kconfig~memcg-rename-config-variables
+++ a/init/Kconfig
@@ -686,7 +686,7 @@ config RESOURCE_COUNTERS
 	  This option enables controller independent resource accounting
 	  infrastructure that works with cgroups.
 
-config CGROUP_MEM_RES_CTLR
+config MEMCG
 	bool "Memory Resource Controller for Control Groups"
 	depends on RESOURCE_COUNTERS
 	select MM_OWNER
@@ -709,9 +709,9 @@ config CGROUP_MEM_RES_CTLR
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.
 
-config CGROUP_MEM_RES_CTLR_SWAP
+config MEMCG_SWAP
 	bool "Memory Resource Controller Swap Extension"
-	depends on CGROUP_MEM_RES_CTLR && SWAP
+	depends on MEMCG && SWAP
 	help
 	  Add swap management feature to memory resource controller. When you
 	  enable this, you can limit mem+swap usage per cgroup. In other words,
@@ -726,9 +726,9 @@ config CGROUP_MEM_RES_CTLR_SWAP
 	  if boot option "swapaccount=0" is set, swap will not be accounted.
 	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
 	  size is 4096bytes, 512k per 1Gbytes of swap.
-config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
+config MEMCG_SWAP_ENABLED
 	bool "Memory Resource Controller Swap Extension enabled by default"
-	depends on CGROUP_MEM_RES_CTLR_SWAP
+	depends on MEMCG_SWAP
 	default y
 	help
 	  Memory Resource Controller Swap Extension comes with its price in
@@ -739,9 +739,9 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
 	  For those who want to have the feature enabled by default should
 	  select this option (if, for some reason, they need to disable it
 	  then swapaccount=0 does the trick).
-config CGROUP_MEM_RES_CTLR_KMEM
+config MEMCG_KMEM
 	bool "Memory Resource Controller Kernel Memory accounting (EXPERIMENTAL)"
-	depends on CGROUP_MEM_RES_CTLR && EXPERIMENTAL
+	depends on MEMCG && EXPERIMENTAL
 	default n
 	help
 	  The Kernel Memory extension for Memory Resource Controller can limit
diff -puN kernel/fork.c~memcg-rename-config-variables kernel/fork.c
--- a/kernel/fork.c~memcg-rename-config-variables
+++ a/kernel/fork.c
@@ -1306,7 +1306,7 @@ static struct task_struct *copy_process(
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 	p->memcg_batch.do_batch = 0;
 	p->memcg_batch.memcg = NULL;
 #endif
diff -puN mm/Makefile~memcg-rename-config-variables mm/Makefile
--- a/mm/Makefile~memcg-rename-config-variables
+++ a/mm/Makefile
@@ -49,7 +49,7 @@ obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o
-obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
+obj-$(CONFIG_MEMCG) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
diff -puN mm/hwpoison-inject.c~memcg-rename-config-variables mm/hwpoison-inject.c
--- a/mm/hwpoison-inject.c~memcg-rename-config-variables
+++ a/mm/hwpoison-inject.c
@@ -123,7 +123,7 @@ static int pfn_inject_init(void)
 	if (!dentry)
 		goto fail;
 
-#ifdef	CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#ifdef CONFIG_MEMCG_SWAP
 	dentry = debugfs_create_u64("corrupt-filter-memcg", 0600,
 				    hwpoison_dir, &hwpoison_filter_memcg);
 	if (!dentry)
diff -puN mm/memcontrol.c~memcg-rename-config-variables mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rename-config-variables
+++ a/mm/memcontrol.c
@@ -61,12 +61,12 @@ struct cgroup_subsys mem_cgroup_subsys _
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 static struct mem_cgroup *root_mem_cgroup __read_mostly;
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#ifdef CONFIG_MEMCG_SWAP
 /* Turned on only when memory cgroup is enabled && really_do_swap_account = 1 */
 int do_swap_account __read_mostly;
 
 /* for remember boot option*/
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED
+#ifdef CONFIG_MEMCG_SWAP_ENABLED
 static int really_do_swap_account __initdata = 1;
 #else
 static int really_do_swap_account __initdata = 0;
@@ -407,7 +407,7 @@ static void mem_cgroup_get(struct mem_cg
 static void mem_cgroup_put(struct mem_cgroup *memcg);
 
 /* Writing them here to avoid exposing memcg's inner layout */
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 #include <net/sock.h>
 #include <net/ip.h>
 
@@ -466,9 +466,9 @@ struct cg_proto *tcp_proto_cgroup(struct
 }
 EXPORT_SYMBOL(tcp_proto_cgroup);
 #endif /* CONFIG_INET */
-#endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
+#endif /* CONFIG_MEMCG_KMEM */
 
-#if defined(CONFIG_INET) && defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM)
+#if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
 static void disarm_sock_keys(struct mem_cgroup *memcg)
 {
 	if (!memcg_proto_activated(&memcg->tcp_mem.cg_proto))
@@ -3085,7 +3085,7 @@ mem_cgroup_uncharge_swapcache(struct pag
 }
 #endif
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#ifdef CONFIG_MEMCG_SWAP
 /*
  * called from swap_entry_free(). remove record in swap_cgroup and
  * uncharge "memsw" account.
@@ -4518,7 +4518,7 @@ static int mem_cgroup_oom_control_write(
 	return 0;
 }
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
 	return mem_cgroup_sockets_init(memcg, ss);
@@ -4608,7 +4608,7 @@ static struct cftype mem_cgroup_files[] 
 		.read_seq_string = mem_control_numa_stat_show,
 	},
 #endif
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#ifdef CONFIG_MEMCG_SWAP
 	{
 		.name = "memsw.usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
@@ -4795,7 +4795,7 @@ struct mem_cgroup *parent_mem_cgroup(str
 }
 EXPORT_SYMBOL(parent_mem_cgroup);
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#ifdef CONFIG_MEMCG_SWAP
 static void __init enable_swap_cgroup(void)
 {
 	if (!mem_cgroup_disabled() && really_do_swap_account)
@@ -5526,7 +5526,7 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.__DEPRECATED_clear_css_refs = true,
 };
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#ifdef CONFIG_MEMCG_SWAP
 static int __init enable_swap_account(char *s)
 {
 	/* consider enabled if no parameter or 1 is given */
diff -puN mm/memory-failure.c~memcg-rename-config-variables mm/memory-failure.c
--- a/mm/memory-failure.c~memcg-rename-config-variables
+++ a/mm/memory-failure.c
@@ -128,7 +128,7 @@ static int hwpoison_filter_flags(struct 
  * can only guarantee that the page either belongs to the memcg tasks, or is
  * a freed page.
  */
-#ifdef	CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#ifdef	CONFIG_MEMCG_SWAP
 u64 hwpoison_filter_memcg;
 EXPORT_SYMBOL_GPL(hwpoison_filter_memcg);
 static int hwpoison_filter_task(struct page *p)
diff -puN mm/mmzone.c~memcg-rename-config-variables mm/mmzone.c
--- a/mm/mmzone.c~memcg-rename-config-variables
+++ a/mm/mmzone.c
@@ -96,7 +96,7 @@ void lruvec_init(struct lruvec *lruvec, 
 	for_each_lru(lru)
 		INIT_LIST_HEAD(&lruvec->lists[lru]);
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 	lruvec->zone = zone;
 #endif
 }
diff -puN mm/oom_kill.c~memcg-rename-config-variables mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-rename-config-variables
+++ a/mm/oom_kill.c
@@ -541,7 +541,7 @@ static void check_panic_on_oom(enum oom_
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
 }
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			      int order)
 {
diff -puN mm/page_cgroup.c~memcg-rename-config-variables mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-rename-config-variables
+++ a/mm/page_cgroup.c
@@ -317,7 +317,7 @@ void __meminit pgdat_page_cgroup_init(st
 #endif
 
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+#ifdef CONFIG_MEMCG_SWAP
 
 static DEFINE_MUTEX(swap_cgroup_mutex);
 struct swap_cgroup_ctrl {
diff -puN mm/vmscan.c~memcg-rename-config-variables mm/vmscan.c
--- a/mm/vmscan.c~memcg-rename-config-variables
+++ a/mm/vmscan.c
@@ -133,7 +133,7 @@ long vm_total_pages;	/* The total number
 static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 static bool global_reclaim(struct scan_control *sc)
 {
 	return !sc->target_mem_cgroup;
@@ -2142,7 +2142,7 @@ unsigned long try_to_free_pages(struct z
 	return nr_reclaimed;
 }
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 
 unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *memcg,
 						gfp_t gfp_mask, bool noswap,
diff -puN net/core/sock.c~memcg-rename-config-variables net/core/sock.c
--- a/net/core/sock.c~memcg-rename-config-variables
+++ a/net/core/sock.c
@@ -142,7 +142,7 @@
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 int mem_cgroup_sockets_init(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
 	struct proto *proto;
diff -puN net/ipv4/Makefile~memcg-rename-config-variables net/ipv4/Makefile
--- a/net/ipv4/Makefile~memcg-rename-config-variables
+++ a/net/ipv4/Makefile
@@ -49,7 +49,7 @@ obj-$(CONFIG_TCP_CONG_SCALABLE) += tcp_s
 obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
-obj-$(CONFIG_CGROUP_MEM_RES_CTLR_KMEM) += tcp_memcontrol.o
+obj-$(CONFIG_MEMCG_KMEM) += tcp_memcontrol.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
diff -puN net/ipv4/sysctl_net_ipv4.c~memcg-rename-config-variables net/ipv4/sysctl_net_ipv4.c
--- a/net/ipv4/sysctl_net_ipv4.c~memcg-rename-config-variables
+++ a/net/ipv4/sysctl_net_ipv4.c
@@ -184,7 +184,7 @@ static int ipv4_tcp_mem(ctl_table *ctl, 
 	int ret;
 	unsigned long vec[3];
 	struct net *net = current->nsproxy->net_ns;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 	struct mem_cgroup *memcg;
 #endif
 
@@ -203,7 +203,7 @@ static int ipv4_tcp_mem(ctl_table *ctl, 
 	if (ret)
 		return ret;
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(current);
 
diff -puN net/ipv4/tcp_ipv4.c~memcg-rename-config-variables net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~memcg-rename-config-variables
+++ a/net/ipv4/tcp_ipv4.c
@@ -2633,7 +2633,7 @@ struct proto tcp_prot = {
 	.compat_setsockopt	= compat_tcp_setsockopt,
 	.compat_getsockopt	= compat_tcp_getsockopt,
 #endif
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 	.init_cgroup		= tcp_init_cgroup,
 	.destroy_cgroup		= tcp_destroy_cgroup,
 	.proto_cgroup		= tcp_proto_cgroup,
diff -puN net/ipv6/tcp_ipv6.c~memcg-rename-config-variables net/ipv6/tcp_ipv6.c
--- a/net/ipv6/tcp_ipv6.c~memcg-rename-config-variables
+++ a/net/ipv6/tcp_ipv6.c
@@ -2015,7 +2015,7 @@ struct proto tcpv6_prot = {
 	.compat_setsockopt	= compat_tcp_setsockopt,
 	.compat_getsockopt	= compat_tcp_getsockopt,
 #endif
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 	.proto_cgroup		= tcp_proto_cgroup,
 #endif
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
mm-slab_commonc-fix-warning.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

