Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA6D4071DE
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525484; cv=none; b=sFePZf2c4woSeENNpwpiWuJqK0qgfrLT/sy+5AOaPKMk5K7G1pTSbamuHVTbOQ1eLTQTe9bynff13dx7qHvb9feZOWGViBOifpEuMW3ExIMk/iuUEhvEYIGEU7rHhusQezJyBJfxKQfBys8vs/DJhArXWP9Sp4ZiBSdEvFq5ik0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525484; c=relaxed/simple;
	bh=IC1QDPA/iA+bWR9FG8Cul/hw/b26rsHBMpEhYQwycUA=;
	h=Date:To:From:Subject:Message-Id; b=oFZ6dvjgzJP6ydrQGaz9w8Pzr2fgefS7ozK+1v38r2oBfyCOOjPk55kz9RlgD7ebxn44QNL4qp4cI6tETJTRbw2LKfCFqQAIY9/9DVyEYSuAzCsLWkBDQHMu/7xwhJ3LvH2ImAWL322hFjPpIzKabXBJeCWSTBP2L9z/FekdTIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M4YXatrc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M4YXatrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5551F00898;
	Fri,  9 Oct 2026 05:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525482;
	bh=2y0zVmNceafhUCMY2CkajjigtxI/+4onHwVVglPha9E=;
	h=Date:To:From:Subject;
	b=M4YXatrcZr6j2JCCscPMMW+tN1AUAVer8QT5zkQ/bPT3B2FyWO/Npazm2FYSzx4m/
	 4kYsEK8iw+rXyvEsW0tMgNTKnV9FIp0DHEchXfjWMp8bi7ZFpLz54nZ5u/qmhzzNlw
	 5oflaJZ0BbInM1jK5s+dU55SPPKqnWSTdakwBQ0k=
Date: Thu, 08 Oct 2026 22:58:02 -0700
To: mm-commits@vger.kernel.org,gutierrez.asier@huawei-partners.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-support-pgidle_unset-probe-filter-type.patch removed from -mm tree
Message-Id: <20261009055802.CC5551F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: support pgidle_unset probe filter type
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-support-pgidle_unset-probe-filter-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/vaddr: support pgidle_unset probe filter type
Date: Wed, 9 Sep 2026 07:04:07 -0700

DAMON virtual address space operation set (vaddr) does not support
pgidle_unset probe filter type.  Add the support.

Link: https://lore.kernel.org/20260909140408.104699-6-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
---

 mm/damon/vaddr.c |   55 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 7 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-support-pgidle_unset-probe-filter-type
+++ a/mm/damon/vaddr.c
@@ -522,13 +522,49 @@ static void damon_va_prep_probes(struct
 	}
 }
 
-static bool damon_va_filter_pass(struct folio *folio, struct damon_probe *p)
+static bool damon_va_young_addr(struct folio *folio, pte_t *pte, pmd_t *pmd,
+		struct mm_struct *mm, unsigned long addr)
+{
+	bool young = false;
+
+	if (pte)
+		young = pte_young(*pte);
+	else if (pmd)
+		young = pmd_young(*pmd);
+	young = young || !folio_test_idle(folio) ||
+		mmu_notifier_test_young(mm, addr);
+	return young;
+}
+
+static bool damon_va_filter_match(struct damon_filter *filter,
+		struct folio *folio, pte_t *pte, pmd_t *pmd,
+		struct mm_struct *mm, unsigned long addr)
+{
+	bool matched = false;
+
+	switch (filter->type) {
+	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
+		if (!folio)
+			matched = false;
+		else
+			matched = damon_va_young_addr(folio, pte, pmd, mm,
+					addr);
+		break;
+	default:
+		return damon_ops_filter_match(filter, folio);
+	}
+	return matched == filter->matching;
+}
+
+static bool damon_va_filter_pass(struct folio *folio, struct damon_probe *p,
+		pte_t *pte, pmd_t *pmd, struct mm_struct *mm,
+		unsigned long addr)
 {
 	struct damon_filter *f;
 	bool pass = true;
 
 	damon_for_each_filter(f, p) {
-		if (damon_ops_filter_match(f, folio)) {
+		if (damon_va_filter_match(f, folio, pte, pmd, mm, addr)) {
 			pass = f->allow;
 			break;
 		}
@@ -543,13 +579,15 @@ struct damon_va_probe_walk_private {
 };
 
 static void damon_va_probe_folio(struct damon_ctx *ctx,
-		struct damon_region *r, struct folio *folio)
+		struct damon_region *r, struct folio *folio,
+		pte_t *pte, pmd_t *pmd, struct mm_struct *mm)
 {
 	struct damon_probe *probe;
 	int i = 0;
 
 	damon_for_each_probe(probe, ctx) {
-		if (damon_va_filter_pass(folio, probe))
+		if (damon_va_filter_pass(folio, probe, pte, pmd, mm,
+					r->sampling_addr))
 			r->probe_hits[i]++;
 		i++;
 	}
@@ -574,7 +612,8 @@ static int damon_va_probe_pmd_entry(pmd_
 		folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
 		if (!folio)
 			goto huge_out;
-		damon_va_probe_folio(priv->ctx, priv->r, folio);
+		damon_va_probe_folio(priv->ctx, priv->r, folio, NULL, &pmde,
+				walk->vma->vm_mm);
 
 huge_out:
 		spin_unlock(ptl);
@@ -591,7 +630,8 @@ huge_out:
 	folio = vm_normal_folio(walk->vma, addr, ptent);
 	if (!folio)
 		goto out;
-	damon_va_probe_folio(priv->ctx, priv->r, folio);
+	damon_va_probe_folio(priv->ctx, priv->r, folio, &ptent, NULL,
+			walk->vma->vm_mm);
 
 out:
 	pte_unmap_unlock(pte, ptl);
@@ -615,7 +655,8 @@ static int damon_va_probe_hugetlb_entry(
 
 	folio = pfn_folio(pte_pfn(entry));
 	folio_get(folio);
-	damon_va_probe_folio(priv->ctx, priv->r, folio);
+	damon_va_probe_folio(priv->ctx, priv->r, folio, &entry, NULL,
+			walk->vma->vm_mm);
 	folio_put(folio);
 
 out:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-read-sysfs_filter-addr_range-only-once.patch
mm-damon-sysfs-schemes-read-sysfs_filter-sz_range-only-once.patch
mm-damon-core-return-an-error-from-damos_commit_filter_arg.patch
mm-damon-core-disallow-max-min-damos-filter-range-arguments-commit.patch
mm-damon-sysfs-schemes-drop-centralized-filter-range-arg-validations.patch
mm-damon-sysfs-schemes-use-switch-case-in-add_scheme_filters.patch
mm-damon-core-kunit-extend-damos_commit_filter_for-for-wrong-input.patch
mm-damon-core-kunit-test-invalid-damos-filter-commits.patch
mm-damon-api-introduce-damon_filter_type_hugepage_size.patch
mm-damon-core-commit-hugepage_size-type-damon-filter.patch
mm-damon-ops-common-support-hugepage_size-damon-filter-matching.patch
mm-damon-sysfs-add-minmax-files-under-probe-filter-directory.patch
mm-damon-sysfs-support-hugepage_size-probe-filter.patch
docs-mm-damon-design-update-for-hugepage_size-probe-filter.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch
docs-abi-damon-update-for-hugepage_size-probe-filter.patch
mm-damon-api-remove-nr_damos_filter_types.patch
mm-damon-core-use-abs_diff-in-damon_feed_loop_next_input.patch
mm-damon-core-use-mult_frac-in-damon_feed_loop_next_input.patch
mm-damon-core-set-damon_ctx-walk_control_obsolete-in-damon_new_ctx.patch
mm-damon-core-document-damon_call-damon_start-race-hang-issue.patch
mm-damon-paddr-remove-pa-parameter-from-damon_pa_filter_pass.patch
mm-damon-tests-core-kunit-test-eligible_mem_bp-commitment.patch
mm-damon-tests-core-kunit-add-probe_hits_wsum-damos-filter-commit-test.patch
selftests-damon-sysfs_memcg_path_leak-fail-only-for-real-damon-leak.patch
docs-mm-damon-design-clarify-bp-is-basis-point.patch
mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

