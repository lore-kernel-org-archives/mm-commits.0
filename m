Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8031D5146
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334126; cv=none; b=UqBAkwO4HCKnldPwrlObJegrsgPpo5FGVBnUp8cX+NsETcPiA0ib7H0S4A9R88P4iF0TtbFFaZMNXzh3pFfzDUTa4BgWYwRaYk0tzSmZgpnGd20fMKfKYitsC1JHjFhHDmZO47CnobemitmZ4A9b0tcPD8oa0ZsY1yO6wBVZgr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334126; c=relaxed/simple;
	bh=uScl2uxEX/VEgJoKacnZTQiiBZUfjC+y3mSufI3gHxE=;
	h=Date:To:From:Subject:Message-Id; b=GsatRKVRS3MN9s1UKcx3QTAZWCFfNQnCxK1BAU0pL4TKCsRZu7YRshOXK5i8JV+6ai9sAxk14QXrVLooRH+oqDSr3FXPvaYYCgTjxk7MhVzDPKALxMOT4Mt7m6dEtBGcb1euOuEZf8KMMj0WOCEAsKDGz9vhetxDWTtI+jdpR4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cHslpV0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cHslpV0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEC61F0089B;
	Wed,  7 Oct 2026 00:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334125;
	bh=Wl7Pg7C2qoqVvsAn2TKS0XimcXbCeZKla2b5KQolFqE=;
	h=Date:To:From:Subject;
	b=cHslpV0BGm0gPi4fRDavIxBbHLdiNXMGUyhp2SY+YdJWDDWk3hwZHwjeqodxbbq08
	 U+YNyHTi0Cy2+OvN2q5ox5JBw4oDgBFsR5k+JYBYIFUDFENAqtmo3Jo3jS8+DbM0u7
	 mVOaS+20BQ/W3K2jIbWnXqya5PpvAuF/EhbqB26g=
Date: Tue, 06 Oct 2026 17:48:44 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-drop-the-combined-limit-gate-in-__node_reclaim.patch removed from -mm tree
Message-Id: <20261007004845.2AEC61F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: drop the combined limit gate in __node_reclaim()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-drop-the-combined-limit-gate-in-__node_reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/vmscan: drop the combined limit gate in __node_reclaim()
Date: Wed, 26 Aug 2026 20:44:09 +0800

__node_reclaim() is called from two paths: node_reclaim() and
user_proactive_reclaim().

node_reclaim() already bails out early unless node_pagecache_reclaimable()
is over pgdat->min_unmapped_pages or the reclaimable slab is over
pgdat->min_slab_pages.  The identical check inside __node_reclaim() that
guards the shrink_node() loop is therefore redundant for this path.

user_proactive_reclaim() is proactive reclaim driven by userspace and
should not be gated by the per-node min_unmapped_pages / min_slab_pages
limits at all [1].  With the gate in place, a proactive request is
silently turned into a no-op whenever the node happens to sit below both
thresholds.

Drop the gate in __node_reclaim() and always run the shrink_node() loop. 
The node_reclaim() path is unchanged, since its caller has already applied
the same test; the proactive path is no longer wrongly gated.

Link: https://lore.kernel.org/20260826124409.35569-1-ridong.chen@linux.dev
Link: https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev [1]
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Assisted-by: Claude:claude-opus-4-8
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/vmscan.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-drop-the-combined-limit-gate-in-__node_reclaim
+++ a/mm/vmscan.c
@@ -7851,16 +7851,9 @@ static unsigned long __node_reclaim(stru
 	noreclaim_flag = memalloc_noreclaim_save();
 	set_task_reclaim_state(p, &sc->reclaim_state);
 
-	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
-	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
-		/*
-		 * Free memory by calling shrink node with increasing
-		 * priorities until we have enough memory freed.
-		 */
-		do {
-			shrink_node(pgdat, sc);
-		} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
-	}
+	do {
+		shrink_node(pgdat, sc);
+	} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
 
 	set_task_reclaim_state(p, NULL);
 	memalloc_noreclaim_restore(noreclaim_flag);
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-page_counter-avoid-integer-overflow-in-effective_protection.patch
mm-mglru-fix-ineffective-memory-protection-for-non-kswapd-reclaim.patch
mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch

