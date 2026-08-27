Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69127372EFF;
	Thu, 27 Aug 2026 20:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861318; cv=none; b=GqreeGUECSGDeFlG1NXKGFz7piJ/eKg5DQF4665n/Pc11vD8jAa2JJKsxh5ZYdvRg3G3s9KI+l3OUaxPo/RqYjhpqQfUiw82WezjIM0huBVJ54lG2Tb/gN0wgFCvGVyA/ZHGzFrl6btsnCIzc8n2LSwMrkDL6gf4ce4+zyvnGAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861318; c=relaxed/simple;
	bh=ivfvmGJOOofdSKqvxo9hS22av/AOSKBAH33GYt8CZvo=;
	h=Date:To:From:Subject:Message-Id; b=s03DVyq0keBuXvi+6wo+5du405M0/bEd8L0xKuz1EycSi810YawdrM59AKZk7sOGRseBv5cZ7Tu+m8RVobsYCHc5uMyANPCLx99dn8rLr0dGKhxmYen9Wnu9HfAC1r7iBvgWwCBqwI5p3KCBgxv5tYxhADmLeLF6I4mleRx05Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KZ964a8u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KZ964a8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A0F1F000E9;
	Thu, 27 Aug 2026 20:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787861316;
	bh=uNAcoZbE/XW0keWCDwECz7jBx2FewXBOfbmiWlf3dEM=;
	h=Date:To:From:Subject;
	b=KZ964a8u+w2gmu47Sfg4RtDnzJAKOP1ZPjl5ceWrtxxaXvOn4kbdHBVJpERMco2Qx
	 eqjpAzRQIMOl7FQHw8fnKtw4BaWDm2PY3n9E0kaY3vTXsPYlGN2qWqzclt9sLdoOu3
	 Y53StMSTTosuB3Bl2CGpAyXUg5unXRARnxYdRudg=
Date: Thu, 27 Aug 2026 13:08:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,baolin.wang@linux.alibaba.com,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-missing-migratable-flag-on-same-node-hugetlb-migration.patch removed from -mm tree
Message-Id: <20260827200836.D6A0F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix missing migratable flag on same-node hugetlb migration
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-missing-migratable-flag-on-same-node-hugetlb-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-migratable-flag-on-same-node-hugetlb-migration
+++ a/mm/hugetlb.c
@@ -7332,14 +7332,14 @@ void move_hugetlb_state(struct folio *ol
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


