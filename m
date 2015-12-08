From: akpm@linux-foundation.org
Subject: + net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
 added to -mm tree
Date: Tue, 08 Dec 2015 14:51:57 -0800
Message-ID: <56675f0d.1OabDKTvvcIHKnn/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbbLHWv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:51:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net: tcp_memcontrol: simplify the per-memcg limit access
has been added to the -mm tree.  Its filename is
     net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch

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
@@ -1160,10 +1160,12 @@ static inline void sk_enter_memory_press
 
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

