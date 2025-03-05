Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274322E3397
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741217524; cv=none; b=B90mb3s97kXMdDj0y5wKAYAMAQ4ppQuLDTOT9hW4Fw8C1XzXOD2poEHSyBE45LlcGsQo165m+EItAHR2BWh4NF+kwDB5uOtXYyAUpBW+uM63JAiq2nffPLNAlHk8LMeDHEItdGJYNgokILfXLv2AoT6IXYVx0msDltXaQelWMe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741217524; c=relaxed/simple;
	bh=sj1Le0Jrqm8HIoQXeNV1E+FIkpNkLu20USozhSj68Co=;
	h=Date:To:From:Subject:Message-Id; b=mT/ck5gqs2+zDne4F+KeCETspajkNlQegcOAN7BU0CnWdWxGx3r42Cn8xCR5Qf9g2pYXGCPVB8Hq9E155Fyu30If3fSeUjtd4YIhX2JU8PEofx9KuVncF+Amovf2u0Ozw42BVmLhkPDPnZ54mTDyg6r+a1ble1dWEvP7GKOVIf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=StuPuupY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="StuPuupY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D1DC4CEEE;
	Wed,  5 Mar 2025 23:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741217524;
	bh=sj1Le0Jrqm8HIoQXeNV1E+FIkpNkLu20USozhSj68Co=;
	h=Date:To:From:Subject:From;
	b=StuPuupYYywgolAUj4NwVxpKJP2lq989lzFSdAt7U+1iuRQZ7vzOy6pZOWzZXJfhW
	 sXJbdTynRigCoEp9d3QvNrZq3lH/EI5NPUCG1AhGzGF2MqMzrNQyoAOlG365M4IZe9
	 4CG/wBEN+K64olgmZInFdxFi6X/lIdqJtLGfvqfY=
Date: Wed, 05 Mar 2025 15:32:03 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch added to mm-unstable branch
Message-Id: <20250305233203.E8D1DC4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: return error when for attempts to install filters on wrong sysfs directory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch

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
Subject: mm/damon/sysfs-schemes: return error when for attempts to install filters on wrong sysfs directory
Date: Wed, 5 Mar 2025 14:27:31 -0800

Return error if the user tries to install a DAMOS filter on DAMOS filters
sysfs directory that assumed to be used for filters that handled by a
DAMON layer that not same to that for the installing filter.

Link: https://lkml.kernel.org/r/20250305222733.59089-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory
+++ a/mm/damon/sysfs-schemes.c
@@ -362,6 +362,23 @@ static ssize_t type_show(struct kobject
 			damon_sysfs_scheme_filter_type_strs[filter->type]);
 }
 
+static bool damos_sysfs_scheme_filter_valid_type(
+		enum damos_sysfs_filter_handle_layer layer,
+		enum damos_filter_type type)
+{
+	switch (layer) {
+	case DAMOS_SYSFS_FILTER_HANDLE_LAYER_BOTH:
+		return true;
+	case DAMOS_SYSFS_FILTER_HANDLE_LAYER_CORE:
+		return !damos_filter_for_ops(type);
+	case DAMOS_SYSFS_FILTER_HANDLE_LAYER_OPS:
+		return damos_filter_for_ops(type);
+	default:
+		break;
+	}
+	return false;
+}
+
 static ssize_t type_store(struct kobject *kobj,
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
@@ -373,6 +390,9 @@ static ssize_t type_store(struct kobject
 	for (type = 0; type < NR_DAMOS_FILTER_TYPES; type++) {
 		if (sysfs_streq(buf, damon_sysfs_scheme_filter_type_strs[
 					type])) {
+			if (!damos_sysfs_scheme_filter_valid_type(
+						filter->handle_layer, type))
+				break;
 			filter->type = type;
 			ret = count;
 			break;
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
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

