Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C6FEEA6
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 01:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747099091; cv=none; b=NfM3RpB12PVEev1SCY0fHNjXxx+d7dS9S3hJ1xM9BCVAYCMseaJYUo1UXtNOIv2rUEVE6iZCJietUX7YT7+4kXW2IS1owXEnykBAY2IlxWGXM2HKBTeYIAtcU+6MtEquRoB3bGL1yjdJMgTO3s2R+LayJWFp45BPKgm18jXlvcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747099091; c=relaxed/simple;
	bh=SvvLqk7ei6oitp/zenTDEDIx8r2Vc9UyP8NPPs6wzTc=;
	h=Date:To:From:Subject:Message-Id; b=CksInl6WKlly5/WA2txYtsW8HI5aSaflIcS0gj9vyk78dtLNzTeTA4Z7MwodeuGS4noFj/kqyuYH801LKi/mv85a1M+IMbnlgpPLhUY35dlH6e0KSO5UMxFWxpWvsbgc1CRS0ELRalC1PHoTzZUkdS0e+fg5uP833GVH1JA5u+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ziWI1YQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ziWI1YQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7CEC4CEE7;
	Tue, 13 May 2025 01:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747099090;
	bh=SvvLqk7ei6oitp/zenTDEDIx8r2Vc9UyP8NPPs6wzTc=;
	h=Date:To:From:Subject:From;
	b=ziWI1YQZa9Wtxrhn/G/vY3uIUYNXxCFB4LJ3h2FBKBEFYA4ju+WZsrcLch1hnCCkC
	 uSShT3CYOJrsmdtQdPS9ZLsSoxwm3C+ZnkuQJ+BiFJqNRog4KZz5uJTAGYvfKOqLbR
	 Uv/uvTGvm8a5B511epXWHSgH//v8x6eKJbD+wfME=
Date: Mon, 12 May 2025 18:18:10 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch added to mm-new branch
Message-Id: <20250513011810.8B7CEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: add a test for damos_set_filters_default_reject()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/damon/tests/core-kunit: add a test for damos_set_filters_default_reject()
Date: Mon, 12 May 2025 17:27:13 -0700

DAMOS filters' default reject behavior is not very simple.  Actually there
was a mistake[1] during the development.  Add a kunit test for validating
the behavior.

Link: https://lkml.kernel.org/r/20250513002715.40126-5-sj@kernel.org
Link: https://lore.kernel.org/20250227002913.19359-1-sj@kernel.org [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   70 ++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject
+++ a/mm/damon/tests/core-kunit.h
@@ -510,6 +510,75 @@ static void damon_test_feed_loop_next_in
 			damon_feed_loop_next_input(last_input, 2000));
 }
 
+static void damon_test_set_filters_default_reject(struct kunit *test)
+{
+	struct damos scheme;
+	struct damos_filter *target_filter, *anon_filter;
+
+	INIT_LIST_HEAD(&scheme.filters);
+	INIT_LIST_HEAD(&scheme.ops_filters);
+
+	damos_set_filters_default_reject(&scheme);
+	/*
+	 * No filter is installed.  Allow by default on both core and ops layer
+	 * filtering stages, since there are no filters at all.
+	 */
+	KUNIT_EXPECT_EQ(test, scheme.core_filters_default_reject, false);
+	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, false);
+
+	target_filter = damos_new_filter(DAMOS_FILTER_TYPE_TARGET, true, true);
+	damos_add_filter(&scheme, target_filter);
+	damos_set_filters_default_reject(&scheme);
+	/*
+	 * A core-handled allow-filter is installed.
+	 * Rejct by default on core layer filtering stage due to the last
+	 * core-layer-filter's behavior.
+	 * Allow by default on ops layer filtering stage due to the absence of
+	 * ops layer filters.
+	 */
+	KUNIT_EXPECT_EQ(test, scheme.core_filters_default_reject, true);
+	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, false);
+
+	target_filter->allow = false;
+	damos_set_filters_default_reject(&scheme);
+	/*
+	 * A core-handled reject-filter is installed.
+	 * Allow by default on core layer filtering stage due to the last
+	 * core-layer-filter's behavior.
+	 * Allow by default on ops layer filtering stage due to the absence of
+	 * ops layer filters.
+	 */
+	KUNIT_EXPECT_EQ(test, scheme.core_filters_default_reject, false);
+	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, false);
+
+	anon_filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, true);
+	damos_add_filter(&scheme, anon_filter);
+
+	damos_set_filters_default_reject(&scheme);
+	/*
+	 * A core-handled reject-filter and ops-handled allow-filter are installed.
+	 * Allow by default on core layer filtering stage due to the existence
+	 * of the ops-handled filter.
+	 * Reject by default on ops layer filtering stage due to the last
+	 * ops-layer-filter's behavior.
+	 */
+	KUNIT_EXPECT_EQ(test, scheme.core_filters_default_reject, false);
+	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, true);
+
+	target_filter->allow = true;
+	damos_set_filters_default_reject(&scheme);
+	/*
+	 * A core-handled allow-filter and ops-handled allow-filter are
+	 * installed.
+	 * Allow by default on core layer filtering stage due to the existence
+	 * of the ops-handled filter.
+	 * Reject by default on ops layer filtering stage due to the last
+	 * ops-layer-filter's behavior.
+	 */
+	KUNIT_EXPECT_EQ(test, scheme.core_filters_default_reject, false);
+	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, true);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -527,6 +596,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
+	KUNIT_CASE(damon_test_set_filters_default_reject),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch
samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch
mm-damon-core-warn-and-fix-nr_accesses-corruption.patch
mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch
mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch
mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch
selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch
docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch

