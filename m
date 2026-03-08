Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1A234CFA8
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 20:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773002164; cv=none; b=HVQT1zpFZ7ym3GuZMPrLwi7eo0qf9565kdeu06mfPDwKKiUQA1ltHZFIWhJ1qC+IyIzkVd5KohBbpWHk7Iw9Ii0I2/7aqQxWUsFebtGbL7wbdd9t6u2/+NVJ+XX1znmGu1MezDNIHRSUKJpH8GyQNHDhjzb/r1DqkcZB8JvALZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773002164; c=relaxed/simple;
	bh=JCO2LDVL1Pbl/uvxmg3E/zxvOgSKcbWI+U/+F2dftfM=;
	h=Date:To:From:Subject:Message-Id; b=qPHTnkp00O4YXHvyQZbh26Lc1TmYWrbVCqYFkjgZ7/acRs3W4NHqhlQZO6+a7JqWdQLWFJgl4HK05tHFPRjpn0SYC839URICBvPgYffEwafNJ3+Fjpcpn7ftZlOIbUXAxE8XZMLdC3cV1AS9Zrq3XA1PRYJDihOIAcuAa9Qvk4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z2j/J4Hg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z2j/J4Hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0EEC116C6;
	Sun,  8 Mar 2026 20:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773002163;
	bh=JCO2LDVL1Pbl/uvxmg3E/zxvOgSKcbWI+U/+F2dftfM=;
	h=Date:To:From:Subject:From;
	b=z2j/J4HgN5Rb0+XiXHUidV4gDoUDVdh8LlQTUSPFSMiJEQPD4CL1CjIkTC5JEhfU6
	 5CPMizaxzw/L7iiOD8DK3cxCA6GaqbQI5WlcGajs67I7I1iu55eU06KOb/wDuuxVSB
	 07wzne978nNVqjUoh/0DCS5eET80E/mqQvAiU0KY=
Date: Sun, 08 Mar 2026 13:36:03 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch added to mm-new branch
Message-Id: <20260308203603.AA0EEC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: add a test for damon_commit_ctx()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: add a test for damon_commit_ctx()
Date: Sat, 7 Mar 2026 11:42:20 -0800

Patch series "mm/damon: test and document power-of-2 min_region_sz
requirement".

Since commit c80f46ac228b ("mm/damon/core: disallow non-power of two
min_region_sz"), min_region_sz is always restricted to be a power of two. 
Add a kunit test to confirm the functionality.  Also, the change adds a
restriction to addr_unit parameter.  Clarify it on the document.


This patch (of 2):

Add a kunit test for confirming the change that is made on commit
c80f46ac228b ("mm/damon/core: disallow non-power of two min_region_sz")
functions as expected.

Link: https://lkml.kernel.org/r/20260307194222.202075-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx
+++ a/mm/damon/tests/core-kunit.h
@@ -1057,6 +1057,27 @@ static void damon_test_commit_target_reg
 			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2);
 }
 
+static void damon_test_commit_ctx(struct kunit *test)
+{
+	struct damon_ctx *src, *dst;
+
+	src = damon_new_ctx();
+	if (!src)
+		kunit_skip(test, "src alloc fail");
+	dst = damon_new_ctx();
+	if (!dst) {
+		damon_destroy_ctx(src);
+		kunit_skip(test, "dst alloc fail");
+	}
+	/* Only power of two min_region_sz is allowed. */
+	src->min_region_sz = 4096;
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), 0);
+	src->min_region_sz = 4095;
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), -EINVAL);
+	damon_destroy_ctx(src);
+	damon_destroy_ctx(dst);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -1313,6 +1334,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_commit_pageout),
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
+	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch

