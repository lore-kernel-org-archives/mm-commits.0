Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C13C432BE
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A34610C9
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhHaWy7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 18:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230400AbhHaWy7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 18:54:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B56326108B;
        Tue, 31 Aug 2021 22:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630450443;
        bh=tGCg4yl7LPcJwNyAWgiey+fv6/ihuPcU/J53YqU5b4s=;
        h=Date:From:To:Subject:From;
        b=GoTqcEOUMKNKG6GA6PHO7oAcvqp9e9QQ4AXqhBG9N6GIT4zYpLulhpGPURfqzc2lw
         5TGElpI42kcTmWFCD6vxTPiLqcaKYVIXUfYIjlkS+gWYiSlO/T9L6APt9v04Ehk0+t
         yn8ylonJaWzBwlXqX5sirWq6kA8s3AETfHC7CVCA=
Date:   Tue, 31 Aug 2021 15:54:03 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com
Subject:  + kfence-test-fail-fast-if-disabled-at-boot.patch added
 to -mm tree
Message-ID: <20210831225403.z_P7MelaJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: test: fail fast if disabled at boot
has been added to the -mm tree.  Its filename is
     kfence-test-fail-fast-if-disabled-at-boot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-test-fail-fast-if-disabled-at-boot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-test-fail-fast-if-disabled-at-boot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -800,6 +800,9 @@ static int test_init(struct kunit *test)
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

kfence-show-cpu-and-timestamp-in-alloc-free-info.patch
kfence-test-fail-fast-if-disabled-at-boot.patch

