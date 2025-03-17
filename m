Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0772165ED
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188354; cv=none; b=qykMtkW+keJDucG3DmOTWU49IDxQbKi5LWlFN5vzhzUSUREfmRh+T2KNaoM9/mtnSO+qlIVbyNDLJDsZwe2UJ+OqexVDifbWG1sEZxOZ2VGOUfnqC93zCFfsNMqmoucHwm6fxpiTN9KwglQ80Z63Jokq4QSQoMvaWwVSp5gtyDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188354; c=relaxed/simple;
	bh=ZoRPysuAGrUacEB6BH8I77rBpdSMxPnk5mZ6KK4dsNI=;
	h=Date:To:From:Subject:Message-Id; b=L2eYVPcMqHYMBgM63bM3BCJBrgzu2pOqyDWmc2YIvtQLWraRxo6RUKHpRN/H18bf42VpQ+fI19WVRlfs+NRY7x8LcU+UYzZDyf+RgFzcMrqwUh8fVLYk1CErSl8gVqXDkoI5HDfgjq5kc2i6ouQQsIX0WYSGZ5M0TdyLvmoJPOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eIecj2gZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eIecj2gZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AFAC4CEEC;
	Mon, 17 Mar 2025 05:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188354;
	bh=ZoRPysuAGrUacEB6BH8I77rBpdSMxPnk5mZ6KK4dsNI=;
	h=Date:To:From:Subject:From;
	b=eIecj2gZHCuaSSZ6qQAYljHEQAX6FSI7JQnmlC0X58COqUK8yIg/n4XvYliQmyV0n
	 uOYRLoA3yOV5ZlTBq+NqCx2WEY0PHF2e2h5SjLJGW5XSETnq0KLNhGjbV67h8azGP+
	 rqLoFgUazgIs4cWq8qGK+LFzwUi2sEG9tEtKVas8=
Date: Sun, 16 Mar 2025 22:12:33 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch removed from -mm tree
Message-Id: <20250317051234.41AFAC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: clarify handling layer based filters evaluation sequence
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: clarify handling layer based filters evaluation sequence
Date: Tue, 18 Feb 2025 14:37:07 -0800

If an element of memory matches a DAMOS filter, filters that installed
after that get no chance to make any effect to the element.  Hence in what
order DAMOS filters are handled is important, if both allow filters and
reject filters are used together.

The ordering is affected by both the installation order and which layter
the filters are handled.  The design document is not clearly documenting
the latter part.  Clarify it on the design doc.

Link: https://lkml.kernel.org/r/20250218223708.53437-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence
+++ a/Documentation/mm/damon/design.rst
@@ -569,11 +569,21 @@ number of filters for each scheme.  Each
 - whether it is to allow (include) or reject (exclude) applying
   the scheme's action to the memory (``allow``).
 
-When multiple filters are installed, each filter is evaluated in the installed
-order.  If a part of memory is matched to one of the filter, next filters are
-ignored.  If the memory passes through the filters evaluation stage because it
-is not matched to any of the filters, applying the scheme's action to it is
-allowed, same to the behavior when no filter exists.
+For efficient handling of filters, some types of filters are handled by the
+core layer, while others are handled by operations set.  In the latter case,
+hence, support of the filter types depends on the DAMON operations set.  In
+case of the core layer-handled filters, the memory regions that excluded by the
+filter are not counted as the scheme has tried to the region.  In contrast, if
+a memory regions is filtered by an operations set layer-handled filter, it is
+counted as the scheme has tried.  This difference affects the statistics.
+
+When multiple filters are installed, the group of filters that handled by the
+core layer are evaluated first.  After that, the group of filters that handled
+by the operations layer are evaluated.  Filters in each of the groups are
+evaluated in the installed order.  If a part of memory is matched to one of the
+filter, next filters are ignored.  If the memory passes through the filters
+evaluation stage because it is not matched to any of the filters, applying the
+scheme's action to it is allowed, same to the behavior when no filter exists.
 
 For example, let's assume 1) a filter for allowing anonymous pages and 2)
 another filter for rejecting young pages are installed in the order.  If a page
@@ -590,14 +600,6 @@ filter-allowed or filters evaluation sta
 allow-filters at the end of the list makes no practical change but only
 filters-checking overhead.
 
-For efficient handling of filters, some types of filters are handled by the
-core layer, while others are handled by operations set.  In the latter case,
-hence, support of the filter types depends on the DAMON operations set.  In
-case of the core layer-handled filters, the memory regions that excluded by the
-filter are not counted as the scheme has tried to the region.  In contrast, if
-a memory regions is filtered by an operations set layer-handled filter, it is
-counted as the scheme has tried.  This difference affects the statistics.
-
 Below ``type`` of filters are currently supported.
 
 - anon
_

Patches currently in -mm which might be from sj@kernel.org are

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

