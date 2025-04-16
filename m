Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5B51494DF
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 02:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744769813; cv=none; b=Fd1BSEqtIShIpnRTjt8HiXIPIelFFF7DNuh0+EbKTBpeD+6WjgRLzHfWTZqORl0GhIEG509aT04RSzADCS4VVqvQlaht/LFbOeYP8ThZBytmeSBrbmgaZPRV0rlzqCWze0MPEC+EDgIoNdhvjNum3AR0TxH6mq0ZMENROIU6BTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744769813; c=relaxed/simple;
	bh=s364k5nUGomd9V0yKyiSkbe1cSFAel/hPBfWeBnAfGI=;
	h=Date:To:From:Subject:Message-Id; b=CAtZcd0w/BzTIKWA3t0ynzpi5fYBRV/IUaj4w5pHD15zaOovpk+rkMtchSCf+lwr8UDkZqJg3vJfXqhx5jztOcEVgMURFBDaaXDyTpw64fCSF59GOItNvN/JofTB3DP/BGASeds4NEahtyIhRXL7qN9sjyaYTX4ZwNsziIgjUPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p3BAGtmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p3BAGtmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8900CC4CEE7;
	Wed, 16 Apr 2025 02:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744769812;
	bh=s364k5nUGomd9V0yKyiSkbe1cSFAel/hPBfWeBnAfGI=;
	h=Date:To:From:Subject:From;
	b=p3BAGtmOg+T0AbZZcF641MyPhw2Zv46hHSPvrFT4gYqklI/1doUHjFhVRFO1v27Mj
	 8HCiWPd2jVcfHLBtkNy2gxD/F4XRLVWqEbVnjuYZ736Puka/oY5UvDm46/ks7XqVYq
	 i/uyH9kugfWCSjrBXa/JgIggza9K7MHIOZmJfeL0=
Date: Tue, 15 Apr 2025 19:16:51 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock.patch removed from -mm tree
Message-Id: <20250416021652.8900CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: decouple memcg_hotplug_cpu_dead from stock_lock
has been removed from the -mm tree.  Its filename was
     memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: decouple memcg_hotplug_cpu_dead from stock_lock
Date: Thu, 10 Apr 2025 14:06:23 -0700

memcg_hotplug_cpu_dead() works on the stock of a remote dead CPU and
drain_obj_stock() works on the given stock instead of local stock, so
there is no need to take local stock_lock anymore.

[akpm@linux-foundation.org: fix build: s/flag/flags/ in memcg_hotplug_cpu_dead]
Link: https://lkml.kernel.org/r/20250410210623.1016767-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/memcontrol.c~memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock
+++ a/mm/memcontrol.c
@@ -1791,7 +1791,7 @@ static DEFINE_PER_CPU(struct memcg_stock
 };
 static DEFINE_MUTEX(percpu_charge_mutex);
 
-static void drain_obj_stock(struct memcg_stock_pcp *stock);
+static void __drain_obj_stock(struct memcg_stock_pcp *stock);
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 
@@ -1875,7 +1875,7 @@ static void drain_local_stock(struct wor
 	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
-	drain_obj_stock(stock);
+	__drain_obj_stock(stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
@@ -1966,10 +1966,10 @@ static int memcg_hotplug_cpu_dead(unsign
 
 	stock = &per_cpu(memcg_stock, cpu);
 
-	/* drain_obj_stock requires stock_lock */
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
-	drain_obj_stock(stock);
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	local_irq_save(flags);
+	/* stock of a remote dead cpu, no need for stock_lock. */
+	__drain_obj_stock(stock);
+	local_irq_restore(flags);
 
 	drain_stock(stock);
 
@@ -2839,7 +2839,11 @@ static bool consume_obj_stock(struct obj
 	return ret;
 }
 
-static void drain_obj_stock(struct memcg_stock_pcp *stock)
+/*
+ * Works on the given stock. The callers are responsible for the proper locking
+ * for the local or remote stocks.
+ */
+static void __drain_obj_stock(struct memcg_stock_pcp *stock)
 {
 	struct obj_cgroup *old = READ_ONCE(stock->cached_objcg);
 
@@ -2927,7 +2931,7 @@ static void refill_obj_stock(struct obj_
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
-		drain_obj_stock(stock);
+		__drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
 				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
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

