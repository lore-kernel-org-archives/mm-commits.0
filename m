Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB82166F0C
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011019; cv=none; b=uY9nyIe/JP8S85sA6VKK5v9JDNFRYKpoMJbiSWWUziQqUd2j6Fuwpvw/nrotK8Lk6GccbHGzF+02f6a0uiPxhEgTREqVaG1MIyh/sZAJssgj0cKKVd/1hLyXFkuZbsx7b7bzzGo8IgWYe1nETPZnAS6g9IJKj3qKKX3iuTY99R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011019; c=relaxed/simple;
	bh=8QyMwdR5fqrdhirwha9a/znvD3HPW0bm9P6U5qC9DfI=;
	h=Date:To:From:Subject:Message-Id; b=DtLUpKu9jhEO/E0sQPW/I+0UlEPWtB5vTUt031ZH4O6FD+ZN33d12mo/cDbgcmrije3L64ah+HAwrW1bY7w6IpuxOQMiG0ge6jxkGRzt2u+/PP+RN0lrR2v8dE8IHCzskLiD8s+FwdqIKLQ10GMlP5friXCi3T7BIn2R/m9YwDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kfqZ6qfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kfqZ6qfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC90C4CEE4;
	Mon, 12 May 2025 00:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011018;
	bh=8QyMwdR5fqrdhirwha9a/znvD3HPW0bm9P6U5qC9DfI=;
	h=Date:To:From:Subject:From;
	b=kfqZ6qfRGRjD3TgCoUkpn2pwa0hxC6qqgth+wI4CD8Gt3XwNNeMMpjHi3qjb+oI/0
	 dZbVJypUfRcp9435sm9g8LLuaZStyGjAx/r+upOZZc0V6RB+cOxQ83nVCAPrS8YP+y
	 bz7x4u/6bb+1BZwANtjMgPgRbTouW1585qdOITCY=
Date: Sun, 11 May 2025 17:50:18 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-root-memcg-check-from-refill_stock.patch removed from -mm tree
Message-Id: <20250512005018.BFC90C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove root memcg check from refill_stock
has been removed from the -mm tree.  Its filename was
     memcg-remove-root-memcg-check-from-refill_stock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove root memcg check from refill_stock
Date: Thu, 3 Apr 2025 18:39:05 -0700

refill_stock can not be called with root memcg, so there is no need to
check it.  Instead add a warning if root is ever passed to it.

Link: https://lkml.kernel.org/r/20250404013913.1663035-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20250404013913.1663035-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-remove-root-memcg-check-from-refill_stock
+++ a/mm/memcontrol.c
@@ -1893,13 +1893,13 @@ static void refill_stock(struct mem_cgro
 {
 	unsigned long flags;
 
+	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
+
 	if (!local_trylock_irqsave(&memcg_stock.stock_lock, flags)) {
 		/*
 		 * In case of unlikely failure to lock percpu stock_lock
 		 * uncharge memcg directly.
 		 */
-		if (mem_cgroup_is_root(memcg))
-			return;
 		page_counter_uncharge(&memcg->memory, nr_pages);
 		if (do_memsw_account())
 			page_counter_uncharge(&memcg->memsw, nr_pages);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

