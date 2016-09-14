From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-make-per-cpu-charge-cache-irq-safe-for-socket-accounting.patch added to -mm tree
Date: Wed, 14 Sep 2016 13:41:10 -0700
Message-ID: <57d9b5e6.gFIn8U4vxtSVpdCi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41021 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756664AbcINUlM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2016 16:41:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@fb.com, davem@davemloft.net, hannes@cmpxchg.org, mhocko@suse.cz, stable@vger.kernel.org, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: make per-cpu charge cache IRQ-safe for socket accounting
has been added to the -mm tree.  Its filename is
     mm-memcontrol-make-per-cpu-charge-cache-irq-safe-for-socket-accounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-make-per-cpu-charge-cache-irq-safe-for-socket-accounting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-make-per-cpu-charge-cache-irq-safe-for-socket-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <jweiner@fb.com>
Subject: mm: memcontrol: make per-cpu charge cache IRQ-safe for socket accounting

During cgroup2 rollout into production, we started encountering css
refcount underflows and css access crashes in the memory controller. 
Splitting the heavily shared css reference counter into logical users
narrowed the imbalance down to the cgroup2 socket memory accounting.

The problem turns out to be the per-cpu charge cache.  Cgroup1 had a
separate socket counter, but the new cgroup2 socket accounting goes
through the common charge path that uses a shared per-cpu cache for all
memory that is being tracked.  Those caches are safe against scheduling
preemption, but not against interrupts - such as the newly added packet
receive path.  When cache draining is interrupted by network RX taking
pages out of the cache, the resuming drain operation will put references
of in-use pages, thus causing the imbalance.

Disable IRQs during all per-cpu charge cache operations.

Fixes: f7e1cb6ec51b ("mm: memcontrol: account socket memory in unified hierarchy memory controller")
Link: http://lkml.kernel.org/r/20160914194846.11153-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: <stable@vger.kernel.org>	[4.5+]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-make-per-cpu-charge-cache-irq-safe-for-socket-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-make-per-cpu-charge-cache-irq-safe-for-socket-accounting
+++ a/mm/memcontrol.c
@@ -1740,17 +1740,22 @@ static DEFINE_MUTEX(percpu_charge_mutex)
 static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	struct memcg_stock_pcp *stock;
+	unsigned long flags;
 	bool ret = false;
 
 	if (nr_pages > CHARGE_BATCH)
 		return ret;
 
-	stock = &get_cpu_var(memcg_stock);
+	local_irq_save(flags);
+
+	stock = this_cpu_ptr(&memcg_stock);
 	if (memcg == stock->cached && stock->nr_pages >= nr_pages) {
 		stock->nr_pages -= nr_pages;
 		ret = true;
 	}
-	put_cpu_var(memcg_stock);
+
+	local_irq_restore(flags);
+
 	return ret;
 }
 
@@ -1771,15 +1776,18 @@ static void drain_stock(struct memcg_sto
 	stock->cached = NULL;
 }
 
-/*
- * This must be called under preempt disabled or must be called by
- * a thread which is pinned to local cpu.
- */
 static void drain_local_stock(struct work_struct *dummy)
 {
-	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
+	struct memcg_stock_pcp *stock;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	stock = this_cpu_ptr(&memcg_stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
+
+	local_irq_restore(flags);
 }
 
 /*
@@ -1788,14 +1796,19 @@ static void drain_local_stock(struct wor
  */
 static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
-	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
+	struct memcg_stock_pcp *stock;
+	unsigned long flags;
+
+	local_irq_save(flags);
 
+	stock = this_cpu_ptr(&memcg_stock);
 	if (stock->cached != memcg) { /* reset if necessary */
 		drain_stock(stock);
 		stock->cached = memcg;
 	}
 	stock->nr_pages += nr_pages;
-	put_cpu_var(memcg_stock);
+
+	local_irq_restore(flags);
 }
 
 /*
_

Patches currently in -mm which might be from jweiner@fb.com are

mm-memcontrol-make-per-cpu-charge-cache-irq-safe-for-socket-accounting.patch
cgroup-duplicate-cgroup-reference-when-cloning-sockets.patch

