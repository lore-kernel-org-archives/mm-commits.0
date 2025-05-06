Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB01A19CC0A
	for <mm-commits@vger.kernel.org>; Tue,  6 May 2025 23:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746573506; cv=none; b=QR9EJ0M/1lkpWp+HulCItC0gunijkffNFLVJL3gVH8QMQHKZtu3po0lFJjRHDEaW32T3xjvv8W+Hfh9gdV6LQPkYk5/r7Xk5j6dtSe4lDX3yoT19AOzbBCiUR9lTaC0IecdlVE7TxuVlhwAQCgY/Gpesj4MDG23RdrKndDQ2KrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746573506; c=relaxed/simple;
	bh=n7Bo9nxKoTDZZ6HAecNJSEAo/NfZrZgUC/Q+23NK5v0=;
	h=Date:To:From:Subject:Message-Id; b=RUyQ+fOYPBnozk7g2omAI0/ET2JuVRV5XCZZWxJnwju3N3TByPwdraqva1wsbMcMmWwnd8Tn3zQzaknG7Hs9kPF/bgGzj4U+U+tjjmSlSj9IcaeXB6FV74ExJumZW0HeRCgeuAAbYCXnjN4d8yzizXyaXQMGNCgwqGZ1Ar3eDXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OHQhogTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OHQhogTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3B3C4CEE4;
	Tue,  6 May 2025 23:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746573506;
	bh=n7Bo9nxKoTDZZ6HAecNJSEAo/NfZrZgUC/Q+23NK5v0=;
	h=Date:To:From:Subject:From;
	b=OHQhogTN8wgdUpgZ6H9FEqMN714sJewcqJ36T6fJ0b1M8DbUnN63wUfFv0JE25YXK
	 /9XImTlVzOhxaTW9HL+BEFbw+XEW6g4oldgSMhlbv3V8BiVN3GtW9hRFM9eAO7GqP5
	 GFsfSwe8Sc9OPr/uh67yMLcB8NkMU5mKIAL64Yuw=
Date: Tue, 06 May 2025 16:18:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,kuba@kernel.org,hannes@cmpxchg.org,edumazet@google.com,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-no-irq-disable-for-memcg-stock-lock.patch added to mm-new branch
Message-Id: <20250506231826.2A3B3C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: no irq disable for memcg stock lock
has been added to the -mm mm-new branch.  Its filename is
     memcg-no-irq-disable-for-memcg-stock-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-no-irq-disable-for-memcg-stock-lock.patch

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

