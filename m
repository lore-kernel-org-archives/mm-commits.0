Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1F929A5
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 00:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987019; cv=none; b=IDLss4BFDNGJVzsilb9IC0mrYGt4htaH1n8VobJ5zdM8b7OTdGzAp4DSEcROH+UO6KB7Y85WQ6LRtT3HGsB5kJVOOK2iA5V0jQZDcV/A0L1dMnxnavK5DmgXba0H8Q3KkWhCjv0Z6KqBBStr6lSvh98OUFXrKjyl8LzQCtune6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987019; c=relaxed/simple;
	bh=INLTGOPRpmstOZ+NxDV5kXhgIKglG18Bz7MOsYjBO/8=;
	h=Date:To:From:Subject:Message-Id; b=rcJclBnOVel0qs4UlO0JDaaSbPWjq191e68+XA0snOR6s2/53Mo7FSv2ZngZ2PSdRvFTsz8BtH2fPDxB6atUIUvqMcUxAG74SMnCJeUgb5i3xywAuuK28QL8wofJeq/HW0s0rUJhV2m/Q6toLkB8xRi+P/mjklr8u2C3bDE7I/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLt/rldn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLt/rldn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE68C4CEE3;
	Mon,  7 Apr 2025 00:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987017;
	bh=INLTGOPRpmstOZ+NxDV5kXhgIKglG18Bz7MOsYjBO/8=;
	h=Date:To:From:Subject:From;
	b=MLt/rldnVhzAXc4Ca2D2GphzEQ3GV1w21X7tW6NgxB5BnFJcyjshaNQaNzreWI1wd
	 VN5rZw4zkxFQP7ZRVk70OY+1hbTmvZq+I8vCqDIuaaD2iG3y85ZNxzFApmL/1bYqLJ
	 IygVCN7YNYDVX/CFWNXv4vn2BEwLvPEzTHqeT+Jw=
Date: Sun, 06 Apr 2025 17:50:16 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-manually-inline-__refill_stock.patch added to mm-new branch
Message-Id: <20250407005017.5BE68C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: manually inline __refill_stock
has been added to the -mm mm-new branch.  Its filename is
     memcg-manually-inline-__refill_stock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-manually-inline-__refill_stock.patch

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

