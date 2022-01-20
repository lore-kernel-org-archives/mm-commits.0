Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06C9C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbiATCKj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbiATCKj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:10:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F42C061574
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 18:10:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89ED8B81C9F
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA198C004E1;
        Thu, 20 Jan 2022 02:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644636;
        bh=XqWxMBXH0Ssbjg1TCcV3idPXLq2m13f/Pz9hdIr+VKc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tTbm/hKNrxFTMg0NlKNdVA2p1sTTM7kHVy/b6ZRAePLVBCsPVza7Y0qZxPorVINR4
         wYp3JQRF082hYP7S652QsuupLpo39rZJhBuUGUZHyGk8qZwtzlmLxzJ3NEtQD/QK34
         Zpvj6fpZy9SJsPzQaFA2KF/ZCkRJvBfFy+wUp4JA=
Date:   Wed, 19 Jan 2022 18:10:35 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, elver@google.com,
        keescook@chromium.org, linux-mm@kvack.org, masahiroy@kernel.org,
        michal.lkml@markovi.net, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, peterz@infradead.org,
        ryabinin.a.a@gmail.com, sfr@canb.auug.org.au,
        torvalds@linux-foundation.org
Subject:  [patch 54/55] ubsan: remove CONFIG_UBSAN_OBJECT_SIZE
Message-ID: <20220120021035.XOdxBsioR%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: ubsan: remove CONFIG_UBSAN_OBJECT_SIZE

The object-size sanitizer is redundant to -Warray-bounds, and
inappropriately performs its checks at run-time when all information
needed for the evaluation is available at compile-time, making it quite
difficult to use:

https://bugzilla.kernel.org/show_bug.cgi?id=214861

With -Warray-bounds almost enabled globally, it doesn't make sense to keep
this around.

Link: https://lkml.kernel.org/r/20211203235346.110809-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan      |   13 -------------
 lib/test_ubsan.c       |   22 ----------------------
 scripts/Makefile.ubsan |    1 -
 3 files changed, 36 deletions(-)

--- a/lib/Kconfig.ubsan~ubsan-remove-config_ubsan_object_size
+++ a/lib/Kconfig.ubsan
@@ -112,19 +112,6 @@ config UBSAN_UNREACHABLE
 	  This option enables -fsanitize=unreachable which checks for control
 	  flow reaching an expected-to-be-unreachable position.
 
-config UBSAN_OBJECT_SIZE
-	bool "Perform checking for accesses beyond the end of objects"
-	default UBSAN
-	# gcc hugely expands stack usage with -fsanitize=object-size
-	# https://lore.kernel.org/lkml/CAHk-=wjPasyJrDuwDnpHJS2TuQfExwe=px-SzLeN8GFMAQJPmQ@mail.gmail.com/
-	depends on !CC_IS_GCC
-	depends on $(cc-option,-fsanitize=object-size)
-	help
-	  This option enables -fsanitize=object-size which checks for accesses
-	  beyond the end of objects where the optimizer can determine both the
-	  object being operated on and its size, usually seen with bad downcasts,
-	  or access to struct members from NULL pointers.
-
 config UBSAN_BOOL
 	bool "Perform checking for non-boolean values used as boolean"
 	default UBSAN
--- a/lib/test_ubsan.c~ubsan-remove-config_ubsan_object_size
+++ a/lib/test_ubsan.c
@@ -79,15 +79,6 @@ static void test_ubsan_load_invalid_valu
 	eval2 = eval;
 }
 
-static void test_ubsan_null_ptr_deref(void)
-{
-	volatile int *ptr = NULL;
-	int val;
-
-	UBSAN_TEST(CONFIG_UBSAN_OBJECT_SIZE);
-	val = *ptr;
-}
-
 static void test_ubsan_misaligned_access(void)
 {
 	volatile char arr[5] __aligned(4) = {1, 2, 3, 4, 5};
@@ -98,29 +89,16 @@ static void test_ubsan_misaligned_access
 	*ptr = val;
 }
 
-static void test_ubsan_object_size_mismatch(void)
-{
-	/* "((aligned(8)))" helps this not into be misaligned for ptr-access. */
-	volatile int val __aligned(8) = 4;
-	volatile long long *ptr, val2;
-
-	UBSAN_TEST(CONFIG_UBSAN_OBJECT_SIZE);
-	ptr = (long long *)&val;
-	val2 = *ptr;
-}
-
 static const test_ubsan_fp test_ubsan_array[] = {
 	test_ubsan_shift_out_of_bounds,
 	test_ubsan_out_of_bounds,
 	test_ubsan_load_invalid_value,
 	test_ubsan_misaligned_access,
-	test_ubsan_object_size_mismatch,
 };
 
 /* Excluded because they Oops the module. */
 static const test_ubsan_fp skip_ubsan_array[] = {
 	test_ubsan_divrem_overflow,
-	test_ubsan_null_ptr_deref,
 };
 
 static int __init test_ubsan_init(void)
--- a/scripts/Makefile.ubsan~ubsan-remove-config_ubsan_object_size
+++ a/scripts/Makefile.ubsan
@@ -8,7 +8,6 @@ ubsan-cflags-$(CONFIG_UBSAN_LOCAL_BOUNDS
 ubsan-cflags-$(CONFIG_UBSAN_SHIFT)		+= -fsanitize=shift
 ubsan-cflags-$(CONFIG_UBSAN_DIV_ZERO)		+= -fsanitize=integer-divide-by-zero
 ubsan-cflags-$(CONFIG_UBSAN_UNREACHABLE)	+= -fsanitize=unreachable
-ubsan-cflags-$(CONFIG_UBSAN_OBJECT_SIZE)	+= -fsanitize=object-size
 ubsan-cflags-$(CONFIG_UBSAN_BOOL)		+= -fsanitize=bool
 ubsan-cflags-$(CONFIG_UBSAN_ENUM)		+= -fsanitize=enum
 ubsan-cflags-$(CONFIG_UBSAN_TRAP)		+= -fsanitize-undefined-trap-on-error
_
