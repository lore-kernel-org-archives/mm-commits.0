Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6669C433E2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 01:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 856AC21973
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 01:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600219451;
	bh=FBm0GtUlsJgbI6TstO0MxwJ042gcSn/xkSN5K43W+OY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=NYYZp8R5aMV4/gTKcAe5RBY5kLJgjcKF2RTKTnUlCw+msTxELrME+srwH4aIUm/vX
	 zARO+VxJUJXV0QW9Qau0krPDDqEF3mlOGS86AykN75CK4eBEDChNwXAv03vAWfzaOa
	 DB5+1l+6w98RWHAFWeUtxtLFOHVrSRpluZGAb2Zs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgIPBYL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 21:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgIPBYL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 21:24:11 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30266208E4;
        Wed, 16 Sep 2020 01:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600219450;
        bh=FBm0GtUlsJgbI6TstO0MxwJ042gcSn/xkSN5K43W+OY=;
        h=Date:From:To:Subject:From;
        b=P5cOwRHNGWdUtcvazZcEJVvfmFcV8gmzsxX2F2PQW/rsBA6m940zVKmNWhBSTDtes
         z+2FSr3gzzaCcUWez2YblxYvCEdMwGvLdJYo3XpPA1NBsC6i3EGdVN/Y8hTGsGENlf
         AfXrOSxQGATTqHukqbeYNFBUyv7auUwpngYQV6Zg=
Date:   Tue, 15 Sep 2020 18:24:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, dvyukov@google.com,
        davidgow@google.com, brendanhiggins@google.com,
        andreyknvl@google.com, trishalfonso@google.com
Subject:  + kasan-port-kasan-tests-to-kunit-v14.patch added to -mm
 tree
Message-ID: <20200916012409.tSFAd%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-port-kasan-tests-to-kunit-v14
has been added to the -mm tree.  Its filename is
     kasan-port-kasan-tests-to-kunit-v14.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-port-kasan-tests-to-kunit-v14.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-port-kasan-tests-to-kunit-v14.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
kasan-port-kasan-tests-to-kunit-v14.patch
kasan-testing-documentation.patch

