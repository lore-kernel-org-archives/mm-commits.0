Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0897133EA
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215461; cv=none; b=hBdb3vjSZmhAebEpEuoLTbC73D/x8gCQzzxj5Y7fvI4hzlruUJrDCJH+xW/0SoldyOC2BX/Ey+ityRf6fOOeUZ3v1iHUTOhvbjtuck0ZlL9Wru5GKwatRnVE4a8QZzeTL+HfcL07SVT8SdtP19wsiHCT27coof4z23yc6rrw+20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215461; c=relaxed/simple;
	bh=F89XsTXAsd7WR5XMAKw3wd+NrWs3Lc8rrmgVTCbIDnE=;
	h=Date:To:From:Subject:Message-Id; b=j/huqZOwkACqFFHj221fDXkMTjF+ZmRXPD7B9bB+nNSMVyQrHRgK8+8eDP020iJ+XQh5jAHHcyg4qqO3t7qm4UtWjPhtUoClbi4oAXNFsCnCQwnYtk+3+bD4MWmQxiAvVb02ONMtnjHSUKCBiQDLFiTns5+Vd115f6m5xWK+dF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gLu7ghDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gLu7ghDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86419C4CED2;
	Tue,  7 Jan 2025 02:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736215460;
	bh=F89XsTXAsd7WR5XMAKw3wd+NrWs3Lc8rrmgVTCbIDnE=;
	h=Date:To:From:Subject:From;
	b=gLu7ghDcojbMrOS1aySGmC7p7XRhRpHjDARaN0ctVMBEsv1nJLCZLQHwSmvs/4Hz9
	 Jj5gtQwOifLooT+C2JIvkTy6+n0YrBkL6FRA2WnSaZZt63gvL2tB+qy9eH4t8sR7Q9
	 1c/s49KUrf5K9Q9DCtFLY6YDAaFNxQFnOTx7iNig=
Date: Mon, 06 Jan 2025 18:04:19 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch added to mm-unstable branch
Message-Id: <20250107020420.86419C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: clarify trying vs applying on damos_stat kernel-doc comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch

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
Subject: mm/damon: clarify trying vs applying on damos_stat kernel-doc comment
Date: Mon, 6 Jan 2025 11:33:46 -0800

Patch series "mm/damon: enable page level properties based monitoring".

TL; DR
======

This patch series enables access monitoring based on page level properties
including their anonymousness, belonging cgroups and young-ness, by
extending DAMOS stats and regions walk features with region-internal DAMOS
filters.

Background
==========

DAMOS has initially developed for only access-aware system operations. 
But, efficient acces monitoring results querying is yet another major
usage of today's DAMOS.  DAMOS stats and regions walk, which exposes
accumulated counts and per-region monitoring results that filtered by
DAMOS parameters including target access pattern, quotas and DAMOS
filters, are the key features for that usage.  For tunings and
investigations, it can be more useful if only the information can be
exposed without making real system operational change.  Special DAMOS
action, DAMOS_STAT, was introduced for the purpose.

DAMOS fundametally works with only access pattern information in region
granularity.  For some use cases, fixed and fine granularity information
based on non access pattern properties can be useful, though.  For
example, on systems having swap devices that much faster than storage
devices for files, DAMOS-based proactive reclaim need to be applied
differently for anonymous pages and file-backed pages.

DAMOS filters is a feature that makes it possible.  It supports non access
pattern information including page level properties such as anonymousness,
belonging cgroups, and young-ness (whether the page has accessed since the
last access check of it).  The information can be useful for tuning and
investigations.  DAMOS stat exposes some of it via {nr,sz}_applied, but it
is mixed with operation failures.  Also, exposing the information without
making system operation change is impossible, since DAMOS_STAT simply
ignores the page level properties based DAMOS filters.

Design
======

Expose the exact information for every DAMOS action including DAMOS_STAT
by implementing below changes.

Extend the interface for DAMON operations set layer, which contains the
implementation of the page level filters, to report back the amount of
memory that passed the region-internal DAMOS filters to the core layer. 
On the core layer, account the operations set layer reported stat with
DAMOS stat for per-scheme monitoring.  Also, pass the information to
regions walk for per-region monitoring.  In this way, DAMON API users can
efficiently get the fine-grained information.

For the user-space, make DAMON sysfs interface collects the information
using the updated DAMON core API, and expose those to new per-scheme stats
file and per-DAMOS-tried region properties file.

Practical Usages
================

With this patch series, DAMON users can query how many bytes of regions of
specific access temperature is backed by pages of specific type.  The type
can be any of DAMOS filter-supporting one, including anonymousness,
belonging cgroups, and young-ness.  For example, users can visualize
access hotness-based page granulairty histogram for different cgroups,
backing content type, or youngness.  In future, it could be extended to
more types such as whether it is THP, position on LRU lists, etc.  This
can be useful for estimating benefits of a new or an existing access-aware
system optimizations without really committing the changes.

Patches Sequence
================

The patches are constructed in four sub-sequences.

First three patches (patches 1-3) update documents to have missing
background knowledges and better structures for easily introducing
followup changes.

Following three patches (patches 4-6) change the operations set layer
interface to report back the region-internal filter passed memory size,
and make the operations set implementations support the changed symantic.

Following five patches (patches 7-11) implement per-scheme accumulated
stat for region-internal filter-passed memory size on core API
(damos_stat) and DAMON sysfs interface.  First two patches of those are
for code change, and following three patches are for documentation.

Finally, five patches (patches 12-16) implementing per-region
region-internal filter-passed memory size follows.  Similar to that for
per-scheme stat, first two patches implement core-API and sysfs interface
change.  Then three patches for documentation update follow.


This patch (of 16):

DAMOS stat kernel-doc documentation is using terms that bit ambiguous. 
Without reading the code, understanding it correctly is not that easy. 
Add the clarification on the kernel-doc comment.

Link: https://lkml.kernel.org/r/20250106193401.109161-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250106193401.109161-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/include/linux/damon.h~mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment
+++ a/include/linux/damon.h
@@ -287,6 +287,23 @@ struct damos_watermarks {
  * @nr_applied:	Total number of regions that the scheme is applied.
  * @sz_applied:	Total size of regions that the scheme is applied.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
+ *
+ * "Tried an action to a region" in this context means the DAMOS core logic
+ * determined the region as eligible to apply the action.  The access pattern
+ * (&struct damos_access_pattern), quotas (&struct damos_quota), watermarks
+ * (&struct damos_watermarks) and filters (&struct damos_filter) that handled
+ * on core logic can affect this.  The core logic asks the operation set
+ * (&struct damon_operations) to apply the action to the region.
+ *
+ * "Applied an action to a region" in this context means the operation set
+ * (&struct damon_operations) successfully applied the action to the region, at
+ * least to a part of the region.  The filters (&struct damos_filter) that
+ * handled on operation set layer and type of the action and pages of the
+ * region can affect this.  For example, if a filter is set to exclude
+ * anonymous pages and the region has only anonymous pages, the region will be
+ * failed at applying the action.  If the action is &DAMOS_PAGEOUT and all
+ * pages of the region are already paged out, the region will be failed at
+ * applying the action.
  */
 struct damos_stat {
 	unsigned long nr_tried;
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

