From: akpm@linux-foundation.org
Subject: +
 net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
 added to -mm tree
Date: Tue, 08 Dec 2015 14:51:53 -0800
Message-ID: <56675f09.hQSe9JumC7ShCOYV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbbLHWvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:51:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net: tcp_memcontrol: protect all tcp_memcontrol calls by jump-label
has been added to the -mm tree.  Its filename is
     net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch

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
Subject: net: tcp_memcontrol: protect all tcp_memcontrol calls by jump-label

Move the jump-label from sock_update_memcg() and sock_release_memcg() to
the callsite, and so eliminate those function calls when socket accounting
is not enabled.

This also eliminates the need for dummy functions because the calls will
be optimized away if the Kconfig options are not enabled.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 -----
 mm/memcontrol.c            |   62 +++++++++++++++--------------------
 net/core/sock.c            |    9 +----
 net/ipv4/tcp.c             |    3 +
 net/ipv4/tcp_ipv4.c        |    4 +-
 5 files changed, 35 insertions(+), 52 deletions(-)

diff -puN include/linux/memcontrol.h~net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label
+++ a/include/linux/memcontrol.h
@@ -694,17 +694,8 @@ static inline void mem_cgroup_wb_stats(s
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 struct sock;
-#if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
 void sock_update_memcg(struct sock *sk);
 void sock_release_memcg(struct sock *sk);
-#else
-static inline void sock_update_memcg(struct sock *sk)
-{
-}
-static inline void sock_release_memcg(struct sock *sk)
-{
-}
-#endif /* CONFIG_INET && CONFIG_MEMCG_KMEM */
 
 #ifdef CONFIG_MEMCG_KMEM
 extern struct static_key memcg_kmem_enabled_key;
diff -puN mm/memcontrol.c~net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label mm/memcontrol.c
--- a/mm/memcontrol.c~net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label
+++ a/mm/memcontrol.c
@@ -293,46 +293,40 @@ static inline struct mem_cgroup *mem_cgr
 
 void sock_update_memcg(struct sock *sk)
 {
-	if (mem_cgroup_sockets_enabled) {
-		struct mem_cgroup *memcg;
-		struct cg_proto *cg_proto;
-
-		BUG_ON(!sk->sk_prot->proto_cgroup);
-
-		/* Socket cloning can throw us here with sk_cgrp already
-		 * filled. It won't however, necessarily happen from
-		 * process context. So the test for root memcg given
-		 * the current task's memcg won't help us in this case.
-		 *
-		 * Respecting the original socket's memcg is a better
-		 * decision in this case.
-		 */
-		if (sk->sk_cgrp) {
-			BUG_ON(mem_cgroup_is_root(sk->sk_cgrp->memcg));
-			css_get(&sk->sk_cgrp->memcg->css);
-			return;
-		}
-
-		rcu_read_lock();
-		memcg = mem_cgroup_from_task(current);
-		cg_proto = sk->sk_prot->proto_cgroup(memcg);
-		if (cg_proto && cg_proto->active &&
-		    css_tryget_online(&memcg->css)) {
-			sk->sk_cgrp = cg_proto;
-		}
-		rcu_read_unlock();
+	struct mem_cgroup *memcg;
+	struct cg_proto *cg_proto;
+
+	BUG_ON(!sk->sk_prot->proto_cgroup);
+
+	/* Socket cloning can throw us here with sk_cgrp already
+	 * filled. It won't however, necessarily happen from
+	 * process context. So the test for root memcg given
+	 * the current task's memcg won't help us in this case.
+	 *
+	 * Respecting the original socket's memcg is a better
+	 * decision in this case.
+	 */
+	if (sk->sk_cgrp) {
+		BUG_ON(mem_cgroup_is_root(sk->sk_cgrp->memcg));
+		css_get(&sk->sk_cgrp->memcg->css);
+		return;
 	}
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_task(current);
+	cg_proto = sk->sk_prot->proto_cgroup(memcg);
+	if (cg_proto && cg_proto->active &&
+	    css_tryget_online(&memcg->css)) {
+		sk->sk_cgrp = cg_proto;
+	}
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(sock_update_memcg);
 
 void sock_release_memcg(struct sock *sk)
 {
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp) {
-		struct mem_cgroup *memcg;
-		WARN_ON(!sk->sk_cgrp->memcg);
-		memcg = sk->sk_cgrp->memcg;
-		css_put(&sk->sk_cgrp->memcg->css);
-	}
+	WARN_ON(!sk->sk_cgrp->memcg);
+	css_put(&sk->sk_cgrp->memcg->css);
 }
 
 struct cg_proto *tcp_proto_cgroup(struct mem_cgroup *memcg)
diff -puN net/core/sock.c~net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label net/core/sock.c
--- a/net/core/sock.c~net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label
+++ a/net/core/sock.c
@@ -1488,12 +1488,6 @@ void sk_free(struct sock *sk)
 }
 EXPORT_SYMBOL(sk_free);
 
-static void sk_update_clone(const struct sock *sk, struct sock *newsk)
-{
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
-		sock_update_memcg(newsk);
-}
-
 /**
  *	sk_clone_lock - clone a socket, and lock its clone
  *	@sk: the socket to clone
@@ -1588,7 +1582,8 @@ struct sock *sk_clone_lock(const struct
 		sk_set_socket(newsk, NULL);
 		newsk->sk_wq = NULL;
 
-		sk_update_clone(sk, newsk);
+		if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
+			sock_update_memcg(newsk);
 
 		if (newsk->sk_prot->sockets_allocated)
 			sk_sockets_allocated_inc(newsk);
diff -puN net/ipv4/tcp.c~net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label net/ipv4/tcp.c
--- a/net/ipv4/tcp.c~net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label
+++ a/net/ipv4/tcp.c
@@ -422,7 +422,8 @@ void tcp_init_sock(struct sock *sk)
 	sk->sk_rcvbuf = sysctl_tcp_rmem[1];
 
 	local_bh_disable();
-	sock_update_memcg(sk);
+	if (mem_cgroup_sockets_enabled)
+		sock_update_memcg(sk);
 	sk_sockets_allocated_inc(sk);
 	local_bh_enable();
 }
diff -puN net/ipv4/tcp_ipv4.c~net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label
+++ a/net/ipv4/tcp_ipv4.c
@@ -1813,7 +1813,9 @@ void tcp_v4_destroy_sock(struct sock *sk
 	tcp_saved_syn_free(tp);
 
 	sk_sockets_allocated_dec(sk);
-	sock_release_memcg(sk);
+
+	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
+		sock_release_memcg(sk);
 }
 EXPORT_SYMBOL(tcp_v4_destroy_sock);
 
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

