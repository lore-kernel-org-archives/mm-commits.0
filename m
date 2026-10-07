Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8516830F533;
	Wed,  7 Oct 2026 00:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334355; cv=none; b=hnXQVG9ow8dtRLNFjrSmwVmRMjoeptyPgC7Se1R7Oit8oBNUs0lvEixY5mHVlR1hkr70x3HJ05wgqspAeiShrRASoJNptU+KrgLVPRu4mdpHWAvk3V/AiLMMO1wb3rcAza1BIsD1sL1jH5WDxaJWm8VYX2fH4NQTs7Ddq7lGMrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334355; c=relaxed/simple;
	bh=zFpVGf3tx82DbqstwRaosB4Kdvdz6pwxGB/B1RHPORo=;
	h=Date:To:From:Subject:Message-Id; b=Oqm+vKF8ULUgmkY5Z1ki26HWFKo7gzeyjvxPLQKHN1kdYpMxB6xmHVAlivspRx8Jkr5CPu5hxgA01syxg+exIgrR7s5nXCFCHhc5bSqwWI+coU4WzUJL+9gycN9376aybzR/ZMCsSSxKXr7Ms6jVl6hJKFbtzUBMWUKR5113OZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DJihP2Tw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DJihP2Tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8881F0089D;
	Wed,  7 Oct 2026 00:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334354;
	bh=oTUYR7opos/RqXXTuWOf2uy78JaeAD1yR1zlg2OJ2JE=;
	h=Date:To:From:Subject;
	b=DJihP2TwO/kDV+zi49r2hDd3Pp/JPHLzoj9XGESe1WY1AvVEGwRPmc0E2D9qVxKa0
	 St3eK4u7cL66aXLfOkiri+Ea+ohA2iiGmFdOSCN1VYlslahaqgub48Dl167rqeUUW0
	 Us8PJCe3VryCZi+C0rikavJZz1xIXmvEXjVugTUE=
Date: Tue, 06 Oct 2026 17:52:33 -0700
To: mm-commits@vger.kernel.org,xlpang@linux.alibaba.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,lance.yang@linux.dev,hannes@cmpxchg.org,guanwentao@uniontech.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch removed from -mm tree
Message-Id: <20261007005234.5B8881F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/list_lru: don't copy stale shrinker id from non-memcg-aware shrinkers
has been removed from the -mm tree.  Its filename was
     mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: mm/list_lru: don't copy stale shrinker id from non-memcg-aware shrinkers
Date: Tue, 1 Sep 2026 19:51:04 +0800

With cgroup.memory=nokmem, shrinker_memcg_alloc() fails with -ENOSYS for
shrinkers without SHRINKER_NONSLAB, and shrinker_alloc() falls back to a
non-memcg-aware shrinker.  On this fallback path, shrinker->id is never
assigned and keeps 0 from kzalloc(), which is a valid id belonging to
whichever memcg-aware shrinker registers first.

__list_lru_init() copies shrinker->id unconditionally, so every list_lru
backed by such a fallback shrinker (thp-deferred_split, zswap-shrinker,
workingset shadow nodes, superblock lrus, ...) ends up with
lru->shrinker_id == 0 instead of -1.

Under nokmem the list_lru collapses to the shared per-node lists, but
__list_lru_add() still calls set_shrinker_bit() against the memcg of
the added object.  Most list_lru users are unaffected because their
objects resolve to a NULL memcg without kmem accounting, but the THP
deferred split queue holds user folios, which are charged regardless of
nokmem.  On a system where no SHRINKER_NONSLAB shrinker registers,
shrinker_nr_max stays 0 and every memcg's shrinker_info has map_nr_max
== 0, so the first folio added by khugepaged triggers on every boot:

  WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x99/0xa0

On systems where a SHRINKER_NONSLAB shrinker (btrfs, xfs) did register and
expand the maps, there is no warning; instead bit 0 is set spuriously for
an unrelated shrinker.

shrinker->id is only meaningful while SHRINKER_MEMCG_AWARE is set, and all
readers inside mm/shrinker.c already check the flag before using the id. 
Make __list_lru_init() do the same and fall back to -1, so
set_shrinker_bit() is never reached with a bogus id.  The stale
shrinker->id itself is left as is; cleaning that up is a separate topic.

Verified on a machine booting with cgroup.memory=nokmem and
CONFIG_TRANSPARENT_HUGEPAGE=y: the warning fires once per boot from
khugepaged, disappears when nokmem is removed from the command line, and
no longer triggers with this fix applied and nokmem set.

Link: https://lore.kernel.org/20260901115104.2944996-1-qinyuntan@linux.alibaba.com
Fixes: fafaeceb89a5e ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Wentao Guan <guanwentao@uniontech.com>
Closes: https://lore.kernel.org/linux-mm/20260904190028.21542-1-guanwentao@uniontech.com/
Tested-by: Wentao Guan <guanwentao@uniontech.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
---

 mm/list_lru.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers
+++ a/mm/list_lru.c
@@ -666,7 +666,12 @@ int __list_lru_init(struct list_lru *lru
 	int i;
 
 #ifdef CONFIG_MEMCG
-	if (shrinker)
+	/*
+	 * If the shrinker fell back to being non-memcg-aware (e.g. with
+	 * cgroup.memory=nokmem), its id was never assigned and holds a
+	 * stale 0. Don't let set_shrinker_bit() act on it.
+	 */
+	if (shrinker && (shrinker->flags & SHRINKER_MEMCG_AWARE))
 		lru->shrinker_id = shrinker->id;
 	else
 		lru->shrinker_id = -1;
_

Patches currently in -mm which might be from qinyuntan@linux.alibaba.com are


