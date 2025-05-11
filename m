Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4226A17BB6
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746935007; cv=none; b=tSd5JR660c6hBC6sYF4+Ia37h/VJaOMmYbPY6tx83lewozMeagG4y9mEukGjKV/H3lS/boY7/1+ioD1zKmHH2DYrqknsbAEWqj2humuIfbTRCS08iLEcRRx0PY24+RxnYvavtwwgr68HwVQF3NWX326tF0Bx7jiMqSF6lDsPG58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746935007; c=relaxed/simple;
	bh=SVdgn390U86sAMGY2MmbWLZNQZGO89TjtDxjmhL245g=;
	h=Date:To:From:Subject:Message-Id; b=dSm7/nfxzsRtSwZhAA2RGdkq7ez7BH98m3Z39tmycAo5U7wVigAmiWFZ3KB27BvaI1FHBEgw7vHAwGMORc2EF8vwyxDSalyTfUwwOTqwdpmEic25+r0QmbG0+4QF/pjFXb01IzMZe5V5hkZ8PpIj9VZ4aoCrhnMGj5WSzoBHxMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oy+7U1oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oy+7U1oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A305DC4CEE4;
	Sun, 11 May 2025 03:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746935006;
	bh=SVdgn390U86sAMGY2MmbWLZNQZGO89TjtDxjmhL245g=;
	h=Date:To:From:Subject:From;
	b=Oy+7U1ojnYa2PjUF79Q/QcTj0gkYgbTx/sgPgRi/aN1xbkS1Ru2nu1NsdrERtvfCP
	 czKxxD/p1UfloNhXofJMzXxqX9aI626nyVQkaJlSjRkA3sxyL7QuuRQmfdzewioeAv
	 zjT4qRkcEyP5aAhEU90r8IetmBisyHFIFrPdUXuM=
Date: Sat, 10 May 2025 20:43:26 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,soheil@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,kuba@kernel.org,hughd@google.com,hannes@cmpxchg.org,edumazet@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-multi-memcg-percpu-charge-cache-fix-2.patch removed from -mm tree
Message-Id: <20250511034326.A305DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: multi-memcg percpu charge cache - fix 2
has been removed from the -mm tree.  Its filename was
     memcg-multi-memcg-percpu-charge-cache-fix-2.patch

This patch was dropped because it was folded into memcg-multi-memcg-percpu-charge-cache.patch

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: multi-memcg percpu charge cache - fix 2
Date: Fri, 25 Apr 2025 13:10:43 -0700

Simplify refill_stock by avoiding goto and doing the operations inline and
make sure the given memcg is not cached multiple times.

Link: https://lkml.kernel.org/r/as5cdsm4lraxupg3t6onep2ixql72za25hvd4x334dsoyo4apr@zyzl4vkuevuv
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/mm/memcontrol.c~memcg-multi-memcg-percpu-charge-cache-fix-2
+++ a/mm/memcontrol.c
@@ -1904,7 +1904,8 @@ static void refill_stock(struct mem_cgro
 	struct mem_cgroup *cached;
 	uint8_t stock_pages;
 	unsigned long flags;
-	bool evict = true;
+	bool success = false;
+	int empty_slot = -1;
 	int i;
 
 	/*
@@ -1928,26 +1929,28 @@ static void refill_stock(struct mem_cgro
 
 	stock = this_cpu_ptr(&memcg_stock);
 	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-again:
 		cached = READ_ONCE(stock->cached[i]);
-		if (!cached) {
-			css_get(&memcg->css);
-			WRITE_ONCE(stock->cached[i], memcg);
-		}
-		if (!cached || memcg == READ_ONCE(stock->cached[i])) {
+		if (!cached && empty_slot == -1)
+			empty_slot = i;
+		if (memcg == READ_ONCE(stock->cached[i])) {
 			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
 			if (stock_pages > MEMCG_CHARGE_BATCH)
 				drain_stock(stock, i);
-			evict = false;
+			success = true;
 			break;
 		}
 	}
 
-	if (evict) {
-		i = get_random_u32_below(NR_MEMCG_STOCK);
-		drain_stock(stock, i);
-		goto again;
+	if (!success) {
+		i = empty_slot;
+		if (i == -1) {
+			i = get_random_u32_below(NR_MEMCG_STOCK);
+			drain_stock(stock, i);
+		}
+		css_get(&memcg->css);
+		WRITE_ONCE(stock->cached[i], memcg);
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
 	}
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
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
memcg-multi-memcg-percpu-charge-cache-fix-4.patch
memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

