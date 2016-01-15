From: akpm@linux-foundation.org
Subject: [merged]
 memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:33:28 -0800
Message-ID: <569973b8.Ydt2cC7+uygQziVO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbcAOWd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: do not allow to disable tcp accounting after limit is set
has been removed from the -mm tree.  Its filename was
     memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: memcg: do not allow to disable tcp accounting after limit is set

There are two bits defined for cg_proto->flags - MEMCG_SOCK_ACTIVATED and
MEMCG_SOCK_ACTIVE - both are set in tcp_update_limit, but the former is
never cleared while the latter can be cleared by unsetting the limit. 
This allows to disable tcp socket accounting for new sockets after it was
enabled by writing -1 to memory.kmem.tcp.limit_in_bytes while still
guaranteeing that memcg_socket_limit_enabled static key will be
decremented on memcg destruction.

This functionality looks dubious, because it is not clear what a use case
would be.  By enabling tcp accounting a user accepts the price.  If they
then find the performance degradation unacceptable, they can always
restart their workload with tcp accounting disabled.  It does not seem
there is any need to flip it while the workload is running.

Besides, it contradicts to how kmem accounting API works: writing whatever
to memory.kmem.limit_in_bytes enables kmem accounting for the cgroup in
question, after which it cannot be disabled.  Therefore one might expect
that writing -1 to memory.kmem.tcp.limit_in_bytes just enables socket
accounting w/o limiting it, which might be useful by itself, but it isn't
true.

Since this API peculiarity is not documented anywhere, I propose to drop
it.  This will allow to simplify the code by dropping cg_proto->flags.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 +-----------
 mm/memcontrol.c            |    2 +-
 net/ipv4/tcp_memcontrol.c  |   17 +++++------------
 3 files changed, 7 insertions(+), 24 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set
+++ a/include/linux/memcontrol.h
@@ -85,22 +85,12 @@ enum mem_cgroup_events_target {
 	MEM_CGROUP_NTARGETS,
 };
 
-/*
- * Bits in struct cg_proto.flags
- */
-enum cg_proto_flags {
-	/* Currently active and new sockets should be assigned to cgroups */
-	MEMCG_SOCK_ACTIVE,
-	/* It was ever activated; we must disarm static keys on destruction */
-	MEMCG_SOCK_ACTIVATED,
-};
-
 struct cg_proto {
 	struct page_counter	memory_allocated;	/* Current allocated memory. */
 	struct percpu_counter	sockets_allocated;	/* Current number of sockets. */
 	int			memory_pressure;
+	bool			active;
 	long			sysctl_mem[3];
-	unsigned long		flags;
 	/*
 	 * memcg field is used to find which memcg we belong directly
 	 * Each memcg struct can hold more than one cg_proto, so container_of
diff -puN mm/memcontrol.c~memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set
+++ a/mm/memcontrol.c
@@ -316,7 +316,7 @@ void sock_update_memcg(struct sock *sk)
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
 		cg_proto = sk->sk_prot->proto_cgroup(memcg);
-		if (cg_proto && test_bit(MEMCG_SOCK_ACTIVE, &cg_proto->flags) &&
+		if (cg_proto && cg_proto->active &&
 		    css_tryget_online(&memcg->css)) {
 			sk->sk_cgrp = cg_proto;
 		}
diff -puN net/ipv4/tcp_memcontrol.c~memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set
+++ a/net/ipv4/tcp_memcontrol.c
@@ -48,7 +48,7 @@ void tcp_destroy_cgroup(struct mem_cgrou
 
 	percpu_counter_destroy(&cg_proto->sockets_allocated);
 
-	if (test_bit(MEMCG_SOCK_ACTIVATED, &cg_proto->flags))
+	if (cg_proto->active)
 		static_key_slow_dec(&memcg_socket_limit_enabled);
 
 }
@@ -72,11 +72,9 @@ static int tcp_update_limit(struct mem_c
 		cg_proto->sysctl_mem[i] = min_t(long, nr_pages,
 						sysctl_tcp_mem[i]);
 
-	if (nr_pages == PAGE_COUNTER_MAX)
-		clear_bit(MEMCG_SOCK_ACTIVE, &cg_proto->flags);
-	else {
+	if (!cg_proto->active) {
 		/*
-		 * The active bit needs to be written after the static_key
+		 * The active flag needs to be written after the static_key
 		 * update. This is what guarantees that the socket activation
 		 * function is the last one to run. See sock_update_memcg() for
 		 * details, and note that we don't mark any socket as belonging
@@ -90,14 +88,9 @@ static int tcp_update_limit(struct mem_c
 		 * We never race with the readers in sock_update_memcg(),
 		 * because when this value change, the code to process it is not
 		 * patched in yet.
-		 *
-		 * The activated bit is used to guarantee that no two writers
-		 * will do the update in the same memcg. Without that, we can't
-		 * properly shutdown the static key.
 		 */
-		if (!test_and_set_bit(MEMCG_SOCK_ACTIVATED, &cg_proto->flags))
-			static_key_slow_inc(&memcg_socket_limit_enabled);
-		set_bit(MEMCG_SOCK_ACTIVE, &cg_proto->flags);
+		static_key_slow_inc(&memcg_socket_limit_enabled);
+		cg_proto->active = true;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-add-page_check_address_transhuge-helper.patch
mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch
net-drop-tcp_memcontrolc.patch
mm-memcontrol-charge-swap-to-cgroup2.patch
mm-vmscan-pass-memcg-to-get_scan_count.patch
mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch
swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch
mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch
mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch
documentation-cgroup-add-memoryswapcurrentmax-description.patch

