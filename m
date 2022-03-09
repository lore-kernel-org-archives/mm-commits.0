Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9F5C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  9 Mar 2022 21:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiCIVg0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Mar 2022 16:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiCIVg0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2022 16:36:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D484EF9FB8
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 13:35:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 885B4B82234
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 21:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E5AC340E8;
        Wed,  9 Mar 2022 21:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646861724;
        bh=OOMg/8dtd4GqFCJg5vBBzTdRcvama8J0N/M/XbCz9+o=;
        h=Date:To:From:Subject:From;
        b=jtN/VfJW+CoMc8hRd4bf1GSYzyHrcdyWq9CvwThVXy9PNBmiibs16PN19xjZDWYr2
         PTKOp9fgFyjOYOWIf7BE93abiBPF2OAY56oP5XyhlejiJIHmduUE3z0/Eadax9cwHD
         +egg6EmF1mW7vPEX+nMgqbsOEqBhN2G7ysNavLlE=
Date:   Wed, 09 Mar 2022 13:35:23 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        dlatypov@google.com, davidgow@google.com,
        brendanhiggins@google.com, liupeng256@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-make-kunit_test_timeout-compatible-with-comment.patch added to -mm tree
Message-Id: <20220309213524.15E5AC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kunit: make kunit_test_timeout compatible with comment
has been added to the -mm tree.  Its filename is
     kunit-make-kunit_test_timeout-compatible-with-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kunit-make-kunit_test_timeout-compatible-with-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kunit-make-kunit_test_timeout-compatible-with-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Brendan Higgins <brendanhiggins@google.com>
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

kunit-fix-uaf-when-run-kfence-test-case-test_gfpzero.patch
kunit-make-kunit_test_timeout-compatible-with-comment.patch
kfence-test-try-to-avoid-test_gfpzero-trigger-rcu_stall.patch

