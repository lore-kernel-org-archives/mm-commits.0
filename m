Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99BF19E99F
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308496; cv=none; b=l9w3xPVJnHjNnBooIfADuApQfHxbqrv0uEFVYp1SkvbniMZvoxtUZVRw3r5l55twn806IhU1dJvyCqAsGDCIjHrStzzjicwdlDSQlKm/wX9uKRmZ6yz1hhJlW5FcP2RT8TPHm0IC6qhNIw/zzDw6nJos8yfBDrGRNUsCELlGLQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308496; c=relaxed/simple;
	bh=VXNBzmCULsy7Qiq80MPt30wRF3QnqcYX/qu0OCMAd7I=;
	h=Date:To:From:Subject:Message-Id; b=j3Rq28zx+9hsrZhFYz3cOohpT2GLVNt/86eUWeikmM6vizHEojoS4wWJmEWApGNRGUa2tflvJM+uS2KtFl2uSUrBcZraTS8Pu0uztFlbEo9ZQPi5xqmZ2RQX9sC5w+bbwY7Jqnzmg+qXdt0QXqkDEgd0a5G6fXvhlWO9gWqKMRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MuQPUi0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MuQPUi0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D74EC4CEE2;
	Wed,  8 Jan 2025 03:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736308496;
	bh=VXNBzmCULsy7Qiq80MPt30wRF3QnqcYX/qu0OCMAd7I=;
	h=Date:To:From:Subject:From;
	b=MuQPUi0v0r4M9Dv++FF+NLL8pTvNASRyjyytR+NlW5QQxleGH+97AxZ2/mQ4B5M4e
	 1X0jGkBwa4uRLnq0Ibi5KlpaY5yX5j9w6N/40i6BBvr/R7vXFgNqg+TUxWSw05XQ/d
	 r43cOepOa1Oaw4bAAHRLmm3HDJZPOkMoN7ljI2Fw=
Date: Tue, 07 Jan 2025 19:54:55 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-add-pass-argument-to-damos_new_filter.patch added to mm-unstable branch
Message-Id: <20250108035456.2D74EC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: add pass argument to damos_new_filter()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-add-pass-argument-to-damos_new_filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-add-pass-argument-to-damos_new_filter.patch

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
Subject: mm/damon: add pass argument to damos_new_filter()
Date: Tue, 7 Jan 2025 12:17:34 -0800

DAMON API users should set damos_filter->pass manually to use a DAMOS pass
filter, since damos_new_filter() unsets the field always.  It is
cumbersome and easy to mistake.  Add an arugment for setting the field to
damos_new_filter().

Link: https://lkml.kernel.org/r/20250107201739.79484-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h       |    2 +-
 mm/damon/core.c             |    7 ++++---
 mm/damon/paddr.c            |    3 ++-
 mm/damon/reclaim.c          |    2 +-
 mm/damon/sysfs-schemes.c    |    2 +-
 mm/damon/tests/core-kunit.h |    4 ++--
 6 files changed, 11 insertions(+), 9 deletions(-)

--- a/include/linux/damon.h~mm-damon-add-pass-argument-to-damos_new_filter
+++ a/include/linux/damon.h
@@ -801,7 +801,7 @@ void damon_update_region_access_rate(str
 		struct damon_attrs *attrs);
 
 struct damos_filter *damos_new_filter(enum damos_filter_type type,
-		bool matching);
+		bool matching, bool pass);
 void damos_add_filter(struct damos *s, struct damos_filter *f);
 void damos_destroy_filter(struct damos_filter *f);
 
--- a/mm/damon/core.c~mm-damon-add-pass-argument-to-damos_new_filter
+++ a/mm/damon/core.c
@@ -266,7 +266,7 @@ int damon_set_regions(struct damon_targe
 }
 
 struct damos_filter *damos_new_filter(enum damos_filter_type type,
-		bool matching)
+		bool matching, bool pass)
 {
 	struct damos_filter *filter;
 
@@ -275,7 +275,7 @@ struct damos_filter *damos_new_filter(en
 		return NULL;
 	filter->type = type;
 	filter->matching = matching;
-	filter->pass = false;
+	filter->pass = pass;
 	INIT_LIST_HEAD(&filter->list);
 	return filter;
 }
@@ -806,7 +806,8 @@ static int damos_commit_filters(struct d
 			continue;
 
 		new_filter = damos_new_filter(
-				src_filter->type, src_filter->matching);
+				src_filter->type, src_filter->matching,
+				src_filter->pass);
 		if (!new_filter)
 			return -ENOMEM;
 		damos_commit_filter_arg(new_filter, src_filter);
--- a/mm/damon/paddr.c~mm-damon-add-pass-argument-to-damos_new_filter
+++ a/mm/damon/paddr.c
@@ -259,7 +259,8 @@ static unsigned long damon_pa_pageout(st
 		}
 	}
 	if (install_young_filter) {
-		filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, true);
+		filter = damos_new_filter(
+				DAMOS_FILTER_TYPE_YOUNG, true, false);
 		if (!filter)
 			return 0;
 		damos_add_filter(s, filter);
--- a/mm/damon/reclaim.c~mm-damon-add-pass-argument-to-damos_new_filter
+++ a/mm/damon/reclaim.c
@@ -221,7 +221,7 @@ static int damon_reclaim_apply_parameter
 	}
 
 	if (skip_anon) {
-		filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
+		filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, false);
 		if (!filter)
 			goto out;
 		damos_add_filter(scheme, filter);
--- a/mm/damon/sysfs-schemes.c~mm-damon-add-pass-argument-to-damos_new_filter
+++ a/mm/damon/sysfs-schemes.c
@@ -1901,7 +1901,7 @@ static int damon_sysfs_add_scheme_filter
 			sysfs_filters->filters_arr[i];
 		struct damos_filter *filter =
 			damos_new_filter(sysfs_filter->type,
-					sysfs_filter->matching);
+					sysfs_filter->matching, false);
 		int err;
 
 		if (!filter)
--- a/mm/damon/tests/core-kunit.h~mm-damon-add-pass-argument-to-damos_new_filter
+++ a/mm/damon/tests/core-kunit.h
@@ -411,7 +411,7 @@ static void damos_test_new_filter(struct
 {
 	struct damos_filter *filter;
 
-	filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
+	filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, false);
 	KUNIT_EXPECT_EQ(test, filter->type, DAMOS_FILTER_TYPE_ANON);
 	KUNIT_EXPECT_EQ(test, filter->matching, true);
 	KUNIT_EXPECT_PTR_EQ(test, filter->list.prev, &filter->list);
@@ -425,7 +425,7 @@ static void damos_test_filter_out(struct
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
 
-	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true);
+	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
 	f->addr_range = (struct damon_addr_range){
 		.start = DAMON_MIN_REGION * 2, .end = DAMON_MIN_REGION * 6};
 
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

