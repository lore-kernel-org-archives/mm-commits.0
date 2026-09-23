Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF4835DA6E
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 01:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790127365; cv=none; b=aIBGyXTLvvKWV+xrTFmZZgzsvdmZVobjtViFTVzPvfPWnB5S7r1NEcDGu1fRGqLcGu6bJHy07MIbn7Jf6qm33Dva2RQFJrAzkWqSrG23j3MMWxBNobYEbimr9TP8BNRU7kSaRUkNiXWikAuqhCOXgsbfb/KEEZS+xxhoKK04tXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790127365; c=relaxed/simple;
	bh=nnxpWf0eEWGQhVkzKyG0ekEo4Pd07XWFf0ljyJlnOCQ=;
	h=Date:To:From:Subject:Message-Id; b=QoUEok/mwEt3xn9UuQld5U6V6v+h2a9IBWT/nPnvlS2ftZbNPb3NZNI80v1D7Gnmw5I+7CybdpSsDqyu4F8S8wJGKVhNQSHrwth3xTditNdl3x7h2F/vtUzet/CFOQQLWn96HW4uIraLDmTCw+JaJOtq+TmPcni2KBUeRlWPcUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CfuH7ekM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CfuH7ekM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609DA1F00893;
	Wed, 23 Sep 2026 01:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790127363;
	bh=poRogMh55vPiDdW3pytOUnZsvQeaV2medAui6LZHmx4=;
	h=Date:To:From:Subject;
	b=CfuH7ekMglJLd3r22LlTAZcgOj3u8jHWP/vNhnyA57wxAxXXrdbbiF0zxNqRlLxJW
	 ogpTRJrk5izvVDWDBhHwx0IAOOIV/OQWLRr6p1sYHn2KNWbKa6TM92Vwtnol2fhsAn
	 7vjdKSnxHw4b5b9tsYAUlXwHIoakAPO+jHlNRNYc=
Date: Tue, 22 Sep 2026 18:36:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosry@kernel.org,xlpang@linux.alibaba.com,usama.arif@linux.dev,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch added to mm-new branch
Message-Id: <20260923013603.609DA1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
has been added to the -mm mm-new branch.  Its filename is
     mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch

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
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
Date: Thu, 10 Sep 2026 16:07:21 +0800

On a system booted with cgroup.memory=nokmem, the deferred split shrinker
is demoted to a non-memcg-aware one.  As a result, partially unmapped THPs
are only split under global reclaim; memcg (limit-induced) reclaim never
splits them, so a cgroup under memory pressure keeps its underused THPs
intact.

The shrinker has carried SHRINKER_NONSLAB since commit 0a432dcbeb32 ("mm:
shrinker: make shrinker not depend on memcg kmem") precisely so it would
keep working with kmem accounting disabled.  Commit fafaeceb89a5 ("mm:
switch deferred split shrinker to list_lru") dropped it knowingly: under
nokmem the list_lru collapses into a shared per-node list while
__list_lru_add() still sets the shrinker bit on whichever memcg happens to
add the first item, and with the flag set the shrinker would run twice per
reclaim cycle [1].

NONSLAB-backed lrus keep their per-memcg lists under nokmem now, so the
shrinker bit identifies the owning memcg again.  Restore the flag.

This was noticed by Michal during review of the patch "mm/list_lru: don't
copy stale shrinker id from non-memcg-aware shrinkers" [2].

Link: https://lore.kernel.org/20260910080722.3961351-4-qinyuntan@linux.alibaba.com
Link: https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/ [1]
Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/ [2]
Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker
+++ a/mm/huge_memory.c
@@ -1059,7 +1059,8 @@ int folio_memcg_alloc_deferred(struct fo
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
mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing.patch
mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus.patch
mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch
mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch

