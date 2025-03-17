Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D7A1DA61D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188546; cv=none; b=LFXVOsJDZy3S7bwv6TKY3RR0lYGjzpzH+YaX2nj4ndeXn1Y6q8SzSG+PF2E/iV/42Cw522zOE4Sh+dYhRYQb3Yomb9Bolk9wSiroHRsK+mi61ByGGz++Sq4mYlIQRyn8W+OO/wd45CNg+sLnzeS2My3Hq0O2xOCjcein8PPmgO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188546; c=relaxed/simple;
	bh=hpobKQM9rMiHYORvQdv0B6JK6g/uGB0csmXW6c3QuWQ=;
	h=Date:To:From:Subject:Message-Id; b=SGJ4J6DH6TmHwgFVcoj4Edlmc33JBw6NYdN5W39bn5rHo99/BzX812BOfiBHwJAeCOThQoRS+7LGSkdHYw+G9c2dmhe+mpqgwcaDIi/Teas93nIceQPwBh2+15BwuFgGVrWE839+kKRu/etKcE3SDFfS3vMdrrAIOanKJkKGsWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PrgiPtjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PrgiPtjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E9CC4CEEC;
	Mon, 17 Mar 2025 05:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188546;
	bh=hpobKQM9rMiHYORvQdv0B6JK6g/uGB0csmXW6c3QuWQ=;
	h=Date:To:From:Subject:From;
	b=PrgiPtjkWHfJFR5WgR5nuQxCC8cuDePnmPIW08X7su1FqJW088ulW2BFOHs8kfY8g
	 QP/AVZ90ADziQcCD3Z5lJzTFUnnHHARPJFY7R5IWrv/mDRY6Wa5sMIUjD4HaZTssZX
	 9cblZZj8pWgVx60qK8bUsAzqV2VEf5OGf4p3L31Y=
Date: Sun, 16 Mar 2025 22:15:46 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-update-for-changed-filter-default-behavior.patch removed from -mm tree
Message-Id: <20250317051546.94E9CC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: update for changed filter-default behavior
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-update-for-changed-filter-default-behavior.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: update for changed filter-default behavior
Date: Tue, 4 Mar 2025 13:19:13 -0800

Update the design documentation for changed DAMOS filters default
allowance behaviors.

Link: https://lkml.kernel.org/r/20250304211913.53574-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-changed-filter-default-behavior
+++ a/Documentation/mm/damon/design.rst
@@ -631,9 +631,10 @@ When multiple filters are installed, the
 core layer are evaluated first.  After that, the group of filters that handled
 by the operations layer are evaluated.  Filters in each of the groups are
 evaluated in the installed order.  If a part of memory is matched to one of the
-filter, next filters are ignored.  If the memory passes through the filters
+filter, next filters are ignored.  If the part passes through the filters
 evaluation stage because it is not matched to any of the filters, applying the
-scheme's action to it is allowed, same to the behavior when no filter exists.
+scheme's action to it depends on the last filter's allowance type.  If the last
+filter was for allowing, the part of memory will be rejected, and vice versa.
 
 For example, let's assume 1) a filter for allowing anonymous pages and 2)
 another filter for rejecting young pages are installed in the order.  If a page
@@ -645,11 +646,6 @@ second reject-filter blocks it.  If the
 the page will pass through the filters evaluation stage since there is no
 matching filter, and the action will be applied to the page.
 
-Note that the action can equally be applied to memory that either explicitly
-filter-allowed or filters evaluation stage passed.  It means that installing
-allow-filters at the end of the list makes no practical change but only
-filters-checking overhead.
-
 Below ``type`` of filters are currently supported.
 
 - Core layer handled
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

