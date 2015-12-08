From: akpm@linux-foundation.org
Subject: + mm-memcontrol-switch-to-the-updated-jump-label-api.patch added
 to -mm tree
Date: Tue, 08 Dec 2015 14:52:23 -0800
Message-ID: <56675f27.B1LMLwc7SY2Kfyj0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbbLHWwZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:52:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, jbaron@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: switch to the updated jump-label API
has been added to the -mm tree.  Its filename is
     mm-memcontrol-switch-to-the-updated-jump-label-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-switch-to-the-updated-jump-label-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-switch-to-the-updated-jump-label-api.patch

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
Subject: mm: memcontrol: switch to the updated jump-label API

According to <linux/jump_label.h> the direct use of struct static_key is
deprecated.  Update the socket and slab accounting code accordingly.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David S. Miller <davem@davemloft.net>
Reported-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 ++++----
 mm/memcontrol.c            |   12 ++++++------
 net/ipv4/tcp_memcontrol.c  |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-switch-to-the-updated-jump-label-api include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-switch-to-the-updated-jump-label-api
+++ a/include/linux/memcontrol.h
@@ -704,8 +704,8 @@ void sock_release_memcg(struct sock *sk)
 bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 #if defined(CONFIG_MEMCG) && defined(CONFIG_INET)
-extern struct static_key memcg_sockets_enabled_key;
-#define mem_cgroup_sockets_enabled static_key_false(&memcg_sockets_enabled_key)
+extern struct static_key_false memcg_sockets_enabled_key;
+#define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 #ifdef CONFIG_MEMCG_KMEM
@@ -727,7 +727,7 @@ static inline bool mem_cgroup_under_sock
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
-extern struct static_key memcg_kmem_enabled_key;
+extern struct static_key_false memcg_kmem_enabled_key;
 
 extern int memcg_nr_cache_ids;
 void memcg_get_cache_ids(void);
@@ -743,7 +743,7 @@ void memcg_put_cache_ids(void);
 
 static inline bool memcg_kmem_enabled(void)
 {
-	return static_key_false(&memcg_kmem_enabled_key);
+	return static_branch_unlikely(&memcg_kmem_enabled_key);
 }
 
 static inline bool memcg_kmem_is_active(struct mem_cgroup *memcg)
diff -puN mm/memcontrol.c~mm-memcontrol-switch-to-the-updated-jump-label-api mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-switch-to-the-updated-jump-label-api
+++ a/mm/memcontrol.c
@@ -346,7 +346,7 @@ void memcg_put_cache_ids(void)
  * conditional to this static branch, we'll have to allow modules that does
  * kmem_cache_alloc and the such to see this symbol as well
  */
-struct static_key memcg_kmem_enabled_key;
+DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabled_key);
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
 #endif /* CONFIG_MEMCG_KMEM */
@@ -2883,7 +2883,7 @@ static int memcg_activate_kmem(struct me
 	err = page_counter_limit(&memcg->kmem, nr_pages);
 	VM_BUG_ON(err);
 
-	static_key_slow_inc(&memcg_kmem_enabled_key);
+	static_branch_inc(&memcg_kmem_enabled_key);
 	/*
 	 * A memory cgroup is considered kmem-active as soon as it gets
 	 * kmemcg_id. Setting the id after enabling static branching will
@@ -3622,7 +3622,7 @@ static void memcg_destroy_kmem(struct me
 {
 	if (memcg->kmem_acct_activated) {
 		memcg_destroy_kmem_caches(memcg);
-		static_key_slow_dec(&memcg_kmem_enabled_key);
+		static_branch_dec(&memcg_kmem_enabled_key);
 		WARN_ON(page_counter_read(&memcg->kmem));
 	}
 	tcp_destroy_cgroup(memcg);
@@ -4258,7 +4258,7 @@ mem_cgroup_css_online(struct cgroup_subs
 
 #ifdef CONFIG_INET
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
-		static_key_slow_inc(&memcg_sockets_enabled_key);
+		static_branch_inc(&memcg_sockets_enabled_key);
 #endif
 
 	/*
@@ -4302,7 +4302,7 @@ static void mem_cgroup_css_free(struct c
 	memcg_destroy_kmem(memcg);
 #ifdef CONFIG_INET
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
-		static_key_slow_dec(&memcg_sockets_enabled_key);
+		static_branch_dec(&memcg_sockets_enabled_key);
 #endif
 	__mem_cgroup_free(memcg);
 }
@@ -5524,7 +5524,7 @@ void mem_cgroup_replace_page(struct page
 
 #ifdef CONFIG_INET
 
-struct static_key memcg_sockets_enabled_key;
+DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
 EXPORT_SYMBOL(memcg_sockets_enabled_key);
 
 void sock_update_memcg(struct sock *sk)
diff -puN net/ipv4/tcp_memcontrol.c~mm-memcontrol-switch-to-the-updated-jump-label-api net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~mm-memcontrol-switch-to-the-updated-jump-label-api
+++ a/net/ipv4/tcp_memcontrol.c
@@ -34,7 +34,7 @@ void tcp_destroy_cgroup(struct mem_cgrou
 		return;
 
 	if (memcg->tcp_mem.active)
-		static_key_slow_dec(&memcg_sockets_enabled_key);
+		static_branch_dec(&memcg_sockets_enabled_key);
 }
 
 static int tcp_update_limit(struct mem_cgroup *memcg, unsigned long nr_pages)
@@ -65,7 +65,7 @@ static int tcp_update_limit(struct mem_c
 		 * because when this value change, the code to process it is not
 		 * patched in yet.
 		 */
-		static_key_slow_inc(&memcg_sockets_enabled_key);
+		static_branch_inc(&memcg_sockets_enabled_key);
 		memcg->tcp_mem.active = true;
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
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch

