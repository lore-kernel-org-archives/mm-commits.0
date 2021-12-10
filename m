Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27100C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344707AbhLJWuU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:50:20 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57096 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344658AbhLJWuT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:50:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 30FE2CE2D89
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AC6C341C7;
        Fri, 10 Dec 2021 22:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176401;
        bh=QwElY9r0QSQqvKB6dpiTKoNSwWZHQyNB59M5LkHdlt0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MYGZ2cdJ+u9YYWvN2Q50od8drsIhC6LaUOvy4ZHfG3er+x3kC1ZVXEukjXoPtIyHm
         e9O0O+TZBFwZ04Ueo0IL1WXDJbcQcKRs3ccXx6HLutrbErx/ULSAwlWcgI4HUxLEsE
         RgzXag65plMH4eIO8+QQo5FOSPt0zVdcTr5x3TTg=
Date:   Fri, 10 Dec 2021 14:46:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brendanhiggins@google.com,
        linux-mm@kvack.org, lkp@intel.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 11/21] mm/damon/vaddr-test: split a test function
 having >1024 bytes frame size
Message-ID: <20211210224640.kaScafhqR%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr-test: split a test function having >1024 bytes frame size

On some configuration[1], 'damon_test_split_evenly()' kunit test function
has >1024 bytes frame size, so below build warning is triggered:

      CC      mm/damon/vaddr.o
    In file included from mm/damon/vaddr.c:672:
    mm/damon/vaddr-test.h: In function 'damon_test_split_evenly':
    mm/damon/vaddr-test.h:309:1: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]
      309 | }
          | ^

This commit fixes the warning by separating the common logic in the
function.

[1] https://lore.kernel.org/linux-mm/202111182146.OV3C4uGr-lkp@intel.com/

Link: https://lkml.kernel.org/r/20211201150440.1088-6-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |   77 ++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 37 deletions(-)

--- a/mm/damon/vaddr-test.h~mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size
+++ a/mm/damon/vaddr-test.h
@@ -252,59 +252,62 @@ static void damon_test_apply_three_regio
 			new_three_regions, expected, ARRAY_SIZE(expected));
 }
 
-static void damon_test_split_evenly(struct kunit *test)
+static void damon_test_split_evenly_fail(struct kunit *test,
+		unsigned long start, unsigned long end, unsigned int nr_pieces)
 {
-	struct damon_ctx *c = damon_new_ctx();
-	struct damon_target *t;
-	struct damon_region *r;
-	unsigned long i;
-
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(NULL, NULL, 5),
-			-EINVAL);
-
-	t = damon_new_target(42);
-	r = damon_new_region(0, 100);
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(t, r, 0), -EINVAL);
+	struct damon_target *t = damon_new_target(42);
+	struct damon_region *r = damon_new_region(start, end);
 
 	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(t, r, 10), 0);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 10u);
+	KUNIT_EXPECT_EQ(test,
+			damon_va_evenly_split_region(t, r, nr_pieces), -EINVAL);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1u);
 
-	i = 0;
 	damon_for_each_region(r, t) {
-		KUNIT_EXPECT_EQ(test, r->ar.start, i++ * 10);
-		KUNIT_EXPECT_EQ(test, r->ar.end, i * 10);
+		KUNIT_EXPECT_EQ(test, r->ar.start, start);
+		KUNIT_EXPECT_EQ(test, r->ar.end, end);
 	}
+
 	damon_free_target(t);
+}
+
+static void damon_test_split_evenly_succ(struct kunit *test,
+	unsigned long start, unsigned long end, unsigned int nr_pieces)
+{
+	struct damon_target *t = damon_new_target(42);
+	struct damon_region *r = damon_new_region(start, end);
+	unsigned long expected_width = (end - start) / nr_pieces;
+	unsigned long i = 0;
 
-	t = damon_new_target(42);
-	r = damon_new_region(5, 59);
 	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(t, r, 5), 0);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
+	KUNIT_EXPECT_EQ(test,
+			damon_va_evenly_split_region(t, r, nr_pieces), 0);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_pieces);
 
-	i = 0;
 	damon_for_each_region(r, t) {
-		if (i == 4)
+		if (i == nr_pieces - 1)
 			break;
-		KUNIT_EXPECT_EQ(test, r->ar.start, 5 + 10 * i++);
-		KUNIT_EXPECT_EQ(test, r->ar.end, 5 + 10 * i);
+		KUNIT_EXPECT_EQ(test,
+				r->ar.start, start + i++ * expected_width);
+		KUNIT_EXPECT_EQ(test, r->ar.end, start + i * expected_width);
 	}
-	KUNIT_EXPECT_EQ(test, r->ar.start, 5 + 10 * i);
-	KUNIT_EXPECT_EQ(test, r->ar.end, 59ul);
+	KUNIT_EXPECT_EQ(test, r->ar.start, start + i * expected_width);
+	KUNIT_EXPECT_EQ(test, r->ar.end, end);
 	damon_free_target(t);
+}
 
-	t = damon_new_target(42);
-	r = damon_new_region(5, 6);
-	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(t, r, 2), -EINVAL);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1u);
+static void damon_test_split_evenly(struct kunit *test)
+{
+	struct damon_ctx *c = damon_new_ctx();
+
+	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(NULL, NULL, 5),
+			-EINVAL);
+
+	damon_test_split_evenly_fail(test, 0, 100, 0);
+	damon_test_split_evenly_succ(test, 0, 100, 10);
+	damon_test_split_evenly_succ(test, 5, 59, 5);
+	damon_test_split_evenly_fail(test, 5, 6, 2);
 
-	damon_for_each_region(r, t) {
-		KUNIT_EXPECT_EQ(test, r->ar.start, 5ul);
-		KUNIT_EXPECT_EQ(test, r->ar.end, 6ul);
-	}
-	damon_free_target(t);
 	damon_destroy_ctx(c);
 }
 
_
