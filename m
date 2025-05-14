Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715881F4CAB
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 05:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747202342; cv=none; b=T++4tELjuGL0xdDHgiAYHga+64jBRVB/4om/GRjCJURM3ktOjRa3Zxq2y1XnxPKPyat1I5PFSZ8fmtkrfZMC2d9wBlmcQ94EaQ5ohaZwkfAxBOq5YgmRZ/QqvEyE4S05Gog9mock5Uq9tMd+mER0fDx5eHatZ8bFJgMWZQruBPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747202342; c=relaxed/simple;
	bh=Ebp9tfHiJR8CsjjQJcc+UMTIQtimua9Rn4/uH74yao0=;
	h=Date:To:From:Subject:Message-Id; b=MYsfPqJxSK4BkQuqSOx0wZXBzgzCmPZSWZNu4Xv2PJoq/NTzYfSRS01XE86SoKgPR3Bd62cs6ioLJOtIn7EYNVnMU0M1U3lRTQ8VZA4d4JBVu0tnoVGWOhzj+LGyOrU5fIRVfW9Zha511WBPm/Sy2IcwGggGL30MHWzoHPGScfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KWHkDQHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KWHkDQHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5085C4CEE9;
	Wed, 14 May 2025 05:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747202341;
	bh=Ebp9tfHiJR8CsjjQJcc+UMTIQtimua9Rn4/uH74yao0=;
	h=Date:To:From:Subject:From;
	b=KWHkDQHPULysCOVWYcZzNTpEfdPCHZ7VX/4f7AnysfoI3IBw374XtKPjzP9eflVF1
	 JXCx1McNdAH10Wa8WiFUjVVzwtKpI/Gq/DR1VwWrRxixXXSzipeuHWpXDSOJsvSclj
	 zw/WXA3Y/I5Lr7iOvsUlvFlM2hjzEsEHVj8FFXNw=
Date: Tue, 13 May 2025 22:59:01 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-objcg-stock-trylock-without-irq-disabling.patch added to mm-new branch
Message-Id: <20250514055901.D5085C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: objcg stock trylock without irq disabling
has been added to the -mm mm-new branch.  Its filename is
     memcg-objcg-stock-trylock-without-irq-disabling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-objcg-stock-trylock-without-irq-disabling.patch

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
Subject: memcg: objcg stock trylock without irq disabling
Date: Tue, 13 May 2025 22:08:13 -0700

There is no need to disable irqs to use objcg per-cpu stock, so let's just
not do that but consume_obj_stock() and refill_obj_stock() will need to
use trylock instead to avoid deadlock against irq.  One consequence of
this change is that the charge request from irq context may take slowpath
more often but it should be rare.

Link: https://lkml.kernel.org/r/20250514050813.2526843-8-shakeel.butt@linux.dev
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

memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch
memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch
memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch
memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch
memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch
memcg-no-stock-lock-for-cpu-hot-unplug.patch
memcg-objcg-stock-trylock-without-irq-disabling.patch

