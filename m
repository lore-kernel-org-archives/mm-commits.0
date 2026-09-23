Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCAE35F18B
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 01:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790127366; cv=none; b=CLZT87/tr0ZsgHzqTxa+w9h8lU/dGc6Se6Vlfe8xAgCmN2tdjQQoMghR7bsIt9T2KlvVrgEMBHoWzwK+Z49AxUCkWMqLYgSCF2RnQfLOascj/gtQvsVTSkRgLAycl2yC2d6p1sAJYPuwXgy5pxqcwPJwXpQtHXfCnRjEds4y7ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790127366; c=relaxed/simple;
	bh=Dmz1/jVi6T3nqcnPBMmpxQ6cGNoIXxkak5Y4rqjkhTQ=;
	h=Date:To:From:Subject:Message-Id; b=TcXCecr41mecEnosYsE7Bb5MJr3p4O4hykHS3bJu2jIZXws5dDBAc/aFG502dgE08tkLWRCcg03bcsnVQEWoPZ1Gv3TuXClkBQty9i8wjmxYdeOb9HZrP1AMpuBLj2UHWR0W4GT1c60oKXco85oqdlmfkYAA64OsL9JgHS81JMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VGO8An+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VGO8An+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585EE1F000FF;
	Wed, 23 Sep 2026 01:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790127365;
	bh=44DE0RS71fKxYaHnGvyKaLxlucpDBjaLUiy79N7Flws=;
	h=Date:To:From:Subject;
	b=VGO8An+5IudZqXE9ILSNMTl28DNpdtvZayQSOLFFpW2mrhxQRcsoj6elGE+MsXPfZ
	 hwN2kqsEvfCeeorhJAXViDFMcKFeZXiogGueZJiaazeNzE2W9Q/xr7iND+F1QJQkDj
	 lUPr6LxdSr6P1tKOh5PhIMUQrqxt8A39uJfto1Y4=
Date: Tue, 22 Sep 2026 18:36:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosry@kernel.org,xlpang@linux.alibaba.com,usama.arif@linux.dev,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch added to mm-new branch
Message-Id: <20260923013605.585EE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch

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
Subject: mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
Date: Thu, 10 Sep 2026 16:07:22 +0800

With kmem accounting disabled (cgroup.memory=nokmem), memcg reclaim never
invokes the zswap shrinker: a cgroup under memory pressure does not write
back its own zswapped pages to make room; they are only written back by
global reclaim or once the global pool limit kicks in.

The zswap shrinker is registered memcg-aware but without SHRINKER_NONSLAB,
so under nokmem it is treated as a slab shrinker: before commit
03375203e1da ("mm: do not allocate shrinker info with
cgroup.memory=nokmem") it was skipped by the !memcg_kmem_online() check in
shrink_slab_memcg(); since that commit it is demoted to non-memcg-aware at
registration.  But the zswap shrinker is not a slab shrinker: it tracks
zswap entries and resolves the owning memcg from the folio's objcg,
independent of kmem accounting.

This was noticed by Michal during review of the patch "mm/list_lru: don't
copy stale shrinker id from non-memcg-aware shrinkers" [1].

Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs under
memcg reclaim with nokmem.

Link: https://lore.kernel.org/20260910080722.3961351-5-qinyuntan@linux.alibaba.com
Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/ [1]
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab
+++ a/mm/zswap.c
@@ -1297,8 +1297,8 @@ static struct shrinker *zswap_alloc_shri
 {
 	struct shrinker *shrinker;
 
-	shrinker =
-		shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE, "mm-zswap");
+	shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE |
+				  SHRINKER_NONSLAB, "mm-zswap");
 	if (!shrinker)
 		return NULL;
 
_

Patches currently in -mm which might be from qinyuntan@linux.alibaba.com are

mm-list_lru-disable-memcg-awareness-under-cgroup_disable=memory.patch
mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch
mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing.patch
mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus.patch
mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch
mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch

