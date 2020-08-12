Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AADC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D90D206F2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597194279;
	bh=60pY5s6Luvd+ddBx1peDJBQgn4lPlFDZ3v8URK/op3M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=X9T5dO/TyM2IXsVnJJhYaQ+uCMOUm0Of51F7U5HfsTFRH7zLDysHikMLeqT815y+S
	 /RCiPIR7n97jwgQTmCnysxFlaKQbs8vrqPXoJhmLqWncqbH+J2AWRZ9TjP0agtqPbM
	 H96oEVXyTL4fHizHmXw4H3ChHhi4W5M+E2M9BHqE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgHLBEi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBEi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:04:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CF2B206B5;
        Wed, 12 Aug 2020 01:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597194276;
        bh=60pY5s6Luvd+ddBx1peDJBQgn4lPlFDZ3v8URK/op3M=;
        h=Date:From:To:Subject:From;
        b=YWoA43mtQgJYhoyh+ydFUSNyl8ks1YYdgfw09BiZhlGewCeAvEk1FGZfIL64jbf9k
         eH8m1NGxzxVw1nHbrmO7sNdQ4WJViYH7fIikT+iOdy6zIGVWiFaMp8Oh85En9Nv/IW
         UZtz2HFSmjeWmbSgzW6Lb8uylJsjpnFDdJJLVS0o=
Date:   Tue, 11 Aug 2020 18:04:36 -0700
From:   akpm@linux-foundation.org
To:     hulkci@huawei.com, mm-commits@vger.kernel.org,
        rikard.falkeborn@gmail.com, weiyongjun1@huawei.com
Subject:  [folded-merged] bits-add-tests-of-genmask-fix-2.patch
 removed from -mm tree
Message-ID: <20200812010436.d4sIxUgfh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_bits: make some functions static
has been removed from the -mm tree.  Its filename was
     bits-add-tests-of-genmask-fix-2.patch

This patch was dropped because it was folded into bits-add-tests-of-genmask.patch

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: lib/test_bits: make some functions static

Fix sparse build warnings:

lib/test_bits.c:10:6: warning:
 symbol 'genmask_test' was not declared. Should it be static?
lib/test_bits.c:27:6: warning:
 symbol 'genmask_ull_test' was not declared. Should it be static?
lib/test_bits.c:42:6: warning:
 symbol 'genmask_input_check_test' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20200702150336.4756-1-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bits.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/test_bits.c~bits-add-tests-of-genmask-fix-2
+++ a/lib/test_bits.c
@@ -7,7 +7,7 @@
 #include <linux/bits.h>
 
 
-void genmask_test(struct kunit *test)
+static void genmask_test(struct kunit *test)
 {
 	KUNIT_EXPECT_EQ(test, 1ul, GENMASK(0, 0));
 	KUNIT_EXPECT_EQ(test, 3ul, GENMASK(1, 0));
@@ -24,7 +24,7 @@ void genmask_test(struct kunit *test)
 
 }
 
-void genmask_ull_test(struct kunit *test)
+static void genmask_ull_test(struct kunit *test)
 {
 	KUNIT_EXPECT_EQ(test, 1ull, GENMASK_ULL(0, 0));
 	KUNIT_EXPECT_EQ(test, 3ull, GENMASK_ULL(1, 0));
@@ -39,7 +39,7 @@ void genmask_ull_test(struct kunit *test
 #endif
 }
 
-void genmask_input_check_test(struct kunit *test)
+static void genmask_input_check_test(struct kunit *test)
 {
 	unsigned int x, y;
 	int z, w;
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are

lib-test_lockupc-make-symbol-test_works-static.patch
bits-add-tests-of-genmask.patch
kcov-make-some-symbols-static.patch

