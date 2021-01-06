Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59497C433DB
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 00:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16AD822E03
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 00:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbhAFAMW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Jan 2021 19:12:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbhAFAMW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Jan 2021 19:12:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11016230FA;
        Wed,  6 Jan 2021 00:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609891871;
        bh=ycndDSsTDfODjvwtoWoE0mKMMPMMPBnLSR+KBK/isEc=;
        h=Date:From:To:Subject:From;
        b=Yh3BLcmd9dHzceYfNr+SqxCiPkDY0X1LMh1ZrzZCDwbW3eDTpA6e8OmJiM/5NzE5V
         1WpknhuDqTzLChbfaYJ/Wr51wxBs74Jh334PP7KLHLQouyJPLgqO5uCh166g5nFbeL
         V31e/7xog1swQ/lMbRgbldNeJFyzJBJvzHJuW23A=
Date:   Tue, 05 Jan 2021 16:11:10 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + kasan-rename-config_test_kasan_module.patch added to
 -mm tree
Message-ID: <20210106001110.9HrQFJ8ZZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rename CONFIG_TEST_KASAN_MODULE
has been added to the -mm tree.  Its filename is
     kasan-rename-config_test_kasan_module.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-rename-config_test_kasan_module.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-rename-config_test_kasan_module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: rename CONFIG_TEST_KASAN_MODULE

Rename CONFIG_TEST_KASAN_MODULE to CONFIG_KASAN_MODULE_TEST.

This naming is more consistent with the existing CONFIG_KASAN_KUNIT_TEST.

Link: https://lkml.kernel.org/r/ae666d8946f586cfc250205cea4ae0b729d818fa.1609871239.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Id347dfa5fe8788b7a1a189863e039f409da0ae5fSigned-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    6 +++---
 lib/Kconfig.kasan                 |    2 +-
 lib/Makefile                      |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-rename-config_test_kasan_module
+++ a/Documentation/dev-tools/kasan.rst
@@ -374,8 +374,8 @@ unmapped. This will require changes in a
 This allows ``VMAP_STACK`` support on x86, and can simplify support of
 architectures that do not have a fixed module region.
 
-CONFIG_KASAN_KUNIT_TEST & CONFIG_TEST_KASAN_MODULE
---------------------------------------------------
+CONFIG_KASAN_KUNIT_TEST and CONFIG_KASAN_MODULE_TEST
+----------------------------------------------------
 
 KASAN tests consist on two parts:
 
@@ -384,7 +384,7 @@ KASAN tests consist on two parts:
 automatically in a few different ways, see the instructions below.
 
 2. Tests that are currently incompatible with KUnit. Enabled with
-``CONFIG_TEST_KASAN_MODULE`` and can only be run as a module. These tests can
+``CONFIG_KASAN_MODULE_TEST`` and can only be run as a module. These tests can
 only be verified manually, by loading the kernel module and inspecting the
 kernel log for KASAN reports.
 
--- a/lib/Kconfig.kasan~kasan-rename-config_test_kasan_module
+++ a/lib/Kconfig.kasan
@@ -192,7 +192,7 @@ config KASAN_KUNIT_TEST
 	  For more information on KUnit and unit tests in general, please refer
 	  to the KUnit documentation in Documentation/dev-tools/kunit.
 
-config TEST_KASAN_MODULE
+config KASAN_MODULE_TEST
 	tristate "KUnit-incompatible tests of KASAN bug detection capabilities"
 	depends on m && KASAN && !KASAN_HW_TAGS
 	help
--- a/lib/Makefile~kasan-rename-config_test_kasan_module
+++ a/lib/Makefile
@@ -68,7 +68,7 @@ obj-$(CONFIG_TEST_IDA) += test_ida.o
 obj-$(CONFIG_KASAN_KUNIT_TEST) += test_kasan.o
 CFLAGS_test_kasan.o += -fno-builtin
 CFLAGS_test_kasan.o += $(call cc-disable-warning, vla)
-obj-$(CONFIG_TEST_KASAN_MODULE) += test_kasan_module.o
+obj-$(CONFIG_KASAN_MODULE_TEST) += test_kasan_module.o
 CFLAGS_test_kasan_module.o += -fno-builtin
 obj-$(CONFIG_TEST_UBSAN) += test_ubsan.o
 CFLAGS_test_ubsan.o += $(call cc-disable-warning, vla)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-prefix-exported-functions-with-kasan_.patch
kasan-clarify-hw_tags-impact-on-tbi.patch
kasan-clean-up-comments-in-tests.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adopt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch

