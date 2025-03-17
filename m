Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AD9207E0A
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188545; cv=none; b=Zl/Bk1NKmThTIj7H79qBoAHagp0sWT0m5VLpy75WPUikC7K16kQ2NaGip8byg8e5abxxrHuIdsHbf0v6tJSdwOAIj17WxVtAvrXN+quJJ5zCEcwHdJeruk8pr2RWcWRQq6ZnLZKnlaCa4waheTYrK7PHlpO+x0Z6XEc2wdpvQU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188545; c=relaxed/simple;
	bh=ld/qAgV9+dAqNpv6BJ2itRqATaYJMilBEZUGRQGwt4I=;
	h=Date:To:From:Subject:Message-Id; b=gL3P7Yx24r8sWcxTW6HcLrH/dEKKmPeTobaW8v9HiBpKFgMq9Gk1ECMNqjXCvfv6TBkToG/E6kXhjkZX+292SPdi8eHb/shl2ZXNj8Thcny9HGRyewDeMtG8Ox7cXPPX8gVULRD1hBM8DLOXQvKVrspNd8rimTMYPBakh/sys1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FJe0gS2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FJe0gS2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D37C4CEEC;
	Mon, 17 Mar 2025 05:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188545;
	bh=ld/qAgV9+dAqNpv6BJ2itRqATaYJMilBEZUGRQGwt4I=;
	h=Date:To:From:Subject:From;
	b=FJe0gS2EUOYOoLeKt2qJLU3ckLaPFEmgaMVajJDYOaXHSzBYhoRxqTYfsMT8pNq25
	 g+pzLIN8mGiKj5vFFubpD3TmTPao0gOvtlKJja1Xn+34/5b0Sc+lM9djCUpjJzaofA
	 agSYv7E3VfZiHxxXR5x07PKZm3fhEUwftcd1k+u8=
Date: Sun, 16 Mar 2025 22:15:44 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-respect-ops_filters_default_reject.patch removed from -mm tree
Message-Id: <20250317051545.84D37C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: respect ops_filters_default_reject
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-respect-ops_filters_default_reject.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: respect ops_filters_default_reject
Date: Tue, 4 Mar 2025 13:19:12 -0800

Use damos->ops_filters_default_reject, which is set based on the installed
filters' behaviors, from physical address space DAMON operations set.

Link: https://lkml.kernel.org/r/20250304211913.53574-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-respect-ops_filters_default_reject
+++ a/mm/damon/paddr.c
@@ -260,7 +260,7 @@ static bool damos_pa_filter_out(struct d
 		if (damos_pa_filter_match(filter, folio))
 			return !filter->allow;
 	}
-	return false;
+	return scheme->ops_filters_default_reject;
 }
 
 static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
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

