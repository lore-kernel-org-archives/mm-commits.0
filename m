Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7798145009
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215481; cv=none; b=Gq2sE3KJxphhhdlMThzqkbyvvY+HrBJrSrkAo6Zh05676W5PSy26AFPVJpev+MLLqQVTzdaLCbP8YJzmuj/NOfvLKqb4Kb6c/AlGzia1n2KmbK9AypeAZO3fsqn6slP20c8hXWN9p2KEryjzme+t9MFk+WRzvdhBChYL1Ay3H04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215481; c=relaxed/simple;
	bh=B/4Ew5knwfczP6v0GfClA2UoH26vCROOiWiO34Okv4o=;
	h=Date:To:From:Subject:Message-Id; b=fwwO0EsXOGO10g6d96aW3dO8Z/0qqb9DvJyCyv9a6TkR3fPzL+c3XU8d+Eendg8+qJ2F+5BFhb0uEpACZqxryo+lgbd1WvEDylVkmpCsg8JHAwlRejq381INSANUYXxvekffPGH7K0wNxbNa3tWfMdfccssosBr1QrULk+jvRPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=073BWTOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="073BWTOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8A8C4CED2;
	Tue,  7 Jan 2025 02:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736215481;
	bh=B/4Ew5knwfczP6v0GfClA2UoH26vCROOiWiO34Okv4o=;
	h=Date:To:From:Subject:From;
	b=073BWTOnL0tnw67vVPOL2qE+wQIx2AU0+yv1FRXKoLFHKLt9qZoS0zd7rqEhuQtZL
	 xmYrGhOVZ4OmxpPUR8Ixby2ywuJ2h/H5Uqe9n1HxkfusQh4NijthYg9mXLfDsxra8r
	 MsNwNCEbqtr1RJP+i2ObFYpZO3jCjs/tZ0Zb5YDw=
Date: Mon, 06 Jan 2025 18:04:40 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch added to mm-unstable branch
Message-Id: <20250107020441.4A8A8C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: document per-scheme filter-passed bytes stat file
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch

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
Subject: Docs/ABI/damon: document per-scheme filter-passed bytes stat file
Date: Mon, 6 Jan 2025 11:33:56 -0800

Document the new ABI for per-scheme operations set layer-handled DAMOS
filters passed bytes statistic on the ABI document.

Link: https://lkml.kernel.org/r/20250106193401.109161-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -384,6 +384,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Reading this file returns the total size of regions that the
 		action of the scheme has successfully applied in bytes.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/sz_ops_filter_passed
+Date:		Dec 2024
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the total size of memory that passed
+		DAMON operations layer-handled filters of the scheme in bytes.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/qt_exceeds
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
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

