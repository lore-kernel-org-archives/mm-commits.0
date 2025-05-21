Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4F71CEEB2
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846653; cv=none; b=ow/ogDGOQwbHjHWn41HLrFMuitx7utmn0IppcgXn5D5cbnHPCCKVgl5bUltqWtLf40iUbuK2gPDwpzlEbkM/N7o0NlGsgOlxPpcCTW/pQy0mm6aH1SvAjhLcYCS5BxuIK1UMccwifdP2egNZ14ihFQIRe1mPQhpivryv7YM4vVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846653; c=relaxed/simple;
	bh=6u6GFkGb9oEevax+KSZIc0d6VueJ+GyHoNzn/Jj91p4=;
	h=Date:To:From:Subject:Message-Id; b=LUjyVePCVIbZENx1G7p6Rz1abef84rOmOixJT4Sn/o44xXBQjTxd0XRgDcz4P4ftP5WedcRDHsv3OeOZ1Vc70HKOf2IxlB5YNTCDPahscQa7fm12rxwHRfQsoQ3J8ym57LL5SPuifViBpDhWUrtHsZc3AePRyww4SgP9ELVaVhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fMEszhbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fMEszhbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED41C4CEE4;
	Wed, 21 May 2025 16:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846653;
	bh=6u6GFkGb9oEevax+KSZIc0d6VueJ+GyHoNzn/Jj91p4=;
	h=Date:To:From:Subject:From;
	b=fMEszhbiK3CiW08lL4WCuCNWntdbOO3TE87ZalDk9fjKMvNy+3toSuXWp/YVE7ixu
	 1l928RhNh13KrliUosJLjZ47q+3d1bBu8LlD9wvpCkQNIIO/2zYzwxyhUk3ePxp5t0
	 Wsd7Zk12Cz41cfzBvUKGObj86YA3cK4UPnNtmuog=
Date: Wed, 21 May 2025 09:57:32 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch removed from -mm tree
Message-Id: <20250521165733.6ED41C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add a test for damos_set_filters_default_reject()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


