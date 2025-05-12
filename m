Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FA21553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011022; cv=none; b=fy1PinaXRoEd3LwZXHhcgNyLX4dtQiZC/sy83jIcu6UMPxnJsLL3H62d6bEPK59ntu6OWmuR/vrG3czQoxZ8kO5gnkvBAV+jSnyq9u+HeD2cJvxZJduYCjDtX4nbJMW54wAYJK6f+YqfV7cmjigQ65CL6NoCYgVcv4oyq9XriTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011022; c=relaxed/simple;
	bh=GVDC03EIvLvbKmu2Mo8bQlkSqlr/FV6La17ohkKGzI0=;
	h=Date:To:From:Subject:Message-Id; b=KkMdRzLrn8ZWR2FSmoaC4yUQ+i3y52/zNMoItcphDveoTG1WfqUw6CFk8IXvnc1Ec2rg28wllKNm32MU3GS3P3nT8E84kkXr3S9J6/JVTIH+rZR7djmBfiD1hNK2uZdrqkRzSfb+UVAu4FgOsNDA3oNp74uQjAF7YhFvCwwqaM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RiUoAki8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RiUoAki8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAA8C4CEE4;
	Mon, 12 May 2025 00:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011022;
	bh=GVDC03EIvLvbKmu2Mo8bQlkSqlr/FV6La17ohkKGzI0=;
	h=Date:To:From:Subject:From;
	b=RiUoAki81pCe8lQf0iedTisErYLgN82rEBVESHgBELeZfKk5tc3LxCtA3uvFBeMin
	 HbdC3rgx15+JDCyxKZ9FbKon0v/vxRRl4d8paBEa3MVnwUz+t5b/ItjSAQlNdKcxgS
	 TeFsGHK1vLiVWpReGxtVclSGKHhq3CAkeZtvL5DM=
Date: Sun, 11 May 2025 17:50:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-manually-inline-__refill_stock.patch removed from -mm tree
Message-Id: <20250512005022.5AAA8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: manually inline __refill_stock
has been removed from the -mm tree.  Its filename was
     memcg-manually-inline-__refill_stock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: manually inline __refill_stock
Date: Thu, 3 Apr 2025 18:39:08 -0700

There are no more multiple callers of __refill_stock(), so simply inline
it to refill_stock().

Link: https://lkml.kernel.org/r/20250404013913.1663035-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

--- a/mm/memcontrol.c~memcg-manually-inline-__refill_stock
+++ a/mm/memcontrol.c
@@ -1871,14 +1871,22 @@ static void drain_local_stock(struct wor
 	obj_cgroup_put(old);
 }
 
-/*
- * Cache charges(val) to local per_cpu area.
- * This will be consumed by consume_stock() function, later.
- */
-static void __refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	struct memcg_stock_pcp *stock;
 	unsigned int stock_pages;
+	unsigned long flags;
+
+	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
+
+	if (!local_trylock_irqsave(&memcg_stock.stock_lock, flags)) {
+		/*
+		 * In case of unlikely failure to lock percpu stock_lock
+		 * uncharge memcg directly.
+		 */
+		memcg_uncharge(memcg, nr_pages);
+		return;
+	}
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (READ_ONCE(stock->cached) != memcg) { /* reset if necessary */
@@ -1891,23 +1899,7 @@ static void __refill_stock(struct mem_cg
 
 	if (stock_pages > MEMCG_CHARGE_BATCH)
 		drain_stock(stock);
-}
 
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	unsigned long flags;
-
-	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
-
-	if (!local_trylock_irqsave(&memcg_stock.stock_lock, flags)) {
-		/*
-		 * In case of unlikely failure to lock percpu stock_lock
-		 * uncharge memcg directly.
-		 */
-		memcg_uncharge(memcg, nr_pages);
-		return;
-	}
-	__refill_stock(memcg, nr_pages);
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 }
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

