From: akpm@linux-foundation.org
Subject: + memcg-cleanup-static-keys-decrement.patch added to -mm tree
Date: Mon, 02 Feb 2015 14:51:05 -0800
Message-ID: <54cfff59.aJXEk6EKLJL2B1Nh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965327AbbBBWvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2015 17:51:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, davem@davemloft.net, ebiederm@xmission.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujtisu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: cleanup static keys decrement
has been added to the -mm tree.  Its filename is
     memcg-cleanup-static-keys-decrement.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-cleanup-static-keys-decrement.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-cleanup-static-keys-decrement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: cleanup static keys decrement

Move memcg_socket_limit_enabled decrement to tcp_destroy_cgroup (called
from memcg_destroy_kmem -> mem_cgroup_sockets_destroy) and zap a bunch of
wrapper functions.

Although this patch moves static keys decrement from __mem_cgroup_free to
mem_cgroup_css_free, it does not introduce any functional changes, because
the keys are incremented on setting the limit (tcp or kmem), which can
only happen after successful mem_cgroup_css_online.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/sock.h        |    5 ----
 mm/memcontrol.c           |   38 ++++--------------------------------
 net/ipv4/tcp_memcontrol.c |    4 +++
 3 files changed, 9 insertions(+), 38 deletions(-)

diff -puN include/net/sock.h~memcg-cleanup-static-keys-decrement include/net/sock.h
--- a/include/net/sock.h~memcg-cleanup-static-keys-decrement
+++ a/include/net/sock.h
@@ -1099,11 +1099,6 @@ static inline bool memcg_proto_active(st
 	return test_bit(MEMCG_SOCK_ACTIVE, &cg_proto->flags);
 }
 
-static inline bool memcg_proto_activated(struct cg_proto *cg_proto)
-{
-	return test_bit(MEMCG_SOCK_ACTIVATED, &cg_proto->flags);
-}
-
 #ifdef SOCK_REFCNT_DEBUG
 static inline void sk_refcnt_debug_inc(struct sock *sk)
 {
diff -puN mm/memcontrol.c~memcg-cleanup-static-keys-decrement mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cleanup-static-keys-decrement
+++ a/mm/memcontrol.c
@@ -519,16 +519,6 @@ struct cg_proto *tcp_proto_cgroup(struct
 }
 EXPORT_SYMBOL(tcp_proto_cgroup);
 
-static void disarm_sock_keys(struct mem_cgroup *memcg)
-{
-	if (!memcg_proto_activated(&memcg->tcp_mem))
-		return;
-	static_key_slow_dec(&memcg_socket_limit_enabled);
-}
-#else
-static void disarm_sock_keys(struct mem_cgroup *memcg)
-{
-}
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
@@ -583,28 +573,8 @@ void memcg_put_cache_ids(void)
 struct static_key memcg_kmem_enabled_key;
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
-static void disarm_kmem_keys(struct mem_cgroup *memcg)
-{
-	if (memcg->kmem_acct_activated)
-		static_key_slow_dec(&memcg_kmem_enabled_key);
-	/*
-	 * This check can't live in kmem destruction function,
-	 * since the charges will outlive the cgroup
-	 */
-	WARN_ON(page_counter_read(&memcg->kmem));
-}
-#else
-static void disarm_kmem_keys(struct mem_cgroup *memcg)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
-static void disarm_static_keys(struct mem_cgroup *memcg)
-{
-	disarm_sock_keys(memcg);
-	disarm_kmem_keys(memcg);
-}
-
 static struct mem_cgroup_per_zone *
 mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
 {
@@ -4092,7 +4062,11 @@ static void memcg_deactivate_kmem(struct
 
 static void memcg_destroy_kmem(struct mem_cgroup *memcg)
 {
-	memcg_destroy_kmem_caches(memcg);
+	if (memcg->kmem_acct_activated) {
+		memcg_destroy_kmem_caches(memcg);
+		static_key_slow_dec(&memcg_kmem_enabled_key);
+		WARN_ON(page_counter_read(&memcg->kmem));
+	}
 	mem_cgroup_sockets_destroy(memcg);
 }
 #else
@@ -4523,8 +4497,6 @@ static void __mem_cgroup_free(struct mem
 		free_mem_cgroup_per_zone_info(memcg, node);
 
 	free_percpu(memcg->stat);
-
-	disarm_static_keys(memcg);
 	kfree(memcg);
 }
 
diff -puN net/ipv4/tcp_memcontrol.c~memcg-cleanup-static-keys-decrement net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~memcg-cleanup-static-keys-decrement
+++ a/net/ipv4/tcp_memcontrol.c
@@ -47,6 +47,10 @@ void tcp_destroy_cgroup(struct mem_cgrou
 		return;
 
 	percpu_counter_destroy(&cg_proto->sockets_allocated);
+
+	if (test_bit(MEMCG_SOCK_ACTIVATED, &cg_proto->flags))
+		static_key_slow_dec(&memcg_socket_limit_enabled);
+
 }
 EXPORT_SYMBOL(tcp_destroy_cgroup);
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
mm-memcontrol-simplify-soft-limit-tree-init-code.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-embed-memcg_cache_params-to-kmem_cache-fix.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
slub-never-fail-to-shrink-cache.patch
slub-fix-kmem_cache_shrink-return-value.patch
slub-make-dead-caches-discard-free-slabs-immediately.patch
vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch
memcg-cleanup-static-keys-decrement.patch

