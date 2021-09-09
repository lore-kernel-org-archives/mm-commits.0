Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80138C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D698611C4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348443AbhIIVEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347563AbhIIVDn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:03:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78C9F611CA;
        Thu,  9 Sep 2021 21:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221346;
        bh=85wTXEwHhgPYBAchTM7rl1QyjvAfBlCBooOF6HZgiyw=;
        h=Date:From:To:Subject:From;
        b=vwTMh9YysiueG9BTKHWYkyWNqepHCl6uDQNfivMMw+8qfWq6G6T+V4MxRfIhXN9BS
         /CqMd8xicqOFPIX3prqdE6unrZdltzALtRKIO0lngqxcYvUY/dIjhfd2lAupktx448
         1h+x1+0ZrsgxEQ6dhltrBB25J7gy5etQpBuIemyU=
Date:   Thu, 09 Sep 2021 14:02:26 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com
Subject:  [merged] kfence-test-fail-fast-if-disabled-at-boot.patch
 removed from -mm tree
Message-ID: <20210909210226.6EHnRTTrZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: test: fail fast if disabled at boot
has been removed from the -mm tree.  Its filename was
     kfence-test-fail-fast-if-disabled-at-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: test: fail fast if disabled at boot

Fail kfence_test fast if KFENCE was disabled at boot, instead of each test
case trying several seconds to allocate from KFENCE and failing.  KUnit
will fail all test cases if kunit_suite::init returns an error.

Even if KFENCE was disabled, we still want the test to fail, so that CI
systems that parse KUnit output will alert on KFENCE being disabled
(accidentally or otherwise).

Link: https://lkml.kernel.org/r/20210825105533.1247922-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/kfence/kfence_test.c~kfence-test-fail-fast-if-disabled-at-boot
+++ a/mm/kfence/kfence_test.c
@@ -789,6 +789,9 @@ static int test_init(struct kunit *test)
 	unsigned long flags;
 	int i;
 
+	if (!__kfence_pool)
+		return -EINVAL;
+
 	spin_lock_irqsave(&observed.lock, flags);
 	for (i = 0; i < ARRAY_SIZE(observed.lines); i++)
 		observed.lines[i][0] = '\0';
_

Patches currently in -mm which might be from elver@google.com are


