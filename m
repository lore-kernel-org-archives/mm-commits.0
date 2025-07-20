Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CAF1487C3
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976909; cv=none; b=cb8+Y6yrj4buU9lUNtR93dPObUcsowTAJNZrZW5PENKPQgWRwTYIWvw0ZQVGI8Fdk9hj9wo1cKfBQELs4VUM7DpMcO2QVjP6rd3x3WX5flLqO+UVf7vy60OkSl6sMHpEsrdUOCjSBqrR6uxr5GibNlyKgiKnoL2GlG9qQMhhwjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976909; c=relaxed/simple;
	bh=Xeaca4ZuKDE5t5k6x01RsEEuiDkksFAm0YIR5zghEEc=;
	h=Date:To:From:Subject:Message-Id; b=cTDCfK6iu1lXjBu2QwsFVXBrydcdnlc8gk8G6DUWRxQsMtSPe8TQ0RY9h8/nkr3eNnU8bibdDuICZ/KkEtvcc3H8YYn3cfKQ9iDQ/A2F0anmrzH7k/ARxaOVLLWeTuuQdjAmvfb9kW3tjvRoZVHYlN+k+dHpMghRz1iW9+NYiJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aUE7V0vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aUE7V0vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1ABC4CEE3;
	Sun, 20 Jul 2025 02:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976909;
	bh=Xeaca4ZuKDE5t5k6x01RsEEuiDkksFAm0YIR5zghEEc=;
	h=Date:To:From:Subject:From;
	b=aUE7V0vsYzz02R9KGRLa83gWipehr7vUogcF63VNnVYy1BDXXQwZzFD7I+SQ57O4D
	 DCPTkO0BrmQE5cBsALNqZ2qtvlCsgA2bysqU3V3pHfdEZi4n+oEo3wruHKpifs4iu9
	 TlAUE5VNDZN955XM8GFYegRKGfuXMSdP+dUR9xF4=
Date: Sat, 19 Jul 2025 19:01:48 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-apply-filters-in-migrate_hot-cold.patch removed from -mm tree
Message-Id: <20250720020149.5C1ABC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: apply filters in migrate_{hot/cold}
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-apply-filters-in-migrate_hot-cold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
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


