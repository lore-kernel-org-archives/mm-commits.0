Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772FC27703
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 00:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998863; cv=none; b=IFeADamI7J5C02w+MOJyvmKIcVm1J/gncRsSQ/TGh2eSxjC4gfFylYERGTOVk5RUVBAk4DFlzQPRGJhOmCtnPbG78+8XB7oGUlERYcKgHrwE2Z7DntHPsmVoM4h0I8zFCQLDwgYODgC1apU2i0H9u4yjmSfKkJpPuPQwWVtU+gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998863; c=relaxed/simple;
	bh=HRWsxu6hHjrZAtvax9uksQZymSw3SKx9bAK3QZ/3F/M=;
	h=Date:To:From:Subject:Message-Id; b=T9mAmLK9qtuEanvEWRNeyW0bXivqUtKVlgPomoAGlwdlKWXphGsJUkbmgxUKpf1By9gz5MN5OHwEDiaKtOsHR9whExbgjoHRkzmxeOATN7A5/PKUweIOwxoAAyo+jyU7W/quox/qNj8muB06JiPeUWVi/263cnUGcq8qfYWGEZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eODjQZC4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eODjQZC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867951F00898;
	Thu, 10 Sep 2026 00:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788998859;
	bh=qFOKZNNzMT8Cmj0qEoJPgsP8vtWFYkPcwbKVxm9ZqXM=;
	h=Date:To:From:Subject;
	b=eODjQZC4/zEDOXau++EHNo3dV3TpZykglg9qBX8Caso1kuXHS2vNMZrJNPyDLR+AG
	 iqTfttH2YanXWvEQR97+D4gRAuaK6Ix7lKS8OtIMPxnY6H0OpYffc5XRFmGjo5xqDD
	 dXTT9w6MCZJkrJVIwgMXkPBazm43nKXdKSyQjHwU=
Date: Wed, 09 Sep 2026 17:07:39 -0700
To: mm-commits@vger.kernel.org,gutierrez.asier@huawei-partners.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-move-probe-filter-handling-to-ops-common.patch added to mm-new branch
Message-Id: <20260910000739.867951F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: move probe filter handling to ops-common
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-move-probe-filter-handling-to-ops-common.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-move-probe-filter-handling-to-ops-common.patch

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
Subject: mm/damon/paddr: move probe filter handling to ops-common
Date: Wed, 9 Sep 2026 07:04:04 -0700

Probe filter matching logic for anon and memcg type filters in DAMON's
physical address space operation set (paddr) can be reused by virtual
address space operation set (vaddr) in future.  Prepare the future by
moving the code to ops-common.c

Link: https://lore.kernel.org/20260909140408.104699-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |   32 ++++++++++++++++++++++++++++++++
 mm/damon/ops-common.h |    2 ++
 mm/damon/paddr.c      |   23 +----------------------
 3 files changed, 35 insertions(+), 22 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-paddr-move-probe-filter-handling-to-ops-common
+++ a/mm/damon/ops-common.c
@@ -531,3 +531,35 @@ bool damos_ops_has_filter(struct damos *
 		return true;
 	return false;
 }
+
+bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
+{
+	bool matched = false;
+	struct mem_cgroup *memcg;
+
+	switch (filter->type) {
+	case DAMON_FILTER_TYPE_ANON:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		matched = folio_test_anon(folio);
+		break;
+	case DAMON_FILTER_TYPE_MEMCG:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		rcu_read_lock();
+		memcg = folio_memcg_check(folio);
+		if (!memcg)
+			matched = false;
+		else
+			matched = filter->memcg_id == mem_cgroup_id(memcg);
+		rcu_read_unlock();
+		break;
+	default:
+		break;
+	}
+	return matched == filter->matching;
+}
--- a/mm/damon/ops-common.h~mm-damon-paddr-move-probe-filter-handling-to-ops-common
+++ a/mm/damon/ops-common.h
@@ -31,3 +31,5 @@ bool damos_folio_filter_match(struct dam
 unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
 
 bool damos_ops_has_filter(struct damos *s);
+
+bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio);
--- a/mm/damon/paddr.c~mm-damon-paddr-move-probe-filter-handling-to-ops-common
+++ a/mm/damon/paddr.c
@@ -143,29 +143,8 @@ static bool damon_pa_filter_match(struct
 		struct folio *folio)
 {
 	bool matched = false;
-	struct mem_cgroup *memcg;
 
 	switch (filter->type) {
-	case DAMON_FILTER_TYPE_ANON:
-		if (!folio) {
-			matched = false;
-			break;
-		}
-		matched = folio_test_anon(folio);
-		break;
-	case DAMON_FILTER_TYPE_MEMCG:
-		if (!folio) {
-			matched = false;
-			break;
-		}
-		rcu_read_lock();
-		memcg = folio_memcg_check(folio);
-		if (!memcg)
-			matched = false;
-		else
-			matched = filter->memcg_id == mem_cgroup_id(memcg);
-		rcu_read_unlock();
-		break;
 	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
 		if (!folio)
 			matched = false;
@@ -173,7 +152,7 @@ static bool damon_pa_filter_match(struct
 			matched = damon_folio_young(folio);
 		break;
 	default:
-		break;
+		return damon_ops_filter_match(filter, folio);
 	}
 	return matched == filter->matching;
 }
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

