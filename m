Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1836FBF
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 00:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987012; cv=none; b=Ir608ygFlcNNSSKOt9hazhhPQUI21t/80OS5hntS3JOcPcH0wh8LqU/IdzsxXsKe7vGdmBYu0rhQ3hQxPUfWWBHzVni7u13/X4Oa3tZ0cIZLt6Ie27aHjv2uEuE2m7vDpf/LXH2JhwosjUSdCvHo807r4LR/+m301JlnSYujX2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987012; c=relaxed/simple;
	bh=bvcT15gDDvbcgIK7DIC2ANl/IxG424ERL4J/t8VyKck=;
	h=Date:To:From:Subject:Message-Id; b=upLyrKDcf2T9aPsc/4e7mODqVjsmo8IoqmcL+k5udmGH2yGbZKAmL38SWf7afGv2y6JzVI060bHiGIG8XiJkfT/DYXlck5pUNHGr661QHwL1XNcuqSY6t7RlATBfN77zYTGb8d+JE1MJMM+B4Sv4amcrpffs8HUzsUDizrNjcwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I3bhLeBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I3bhLeBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F662C4CEE3;
	Mon,  7 Apr 2025 00:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987011;
	bh=bvcT15gDDvbcgIK7DIC2ANl/IxG424ERL4J/t8VyKck=;
	h=Date:To:From:Subject:From;
	b=I3bhLeBjTuthTur2pOI1qL1POEhOb6Auj2DvLzrATgaRuu9kz54R1Khx4NXXUSRxM
	 a8T8IEu9FdruTymRnwuFHLWP2ajUCBOA2Zn0QT/Z0831ErqUOdn1w+gzWpDn4cdOgm
	 A6RTCbnR8BiQIo7JoQ/d7A0NR8iIFhNA1tPjbsvc=
Date: Sun, 06 Apr 2025 17:50:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-root-memcg-check-from-refill_stock.patch added to mm-new branch
Message-Id: <20250407005011.6F662C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove root memcg check from refill_stock
has been added to the -mm mm-new branch.  Its filename is
     memcg-remove-root-memcg-check-from-refill_stock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-root-memcg-check-from-refill_stock.patch

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

