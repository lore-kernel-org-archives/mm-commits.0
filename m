Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6462B1FA4
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736467847; cv=none; b=fMLRuEwnYx+ro3NOqE36q8VjugKIStzWZPljwhUQYHNKG39ebw4aWSXdzG3iMi5FuBCBsrG/0IhD/qwcFd/rKFiZbN/r7J9lJNQSilCp2xLCo8TC0oVGODpBwkyuKu0WGph5nrOhY/6dl6XvnJICY4E1Mn/rn3PfMb10HyQgn6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736467847; c=relaxed/simple;
	bh=MqCHtYDgpEHoMiQoP2722ufjqy/pHM8Qj5YKRhP88Kk=;
	h=Date:To:From:Subject:Message-Id; b=YljqZqkytCXfyj+LXNuHi/V044Dk9tBHwS4QCBamcNwt23mlYQmo/H4HDJw+MPfMDmfhR01oBqdRuUgD9YkvKCpHXvVgONzKGi8vkbw8IYKdIBgXqDs/ScEEI1c/tRPk/eBRF6ATdf+4hiJWtvT73MZ0KrvnvKjiFOlxOo6oRjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eqQcVCMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eqQcVCMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0F8C4CED2;
	Fri, 10 Jan 2025 00:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736467847;
	bh=MqCHtYDgpEHoMiQoP2722ufjqy/pHM8Qj5YKRhP88Kk=;
	h=Date:To:From:Subject:From;
	b=eqQcVCMyKtVu+Jog2XH4urihXQ8VDZgxlHyoZsNFf6gFW9W9oH0TcWkDbXcMkA9/C
	 o53zFHfN/DBo41rqU3lHQ9AR+IpfJDaM3XfghjyrGJA4Q/XclsymJn40gA5QLLxdSA
	 ZDvLYk0NQT2s7InidTThHm1XdZSQbLZxropq/WEI=
Date: Thu, 09 Jan 2025 16:10:46 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-support-damos_filter-allow.patch added to mm-unstable branch
Message-Id: <20250110001047.1B0F8C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: support damos_filter->allow
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-support-damos_filter-allow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-support-damos_filter-allow.patch

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
Subject: mm/damon/core: support damos_filter->allow
Date: Thu, 9 Jan 2025 09:51:19 -0800

DAMOS filters supports allowing behavior, but the core layer's DAMOS
filters handling logic still assumes only rejecting (filtering-out)
behavior.  Update the logic to aware of and respect the behavioral
decision by reading damos_filter->allow when making the decision to
exclude a region or not.

Link: https://lkml.kernel.org/r/20250109175126.57878-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c             |    6 +++---
 mm/damon/tests/core-kunit.h |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-support-damos_filter-allow
+++ a/mm/damon/core.c
@@ -1374,7 +1374,7 @@ static void damos_update_stat(struct dam
 	s->stat.sz_ops_filter_passed += sz_ops_filter_passed;
 }
 
-static bool __damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
+static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos_filter *filter)
 {
 	bool matched = false;
@@ -1428,8 +1428,8 @@ static bool damos_filter_out(struct damo
 	struct damos_filter *filter;
 
 	damos_for_each_filter(filter, s) {
-		if (__damos_filter_out(ctx, t, r, filter))
-			return true;
+		if (damos_filter_match(ctx, t, r, filter))
+			return !filter->allow;
 	}
 	return false;
 }
--- a/mm/damon/tests/core-kunit.h~mm-damon-core-support-damos_filter-allow
+++ a/mm/damon/tests/core-kunit.h
@@ -434,25 +434,25 @@ static void damos_test_filter_out(struct
 	damon_add_region(r, t);
 
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
 	r->ar.start = DAMON_MIN_REGION * 1;
 	r->ar.end = DAMON_MIN_REGION * 2;
-	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
 	r->ar.start = DAMON_MIN_REGION * 6;
 	r->ar.end = DAMON_MIN_REGION * 8;
-	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
 	r->ar.start = DAMON_MIN_REGION * 1;
 	r->ar.end = DAMON_MIN_REGION * 4;
-	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 2);
@@ -465,7 +465,7 @@ static void damos_test_filter_out(struct
 	/* region started in the range */
 	r->ar.start = DAMON_MIN_REGION * 2;
 	r->ar.end = DAMON_MIN_REGION * 8;
-	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
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
mm-damon-core-add-damos_filter-allow-field.patch
mm-damon-core-support-damos_filter-allow.patch
mm-damon-paddr-support-damos_filter-allow.patch
mm-damon-add-allow-argument-to-damos_new_filter.patch
mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-allow.patch
docs-mm-damon-design-document-allow-reject-damos-filter-behaviors.patch
docs-abi-damon-document-damos-filter-allow-sysfs-file.patch
docs-admin-guide-mm-damon-usage-omit-damos-filter-details-in-favor-of-design-doc.patch
docs-admin-guide-mm-damon-usage-document-damos-filter-allow-sysfs-file.patch

