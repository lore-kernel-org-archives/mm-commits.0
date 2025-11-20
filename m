Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7F6287268
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675123; cv=none; b=NVp/lOXakjsbDmprKMhzLo16gOxm1k2WJq41ukmvOwrJLs5IEePDEp2OASDiL1unSHgRwfnf8oAfcbszc+lO2kOMOPExMIr3feGdTSRn7G2I0QxkQ/UI/FIxIJmyxkf2DueRZZRkbfUMCT987s0roQWSp8TRoYSNzec18F1KfYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675123; c=relaxed/simple;
	bh=IP386IDavsZuqNG2g/EIxKszBLxbgqI9vH3SB9vlLrs=;
	h=Date:To:From:Subject:Message-Id; b=hw30OXWT93zm+yHjDkMDpIxZ/WWIHAdnhl/cfraxpLZ9QiSETIkVg6v6CBTEviKN8f8lXkKhBlvOa0tTMSTkR9huIudJT4D5UCiILRfkm74pj6hSZyAd5BW28Kt+ltpfd878wrEaHuYeY6ZDQTCqgXOXCMhaQrLYF+VYxJLjT90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=stUhnUcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="stUhnUcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73493C4CEF1;
	Thu, 20 Nov 2025 21:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675123;
	bh=IP386IDavsZuqNG2g/EIxKszBLxbgqI9vH3SB9vlLrs=;
	h=Date:To:From:Subject:From;
	b=stUhnUcFuq1wDkwA0Y8DrdFpVwKR10bY013t30OoW6ZTMwtOti9ftTB++VxKXW9gX
	 V6qTxA2u189ylX93boAWPrgKcRWzIDTlPZywzD6GZm67q4h9NNxNFGLcWBffMQ+Zmv
	 OdstH1QrLafvBPnQMuR1gJ1/S64YFOL8jRlrU9jU=
Date: Thu, 20 Nov 2025 13:45:22 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch removed from -mm tree
Message-Id: <20251120214523.73493C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: consistently use only pmd_entry for damos_migrate
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: consistently use only pmd_entry for damos_migrate
Date: Wed, 12 Nov 2025 07:41:08 -0800

For page table walks, it is usual [1] to have only one pmd entry function.
The vaddr.c code for DAMOS_MIGRATE_{HOT,COLD} is not following the
pattern.  Instead, it uses both pmd and pte entry functions without a
special reason.  Refactor it to use only the pmd entry function, to make
the code under mm/ more consistent.

Link: https://lkml.kernel.org/r/20251112154114.66053-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   88 +++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 49 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate
+++ a/mm/damon/vaddr.c
@@ -697,7 +697,6 @@ isolate:
 	list_add(&folio->lru, &migration_lists[i]);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
@@ -707,58 +706,49 @@ static int damos_va_migrate_pmd_entry(pm
 	struct damos_migrate_dests *dests = &s->migrate_dests;
 	struct folio *folio;
 	spinlock_t *ptl;
-	pmd_t pmde;
-
-	ptl = pmd_lock(walk->mm, pmd);
-	pmde = pmdp_get(pmd);
-
-	if (!pmd_present(pmde) || !pmd_trans_huge(pmde))
-		goto unlock;
-
-	/* Tell page walk code to not split the PMD */
-	walk->action = ACTION_CONTINUE;
-
-	folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
-	if (!folio)
-		goto unlock;
-
-	if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
-		goto unlock;
-
-	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
-		migration_lists);
-
-unlock:
-	spin_unlock(ptl);
-	return 0;
-}
-#else
-#define damos_va_migrate_pmd_entry NULL
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
-static int damos_va_migrate_pte_entry(pte_t *pte, unsigned long addr,
-		unsigned long next, struct mm_walk *walk)
-{
-	struct damos_va_migrate_private *priv = walk->private;
-	struct list_head *migration_lists = priv->migration_lists;
-	struct damos *s = priv->scheme;
-	struct damos_migrate_dests *dests = &s->migrate_dests;
-	struct folio *folio;
-	pte_t ptent;
-
-	ptent = ptep_get(pte);
-	if (pte_none(ptent) || !pte_present(ptent))
-		return 0;
+	pte_t *start_pte, *pte, ptent;
+	int nr;
 
-	folio = vm_normal_folio(walk->vma, addr, ptent);
-	if (!folio)
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (ptl) {
+		pmd_t pmde = pmdp_get(pmd);
+
+		if (!pmd_present(pmde))
+			goto huge_out;
+		folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
+		if (!folio)
+			goto huge_out;
+		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
+			goto huge_out;
+		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
+				migration_lists);
+huge_out:
+		spin_unlock(ptl);
 		return 0;
+	}
+#endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
-	if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
+	start_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte)
 		return 0;
 
-	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
-		migration_lists);
+	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		nr = 1;
+		ptent = ptep_get(pte);
+
+		if (pte_none(ptent) || !pte_present(ptent))
+			continue;
+		folio = vm_normal_folio(walk->vma, addr, ptent);
+		if (!folio)
+			continue;
+		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
+			return 0;
+		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
+				migration_lists);
+		nr = folio_nr_pages(folio);
+	}
+	pte_unmap_unlock(start_pte, ptl);
 	return 0;
 }
 
@@ -824,7 +814,7 @@ static unsigned long damos_va_migrate(st
 	struct damos_migrate_dests *dests = &s->migrate_dests;
 	struct mm_walk_ops walk_ops = {
 		.pmd_entry = damos_va_migrate_pmd_entry,
-		.pte_entry = damos_va_migrate_pte_entry,
+		.pte_entry = NULL,
 		.walk_lock = PGWALK_RDLOCK,
 	};
 
_

Patches currently in -mm which might be from sj@kernel.org are


