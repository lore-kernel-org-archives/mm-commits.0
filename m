Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4ED8C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 19:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 861716108F
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 19:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhJ1TXs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 15:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231246AbhJ1TXs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 15:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05A7960F58;
        Thu, 28 Oct 2021 19:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635448881;
        bh=hif40PZGr7hrOv0hp1954QZ+E8ABPkl1y5pRHQJPUV4=;
        h=Date:From:To:Subject:From;
        b=JTh07B+DcdbnQkit+iG/XEZqy5CrfVdd7f5YsrkfITvXHBQH4MhelJTsppTLXXgG/
         AMM5Dml2xHpOHOwV7vpHVI5eqZ+tTvDl3mjIDxCapsyPFXWYUT2Nzlo+iTWurVmvQC
         2Fb/wOrM5+zOBn+ijFxHBvzLihGttQ8fdDtubfyw=
Date:   Thu, 28 Oct 2021 12:21:20 -0700
From:   akpm@linux-foundation.org
To:     colin.i.king@gmail.com, colin.i.king@googlemail.com,
        mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 =?US-ASCII?Q?mm-damon-fix-a-few-spelling-mistakes-in-comments-and-a-pr?=
 =?US-ASCII?Q?=5Fdebug-message.patch?= added to -mm tree
Message-ID: <20211028192120.Y8ehMFe8y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: fix a few spelling mistakes in comments and a pr_debug message
has been added to the -mm tree.  Its filename is
     mm-damon-fix-a-few-spelling-mistakes-in-comments-and-a-pr_debug-message.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-fix-a-few-spelling-mistakes-in-comments-and-a-pr_debug-message.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-fix-a-few-spelling-mistakes-in-comments-and-a-pr_debug-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-damon-fix-a-few-spelling-mistakes-in-comments-and-a-pr_debug-message.patch

