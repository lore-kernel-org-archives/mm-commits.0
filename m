From: akpm@linux-foundation.org
Subject: [merged] memcg-cleanup-static-keys-decrement.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 12:20:44 -0800
Message-ID: <54de5c9c.PPY59DFWM/bE8LRP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbbBMUUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, davem@davemloft.net, ebiederm@xmission.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujtisu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: cleanup static keys decrement
has been removed from the -mm tree.  Its filename was
     memcg-cleanup-static-keys-decrement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1077,11 +1077,6 @@ static inline bool memcg_proto_active(st
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

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

