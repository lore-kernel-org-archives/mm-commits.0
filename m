Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B36C2B9F2
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9FE86052B
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhEWAnf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 20:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231451AbhEWAnf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 20:43:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9616B6100A;
        Sun, 23 May 2021 00:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621730528;
        bh=oiH/oCciZJpvD6natzZOOVKats8b40WeXt7u2e+Jhp0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VRX/J+gh5+Dnpz6a6ieserALjsfkm7OTxpAluk/iC364IEkHJu17ojZ5YnUwezQPq
         xEyrMh8dHhJKlgEIh3talo0Q420ZTuKGmlhgzCLVvj1+SAO2G5X/CJi8Lota9t7KSx
         HEvnDI9ucivQ69x8Rs//YGkNdCwPk70v0L1lmsb4=
Date:   Sat, 22 May 2021 17:42:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        thunder.leizhen@huawei.com, torvalds@linux-foundation.org,
        vitor@massaru.org
Subject:  [patch 09/10] lib: kunit: suppress a compilation warning
 of frame size
Message-ID: <20210523004208.OFbVcUevF%akpm@linux-foundation.org>
In-Reply-To: <20210522174113.47fd4c853c0a1470c57deefa@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: lib: kunit: suppress a compilation warning of frame size

lib/bitfield_kunit.c: In function `test_bitfields_constants':
lib/bitfield_kunit.c:93:1: warning: the frame size of 7456 bytes is larger than 2048 bytes [-Wframe-larger-than=]
 }
 ^

As the description of BITFIELD_KUNIT in lib/Kconfig.debug, it "Only useful
for kernel devs running the KUnit test harness, and not intended for
inclusion into a production build".  Therefore, it is not worth modifying
variable 'test_bitfields_constants' to clear this warning.  Just suppress
it.

Link: https://lkml.kernel.org/r/20210518094533.7652-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vitor Massaru Iha <vitor@massaru.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Makefile~lib-kunit-suppress-a-compilation-warning-of-frame-size
+++ a/lib/Makefile
@@ -348,6 +348,7 @@ obj-$(CONFIG_OBJAGG) += objagg.o
 obj-$(CONFIG_PLDMFW) += pldmfw/
 
 # KUnit tests
+CFLAGS_bitfield_kunit.o := $(call cc-option,-Wframe-larger-than=10240)
 obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
 obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
_
