Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C61D3451CD
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 02:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788662160; cv=none; b=SpRva3An5pNZ6t3ZRUE6h0srucr2TL0b6IPRHT4kyN+i5+xAzury7UQSOHjjDTGrIHaw8C522ywogibN9keGqQGY9nzQvd0m+EHtLIUib0Xc3Ohqo1YTNlRZkrwji1wNY1/Zq9NTTIHBPJbX9QyxH+MKNXwv+mNhCcEZ7qqMEAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788662160; c=relaxed/simple;
	bh=fU/LWf6lI7Fz6c4tCiTiro+/on61agjONT73gQ16jlk=;
	h=Date:To:From:Subject:Message-Id; b=efWm2fytQCuNJ7v+CLd2ITw+ftlewA/wCiXWADXppK3ghKLANG0XfokdtDg9cjcOPmOvNSLZYsMwHY3u9TJdJUlPbuyC0Sahh+Px2cIOTLGxoutAYhLNdhyMxEfjFHXNjP0oPy2WiesHNBujabX0vWQmWmTpZtLK9C1Xv1q1oX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lpP8IMex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lpP8IMex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7721F00A3A;
	Sun,  6 Sep 2026 02:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788662159;
	bh=5uWsHyOYWermtTLb3Kv2v6CKeelDRh0Rh6o6sNYYuac=;
	h=Date:To:From:Subject;
	b=lpP8IMexM30ijfjBSpt4GreCrPR4kvN7gD1o+GkSnWS7oO2uteLu4MshHWFgvt+j4
	 vHtGghU2KqJhGBTf+6Z1XD9ijHx9o0NiVKCOLSK7ahQyq0HSj4VuUPgEGOsDBI64l7
	 vA+8o1MPwAWZ/mtAYHh/9GSF9sFWpWX2E1PL6LB4=
Date: Sat, 05 Sep 2026 19:35:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xlpang@linux.alibaba.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,mkoutny@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch added to mm-new branch
Message-Id: <20260906023558.ED7721F00A3A@smtp.kernel.org>
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
Date: Fri, 4 Sep 2026 11:35:03 +0800

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

Link: https://lore.kernel.org/20260904033503.4067283-3-qinyuntan@linux.alibaba.com
Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/ [1]
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
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
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab
+++ a/mm/zswap.c
@@ -1254,8 +1254,8 @@ static struct shrinker *zswap_alloc_shri
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
mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch
mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch

