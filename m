Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605BB3451CD
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 02:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788662158; cv=none; b=S55r7xu0uFYGylR0Ag7Ki615as8e7BOBaNb3hdpYYPv1ntaOtkrJm1QKvJOYnp1hMrxtEVdstAaunbjYbDtCSt4y/52qBr8KVNNPUBHEc7aQOJpUant2OTdZuIn3XNTYa9EAa3lK4xpfTELLMPQe4JL3m3S5k/PnTaDao7DmpSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788662158; c=relaxed/simple;
	bh=cn1++h0Smtvr91TDQosnFVVRUqeFe/iiaKeP2z2gB3Y=;
	h=Date:To:From:Subject:Message-Id; b=BkWXnu7JyzMcF+l2H2dEI/gLbKjNpPU1DZ5IQa4wpXTXD4FIjiLyZ4uMeI6vjVxkl/I8+rah2v0hq22wfj4S3ZQKBQGwVpmNwtBG4huIaf8e9tAL/6TcGOranZFdwZQ6CifZSTNW6M/YqXcJTtnAlBgPng43oPOKdGyWHCH7Ux4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EJMkXdux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EJMkXdux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFC51F00A3A;
	Sun,  6 Sep 2026 02:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788662156;
	bh=WXlcVxIMwxZQdhFlKIV5b+9G3l3bJ2jh4LRHklRrf80=;
	h=Date:To:From:Subject;
	b=EJMkXdux5c6Ect6x6LJ0CK5AV+lk9mj+KzOyVIt3Ds9Ea2AH6EH+aTI5x88A5W8vv
	 7Ckof4L4eYrxBjwdxWZbZ/1Bd83wNsZHCud/uR7lGxeeaNxhiqG1mrIxMCN47Ilsdq
	 QxB+1gxMkzFDOZcXIA5I0OBykVPykdH2Cdx9X1Oc=
Date: Sat, 05 Sep 2026 19:35:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xlpang@linux.alibaba.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,mkoutny@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch added to mm-new branch
Message-Id: <20260906023556.CAFC51F00A3A@smtp.kernel.org>
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
Suggested-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Zi Yan <ziy@nvidia.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch
mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch

