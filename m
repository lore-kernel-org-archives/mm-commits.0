From: akpm@linux-foundation.org
Subject: + mm-memcontrol-consolidate-cgroup-socket-tracking.patch added to -mm tree
Date: Wed, 14 Sep 2016 13:42:08 -0700
Message-ID: <57d9b620.esinWelXNjy7VJKm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41049 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761905AbcINUmJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2016 16:42:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: consolidate cgroup socket tracking
has been added to the -mm tree.  Its filename is
     mm-memcontrol-consolidate-cgroup-socket-tracking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-consolidate-cgroup-socket-tracking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-consolidate-cgroup-socket-tracking.patch

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
Subject: mm: memcontrol: consolidate cgroup socket tracking

The cgroup core and the memory controller need to track socket ownership
for different purposes, but the tracking sites being entirely different is
kind of ugly.

Be a better citizen and rename the memory controller callbacks to match
the cgroup core callbacks, then move them to the same place.

Link: http://lkml.kernel.org/r/20160914194846.11153-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   19 +++++++++++--------
 net/core/sock.c            |    6 +++---
 net/ipv4/tcp.c             |    2 --
 net/ipv4/tcp_ipv4.c        |    3 ---
 5 files changed, 16 insertions(+), 18 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-consolidate-cgroup-socket-tracking include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-consolidate-cgroup-socket-tracking
+++ a/include/linux/memcontrol.h
@@ -773,8 +773,8 @@ static inline void mem_cgroup_wb_stats(s
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 struct sock;
-void sock_update_memcg(struct sock *sk);
-void sock_release_memcg(struct sock *sk);
+void mem_cgroup_sk_alloc(struct sock *sk);
+void mem_cgroup_sk_free(struct sock *sk);
 bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 #ifdef CONFIG_MEMCG
diff -puN mm/memcontrol.c~mm-memcontrol-consolidate-cgroup-socket-tracking mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-consolidate-cgroup-socket-tracking
+++ a/mm/memcontrol.c
@@ -2939,7 +2939,7 @@ static int memcg_update_tcp_limit(struct
 		/*
 		 * The active flag needs to be written after the static_key
 		 * update. This is what guarantees that the socket activation
-		 * function is the last one to run. See sock_update_memcg() for
+		 * function is the last one to run. See mem_cgroup_sk_alloc() for
 		 * details, and note that we don't mark any socket as belonging
 		 * to this memcg until that flag is up.
 		 *
@@ -2948,7 +2948,7 @@ static int memcg_update_tcp_limit(struct
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
@@ -1385,6 +1385,7 @@ static void sk_prot_free(struct proto *p
 	slab = prot->slab;
 
 	cgroup_sk_free(&sk->sk_cgrp_data);
+	mem_cgroup_sk_free(sk);
 	security_sk_free(sk);
 	if (slab != NULL)
 		kmem_cache_free(slab, sk);
@@ -1421,6 +1422,7 @@ struct sock *sk_alloc(struct net *net, i
 		sock_net_set(sk, net);
 		atomic_set(&sk->sk_wmem_alloc, 1);
 
+		mem_cgroup_sk_alloc(sk);
 		cgroup_sk_alloc(&sk->sk_cgrp_data);
 		sock_update_classid(&sk->sk_cgrp_data);
 		sock_update_netprioidx(&sk->sk_cgrp_data);
@@ -1567,6 +1569,7 @@ struct sock *sk_clone_lock(const struct
 		newsk->sk_incoming_cpu = raw_smp_processor_id();
 		atomic64_set(&newsk->sk_cookie, 0);
 
+		mem_cgroup_sk_alloc(newsk);
 		cgroup_sk_alloc(&newsk->sk_cgrp_data);
 
 		/*
@@ -1591,9 +1594,6 @@ struct sock *sk_clone_lock(const struct
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
@@ -421,8 +421,6 @@ void tcp_init_sock(struct sock *sk)
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
@@ -1845,9 +1845,6 @@ void tcp_v4_destroy_sock(struct sock *sk
 	local_bh_disable();
 	sk_sockets_allocated_dec(sk);
 	local_bh_enable();
