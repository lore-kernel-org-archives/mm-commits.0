Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D969D2594AB
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215464; cv=none; b=uUjnlvkzlnz1b8pzMMmS9pA76421PSe347wOz/MXBMxWKiP7+t6NwN63nyJW5WwDPtbrQ8RDgFiZcXqoh078X/fkJktR4S96d9B+wvkPXdyVj4zayWOEKJ91WFpasij/KiKQY+3LSMSrmI9Xu1++LQafjr+KoZa8+B1+QukraI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215464; c=relaxed/simple;
	bh=+8f1p5yQqdaxDjNx0REOMPxL9zd6o6bAcuj1CIxIgBs=;
	h=Date:To:From:Subject:Message-Id; b=XANiawHNopYuQYMcvKv6W956pMPVn4o7fkazW6AllSipqXiwOdXl1/b1At+5jzWkesWsL5+BJXXq/r+fAKmNY8WIMQJmXUCvQovvwqU0QWajqsdhUmHhbzGQq0HY9MPtg5bqo+6zyv5PyzhZRzwn+NeXCWOkN4b+sN7ELrFZaA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qFojspDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qFojspDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7D6C4CED2;
	Tue,  7 Jan 2025 02:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736215464;
	bh=+8f1p5yQqdaxDjNx0REOMPxL9zd6o6bAcuj1CIxIgBs=;
	h=Date:To:From:Subject:From;
	b=qFojspDqjMOAD8qYhfu1JZG7eRLL3qqUGmJpnYiYp0ZUWjgKmB4AJuVRhhoHeH3yW
	 Xa4n+JTWWpYBSCjL885xlSErTnSbs/C9ap7YJs5i7LNxTPjaj1Td1sDyKsCa8XppDW
	 lsEnbFqzwbimTsnaRiQSdL5GztmxZsmQc3afA5S4=
Date: Mon, 06 Jan 2025 18:04:23 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch added to mm-unstable branch
Message-Id: <20250107020424.5E7D6C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: link damos stat design doc
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch

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
Subject: Docs/admin-guide/mm/damon/usage: link damos stat design doc
Date: Mon, 6 Jan 2025 11:33:48 -0800

DAMON sysfs usage document focuses on usage, rather than the detail of the
stat metric itself.  Add a link to the design document on DAMOS stat usage
section.

Link: https://lkml.kernel.org/r/20250106193401.109161-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    3 ++-
 Documentation/mm/damon/design.rst            |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -451,7 +451,8 @@ schemes/<N>/stats/
 DAMON counts the total number and bytes of regions that each scheme is tried to
 be applied, the two numbers for the regions that each scheme is successfully
 applied, and the total number of the quota limit exceeds.  This statistics can
-be used for online analysis or tuning of the schemes.
+be used for online analysis or tuning of the schemes.  Refer to :ref:`design
+doc <damon_design_damos_stat>` for more details about the stats.
 
 The statistics can be retrieved by reading the files under ``stats`` directory
 (``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``, and
--- a/Documentation/mm/damon/design.rst~docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc
+++ a/Documentation/mm/damon/design.rst
@@ -539,6 +539,8 @@ To know how user-space can set the water
 <sysfs_interface>`, refer to :ref:`filters <sysfs_filters>` part of the
 documentation.
 
+.. _damon_design_damos_stat:
+
 Statistics
 ~~~~~~~~~~
 
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

