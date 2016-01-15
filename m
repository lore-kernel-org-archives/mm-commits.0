From: akpm@linux-foundation.org
Subject: [merged]
 net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:34:30 -0800
Message-ID: <569973f6.XWctBAG4RdwAldfT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net: tcp_memcontrol: protect all tcp_memcontrol calls by jump-label
has been removed from the -mm tree.  Its filename was
     net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1507,12 +1507,6 @@ void sk_free(struct sock *sk)
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
@@ -1607,7 +1601,8 @@ struct sock *sk_clone_lock(const struct
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
@@ -1818,7 +1818,9 @@ void tcp_v4_destroy_sock(struct sock *sk
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

