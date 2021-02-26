Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B43C433E9
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5984364EE4
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhBZBXq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230100AbhBZBX3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:23:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 007DF64F32;
        Fri, 26 Feb 2021 01:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302563;
        bh=x2XCohAYi0wo5uTGb0rMg1kh966aOzH6oKX/UPMclcI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fCqX+9jHeJ7MfX6p5M/UIrNTnh+SUFmofKxhe+ElUk8YQDpaNoOghXUnMKqpAl0VV
         fV1f7Z17gVO75qpDzoEmIGbfaQT7bV/+jFoOj+bI2y68hc91WlbFPLi5yl0JpSVtUp
         lkxSK85tJuxstE+el+03NhbrVW3Sc7A8p3ljWC8o=
Date:   Thu, 25 Feb 2021 17:22:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dvyukov@google.com, jpoimboe@redhat.com,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, ryabinin.a.a@gmail.com,
        sfr@canb.auug.org.au, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 116/118] ubsan: remove overflow checks
Message-ID: <20210226012242.wIqztJH53%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: ubsan: remove overflow checks

Since GCC 8.0 -fsanitize=signed-integer-overflow doesn't work with
-fwrapv.  -fwrapv makes signed overflows defines and GCC essentially
disables ubsan checks.  On GCC < 8.0 -fwrapv doesn't have influence on
-fsanitize=signed-integer-overflow setting, so it kinda works but
generates false-positves and violates uaccess rules:

lib/iov_iter.o: warning: objtool: iovec_from_user()+0x22d: call to
__ubsan_handle_add_overflow() with UACCESS enabled

Disable signed overflow checks to avoid these problems.  Remove unsigned
overflow checks as well.  Unsigned overflow appeared as side effect of
commit cdf8a76fda4a ("ubsan: move cc-option tests into Kconfig"), but it
never worked (kernel doesn't boot).  And unsigned overflows are allowed by
C standard, so it just pointless.

Link: https://lkml.kernel.org/r/20210209232348.20510-1-ryabinin.a.a@gmail.com
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan      |   17 ---------
 lib/test_ubsan.c       |   49 ----------------------------
 lib/ubsan.c            |   68 ---------------------------------------
 scripts/Makefile.ubsan |    2 -
 4 files changed, 136 deletions(-)

--- a/lib/Kconfig.ubsan~ubsan-remove-overflow-checks
+++ a/lib/Kconfig.ubsan
@@ -112,23 +112,6 @@ config UBSAN_UNREACHABLE
 	  This option enables -fsanitize=unreachable which checks for control
 	  flow reaching an expected-to-be-unreachable position.
 
-config UBSAN_SIGNED_OVERFLOW
-	bool "Perform checking for signed arithmetic overflow"
-	default UBSAN
-	depends on $(cc-option,-fsanitize=signed-integer-overflow)
-	help
-	  This option enables -fsanitize=signed-integer-overflow which checks
-	  for overflow of any arithmetic operations with signed integers.
-
-config UBSAN_UNSIGNED_OVERFLOW
-	bool "Perform checking for unsigned arithmetic overflow"
-	depends on $(cc-option,-fsanitize=unsigned-integer-overflow)
-	depends on !X86_32 # avoid excessive stack usage on x86-32/clang
-	help
-	  This option enables -fsanitize=unsigned-integer-overflow which checks
-	  for overflow of any arithmetic operations with unsigned integers. This
-	  currently causes x86 to fail to boot.
-
 config UBSAN_OBJECT_SIZE
 	bool "Perform checking for accesses beyond the end of objects"
 	default UBSAN
--- a/lib/test_ubsan.c~ubsan-remove-overflow-checks
+++ a/lib/test_ubsan.c
@@ -11,51 +11,6 @@ typedef void(*test_ubsan_fp)(void);
 			#config, IS_ENABLED(config) ? "y" : "n");	\
 	} while (0)
 
-static void test_ubsan_add_overflow(void)
-{
-	volatile int val = INT_MAX;
-	volatile unsigned int uval = UINT_MAX;
-
-	UBSAN_TEST(CONFIG_UBSAN_SIGNED_OVERFLOW);
-	val += 2;
-
-	UBSAN_TEST(CONFIG_UBSAN_UNSIGNED_OVERFLOW);
-	uval += 2;
-}
-
-static void test_ubsan_sub_overflow(void)
-{
-	volatile int val = INT_MIN;
-	volatile unsigned int uval = 0;
-	volatile int val2 = 2;
-
-	UBSAN_TEST(CONFIG_UBSAN_SIGNED_OVERFLOW);
-	val -= val2;
-
-	UBSAN_TEST(CONFIG_UBSAN_UNSIGNED_OVERFLOW);
-	uval -= val2;
-}
-
-static void test_ubsan_mul_overflow(void)
-{
-	volatile int val = INT_MAX / 2;
-	volatile unsigned int uval = UINT_MAX / 2;
-
-	UBSAN_TEST(CONFIG_UBSAN_SIGNED_OVERFLOW);
-	val *= 3;
-
-	UBSAN_TEST(CONFIG_UBSAN_UNSIGNED_OVERFLOW);
-	uval *= 3;
-}
-
-static void test_ubsan_negate_overflow(void)
-{
-	volatile int val = INT_MIN;
-
-	UBSAN_TEST(CONFIG_UBSAN_SIGNED_OVERFLOW);
-	val = -val;
-}
-
 static void test_ubsan_divrem_overflow(void)
 {
 	volatile int val = 16;
@@ -155,10 +110,6 @@ static void test_ubsan_object_size_misma
 }
 
 static const test_ubsan_fp test_ubsan_array[] = {
-	test_ubsan_add_overflow,
-	test_ubsan_sub_overflow,
-	test_ubsan_mul_overflow,
-	test_ubsan_negate_overflow,
 	test_ubsan_shift_out_of_bounds,
 	test_ubsan_out_of_bounds,
 	test_ubsan_load_invalid_value,
--- a/lib/ubsan.c~ubsan-remove-overflow-checks
+++ a/lib/ubsan.c
@@ -163,74 +163,6 @@ static void ubsan_epilogue(void)
 	}
 }
 
-static void handle_overflow(struct overflow_data *data, void *lhs,
-			void *rhs, char op)
-{
-
-	struct type_descriptor *type = data->type;
-	char lhs_val_str[VALUE_LENGTH];
-	char rhs_val_str[VALUE_LENGTH];
-
-	if (suppress_report(&data->location))
-		return;
-
-	ubsan_prologue(&data->location, type_is_signed(type) ?
-			"signed-integer-overflow" :
-			"unsigned-integer-overflow");
-
-	val_to_string(lhs_val_str, sizeof(lhs_val_str), type, lhs);
-	val_to_string(rhs_val_str, sizeof(rhs_val_str), type, rhs);
-	pr_err("%s %c %s cannot be represented in type %s\n",
-		lhs_val_str,
-		op,
-		rhs_val_str,
-		type->type_name);
-
-	ubsan_epilogue();
-}
-
-void __ubsan_handle_add_overflow(void *data,
-				void *lhs, void *rhs)
-{
-
-	handle_overflow(data, lhs, rhs, '+');
-}
-EXPORT_SYMBOL(__ubsan_handle_add_overflow);
-
-void __ubsan_handle_sub_overflow(void *data,
-				void *lhs, void *rhs)
-{
-	handle_overflow(data, lhs, rhs, '-');
-}
-EXPORT_SYMBOL(__ubsan_handle_sub_overflow);
-
-void __ubsan_handle_mul_overflow(void *data,
-				void *lhs, void *rhs)
-{
-	handle_overflow(data, lhs, rhs, '*');
-}
-EXPORT_SYMBOL(__ubsan_handle_mul_overflow);
-
-void __ubsan_handle_negate_overflow(void *_data, void *old_val)
-{
-	struct overflow_data *data = _data;
-	char old_val_str[VALUE_LENGTH];
-
-	if (suppress_report(&data->location))
-		return;
-
-	ubsan_prologue(&data->location, "negation-overflow");
-
-	val_to_string(old_val_str, sizeof(old_val_str), data->type, old_val);
-
-	pr_err("negation of %s cannot be represented in type %s:\n",
-		old_val_str, data->type->type_name);
-
-	ubsan_epilogue();
-}
-EXPORT_SYMBOL(__ubsan_handle_negate_overflow);
-
-
 void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs)
 {
 	struct overflow_data *data = _data;
--- a/scripts/Makefile.ubsan~ubsan-remove-overflow-checks
+++ a/scripts/Makefile.ubsan
@@ -8,8 +8,6 @@ ubsan-cflags-$(CONFIG_UBSAN_LOCAL_BOUNDS
 ubsan-cflags-$(CONFIG_UBSAN_SHIFT)		+= -fsanitize=shift
 ubsan-cflags-$(CONFIG_UBSAN_DIV_ZERO)		+= -fsanitize=integer-divide-by-zero
 ubsan-cflags-$(CONFIG_UBSAN_UNREACHABLE)	+= -fsanitize=unreachable
-ubsan-cflags-$(CONFIG_UBSAN_SIGNED_OVERFLOW)	+= -fsanitize=signed-integer-overflow
-ubsan-cflags-$(CONFIG_UBSAN_UNSIGNED_OVERFLOW)	+= -fsanitize=unsigned-integer-overflow
 ubsan-cflags-$(CONFIG_UBSAN_OBJECT_SIZE)	+= -fsanitize=object-size
 ubsan-cflags-$(CONFIG_UBSAN_BOOL)		+= -fsanitize=bool
 ubsan-cflags-$(CONFIG_UBSAN_ENUM)		+= -fsanitize=enum
_
