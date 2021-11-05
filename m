Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCEFC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CCC860E94
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhKEUvF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232646AbhKEUvF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:51:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F34960174;
        Fri,  5 Nov 2021 20:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145305;
        bh=xsJdjv6ng8sEpgv7jHSwgU/wsI4SvLhKvGQZ2i0Y5jM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MXF1LXatueH6X10jjg5ap07oYGkfIgLLKb2Kn8Zhw3gYPSkFgJdViogpsRKqn+5sf
         fN6RRrbpB3mVWyrYFguHyKmScd1Ao8aoDwYEFd9cswbx9XmzI+rWEtkWaGoXidS08J
         C0TtGxESwDN8WMS89j6+A62Ok/v4dm/UV7T13S5s=
Date:   Fri, 05 Nov 2021 13:48:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.i.king@gmail.com,
        colin.i.king@googlemail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 261/262] mm/damon: fix a few spelling mistakes in
 comments and a pr_debug message
Message-ID: <20211105204824.qNbqcpySO%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Ian King <colin.i.king@googlemail.com>
Subject: mm/damon: fix a few spelling mistakes in comments and a pr_debug message

There are a few spelling mistakes in the code. Fix these.

Link: https://lkml.kernel.org/r/20211028184157.614544-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c       |    2 +-
 mm/damon/dbgfs-test.h |    2 +-
 mm/damon/vaddr-test.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-fix-a-few-spelling-mistakes-in-comments-and-a-pr_debug-message
+++ a/mm/damon/core.c
@@ -959,7 +959,7 @@ static unsigned long damos_wmark_wait_us
 	/* higher than high watermark or lower than low watermark */
 	if (metric > scheme->wmarks.high || scheme->wmarks.low > metric) {
 		if (scheme->wmarks.activated)
-			pr_debug("inactivate a scheme (%d) for %s wmark\n",
+			pr_debug("deactivate a scheme (%d) for %s wmark\n",
 					scheme->action,
 					metric > scheme->wmarks.high ?
 					"high" : "low");
--- a/mm/damon/dbgfs-test.h~mm-damon-fix-a-few-spelling-mistakes-in-comments-and-a-pr_debug-message
+++ a/mm/damon/dbgfs-test.h
@@ -145,7 +145,7 @@ static void damon_dbgfs_test_set_init_re
 
 		KUNIT_EXPECT_STREQ(test, (char *)buf, expect);
 	}
-	/* Put invlid inputs and check the return error code */
+	/* Put invalid inputs and check the return error code */
 	for (i = 0; i < ARRAY_SIZE(invalid_inputs); i++) {
 		input = invalid_inputs[i];
 		pr_info("input: %s\n", input);
--- a/mm/damon/vaddr-test.h~mm-damon-fix-a-few-spelling-mistakes-in-comments-and-a-pr_debug-message
+++ a/mm/damon/vaddr-test.h
@@ -233,7 +233,7 @@ static void damon_test_apply_three_regio
  * and 70-100) has totally freed and mapped to different area (30-32 and
  * 65-68).  The target regions which were in the old second and third big
  * regions should now be removed and new target regions covering the new second
- * and third big regions should be crated.
+ * and third big regions should be created.
  */
 static void damon_test_apply_three_regions4(struct kunit *test)
 {
_
