Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450D4217673
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188407; cv=none; b=U/iJkcZrgVYXZ3uVgJkrrxLaqXjjuxTnnSQ2srxS4ekjkS/ZG6wSaPaIn/rLXxSvHxRPCZ8CRpCeA4ZF5YgipVf6vNC11Zjs/ei1be2UVPJxAxMyeTd309UTMsyZBDxMVIYQ0w0YpV6mDrm97E04XC0YzEzd5Jb7iqZ6sA+S+/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188407; c=relaxed/simple;
	bh=dSbwugz1RABRYxIbNA+bRYR4QPIPNgPRqOKQ5nXXcWA=;
	h=Date:To:From:Subject:Message-Id; b=pz5/chycyI9gScLZey07lDZFW26ZKsUIH7CyYzlGMlN4xLEwL5jYyT3a7bwNJ+2b3IPq9m3tD7uUXsSL4cG7Ukk+h/wOr6h2QNfTv8q1nOYt4MQLUKuKpyWXoJjAkesOymFeThry4bohNAzRP7NIRRN/fvNHZTNevLEAyq6hixo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c0vVamvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c0vVamvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9E5C4CEEC;
	Mon, 17 Mar 2025 05:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188407;
	bh=dSbwugz1RABRYxIbNA+bRYR4QPIPNgPRqOKQ5nXXcWA=;
	h=Date:To:From:Subject:From;
	b=c0vVamvwdlReaXf5/WTrUAYEjhSIxcv6Li8Mi35wjlFRtAQkrcSGZZF21H/ZevBGj
	 XX0CUARw/vuNUlG71/uiRUsWDa74t0iKRYOYdC51sjYJ0qDC7f3fZ3XWFRI45RuybS
	 HNFUTZ6p8pz+52HH9wt0VS7Q63uTcGA5kKD6Xguw=
Date: Sun, 16 Mar 2025 22:13:26 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-unmapped-damos-filter-type.patch removed from -mm tree
Message-Id: <20250317051327.1A9E5C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document unmapped DAMOS filter type
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-unmapped-damos-filter-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document unmapped DAMOS filter type
Date: Wed, 19 Feb 2025 14:01:46 -0800

Document availability and meaning of unmapped DAMOS filter type on design
document.  Since introduction of the type requires no additional user ABI,
usage and ABI document need no update.

Link: https://lkml.kernel.org/r/20250219220146.133650-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-unmapped-damos-filter-type
+++ a/Documentation/mm/damon/design.rst
@@ -617,6 +617,8 @@ Below ``type`` of filters are currently
           scheme.
     - hugepage_size
         - Applied to pages that managed in a given size range.
+    - unmapped
+        - Applied to pages that unmapped.
 
 To know how user-space can set the filters via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`filters <sysfs_filters>` part of the
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

