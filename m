From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch added to -mm tree
Date: Tue, 08 Dec 2015 14:52:07 -0800
Message-ID: <56675f17.swRAinZaGkI9wOui%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbbLHWwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:52:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: move socket code for unified hierarchy accounting
has been added to the -mm tree.  Its filename is
     mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch

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
Subject: mm: memcontrol: move socket code for unified hierarchy accounting

The unified hierarchy memory controller will account socket memory.  Move
the infrastructure functions accordingly.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  148 +++++++++++++++++++++++-----------------------
 1 file changed, 74 insertions(+), 74 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting
+++ a/mm/memcontrol.c
@@ -294,80 +294,6 @@ static inline struct mem_cgroup *mem_cgr
 	return mem_cgroup_from_css(css);
 }
 
-/* Writing them here to avoid exposing memcg's inner layout */
-#if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
-
-struct static_key memcg_sockets_enabled_key;
-EXPORT_SYMBOL(memcg_sockets_enabled_key);
-
-void sock_update_memcg(struct sock *sk)
-{
-	struct mem_cgroup *memcg;
-
-	/* Socket cloning can throw us here with sk_cgrp already
-	 * filled. It won't however, necessarily happen from
-	 * process context. So the test for root memcg given
-	 * the current task's memcg won't help us in this case.
-	 *
-	 * Respecting the original socket's memcg is a better
-	 * decision in this case.
-	 */
-	if (sk->sk_memcg) {
-		BUG_ON(mem_cgroup_is_root(sk->sk_memcg));
-		css_get(&sk->sk_memcg->css);
-		return;
-	}
-
-	rcu_read_lock();
-	memcg = mem_cgroup_from_task(current);
-	if (memcg != root_mem_cgroup &&
-	    memcg->tcp_mem.active &&
-	    css_tryget_online(&memcg->css))
-		sk->sk_memcg = memcg;
-	rcu_read_unlock();
-}
-EXPORT_SYMBOL(sock_update_memcg);
-
-void sock_release_memcg(struct sock *sk)
-{
-	WARN_ON(!sk->sk_memcg);
-	css_put(&sk->sk_memcg->css);
-}
-
-/**
- * mem_cgroup_charge_skmem - charge socket memory
- * @memcg: memcg to charge
- * @nr_pages: number of pages to charge
- *
- * Charges @nr_pages to @memcg. Returns %true if the charge fit within
- * @memcg's configured limit, %false if the charge had to be forced.
- */
-bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	struct page_counter *counter;
-
-	if (page_counter_try_charge(&memcg->tcp_mem.memory_allocated,
-				    nr_pages, &counter)) {
-		memcg->tcp_mem.memory_pressure = 0;
-		return true;
-	}
-	page_counter_charge(&memcg->tcp_mem.memory_allocated, nr_pages);
-	memcg->tcp_mem.memory_pressure = 1;
-	return false;
-}
-
-/**
- * mem_cgroup_uncharge_skmem - uncharge socket memory
- * @memcg - memcg to uncharge
- * @nr_pages - number of pages to uncharge
- */
-void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	page_counter_uncharge(&memcg->tcp_mem.memory_allocated, nr_pages);
-}
-
-#endif
-
 #ifdef CONFIG_MEMCG_KMEM
 /*
  * This will be the memcg's index in each cache's ->memcg_params.memcg_caches.
@@ -5574,6 +5500,80 @@ void mem_cgroup_replace_page(struct page
 	commit_charge(newpage, memcg, true);
 }
 
+/* Writing them here to avoid exposing memcg's inner layout */
+#if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
+
+struct static_key memcg_sockets_enabled_key;
+EXPORT_SYMBOL(memcg_sockets_enabled_key);
+
+void sock_update_memcg(struct sock *sk)
+{
+	struct mem_cgroup *memcg;
+
+	/* Socket cloning can throw us here with sk_cgrp already
+	 * filled. It won't however, necessarily happen from
+	 * process context. So the test for root memcg given
+	 * the current task's memcg won't help us in this case.
+	 *
+	 * Respecting the original socket's memcg is a better
+	 * decision in this case.
+	 */
+	if (sk->sk_memcg) {
+		BUG_ON(mem_cgroup_is_root(sk->sk_memcg));
+		css_get(&sk->sk_memcg->css);
+		return;
+	}
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_task(current);
+	if (memcg != root_mem_cgroup &&
+	    memcg->tcp_mem.active &&
+	    css_tryget_online(&memcg->css))
+		sk->sk_memcg = memcg;
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(sock_update_memcg);
+
+void sock_release_memcg(struct sock *sk)
+{
+	WARN_ON(!sk->sk_memcg);
+	css_put(&sk->sk_memcg->css);
+}
+
+/**
+ * mem_cgroup_charge_skmem - charge socket memory
+ * @memcg: memcg to charge
+ * @nr_pages: number of pages to charge
+ *
+ * Charges @nr_pages to @memcg. Returns %true if the charge fit within
+ * @memcg's configured limit, %false if the charge had to be forced.
+ */
+bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	struct page_counter *counter;
+
+	if (page_counter_try_charge(&memcg->tcp_mem.memory_allocated,
+				    nr_pages, &counter)) {
+		memcg->tcp_mem.memory_pressure = 0;
+		return true;
+	}
+	page_counter_charge(&memcg->tcp_mem.memory_allocated, nr_pages);
+	memcg->tcp_mem.memory_pressure = 1;
+	return false;
+}
+
+/**
+ * mem_cgroup_uncharge_skmem - uncharge socket memory
+ * @memcg - memcg to uncharge
+ * @nr_pages - number of pages to uncharge
+ */
+void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	page_counter_uncharge(&memcg->tcp_mem.memory_allocated, nr_pages);
+}
+
+#endif
+
 /*
  * subsys_initcall() for memory controller.
  *
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

