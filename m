Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CFCEB64D9
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jun 2023 19:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjFOTF0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jun 2023 15:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjFOTFZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2023 15:05:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C541E26BA
        for <mm-commits@vger.kernel.org>; Thu, 15 Jun 2023 12:05:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 554BE61E9E
        for <mm-commits@vger.kernel.org>; Thu, 15 Jun 2023 19:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95082C433C8;
        Thu, 15 Jun 2023 19:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686855922;
        bh=AOLUzK6ozIIzHiBaitmbRlFUXaHOtoHVLcb/+pwpkFI=;
        h=Date:To:From:Subject:From;
        b=UvxRtC1EncSVaVrBruYn+yXE7L4jHHjH65khL+k+C9L6YiZLpZwY8uyTH2g6AEb/e
         Pk7HUk1LbzBZaYM0jpYo9CN0MgpVqhoJziR2+Ax1/2muXYZZTrUIMFx1DTDjiWCClX
         1g7NQN3zQ9JVEhHJ0seXvV7QrHJIyxbOOuyZWMQs=
Date:   Thu, 15 Jun 2023 12:05:21 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-add-a-test-for-damon_set_attrs.patch added to mm-unstable branch
Message-Id: <20230615190522.95082C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: add a test for damon_set_attrs()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-test-add-a-test-for-damon_set_attrs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-add-a-test-for-damon_set_attrs.patch

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
Subject: mm/damon/core-test: add a test for damon_set_attrs()
Date: Thu, 15 Jun 2023 18:33:22 +0000

Commit 5ff6e2fff88e ("mm/damon/core: fix divide error in
damon_nr_accesses_to_accesses_bp()") fixed a bug by adding arguments
validation in damon_set_attrs().  Add a unit test for the added validation
to ensure the bug cannot occur again.

Link: https://lkml.kernel.org/r/20230615183323.87561-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
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

mm-damon-core-test-add-a-test-for-damon_set_attrs.patch

