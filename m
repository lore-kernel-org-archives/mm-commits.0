From: akpm@linux-foundation.org
Subject: +
 net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch added to
 -mm tree
Date: Tue, 08 Dec 2015 14:51:59 -0800
Message-ID: <56675f0f.3sBJQGtZMMpoBaV2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbbLHWwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:52:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net: tcp_memcontrol: sanitize tcp memory accounting callbacks
has been added to the -mm tree.  Its filename is
     net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch

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
Subject: net: tcp_memcontrol: sanitize tcp memory accounting callbacks

There won't be a tcp control soft limit, so integrating the memcg code
into the global skmem limiting scheme complicates things unnecessarily. 
Replace this with simple and clear charge and uncharge calls--hidden
behind a jump label--to account skb memory.

Note that this is not purely aesthetic: as a result of shoehorning the
per-memcg code into the same memory accounting functions that handle the
global level, the old code would compare the per-memcg consumption against
the smaller of the per-memcg limit and the global limit.  This allowed the
total consumption of multiple sockets to exceed the global limit, as long
as the individual sockets stayed within bounds.  After this change, the
code will always compare the per-memcg consumption to the per-memcg limit,
and the global consumption to the global limit, and thus close this
loophole.

Without a soft limit, the per-memcg memory pressure state in sockets is
generally questionable.  However, we did it until now, so we continue to
enter it when the hard limit is hit, and packets are dropped, to let other
sockets in the cgroup know that they shouldn't grow their transmit
windows, either.  However, keep it simple in the new callback model and
leave memory pressure lazily when the next packet is accepted (as opposed
to doing it synchroneously when packets are processed).  When packets are
dropped, network performance will already be in the toilet, so that should
be a reasonable trade-off.

As described above, consumption is now checked on the per-memcg level and
the global level separately.  Likewise, memory pressure states are
maintained on both the per-memcg level and the global level, and a socket
is considered under pressure when either level asserts as much.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   19 +++++++---
 include/net/sock.h         |   64 ++++-------------------------------
 include/net/tcp.h          |    5 +-
 mm/memcontrol.c            |   32 +++++++++++++++++
 net/core/sock.c            |   26 ++++++++------
 net/ipv4/tcp_output.c      |    7 ++-
 6 files changed, 77 insertions(+), 76 deletions(-)

diff -puN include/linux/memcontrol.h~net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks
+++ a/include/linux/memcontrol.h
@@ -660,12 +660,6 @@ void mem_cgroup_count_vm_event(struct mm
 }
 #endif /* CONFIG_MEMCG */
 
-enum {
-	UNDER_LIMIT,
-	SOFT_LIMIT,
-	OVER_LIMIT,
-};
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 struct list_head *mem_cgroup_cgwb_list(struct mem_cgroup *memcg);
@@ -694,6 +688,19 @@ static inline void mem_cgroup_wb_stats(s
 struct sock;
 void sock_update_memcg(struct sock *sk);
 void sock_release_memcg(struct sock *sk);
+bool mem_cgroup_charge_skmem(struct cg_proto *proto, unsigned int nr_pages);
+void mem_cgroup_uncharge_skmem(struct cg_proto *proto, unsigned int nr_pages);
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
+static inline bool mem_cgroup_under_socket_pressure(struct cg_proto *proto)
+{
+	return proto->memory_pressure;
+}
+#else
+static inline bool mem_cgroup_under_pressure(struct cg_proto *proto)
+{
+	return false;
+}
+#endif
 
 #ifdef CONFIG_MEMCG_KMEM
 extern struct static_key memcg_kmem_enabled_key;
diff -puN include/net/sock.h~net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks include/net/sock.h
--- a/include/net/sock.h~net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks
+++ a/include/net/sock.h
@@ -1127,8 +1127,9 @@ static inline bool sk_under_memory_press
 	if (!sk->sk_prot->memory_pressure)
 		return false;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
-		return !!sk->sk_cgrp->memory_pressure;
+	if (mem_cgroup_sockets_enabled && sk->sk_cgrp &&
+	    mem_cgroup_under_socket_pressure(sk->sk_cgrp))
+		return true;
 
 	return !!*sk->sk_prot->memory_pressure;
 }
@@ -1142,9 +1143,6 @@ static inline void sk_leave_memory_press
 
 	if (*memory_pressure)
 		*memory_pressure = 0;
-
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
-		sk->sk_cgrp->memory_pressure = 0;
 }
 
 static inline void sk_enter_memory_pressure(struct sock *sk)
@@ -1152,76 +1150,30 @@ static inline void sk_enter_memory_press
 	if (!sk->sk_prot->enter_memory_pressure)
 		return;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
-		sk->sk_cgrp->memory_pressure = 1;
-
 	sk->sk_prot->enter_memory_pressure(sk);
 }
 
 static inline long sk_prot_mem_limits(const struct sock *sk, int index)
 {
-	long limit = sk->sk_prot->sysctl_mem[index];
-
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
-		limit = min_t(long, limit, sk->sk_cgrp->memory_allocated.limit);
-
-	return limit;
-}
-
-static inline void memcg_memory_allocated_add(struct cg_proto *prot,
-					      unsigned long amt,
-					      int *parent_status)
-{
-	struct page_counter *counter;
-
-	if (page_counter_try_charge(&prot->memory_allocated, amt, &counter))
-		return;
-
-	page_counter_charge(&prot->memory_allocated, amt);
-	*parent_status = OVER_LIMIT;
-}
-
-static inline void memcg_memory_allocated_sub(struct cg_proto *prot,
-					      unsigned long amt)
-{
-	page_counter_uncharge(&prot->memory_allocated, amt);
+	return sk->sk_prot->sysctl_mem[index];
 }
 
 static inline long
 sk_memory_allocated(const struct sock *sk)
 {
-	struct proto *prot = sk->sk_prot;
-
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
-		return page_counter_read(&sk->sk_cgrp->memory_allocated);
-
-	return atomic_long_read(prot->memory_allocated);
+	return atomic_long_read(sk->sk_prot->memory_allocated);
 }
 
 static inline long
-sk_memory_allocated_add(struct sock *sk, int amt, int *parent_status)
+sk_memory_allocated_add(struct sock *sk, int amt)
 {
-	struct proto *prot = sk->sk_prot;
-
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp) {
-		memcg_memory_allocated_add(sk->sk_cgrp, amt, parent_status);
-		/* update the root cgroup regardless */
-		atomic_long_add_return(amt, prot->memory_allocated);
-		return page_counter_read(&sk->sk_cgrp->memory_allocated);
-	}
-
-	return atomic_long_add_return(amt, prot->memory_allocated);
+	return atomic_long_add_return(amt, sk->sk_prot->memory_allocated);
 }
 
 static inline void
 sk_memory_allocated_sub(struct sock *sk, int amt)
 {
-	struct proto *prot = sk->sk_prot;
-
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
-		memcg_memory_allocated_sub(sk->sk_cgrp, amt);
-
-	atomic_long_sub(amt, prot->memory_allocated);
+	atomic_long_sub(amt, sk->sk_prot->memory_allocated);
 }
 
 static inline void sk_sockets_allocated_dec(struct sock *sk)
diff -puN include/net/tcp.h~net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks include/net/tcp.h
--- a/include/net/tcp.h~net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks
+++ a/include/net/tcp.h
@@ -292,8 +292,9 @@ extern int tcp_memory_pressure;
 /* optimized version of sk_under_memory_pressure() for TCP sockets */
 static inline bool tcp_under_memory_pressure(const struct sock *sk)
 {
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
-		return !!sk->sk_cgrp->memory_pressure;
+	if (mem_cgroup_sockets_enabled && sk->sk_cgrp &&
+	    mem_cgroup_under_socket_pressure(sk->sk_cgrp))
+		return true;
 
 	return tcp_memory_pressure;
 }
diff -puN mm/memcontrol.c~net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks mm/memcontrol.c
--- a/mm/memcontrol.c~net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks
+++ a/mm/memcontrol.c
@@ -338,6 +338,38 @@ struct cg_proto *tcp_proto_cgroup(struct
 }
 EXPORT_SYMBOL(tcp_proto_cgroup);
 
+/**
+ * mem_cgroup_charge_skmem - charge socket memory
+ * @proto: proto to charge
+ * @nr_pages: number of pages to charge
+ *
+ * Charges @nr_pages to @proto. Returns %true if the charge fit within
+ * @proto's configured limit, %false if the charge had to be forced.
+ */
+bool mem_cgroup_charge_skmem(struct cg_proto *proto, unsigned int nr_pages)
+{
+	struct page_counter *counter;
+
+	if (page_counter_try_charge(&proto->memory_allocated,
+				    nr_pages, &counter)) {
+		proto->memory_pressure = 0;
+		return true;
+	}
+	page_counter_charge(&proto->memory_allocated, nr_pages);
+	proto->memory_pressure = 1;
+	return false;
+}
+
+/**
+ * mem_cgroup_uncharge_skmem - uncharge socket memory
+ * @proto - proto to uncharge
+ * @nr_pages - number of pages to uncharge
+ */
+void mem_cgroup_uncharge_skmem(struct cg_proto *proto, unsigned int nr_pages)
+{
+	page_counter_uncharge(&proto->memory_allocated, nr_pages);
+}
+
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
diff -puN net/core/sock.c~net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks net/core/sock.c
--- a/net/core/sock.c~net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks
+++ a/net/core/sock.c
@@ -2065,27 +2065,27 @@ int __sk_mem_schedule(struct sock *sk, i
 	struct proto *prot = sk->sk_prot;
 	int amt = sk_mem_pages(size);
 	long allocated;
-	int parent_status = UNDER_LIMIT;
 
 	sk->sk_forward_alloc += amt * SK_MEM_QUANTUM;
 
-	allocated = sk_memory_allocated_add(sk, amt, &parent_status);
+	allocated = sk_memory_allocated_add(sk, amt);
+
+	if (mem_cgroup_sockets_enabled && sk->sk_cgrp &&
+	    !mem_cgroup_charge_skmem(sk->sk_cgrp, amt))
+		goto suppress_allocation;
 
 	/* Under limit. */
-	if (parent_status == UNDER_LIMIT &&
-			allocated <= sk_prot_mem_limits(sk, 0)) {
+	if (allocated <= sk_prot_mem_limits(sk, 0)) {
 		sk_leave_memory_pressure(sk);
 		return 1;
 	}
 
-	/* Under pressure. (we or our parents) */
-	if ((parent_status > SOFT_LIMIT) ||
-			allocated > sk_prot_mem_limits(sk, 1))
+	/* Under pressure. */
+	if (allocated > sk_prot_mem_limits(sk, 1))
 		sk_enter_memory_pressure(sk);
 
-	/* Over hard limit (we or our parents) */
-	if ((parent_status == OVER_LIMIT) ||
-			(allocated > sk_prot_mem_limits(sk, 2)))
+	/* Over hard limit. */
+	if (allocated > sk_prot_mem_limits(sk, 2))
 		goto suppress_allocation;
 
 	/* guarantee minimum buffer size under pressure */
@@ -2134,6 +2134,9 @@ suppress_allocation:
 
 	sk_memory_allocated_sub(sk, amt);
 
+	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
+		mem_cgroup_uncharge_skmem(sk->sk_cgrp, amt);
+
 	return 0;
 }
 EXPORT_SYMBOL(__sk_mem_schedule);
@@ -2149,6 +2152,9 @@ void __sk_mem_reclaim(struct sock *sk, i
 	sk_memory_allocated_sub(sk, amount);
 	sk->sk_forward_alloc -= amount << SK_MEM_QUANTUM_SHIFT;
 
+	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
+		mem_cgroup_uncharge_skmem(sk->sk_cgrp, amount);
+
 	if (sk_under_memory_pressure(sk) &&
 	    (sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)))
 		sk_leave_memory_pressure(sk);
diff -puN net/ipv4/tcp_output.c~net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks net/ipv4/tcp_output.c
--- a/net/ipv4/tcp_output.c~net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks
+++ a/net/ipv4/tcp_output.c
@@ -2813,13 +2813,16 @@ begin_fwd:
  */
 void sk_forced_mem_schedule(struct sock *sk, int size)
 {
-	int amt, status;
+	int amt;
 
 	if (size <= sk->sk_forward_alloc)
 		return;
 	amt = sk_mem_pages(size);
 	sk->sk_forward_alloc += amt * SK_MEM_QUANTUM;
-	sk_memory_allocated_add(sk, amt, &status);
+	sk_memory_allocated_add(sk, amt);
+
+	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
+		mem_cgroup_charge_skmem(sk->sk_cgrp, amt);
 }
 
 /* Send a FIN. The caller locks the socket for us.
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

