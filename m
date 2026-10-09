Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EABB3F106D
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525483; cv=none; b=M0r7iEgEzpo21JbYy8Fj4bvVGLHFXAY32ePzIYisAsV9kFyHKdIPCpkOCsh7HHT59v+WX8Nci4CNgTebsMaTJHbzQ4ZWsnLXf8Odr2CjdsaUSOpkGAFR7LDyccWUb4phuhzE51Txp0pkhQ4CedmrAdVaxOavF3YcWoHfL3R5/As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525483; c=relaxed/simple;
	bh=32AA4Cbop5anWRModbjAcTxXs3vfWu626I+TzR0fqeo=;
	h=Date:To:From:Subject:Message-Id; b=c0+09INlI5DL15ROTfs+Eu6QWJ0NfLCWcq8qQrit8sECYG6BEUNcm2X1LAdtJEMKtZgyMQSGjjjHkDVdx9vQySgRUuwyiDOl9DyUJgxn1joORwEiGBaxljvJJf9KtXCrukP5JPTi7/irMEmRDgt+hJ0AbsfrRH/BVcDJ4CVFF60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cIGOO3dh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cIGOO3dh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9041F00893;
	Fri,  9 Oct 2026 05:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525480;
	bh=k2QcSOrl27D4Q3EclQ7t+2qPcu2LGileH934Ae8e8sI=;
	h=Date:To:From:Subject;
	b=cIGOO3dhWn33lpjWz/wASzH1V4efHtH9AND3q5nsyphFTUFL43wv3rh/8xWPwFWpc
	 70zvvfx4e9WntdzFi11llAfYKYcbnGdE+1Th534R+3kkLMItrQKcM1Q9dVRr6Mf1j5
	 2eLA0zaB+E3ZmIdk8nKVTmv7knqWhJWFLrPHEfn4=
Date: Thu, 08 Oct 2026 22:57:59 -0700
To: mm-commits@vger.kernel.org,gutierrez.asier@huawei-partners.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-support-apply_probe.patch removed from -mm tree
Message-Id: <20261009055800.6C9041F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: support apply_probe
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-support-apply_probe.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/vaddr: support apply_probe
Date: Wed, 9 Sep 2026 07:04:05 -0700

DAMON virtual address space operation set (vaddr) is not supporting
apply_probe.  Add a minimum support.  Do not support hugetlb pages and
PGIDLE_UNSET filter type for simplicity.

Link: https://lore.kernel.org/20260909140408.104699-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
---

 mm/damon/vaddr.c |  123 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-support-apply_probe
+++ a/mm/damon/vaddr.c
@@ -522,6 +522,128 @@ static void damon_va_prep_probes(struct
 	}
 }
 
+static bool damon_va_filter_pass(struct folio *folio, struct damon_probe *p)
+{
+	struct damon_filter *f;
+	bool pass = true;
+
+	damon_for_each_filter(f, p) {
+		if (damon_ops_filter_match(f, folio)) {
+			pass = f->allow;
+			break;
+		}
+		pass = !f->allow;
+	}
+	return pass;
+}
+
+struct damon_va_probe_walk_private {
+	struct damon_ctx *ctx;
+	struct damon_region *r;
+};
+
+static void damon_va_probe_folio(struct damon_ctx *ctx,
+		struct damon_region *r, struct folio *folio)
+{
+	struct damon_probe *probe;
+	int i = 0;
+
+	damon_for_each_probe(probe, ctx) {
+		if (damon_va_filter_pass(folio, probe))
+			r->probe_hits[i]++;
+		i++;
+	}
+}
+
+static int damon_va_probe_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk)
+{
+	pte_t *pte;
+	pte_t ptent;
+	spinlock_t *ptl;
+	struct folio *folio;
+	struct damon_va_probe_walk_private *priv = walk->private;
+
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
+		damon_va_probe_folio(priv->ctx, priv->r, folio);
+
+huge_out:
+		spin_unlock(ptl);
+		return 0;
+	}
+#endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
+
+	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte)
+		return 0;
+	ptent = ptep_get(pte);
+	if (!pte_present(ptent))
+		goto out;
+	folio = vm_normal_folio(walk->vma, addr, ptent);
+	if (!folio)
+		goto out;
+	damon_va_probe_folio(priv->ctx, priv->r, folio);
+
+out:
+	pte_unmap_unlock(pte, ptl);
+	return 0;
+}
+
+static void __damon_va_apply_probes(struct damon_ctx *ctx,
+		struct mm_struct *mm,  struct damon_region *r)
+{
+	struct damon_va_probe_walk_private arg = {
+		.ctx = ctx,
+		.r = r,
+	};
+	struct mm_walk_ops damon_probe_walk_ops = {
+		.pmd_entry = damon_va_probe_pmd_entry,
+		.hugetlb_entry = NULL,
+	};
+	unsigned long addr = r->sampling_addr;
+
+	if (!mm)
+		return;
+
+	damon_va_walk_page_range(mm, addr, addr + 1, &damon_probe_walk_ops,
+			&arg);
+}
+
+static unsigned int damon_va_apply_probes(struct damon_ctx *ctx,
+		bool set_samples, bool return_max_wsum)
+{
+	struct damon_target *t;
+	struct mm_struct *mm;
+	struct damon_region *r;
+	unsigned int max_wsum = 0;
+
+	damon_for_each_target(t, ctx) {
+		mm = damon_get_mm(t);
+		damon_for_each_region(r, t) {
+			if (set_samples)
+				r->sampling_addr = damon_rand(ctx, r->ar.start,
+						r->ar.end);
+			__damon_va_apply_probes(ctx, mm, r);
+			if (return_max_wsum)
+				max_wsum = max(damon_probe_hits_wsum(r, false,
+							ctx), max_wsum);
+		}
+		if (mm)
+			mmput(mm);
+	}
+
+	return max_wsum;
+}
+
 static bool damos_va_filter_young_match(struct damos_filter *filter,
 		struct folio *folio, struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, pmd_t *pmdp)
@@ -951,6 +1073,7 @@ static int __init damon_va_initcall(void
 		.prepare_access_checks = damon_va_prepare_access_checks,
 		.check_accesses = damon_va_check_accesses,
 		.prep_probes = damon_va_prep_probes,
+		.apply_probes = damon_va_apply_probes,
 		.target_valid = damon_va_target_valid,
 		.cleanup_target = damon_va_cleanup_target,
 		.apply_scheme = damon_va_apply_scheme,
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

