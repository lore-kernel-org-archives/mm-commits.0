Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84EE8E7C4FC
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbjJDUXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244971AbjJDUWa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5283F1989
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2726C433C7;
        Wed,  4 Oct 2023 20:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450926;
        bh=zxGesU7uX3krwIECjquCKvn+1QOJmgxGXNE1YIO56hc=;
        h=Date:To:From:Subject:From;
        b=kdmUUM9G/kD8YkwBMNPQwz5jpfrRpFrhbl/rcSoSBTAs8tBaFPWXNgb4sUVaVI2Al
         3th5gcGoyhFTKNdoDhsIAJ+ruAxV2L5ooqywQtFUUbotmNDVU8yL0rbSJ7KLp8BJBB
         nDvY9BTjr26M8XftcoYW0iDfheXqhK0awjuUrGls=
Date:   Wed, 04 Oct 2023 13:22:03 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-test-add-a-unit-test-for-damon_moving_sum.patch removed from -mm tree
Message-Id: <20231004202205.A2726C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core-test: add a unit test for damon_moving_sum()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-add-a-unit-test-for-damon_moving_sum.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


