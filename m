Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11213AD52E
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 20:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779741147; cv=none; b=IpSV5RBQPeACenOi7+89P/UjRaBjvBG2GyY0YkUxRZw5omeyy2f9/XImhO9V1Rm7Wq0bxAgPWjVE4/BXAHgihUOcqAoaSLR7+OJnybDe1Uqi+d1ICsM/9ATzV/qiyKUJmxdCztiIsj5b7vu42YQ/BnidMOyQ8JlVeKDFm+8QD6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779741147; c=relaxed/simple;
	bh=CTLWGtYY0T1uwnOJRM7ODRmx7ndImTcP0i7zGYNkExs=;
	h=Date:To:From:Subject:Message-Id; b=NwyDIgB4ORRNTKnxixAFAtpU0R8F4JmsB2liGQzJjhvGNCdqS4fb3HHj5MMe8wOuspUicM3P80OYPuohiKnblQr6WA6jNe9ZKIyhcdM+riFh9DBTYcm3pUcMoKYkHsS5myvFpRhniTa2xEpkR2tmn4dNKmqcosrP6Po/PeA+xMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z9ae/gxV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z9ae/gxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A661F00A3A;
	Mon, 25 May 2026 20:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779741145;
	bh=T+1Kl0r4X3v245Spad+88FvBca0W9V/21gycxDFLavY=;
	h=Date:To:From:Subject;
	b=Z9ae/gxV7REiavAshrRtWyBC3fAKlneOPUozIlig+uOR+4Qp/ZVmlLrmwVc838jRQ
	 +PSp7AEyFQKl38SKcriQBlB1CZhWja0OanAd9VAL8+ts4uJgrxlK+V8bnAbbfsupNY
	 jCK3gJCxQatP3bWQ6/4d3TBbl4gI6JIp71rkVTcs=
Date: Mon, 25 May 2026 13:32:25 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memcg-int16_t-for-cached-slab-stats.patch removed from -mm tree
Message-Id: <20260525203225.73A661F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: int16_t for cached slab stats
has been removed from the -mm tree.  Its filename was
     memcg-int16_t-for-cached-slab-stats.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: int16_t for cached slab stats
Date: Thu, 21 May 2026 18:19:07 -0700

Currently struct obj_stock_pcp stores cached slab stats in 'int' which is
4 bytes per counter on 64-bit machines.  Switch them to int16_t to shrink
the cached metadata.

The existing PAGE_SIZE flush in __account_obj_stock() bounds *bytes at
PAGE_SIZE on 4KiB and 16KiB page archs, well within int16_t.  On 64KiB
pages PAGE_SIZE is well above S16_MAX so that flush never fires, and a
sufficiently long run of accumulations would overflow the cache.  Add an
explicit S16_MAX guard before each add: when the next add would push
abs(*bytes) past S16_MAX, fold the cached value into @nr and flush
directly via mod_objcg_mlstate() before the accumulation.

Link: https://lore.kernel.org/20260522011908.1669332-4-shakeel.butt@linux.dev
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~memcg-int16_t-for-cached-slab-stats
+++ a/mm/memcontrol.c
@@ -2023,8 +2023,8 @@ struct obj_stock_pcp {
 	struct obj_cgroup *cached_objcg;
 	uint16_t nr_bytes;
 	int16_t node_id;
-	int nr_slab_reclaimable_b;
-	int nr_slab_unreclaimable_b;
+	int16_t nr_slab_reclaimable_b;
+	int16_t nr_slab_unreclaimable_b;
 
 	struct work_struct work;
 	unsigned long flags;
@@ -3161,7 +3161,7 @@ static void __account_obj_stock(struct o
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	int *bytes;
+	int16_t *bytes;
 
 	/*
 	 * Though at the moment MAX_NUMNODES <= 1024 in all archs but let's make
@@ -3199,6 +3199,16 @@ static void __account_obj_stock(struct o
 	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
 					       : &stock->nr_slab_unreclaimable_b;
 	/*
+	 * To avoid overflow or underflow, flush directly if accumulating @nr
+	 * would push the cached value past S16_MAX.
+	 */
+	if (abs(nr + *bytes) > S16_MAX) {
+		nr += *bytes;
+		*bytes = 0;
+		goto direct;
+	}
+
+	/*
 	 * Even for large object >= PAGE_SIZE, the vmstat data will still be
 	 * cached locally at least once before pushing it out.
 	 */
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-use-round-robin-victim-selection-in-refill_stock.patch
memcg-multi-objcg-charge-support.patch

