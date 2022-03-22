Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C83FC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236683AbiCVVt7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236791AbiCVVts (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:49:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3450D5FEB
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAE5D61662
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E539C340EE;
        Tue, 22 Mar 2022 21:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985700;
        bh=PTY5AQR0Uv4zkrNMjuB72K6AdNno877uzvOUdRK72r8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=YvRIVBtrFKPNv6lR2NDtOLLO8TpAgI73EEU34kkodSQOtq42UDmcr0KnIxnthq57N
         We+U4riAf3MBL+amxmwmgFimpq4Og8Sb7/TCed45zaO1AoJxLzjxeSWRzE/yy8OFXD
         EMUC6D9kZRJh7mzgJtM1wj7WZCCHJKJkcbc709fM=
Date:   Tue, 22 Mar 2022 14:48:19 -0700
To:     wangkefeng.wang@huawei.com, glider@google.com, elver@google.com,
        dvyukov@google.com, dlatypov@google.com, davidgow@google.com,
        brendanhiggins@google.com, liupeng256@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 193/227] kunit: make kunit_test_timeout compatible with comment
Message-Id: <20220322214820.1E539C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
