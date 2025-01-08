Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CD219CC02
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308502; cv=none; b=bC8ie5Unh7iP9i2hoDEaBK5E10VLXzDKvp0KFV6nFclEAqTnHbG/IEPSNdBzq7MGNRwho/+Y+PbutCgt4BqKC80r+HynHmJur7G3VymRzv3w1WulpwaO0ZO+xbVl8SX9q5wy3kg0e98CdkIeoH0lTUrE7pLVVs1Oxf+T6Txw9qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308502; c=relaxed/simple;
	bh=SRU6r2/GpSsTes0vlKuvjS6ZWTT9D6OFtBlUZ5B9+k0=;
	h=Date:To:From:Subject:Message-Id; b=M8SmV42u/RPllOKHx/XU1GWrNlASfw0fspdmqvsUKLUPNzgHyPOo6U4xxwb1hBYwzUmfn5sntG5UalsMPUq2P/U5DV1KCn6bhHkUjmpmk6INM6A6ZaALbxo6RoHMZDrfttm3BPtw1XhapO3EGywbffHEYvdMA+y7zPJ1a1ewyrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YLSNRJ6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YLSNRJ6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB71C4CED0;
	Wed,  8 Jan 2025 03:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736308502;
	bh=SRU6r2/GpSsTes0vlKuvjS6ZWTT9D6OFtBlUZ5B9+k0=;
	h=Date:To:From:Subject:From;
	b=YLSNRJ6/AcPkvPdMq7ZBy+ML1HwGpPA7DvfllPF9lvYHWlrLcmp2APruYcNOAQYni
	 kfpii1cuv9UuHIeS7dVLQ4z3tg+csRNIN03WXNIaTCVDX0CTfy8zGKt9n6TB5Fe2Sw
	 8348AfXrfuke4b9U9zIzxIfrEdpWhUkyd8FwcVxY=
Date: Tue, 07 Jan 2025 19:55:01 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-pass-block-filters-behaviors.patch added to mm-unstable branch
Message-Id: <20250108035501.EBB71C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document pass/block filters behaviors
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-pass-block-filters-behaviors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-pass-block-filters-behaviors.patch

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
Subject: Docs/mm/damon/design: document pass/block filters behaviors
Date: Tue, 7 Jan 2025 12:17:36 -0800

Update DAMOS filters design document to describe the pass/block behavior
of filters.

Link: https://lkml.kernel.org/r/20250107201739.79484-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   34 ++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-pass-block-filters-behaviors
+++ a/Documentation/mm/damon/design.rst
@@ -504,9 +504,35 @@ have a list of latency-critical processe
 
 To let users optimize DAMOS schemes with such special knowledge, DAMOS provides
 a feature called DAMOS filters.  The feature allows users to set an arbitrary
-number of filters for each scheme.  Each filter specifies the type of target
-memory, and whether it should exclude the memory of the type (filter-out), or
-all except the memory of the type (filter-in).
+number of filters for each scheme.  Each filter specifies
+
+- a type of memory (``type``),
+- whether it is for the memory of the type or all except the type
+  (``matching``), and
+- whether it is to allow (pass through the filter) or reject (block) applying
+  the scheme's action to the memory (``pass``).
+
+When multiple filters are installed, each filter is evaluated in the installed
+order.  If a part of memory is matched to one of the filter, next filters are
+ignored.  If a part of memory is not matched to any of the filters, the default
+behavior is applied.  That is, as long as it fulfills other conditions of the
+scheme including the access pattern and quotas, the action will be applied to
+the part of the memory.
+
+For example, let's assume 1) a filter for passing anonymous pages and 2)
+another filter for blocking young pages are installed in the order.  If a page
+of a region that eligible to apply the scheme's action is an anonymous page,
+the scheme's action will be applied to the page regardless of whether it is
+young or not, since it matches with the first filter.  If the page is not
+anonymous but young, the scheme's action will not be applied, since the second
+filter blocks it.  If the page is neither anonymous nor young, no filter is
+involved, so the action will be applied to the page.
+
+The fact that the action can be applied to any memory as long as no block
+filter explicitly excluded it means that installing pass filters without any
+block filter after those is same to not installing the pass filters, in terms
+of the ``action`` applying.  Statistics for DAMOS filters will still be
+accounted, though.  It is therefore still useful for monitoring purpose.
 
 For efficient handling of filters, some types of filters are handled by the
 core layer, while others are handled by operations set.  In the latter case,
@@ -516,7 +542,7 @@ filter are not counted as the scheme has
 a memory regions is filtered by an operations set layer-handled filter, it is
 counted as the scheme has tried.  This difference affects the statistics.
 
-Below types of filters are currently supported.
+Below ``type`` of filters are currently supported.
 
 - anonymous page
     - Applied to pages that containing data that not stored in files.
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch
mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch
docs-mm-damon-design-add-statistics-section.patch
docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch
mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch
mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch
mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch
docs-mm-damon-design-document-sz_ops_filter_passed.patch
docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch
docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch
mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch
mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch
docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch
docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch
docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch
docs-translations-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-fixup-damos_filter-kernel-doc.patch
mm-damon-core-add-damos_filter-pass-field.patch
mm-damon-core-support-damos_filter-pass.patch
mm-damon-paddr-support-damos_filter-pass.patch
mm-damon-add-pass-argument-to-damos_new_filter.patch
mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-pass.patch
docs-mm-damon-design-document-pass-block-filters-behaviors.patch
docs-abi-damon-document-damos-filter-pass-sysfs-file.patch
docs-admin-guide-mm-damon-usage-omit-damos-filter-details-in-favor-of-design-doc.patch
docs-admin-guide-mm-damon-usage-document-damos-filter-pass-sysfs-file.patch

