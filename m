Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9318B3C3F62
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 04:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791519944; cv=none; b=UDrinI5nOfv4oq/xRcMGyvCL9ydqd1GVs66ZrefHIKDp2RxMGCTXu6GZdOd/TDP9TaS0fbOqzWI38Anfg9i5YiOVJqYcPLpSVa+ozIvzmGbqN+3QFnk096WEE/aCGJaP81bbX++/TKVaFXw6jOQWNWZVe9WPR2kIpLhOeCqzquU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791519944; c=relaxed/simple;
	bh=NgLNH7XCh3a1YeiMA4RfPF6S2sv1M077ZWIwxhvU61g=;
	h=Date:To:From:Subject:Message-Id; b=BaqhEHk8wA/xoGZcXpv26Jpn6/mouTGe9fMyjAvjjQ/sgE7ucbTx9/JlVA7tKUsUZ4+uoLGZa8Ygxyp0ISszcnnET+Mk3oOpJCwgAFdHphOLoXoDCwE8i5mm+u016BBUZZOfhCng4xoaTFZ5PO2f+4vmWrQ6Nz6YsK5CmwissYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IsZ59u2K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IsZ59u2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A171F000FF;
	Fri,  9 Oct 2026 04:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791519938;
	bh=/9yyjeOwuf6kTrwDHzB5zXln1ErAQAbDtySq7TtUwG0=;
	h=Date:To:From:Subject;
	b=IsZ59u2KJcdi2yk5hxMIL0pzOpzjp6FaCs6t3AkKSMdUIIIT4uPApLxyI0PU/jX/9
	 GjUlIdX8Fg3qg7n2wqw/2hgkaT3KBonm7zuaQvmhmb50XL4SLSOuPmRfQ61IuqQeWK
	 qMcsAvpZSC0SddbW+whMTH3EiD+hUZv31waCSeaE=
Date: Thu, 08 Oct 2026 21:25:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-api-introduce-damos_filter_type_probe_hits_wsum-fix.patch removed from -mm tree
Message-Id: <20261009042537.E4A171F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/api: clarify DAMOS_FILTER_TYPE_PROBE_HITS_WSUM behavior
has been removed from the -mm tree.  Its filename was
     mm-damon-api-introduce-damos_filter_type_probe_hits_wsum-fix.patch

This patch was dropped because it was folded into mm-damon-api-introduce-damos_filter_type_probe_hits_wsum.patch

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/api: clarify DAMOS_FILTER_TYPE_PROBE_HITS_WSUM behavior
Date: Fri, 11 Sep 2026 07:20:01 -0700

clarify DAMOS_FILTER_TYPE_PROBE_HITS_WSUM behavior

Link: https://lore.kernel.org/20260911142522.98013-1-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/damon.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-api-introduce-damos_filter_type_probe_hits_wsum-fix
+++ a/include/linux/damon.h
@@ -405,9 +405,9 @@ struct damos_stat {
  * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
  * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
  * damon_operations as a part of scheme action trying, and therefore accounted
- * as 'tried'.  In contrast, &DAMOS_FILTER_TYPE_ADDR and
- * &DAMOS_FILTER_TYPE_TARGET filters are handled by the core layer before
- * trying of the action, and therefore not accounted as 'tried'.
+ * as 'tried'.  In contrast, &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET
+ * and &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM filters are handled by the core layer
+ * before trying of the action, and therefore not accounted as 'tried'.
  *
  * Support for the operations-handled filters depends on the running
  * &struct damon_operations.
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

