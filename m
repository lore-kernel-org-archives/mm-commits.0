Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2889C42A94
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215474; cv=none; b=opztP5O9xC0l3B67a0MKHQ+IfyWqE+Xq6xnQyfS9dFGdcGO240newL5fH5SNr2CwPSU9NCP88ISUXgB012I9JOb0jOPT37p9IyF5TF21H6FtToUhnFk6Npqp9gIA7s6rH0sA+tmQRPZ2hecHNAi0gwva5m/+LyOhobqIDkmKjEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215474; c=relaxed/simple;
	bh=lPveHdc+R2GdCbY0cpeJPucN7/OO0od7p2ZHk7qcNAY=;
	h=Date:To:From:Subject:Message-Id; b=nocyQIsxUHyBQ1yILkFdyvh9bN22QBSFI0AbzJoxiyCE0XrqgKozFetzH2ZV5RrQSr5SlA7Ew+iS1/c7ITEH7jZg3Sw0H+Ey0T0Iy0s8A5bh1a+LaP1jJdHau4XjSMQLn2MMQGPg61xJ2qUjkUkD1vsVOOr1ZWl2mYLNdcKcY1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jsur5bAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jsur5bAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33A0C4CEDD;
	Tue,  7 Jan 2025 02:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736215473;
	bh=lPveHdc+R2GdCbY0cpeJPucN7/OO0od7p2ZHk7qcNAY=;
	h=Date:To:From:Subject:From;
	b=Jsur5bASlgiM4rypDZzyi5jOTz3y9Lgw+YD48pJnj0Hdam9uz/g6HGV0Uva5qU3lA
	 bLvasWkalCqGWbiY3otS9bSEOGYzUag5rbwhYssdjc6zKM4h6gBOwh/9rn0hxjbQ8P
	 Q/nVgvQEaB/E1QknFnJ1NBGjhyYKX5S7B8fL4g5Y=
Date: Mon, 06 Jan 2025 18:04:33 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch added to mm-unstable branch
Message-Id: <20250107020433.A33A0C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: implement per-scheme ops-handled filter-passed bytes stat
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch

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
Subject: mm/damon/core: implement per-scheme ops-handled filter-passed bytes stat
Date: Mon, 6 Jan 2025 11:33:52 -0800

Implement a new per-DAMOS scheme statistic field, namely
sz_ops_filter_passed, using the changed damon_operations->apply_scheme()
interface.  It counts total bytes of memory that given DAMOS action tried
to be applied, and passed the operations layer handled region-internal
filters of the scheme.  DAMON API users can access it using DAMON-internal
safe access features such as damon_call() and/or damos_walk().

Link: https://lkml.kernel.org/r/20250106193401.109161-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 +++
 mm/damon/core.c       |    6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat
+++ a/include/linux/damon.h
@@ -286,6 +286,8 @@ struct damos_watermarks {
  * @sz_tried:	Total size of regions that the scheme is tried to be applied.
  * @nr_applied:	Total number of regions that the scheme is applied.
  * @sz_applied:	Total size of regions that the scheme is applied.
+ * @sz_ops_filter_passed:
+ *		Total bytes that passed ops layer-handled DAMOS filters.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  *
  * "Tried an action to a region" in this context means the DAMOS core logic
@@ -310,6 +312,7 @@ struct damos_stat {
 	unsigned long sz_tried;
 	unsigned long nr_applied;
 	unsigned long sz_applied;
+	unsigned long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
 };
 
--- a/mm/damon/core.c~mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat
+++ a/mm/damon/core.c
@@ -1362,13 +1362,15 @@ static bool damos_skip_charged_region(st
 }
 
 static void damos_update_stat(struct damos *s,
-		unsigned long sz_tried, unsigned long sz_applied)
+		unsigned long sz_tried, unsigned long sz_applied,
+		unsigned long sz_ops_filter_passed)
 {
 	s->stat.nr_tried++;
 	s->stat.sz_tried += sz_tried;
 	if (sz_applied)
 		s->stat.nr_applied++;
 	s->stat.sz_applied += sz_applied;
+	s->stat.sz_ops_filter_passed += sz_ops_filter_passed;
 }
 
 static bool __damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
@@ -1586,7 +1588,7 @@ static void damos_apply_scheme(struct da
 		r->age = 0;
 
 update_stat:
-	damos_update_stat(s, sz, sz_applied);
+	damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
 }
 
 static void damon_do_apply_schemes(struct damon_ctx *c,
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

