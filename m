Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D77C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63E2A64F1A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbhBYT1V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:27:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233591AbhBYTZe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C500A64F7F;
        Thu, 25 Feb 2021 19:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280537;
        bh=OHquS9LCM51oW9i/IILPVBptEiOwcaRdOoWT3ciLuK0=;
        h=Date:From:To:Subject:From;
        b=Rm7owEEtKskxpB6d2qZe08xPRyz+dPZc6whoA9V49Vb8ntvTjSnhcGCK4yzUCEUkE
         Ueuj497TYR/CcTv8kR2t0dWDtzaGR/tWu3ZAP2hXuraskSNT7bHI3vxxoNQ/iBEEpP
         +AN04QQv7UVTLQtiTZNG/OqCXqoAcDQAc8H5crqM=
Date:   Thu, 25 Feb 2021 11:15:36 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged] kasan-rename-config_test_kasan_module.patch
 removed from -mm tree
Message-ID: <20210225191536.qZee_PJHw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rename CONFIG_TEST_KASAN_MODULE
has been removed from the -mm tree.  Its filename was
     kasan-rename-config_test_kasan_module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: rename CONFIG_TEST_KASAN_MODULE

Rename CONFIG_TEST_KASAN_MODULE to CONFIG_KASAN_MODULE_TEST.

This naming is more consistent with the existing CONFIG_KASAN_KUNIT_TEST.

Link: https://linux-review.googlesource.com/id/Id347dfa5fe8788b7a1a189863e039f409da0ae5f
Link: https://lkml.kernel.org/r/f08250246683981bcf8a094fbba7c361995624d2.1610733117.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    8 ++++----
 lib/Kconfig.kasan                 |    2 +-
 lib/Makefile                      |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-rename-config_test_kasan_module
+++ a/Documentation/dev-tools/kasan.rst
@@ -358,17 +358,17 @@ unmapped. This will require changes in a
 This allows ``VMAP_STACK`` support on x86, and can simplify support of
 architectures that do not have a fixed module region.
 
-CONFIG_KASAN_KUNIT_TEST & CONFIG_TEST_KASAN_MODULE
---------------------------------------------------
+CONFIG_KASAN_KUNIT_TEST and CONFIG_KASAN_MODULE_TEST
+----------------------------------------------------
 
-KASAN tests consist on two parts:
+KASAN tests consist of two parts:
 
 1. Tests that are integrated with the KUnit Test Framework. Enabled with
 ``CONFIG_KASAN_KUNIT_TEST``. These tests can be run and partially verified
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
@@ -66,7 +66,7 @@ obj-$(CONFIG_TEST_IDA) += test_ida.o
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

kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-fail-krealloc-on-freed-objects.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-inline-hw_tags-helper-functions.patch
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

