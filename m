Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2904435294E
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 22:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788647108; cv=none; b=AMmRf8/+CkLXIv3+S80R4kloSnQ9iuUtWA3m5G+ndSbjnV/MERNfFeF42AATHQe/ec5h28uwCYKsf2BkbB5ZcaLy/pSvT0Dho/cUV4qacA1xOJkvmWQIn4sPB/Pw0Yu1WsyPWrcpX8lFZoIVIrTlbPytP1gdTGBG+zVX3gRszj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788647108; c=relaxed/simple;
	bh=35QVhRiNkfd+d14KjTgZjl1G0ofDQOp9U+9v5mc4HH4=;
	h=Date:To:From:Subject:Message-Id; b=Mjpf8lEtEf30SXt2umVLJfsLpCxgmTLavJXmszxRMRdPPv3na7gLVcMFvymFSmHLxrr/M3dEnwjGh46H//RWejKmlXEt0euflNBuyW16lkNkelhJ67g0zb+kNamfXF4nKpeqMRwgHXRZvaH5VNciHFBB3KlurJ0o5oUzhz/6kAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jA/sV+Up; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jA/sV+Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52DE1F00A3A;
	Sat,  5 Sep 2026 22:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788647106;
	bh=xmZy3U9q8Ugmf8bz8sNoVayQ49kZoQrnEjKQGG+3J5E=;
	h=Date:To:From:Subject;
	b=jA/sV+UpwyMM91A8xcwYLtRTzsJoM9ruHkVUnmq6ji5CdtEgWbctHtnumDT2U3M8d
	 N0NwhPsVm8ZWtfEYiOVbLIXZxleDZTlFBEEryJ4AuEzaohmW9vgWTnrmrSuFdDreoy
	 4G155z3MnfPOFYM9nM0v3n7ZBCqL4RDPXrWri4Cc=
Date: Sat, 05 Sep 2026 15:25:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch added to mm-new branch
Message-Id: <20260905222506.C52DE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: move the lru_zone_size sanity check to the reader side
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/memcontrol: move the lru_zone_size sanity check to the reader side
Date: Sun, 06 Sep 2026 00:51:06 +0800

Patch series "mm/mglru: clean up folio counters and flag usage", v6.

This is a cleanup series separated out from the MGLRU-FG series [1].  As
that series is getting too long in following updates, seperate out the
clean up part for easier review and merge.

No feature change is intended, except one bugfix.  It mostly replaces the
open-coded bit operations scattered throughout the MGLRU code with new
helpers, with proper kdocs, sanity debug checks, and hardens a few MGLRU
functions.

A subtle generation counter leak is also found during the refactoring and
the fix is included.

Also collected review feedbacks on the cleanup part from the posted
series.


This patch (of 6):

Instead of using an unsigned long and checking the counter value at the
updater side, turn the counter into a signed long and check at the reader
side.  This reduces overhead and simplifies the code.

commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
added a sanity check for memcg counter underflow: lru_zone_size is
unsigned, so an underflow wraps it around and returns an enormously large
number, then the memcg shrinker loops almost forever as the calculated
number of folios to shrink is huge.  It also checked if a zero value
matches the empty LRU list, so the positive and negative deltas had to be
handled separately.  However that emptiness check was already removed by
commit b4536f0c829c ("mm, memcg: fix the active list aging for lowmem
requests when memcg is enabled"), so handling the deltas separately is no
longer needed.

The remaining update-side check is costly and cannot really catch the leak
it is after anyway.  It runs on every LRU folio, and if a folio was
removed without updating the counter while other folios remain on the LRU,
the WARN only triggers much later, from a likely innocent callsite.  While
readers are much rarer than writers, only the reclaim and reparenting
paths read it, once per batch.

Checking at the reader side instead leaves the update path a plain
addition, and puts the warning where the value is actually consumed.

Note this changes the behavior on underflow: the correction is removed and
a negative value is kept.  A massive leak of the LRU size counter would
indicate that something else has gone very wrong, and one should fix that
leaking site instead.  Besides, the original behavior might cause false
positives, or make things worse if the accounting happens after the actual
insertion: the value is not leaked, just delayed, so force-fixing it would
cause a bigger problem.  The warning now only kicks in when a consumer
actually uses it, in which case the reader gets zero.

Link: https://lore.kernel.org/20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com
Link: https://lore.kernel.org/20260906-mglru-flags-cleanup-v6-1-9aacbd77d4ca@tencent.com
Link: https://lore.kernel.org/linux-mm/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 +++++++--
 mm/memcontrol.c            |   18 +-----------------
 2 files changed, 8 insertions(+), 19 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side
+++ a/include/linux/memcontrol.h
@@ -100,7 +100,7 @@ struct mem_cgroup_per_node {
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
 	CACHELINE_PADDING(_pad2_);
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	long			lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
@@ -888,10 +888,15 @@ static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
+	long val;
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	val = READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	if (WARN_ON_ONCE(val < 0))
+		return 0;
+
+	return val;
 }
 
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
--- a/mm/memcontrol.c~mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side
+++ a/mm/memcontrol.c
@@ -1529,28 +1529,12 @@ void mem_cgroup_update_lru_size(struct l
 				int zid, long nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
-	unsigned long *lru_size;
-	long size;
 
 	if (mem_cgroup_disabled())
 		return;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	lru_size = &mz->lru_zone_size[zid][lru];
-
-	if (nr_pages < 0)
-		*lru_size += nr_pages;
-
-	size = *lru_size;
-	if (WARN_ONCE(size < 0,
-		"%s(%p, %d, %ld): lru_size %ld\n",
-		__func__, lruvec, lru, nr_pages, size)) {
-		VM_BUG_ON(1);
-		*lru_size = 0;
-	}
-
-	if (nr_pages > 0)
-		*lru_size += nr_pages;
+	mz->lru_zone_size[zid][lru] += nr_pages;
 }
 
 /**
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch

