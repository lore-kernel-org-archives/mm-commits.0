Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3110D2163B2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188351; cv=none; b=OPqHJsd9djKU3mA3KxjAnyTDXw/ED4ucWQAenjOT0zS+cMuFLGlhbMDfDplys//APhDwz1Y4/af3XEmxKtGgyKZJ00Ix5erS7Dm7eqqDy2cKK9v/N+iiwcJgYNRM4aVR6ohmr9MmAVo34BKor1RBhselHQ97tHVyeeuVv8N9iac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188351; c=relaxed/simple;
	bh=IoN8WO8CE9TnGhpTIB0YstlN/r7sOmkPnszWXKvdpzs=;
	h=Date:To:From:Subject:Message-Id; b=oi1vdYGtJHipJUwA08Tk7mG1XEOvDawzdog3JUm8gydLjOP9uHUXU0+kxk1jh3yLjFpOnA+HPIlVz0kBvM5uGv5Tcl1ipTnnCvtNmriRlANVgpSzaAQcY0zYYOLjWGyfrAx/wwog6qAMwZKP8kcIVwrcHmIBFDULQo2s66GM0Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nocPOdA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nocPOdA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0767AC4CEEC;
	Mon, 17 Mar 2025 05:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188351;
	bh=IoN8WO8CE9TnGhpTIB0YstlN/r7sOmkPnszWXKvdpzs=;
	h=Date:To:From:Subject:From;
	b=nocPOdA7XpPv7r1oi7D2lK7hat1+CVYnbjebK74RAfoZOe2YAppQHJVmeZAJj8Ie3
	 3nfwx3WGpOAHGv62dEd/avhFatAMZioraLOldGiSl/QO9KRkiqwNy4beBiloLx3YzC
	 3owRSMuOGpl5YxW+KewZYI3uKC1iR2JVuXZ7fKNc=
Date: Sun, 16 Mar 2025 22:12:30 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch removed from -mm tree
Message-Id: <20250317051231.0767AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: fix typo on DAMOS filters usage doc link
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: fix typo on DAMOS filters usage doc link
Date: Tue, 18 Feb 2025 14:37:04 -0800

Patch series "Docs/mm/damon: misc DAMOS filters documentation fixes and
improves".

Fix and improve DAMOS filters documentation by fixing a copy-paste typo,
adding hugepage_size filter documentation on design doc, moving logic
details from usage to design, clarify DAMOS filters handling sequence
based on handling layer, and re-organizing the filters type list for
easier understanding of the handling sequence.


This patch (of 5):

The link from DAMOS filters design doc to usage doc has a typo calling
filters as watermarks.  Fix it.

Link: https://lkml.kernel.org/r/20250218223708.53437-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250218223708.53437-2-sj@kernel.org
Fixes: d31f5626a0e1 ("Docs/mm/damon/design: add links to sections of DAMON sysfs interface usage doc")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link
+++ a/Documentation/mm/damon/design.rst
@@ -617,7 +617,7 @@ Below ``type`` of filters are currently
     - Applied to pages that belonging to a given DAMON monitoring target.
     - Handled by the core logic.
 
-To know how user-space can set the watermarks via :ref:`DAMON sysfs interface
+To know how user-space can set the filters via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`filters <sysfs_filters>` part of the
 documentation.
 
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

