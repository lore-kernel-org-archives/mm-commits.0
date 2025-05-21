Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FADA2222C8
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846672; cv=none; b=Fd+euYydd3694M+yD550RMHbVW/uYXlsFY9trgaYpUyL5ufDzTOTnyGSOEdCr6vGd98DziJwDY0SObfGt7jmqQmcdyQQcrmQ/1hKVlMgQAGFIxCzkW1ONxzKC/HOwK3jyUxqC4Na8jDRpOjFaHOqEO8ZILA7mgYyD6OZR5eEqeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846672; c=relaxed/simple;
	bh=Q7uaMjNO/OnzFjanMJiBsHjyfAK6kMzUg2Pm6t20Ozk=;
	h=Date:To:From:Subject:Message-Id; b=JE3+QQAmJ5zJ2Q2JmFsqsy/HovWuKuSz2DpF/8XNIrTCxfMirPo+VSd97X0JOCn2YnxIUkplRW8JpuawttTJxJaTn5FXQs2fSftNO/gIyqDM6jH61i9HQ7mZTKWUwKhChY6YsFRNn13d6OsxW2lZ+3lqqlR8Dn7cCFJTEtMZ7HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jkthCH2X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jkthCH2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD201C4CEE7;
	Wed, 21 May 2025 16:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846672;
	bh=Q7uaMjNO/OnzFjanMJiBsHjyfAK6kMzUg2Pm6t20Ozk=;
	h=Date:To:From:Subject:From;
	b=jkthCH2Xgk/5Abuf/ua3Tq6G/ye9Nz3SvHeEhE+fE9yRgEbYdaA9d8Ltvw00mTFq7
	 dKM/Uhn1QqWbR4lCPTSh+S1YZOOsVQ9oP8pVpXkJJOMIGpDkwa3PMJFi2y/YvlhwYa
	 pXa1kPx/6QA1gYSKPBBMZSR62oZ5hhnzeHciJj2g=
Date: Wed, 21 May 2025 09:57:51 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-objcg-stock-trylock-without-irq-disabling.patch removed from -mm tree
Message-Id: <20250521165751.DD201C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: objcg stock trylock without irq disabling
has been removed from the -mm tree.  Its filename was
     memcg-objcg-stock-trylock-without-irq-disabling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: objcg stock trylock without irq disabling
Date: Wed, 14 May 2025 11:41:58 -0700

There is no need to disable irqs to use objcg per-cpu stock, so let's just
not do that but consume_obj_stock() and refill_obj_stock() will need to
use trylock instead to avoid deadlock against irq.  One consequence of
this change is that the charge request from irq context may take slowpath
more often but it should be rare.

Link: https://lkml.kernel.org/r/20250514184158.3471331-8-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~memcg-objcg-stock-trylock-without-irq-disabling
+++ a/mm/memcontrol.c
@@ -1882,18 +1882,17 @@ static void drain_local_memcg_stock(stru
 static void drain_local_obj_stock(struct work_struct *dummy)
 {
 	struct obj_stock_pcp *stock;
-	unsigned long flags;
 
 	if (WARN_ONCE(!in_task(), "drain in non-task context"))
 		return;
 
-	local_lock_irqsave(&obj_stock.lock, flags);
+	local_lock(&obj_stock.lock);
 
 	stock = this_cpu_ptr(&obj_stock);
 	drain_obj_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
-	local_unlock_irqrestore(&obj_stock.lock, flags);
+	local_unlock(&obj_stock.lock);
 }
 
 static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
@@ -2876,10 +2875,10 @@ static bool consume_obj_stock(struct obj
 			      struct pglist_data *pgdat, enum node_stat_item idx)
 {
 	struct obj_stock_pcp *stock;
-	unsigned long flags;
 	bool ret = false;
 
-	local_lock_irqsave(&obj_stock.lock, flags);
+	if (!local_trylock(&obj_stock.lock))
+		return ret;
 
 	stock = this_cpu_ptr(&obj_stock);
 	if (objcg == READ_ONCE(stock->cached_objcg) && stock->nr_bytes >= nr_bytes) {
@@ -2890,7 +2889,7 @@ static bool consume_obj_stock(struct obj
 			__account_obj_stock(objcg, stock, nr_bytes, pgdat, idx);
 	}
 
-	local_unlock_irqrestore(&obj_stock.lock, flags);
+	local_unlock(&obj_stock.lock);
 
 	return ret;
 }
@@ -2979,10 +2978,16 @@ static void refill_obj_stock(struct obj_
 		enum node_stat_item idx)
 {
 	struct obj_stock_pcp *stock;
-	unsigned long flags;
 	unsigned int nr_pages = 0;
 
-	local_lock_irqsave(&obj_stock.lock, flags);
+	if (!local_trylock(&obj_stock.lock)) {
+		if (pgdat)
+			mod_objcg_mlstate(objcg, pgdat, idx, nr_bytes);
+		nr_pages = nr_bytes >> PAGE_SHIFT;
+		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
+		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
+		goto out;
+	}
 
 	stock = this_cpu_ptr(&obj_stock);
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
@@ -3004,8 +3009,8 @@ static void refill_obj_stock(struct obj_
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	local_unlock_irqrestore(&obj_stock.lock, flags);
-
+	local_unlock(&obj_stock.lock);
+out:
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-disable-kmem-charging-in-nmi-for-unsupported-arch.patch
memcg-nmi-safe-memcg-stats-for-specific-archs.patch
memcg-add-nmi-safe-update-for-memcg_kmem.patch
memcg-nmi-safe-slab-stats-updates.patch
memcg-make-memcg_rstat_updated-nmi-safe.patch

