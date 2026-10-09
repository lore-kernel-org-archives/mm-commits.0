Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C174F40F754
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525483; cv=none; b=AtBIaEs7Prdjgp2H2EdNf0Nt0bTSaYKkqrBON93iesn7BDGb4sR6RzmHrpzSLBrBcI+ZPJy0CBxQPCDPsD4xQuyNB5u0NKuiW3dxd/USzs2egVY5p8Aat0GfFF6MaJBA80eeFzE93+draGlOTnBT+vminCdD4MeVlYQa0NizCWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525483; c=relaxed/simple;
	bh=mJpGnq/VznsC4uET9NX8yvz62EOEQ0V7QlCrunYYiD0=;
	h=Date:To:From:Subject:Message-Id; b=nxwU2wMXI7Y7k4Cw+nOPdyFVHyohDhP84K8rHG2XnGoW9xSeacG4bnp9UPc3W21ZCPlwF70Z5C5jbJbdVbHhYbnIzejy5lwKomhuD9scS/qd0NLfekoZNrs8daNnUP4Y/By77daHA0cEwbcWXbIDn+jfZ6bb+k1KaNtxaaunQa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VEYzC3qP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VEYzC3qP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910C91F000FF;
	Fri,  9 Oct 2026 05:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525481;
	bh=w0Hoa7fFAnonBeGq1dD1FnVhztmwCkUL8AYQnCscIVs=;
	h=Date:To:From:Subject;
	b=VEYzC3qPVJ8FqYvX3CCz/7ww/LdE7prH0PdR+1RVB7BCSUTesHi716/D1LgsTMjvv
	 3rw1iyNqtI/8fqkcnHwqcV70FL2P8+mxuzh1CjdwasxpJie84B/LC7sd00pqthlslV
	 P0q2OQHZbjGnTFy/1oHnaG6o6VoLO84VwI3cFj4k=
Date: Thu, 08 Oct 2026 22:58:01 -0700
To: mm-commits@vger.kernel.org,gutierrez.asier@huawei-partners.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-extend-apply_probes-for-hugetlb.patch removed from -mm tree
Message-Id: <20261009055801.910C91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: extend apply_probes() for hugetlb
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-extend-apply_probes-for-hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/vaddr: extend apply_probes() for hugetlb
Date: Wed, 9 Sep 2026 07:04:06 -0700

DAMON virtual address space operation set(vaddr) does not support hugetlb
pages in apply_probes.  Extend it for hugetlb pages.

Link: https://lore.kernel.org/20260909140408.104699-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
---

 mm/damon/vaddr.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-extend-apply_probes-for-hugetlb
+++ a/mm/damon/vaddr.c
@@ -598,6 +598,34 @@ out:
 	return 0;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static int damon_va_probe_hugetlb_entry(pte_t *pte, unsigned long hmask,
+		unsigned long addr, unsigned long end, struct mm_walk *walk)
+{
+	struct damon_va_probe_walk_private *priv = walk->private;
+	struct hstate *h = hstate_vma(walk->vma);
+	struct folio *folio;
+	spinlock_t *ptl;
+	pte_t entry;
+
+	ptl = huge_pte_lock(h, walk->mm, pte);
+	entry = huge_ptep_get(walk->mm, addr, pte);
+	if (!pte_present(entry))
+		goto out;
+
+	folio = pfn_folio(pte_pfn(entry));
+	folio_get(folio);
+	damon_va_probe_folio(priv->ctx, priv->r, folio);
+	folio_put(folio);
+
+out:
+	spin_unlock(ptl);
+	return 0;
+}
+#else
+#define damon_va_probe_hugetlb_entry NULL
+#endif /* CONFIG_HUGETLB_PAGE */
+
 static void __damon_va_apply_probes(struct damon_ctx *ctx,
 		struct mm_struct *mm,  struct damon_region *r)
 {
@@ -607,7 +635,7 @@ static void __damon_va_apply_probes(stru
 	};
 	struct mm_walk_ops damon_probe_walk_ops = {
 		.pmd_entry = damon_va_probe_pmd_entry,
-		.hugetlb_entry = NULL,
+		.hugetlb_entry = damon_va_probe_hugetlb_entry,
 	};
 	unsigned long addr = r->sampling_addr;
 
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

