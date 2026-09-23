Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74323382F9
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 01:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790126546; cv=none; b=t/BTZaJwbikqqDZw30JcwUz2CjPwQeZBYj7i8Y0GJIfoCrHCvqrs12r4evPLRfwO/z1R/H8NmJcdTwy59P4QUZLy4WfyldgZwtsd2tWujbFSDwoCIPLzvRora7hkgDGNQMzFFbJB02tYLhTwyGf8m+VsVQunmV2NsuTJdajhwO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790126546; c=relaxed/simple;
	bh=YosFXku/DW1dV+tlbN76QjUCR35kgCRs71k4bcjOr2M=;
	h=Date:To:From:Subject:Message-Id; b=fM7OH/TpU8kEK/uoMj0V/qbvFGLlESIVNC/K2hOZX2jKJVtxpo7a4K7YnIJMHfki+HUJcUV57cBXf0sgboSF2H7MtuwEwgDPjGutP3w5v/9vovzHopza3TX+Aut4yAWkVbZMec3sVspcrmtnDblNnugQOFGkE+ISuR1JWFGjvB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YxseIRw2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YxseIRw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E311F000FF;
	Wed, 23 Sep 2026 01:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790126544;
	bh=K06UQqyPsbas5gdh7BXhVVIkb+lFhTv3ydEOHYPpvOE=;
	h=Date:To:From:Subject;
	b=YxseIRw2OSFMc1VBiUSnanM/XA74bB7qi9iCJSbZF14r06fuHpC8QLq3ErrwMF1Xc
	 x0THDirErvhBNl0PHaFBeViVWwj0S40uNXoKa5s05QSaLrwbk05pOma/BKvemRObGP
	 nUWF4D3F9uW6FS3vvdUVKxRWDKDrZ4oQv/JEjDMs=
Date: Tue, 22 Sep 2026 18:22:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xlpang@linux.alibaba.com,usama.arif@linux.dev,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,mkoutny@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch removed from -mm tree
Message-Id: <20260923012224.22E311F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
has been removed from the -mm tree.  Its filename was
     mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
Date: Fri, 4 Sep 2026 11:35:02 +0800

Patch series "mm: restore SHRINKER_NONSLAB on THP and zswap shrinkers".

While reviewing the patch "mm/list_lru: don't copy stale shrinker id from
non-memcg-aware shrinkers" (now in mm-unstable), Michal noticed that the
two non-slab memcg-aware shrinkers, the THP deferred split shrinker and
the zswap shrinker, are registered without SHRINKER_NONSLAB [1].

Without that flag, booting with cgroup.memory=nokmem silently demotes both
shrinkers to non-memcg-aware ones: memcg (limit-induced) reclaim neither
splits partially unmapped THPs nor writes back zswapped pages of the
cgroup under pressure.

Patch 1 restores the flag on the deferred split shrinker; it was lost when
commit fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
re-registered the shrinker.

Patch 2 adds the flag to the zswap shrinker, which has never carried it
since its introduction in commit b5ba474f3f51 ("zswap: shrink zswap pool
based on memory pressure").


This patch (of 2):

On a system booted with cgroup.memory=nokmem, the deferred split shrinker
is quietly demoted to a non-memcg-aware one.  As a result, partially
unmapped THPs are only split under global reclaim; memcg (limit-induced)
reclaim never splits them, so a cgroup under memory pressure keeps its
underused THPs intact.

This is a regression from commit fafaeceb89a5 ("mm: switch deferred split
shrinker to list_lru"), which re-registered the shrinker without
SHRINKER_NONSLAB.  The shrinker had carried this flag since commit
0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
precisely so it would keep working with kmem accounting disabled.  Without
the flag, shrinker_memcg_alloc() fails with -ENOSYS under nokmem and the
shrinker loses its memcg awareness.

This was noticed by Michal during review of the patch "mm/list_lru: don't
copy stale shrinker id from non-memcg-aware shrinkers" [1].

Restore the flag.

Link: https://lore.kernel.org/20260904033503.4067283-1-qinyuntan@linux.alibaba.com
Link: https://lore.kernel.org/20260904033503.4067283-2-qinyuntan@linux.alibaba.com
Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/ [1]
Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker
+++ a/mm/huge_memory.c
@@ -1064,7 +1064,8 @@ int folio_memcg_alloc_deferred(struct fo
 static int __init thp_shrinker_init(void)
 {
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
-						 SHRINKER_MEMCG_AWARE,
+						 SHRINKER_MEMCG_AWARE |
+						 SHRINKER_NONSLAB,
 						 "thp-deferred_split");
 	if (!deferred_split_shrinker)
 		return -ENOMEM;
_

Patches currently in -mm which might be from qinyuntan@linux.alibaba.com are

mm-list_lru-disable-memcg-awareness-under-cgroup_disable=memory.patch
mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch
mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch
mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing.patch
mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus.patch

