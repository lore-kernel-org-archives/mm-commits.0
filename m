Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB62D218ACC
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188540; cv=none; b=K5cORBAfeSZU2K9kTc1lk6Ta95eYrYQV6OoKmqR6DjhUPEqLn5YfaxlhRXgdit2hwvuap30ovBZF2sKSUE6eVTXnNifevDqIuVA6gyWldwTzsNkNoPBp7R0SV1TFKi9Wd4W7DxK7k2319pPcSQntmJoblmMHz+qTxQT9S0foF6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188540; c=relaxed/simple;
	bh=9+uYNXrFu9+aMhvo+7tz7uCnvPIfRw83x909+/PXn5g=;
	h=Date:To:From:Subject:Message-Id; b=OaQtL3cJnmGYAuF2PlD+sGK/Ia49L2n6mqogHa/Qx/kp0aDTcErNq6jn2nyYAvc12LGIaar87YqlFhdNPe9BAY4Yzgq0S4Y1dedVR/mjbLlmo8ZWJbb5bHWfhwF1rU8cxZC0DkV2LRf1u192Zbhr06mrmKQ8Rm5cs8HaDBSCvnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PQPAerLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PQPAerLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A261AC4CEEC;
	Mon, 17 Mar 2025 05:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188540;
	bh=9+uYNXrFu9+aMhvo+7tz7uCnvPIfRw83x909+/PXn5g=;
	h=Date:To:From:Subject:From;
	b=PQPAerLcZyYiIgw9C4VpkaMN8UBedkRTxrmDcnwr+yyVCcTR3rgZjnRD4w7L0EkRI
	 QCATA8BlqH/9+DlqedojJ9sUdV92thDdpgcsZLxaAy+73lodxeP03oV4nTPeon4en/
	 LIDjd+fZEnPijN3dZexisIGx+I+iXh4Cc7INO7PQ=
Date: Sun, 16 Mar 2025 22:15:40 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-support-only-damos-ops_filters.patch removed from -mm tree
Message-Id: <20250317051540.A261AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: support only damos->ops_filters
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-support-only-damos-ops_filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: support only damos->ops_filters
Date: Tue, 4 Mar 2025 13:19:09 -0800

DAMON physical address space operation set implementation (paddr) started
handling both damos->filters and damos->ops_filters to avoid breakage
during the change for the ->ops_filters setup.  Now the change is done, so
paddr's support of ->filters is only a waste that can safely be dropped. 
Remove it.

Link: https://lkml.kernel.org/r/20250304211913.53574-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-only-damos-ops_filters
+++ a/mm/damon/paddr.c
@@ -256,10 +256,6 @@ static bool damos_pa_filter_out(struct d
 	if (scheme->core_filters_allowed)
 		return false;
 
-	damos_for_each_filter(filter, scheme) {
-		if (damos_pa_filter_match(filter, folio))
-			return !filter->allow;
-	}
 	damos_for_each_ops_filter(filter, scheme) {
 		if (damos_pa_filter_match(filter, folio))
 			return !filter->allow;
@@ -288,12 +284,6 @@ static unsigned long damon_pa_pageout(st
 	struct folio *folio;
 
 	/* check access in page level again by default */
-	damos_for_each_filter(filter, s) {
-		if (filter->type == DAMOS_FILTER_TYPE_YOUNG) {
-			install_young_filter = false;
-			break;
-		}
-	}
 	damos_for_each_ops_filter(filter, s) {
 		if (filter->type == DAMOS_FILTER_TYPE_YOUNG) {
 			install_young_filter = false;
@@ -546,8 +536,6 @@ static bool damon_pa_scheme_has_filter(s
 {
 	struct damos_filter *f;
 
-	damos_for_each_filter(f, s)
-		return true;
 	damos_for_each_ops_filter(f, s)
 		return true;
 	return false;
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

