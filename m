Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354B2481253;
	Tue,  1 Sep 2026 17:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283796; cv=none; b=PsxcnDeOzrsEI2mlObh2GXMHGrkvu9Za2GiKrNoQM5PYg+V/ZKa7llyANrwcGSD9VpN2zivc74znxCtxEVcRu6otCZmFP4iZ0Wu6HaMsB1RqfaBDHosYbLw+Nf6JP2QUfrm4Hw2ZwpnGz+vskH4N+krI4mBQT5ZyWfKyiwx5QKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283796; c=relaxed/simple;
	bh=XgAgMt83WR5JZmohgcgxN/eKWPWoNP6kK5bWy+ejKv8=;
	h=Date:To:From:Subject:Message-Id; b=tf9qZfAVSi/7e3NMvsT8inDReWwDNYuwDaWMxR7onNtF95t2xrY0FE4S52hiDjg4OVurrJ9lfVq9ZVDTjQh2X6+cJG83Y0We4GknhrSSUqcYfu1O+HT1clXicsqab972U/ENiMkI05eofqQMuxfL+mrT59Rz/1voE+JCJqkX83E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C4YXJSOt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C4YXJSOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3251F000E9;
	Tue,  1 Sep 2026 17:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788283794;
	bh=jvm/HKiMmeJIdMrMJyMkbzF2E1iHezjHutK+RooSl8U=;
	h=Date:To:From:Subject;
	b=C4YXJSOt0oUXpWO7CqxPJILPUAoFXX8HMj3oMjMY9Gl+CvmirAa8SfINoa0/us94+
	 PXiEu4SDr1tabvlrw4CVmEYI7AWchpoy205/hOTzUwfaHlGoIrITskPGjKgyg7EX9W
	 o35m4Kxr3fgUy8O3uCJnM+Hxw9ph/EoSHxs3hAX8=
Date: Tue, 01 Sep 2026 10:29:54 -0700
To: mm-commits@vger.kernel.org,xlpang@linux.alibaba.com,stable@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mkoutny@suse.com,mhocko@suse.com,lance.yang@linux.dev,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch added to mm-new branch
Message-Id: <20260901172954.BB3251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/list_lru: don't copy stale shrinker id from non-memcg-aware shrinkers
has been added to the -mm mm-new branch.  Its filename is
     mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch

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
__list_lru_add() still calls set_shrinker_bit() against the memcg of the
added object.  Most list_lru users are unaffected because their objects
resolve to a NULL memcg without kmem accounting, but the THP deferred
split queue holds user folios, which are charged regardless of nokmem. 
Since no memcg-aware shrinker can register under nokmem, shrinker_nr_max
stays 0 and every memcg's shrinker_info has map_nr_max == 0, so the first
folio added by khugepaged triggers on every boot:

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
Fixes: 03375203e1da8 ("mm: do not allocate shrinker info with cgroup.memory=nokmem")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch

