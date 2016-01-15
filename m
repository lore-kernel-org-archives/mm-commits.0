From: akpm@linux-foundation.org
Subject: [merged]
 net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch removed from
 -mm tree
Date: Fri, 15 Jan 2016 14:34:34 -0800
Message-ID: <569973fa.D8AZaAeomaNJDQ42%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net: tcp_memcontrol: simplify the per-memcg limit access
has been removed from the -mm tree.  Its filename was
     net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: net: tcp_memcontrol: simplify the per-memcg limit access

tcp_memcontrol replicates the global sysctl_mem limit array per cgroup,
but it only ever sets these entries to the value of the memory_allocated
page_counter limit.  Use the latter directly.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 -
 include/net/sock.h         |    8 +++++---
 net/ipv4/tcp_memcontrol.c  |    8 --------
 3 files changed, 5 insertions(+), 12 deletions(-)

diff -puN include/linux/memcontrol.h~net-tcp_memcontrol-simplify-the-per-memcg-limit-access include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~net-tcp_memcontrol-simplify-the-per-memcg-limit-access
+++ a/include/linux/memcontrol.h
@@ -89,7 +89,6 @@ struct cg_proto {
 	struct page_counter	memory_allocated;	/* Current allocated memory. */
 	int			memory_pressure;
 	bool			active;
-	long			sysctl_mem[3];
 	/*
 	 * memcg field is used to find which memcg we belong directly
 	 * Each memcg struct can hold more than one cg_proto, so container_of
diff -puN include/net/sock.h~net-tcp_memcontrol-simplify-the-per-memcg-limit-access include/net/sock.h
--- a/include/net/sock.h~net-tcp_memcontrol-simplify-the-per-memcg-limit-access
+++ a/include/net/sock.h
@@ -1162,10 +1162,12 @@ static inline void sk_enter_memory_press
 
 static inline long sk_prot_mem_limits(const struct sock *sk, int index)
 {
-	long *prot = sk->sk_prot->sysctl_mem;
+	long limit = sk->sk_prot->sysctl_mem[index];
+
 	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
-		prot = sk->sk_cgrp->sysctl_mem;
-	return prot[index];
+		limit = min_t(long, limit, sk->sk_cgrp->memory_allocated.limit);
+
+	return limit;
 }
 
 static inline void memcg_memory_allocated_add(struct cg_proto *prot,
diff -puN net/ipv4/tcp_memcontrol.c~net-tcp_memcontrol-simplify-the-per-memcg-limit-access net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~net-tcp_memcontrol-simplify-the-per-memcg-limit-access
+++ a/net/ipv4/tcp_memcontrol.c
@@ -21,9 +21,6 @@ int tcp_init_cgroup(struct mem_cgroup *m
 	if (!cg_proto)
 		return 0;
 
-	cg_proto->sysctl_mem[0] = sysctl_tcp_mem[0];
-	cg_proto->sysctl_mem[1] = sysctl_tcp_mem[1];
-	cg_proto->sysctl_mem[2] = sysctl_tcp_mem[2];
 	cg_proto->memory_pressure = 0;
 	cg_proto->memcg = memcg;
 
@@ -54,7 +51,6 @@ EXPORT_SYMBOL(tcp_destroy_cgroup);
 static int tcp_update_limit(struct mem_cgroup *memcg, unsigned long nr_pages)
 {
 	struct cg_proto *cg_proto;
-	int i;
 	int ret;
 
 	cg_proto = tcp_prot.proto_cgroup(memcg);
@@ -65,10 +61,6 @@ static int tcp_update_limit(struct mem_c
 	if (ret)
 		return ret;
 
-	for (i = 0; i < 3; i++)
-		cg_proto->sysctl_mem[i] = min_t(long, nr_pages,
-						sysctl_tcp_mem[i]);
-
 	if (!cg_proto->active) {
 		/*
 		 * The active flag needs to be written after the static_key
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

