Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94410C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5974522227
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630733;
	bh=YLSn7K2EnG90cB7RI1R5YS8hx4tAdGw2mb2TyrIRV2U=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=W0GkRC1MAtvJ6WpHGzCKvftRsjyQo16arWl4tycTBFZto5p38T/+MIsIsX5SwuOVU
	 yVh48biPp39PQ+kENz0688+706MiTy8HvvQ198sDg9okApq+j/K9KXbacLERy9A8GD
	 GVjZ0qLlvNNOjmIaw4prooCdA5yTVZhf4K4PKPS8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387573AbgJMXMM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387570AbgJMXMK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:12:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F51221D40;
        Tue, 13 Oct 2020 23:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630729;
        bh=YLSn7K2EnG90cB7RI1R5YS8hx4tAdGw2mb2TyrIRV2U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VlGkZrID3iVjnMQxZL6AeWDrnOnVHMI+AhFc1cAOuzWExAO4zNi8HRSqu4IPEiU9Y
         CCRk4/S5aIjQs0QO8QODJfCxq50bNbnT6DBAeYrwx27geUy2Le3h6VUH3eWYRLrmpb
         OivAUnOpkDvHg0och81QGAZP0zstDgqmznbLr/4k=
Date:   Tue, 13 Oct 2020 16:12:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     andreyknvl@google.com, brendanhiggins@google.com,
        davidgow@google.com, dvyukov@google.com,
        mm-commits@vger.kernel.org, trishalfonso@google.com
Subject:  [folded-merged] kasan-port-kasan-tests-to-kunit-v14.patch
 removed from -mm tree
Message-ID: <20201013231209.w2FzqNNm_%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-port-kasan-tests-to-kunit-v14
has been removed from the -mm tree.  Its filename was
     kasan-port-kasan-tests-to-kunit-v14.patch

This patch was dropped because it was folded into kasan-port-kasan-tests-to-kunit.patch

------------------------------------------------------
From: Patricia Alfonso <trishalfonso@google.com>
Subject: kasan-port-kasan-tests-to-kunit-v14

Fix some compile warnings in test_kasan_module
(https://www.spinics.net/lists/kernel/msg3660451.html)

Link: https://lkml.kernel.org/r/20200915035828.570483-4-davidgow@google.com
Signed-off-by: Patricia Alfonso <trishalfonso@google.com>
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Makefile~kasan-port-kasan-tests-to-kunit-v14
+++ a/lib/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_KASAN_KUNIT_TEST) += test_k
 CFLAGS_test_kasan.o += -fno-builtin
 CFLAGS_test_kasan.o += $(call cc-disable-warning, vla)
 obj-$(CONFIG_TEST_KASAN_MODULE) += test_kasan_module.o
+CFLAGS_test_kasan_module.o += -fno-builtin
 obj-$(CONFIG_TEST_UBSAN) += test_ubsan.o
 CFLAGS_test_ubsan.o += $(call cc-disable-warning, vla)
 UBSAN_SANITIZE_test_ubsan.o := y
_

Patches currently in -mm which might be from trishalfonso@google.com are

add-kunit-struct-to-current-task.patch
kunit-kasan-integration.patch
kasan-port-kasan-tests-to-kunit.patch
kasan-testing-documentation.patch

