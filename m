Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE42CEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjHUUke (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjHUUkK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566CACEA
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5AD364B18
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337A0C433C7;
        Mon, 21 Aug 2023 20:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650385;
        bh=N17k9Q8kfXWVj+3BrkUhdwGiLmoQ6u4h2QEJatg6Lds=;
        h=Date:To:From:Subject:From;
        b=2hjt3jWDgUdZZ8glcMgoP2Sc7XZ1EvmCuli0A1nVMsnmqMhlSdVrpUgdYRC8tSXHf
         LAr5z4G1l1CvDCw9e6vb06bo4hULzE1EWn5xcmFYbdNlIZHfmqS35CPM4TNSth4kP8
         IXgIoGJioOwxm8va/QY5dSrvzv+F3LeK24xKphfo=
Date:   Mon, 21 Aug 2023 13:39:44 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-test-add-a-unit-test-for-__damos_filter_out.patch removed from -mm tree
Message-Id: <20230821203945.337A0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core-test: add a unit test for __damos_filter_out()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-add-a-unit-test-for-__damos_filter_out.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core-test: add a unit test for __damos_filter_out()
Date: Wed, 2 Aug 2023 21:43:02 +0000

Implement a kunit test for the core of address range DAMOS filter
handling, namely __damos_filter_out().  The test especially focus on
regions that overlap with given filter's target address range.

Link: https://lkml.kernel.org/r/20230802214312.110532-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   61 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-add-a-unit-test-for-__damos_filter_out
+++ a/mm/damon/core-test.h
@@ -353,6 +353,66 @@ static void damos_test_new_filter(struct
 	damos_destroy_filter(filter);
 }
 
+static void damos_test_filter_out(struct kunit *test)
+{
+	struct damon_target *t;
+	struct damon_region *r, *r2;
+	struct damos_filter *f;
+
+	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true);
+	f->addr_range = (struct damon_addr_range){
+		.start = DAMON_MIN_REGION * 2, .end = DAMON_MIN_REGION * 6};
+
+	t = damon_new_target();
+	r = damon_new_region(DAMON_MIN_REGION * 3, DAMON_MIN_REGION * 5);
+	damon_add_region(r, t);
+
+	/* region in the range */
+	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
+
+	/* region before the range */
+	r->ar.start = DAMON_MIN_REGION * 1;
+	r->ar.end = DAMON_MIN_REGION * 2;
+	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
+
+	/* region after the range */
+	r->ar.start = DAMON_MIN_REGION * 6;
+	r->ar.end = DAMON_MIN_REGION * 8;
+	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
+
+	/* region started before the range */
+	r->ar.start = DAMON_MIN_REGION * 1;
+	r->ar.end = DAMON_MIN_REGION * 4;
+	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	/* filter should have split the region */
+	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 1);
+	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 2);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	r2 = damon_next_region(r);
+	KUNIT_EXPECT_EQ(test, r2->ar.start, DAMON_MIN_REGION * 2);
+	KUNIT_EXPECT_EQ(test, r2->ar.end, DAMON_MIN_REGION * 4);
+	damon_destroy_region(r2, t);
+
+	/* region started in the range */
+	r->ar.start = DAMON_MIN_REGION * 2;
+	r->ar.end = DAMON_MIN_REGION * 8;
+	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f));
+	/* filter should have split the region */
+	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
+	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	r2 = damon_next_region(r);
+	KUNIT_EXPECT_EQ(test, r2->ar.start, DAMON_MIN_REGION * 6);
+	KUNIT_EXPECT_EQ(test, r2->ar.end, DAMON_MIN_REGION * 8);
+	damon_destroy_region(r2, t);
+
+	damon_free_target(t);
+	damos_free_filter(f);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -366,6 +426,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damos_test_new_filter),
+	KUNIT_CASE(damos_test_filter_out),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are


