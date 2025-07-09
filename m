Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F65521ABDD
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 02:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752027842; cv=none; b=l8VVTbm6YbRZvn3Rd/PKBF8hlgJPnzh+vDqypOrCTy0zffw0X0ru0kLB9+I0gQrcAtrAwjkgrHiVD00uDosNgvjDvKlbm/fSxrNJk9PWY+1Q69HJ2kYvGmzxeQ3k6kMUqRDzT4dA2GthXhSW8Rwyn6uEs8625ZBOo+nSIk4oYXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752027842; c=relaxed/simple;
	bh=hnBLcaMzq5y9OAV1sKI+OlKzB+0VwxLKnczTc5dRK6c=;
	h=Date:To:From:Subject:Message-Id; b=rbq7IaN/D7tpxd0JG9Kr+saR3Qco28r7pKpcPVEEruTnpRDufkp6n1qNRO0MY2rM46eb+GXU3lhIdiXlTUmQ9ldmDspzF2aoNswyVvg9MYjDw/AJUtdspZOeSM5N5nH5/KHcwUhL6UsArjbvDf6NbRvG8+5TRdDmRGPQ5havpOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nLikdFo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nLikdFo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51AFC4CEED;
	Wed,  9 Jul 2025 02:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752027841;
	bh=hnBLcaMzq5y9OAV1sKI+OlKzB+0VwxLKnczTc5dRK6c=;
	h=Date:To:From:Subject:From;
	b=nLikdFo0KfvuPufyB2F/63OYNytzypE+vSzjCk7VPsWLuc6eCp/O5juCryKJLGLiZ
	 2+/s/3F+cAklF+fYy+Pfzf1jLuB7ZSyA1BFb5pyMoU3ZcY++ZcOvSZr38U6bhHzp8b
	 P+U/Z4Bjcj2sr2pBcfiLWn2tatEyF85xuLhAPfVg=
Date: Tue, 08 Jul 2025 19:24:01 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-apply-filters-in-migrate_hot-cold.patch added to mm-new branch
Message-Id: <20250709022401.B51AFC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: apply filters in migrate_{hot/cold}
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-vaddr-apply-filters-in-migrate_hot-cold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-apply-filters-in-migrate_hot-cold.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: mm/damon/vaddr: apply filters in migrate_{hot/cold}
Date: Tue, 8 Jul 2025 19:59:43 -0500

The paddr versions of migrate_{hot/cold} filter out folios from migration
based on the scheme's filters.  This patch does the same for the vaddr
versions of those schemes.

The filtering code is mostly the same for the paddr and vaddr versions. 
The exception is the young filter.  paddr determines if a page is young by
doing a folio rmap walk to find the page table entries corresponding to
the folio.  However, vaddr schemes have easier access to the page tables,
so we add some logic to avoid the extra work.

Link: https://lkml.kernel.org/r/20250709005952.17776-14-bijan311@gmail.com
Co-developed-by: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   69 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 4 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-apply-filters-in-migrate_hot-cold
+++ a/mm/damon/vaddr.c
@@ -611,9 +611,60 @@ static unsigned int damon_va_check_acces
 	return max_nr_accesses;
 }
 
+static bool damos_va_filter_young_match(struct damos_filter *filter,
+		struct folio *folio, struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pmd_t *pmdp)
+{
+	bool young = false;
+
+	if (ptep)
+		young = pte_young(ptep_get(ptep));
+	else if (pmdp)
+		young = pmd_young(pmdp_get(pmdp));
+
+	young = young || !folio_test_idle(folio) ||
+		mmu_notifier_test_young(vma->vm_mm, addr);
+
+	if (young && ptep)
+		damon_ptep_mkold(ptep, vma, addr);
+	else if (young && pmdp)
+		damon_pmdp_mkold(pmdp, vma, addr);
+
+	return young == filter->matching;
+}
+
+static bool damos_va_filter_out(struct damos *scheme, struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr,
+		pte_t *ptep, pmd_t *pmdp)
+{
+	struct damos_filter *filter;
+	bool matched;
+
+	if (scheme->core_filters_allowed)
+		return false;
+
+	damos_for_each_ops_filter(filter, scheme) {
+		/*
+		 * damos_folio_filter_match checks the young filter by doing an
+		 * rmap on the folio to find its page table. However, being the
+		 * vaddr scheme, we have direct access to the page tables, so
+		 * use that instead.
+		 */
+		if (filter->type == DAMOS_FILTER_TYPE_YOUNG)
+			matched = damos_va_filter_young_match(filter, folio,
+				vma, addr, ptep, pmdp);
+		else
+			matched = damos_folio_filter_match(filter, folio);
+
+		if (matched)
+			return !filter->allow;
+	}
+	return scheme->ops_filters_default_reject;
+}
+
 struct damos_va_migrate_private {
 	struct list_head *migration_lists;
-	struct damos_migrate_dests *dests;
+	struct damos *scheme;
 };
 
 /*
@@ -673,7 +724,8 @@ static int damos_va_migrate_pmd_entry(pm
 {
 	struct damos_va_migrate_private *priv = walk->private;
 	struct list_head *migration_lists = priv->migration_lists;
-	struct damos_migrate_dests *dests = priv->dests;
+	struct damos *s = priv->scheme;
+	struct damos_migrate_dests *dests = &s->migrate_dests;
 	struct folio *folio;
 	spinlock_t *ptl;
 	pmd_t pmde;
@@ -691,9 +743,13 @@ static int damos_va_migrate_pmd_entry(pm
 	if (!folio)
 		goto unlock;
 
+	if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
+		goto put_folio;
+
 	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 		migration_lists);
 
+put_folio:
 	folio_put(folio);
 unlock:
 	spin_unlock(ptl);
@@ -708,7 +764,8 @@ static int damos_va_migrate_pte_entry(pt
 {
 	struct damos_va_migrate_private *priv = walk->private;
 	struct list_head *migration_lists = priv->migration_lists;
-	struct damos_migrate_dests *dests = priv->dests;
+	struct damos *s = priv->scheme;
+	struct damos_migrate_dests *dests = &s->migrate_dests;
 	struct folio *folio;
 	pte_t ptent;
 
@@ -720,9 +777,13 @@ static int damos_va_migrate_pte_entry(pt
 	if (!folio)
 		return 0;
 
+	if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
+		goto put_folio;
+
 	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 		migration_lists);
 
+put_folio:
 	folio_put(folio);
 	return 0;
 }
@@ -790,7 +851,7 @@ static unsigned long damos_va_migrate(st
 
 	use_target_nid = dests->nr_dests == 0;
 	nr_dests = use_target_nid ? 1 : dests->nr_dests;
-	priv.dests = dests;
+	priv.scheme = s;
 	priv.migration_lists = kmalloc_array(nr_dests,
 		sizeof(*priv.migration_lists), GFP_KERNEL);
 	if (!priv.migration_lists)
_

Patches currently in -mm which might be from bijantabatab@micron.com are

mm-damon-core-commit-damos-target_nid.patch
mm-damon-core-commit-damos-migrate_dests.patch
mm-damon-move-migration-helpers-from-paddr-to-ops-common.patch
mm-damon-vaddr-add-vaddr-versions-of-migrate_hotcold.patch
docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold.patch
mm-damon-vaddr-use-damos-migrate_dests-in-migrate_hotcold.patch
mm-damon-move-folio-filtering-from-paddr-to-ops-common.patch
mm-damon-vaddr-apply-filters-in-migrate_hot-cold.patch

