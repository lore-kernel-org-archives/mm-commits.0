Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B4D1DF723
	for <mm-commits@vger.kernel.org>; Tue,  6 May 2025 23:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746573502; cv=none; b=N+uHrtBJh+shHxflvwQjT+P3rt/maYYXzytycxN7+6TZhkZx/ZDxB8GoQyGKWJBNffilSBeZu2aByTygzJKbfgUeoaEchyDWm3R/lMciWBG85CpEJiDEdoT1BTHCpdI5J9LYfDDCA8WnB7T/H4sYlQs84aixoAnur7cJnKTPMjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746573502; c=relaxed/simple;
	bh=ZSomHmf/XI+RqZ3MhVbWgOnc8HjCWZ027ZMlEPhFbVU=;
	h=Date:To:From:Subject:Message-Id; b=GdvW9UhULx3AY4XvrtPEdhxBT8nVghzATMopxdpHoo9m2i69pEnBucTtEv5n0oCS5DN4tfpNvN68KJ0oDnm3mily8yI9/LgYksP4ma+2vSm6vRCM+UeHla5bzQ60eb/HXgaw4EVKkfGAfTsd7aBGOdj30ueSsiuUWwuu8If0AE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m47JYM2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m47JYM2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E53BC4CEE4;
	Tue,  6 May 2025 23:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746573499;
	bh=ZSomHmf/XI+RqZ3MhVbWgOnc8HjCWZ027ZMlEPhFbVU=;
	h=Date:To:From:Subject:From;
	b=m47JYM2VSdRDEak24xNAhiWW0tOHRLsnom6PqSa0JpLLLL/iMhjaD6c5TuoOQnFei
	 QXJdgJw/Y28CYg3y7XQJ7+J0N/a9d41kaYk0SPvsTovgF3rV7flUJSw2YBapAaAGxs
	 Psa6PZXWyKoNRPGj0pUMeQtGpmfCR/QbR0JEs+hs=
Date: Tue, 06 May 2025 16:18:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,kuba@kernel.org,hannes@cmpxchg.org,edumazet@google.com,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-simplify-consume_stock.patch added to mm-new branch
Message-Id: <20250506231819.9E53BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: simplify consume_stock
has been added to the -mm mm-new branch.  Its filename is
     memcg-simplify-consume_stock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-simplify-consume_stock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: simplify consume_stock
Date: Tue, 6 May 2025 15:55:30 -0700

Patch series "memcg: decouple memcg and objcg stocks", v3.

The per-cpu memcg charge cache and objcg charge cache are coupled in a
single struct memcg_stock_pcp and a single local lock is used to protect
both of the caches.  This makes memcg charging and objcg charging nmi safe
challenging.  Decoupling memcg and objcg stocks would allow us to make
them nmi safe and even work without disabling irqs independently.  This
series completely decouples memcg and objcg stocks.

To evaluate the impact of this series with and without PREEMPT_RT config,
we ran varying number of netperf clients in different cgroups on a 72 CPU
machine.

 $ netserver -6
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

PREEMPT_RT config:
------------------
number of clients | Without series | With series
  6               | 38559.1 Mbps   | 38652.6 Mbps
  12              | 37388.8 Mbps   | 37560.1 Mbps
  18              | 30707.5 Mbps   | 31378.3 Mbps
  24              | 25908.4 Mbps   | 26423.9 Mbps
  30              | 22347.7 Mbps   | 22326.5 Mbps
  36              | 20235.1 Mbps   | 20165.0 Mbps

!PREEMPT_RT config:
-------------------
number of clients | Without series | With series
  6               | 50235.7 Mbps   | 51415.4 Mbps
  12              | 49336.5 Mbps   | 49901.4 Mbps
  18              | 46306.8 Mbps   | 46482.7 Mbps
  24              | 38145.7 Mbps   | 38729.4 Mbps
  30              | 30347.6 Mbps   | 31698.2 Mbps
  36              | 26976.6 Mbps   | 27364.4 Mbps

No performance regression was observed.


This patch (of 4):

consume_stock() does not need to check gfp_mask for spinning and can
simply trylock the local lock to decide to proceed or fail.  No need to
spin at all for local lock.

One of the concern raised was that on PREEMPT_RT kernels, this trylock can
fail more often due to tasks having lock_lock can be preempted.  This can
potentially cause the task which have preempted the task having the
local_lock to take the slow path of memcg charging.

However this behavior will only impact the performance if memcg charging
slowpath is worse than two context switches and possibly scheduling delay
behavior of current code.  From the network intensive workload experiment
it does not seem like the case.

We ran varying number of netperf clients in different cgroups on a 72 CPU
machine for PREEMPT_RT config.

 $ netserver -6
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

number of clients | Without series | With series
  6               | 38559.1 Mbps   | 38652.6 Mbps
  12              | 37388.8 Mbps   | 37560.1 Mbps
  18              | 30707.5 Mbps   | 31378.3 Mbps
  24              | 25908.4 Mbps   | 26423.9 Mbps
  30              | 22347.7 Mbps   | 22326.5 Mbps
  36              | 20235.1 Mbps   | 20165.0 Mbps

We don't see any significant performance difference for the network
intensive workload with this series.

Link: https://lkml.kernel.org/r/20250506225533.2580386-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20250506225533.2580386-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/mm/memcontrol.c~memcg-simplify-consume_stock
+++ a/mm/memcontrol.c
@@ -1831,16 +1831,14 @@ static bool obj_stock_flush_required(str
  * consume_stock: Try to consume stocked charge on this cpu.
  * @memcg: memcg to consume from.
  * @nr_pages: how many pages to charge.
- * @gfp_mask: allocation mask.
  *
- * The charges will only happen if @memcg matches the current cpu's memcg
- * stock, and at least @nr_pages are available in that stock.  Failure to
- * service an allocation will refill the stock.
+ * Consume the cached charge if enough nr_pages are present otherwise return
+ * failure. Also return failure for charge request larger than
+ * MEMCG_CHARGE_BATCH or if the local lock is already taken.
  *
  * returns true if successful, false otherwise.
  */
-static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages,
-			  gfp_t gfp_mask)
+static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	struct memcg_stock_pcp *stock;
 	uint8_t stock_pages;
@@ -1848,12 +1846,8 @@ static bool consume_stock(struct mem_cgr
 	bool ret = false;
 	int i;
 
-	if (nr_pages > MEMCG_CHARGE_BATCH)
-		return ret;
-
-	if (gfpflags_allow_spinning(gfp_mask))
-		local_lock_irqsave(&memcg_stock.stock_lock, flags);
-	else if (!local_trylock_irqsave(&memcg_stock.stock_lock, flags))
+	if (nr_pages > MEMCG_CHARGE_BATCH ||
+	    !local_trylock_irqsave(&memcg_stock.stock_lock, flags))
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -2356,7 +2350,7 @@ static int try_charge_memcg(struct mem_c
 	unsigned long pflags;
 
 retry:
-	if (consume_stock(memcg, nr_pages, gfp_mask))
+	if (consume_stock(memcg, nr_pages))
 		return 0;
 
 	if (!gfpflags_allow_spinning(gfp_mask))
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch
memcg-remove-root-memcg-check-from-refill_stock.patch
memcg-decouple-drain_obj_stock-from-local-stock.patch
memcg-introduce-memcg_uncharge.patch
memcg-manually-inline-__refill_stock.patch
memcg-no-refilling-stock-from-obj_cgroup_release.patch
memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch
memcg-use-__mod_memcg_state-in-drain_obj_stock.patch
memcg-manually-inline-replace_stock_objcg.patch
memcg-optimize-memcg_rstat_updated.patch
memcg-multi-memcg-percpu-charge-cache.patch
memcg-multi-memcg-percpu-charge-cache-fix.patch
memcg-multi-memcg-percpu-charge-cache-fix-2.patch
memcg-multi-memcg-percpu-charge-cache-fix-4.patch
memcg-introduce-non-blocking-limit-setting-option.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

