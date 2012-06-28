From: akpm@linux-foundation.org
Subject: + memcg-rename-config-variables-fix.patch added to -mm tree
Date: Thu, 28 Jun 2012 12:54:08 -0700
Message-ID: <20120628195408.B49EDA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61989 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2F1TyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jun 2012 15:54:11 -0400
Received: by wibhr14 with SMTP id hr14so23487wib.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Jun 2012 12:54:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, tj@kernel.org


The patch titled
     Subject: memcg-rename-config-variables-fix
has been added to the -mm tree.  Its filename is
     memcg-rename-config-variables-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg-rename-config-variables-fix

Cc: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    8 ++++----
 include/linux/swap.h             |    6 +++---
 include/net/sock.h               |    4 ++--
 mm/Makefile                      |    2 +-
 net/core/sock.c                  |    2 +-
 net/ipv4/Makefile                |    2 +-
 net/ipv4/sysctl_net_ipv4.c       |    4 ++--
 net/ipv4/tcp_ipv4.c              |    2 +-
 net/ipv6/tcp_ipv6.c              |    2 +-
 9 files changed, 16 insertions(+), 16 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-rename-config-variables-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-rename-config-variables-fix
+++ a/Documentation/cgroups/memory.txt
@@ -192,7 +192,7 @@ When you do swapoff and make swapped-out
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
diff -puN include/linux/swap.h~memcg-rename-config-variables-fix include/linux/swap.h
--- a/include/linux/swap.h~memcg-rename-config-variables-fix
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
@@ -361,7 +361,7 @@ extern int can_reuse_swap_page(struct pa
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_MEMCG
 extern void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
 #else
diff -puN include/net/sock.h~memcg-rename-config-variables-fix include/net/sock.h
--- a/include/net/sock.h~memcg-rename-config-variables-fix
+++ a/include/net/sock.h
@@ -910,7 +910,7 @@ struct proto {
 #ifdef SOCK_REFCNT_DEBUG
 	atomic_t		socks;
 #endif
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 	/*
 	 * cgroup specific init/deinit functions. Called once for all
 	 * protocols that implement it, from cgroups populate function.
@@ -991,7 +991,7 @@ inline void sk_refcnt_debug_release(cons
 #define sk_refcnt_debug_release(sk) do { } while (0)
 #endif /* SOCK_REFCNT_DEBUG */
 
-#if defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM) && defined(CONFIG_NET)
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_NET)
 extern struct static_key memcg_socket_limit_enabled;
 static inline struct cg_proto *parent_cg_proto(struct proto *proto,
 					       struct cg_proto *cg_proto)
diff -puN mm/Makefile~memcg-rename-config-variables-fix mm/Makefile
--- a/mm/Makefile~memcg-rename-config-variables-fix
+++ a/mm/Makefile
@@ -48,7 +48,7 @@ obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o
-obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
+obj-$(CONFIG_MEMCG) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
diff -puN net/core/sock.c~memcg-rename-config-variables-fix net/core/sock.c
--- a/net/core/sock.c~memcg-rename-config-variables-fix
+++ a/net/core/sock.c
@@ -142,7 +142,7 @@
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 int mem_cgroup_sockets_init(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
 	struct proto *proto;
diff -puN net/ipv4/Makefile~memcg-rename-config-variables-fix net/ipv4/Makefile
--- a/net/ipv4/Makefile~memcg-rename-config-variables-fix
+++ a/net/ipv4/Makefile
@@ -48,7 +48,7 @@ obj-$(CONFIG_TCP_CONG_SCALABLE) += tcp_s
 obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
-obj-$(CONFIG_CGROUP_MEM_RES_CTLR_KMEM) += tcp_memcontrol.o
+obj-$(CONFIG_MEMCG_KMEM) += tcp_memcontrol.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
diff -puN net/ipv4/sysctl_net_ipv4.c~memcg-rename-config-variables-fix net/ipv4/sysctl_net_ipv4.c
--- a/net/ipv4/sysctl_net_ipv4.c~memcg-rename-config-variables-fix
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
 
diff -puN net/ipv4/tcp_ipv4.c~memcg-rename-config-variables-fix net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~memcg-rename-config-variables-fix
+++ a/net/ipv4/tcp_ipv4.c
@@ -2652,7 +2652,7 @@ struct proto tcp_prot = {
 	.compat_setsockopt	= compat_tcp_setsockopt,
 	.compat_getsockopt	= compat_tcp_getsockopt,
 #endif
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 	.init_cgroup		= tcp_init_cgroup,
 	.destroy_cgroup		= tcp_destroy_cgroup,
 	.proto_cgroup		= tcp_proto_cgroup,
diff -puN net/ipv6/tcp_ipv6.c~memcg-rename-config-variables-fix net/ipv6/tcp_ipv6.c
--- a/net/ipv6/tcp_ipv6.c~memcg-rename-config-variables-fix
+++ a/net/ipv6/tcp_ipv6.c
@@ -2053,7 +2053,7 @@ struct proto tcpv6_prot = {
 	.compat_setsockopt	= compat_tcp_setsockopt,
 	.compat_getsockopt	= compat_tcp_getsockopt,
 #endif
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+#ifdef CONFIG_MEMCG_KMEM
 	.proto_cgroup		= tcp_proto_cgroup,
 #endif
 };
_
Subject: Subject: memcg-rename-config-variables-fix

Patches currently in -mm which might be from mhocko@suse.cz are

memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
hugetlb-move-all-the-in-use-pages-to-active-list.patch
hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch
hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch
memcg-remove-check-for-signal_pending-during-rmdir.patch
memcg-clean-up-force_empty_list-return-value-check.patch
memcg-mem_cgroup_move_parent-doesnt-need-gfp_mask.patch
memcg-make-mem_cgroup_force_empty_list-return-bool.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-fix-bad-behavior-in-use_hierarchy-file.patch
memcg-rename-mem_control_xxx-to-memcg_xxx.patch

