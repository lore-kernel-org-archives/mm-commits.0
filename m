Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0353FC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbiEJEUk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235976AbiEJETu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:19:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1894286FED
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC0B61744
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D9FC385A6;
        Tue, 10 May 2022 04:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156067;
        bh=L/Ry2CSYdeuHGh3/62mplL6gVNdI0zhQvleLmKZTIWw=;
        h=Date:To:From:Subject:From;
        b=tVgTHnbRinlqYAMvO931fyqVBgfFfFZDxCKIejw6gmQZFRA7Aom8XOf6dhv0gFHMi
         J15NWeuEvGhjaaiOonIsSUsCAOPrJCcW1b+qGbxlH2v1qzT06sotZ0CsiEy//ZcTDO
         2Dcwa8Xq8ejQZaK5IViIc56VliwO7COiP5Vi8RIg=
Date:   Mon, 09 May 2022 21:14:27 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch removed from -mm tree
Message-Id: <20220510041427.D6D9FC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core-test: add a kunit test case for ops registration
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch

This patch was dropped because it was merged into mm-stable

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


