Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3618DC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18C1D6113E
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243156AbhIHC5k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347371AbhIHC5c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA04460E52;
        Wed,  8 Sep 2021 02:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069785;
        bh=LMVrL4u1pgI7/dU2FOoPOkpT2G7rhs/QDIntrBaSiks=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s4wwewtSVduP6Un55xSzUfmyE39TTBL0VKCEgqG43Gufbdu4rG//33DxLarMjLVUb
         IMXl9RCPvn0tuc0awG0BvoS+rSYoDMpXKZIh+4QeutLvfBv1YVYSP+qyU1popkPoRX
         uyTrccxd3/m7t7dSFemabsl8vBmHRnihy9YPlDrM=
Date:   Tue, 07 Sep 2021 19:56:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, wangkefeng.wang@huawei.com
Subject:  [patch 062/147] kfence: test: fail fast if disabled at
 boot
Message-ID: <20210908025624.GleAmQ9nK%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
