From: akpm@linux-foundation.org
Subject: + mm-memcontrol-introduce-config_memcg_legacy_kmem.patch added to -mm tree
Date: Tue, 08 Dec 2015 15:06:50 -0800
Message-ID: <5667628a.PzvWs4kJ95pB2ios%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbLHXGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 18:06:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: introduce CONFIG_MEMCG_LEGACY_KMEM
has been added to the -mm tree.  Its filename is
     mm-memcontrol-introduce-config_memcg_legacy_kmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-introduce-config_memcg_legacy_kmem.patch

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
Subject: mm: memcontrol: introduce CONFIG_MEMCG_LEGACY_KMEM

Let the user know that CONFIG_MEMCG_KMEM does not apply to the cgroup2
interface. This also makes legacy-only code sections stand out better.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 init/Kconfig               |   10 +++++++++-
 mm/memcontrol.c            |   16 ++++++++--------
 net/ipv4/Makefile          |    2 +-
 4 files changed, 20 insertions(+), 12 deletions(-)

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
 
@@ -873,7 +873,7 @@ extern struct static_key_false memcg_soc
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
@@ -1040,10 +1040,13 @@ config MEMCG_SWAP_ENABLED
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
@@ -1052,6 +1055,11 @@ config MEMCG_KMEM
 	  the kmem extension can use it to guarantee that no group of processes
 	  will ever exhaust kernel resources alone.
 
+	  This option affects the ORIGINAL cgroup interface. The cgroup2 memory
+	  controller includes important in-kernel memory consumers per default.
+
+	  If you're using cgroup2, say N.
+
 config CGROUP_HUGETLB
 	bool "HugeTLB Resource Controller for Control Groups"
 	depends on HUGETLB_PAGE
diff -puN mm/memcontrol.c~mm-memcontrol-introduce-config_memcg_legacy_kmem mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-introduce-config_memcg_legacy_kmem
+++ a/mm/memcontrol.c
@@ -2959,7 +2959,7 @@ static void memcg_free_kmem(struct mem_c
 	}
 }
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
 				   unsigned long limit)
 {
@@ -2983,7 +2983,7 @@ static int memcg_update_kmem_limit(struc
 {
 	return -EINVAL;
 }
-#endif /* CONFIG_MEMCG_KMEM */
+#endif /* CONFIG_MEMCG_LEGACY_KMEM */
 
 /*
  * The user of this function is...
@@ -3995,7 +3995,7 @@ static struct cftype mem_cgroup_legacy_f
 		.seq_show = memcg_numa_stat_show,
 	},
 #endif
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	{
 		.name = "kmem.limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
@@ -4220,7 +4220,7 @@ mem_cgroup_css_online(struct cgroup_subs
 	if (ret)
 		return ret;
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	ret = tcp_init_cgroup(memcg);
 	if (ret)
 		return ret;
@@ -4276,7 +4276,7 @@ static void mem_cgroup_css_free(struct c
 
 	memcg_free_kmem(memcg);
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	tcp_destroy_cgroup(memcg);
 #endif
 
@@ -5504,7 +5504,7 @@ void sock_update_memcg(struct sock *sk)
 	memcg = mem_cgroup_from_task(current);
 	if (memcg == root_mem_cgroup)
 		goto out;
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcp_mem.active)
 		goto out;
 #endif
@@ -5533,7 +5533,7 @@ bool mem_cgroup_charge_skmem(struct mem_
 {
 	gfp_t gfp_mask = GFP_KERNEL;
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		struct page_counter *counter;
 
@@ -5565,7 +5565,7 @@ bool mem_cgroup_charge_skmem(struct mem_
  */
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG_LEGACY_KMEM
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		page_counter_uncharge(&memcg->tcp_mem.memory_allocated,
 				      nr_pages);
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
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch

