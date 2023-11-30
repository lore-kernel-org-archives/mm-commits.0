Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77B2C10F04
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 22:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377157AbjK3WXX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 17:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377159AbjK3WXW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 17:23:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C2F1703
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 14:23:21 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2F4C433C7;
        Thu, 30 Nov 2023 22:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701383001;
        bh=tUtM7agKTouUsDl+J7hxREFntNUePrDrd9fdKnjhBXw=;
        h=Date:To:From:Subject:From;
        b=UhwjFizeene64NFsuWiu8NZ+Q4wyHB5aYPAFEA6ne+dAL1xJvtLeoLGpTrDmN0jiT
         s3qMsay3MgsIWApG1ESX3eWA8mXcv5TzNfGrPc7uSP4LT4ofW025Vczm2Rd118I7M+
         KAhwCh4OUSpeJv8am+OzdBnpLv/8WuvMlGBFQ3aU=
Date:   Thu, 30 Nov 2023 14:23:20 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, davidgow@google.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch added to mm-unstable branch
Message-Id: <20231130222321.7A2F4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: add a unit test for the feedback loop algorithm
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch

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
Subject: mm/damon/core-test: add a unit test for the feedback loop algorithm
Date: Thu, 30 Nov 2023 02:36:48 +0000

Implement a simple kunit test for testing the behavior of the feedback
loop algorithm for the aim-oriented feedback-friven DAMOS aggressiveness
auto tuning.

Link: https://lkml.kernel.org/r/20231130023652.50284-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm
+++ a/mm/damon/core-test.h
@@ -446,6 +446,37 @@ static void damos_test_filter_out(struct
 	damos_free_filter(f);
 }
 
+static void damon_test_feed_loop_next_input(struct kunit *test)
+{
+	unsigned long last_input = 900000, current_score = 200;
+
+	/*
+	 * If current score is lower than the goal, which is always 10,000
+	 * (read the comment on damon_feed_loop_next_input()'s comment), next
+	 * input should be higher than the last input.
+	 */
+	KUNIT_EXPECT_GT(test,
+			damon_feed_loop_next_input(last_input, current_score),
+			last_input);
+
+	/*
+	 * If current score is higher than the goal, next input should be lower
+	 * than the last input.
+	 */
+	current_score = 250000000;
+	KUNIT_EXPECT_LT(test,
+			damon_feed_loop_next_input(last_input, current_score),
+			last_input);
+
+	/*
+	 * The next input depends on the distance between the current score and
+	 * the goal
+	 */
+	KUNIT_EXPECT_GT(test,
+			damon_feed_loop_next_input(last_input, 200),
+			damon_feed_loop_next_input(last_input, 2000));
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -461,6 +492,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_filter_out),
+	KUNIT_CASE(damon_test_feed_loop_next_input),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-nr_accesses-when-splitting-region.patch
mm-damon-sysfs-schemes-add-timeout-for-update_schemes_tried_regions.patch
mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning.patch
mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup.patch
mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch
mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch
mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch
selftests-damon-test-quota-goals-directory.patch
docs-mm-damon-design-document-damos-quota-auto-tuning.patch
docs-abi-damon-document-damos-quota-goals.patch
docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch

