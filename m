Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C103B5F63;
	Fri,  7 Aug 2026 02:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068152; cv=none; b=LZ4K+E23YMTbIuFo1OXln5Z110SZ3S49lrkwc3yh1FhrrdtoYbY0wYpeJGWy3LBOhlpRTYT12/hB4PcLBnJQCK9o8sNU2pHI081agrtlDxEZ/s0qSrxyeMf4ciLnith4UfbkqPYLY7vRU8isTf4/KAPgp4aqI/Kj9MeaBYTMG/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068152; c=relaxed/simple;
	bh=lb3oNpr5oZQOdQPFDzQP+EylMvAc3jn9Zw2HGjdkM88=;
	h=Date:To:From:Subject:Message-Id; b=FNqkLpmQV329YiFyyvUMhCKvw7/LWU7APXidUb2kBnuw899LdDmmcvdchIoSCfnqj+k4eSobbpGk37XSNwS+5BfXJMi6Z4YfKqSwU5TdTxS/vbK3SOegVIPmm8LCWPiCQmbXM8ig5hnAfkgOTqp9GOFz9ZFKvgvYXknaZusNios=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y+D2e2dS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y+D2e2dS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8671F00A3A;
	Fri,  7 Aug 2026 02:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068150;
	bh=wJKs5KsJlCpfh4HTFKP/q+Ei1DOyplYsEGSKVo1FH34=;
	h=Date:To:From:Subject;
	b=y+D2e2dSZLFmlwOnJklFHaYKfDjSfsLJvMpkLCykdwxGsoS2zDuT1QWMlN0Ext49k
	 uYbZoOoc2pB6XQET9TrZgiy4hJCweV6fgi2dz8f0R7flnaQaVIN2sykg7izGjb41U/
	 DrIicTbHn9HEb+7Vm3WH2o6+gFKd1KpJl7/LiI7s=
Date: Thu, 06 Aug 2026 19:02:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,gourry@gourry.net,david@kernel.org,brendan.jackman@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-__gfp_fs-lockdep-annotation-for-direct-compaction.patch removed from -mm tree
Message-Id: <20260807020230.7C8671F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: __GFP_FS lockdep annotation for direct compaction
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-__gfp_fs-lockdep-annotation-for-direct-compaction.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: __GFP_FS lockdep annotation for direct compaction
Date: Wed, 22 Jul 2026 10:56:44 -0400

Patch series "mm: fix reclaim storms in defrag_mode", v2.

As we deployed vm.defrag_mode=1 in Meta production, some workloads
regressed with recurring pressure spikes and swap storms (which in turn
triggered userspace OOM rules on pressure and swap utilization levels).

Tracing pinned this to non-movable requests spinning and reclaiming
unproductively when kswapd/kcompactd are overwhelmed.  Direct reclaim
predominantly frees up pages in movable blocks, but those requests cannot
use that space under defrag_mode rules; and it is unlikely to free up
whole blocks incidentally for __rmqueue_claim() to work.

This series fixes it by making non-movable requests participate in
pageblock production in the allocator slowpath - meaning, they will invoke
direct reclaim and direct compaction with pageblock_order.

That requires some small-ish adjustments up front in the allocator and the
compaction code: three prep patches and the fix last.

The series has been in production against one of the affected workloads
for several weeks and restores the OOM kill rate to !defrag_mode baseline.


This patch (of 4):

A subsequent patch will have some order-0 allocations participate in
compaction under defrag_mode, to stave off extfrag events.

Since this is a sprawling expansion of entry points, and compaction can
enter filesystem paths, add lockdep annotations that catches __GFP_FS
passing errors.

Direct reclaim has had this annotation for a while, and since reclaim and
compaction are usually used in conjunction, this is unlikely to unearth
old bugs.  It's more about future proofing and peace of mind.

Link: https://lore.kernel.org/20260722150006.3848560-1-hannes@cmpxchg.org
Link: https://lore.kernel.org/20260722150006.3848560-2-hannes@cmpxchg.org
Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Gregory Price <gourry@gourry.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-__gfp_fs-lockdep-annotation-for-direct-compaction
+++ a/mm/page_alloc.c
@@ -4149,12 +4149,14 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 
 	psi_memstall_enter(&pflags);
 	delayacct_compact_start();
+	fs_reclaim_acquire(gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
 								prio, &page);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
+	fs_reclaim_release(gfp_mask);
 	psi_memstall_leave(&pflags);
 	delayacct_compact_end();
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-mempolicy-fix-automatic-numa-balancing-for-shmem.patch

