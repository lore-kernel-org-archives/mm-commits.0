Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2D31EFF9A
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119354; cv=none; b=Bd78NPBXkyODvB0v5NJvpjsAEr2M+TOZ0bdSygXsbJRzr1WAM9+3Yu5bp5b1Wmx1i800N9RT9RsZni9lknwxUINSBCDrWIYlZs5u5rxmbcE0+G5A7n2JoWZspnEiWg/Cl9nCjLGwD3F4plXDx/86x04302vs4WIf9Mn89qEDkbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119354; c=relaxed/simple;
	bh=nshHYk/oPaayj9uuhlMhHja0Q0OwPWkWAG6VA4Sg1EY=;
	h=Date:To:From:Subject:Message-Id; b=iLbtAED1dvAEV2j53bjTGjhCGJ8OiFtNYabWeOLU08L76VhP4p25IKv575FIjnECnE1nChyXJpSCzC+BGwCm1Ge1F+pkHPpoHA69gMSR1ZB8doW47SzVy9PywlNahp6sasqPA9PqWjYWcbemPbC9/HIdItA6QqMkcyS/X/xyXSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TH/qbXPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TH/qbXPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8FEC4CEEF;
	Tue, 13 May 2025 06:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119354;
	bh=nshHYk/oPaayj9uuhlMhHja0Q0OwPWkWAG6VA4Sg1EY=;
	h=Date:To:From:Subject:From;
	b=TH/qbXPHbHF070/I/kS6/MG9zf9fUwfKTb7AzaZNSWZJ2hF0Z5RHrQ0nb76gYDYwJ
	 EaLQ8aTgE2ozO4yPLqX2GFur3otxi9lnCHJtqh2z9EgujEotHmkT2Cvyf7946IhP1V
	 LPkTAmS3TianKMPiH7N4uVQEUmCh0bMTBjDtjWUQ=
Date: Mon, 12 May 2025 23:55:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,kuba@kernel.org,hannes@cmpxchg.org,edumazet@google.com,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-simplify-consume_stock.patch removed from -mm tree
Message-Id: <20250513065554.0B8FEC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: simplify consume_stock
has been removed from the -mm tree.  Its filename was
     memcg-simplify-consume_stock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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


