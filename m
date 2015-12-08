From: akpm@linux-foundation.org
Subject: + mm-memcontrol-generalize-the-socket-accounting-jump-label.patch added to -mm tree
Date: Tue, 08 Dec 2015 14:52:03 -0800
Message-ID: <56675f13.31CHIngNZAdQBO9a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbbLHWwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:52:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: generalize the socket accounting jump label
has been added to the -mm tree.  Its filename is
     mm-memcontrol-generalize-the-socket-accounting-jump-label.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-generalize-the-socket-accounting-jump-label.patch

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
Subject: mm: memcontrol: generalize the socket accounting jump label

The unified hierarchy memory controller is going to use this jump label as
well to control the networking callbacks.  Move it to the memory
controller code and give it a more generic name.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 +++
 include/net/sock.h         |    7 -------
 mm/memcontrol.c            |    3 +++
 net/core/sock.c            |    5 -----
 net/ipv4/tcp_memcontrol.c  |    4 ++--
 5 files changed, 8 insertions(+), 14 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-generalize-the-socket-accounting-jump-label include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-generalize-the-socket-accounting-jump-label
+++ a/include/linux/memcontrol.h
@@ -681,11 +681,14 @@ void sock_release_memcg(struct sock *sk)
 bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
+extern struct static_key memcg_sockets_enabled_key;
+#define mem_cgroup_sockets_enabled static_key_false(&memcg_sockets_enabled_key)
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	return memcg->tcp_mem.memory_pressure;
 }
 #else
+#define mem_cgroup_sockets_enabled 0
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	return false;
diff -puN include/net/sock.h~mm-memcontrol-generalize-the-socket-accounting-jump-label include/net/sock.h
--- a/include/net/sock.h~mm-memcontrol-generalize-the-socket-accounting-jump-label
+++ a/include/net/sock.h
@@ -1066,13 +1066,6 @@ static inline void sk_refcnt_debug_relea
 #define sk_refcnt_debug_release(sk) do { } while (0)
 #endif /* SOCK_REFCNT_DEBUG */
 
-#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_NET)
-extern struct static_key memcg_socket_limit_enabled;
-#define mem_cgroup_sockets_enabled static_key_false(&memcg_socket_limit_enabled)
-#else
-#define mem_cgroup_sockets_enabled 0
-#endif
-
 static inline bool sk_stream_memory_free(const struct sock *sk)
 {
 	if (sk->sk_wmem_queued >= sk->sk_sndbuf)
diff -puN mm/memcontrol.c~mm-memcontrol-generalize-the-socket-accounting-jump-label mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-generalize-the-socket-accounting-jump-label
+++ a/mm/memcontrol.c
@@ -291,6 +291,9 @@ static inline struct mem_cgroup *mem_cgr
 /* Writing them here to avoid exposing memcg's inner layout */
 #if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
 
+struct static_key memcg_sockets_enabled_key;
+EXPORT_SYMBOL(memcg_sockets_enabled_key);
+
 void sock_update_memcg(struct sock *sk)
 {
 	struct mem_cgroup *memcg;
diff -puN net/core/sock.c~mm-memcontrol-generalize-the-socket-accounting-jump-label net/core/sock.c
--- a/net/core/sock.c~mm-memcontrol-generalize-the-socket-accounting-jump-label
+++ a/net/core/sock.c
@@ -201,11 +201,6 @@ EXPORT_SYMBOL(sk_net_capable);
 static struct lock_class_key af_family_keys[AF_MAX];
 static struct lock_class_key af_family_slock_keys[AF_MAX];
 
-#if defined(CONFIG_MEMCG_KMEM)
-struct static_key memcg_socket_limit_enabled;
-EXPORT_SYMBOL(memcg_socket_limit_enabled);
-#endif
-
 /*
  * Make lock validator output more readable. (we pre-construct these
  * strings build-time, so that runtime initialization of socket
diff -puN net/ipv4/tcp_memcontrol.c~mm-memcontrol-generalize-the-socket-accounting-jump-label net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~mm-memcontrol-generalize-the-socket-accounting-jump-label
+++ a/net/ipv4/tcp_memcontrol.c
@@ -34,7 +34,7 @@ void tcp_destroy_cgroup(struct mem_cgrou
 		return;
 
 	if (memcg->tcp_mem.active)
-		static_key_slow_dec(&memcg_socket_limit_enabled);
+		static_key_slow_dec(&memcg_sockets_enabled_key);
 }
 
 static int tcp_update_limit(struct mem_cgroup *memcg, unsigned long nr_pages)
@@ -65,7 +65,7 @@ static int tcp_update_limit(struct mem_c
 		 * because when this value change, the code to process it is not
 		 * patched in yet.
 		 */
-		static_key_slow_inc(&memcg_socket_limit_enabled);
+		static_key_slow_inc(&memcg_sockets_enabled_key);
 		memcg->tcp_mem.active = true;
 	}
 
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

