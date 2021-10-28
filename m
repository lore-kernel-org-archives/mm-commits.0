Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76367C43217
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6535C610E5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhJ1VjE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231411AbhJ1VjB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 17:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 270DB610D2;
        Thu, 28 Oct 2021 21:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635456994;
        bh=X6fs3f2fSOBDq+IJaZt2fhaL5UXblQ955KaLJm/Tiuc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ofseem+jB3XecyPHSmkd5sZ3dV1NoNSEGSb6Rf70npQDCpugki2qgB31JizKr8doJ
         QQRd1mCdejtCE1N8N3bbzJZsl8cPahQXs+bECNX8jxnWuzHgvD+ubqnZvcp/ddA/hP
         GKLLJ7k7Foda+pEHcXeFhES1ADGRm7Q6D31VGq9U=
Date:   Thu, 28 Oct 2021 14:36:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 10/11] mm/damon/core-test: fix wrong expectations
 for 'damon_split_regions_of()'
Message-ID: <20211028213633.VtZv_vHJo%akpm@linux-foundation.org>
In-Reply-To: <20211028143506.5f5d5e2cd1f768a1da864844@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core-test: fix wrong expectations for 'damon_split_regions_of()'

Kunit test cases for 'damon_split_regions_of()' expects the number of
regions after calling the function will be same to their request
('nr_sub').  However, the requested number is just an upper-limit, because
the function randomly decides the size of each sub-region.  This commit
fixes the wrong expectation.

Link: https://lkml.kernel.org/r/20211028090628.14948-1-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/core-test.h~mm-damon-core-test-fix-wrong-expectations-for-damon_split_regions_of
+++ a/mm/damon/core-test.h
@@ -219,14 +219,14 @@ static void damon_test_split_regions_of(
 	r = damon_new_region(0, 22);
 	damon_add_region(r, t);
 	damon_split_regions_of(c, t, 2);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2u);
+	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 2u);
 	damon_free_target(t);
 
 	t = damon_new_target(42);
 	r = damon_new_region(0, 220);
 	damon_add_region(r, t);
 	damon_split_regions_of(c, t, 4);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 4u);
+	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
 	damon_destroy_ctx(c);
 }
_
