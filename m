Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07E62BEC3F;
	Tue, 22 Sep 2026 03:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790048997; cv=none; b=c/tZ6CrWflarjf+evKxJlJCrwHJJry8hivKCkw7Jsh87Yq4EIhD30sbSr82zEKBYm15WT6vQv6BFN9cBBprk7p1WcHRD5JcJsd8ms7YQb1H3jiIul9BaV4g7rW8Hd8hsnXi20575GmEP4Vcvf/xAmuIbyPOgjwID7tpV9LV6U+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790048997; c=relaxed/simple;
	bh=WQkK+bYYEAtp2l3LuoPW9+BgNpiaFeJ7XqIl60ajtQs=;
	h=Date:To:From:Subject:Message-Id; b=XhDuPG0z5QWwY9afNbyyn9ISKcUu5mKxUaDL1FSslFyXWE6DdixyaSLoknnCbem65tO0gQ7oB9AOTVGl8+Uo01mFk9FcTK/leu5jUizwhwEuaKchpEF0hAcxd9Db1oZrqJyPxKAjGmRS5txtmtABR5c/oMuf7rv8LJ3leMgMOgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wS25B2+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wS25B2+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BBC1F000FF;
	Tue, 22 Sep 2026 03:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790048995;
	bh=BqtZ4JOMa3zYF3VegAgM17tKfLffr5NP2o/5iu1Up5A=;
	h=Date:To:From:Subject;
	b=wS25B2+ig/WXm6X0GtPbsY8PpGwpyG76PNhrTzmlLZKgwCX/zfJq3/yxxScj2hnfZ
	 r9l9OSaDgv6hWiUKjwSHGRRKdwGnmaMFod1uXyenCVWTkZBKD3PBAaLQZmCvJ25Spk
	 3kaV2azTLUPkvMZrFRYXsTFchrRARM5S9raBlGHs=
Date: Mon, 21 Sep 2026 20:49:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,david@kernel.org,chris@chrisdown.name,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch added to mm-new branch
Message-Id: <20260922034955.54BBC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: account migration target folio in per-node NR_HUGETLB vmstat
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/hugetlb: account migration target folio in per-node NR_HUGETLB vmstat
Date: Mon, 21 Sep 2026 17:12:34 +0800

Patch series "mm: fix hugetlb NR_HUGETLB accounting on folio migration".

The hugeTLB counters added by 05d4532b60e3 ("memcg/hugetlb: add hugeTLB
counters to memcg") are maintained in two per-node places:
  - the per-node vmstat counter NR_HUGETLB, exposed as nr_hugetlb in
    /proc/vmstat;
  - the per-node memcg lruvec stat, exposed via memory.numa_stat.

Both are accounted against the folio's node, and both drift when a hugetlb
folio is migrated, though in different ways.

A migration target folio is allocated by alloc_hugetlb_folio_nodemask()
and inherits the old folio's state without ever being accounted, while the
old folio is freed right after and its free is accounted.  That alone
loses vmstat accounting: the target node has no matching increment for the
decrement on the old node, so /proc/vmstat's nr_hugetlb shrinks by
nr_pages per migration.  Patch 1 accounts the folio where it is obtained,
so the increment pairs with the free in free_huge_folio() on the
successful as well as the failed migration path.  The memfd page cache
preallocation helper has the same asymmetry and is fixed in the same
patch.

The per-node lruvec stat breaks differently.  mem_cgroup_migrate() moves
the charge to the new folio and drops the old folio's memcg data, so the
old folio's free right after migration skips the memcg per-node decrement;
the count stays attributed to the old node for the rest of the charge's
life, and the target folio never gets an increment on its new node.  Patch
2 moves that per-node accounting alongside the charge in
mem_cgroup_migrate().


This patch (of 2):

The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
when a huge page is handed to a user via hugetlb_alloc_folio() and
decremented when it is returned to the pool via free_huge_folio().

A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
hugetlb_alloc_folio(), so it is never accounted, while its free always is.
For a migration target this means the target node gets no matching
increment for the decrement on the old node, so the global nr_hugetlb in
/proc/vmstat drops by nr_pages for each migration.  The same asymmetry
affects the failed migration path, which frees the target again right
away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
same helper.

alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
folios, has the same asymmetry: the folio is handed to a user without
being accounted, while its free is accounted through free_huge_folio().

Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
decrement in free_huge_folio(): a successful migration hands the folio to
a user, a failed one frees it again.

Link: https://lore.kernel.org/20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn
Link: https://lore.kernel.org/20260921-for-hugetlb_state-v1-1-8a6eec92661f@kylinos.cn
Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat
+++ a/mm/hugetlb.c
@@ -2206,6 +2206,11 @@ struct folio *alloc_hugetlb_folio_reserv
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
+
+	if (folio)
+		lruvec_stat_mod_folio(folio, NR_HUGETLB,
+				      folio_nr_pages(folio));
+
 	return folio;
 }
 
@@ -2213,24 +2218,30 @@ struct folio *alloc_hugetlb_folio_reserv
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback)
 {
-	spin_lock_irq(&hugetlb_lock);
-	if (available_huge_pages(h)) {
-		struct folio *folio;
+	struct folio *folio = NULL;
 
+	spin_lock_irq(&hugetlb_lock);
+	if (available_huge_pages(h))
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
 						preferred_nid, nmask);
-		if (folio) {
-			spin_unlock_irq(&hugetlb_lock);
-			return folio;
-		}
-	}
 	spin_unlock_irq(&hugetlb_lock);
 
-	/* We cannot fallback to other nodes, as we could break the per-node pool. */
-	if (!allow_alloc_fallback)
-		gfp_mask |= __GFP_THISNODE;
+	if (!folio) {
+		/*
+		 * We cannot fallback to other nodes, as we could break the
+		 * per-node pool.
+		 */
+		if (!allow_alloc_fallback)
+			gfp_mask |= __GFP_THISNODE;
 
-	return alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid, nmask);
+		folio = alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid,
+						    nmask);
+	}
+
+	if (folio)
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));
+
+	return folio;
 }
 
 static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch
mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch
selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers.patch
mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch
selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cross-node-migration.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch
mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch
mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch

