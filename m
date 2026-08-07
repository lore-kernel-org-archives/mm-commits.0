Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806053603C0
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068100; cv=none; b=kRgrj0pxu4+ql8g4+c1qvIYDRx/S9T2acz1RAyT0poTAhAAPhK9d3efgSSt6vm88qI6bPJzdKm+tyWPeHkIozZ9mR8OmaBMqrBsfUpDx6i5djQSAFEhiH0MGq4mh4gLVWKl/hyyHYGgcoKA1BaHdP27K/DdpaknzQnAWidT9y3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068100; c=relaxed/simple;
	bh=PGX6mOA5pE0K4Jnr9+G1r0mxB1kqjvLBRw7f/OIR004=;
	h=Date:To:From:Subject:Message-Id; b=kP5nvgu9D9CTErw91/MerHpjPDhi5+5KMWI0nks7iFPbLOyI8NX9UIntZzyhXaBFR9lqRhSWZXublMuW4yVSGn5k0ZzJoDDYGar1cIF38HxcIJulz4J5+NWuPth0eG+zLMSyy7keuleWDAzH19XZSrmCK9LRl/eZY2X6m6/y4s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aMJVFAFP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aMJVFAFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8A61F000E9;
	Fri,  7 Aug 2026 02:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068099;
	bh=T+Ql5vCxdRbZ2MAb1cHOhetjaNt0a3GapQuHhPoM6f8=;
	h=Date:To:From:Subject;
	b=aMJVFAFPJQr0rqNmmACEYcoRakWk4BfndmlGK/TPNi6Ft2oVpQuLqxGRjnKtZGKvy
	 nnFBJ4gNUTl8PaZnaJqn2h3+VVY7DGie10XjMNZ81BUCWCGXR84pvcRPCynfqcsHQp
	 cMMyEfGq6xa7Hnk+VOHVnsp30hLc4bsQ1bU+Bmn4=
Date: Thu, 06 Aug 2026 19:01:38 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hezhongkun.hzk@bytedance.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch removed from -mm tree
Message-Id: <20260807020139.5A8A61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: fix anon-only reclaim evicting file pages when swappiness=max
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/vmscan: fix anon-only reclaim evicting file pages when swappiness=max
Date: Fri, 24 Jul 2026 11:34:32 +0800

Patch series "mm/vmscan: fix swappiness=max and clean up per-node
proactive reclaim", v4.

Fixes and one cleanup.

Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count() sat
after the "cannot reclaim anon" check, so when no anon was reclaimable the
request fell back to SCAN_FILE and evicted page cache instead.

Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
callers can no longer tell an invalid argument from a busy interface;
propagate the real error code, matching the memcg path.

Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().

Patch 4 fixes the same "swappiness=max" issue for MGLRU.


This patch (of 4):

As Qi mentioned [1], when swappiness=max (SWAPPINESS_ANON_ONLY) is set,
the reclaim logic is expected to reclaim anonymous pages exclusively. 
However, due to the current ordering of checks in get_scan_count(), file
pages may still be evicted if can_reclaim_anon_pages() returns false,
which contradicts the semantics of SWAPPINESS_ANON_ONLY.

Reproducer in a cgroup holding 64M of file cache, with no swap configured:

  Before (file cache is wrongly evicted):
    # cat memory.stat
    anon 196608
    file 67178496
    pgscan_proactive 0
    # echo "64M swappiness=max" > memory.reclaim
    # cat memory.stat
    anon 208896
    file 4096                 <- page cache evicted
    pgsteal_proactive 16400
    pgscan_proactive 16400

  After (file cache is left intact):
    # cat memory.stat
    anon 200704
    file 67178496
    pgscan_proactive 0
    # echo "64M swappiness=max" > memory.reclaim
    -bash: echo: write error: Resource temporarily unavailable
    # cat memory.stat
    anon 208896
    file 67178496             <- page cache untouched
    pgsteal_proactive 0
    pgscan_proactive 0

Fix this by bailing out early when SWAPPINESS_ANON_ONLY is set and no
anonymous pages are reclaimable, before falling back to file reclaim.

Link: https://lore.kernel.org/20260724033435.2573323-1-ridong.chen@linux.dev
Link: https://lore.kernel.org/20260724033435.2573323-2-ridong.chen@linux.dev
Link: https://lore.kernel.org/cgroups/7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev/ [1]
Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Suggested-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max
+++ a/mm/vmscan.c
@@ -2494,6 +2494,23 @@ static void get_scan_count(struct lruvec
 	enum scan_balance scan_balance;
 	enum lru_list lru;
 
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), bail out instead of falling back to evicting file pages,
+	 * which would violate the anon-only semantics.
+	 */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
+			memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
+			return;
+		}
+		scan_balance = SCAN_ANON;
+		goto out;
+	}
+
 	/* If we have no swap space, do not bother scanning anon folios. */
 	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
 		scan_balance = SCAN_FILE;
@@ -2512,13 +2529,6 @@ static void get_scan_count(struct lruvec
 		goto out;
 	}
 
-	/* Proactive reclaim initiated by userspace for anonymous memory only */
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
-		WARN_ON_ONCE(!sc->proactive);
-		scan_balance = SCAN_ANON;
-		goto out;
-	}
-
 	/*
 	 * Do not apply any pressure balancing cleverness when the
 	 * system is close to OOM, scan both anon and file equally
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch
mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

