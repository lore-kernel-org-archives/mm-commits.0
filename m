Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63503C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344768AbhLJWuW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:50:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43574 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344658AbhLJWuW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:50:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 953E9B828B0
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3FCC00446;
        Fri, 10 Dec 2021 22:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176404;
        bh=ikQ/h8TS9XL3Fuv7CuGbW8Q8ZkWryw85zmClNjGV0lc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pshVJA5uO/mq3+MhMXSbAdzNy6TWzq/LLspRQtOlyp93JrOam42HpaF+zB8dG5uJk
         KRvHkIS/RjZAcROq0YMW/N7qlVOUjH1KQgMja04ABXagC2JTI0w4fNJ1NdcKtNF1lX
         Hga/RaSnMA6s/eVmFMHCCRSHSJvcUKrk47Dty5D8=
Date:   Fri, 10 Dec 2021 14:46:43 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brendanhiggins@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 12/21] mm/damon/vaddr-test: remove unnecessary
 variables
Message-ID: <20211210224643.f0b1dkt_H%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr-test: remove unnecessary variables

A couple of test functions in DAMON virtual address space monitoring
primitives implementation has unnecessary damon_ctx variables.  This
commit removes those.

Link: https://lkml.kernel.org/r/20211201150440.1088-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/mm/damon/vaddr-test.h~mm-damon-vaddr-test-remove-unnecessary-variables
+++ a/mm/damon/vaddr-test.h
@@ -135,7 +135,6 @@ static void damon_do_test_apply_three_re
 				struct damon_addr_range *three_regions,
 				unsigned long *expected, int nr_expected)
 {
-	struct damon_ctx *ctx = damon_new_ctx();
 	struct damon_target *t;
 	struct damon_region *r;
 	int i;
@@ -145,7 +144,6 @@ static void damon_do_test_apply_three_re
 		r = damon_new_region(regions[i * 2], regions[i * 2 + 1]);
 		damon_add_region(r, t);
 	}
-	damon_add_target(ctx, t);
 
 	damon_va_apply_three_regions(t, three_regions);
 
@@ -154,8 +152,6 @@ static void damon_do_test_apply_three_re
 		KUNIT_EXPECT_EQ(test, r->ar.start, expected[i * 2]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expected[i * 2 + 1]);
 	}
-
-	damon_destroy_ctx(ctx);
 }
 
 /*
@@ -298,8 +294,6 @@ static void damon_test_split_evenly_succ
 
 static void damon_test_split_evenly(struct kunit *test)
 {
-	struct damon_ctx *c = damon_new_ctx();
-
 	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(NULL, NULL, 5),
 			-EINVAL);
 
@@ -307,8 +301,6 @@ static void damon_test_split_evenly(stru
 	damon_test_split_evenly_succ(test, 0, 100, 10);
 	damon_test_split_evenly_succ(test, 5, 59, 5);
 	damon_test_split_evenly_fail(test, 5, 6, 2);
-
-	damon_destroy_ctx(c);
 }
 
 static struct kunit_case damon_test_cases[] = {
_
