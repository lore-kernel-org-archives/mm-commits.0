From: akpm@linux-foundation.org
Subject: +
 net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
 added to -mm tree
Date: Tue, 08 Dec 2015 14:51:55 -0800
Message-ID: <56675f0b.5x8JyXSZJ5fQfQn4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbbLHWv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:51:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net: tcp_memcontrol: remove dead per-memcg count of allocated sockets
has been added to the -mm tree.  Its filename is
     net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch

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
Subject: net: tcp_memcontrol: remove dead per-memcg count of allocated sockets

The number of allocated sockets is used for calculations in the soft limit
phase, where packets are accepted but the socket is under memory pressure.
 Since there is no soft limit phase in tcp_memcontrol, and memory pressure
is only entered when packets are already dropped, this is actually dead
code.  Remove it.

As this is the last user of parent_cg_proto(), remove that too.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 
 include/net/sock.h         |   39 ++---------------------------------
 net/ipv4/tcp_memcontrol.c  |    3 --
 3 files changed, 3 insertions(+), 40 deletions(-)

diff -puN include/linux/memcontrol.h~net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets
+++ a/include/linux/memcontrol.h
@@ -87,7 +87,6 @@ enum mem_cgroup_events_target {
 
 struct cg_proto {
 	struct page_counter	memory_allocated;	/* Current allocated memory. */
-	struct percpu_counter	sockets_allocated;	/* Current number of sockets. */
 	int			memory_pressure;
 	bool			active;
 	long			sysctl_mem[3];
diff -puN include/net/sock.h~net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets include/net/sock.h
--- a/include/net/sock.h~net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets
+++ a/include/net/sock.h
@@ -1096,19 +1096,9 @@ static inline void sk_refcnt_debug_relea
 
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_NET)
 extern struct static_key memcg_socket_limit_enabled;
-static inline struct cg_proto *parent_cg_proto(struct proto *proto,
-					       struct cg_proto *cg_proto)
-{
-	return proto->proto_cgroup(parent_mem_cgroup(cg_proto->memcg));
-}
 #define mem_cgroup_sockets_enabled static_key_false(&memcg_socket_limit_enabled)
 #else
 #define mem_cgroup_sockets_enabled 0
-static inline struct cg_proto *parent_cg_proto(struct proto *proto,
-					       struct cg_proto *cg_proto)
-{
-	return NULL;
-}
 #endif
 
 static inline bool sk_stream_memory_free(const struct sock *sk)
@@ -1234,41 +1224,18 @@ sk_memory_allocated_sub(struct sock *sk,
 
 static inline void sk_sockets_allocated_dec(struct sock *sk)
 {
-	struct proto *prot = sk->sk_prot;
-
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp) {
-		struct cg_proto *cg_proto = sk->sk_cgrp;
-
-		for (; cg_proto; cg_proto = parent_cg_proto(prot, cg_proto))
-			percpu_counter_dec(&cg_proto->sockets_allocated);
-	}
-
-	percpu_counter_dec(prot->sockets_allocated);
+	percpu_counter_dec(sk->sk_prot->sockets_allocated);
 }
 
 static inline void sk_sockets_allocated_inc(struct sock *sk)
 {
-	struct proto *prot = sk->sk_prot;
-
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp) {
-		struct cg_proto *cg_proto = sk->sk_cgrp;
-
-		for (; cg_proto; cg_proto = parent_cg_proto(prot, cg_proto))
-			percpu_counter_inc(&cg_proto->sockets_allocated);
-	}
-
-	percpu_counter_inc(prot->sockets_allocated);
+	percpu_counter_inc(sk->sk_prot->sockets_allocated);
 }
 
 static inline int
 sk_sockets_allocated_read_positive(struct sock *sk)
 {
-	struct proto *prot = sk->sk_prot;
-
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
-		return percpu_counter_read_positive(&sk->sk_cgrp->sockets_allocated);
-
-	return percpu_counter_read_positive(prot->sockets_allocated);
+	return percpu_counter_read_positive(sk->sk_prot->sockets_allocated);
 }
 
 static inline int
diff -puN net/ipv4/tcp_memcontrol.c~net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets
+++ a/net/ipv4/tcp_memcontrol.c
@@ -32,7 +32,6 @@ int tcp_init_cgroup(struct mem_cgroup *m
 		counter_parent = &parent_cg->memory_allocated;
 
 	page_counter_init(&cg_proto->memory_allocated, counter_parent);
-	percpu_counter_init(&cg_proto->sockets_allocated, 0, GFP_KERNEL);
 
 	return 0;
 }
@@ -46,8 +45,6 @@ void tcp_destroy_cgroup(struct mem_cgrou
 	if (!cg_proto)
 		return;
 
-	percpu_counter_destroy(&cg_proto->sockets_allocated);
-
 	if (cg_proto->active)
 		static_key_slow_dec(&memcg_socket_limit_enabled);
 
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

