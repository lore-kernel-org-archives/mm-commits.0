Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F508EED619
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 16:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjIOQhO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 12:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbjIOQgm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 12:36:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2DBAC
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 09:36:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE84CC433C7;
        Fri, 15 Sep 2023 16:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694795796;
        bh=wWZx0fPDIlhXfWqWjnNDOrrwLxuumEQFZqLWUQRjR+4=;
        h=Date:To:From:Subject:From;
        b=npu0ZQqvAslvYm//iiTz7d4eoEf/RJV88OI8l0k0p2QdMGNvkLj3GQzbrdHZ9l00k
         rUon0fDqVJ0mJ1zvgEDJvH/iU41rGkpP0akMOyiCotlqkzgZIVjne/Mji1nloROQ9B
         g9CU+LNvE+mg6s93myj4SXp8L88MTTt+5He5a1dU=
Date:   Fri, 15 Sep 2023 09:36:36 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-add-a-unit-test-for-damon_moving_sum.patch added to mm-unstable branch
Message-Id: <20230915163636.BE84CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: add a unit test for damon_moving_sum()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-test-add-a-unit-test-for-damon_moving_sum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-add-a-unit-test-for-damon_moving_sum.patch

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
Subject: mm/damon/core-test: add a unit test for damon_moving_sum()
Date: Fri, 15 Sep 2023 02:52:47 +0000

Add a simple unit test for the pseudo moving-sum function
(damon_moving_sum()).

Link: https://lkml.kernel.org/r/20230915025251.72816-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-add-a-unit-test-for-damon_moving_sum
+++ a/mm/damon/core-test.h
@@ -341,6 +341,21 @@ static void damon_test_set_attrs(struct
 	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL);
 }
 
+static void damon_test_moving_sum(struct kunit *test)
+{
+	unsigned int mvsum = 50000, nomvsum = 50000, len_window = 10;
+	unsigned int new_values[] = {10000, 0, 10000, 0, 0, 0, 10000, 0, 0, 0};
+	unsigned int expects[] = {55000, 50000, 55000, 50000, 45000, 40000,
+		45000, 40000, 35000, 30000};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(new_values); i++) {
+		mvsum = damon_moving_sum(mvsum, nomvsum, len_window,
+				new_values[i]);
+		KUNIT_EXPECT_EQ(test, mvsum, expects[i]);
+	}
+}
+
 static void damos_test_new_filter(struct kunit *test)
 {
 	struct damos_filter *filter;
@@ -425,6 +440,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_set_regions),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
+	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	{},
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch
docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch
docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch
docs-mm-damon-design-explicitly-introduce-nr_accesses.patch
docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch
docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context.patch
docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch
mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch
mm-damon-core-add-more-comments-for-nr_accesses.patch
mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch
mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch
mm-damon-core-add-a-tracepoint-for-damos-apply-target-regions.patch
docs-admin-guide-mm-damon-usage-document-damos_before_apply-tracepoint.patch
mm-damon-core-use-number-of-passed-access-sampling-as-a-timer.patch
mm-damon-core-define-and-use-a-dedicated-function-for-region-access-rate-update.patch
mm-damon-vaddr-call-damon_update_region_access_rate-always.patch
mm-damon-core-implement-a-pseudo-moving-sum-function.patch
mm-damon-core-test-add-a-unit-test-for-damon_moving_sum.patch
mm-damon-core-introduce-nr_accesses_bp.patch
mm-damon-core-use-pseudo-moving-sum-for-nr_accesses_bp.patch
mm-damon-core-skip-updating-nr_accesses_bp-for-each-aggregation-interval.patch
mm-damon-core-mark-damon_moving_sum-as-a-static-function.patch

