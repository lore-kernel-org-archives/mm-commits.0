Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0EC3264FB;
	Wed,  7 Oct 2026 00:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334331; cv=none; b=bMCor4KKWIRstW94/wvql8UaeSv7cbpauU86Gwi1p47zKnbcym0gmlovClIkGRJm/0pBQDXWGDnOTPqbyWjFtofh9fWdiH626pMUQCvWl/E+h5gV1mEDV8fkRSidPA0JA2Kwl9foh/kKajR681zXZyZRKuMzC6dnqxHahkJIo5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334331; c=relaxed/simple;
	bh=JNI/mq4Za0gRWLCxcdgydyf5HujAzwgg/8UIYfj4VDw=;
	h=Date:To:From:Subject:Message-Id; b=fxdzvartsjDHyG34gALp6SLuRuJrgtlYDNW6yYMTxwqDBI6gJiLoHilo60LaboY7Y5tKBFTzaDLe5EYtogdo1JyhbJUQ60bTKId5Sd7QXjLR+aX3jrQbiKHZhG8BMkD80twhUAMspGlG3vGFNttTWPoa25j2vNANlAtAIVCLpvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lCufbrmV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lCufbrmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8D81F0089B;
	Wed,  7 Oct 2026 00:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334329;
	bh=/CNMHHKyqpSLA3/+8ATlEyQdchDtlfkHr2o1GudQ3Hw=;
	h=Date:To:From:Subject;
	b=lCufbrmVm6CcmL77sgESfjoYu7gkuG7r+tUv7RN6demRFncd6xaqn6yr9hO/xcqg6
	 XBNdbM3nKxw/I926w6mNfR9yHzN/vmxUnKIECt5m3NEsGiI24osLonfyT0YpjqrLSK
	 HfY8+RClDRoAbhQVi39xALOt7EFwtxPnZrgKQ+Mk=
Date: Tue, 06 Oct 2026 17:52:09 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch removed from -mm tree
Message-Id: <20261007005209.6E8D81F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: respect folio end for DAMOS actions except STAT
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/paddr: respect folio end for DAMOS actions except STAT
Date: Tue, 1 Sep 2026 06:18:44 -0700

A few functions for applying DAMOS actions including pageout, lru_[de]prio
and migrate_{hot,cold} in DAMON physical address space operation set
(paddr) collect folios of the given region by getting the folios of
region-internal addresses.  Then, those functions apply the action to the
collected folios at once.  The collection starts from the region start
address and advances the address by the size of the folio of the address
until it goes out of the region.  If the start address is in the middle of
a large folio, and if the next folios are small, some of the next folios
could be skipped.  Fix the issue by advancing the address to exactly the
start address of the next folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-4-sj@kernel.org
Link: https://lore.kernel.org/20260517234112.89245-1-sj@kernel.org [1]
Fixes: 3a06696305e7 ("mm/damon/ops: have damon_get_folio return folio even for tail pages")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.15.x
---

 mm/damon/paddr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat
+++ a/mm/damon/paddr.c
@@ -264,7 +264,7 @@ static unsigned long damon_pa_pageout(st
 		else
 			list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	if (install_young_filter)
@@ -302,7 +302,7 @@ static inline unsigned long damon_pa_de_
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	s->last_applied = folio;
@@ -350,7 +350,7 @@ static unsigned long damon_pa_migrate(st
 				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	applied = damon_migrate_pages(&folio_list, s->target_nid);
_

Patches currently in -mm which might be from sj@kernel.org are

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
mm-damon-api-introduce-damon_filter_type_pgidle_set.patch
mm-damon-paddr-support-damon_filter_type_pgidle_set.patch
mm-damon-vaddr-support-damon_filter_type_pgidle_set.patch
mm-damon-sysfs-support-damon_filter_type_pgidle_set.patch
docs-mm-damon-design-update-for-pgidle_set-probe-filter.patch
mm-damon-api-introduce-damos_filter_type_probe_hits_wsum.patch
mm-damon-api-introduce-damos_filter_type_probe_hits_wsum-fix.patch
mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation.patch
mm-damon-core-support-probe_hits_wsum-damos-core-filter.patch
mm-damon-sysfs-schemes-rename-sysfs_filter-sz_range-to-range_minmax.patch
mm-damon-sysfs-schemes-support-probe_hits_wsum-damos-core-filter.patch
docs-mm-damon-design-update-for-probe_hits_wsum-damos-core-filter.patch
docs-admin-guide-mm-damon-usage-update-for-probe_hits_wsum-damos-filter.patch
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

