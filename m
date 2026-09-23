Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F8F35DA6E
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 01:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790127363; cv=none; b=X9+GJMPWZD3lZh2/45Lok3AbnUksYuYVkHoF5UABsrFeZXXPHa6EsaYzDmfILJ98IXzoq8vGrNwCtzPRyEH5YJbGHq46X8xywggOtSyOlfdNyGOMI/jgGNMo0zlW9XRpI8VO+mHeeWAJOC5XkVkBT3TnjZNND0Gp6oSNA4VTo5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790127363; c=relaxed/simple;
	bh=Zsas+kOeBrvx8YiDHjHvspyyn4WMbYRC5V4nQFgF6O0=;
	h=Date:To:From:Subject:Message-Id; b=YORE2eLkDBhmZTIQ0hxIcU/WLaw5PQ/QiPQo7WhNP7SL0aLVnKfd3kEjZimFjKv+EEX3zWbG2V1wwIBmZ3cYTekqq9RJdzsE2dak6atckGYYqAosEemCBxZd8SeOv7Taoi/w3XKVMvViAY4v6U6/faKPr3FXmI6HVyAT5WAVtTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b+1ZCvgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b+1ZCvgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730E71F000FF;
	Wed, 23 Sep 2026 01:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790127361;
	bh=oAzqddTkLWc8xA8fF8AbJrKVKDIxXn/QlL2g4FbBCmc=;
	h=Date:To:From:Subject;
	b=b+1ZCvgcHvQQPB3q6IkM493dXL+nqDjfIv7EG8pOGjOdc6IJSgZommTFw1pOvBhcO
	 B83Y7LQa5la0v4ZGn6t3Pb+nIWAkMIxsZQPQbCHASM1sWkqhRHQkG1h+9gY6qQjygg
	 JYUiU6Fx8u8UxefuWQ57UPePBTiPIA9+qwpAdtFA=
Date: Tue, 22 Sep 2026 18:36:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosry@kernel.org,xlpang@linux.alibaba.com,usama.arif@linux.dev,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus.patch added to mm-new branch
Message-Id: <20260923013601.730E71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
has been added to the -mm mm-new branch.  Its filename is
     mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus.patch

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
Subject: mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
Date: Thu, 10 Sep 2026 16:07:20 +0800

With cgroup.memory=nokmem, __list_lru_init() collapses every list_lru into
per-node lists.  That is fine for slab objects, which are not charged per
memcg without kmem accounting.  But a lru backed by a SHRINKER_NONSLAB
shrinker, e.g.  the THP deferred split queue or the zswap entries, holds
user memory, which is charged regardless of nokmem.  Collapsing such an
lru loses the per-memcg view of its objects.  Reclaim can no longer target
just the cgroup under pressure.

Keep such lrus memcg aware under nokmem when their backing shrinker is
registered SHRINKER_NONSLAB.

This leaves the savings of nokmem intact: slab-backed lrus (e.g.  the
superblock dentry/inode lrus) still fall back to the per-node lists, and
the per-memcg lists are allocated only when a memcg actually holds such
objects.

Link: https://lore.kernel.org/20260910080722.3961351-3-qinyuntan@linux.alibaba.com
Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
---

 mm/list_lru.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus
+++ a/mm/list_lru.c
@@ -677,7 +677,9 @@ int __list_lru_init(struct list_lru *lru
 	else
 		lru->shrinker_id = -1;
 
-	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
+	if (mem_cgroup_disabled() ||
+	    (mem_cgroup_kmem_disabled() &&
+	     (!shrinker || !(shrinker->flags & SHRINKER_NONSLAB))))
 		memcg_aware = false;
 #endif
 
_

Patches currently in -mm which might be from qinyuntan@linux.alibaba.com are

mm-list_lru-disable-memcg-awareness-under-cgroup_disable=memory.patch
mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch
mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing.patch
mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus.patch
mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch
mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch

