Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2583EEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjFSX1V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjFSXZu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6800010D0
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4617B60FAF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6E6C433C0;
        Mon, 19 Jun 2023 23:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217007;
        bh=ZQSWi5fYRfEnXpn/vV+6G32PpViZOhG7UNw9OnrRLN8=;
        h=Date:To:From:Subject:From;
        b=Z4TCPe/ZQkYd/jrzChej85cr+z9fbUS4KIOn0hGHezJfYUApbfjFHru70xP0IfRlW
         zubJoUEvtWgrznxmT2XRbIgA2KAKbeVAVcyXHhjzQhKjL+n5xCeXBd2ZEdV/8jSVSc
         z9m7GX5vck+edmLJcs4Bf98fqCXwRNZ5ghMifUzs=
Date:   Mon, 19 Jun 2023 16:23:27 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-test-add-a-test-for-damon_set_attrs.patch removed from -mm tree
Message-Id: <20230619232327.9E6E6C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core-test: add a test for damon_set_attrs()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-add-a-test-for-damon_set_attrs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core-test: add a test for damon_set_attrs()
Date: Thu, 15 Jun 2023 18:33:22 +0000

Commit 5ff6e2fff88e ("mm/damon/core: fix divide error in
damon_nr_accesses_to_accesses_bp()") fixed a bug by adding arguments
validation in damon_set_attrs().  Add a unit test for the added validation
to ensure the bug cannot occur again.

Link: https://lkml.kernel.org/r/20230615183323.87561-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-add-a-test-for-damon_set_attrs
+++ a/mm/damon/core-test.h
@@ -318,6 +318,29 @@ static void damon_test_update_monitoring
 	KUNIT_EXPECT_EQ(test, r->age, 20);
 }
 
+static void damon_test_set_attrs(struct kunit *test)
+{
+	struct damon_ctx ctx;
+	struct damon_attrs valid_attrs = {
+		.min_nr_regions = 10, .max_nr_regions = 1000,
+		.sample_interval = 5000, .aggr_interval = 100000,};
+	struct damon_attrs invalid_attrs;
+
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(&ctx, &valid_attrs), 0);
+
+	invalid_attrs = valid_attrs;
+	invalid_attrs.min_nr_regions = 1;
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(&ctx, &invalid_attrs), -EINVAL);
+
+	invalid_attrs = valid_attrs;
+	invalid_attrs.max_nr_regions = 9;
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(&ctx, &invalid_attrs), -EINVAL);
+
+	invalid_attrs = valid_attrs;
+	invalid_attrs.aggr_interval = 4999;
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(&ctx, &invalid_attrs), -EINVAL);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -329,6 +352,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
 	KUNIT_CASE(damon_test_update_monitoring_result),
+	KUNIT_CASE(damon_test_set_attrs),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are


