Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11120C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F23ED61108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhKKCxd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234655AbhKKCx1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79F1460F26;
        Thu, 11 Nov 2021 02:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599039;
        bh=Zw/58lWTqykB1qdP6+kawhBPYJSi6f4fNubX14JjMG0=;
        h=Date:From:To:Subject:From;
        b=lsZzcjVSjM3dybe7VwxavTKeYd7Nn2G8Kyi9es5k1Tfupoj9tXhtcYqaHr4mLflTu
         MS3pcBMLSM5sBkMLyyVe7McOTzOuYd47evfD9DRI4Yx0vJ7fZwadXFqr9Ep9P8NU7q
         LYjP0O1kn9L7nnyL4aQFTsSKtSFlQvz6RpfJC1Tw=
Date:   Wed, 10 Nov 2021 18:50:39 -0800
From:   akpm@linux-foundation.org
To:     colin.i.king@gmail.com, colin.i.king@googlemail.com,
        mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-damon-fix-a-few-spelling-mistakes-in-comments-and-a-pr?=
 =?US-ASCII?Q?=5Fdebug-message.patch?= removed from -mm tree
Message-ID: <20211111025039.OAPSpLb2J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: fix a few spelling mistakes in comments and a pr_debug message
has been removed from the -mm tree.  Its filename was
     mm-damon-fix-a-few-spelling-mistakes-in-comments-and-a-pr_debug-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from colin.i.king@googlemail.com are


