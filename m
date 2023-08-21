Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E19EE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjHUUkB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjHUUjo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947E918D
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5AD064A31
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300BAC433C7;
        Mon, 21 Aug 2023 20:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650370;
        bh=QBmGKawrwJcdAswFpNxOAHTyfrk3fObJA7T7y2iPN9U=;
        h=Date:To:From:Subject:From;
        b=XAB1CSU66IPPfVqij7CplEuaoRwOMmRwRV2AbshkNeo6WjQ+GTL+neZtpPuBZ2j/3
         zxJHjA9qKHCaG43qMsJnFd1u4B4XXg7bGFXE+5kY05ySJBIgb0kBo9ZgsT1KvoNBcp
         gkMddeywJ03gCEx1pVqpNzZMqFo6+lf/SiZDSVZA=
Date:   Mon, 21 Aug 2023 13:39:29 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-test-add-a-test-for-damos_new_filter.patch removed from -mm tree
Message-Id: <20230821203930.300BAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core-test: add a test for damos_new_filter()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-add-a-test-for-damos_new_filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core-test: add a test for damos_new_filter()
Date: Sat, 29 Jul 2023 20:37:33 +0000

damos_new_filter() was having a bug that not initializing ->list field of
the returning damos_filter struct, which results in access to
uninitialized memory.  Add a unit test for the function.

Link: https://lkml.kernel.org/r/20230729203733.38949-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-add-a-test-for-damos_new_filter
+++ a/mm/damon/core-test.h
@@ -341,6 +341,18 @@ static void damon_test_set_attrs(struct
 	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL);
 }
 
+static void damos_test_new_filter(struct kunit *test)
+{
+	struct damos_filter *filter;
+
+	filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
+	KUNIT_EXPECT_EQ(test, filter->type, DAMOS_FILTER_TYPE_ANON);
+	KUNIT_EXPECT_EQ(test, filter->matching, true);
+	KUNIT_EXPECT_PTR_EQ(test, filter->list.prev, &filter->list);
+	KUNIT_EXPECT_PTR_EQ(test, filter->list.next, &filter->list);
+	damos_destroy_filter(filter);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -353,6 +365,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_set_regions),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
+	KUNIT_CASE(damos_test_new_filter),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are


