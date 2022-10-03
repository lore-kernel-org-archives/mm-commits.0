Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4746AC4167B
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJCVLu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJCVKf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:10:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8982F51403
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16A0DB81122
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13A6C43144;
        Mon,  3 Oct 2022 21:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831211;
        bh=hzAWirZ2QppNkpysYWAef8SCmlkIV0dgDhJ4Iyiscjk=;
        h=Date:To:From:Subject:From;
        b=jO5zc9kQLfjljqchN0RpLEh5bposR8NkCM3GYyC0YzQQYYl/zeBws6InsmRfgqwVe
         lJQDteLbz91AOcngEySc9Fo3+rKh2NXQ7eRhN8spsf5kYZYfgT4UOs1waQmlOYkDr4
         ZX7qEyov1V4XxzMBoqUKez+kioikrnQTW7PXz9Ag=
Date:   Mon, 03 Oct 2022 14:06:51 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-test-test-damon_set_regions.patch removed from -mm tree
Message-Id: <20221003210651.C13A6C43144@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core-test: test damon_set_regions
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-test-damon_set_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core-test: test damon_set_regions
Date: Fri, 9 Sep 2022 20:28:57 +0000

Preceding commit fixes a bug in 'damon_set_regions()', which allows holes
in the new monitoring target ranges.  This commit adds a kunit test case
for the problem to avoid any regression.

Link: https://lkml.kernel.org/r/20220909202901.57977-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yun Levi <ppbuk5246@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-test-damon_set_regions
+++ a/mm/damon/core-test.h
@@ -267,6 +267,28 @@ static void damon_test_ops_registration(
 	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
 }
 
+static void damon_test_set_regions(struct kunit *test)
+{
+	struct damon_target *t = damon_new_target();
+	struct damon_region *r1 = damon_new_region(4, 16);
+	struct damon_region *r2 = damon_new_region(24, 32);
+	struct damon_addr_range range = {.start = 8, .end = 28};
+	unsigned long expects[] = {8, 16, 16, 24, 24, 28};
+	int expect_idx = 0;
+	struct damon_region *r;
+
+	damon_add_region(r1, t);
+	damon_add_region(r2, t);
+	damon_set_regions(t, &range, 1);
+
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 3);
+	damon_for_each_region(r, t) {
+		KUNIT_EXPECT_EQ(test, r->ar.start, expects[expect_idx++]);
+		KUNIT_EXPECT_EQ(test, r->ar.end, expects[expect_idx++]);
+	}
+	damon_destroy_target(t);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -276,6 +298,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_merge_regions_of),
 	KUNIT_CASE(damon_test_split_regions_of),
 	KUNIT_CASE(damon_test_ops_registration),
+	KUNIT_CASE(damon_test_set_regions),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

