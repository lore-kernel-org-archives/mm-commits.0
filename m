Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F50E26FA72
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 02:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744339994; cv=none; b=P8d35MmzwCcEd2xaBFNLqV1wCOuIF0z8clOWEBlg+7mkidNrfUkLhnlfzXvBVWhbP6PCfN5AFSrrOL5LXc8Wf/6IHXKM3Ao8DBapIqhcs44lpT8y8vIjBE05h3sAoBevHu6tgrwnQA3EiRLTf/H25WAj1SSNSHY96KyeIacknmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744339994; c=relaxed/simple;
	bh=LaulsiwOcWop/k01DabByRrlfa97JfHcRanU+a5oGHk=;
	h=Date:To:From:Subject:Message-Id; b=qoDySOUupaoFNXDesrnAv4K4xEw9UcbrSdsbIIpvudoRwbbrifJXZUs3X67RmhOpjBpQAX2QKO66NJwBUH8dyiHjOZehXH7uNX4BWeUwxB1AXOdcWPgU+TLD5Xp+7W/cwtH+kEzGX9mZglWpjggNaosSxkjLbE8sNRQr0D5PRVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UZEjjfmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UZEjjfmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AA9C4CEDD;
	Fri, 11 Apr 2025 02:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744339993;
	bh=LaulsiwOcWop/k01DabByRrlfa97JfHcRanU+a5oGHk=;
	h=Date:To:From:Subject:From;
	b=UZEjjfmySKknOQn7DwP+tORTjRo1+NndbfxnOVfjInGyTGJxRFSJX81dw2uWUZcFJ
	 EWcrtUo415ggNb42afyJ2q9giA7tc96uik5+wCRWttb+ioFa41VGuQIy150KUFgJgm
	 O2s7CW23MpuL40K8dI1Ysckssl+PtvsxbqrWN+Bs=
Date: Thu, 10 Apr 2025 19:53:12 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock.patch added to mm-new branch
Message-Id: <20250411025313.B2AA9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: decouple memcg_hotplug_cpu_dead from stock_lock
has been added to the -mm mm-new branch.  Its filename is
     memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: memcg: decouple memcg_hotplug_cpu_dead from stock_lock
Date: Thu, 10 Apr 2025 14:06:23 -0700

memcg_hotplug_cpu_dead() works on the stock of a remote dead CPU and
drain_obj_stock() works on the given stock instead of local stock, so
there is no need to take local stock_lock anymore.

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
@@ -1789,7 +1789,7 @@ static DEFINE_PER_CPU(struct memcg_stock
 };
 static DEFINE_MUTEX(percpu_charge_mutex);
 
-static void drain_obj_stock(struct memcg_stock_pcp *stock);
+static void __drain_obj_stock(struct memcg_stock_pcp *stock);
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 
@@ -1873,7 +1873,7 @@ static void drain_local_stock(struct wor
 	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
-	drain_obj_stock(stock);
+	__drain_obj_stock(stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
@@ -1964,10 +1964,10 @@ static int memcg_hotplug_cpu_dead(unsign
 
 	stock = &per_cpu(memcg_stock, cpu);
 
-	/* drain_obj_stock requires stock_lock */
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
-	drain_obj_stock(stock);
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	local_irq_save(flag);
+	/* stock of a remote dead cpu, no need for stock_lock. */
+	__drain_obj_stock(stock);
+	local_irq_restore(flag);
 
 	drain_stock(stock);
 
@@ -2837,7 +2837,11 @@ static bool consume_obj_stock(struct obj
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
 
@@ -2925,7 +2929,7 @@ static void refill_obj_stock(struct obj_
 
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
memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock.patch

