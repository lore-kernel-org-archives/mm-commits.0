Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD33B1F1511
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119357; cv=none; b=ujR6nhIJzIfwRA5efD0wl+08AWW0i6MgtXuG3hhvYRADw4nqz+QtixrN85UPlhQmpKKAem2CWlyOHW49/ZilocNbSBs4iZ1twOMM5S2dcA4/0RJFT7s0FPaQs3y+gm+94QUQZOdnWrKLSF9Oi50iBf0aFVFGQJr99bcy708QY7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119357; c=relaxed/simple;
	bh=MIuPEm+YzwlwWD/jnbA9hGHSDbbbQW9BIJIS8IQm37E=;
	h=Date:To:From:Subject:Message-Id; b=p+cQmGx/vkM9aO+Dbd4KznTGrKG0zDHHRWTljLEjEo1hPU+Eg4ryzyw1NqV4bVqdL3WG0WfTuN0MgREeua+lFr/iN86YQX2yk6W6WvKyWKVxwp2ux4ggRl/LU3PfRFsF8F3DFAOCy5LUnxGCHthhk0RGlqll+Vu/fWaXFZeGHpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qul6QVnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qul6QVnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95212C4CEED;
	Tue, 13 May 2025 06:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119357;
	bh=MIuPEm+YzwlwWD/jnbA9hGHSDbbbQW9BIJIS8IQm37E=;
	h=Date:To:From:Subject:From;
	b=qul6QVnbAD5rBWd3yujfPdw6+IO3gVh0VuO0q6kFYRdgwtq9y83RYXF0KumZbzb5M
	 ZhP7lB26pM4+mbylgS6vPeC7SuR8Iar7mlY2RI9G2sVGinNon3DYkjw804DSco9SWB
	 4Ah8/aTZdo2GnLDG975uUaWABzBBfKgMPCzB8b2c=
Date: Mon, 12 May 2025 23:55:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,kuba@kernel.org,hannes@cmpxchg.org,edumazet@google.com,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-no-irq-disable-for-memcg-stock-lock.patch removed from -mm tree
Message-Id: <20250513065557.95212C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: no irq disable for memcg stock lock
has been removed from the -mm tree.  Its filename was
     memcg-no-irq-disable-for-memcg-stock-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: no irq disable for memcg stock lock
Date: Tue, 6 May 2025 15:55:33 -0700

There is no need to disable irqs to use memcg per-cpu stock, so let's just
not do that.  One consequence of this change is if the kernel while in
task context has the memcg stock lock and that cpu got interrupted.  The
memcg charges on that cpu in the irq context will take the slow path of
memcg charging.  However that should be super rare and should be fine in
general.

Link: https://lkml.kernel.org/r/20250506225533.2580386-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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

 mm/memcontrol.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~memcg-no-irq-disable-for-memcg-stock-lock
+++ a/mm/memcontrol.c
@@ -1854,12 +1854,11 @@ static bool consume_stock(struct mem_cgr
 {
 	struct memcg_stock_pcp *stock;
 	uint8_t stock_pages;
-	unsigned long flags;
 	bool ret = false;
 	int i;
 
 	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock_irqsave(&memcg_stock.lock, flags))
+	    !local_trylock(&memcg_stock.lock))
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -1876,7 +1875,7 @@ static bool consume_stock(struct mem_cgr
 		break;
 	}
 
-	local_unlock_irqrestore(&memcg_stock.lock, flags);
+	local_unlock(&memcg_stock.lock);
 
 	return ret;
 }
@@ -1920,18 +1919,17 @@ static void drain_stock_fully(struct mem
 static void drain_local_memcg_stock(struct work_struct *dummy)
 {
 	struct memcg_stock_pcp *stock;
-	unsigned long flags;
 
 	if (WARN_ONCE(!in_task(), "drain in non-task context"))
 		return;
 
-	local_lock_irqsave(&memcg_stock.lock, flags);
+	local_lock(&memcg_stock.lock);
 
 	stock = this_cpu_ptr(&memcg_stock);
 	drain_stock_fully(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
-	local_unlock_irqrestore(&memcg_stock.lock, flags);
+	local_unlock(&memcg_stock.lock);
 }
 
 static void drain_local_obj_stock(struct work_struct *dummy)
@@ -1956,7 +1954,6 @@ static void refill_stock(struct mem_cgro
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *cached;
 	uint8_t stock_pages;
-	unsigned long flags;
 	bool success = false;
 	int empty_slot = -1;
 	int i;
@@ -1971,7 +1968,7 @@ static void refill_stock(struct mem_cgro
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
 	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock_irqsave(&memcg_stock.lock, flags)) {
+	    !local_trylock(&memcg_stock.lock)) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
@@ -2006,7 +2003,7 @@ static void refill_stock(struct mem_cgro
 		WRITE_ONCE(stock->nr_pages[i], nr_pages);
 	}
 
-	local_unlock_irqrestore(&memcg_stock.lock, flags);
+	local_unlock(&memcg_stock.lock);
 }
 
 static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


