Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345A0207E14
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742186358; cv=none; b=Aq6214DxqL9CJVifVJd4lxgFTDLcMrR2nQ6ca6zaQ+buW6wPuiFy6uAQixoclvCq9/Dm4d2xhrNm7PsA+vExdbQ38ypIJeYPu//0uCJdcjB0BM74/kvmTDcNtyhl536c7xd6CyCG6/IEm3WAJtsG/c230KOrVVxU0vS1lIWw3E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742186358; c=relaxed/simple;
	bh=KlSi4Fx8/4BRBC3XvTNfEE8DJDAutytKGQyiKn4pKrQ=;
	h=Date:To:From:Subject:Message-Id; b=JgzV0Vfmq73JyPzTjz8aFHphWJvmFNbGoEtJ8aPgNWEyJvlksl1RWcB++X+HSjZm05Z/2k/VLvYH2FewGuceoHu3F0XnCyD7tUE5Dppgxb6zaJbyJ2Jqet3PRVRBDr1XFgVNL3F1HmaHf5P1lAXRNX2Vml6LKFnubK9KMT1nRuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WHFwlESP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WHFwlESP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0A8C4CEEC;
	Mon, 17 Mar 2025 04:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742186357;
	bh=KlSi4Fx8/4BRBC3XvTNfEE8DJDAutytKGQyiKn4pKrQ=;
	h=Date:To:From:Subject:From;
	b=WHFwlESPZdyBxQZ0OKKLAePaSIcx82WBvCMS7uazTW1FTYUI4bm3o8alr/BwiaoSD
	 m37ly4r5XLGvTCRoEXIV8L+4EK0SovmlOpPFxWmmDE0QDtmMhLMqdsUM8bmP5x/mU6
	 1RADKOOYbh4ym0eYUdmLVGLoLKAeF7fCnxQZgYKM=
Date: Sun, 16 Mar 2025 21:39:17 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-mm-damon-design-document-for-intervals-auto-tuning-fix.patch removed from -mm tree
Message-Id: <20250317043917.8A0A8C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: fix a typo on 'intervals auto-tuning' section
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-for-intervals-auto-tuning-fix.patch

This patch was dropped because it was folded into docs-mm-damon-design-document-for-intervals-auto-tuning.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: fix a typo on 'intervals auto-tuning' section
Date: Wed, 5 Mar 2025 10:27:44 -0800

Commit ("Docs/mm/damon/design: document for intervals auto-tuning") made a
typo on a cross reference link in monitoring intervals auto-tuning
section.  It causes document build warning.  Fix it.

Link: https://lkml.kernel.org/r/20250305182744.56125-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/20250305203312.6f30e9c2@canb.auug.org.au
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-for-intervals-auto-tuning-fix
+++ a/Documentation/mm/damon/design.rst
@@ -340,7 +340,7 @@ DAMON-observed access events to the theo
 (``aggrs``).
 
 The DAMON-observed access events are calculated in byte granularity based on
-DAMON :ref:`region assumption <damon_design_region_based_sample>`.  For
+DAMON :ref:`region assumption <damon_design_region_based_sampling>`.  For
 example, if a region of size ``X`` bytes of ``Y`` ``nr_accesses`` is found, it
 means ``X * Y`` access events are observed by DAMON.  Theoretical maximum
 access events for the region is calculated in same way, but replacing ``Y``
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch
mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch
docs-mm-damon-design-document-unmapped-damos-filter-type.patch
mm-damon-add-data-structure-for-monitoring-intervals-auto-tuning.patch
mm-damon-core-implement-intervals-auto-tuning.patch
mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch
mm-damon-sysfs-commit-intervals-tuning-goal.patch
mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch
docs-mm-damon-design-document-for-intervals-auto-tuning.patch
docs-abi-damon-document-intervals-auto-tuning-abi.patch
docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch
mm-damon-core-introduce-damos-ops_filters.patch
mm-damon-paddr-support-ops_filters.patch
mm-damon-core-support-committing-ops_filters.patch
mm-damon-core-put-ops-handled-filters-to-damos-ops_filters.patch
mm-damon-paddr-support-only-damos-ops_filters.patch
mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos.patch
mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch
mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters-fix.patch
mm-damon-paddr-respect-ops_filters_default_reject.patch
docs-mm-damon-design-update-for-changed-filter-default-behavior.patch
mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

