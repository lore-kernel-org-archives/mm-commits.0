Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661EA1EBA0C
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 21:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741813992; cv=none; b=KaC4mQB291ug/jJ+EVW8hFGd+yTCSfnVkHxad+hYGlT80ZbS5wO5fqCQanMkHO42O1d752AnJcDEEW0cSX8eu+j3BAZrwCk+pDHYHsJqVEj7IlzkJh/TqdTSLfpWTb0ptuuLpaLazs60TfG/yt0AhnbmBuIRJyLWKAY0dzOF+Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741813992; c=relaxed/simple;
	bh=o8UOBWNDPEjGBm422AeoAPOKtdyxGG53XdoWs1KcNwc=;
	h=Date:To:From:Subject:Message-Id; b=QOLdhWp2SVn1jXelS7ngTyiWiuqg7byfDLFE0xjv+mxlGnZs2m2KeFT8M5IjqAABOW7ZmIlAqLiPH4w9i1MZWL4y2n/RbWJBvi7dgfnSLOwNEYOjEjwB2AmXQE7pfOU6kKC+RrbxX/aCsGryx2MTHmNyN/SfhMVgclB7cWrR7po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qrh9pDmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qrh9pDmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E62C4CEDD;
	Wed, 12 Mar 2025 21:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741813991;
	bh=o8UOBWNDPEjGBm422AeoAPOKtdyxGG53XdoWs1KcNwc=;
	h=Date:To:From:Subject:From;
	b=Qrh9pDmHG0nEHmxIx94yOX7v21SRGC/xmo66khZmtJmySaCl1Wml+DH6JO2HfukqJ
	 TexO4t0x8kfLr/13+7qXPqqQnHjkqWKqq/VtMDpy5/+ccgnoBv20POWzT84HG3iZ5t
	 ZW3m4voxBWAM45HA+RPukuq+jIK/gXfuYyRRFgsU=
Date: Wed, 12 Mar 2025 14:13:11 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch added to mm-unstable branch
Message-Id: <20250312211311.B6E62C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: use is_memory_failure() from madvise_do_behavior()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: use is_memory_failure() from madvise_do_behavior()
Date: Wed, 12 Mar 2025 09:47:47 -0700

Patch series "mm/madvise: cleanup requests validations and classifications".

Cleanup madvise entry level code for cleaner request validations and
classifications.


This patch (of 4):

To reduce redundant open-coded checks of CONFIG_MEMORY_FAILURE and
MADV_{HWPOISON,SOFT_OFFLINE} in madvise_[un]lock(), is_memory_failure() is
introduced.  madvise_do_behavior() is still doing the same open-coded
check, though.  Use is_memory_failure() instead.

To avoid build failure on !CONFIG_MEMORY_FAILURE case, implement an empty
madvise_inject_error() under the config.  Also move the definition of
is_memory_failure() inside #ifdef CONFIG_MEMORY_FAILURE clause for
madvise_inject_error() definition, to reduce duplicated ifdef clauses.

Link: https://lkml.kernel.org/r/20250312164750.59215-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250312164750.59215-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   49 +++++++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-is_memory_failure-from-madvise_do_behavior
+++ a/mm/madvise.c
@@ -1392,7 +1392,32 @@ static int madvise_inject_error(int beha
 
 	return 0;
 }
-#endif
+
+static bool is_memory_failure(int behavior)
+{
+	switch (behavior) {
+	case MADV_HWPOISON:
+	case MADV_SOFT_OFFLINE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+#else
+
+static int madvise_inject_error(int behavior,
+		unsigned long start, unsigned long end)
+{
+	return 0;
+}
+
+static bool is_memory_failure(int behavior)
+{
+	return false;
+}
+
+#endif	/* CONFIG_MEMORY_FAILURE */
 
 static bool
 madvise_behavior_valid(int behavior)
@@ -1569,24 +1594,6 @@ int madvise_set_anon_name(struct mm_stru
 }
 #endif /* CONFIG_ANON_VMA_NAME */
 
-#ifdef CONFIG_MEMORY_FAILURE
-static bool is_memory_failure(int behavior)
-{
-	switch (behavior) {
-	case MADV_HWPOISON:
-	case MADV_SOFT_OFFLINE:
-		return true;
-	default:
-		return false;
-	}
-}
-#else
-static bool is_memory_failure(int behavior)
-{
-	return false;
-}
-#endif
-
 static int madvise_lock(struct mm_struct *mm, int behavior)
 {
 	if (is_memory_failure(behavior))
@@ -1640,10 +1647,8 @@ static int madvise_do_behavior(struct mm
 	unsigned long end;
 	int error;
 
-#ifdef CONFIG_MEMORY_FAILURE
-	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
+	if (is_memory_failure(behavior))
 		return madvise_inject_error(behavior, start, start + len_in);
-#endif
 	start = untagged_addr_remote(mm, start);
 	end = start + len;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch
mm-damon-core-initialize-damos-walk_completed-in-damon_new_scheme.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch
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
docs-mm-damon-design-document-for-intervals-auto-tuning-fix.patch
docs-abi-damon-document-intervals-auto-tuning-abi.patch
docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch
mm-damon-core-introduce-damos-ops_filters.patch
mm-damon-paddr-support-ops_filters.patch
mm-damon-core-support-committing-ops_filters.patch
mm-damon-core-put-ops-handled-filters-to-damos-ops_filters.patch
mm-damon-paddr-support-only-damos-ops_filters.patch
mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos.patch
mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch
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

