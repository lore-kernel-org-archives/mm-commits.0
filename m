Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7521EBA0C
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 21:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741813993; cv=none; b=NSMO+T9jDZFdgYAPGUnrloLCOL7jnhxyYQi2SwaXh8GHQo+jaYXObrsal9oj77aXIOSx0K7pUP2LJunHOam4NWOWCHCYaD7ppfd7n/c8rQ7zbqt8fsr1E+rBopAdC1dDWLslaCuD5TGZYr4PwT7AU6YyRET/PQ3ZM8hnauk4ctM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741813993; c=relaxed/simple;
	bh=XYlyvwOAMFTCZ1fhHbDTdAlD7VARtepwYedNIYr3gsc=;
	h=Date:To:From:Subject:Message-Id; b=G7Ab64GQ/8/JS0wpWha2xkv1hjNLDI7ykeyD9bWkcaVTgrcCbhw0b1Hc1hpxCqa2N1B49275hiA/xanxJtfiuANKmQ9upPbCM6AUa4qFpMjwv5oRt4/gr+CCSS3WtoqvMe/n2fs0y1qjgd9OGOdx6Bzsd6Xy5r9Wkrx6HnY4/OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o0RUKh8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o0RUKh8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D7EC4CEE3;
	Wed, 12 Mar 2025 21:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741813993;
	bh=XYlyvwOAMFTCZ1fhHbDTdAlD7VARtepwYedNIYr3gsc=;
	h=Date:To:From:Subject:From;
	b=o0RUKh8db7yP4EKUtflmLfm/cg4TYYoZ3C0lck0RAuIwtMmm5GmmOULzDkPCilYhm
	 KLrht1eozfzPTjr376b0Y7o6/lY6+w5Grl7kxbZRABrkOESB0St11q+ZPyXwgw/5zq
	 OF6sZGMTEfWEfExBer5HLqAj4FH+sgNQCNuaUA7U=
Date: Wed, 12 Mar 2025 14:13:12 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-split-out-populate-behavior-check-logic.patch added to mm-unstable branch
Message-Id: <20250312211312.E6D7EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: split out populate behavior check logic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-split-out-populate-behavior-check-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-split-out-populate-behavior-check-logic.patch

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
Subject: mm/madvise: split out populate behavior check logic
Date: Wed, 12 Mar 2025 09:47:48 -0700

madvise_do_behavior() has a long open-coded 'behavior' check for
MADV_POPULATE_{READ,WRITE}.  It adds multiple layers[1] and make the code
arguably take longer time to read.  Like is_memory_failure(), split out
the check to a separate function.  This is not technically removing the
additional layer but discourage further extending the switch-case.  Also
it makes madvise_do_behavior() code shorter and therefore easier to read.

[1] https://lore.kernel.org/bd6d0bf1-c79e-46bd-a810-9791efb9ad73@lucifer.local

Link: https://lkml.kernel.org/r/20250312164750.59215-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/madvise.c~mm-madvise-split-out-populate-behavior-check-logic
+++ a/mm/madvise.c
@@ -1640,6 +1640,17 @@ static bool is_valid_madvise(unsigned lo
 	return true;
 }
 
+static bool is_madvise_populate(int behavior)
+{
+	switch (behavior) {
+	case MADV_POPULATE_READ:
+	case MADV_POPULATE_WRITE:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int madvise_do_behavior(struct mm_struct *mm,
 		unsigned long start, size_t len_in, size_t len, int behavior)
 {
@@ -1653,16 +1664,11 @@ static int madvise_do_behavior(struct mm
 	end = start + len;
 
 	blk_start_plug(&plug);
-	switch (behavior) {
-	case MADV_POPULATE_READ:
-	case MADV_POPULATE_WRITE:
+	if (is_madvise_populate(behavior))
 		error = madvise_populate(mm, start, end, behavior);
-		break;
-	default:
+	else
 		error = madvise_walk_vmas(mm, start, end, behavior,
 					  madvise_vma_behavior);
-		break;
-	}
 	blk_finish_plug(&plug);
 	return error;
 }
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

