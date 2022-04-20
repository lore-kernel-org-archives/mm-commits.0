Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF30C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 22:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354616AbiDTWZv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 18:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237210AbiDTWZu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 18:25:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FF53A5C2
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 15:23:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3E07B821C5
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 22:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E2AC385A0;
        Wed, 20 Apr 2022 22:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650493379;
        bh=QzWyEauo1/thrj1+gD5Oelr3QZovdrWhlEMMOnWGKVQ=;
        h=Date:To:From:Subject:From;
        b=cx3CDCetVO4/vGfda5W3i0rttw2bkUnnRie85qth9T3nS4FJNszj9d8YpnqHiFg98
         FUwX1zBw+Pab9gOcQIXyxNyFTIIGj80tZBA4PIs6jTLR1qjltawGJ5uw0HRndkZAqY
         JEnhYDfwDdEocHyAu6bpdxHbmu+dbhb/TRo49oNo=
Date:   Wed, 20 Apr 2022 15:22:58 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch added to -mm tree
Message-Id: <20220420222259.92E2AC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: add a kunit test case for ops registration
has been added to the -mm tree.  Its filename is
     mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core-test: add a kunit test case for ops registration

This commit adds a simple kunit test case for DAMON operations
registration feature.

Link: https://lkml.kernel.org/r/20220419122225.290518-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-add-a-kunit-test-case-for-ops-registration
+++ a/mm/damon/core-test.h
@@ -232,6 +232,41 @@ static void damon_test_split_regions_of(
 	damon_destroy_ctx(c);
 }
 
+static void damon_test_ops_registration(struct kunit *test)
+{
+	struct damon_ctx *c = damon_new_ctx();
+	struct damon_operations ops, bak;
+
+	/* DAMON_OPS_{V,P}ADDR are registered on subsys_initcall */
+	KUNIT_EXPECT_EQ(test, damon_select_ops(c, DAMON_OPS_VADDR), 0);
+	KUNIT_EXPECT_EQ(test, damon_select_ops(c, DAMON_OPS_PADDR), 0);
+
+	/* Double-registration is prohibited */
+	ops.id = DAMON_OPS_VADDR;
+	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
+	ops.id = DAMON_OPS_PADDR;
+	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
+
+	/* Unknown ops id cannot be registered */
+	KUNIT_EXPECT_EQ(test, damon_select_ops(c, NR_DAMON_OPS), -EINVAL);
+
+	/* Registration should success after unregistration */
+	mutex_lock(&damon_ops_lock);
+	bak = damon_registered_ops[DAMON_OPS_VADDR];
+	damon_registered_ops[DAMON_OPS_VADDR] = (struct damon_operations){};
+	mutex_unlock(&damon_ops_lock);
+
+	ops.id = DAMON_OPS_VADDR;
+	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), 0);
+
+	mutex_lock(&damon_ops_lock);
+	damon_registered_ops[DAMON_OPS_VADDR] = bak;
+	mutex_unlock(&damon_ops_lock);
+
+	/* Check double-registration failure again */
+	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -240,6 +275,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_merge_two),
 	KUNIT_CASE(damon_test_merge_regions_of),
 	KUNIT_CASE(damon_test_split_regions_of),
+	KUNIT_CASE(damon_test_ops_registration),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch

