Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F2F12E7F
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215463; cv=none; b=hkY+wp6+W3/rkiMMlZqs36Hb4QVhT8RIsFAFdv7pTUdnjJxM2SspkaAZ38ZgwwZmCEn+uruwmUBPWdmkvCXDaCtMQQQJVAw41CApjazCJVPx2Vh5TVCwRQDaRXDuA9v9EsSK6mSTk2knWH79Jx5GjCkVz6HN8LjJ+c7B0G5GLkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215463; c=relaxed/simple;
	bh=abf1aPdpaKXDpwHVu4YDTMsaKAmkE+IZg0jQTxyfbL8=;
	h=Date:To:From:Subject:Message-Id; b=S13iu7VFGVLcnzPqP83//nfqP5GLlDQzx9qRqBAF4VZHu/fzDH7NlnbHr8Kh8lcQo1sOhV2CNZADFKlilp/D6Q/BgfaKhwnmJ5X4qCS7ZJ2QJufaeBeED9DwrkXb+3AJsiEoucepndtv1++dSxoMvWC+6+Id15YNQaKuHWRha8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lVqxAoiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lVqxAoiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E02C4CED2;
	Tue,  7 Jan 2025 02:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736215462;
	bh=abf1aPdpaKXDpwHVu4YDTMsaKAmkE+IZg0jQTxyfbL8=;
	h=Date:To:From:Subject:From;
	b=lVqxAoiqH5W3wyNPdX4ShhXxXe//OvXYlFuup6NCAU2+mBYVssSpIZGN5VJH8m9+j
	 3RnM05LhqU6bqtFFUbYrizl0dqHUGtbq+W4NU2Y7nrOiWLS8JyhR4af1sVPwDQmNAL
	 s1mA9+KUBwK3OV0YSFhkjWde9klM6sZkNFAljCFA=
Date: Mon, 06 Jan 2025 18:04:21 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-add-statistics-section.patch added to mm-unstable branch
Message-Id: <20250107020422.78E02C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: add 'statistics' section
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-add-statistics-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-add-statistics-section.patch

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
Subject: Docs/mm/damon/design: add 'statistics' section
Date: Mon, 6 Jan 2025 11:33:47 -0800

DAMOS stats are important feature for tuning of DAMOS-based access-aware
system operation, and efficient access pattern monitoring.  But not well
documented on the design document.  Add a section on the document.

Link: https://lkml.kernel.org/r/20250106193401.109161-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   38 ++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-statistics-section
+++ a/Documentation/mm/damon/design.rst
@@ -539,6 +539,44 @@ To know how user-space can set the water
 <sysfs_interface>`, refer to :ref:`filters <sysfs_filters>` part of the
 documentation.
 
+Statistics
+~~~~~~~~~~
+
+The statistics of DAMOS behaviors that designed to help monitoring, tuning and
+debugging of DAMOS.
+
+DAMOS accounts below statistics for each scheme, from the beginning of the
+scheme's execution.
+
+- ``nr_tried``: Total number of regions that the scheme is tried to be applied.
+- ``sz_trtied``: Total size of regions that the scheme is tried to be applied.
+- ``nr_applied``: Total number of regions that the scheme is applied.
+- ``sz_applied``: Total size of regions that the scheme is applied.
+- ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
+
+"A scheme is tried to be applied to a region" means DAMOS core logic determined
+the region is eligible to apply the scheme's :ref:`action
+<damon_design_damos_action>`.  The :ref:`access pattern
+<damon_design_damos_access_pattern>`, :ref:`quotas
+<damon_design_damos_quotas>`, :ref:`watermarks
+<damon_design_damos_watermarks>`, and :ref:`filters
+<damon_design_damos_filters>` that handled on core logic could affect this.
+The core logic will only ask the underlying :ref:`operation set
+<damon_operations_set>` to do apply the action to the region, so whether the
+action is really applied or not is unclear.  That's why it is called "tried".
+
+"A scheme is applied to a region" means the :ref:`operation set
+<damon_operations_set>` has applied the action to at least a part of the
+region.  The :ref:`filters <damon_design_damos_filters>` that handled by the
+operation set, and the types of the :ref:`action <damon_design_damos_action>`
+and the pages of the region can affect this.  For example, if a filter is set
+to exclude anonymous pages and the region has only anonymous pages, or if the
+action is ``pageout`` while all pages of the region are unreclaimable, applying
+the action to the region will fail.
+
+To know how user-space can read the stats via :ref:`DAMON sysfs interface
+<sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
+documentation.
 
 Regions Walking
 ~~~~~~~~~~~~~~~
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

