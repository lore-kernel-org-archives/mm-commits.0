Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C605C4361A
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 271E7224BE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387468AbgLDAFK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 19:05:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgLDAFK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 19:05:10 -0500
Date:   Thu, 03 Dec 2020 16:04:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607040250;
        bh=Wuh/AqM6DnY8xlF+nJ9thI68izJURjCG+ZfnhIZlrW4=;
        h=From:To:Subject:From;
        b=KS+R78SF+be3Y8x1UhqxGAlWUEgb51IzVVI0uWNEXokaH+UYQfEp83qXQn0Lm23xt
         zC7IqsVSNFKAf9C9O/potFW2jeYzUZTFiJVMbdhzMaOfIlExigsKmcLrOQWxI0KDkg
         57n2nvNdU7XJT/Fy/JDsQN0ZXIZ9fjMRe9ea+FDA=
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, aryabinin@virtuozzo.com,
        dvyukov@google.com, elver@google.com, georgepope@android.com,
        herbert@gondor.apana.org.au, keescook@chromium.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, oberpar@linux.ibm.com,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  + ubsan-expand-tests-and-reporting.patch added to -mm
 tree
Message-ID: <20201204000408.5fCsbGcqf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: expand tests and reporting
has been added to the -mm tree.  Its filename is
     ubsan-expand-tests-and-reporting.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ubsan-expand-tests-and-reporting.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ubsan-expand-tests-and-reporting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ubsan: expand tests and reporting

Expand the UBSAN tests to include some additional UB cases.  Notably the
out-of-bounds enum loading appears not to work.  Also include per-test
reporting, including the relevant CONFIG_UBSAN...  Kconfigs.

Link: https://lkml.kernel.org/r/20201203004437.389959-8-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: George Popescu <georgepope@android.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_ubsan.c |   74 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 66 insertions(+), 8 deletions(-)

--- a/lib/test_ubsan.c~ubsan-expand-tests-and-reporting
+++ a/lib/test_ubsan.c
@@ -5,32 +5,54 @@
 
 typedef void(*test_ubsan_fp)(void);
 
+#define UBSAN_TEST(config, ...)	do {					\
+		pr_info("%s " __VA_ARGS__ "%s(%s=%s)\n", __func__,	\
+			sizeof(" " __VA_ARGS__) > 2 ? " " : "",		\
+			#config, IS_ENABLED(config) ? "y" : "n");	\
+	} while (0)
+
 static void test_ubsan_add_overflow(void)
 {
 	volatile int val = INT_MAX;
+	volatile unsigned int uval = UINT_MAX;
 
+	UBSAN_TEST(CONFIG_UBSAN_SIGNED_OVERFLOW);
 	val += 2;
+
+	UBSAN_TEST(CONFIG_UBSAN_UNSIGNED_OVERFLOW);
+	uval += 2;
 }
 
 static void test_ubsan_sub_overflow(void)
 {
 	volatile int val = INT_MIN;
+	volatile unsigned int uval = 0;
 	volatile int val2 = 2;
 
+	UBSAN_TEST(CONFIG_UBSAN_SIGNED_OVERFLOW);
 	val -= val2;
+
+	UBSAN_TEST(CONFIG_UBSAN_UNSIGNED_OVERFLOW);
+	uval -= val2;
 }
 
 static void test_ubsan_mul_overflow(void)
 {
 	volatile int val = INT_MAX / 2;
+	volatile unsigned int uval = UINT_MAX / 2;
 
+	UBSAN_TEST(CONFIG_UBSAN_SIGNED_OVERFLOW);
 	val *= 3;
+
+	UBSAN_TEST(CONFIG_UBSAN_UNSIGNED_OVERFLOW);
+	uval *= 3;
 }
 
 static void test_ubsan_negate_overflow(void)
 {
 	volatile int val = INT_MIN;
 
+	UBSAN_TEST(CONFIG_UBSAN_SIGNED_OVERFLOW);
 	val = -val;
 }
 
@@ -39,37 +61,67 @@ static void test_ubsan_divrem_overflow(v
 	volatile int val = 16;
 	volatile int val2 = 0;
 
+	UBSAN_TEST(CONFIG_UBSAN_DIV_ZERO);
 	val /= val2;
 }
 
 static void test_ubsan_shift_out_of_bounds(void)
 {
-	volatile int val = -1;
-	int val2 = 10;
+	volatile int neg = -1, wrap = 4;
+	int val1 = 10;
+	int val2 = INT_MAX;
+
+	UBSAN_TEST(CONFIG_UBSAN_SHIFT, "negative exponent");
+	val1 <<= neg;
 
-	val2 <<= val;
+	UBSAN_TEST(CONFIG_UBSAN_SHIFT, "left overflow");
+	val2 <<= wrap;
 }
 
 static void test_ubsan_out_of_bounds(void)
 {
-	volatile int i = 4, j = 5;
+	volatile int i = 4, j = 5, k = -1;
+	volatile char above[4] = { }; /* Protect surrounding memory. */
 	volatile int arr[4];
+	volatile char below[4] = { }; /* Protect surrounding memory. */
 
+	above[0] = below[0];
+
+	UBSAN_TEST(CONFIG_UBSAN_BOUNDS, "above");
 	arr[j] = i;
+
+	UBSAN_TEST(CONFIG_UBSAN_BOUNDS, "below");
+	arr[k] = i;
 }
 
+enum ubsan_test_enum {
+	UBSAN_TEST_ZERO = 0,
+	UBSAN_TEST_ONE,
+	UBSAN_TEST_MAX,
+};
+
 static void test_ubsan_load_invalid_value(void)
 {
 	volatile char *dst, *src;
 	bool val, val2, *ptr;
-	char c = 4;
+	enum ubsan_test_enum eval, eval2, *eptr;
+	unsigned char c = 0xff;
 
+	UBSAN_TEST(CONFIG_UBSAN_BOOL, "bool");
 	dst = (char *)&val;
 	src = &c;
 	*dst = *src;
 
 	ptr = &val2;
 	val2 = val;
+
+	UBSAN_TEST(CONFIG_UBSAN_ENUM, "enum");
+	dst = (char *)&eval;
+	src = &c;
+	*dst = *src;
+
+	eptr = &eval2;
+	eval2 = eval;
 }
 
 static void test_ubsan_null_ptr_deref(void)
@@ -77,6 +129,7 @@ static void test_ubsan_null_ptr_deref(vo
 	volatile int *ptr = NULL;
 	int val;
 
+	UBSAN_TEST(CONFIG_UBSAN_OBJECT_SIZE);
 	val = *ptr;
 }
 
@@ -85,6 +138,7 @@ static void test_ubsan_misaligned_access
 	volatile char arr[5] __aligned(4) = {1, 2, 3, 4, 5};
 	volatile int *ptr, val = 6;
 
+	UBSAN_TEST(CONFIG_UBSAN_ALIGNMENT);
 	ptr = (int *)(arr + 1);
 	*ptr = val;
 }
@@ -95,6 +149,7 @@ static void test_ubsan_object_size_misma
 	volatile int val __aligned(8) = 4;
 	volatile long long *ptr, val2;
 
+	UBSAN_TEST(CONFIG_UBSAN_OBJECT_SIZE);
 	ptr = (long long *)&val;
 	val2 = *ptr;
 }
@@ -104,15 +159,19 @@ static const test_ubsan_fp test_ubsan_ar
 	test_ubsan_sub_overflow,
 	test_ubsan_mul_overflow,
 	test_ubsan_negate_overflow,
-	test_ubsan_divrem_overflow,
 	test_ubsan_shift_out_of_bounds,
 	test_ubsan_out_of_bounds,
 	test_ubsan_load_invalid_value,
-	//test_ubsan_null_ptr_deref, /* exclude it because there is a crash */
 	test_ubsan_misaligned_access,
 	test_ubsan_object_size_mismatch,
 };
 
+/* Excluded because they Oops the module. */
+static const test_ubsan_fp skip_ubsan_array[] = {
+	test_ubsan_divrem_overflow,
+	test_ubsan_null_ptr_deref,
+};
+
 static int __init test_ubsan_init(void)
 {
 	unsigned int i;
@@ -120,7 +179,6 @@ static int __init test_ubsan_init(void)
 	for (i = 0; i < ARRAY_SIZE(test_ubsan_array); i++)
 		test_ubsan_array[i]();
 
-	(void)test_ubsan_null_ptr_deref; /* to avoid unsed-function warning */
 	return 0;
 }
 module_init(test_ubsan_init);
_

Patches currently in -mm which might be from keescook@chromium.org are

ubsan-remove-redundant-wno-maybe-uninitialized.patch
ubsan-move-cc-option-tests-into-kconfig.patch
ubsan-disable-object-size-sanitizer-under-gcc.patch
ubsan-disable-ubsan_trap-for-allconfig.patch
ubsan-enable-for-allconfig-builds.patch
ubsan-remove-ubsan_misc-in-favor-of-individual-options.patch
ubsan-expand-tests-and-reporting.patch

