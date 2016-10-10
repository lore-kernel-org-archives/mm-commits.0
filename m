From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-consolidate-cgroup-socket-tracking.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:45:48 -0700
Message-ID: <57fc1a1c.rotBrb3HHYi7Ia/w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37183 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752183AbcJJWpt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:45:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: consolidate cgroup socket tracking
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-consolidate-cgroup-socket-tracking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: consolidate cgroup socket tracking

The cgroup core and the memory controller need to track socket ownership
for different purposes, but the tracking sites being entirely different is
kind of ugly.

Be a better citizen and rename the memory controller callbacks to match
the cgroup core callbacks, then move them to the same place.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20160914194846.11153-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++--
 mm/memcontrol.c            |   23 +++++++++++++----------
 net/core/sock.c            |    6 +++---
 net/ipv4/tcp.c             |    2 --
 net/ipv4/tcp_ipv4.c        |    3 ---
 5 files changed, 20 insertions(+), 20 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-consolidate-cgroup-socket-tracking include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-consolidate-cgroup-socket-tracking
+++ a/include/linux/memcontrol.h
@@ -773,13 +773,13 @@ static inline void mem_cgroup_wb_stats(s
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 struct sock;
-void sock_update_memcg(struct sock *sk);
-void sock_release_memcg(struct sock *sk);
 bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 #ifdef CONFIG_MEMCG
 extern struct static_key_false memcg_sockets_enabled_key;
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
+void mem_cgroup_sk_alloc(struct sock *sk);
+void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
@@ -792,6 +792,8 @@ static inline bool mem_cgroup_under_sock
 }
 #else
 #define mem_cgroup_sockets_enabled 0
+static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
+static inline void mem_cgroup_sk_free(struct sock *sk) { };
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	return false;
diff -puN mm/memcontrol.c~mm-memcontrol-consolidate-cgroup-socket-tracking mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-consolidate-cgroup-socket-tracking
+++ a/mm/memcontrol.c
@@ -2939,16 +2939,16 @@ static int memcg_update_tcp_limit(struct
 		/*
 		 * The active flag needs to be written after the static_key
 		 * update. This is what guarantees that the socket activation
-		 * function is the last one to run. See sock_update_memcg() for
-		 * details, and note that we don't mark any socket as belonging
-		 * to this memcg until that flag is up.
+		 * function is the last one to run. See mem_cgroup_sk_alloc()
+		 * for details, and note that we don't mark any socket as
+		 * belonging to this memcg until that flag is up.
 		 *
 		 * We need to do this, because static_keys will span multiple
 		 * sites, but we can't control their order. If we mark a socket
 		 * as accounted, but the accounting functions are not patched in
 		 * yet, we'll lose accounting.
 		 *
-		 * We never race with the readers in sock_update_memcg(),
+		 * We never race with the readers in mem_cgroup_sk_alloc(),
 		 * because when this value change, the code to process it is not
 		 * patched in yet.
 		 */
@@ -5651,11 +5651,15 @@ void mem_cgroup_migrate(struct page *old
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
 EXPORT_SYMBOL(memcg_sockets_enabled_key);
 
-void sock_update_memcg(struct sock *sk)
+void mem_cgroup_sk_alloc(struct sock *sk)
 {
 	struct mem_cgroup *memcg;
 
-	/* Socket cloning can throw us here with sk_cgrp already
+	if (!mem_cgroup_sockets_enabled)
+		return;
+
+	/*
+	 * Socket cloning can throw us here with sk_memcg already
 	 * filled. It won't however, necessarily happen from
 	 * process context. So the test for root memcg given
 	 * the current task's memcg won't help us in this case.
@@ -5680,12 +5684,11 @@ void sock_update_memcg(struct sock *sk)
 out:
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(sock_update_memcg);
 
-void sock_release_memcg(struct sock *sk)
+void mem_cgroup_sk_free(struct sock *sk)
 {
-	WARN_ON(!sk->sk_memcg);
-	css_put(&sk->sk_memcg->css);
+	if (sk->sk_memcg)
+		css_put(&sk->sk_memcg->css);
 }
 
 /**
diff -puN net/core/sock.c~mm-memcontrol-consolidate-cgroup-socket-tracking net/core/sock.c
--- a/net/core/sock.c~mm-memcontrol-consolidate-cgroup-socket-tracking
+++ a/net/core/sock.c
@@ -1363,6 +1363,7 @@ static void sk_prot_free(struct proto *p
 	slab = prot->slab;
 
 	cgroup_sk_free(&sk->sk_cgrp_data);
+	mem_cgroup_sk_free(sk);
 	security_sk_free(sk);
 	if (slab != NULL)
 		kmem_cache_free(slab, sk);
@@ -1399,6 +1400,7 @@ struct sock *sk_alloc(struct net *net, i
 		sock_net_set(sk, net);
 		atomic_set(&sk->sk_wmem_alloc, 1);
 
+		mem_cgroup_sk_alloc(sk);
 		cgroup_sk_alloc(&sk->sk_cgrp_data);
 		sock_update_classid(&sk->sk_cgrp_data);
 		sock_update_netprioidx(&sk->sk_cgrp_data);
@@ -1545,6 +1547,7 @@ struct sock *sk_clone_lock(const struct
 		newsk->sk_incoming_cpu = raw_smp_processor_id();
 		atomic64_set(&newsk->sk_cookie, 0);
 
+		mem_cgroup_sk_alloc(newsk);
 		cgroup_sk_alloc(&newsk->sk_cgrp_data);
 
 		/*
@@ -1569,9 +1572,6 @@ struct sock *sk_clone_lock(const struct
 		sk_set_socket(newsk, NULL);
 		newsk->sk_wq = NULL;
 
-		if (mem_cgroup_sockets_enabled && sk->sk_memcg)
-			sock_update_memcg(newsk);
-
 		if (newsk->sk_prot->sockets_allocated)
 			sk_sockets_allocated_inc(newsk);
 
diff -puN net/ipv4/tcp.c~mm-memcontrol-consolidate-cgroup-socket-tracking net/ipv4/tcp.c
--- a/net/ipv4/tcp.c~mm-memcontrol-consolidate-cgroup-socket-tracking
+++ a/net/ipv4/tcp.c
@@ -424,8 +424,6 @@ void tcp_init_sock(struct sock *sk)
 	sk->sk_rcvbuf = sysctl_tcp_rmem[1];
 
 	local_bh_disable();
-	if (mem_cgroup_sockets_enabled)
-		sock_update_memcg(sk);
 	sk_sockets_allocated_inc(sk);
 	local_bh_enable();
 }
diff -puN net/ipv4/tcp_ipv4.c~mm-memcontrol-consolidate-cgroup-socket-tracking net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~mm-memcontrol-consolidate-cgroup-socket-tracking
+++ a/net/ipv4/tcp_ipv4.c
@@ -1871,9 +1871,6 @@ void tcp_v4_destroy_sock(struct sock *sk
 	local_bh_disable();
 	sk_sockets_allocated_dec(sk);
 	local_bh_enable();
