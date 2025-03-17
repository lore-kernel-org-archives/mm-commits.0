Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4720F216393
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188352; cv=none; b=alnz7qqdg/B0FqPkre3sWQ5+poJE3wDYnSUu7N5NIhnFfLHDEUPTLXNc1is2UWsCWrXODThCJbX8caAQ7yZxOGBSHyWe5JwkdMXRtQYi6TJ70WtjsIPSANW9yDFdtzZg7WWJB7cHSYDM/gJ8Tza68nlSD3JXGy6Zi74AxoEIxGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188352; c=relaxed/simple;
	bh=C4EVnFRq7jgeC/Eld6L/djQUUqzp0kKRT9IT56+TsVo=;
	h=Date:To:From:Subject:Message-Id; b=ckGW7/30334K6YuT0+k7siFreberk3qTsuUCq7WHBTRB6FIp3KzB4TgEOHbWFwlEJnTHJ/LJDzJwclMfwFZlccnp40qzNAAbQVo0njaXvpW526i2E5i3GvO5Q4QZPd7l4lvXWXjNuzCzH9M66AhlHa7xTj8jVIJKnwcC3sYJrZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z0I+nKKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z0I+nKKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181FBC4CEEC;
	Mon, 17 Mar 2025 05:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188352;
	bh=C4EVnFRq7jgeC/Eld6L/djQUUqzp0kKRT9IT56+TsVo=;
	h=Date:To:From:Subject:From;
	b=z0I+nKKU8K85wa32Y4yD98P5LeIiAKeoG5HhJPLfOaGHMoIJzruVehKn4BAeLlR4G
	 LJXytt0rE6MxFv2F8sRF75hhMunI3Qr2fvIhKJ9H5rDngc+Nzv1sv4rcXQxoiKBYz+
	 TsmyM9sSm8fEnncCk9exOntpZw+6BvlIup91OmM4=
Date: Sun, 16 Mar 2025 22:12:31 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-hugepage_size-filter.patch removed from -mm tree
Message-Id: <20250317051232.181FBC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document hugepage_size filter
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-hugepage_size-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document hugepage_size filter
Date: Tue, 18 Feb 2025 14:37:05 -0800

'hugepage_size' DAMOS filter type is not documented on the design doc.
Add a description of the type.

Link: https://lkml.kernel.org/r/20250218223708.53437-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-hugepage_size-filter
+++ a/Documentation/mm/damon/design.rst
@@ -610,6 +610,9 @@ Below ``type`` of filters are currently
     - Applied to pages that are accessed after the last access check from the
       scheme.
     - Handled by operations set layer.  Supported by only ``paddr`` set.
+- pages that managed in a given size range
+    - Applied to pages that managed in a given size range.
+    - Handled by operations set layer.  Supported by only ``paddr`` set.
 - address range
     - Applied to pages that belonging to a given address range.
     - Handled by the core logic.
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

