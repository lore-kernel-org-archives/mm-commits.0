Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9821CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F1AC610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbhKKCwK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:52:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234456AbhKKCwH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:52:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 931356103C;
        Thu, 11 Nov 2021 02:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598958;
        bh=JRMOldYkkLM6t25g4CG+ETctwpK/v31CvGgaZFqIcNc=;
        h=Date:From:To:Subject:From;
        b=vnOnWYg3Jhzn6V+XgphbRa7FbfCi4pmaU1wuZfiUS5SR8nn4KRgA1/jyjkXiK/6yr
         6cfzbk8sKygl0PJKuHuw6/DumsMX6RR57lc/UCIvXIdIhmRgCcWXekLvu/FzpzLK1l
         o6xp4epWpeKCIkDUWpEjZjwe1kxC2SQ5XCFLMUPg=
Date:   Wed, 10 Nov 2021 18:49:17 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org,
        brendanhiggins@google.com, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch removed
 from -mm tree
Message-ID: <20211111024917.-zN9_tcBn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs-test: add a unit test case for 'init_regions'
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs-test: add a unit test case for 'init_regions'

This commit adds another test case for the new feature, 'init_regions'.

Link: https://lkml.kernel.org/r/20211012205711.29216-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rienjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs-test.h |   54 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

--- a/mm/damon/dbgfs-test.h~mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions
+++ a/mm/damon/dbgfs-test.h
@@ -109,9 +109,63 @@ static void damon_dbgfs_test_set_targets
 	dbgfs_destroy_ctx(ctx);
 }
 
+static void damon_dbgfs_test_set_init_regions(struct kunit *test)
+{
+	struct damon_ctx *ctx = damon_new_ctx();
+	unsigned long ids[] = {1, 2, 3};
+	/* Each line represents one region in ``<target id> <start> <end>`` */
+	char * const valid_inputs[] = {"2 10 20\n 2   20 30\n2 35 45",
+		"2 10 20\n",
+		"2 10 20\n1 39 59\n1 70 134\n  2  20 25\n",
+		""};
+	/* Reading the file again will show sorted, clean output */
+	char * const valid_expects[] = {"2 10 20\n2 20 30\n2 35 45\n",
+		"2 10 20\n",
+		"1 39 59\n1 70 134\n2 10 20\n2 20 25\n",
+		""};
+	char * const invalid_inputs[] = {"4 10 20\n",	/* target not exists */
+		"2 10 20\n 2 14 26\n",		/* regions overlap */
+		"1 10 20\n2 30 40\n 1 5 8"};	/* not sorted by address */
+	char *input, *expect;
+	int i, rc;
+	char buf[256];
+
+	damon_set_targets(ctx, ids, 3);
+
+	/* Put valid inputs and check the results */
+	for (i = 0; i < ARRAY_SIZE(valid_inputs); i++) {
+		input = valid_inputs[i];
+		expect = valid_expects[i];
+
+		rc = set_init_regions(ctx, input, strnlen(input, 256));
+		KUNIT_EXPECT_EQ(test, rc, 0);
+
+		memset(buf, 0, 256);
+		sprint_init_regions(ctx, buf, 256);
+
+		KUNIT_EXPECT_STREQ(test, (char *)buf, expect);
+	}
+	/* Put invlid inputs and check the return error code */
+	for (i = 0; i < ARRAY_SIZE(invalid_inputs); i++) {
+		input = invalid_inputs[i];
+		pr_info("input: %s\n", input);
+		rc = set_init_regions(ctx, input, strnlen(input, 256));
+		KUNIT_EXPECT_EQ(test, rc, -EINVAL);
+
+		memset(buf, 0, 256);
+		sprint_init_regions(ctx, buf, 256);
+
+		KUNIT_EXPECT_STREQ(test, (char *)buf, "");
+	}
+
+	damon_set_targets(ctx, NULL, 0);
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_dbgfs_test_str_to_target_ids),
 	KUNIT_CASE(damon_dbgfs_test_set_targets),
+	KUNIT_CASE(damon_dbgfs_test_set_init_regions),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are


