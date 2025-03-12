Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0E61EBA0C
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 21:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741813996; cv=none; b=IzLW3NZjZJciMFx5A/WWG2MX4ur9mlijrVZ0UuAwH3q5u18AZi1kgeznjFXrsAT/WNtp6/Na7lGX+wm+Uq6cC6LcLw6Rb9i0Wwro6rHFzQ9YQiO9mAnfqx4/yiW1Er4tGulSB2M0kkhH4XBYjqpgnUMuM0chLA1T346uNOD9R1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741813996; c=relaxed/simple;
	bh=5DEkzIyaBBLPk2kklaK8wV4f9prpKMiZ1OPzwDdGEYo=;
	h=Date:To:From:Subject:Message-Id; b=XqGZLOIKUxhBpdaX1iepLq2rlh2+YNmsTYUMk16VcxbFQUdAJTBk8kD18GUZQoMrDRvPtuKjEiKwijbVhrc+SIvHksh2dIjGSVJW+cENkdgDAyEY/EKdoXUBWDoiOQ5uX7VNmtI2P1bMOpPgkFh5bLcNhN9ER1+kdywgoJmmo5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vv/Z8F7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vv/Z8F7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18461C4CEE3;
	Wed, 12 Mar 2025 21:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741813994;
	bh=5DEkzIyaBBLPk2kklaK8wV4f9prpKMiZ1OPzwDdGEYo=;
	h=Date:To:From:Subject:From;
	b=Vv/Z8F7AYZ0hQajvZblaxuzn0jAiY3u1EanfWqrXwfWjsFZNzoXbPO/JBKAKNTlJC
	 e22hK/adTXkmBqRMXoZOLQxPIZYiwHe2RBPETjY2RE+34qIqI6hyAVJoQ/PS5eOA3t
	 Fn3L+Rh9BT7mnqYZbbcA0r6j+s8bjWLJXoNfD69I=
Date: Wed, 12 Mar 2025 14:13:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch added to mm-unstable branch
Message-Id: <20250312211314.18461C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: deduplicate madvise_do_behavior() skip case handlings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch

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
Subject: mm/madvise: deduplicate madvise_do_behavior() skip case handlings
Date: Wed, 12 Mar 2025 09:47:49 -0700

The logic for checking if a given madvise() request for a single memory
range can skip real work, namely madvise_do_behavior(), is duplicated in
do_madvise() and vector_madvise().  Split out the logic to a function and
reuse it.

Link: https://lkml.kernel.org/r/20250312164750.59215-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   57 +++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

--- a/mm/madvise.c~mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings
+++ a/mm/madvise.c
@@ -1640,6 +1640,31 @@ static bool is_valid_madvise(unsigned lo
 	return true;
 }
 
+/*
+ * madvise_should_skip() - Return if the request is invalid or nothing.
+ * @start:	Start address of madvise-requested address range.
+ * @len_in:	Length of madvise-requested address range.
+ * @behavior:	Requested madvise behavor.
+ * @err:	Pointer to store an error code from the check.
+ *
+ * If the specified behaviour is invalid or nothing would occur, we skip the
+ * operation.  This function returns true in the cases, otherwise false.  In
+ * the former case we store an error on @err.
+ */
+static bool madvise_should_skip(unsigned long start, size_t len_in,
+		int behavior, int *err)
+{
+	if (!is_valid_madvise(start, len_in, behavior)) {
+		*err = -EINVAL;
+		return true;
+	}
+	if (start + PAGE_ALIGN(len_in) == start) {
+		*err = 0;
+		return true;
+	}
+	return false;
+}
+
 static bool is_madvise_populate(int behavior)
 {
 	switch (behavior) {
@@ -1747,23 +1772,15 @@ static int madvise_do_behavior(struct mm
  */
 int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior)
 {
-	unsigned long end;
 	int error;
-	size_t len;
-
-	if (!is_valid_madvise(start, len_in, behavior))
-		return -EINVAL;
-
-	len = PAGE_ALIGN(len_in);
-	end = start + len;
-
-	if (end == start)
-		return 0;
 
+	if (madvise_should_skip(start, len_in, behavior, &error))
+		return error;
 	error = madvise_lock(mm, behavior);
 	if (error)
 		return error;
-	error = madvise_do_behavior(mm, start, len_in, len, behavior);
+	error = madvise_do_behavior(mm, start, len_in, PAGE_ALIGN(len_in),
+			behavior);
 	madvise_unlock(mm, behavior);
 
 	return error;
@@ -1790,19 +1807,13 @@ static ssize_t vector_madvise(struct mm_
 	while (iov_iter_count(iter)) {
 		unsigned long start = (unsigned long)iter_iov_addr(iter);
 		size_t len_in = iter_iov_len(iter);
-		size_t len;
+		int error;
 
-		if (!is_valid_madvise(start, len_in, behavior)) {
-			ret = -EINVAL;
-			break;
-		}
-
-		len = PAGE_ALIGN(len_in);
-		if (start + len == start)
-			ret = 0;
+		if (madvise_should_skip(start, len_in, behavior, &error))
+			ret = error;
 		else
-			ret = madvise_do_behavior(mm, start, len_in, len,
-					behavior);
+			ret = madvise_do_behavior(mm, start, len_in,
+					PAGE_ALIGN(len_in), behavior);
 		/*
 		 * An madvise operation is attempting to restart the syscall,
 		 * but we cannot proceed as it would not be correct to repeat
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

