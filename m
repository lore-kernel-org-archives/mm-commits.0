Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D403D5464C
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 00:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998864; cv=none; b=cK4GZRIdCzaYBmrjmUKVsqa2QiMogj/10wYaiUF2L7r8Nb9GgQpC95VcEsYnM3K/K+6XdyObOXeNvIicFx/ZtTEsQRmDMr3qpQb0somk6jXRYWZwLQHRYUrmDtrEjM0XuwKO8cyziHavvbrAM0Q9SkuBOTQijRpjwJvV83kbZcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998864; c=relaxed/simple;
	bh=oX8fOaEK2WBxxR4dxnz31ayG8Vgd2vhtfjVtx3h315I=;
	h=Date:To:From:Subject:Message-Id; b=o2+FJF9GzMFv5tzUiVMnC14c66uI2orZwiYXNpYSTfCVbDWcRDIamRIz+PsXB8On0SONC69TkR1AgInXq3rOAwOUZRGpzSUAYkwDxoPmzibMxz+fUmtxdzAIHZmPJGXFxmtm2W1cVXkzpVyxwydVno5DstTCZg66aIG8lDAc2N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2B23Ht/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2B23Ht/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB271F000FF;
	Thu, 10 Sep 2026 00:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788998862;
	bh=mSDdVqFvLnd56a6DLTwqu23wnZcQqjycGnIgGc0rnQs=;
	h=Date:To:From:Subject;
	b=2B23Ht/dSD00dZqWjT8F67F8hffIZQWZNrtJ9AKkBCL08dGcYLmMVf6A5Vp96SJKA
	 PAahwcwyYIrPofyAEdy2oT/K81ZDJZjTI3OcSXNKdL9rj3pcPkss5Y8vrduekLvk1/
	 MjACy8ezEcZ8t1eeS2Qk/LxqAsMF/MSau1Lq+cOw=
Date: Wed, 09 Sep 2026 17:07:41 -0700
To: mm-commits@vger.kernel.org,gutierrez.asier@huawei-partners.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-support-apply_probe.patch added to mm-new branch
Message-Id: <20260910000742.4DB271F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: support apply_probe
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-vaddr-support-apply_probe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-support-apply_probe.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/vaddr: support apply_probe
Date: Wed, 9 Sep 2026 07:04:05 -0700

DAMON virtual address space operation set (vaddr) is not supporting
apply_probe.  Add a minimum support.  Do not support hugetlb pages and
PGIDLE_UNSET filter type for simplicity.

Link: https://lore.kernel.org/20260909140408.104699-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-damon-vaddr-avoid-hw-driven-pte-updates-during-damon_hugetlb_mkold.patch
mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch
mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch
mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-sysfs-support-pgidle_unset-probe-filter-type.patch
docs-mm-damon-design-document-pgidle_unset-probe-filter-type.patch
mm-damon-core-introduce-damon_prep-struct.patch
mm-damon-core-commit-preps.patch
mm-damon-core-introduce-damon_operations-prep_probes.patch
mm-damon-paddr-support-damon_prep.patch
mm-damon-sysfs-implement-preps-directory.patch
mm-damon-sysfs-implement-preps-nr_preps-file.patch
mm-damon-sysfs-create-directories-for-nr_preps-writes.patch
mm-damon-sysfs-implement-prep_action-file.patch
mm-damon-sysfs-pass-preps-to-damon-core.patch
selftests-damon-sysfssh-test-probe-prep-sysfs-files.patch
docs-mm-damon-design-document-probe-preps.patch
docs-admin-guide-mm-damon-usage-document-probe-preps-sysfs-files.patch
docs-abi-damon-document-probe-prep-sysfs-files.patch
mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal.patch
mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total.patch
mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit.patch
mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch
mm-damon-tests-core-kunit-test-damon_commit_filter.patch
mm-damon-tests-core-kunit-add-damon_commit_probes-test.patch
selftests-damon-_damon_sysfs-implement-damonprobes.patch
selftests-damon-drgn_dump_damon_status-dump-probes.patch
selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch
selftests-damon-sysfspy-test-damon-probes.patch
mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold.patch
mm-damon-core-remove-debug-messages.patch
mm-damon-core-remove-debug-messages-fix.patch
mm-damon-vaddr-remove-a-debug-message.patch
mm-damon-core-validate-number-of-probes-in-valid_probe_params.patch
mm-damon-sysfs-remove-probes-number-validation.patch
mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case.patch
mm-damon-tests-core-kunit-test-=0-size-damon_set_regions-inputs.patch
mm-damon-tests-core-kunit-test-overlapping-ranges-for-set_regions.patch
mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch
selftests-damon-sysfssh-test-hugepage_mem_bp-quota-goal.patch
docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies.patch
docs-abi-damon-recommend-subsystem-doc-instead-of-admin-guide.patch
mm-damon-core-error-damos_commit_quota_goal-for-zero-target_value.patch
revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
revert-samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch
mm-damon-core-set-ctx-call_controls_obsolete-in-damon_new_ctx.patch
mm-damon-reclaim-remove-unnecessary-damon_call-param-validation.patch
mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch
mm-damon-vaddr-support-prep_probes.patch
mm-damon-paddr-move-probe-filter-handling-to-ops-common.patch
mm-damon-vaddr-support-apply_probe.patch
mm-damon-vaddr-extend-apply_probes-for-hugetlb.patch
mm-damon-vaddr-support-pgidle_unset-probe-filter-type.patch

