Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA41C433ED
	for <mm-commits@archiver.kernel.org>; Wed, 19 May 2021 00:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 658FF61353
	for <mm-commits@archiver.kernel.org>; Wed, 19 May 2021 00:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhESAhE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 20:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234097AbhESAhD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 20:37:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D07F661004;
        Wed, 19 May 2021 00:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621384545;
        bh=+OTcLeIXdXyCUPWQh7Nroosp0+8vG0H9BGoSNn+9/z4=;
        h=Date:From:To:Subject:From;
        b=h184ZhYccQmrjlmnqX0FWKEsWR6DThE0qy9IWrUG9ktFqT2py+dMCmK2L5W4qSVrb
         1J/PyaEsOcfC4Y2GGfJz4LmOfb6I8xzvsDKIVPjPt+7GqpmMKmNT5YwxWABJrBc/0N
         MkAH/VftORRNUkaLIgtu7LLHo7vyWACuaxZG+Vbs=
Date:   Tue, 18 May 2021 17:35:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        thunder.leizhen@huawei.com, vitor@massaru.org
Subject:  +
 lib-kunit-suppress-a-compilation-warning-of-frame-size.patch added to -mm
 tree
Message-ID: <20210519003544.0HX4wJnWt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: kunit: suppress a compilation warning of frame size
has been added to the -mm tree.  Its filename is
     lib-kunit-suppress-a-compilation-warning-of-frame-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-kunit-suppress-a-compilation-warning-of-frame-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-kunit-suppress-a-compilation-warning-of-frame-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

lib-kunit-suppress-a-compilation-warning-of-frame-size.patch
lib-decompress_bunzip2-remove-an-unneeded-semicolon.patch

