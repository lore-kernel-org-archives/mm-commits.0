Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956A33D1A98;
	Tue,  7 Jul 2026 20:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783455712; cv=none; b=eKVVmYHqmFm28KS5/PxIRry8wZY7p9GinakaEs0N2o6SxBZP1rSEEEA2y9746AqhjixSXEDTTGMDK6MDNZU3sLsSkVRdkELJUyzMR/H+oVBzYKKxEBzGzBKAI2ss4UtJkjMKU3i0SviwvhzHe2RE11QjL5B5sbK8W/K+HzpcAi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783455712; c=relaxed/simple;
	bh=rjfZFtku+wZMNcM21lS6VCuT8vigPkGWUfb5PNwJKzU=;
	h=Date:To:From:Subject:Message-Id; b=mDYkWgsfZ3ikJZeS8qRETYpnW1NeRvofh7OdF5i6iib2ieHSwN/XMAf6aKY/SMTIQ12m7gYE/5/wPyJKXpI7RSYgqsx9xUOctcSiyYPwzFpJOALZIaPxKfbMdHoZ4DdloCIGeKKAcc4Ftk7ZtiLMrLFb7eo40iN28n8DSPvENeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aC7koMnd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aC7koMnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3748A1F000E9;
	Tue,  7 Jul 2026 20:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783455711;
	bh=C2jZV48BzSVIz2TLVrSj+BBmx/csPIiRUIpuC34CgwQ=;
	h=Date:To:From:Subject;
	b=aC7koMndKQzx7qCqK+rp2nS6II7BAP/zepC93jNAlJSgtpg63ediNMeUhDioe/3Gt
	 jghy6ZHjPP83/3GM7boMcHvXNpvmrIsZBiD7DEHkwvW4GzpWV+oOnW2ls8dD32rfND
	 fmWq5BD+VRczDWcIXs+eij3RE9DCj/2U0l/wawAM=
Date: Tue, 07 Jul 2026 13:21:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,baolin.wang@linux.alibaba.com,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-missing-migratable-flag-on-same-node-hugetlb-migration.patch added to mm-new branch
Message-Id: <20260707202151.3748A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix missing migratable flag on same-node hugetlb migration
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-fix-missing-migratable-flag-on-same-node-hugetlb-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-missing-migratable-flag-on-same-node-hugetlb-migration.patch

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
From: Wupeng Ma <mawupeng1@huawei.com>
Subject: mm/hugetlb: fix missing migratable flag on same-node hugetlb migration
Date: Tue, 7 Jul 2026 19:02:54 +0800

Commit ba23f58de896 ("mm/migrate: don't call
folio_putback_active_hugetlb() on dst hugetlb folio") moved setting of the
migratable flag and active-list placement from
folio_putback_active_hugetlb(dst) into move_hugetlb_state(), so that the
freshly allocated destination folio is handled where allocation is known
to have succeeded.

Unfortunately, the new code was appended after the existing
temporary-folio block in move_hugetlb_state(), which contains an early
return added earlier by commit 5af1ab1d24e08 ("mm/hugetlb: optimize the
surplus state transfer code in move_hugetlb_state()"):

  if (folio_test_hugetlb_temporary(new_folio)) {
      ...
      if (new_nid == old_nid)
          return;                       <-- skips the new code
      ...
  }

  /* added by ba23f58 */
  folio_set_hugetlb_migratable(new_folio);
  list_move_tail(&new_folio->lru, ...&h->hugepage_activelist);

When the destination folio is temporary (i.e.  the hugetlb pool was
exhausted and the migration callback fell back to
alloc_migrate_hugetlb_folio()) and the migration does not cross a node --
the common case, and always true on a single-NUMA system --
move_hugetlb_state() returns before setting the migratable flag or adding
the new folio to the active list.  The destination folio is then installed
in the page table but cannot be isolated afterwards, since
folio_isolate_hugetlb() rejects folios without the migratable flag; a
subsequent soft-offline, hard-offline or memory-hotplug offline of that
folio fails with -EBUSY.

This was reproduced on a single-NUMA arm64 VM: a second MADV_SOFT_OFFLINE
on an already-migrated hugetlb page returned EBUSY and logged "hugepage
isolation failed".

Keep the surplus adjustment, which is the only part that depends on the
node crossing, guarded by `if (new_nid != old_nid)', while making the
migratable flag and active-list placement unconditional.  This preserves
the cleanup intent of ba23f58 and closes the early-return hole.

Link: https://lore.kernel.org/20260707110254.3147686-1-mawupeng1@huawei.com
Fixes: ba23f58de896 ("mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio")
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-migratable-flag-on-same-node-hugetlb-migration
+++ a/mm/hugetlb.c
@@ -7252,14 +7252,14 @@ void move_hugetlb_state(struct folio *ol
 		 * There is no need to transfer the per-node surplus state
 		 * when we do not cross the node.
 		 */
-		if (new_nid == old_nid)
-			return;
-		spin_lock_irq(&hugetlb_lock);
-		if (h->surplus_huge_pages_node[old_nid]) {
-			h->surplus_huge_pages_node[old_nid]--;
-			h->surplus_huge_pages_node[new_nid]++;
+		if (new_nid != old_nid) {
+			spin_lock_irq(&hugetlb_lock);
+			if (h->surplus_huge_pages_node[old_nid]) {
+				h->surplus_huge_pages_node[old_nid]--;
+				h->surplus_huge_pages_node[new_nid]++;
+			}
+			spin_unlock_irq(&hugetlb_lock);
 		}
-		spin_unlock_irq(&hugetlb_lock);
 	}
 
 	/*
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

mm-hugetlb-fix-missing-migratable-flag-on-same-node-hugetlb-migration.patch

