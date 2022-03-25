Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE61C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357357AbiCYBgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244969AbiCYBfY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5731A32E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E44EC60AD1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B809C340ED;
        Fri, 25 Mar 2022 01:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171984;
        bh=Of6u67C04BLwws0NJWeIszpXdJLx48eqV0lAYrLVpgA=;
        h=Date:To:From:Subject:From;
        b=nT1In0nr+8oQRop1opSsQTEQmmGr7xVii0zzsMtTbze6dz/W/PY5sTFYAZcYdVldT
         F1aNVDo0+aT2gMq7OJ5SVywjalXbvsA2lbKpLc87/7Ve8zrB0qTJTln6mX28nQqKTS
         EnaqidKrVxT8Q8rSvWG4x4JcCFdoW8t4IHr2jyQQ=
Date:   Thu, 24 Mar 2022 18:33:03 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        dlatypov@google.com, davidgow@google.com,
        brendanhiggins@google.com, liupeng256@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kunit-make-kunit_test_timeout-compatible-with-comment.patch removed from -mm tree
Message-Id: <20220325013304.4B809C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kunit: make kunit_test_timeout compatible with comment
has been removed from the -mm tree.  Its filename was
     kunit-make-kunit_test_timeout-compatible-with-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peng Liu <liupeng256@huawei.com>
Subject: kunit: make kunit_test_timeout compatible with comment

In function kunit_test_timeout, it is declared "300 * MSEC_PER_SEC"
represent 5min.  However, it is wrong when dealing with arm64 whose
default HZ = 250, or some other situations.  Use msecs_to_jiffies to fix
this, and kunit_test_timeout will work as desired.

Link: https://lkml.kernel.org/r/20220309083753.1561921-3-liupeng256@huawei.com
Fixes: 5f3e06208920 ("kunit: test: add support for test abort")
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Wang Kefeng <wangkefeng.wang@huawei.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kunit/try-catch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/kunit/try-catch.c~kunit-make-kunit_test_timeout-compatible-with-comment
+++ a/lib/kunit/try-catch.c
@@ -52,7 +52,7 @@ static unsigned long kunit_test_timeout(
 	 * If tests timeout due to exceeding sysctl_hung_task_timeout_secs,
 	 * the task will be killed and an oops generated.
 	 */
-	return 300 * MSEC_PER_SEC; /* 5 min */
+	return 300 * msecs_to_jiffies(MSEC_PER_SEC); /* 5 min */
 }
 
 void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
_

Patches currently in -mm which might be from liupeng256@huawei.com are


