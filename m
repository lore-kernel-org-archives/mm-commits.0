Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95BB257AF8
	for <mm-commits@vger.kernel.org>; Fri, 25 Apr 2025 23:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745623711; cv=none; b=Wv9ZvBIjmgTlqEUzirqlPuRaGR32MTKrGuJiqVzc3CLXubl60tOddwNJvkPVSsh0w9hsRcRXHU7mIA0RJcRAAtiypVGB7Zap/qEDIaIVCkObmbDfg35n8EHKisejL3zJxD35iyF5GGSqXyK4AwTA225YbZXqZAWTNUBUhALGj44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745623711; c=relaxed/simple;
	bh=BobvewT/Wmqa04hz8+8RZxdaRzBJcUrnQvkDWFQ6K28=;
	h=Date:To:From:Subject:Message-Id; b=QRANjQGzFKhq6cCYIYvGhVAkCx8GVnS+5sjRZjRsQBquPYpP9cQXKFB+haGKJputH7JF7i78ta+gKR3Ggh0TxRUgmX0ZPdAJLe2q9Nj/mQC/Le0i/1CeWYJGIRZ9ZI+57fNspo7uCakXulbhZaJn3JdOBJX2ELDPeF6uv+hBMMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iCXivZ8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iCXivZ8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E7BC4CEE4;
	Fri, 25 Apr 2025 23:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745623711;
	bh=BobvewT/Wmqa04hz8+8RZxdaRzBJcUrnQvkDWFQ6K28=;
	h=Date:To:From:Subject:From;
	b=iCXivZ8ZjfPLn28BvZpLqwTzKHia1xDovmv/vw3W1/6qgLxCJZAL1Behz9M7GjVru
	 yp28fF1ULXDP5XLunxu0q13ZMWfm0oUwNvediZi5q1KLu8TqEQAvdrZaCPP5ACZMwT
	 agHNbH6lBa3LISYaeCGCX+Qkh9JuaMjkOkVMpjmo=
Date: Fri, 25 Apr 2025 16:28:30 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,soheil@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,kuba@kernel.org,hannes@cmpxchg.org,edumazet@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-multi-memcg-percpu-charge-cache-fix-2.patch added to mm-unstable branch
Message-Id: <20250425232831.12E7BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: multi-memcg percpu charge cache - fix 2
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-multi-memcg-percpu-charge-cache-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-multi-memcg-percpu-charge-cache-fix-2.patch

This patch will later appear in the mm-unstable branch at
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/mm/memcontrol.c~memcg-multi-memcg-percpu-charge-cache-fix-2
+++ a/mm/memcontrol.c
@@ -1906,7 +1906,8 @@ static void refill_stock(struct mem_cgro
 	struct mem_cgroup *cached;
 	uint8_t stock_pages;
 	unsigned long flags;
-	bool evict = true;
+	bool success = false;
+	int empty_slot = -1;
 	int i;
 
 	/*
@@ -1930,26 +1931,28 @@ static void refill_stock(struct mem_cgro
 
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
memcg-introduce-non-blocking-limit-setting-option.patch

