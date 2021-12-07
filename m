Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1A8C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  7 Dec 2021 02:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbhLGCOs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:14:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40322 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbhLGCOr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Dec 2021 21:14:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54481CE19B6
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 02:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3DCC341C5;
        Tue,  7 Dec 2021 02:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638843074;
        bh=FwAsPvIRd94b71ZSFSedVxzM12tLL1mM1JBJiCfM+r0=;
        h=Date:From:To:Subject:From;
        b=r1tAwv0kjzr+glSNC/PAMqBjd+SmLgORN2mmG/9ThYJp6lmi/UBT9ldquKcS4cfBo
         64vMeV9NgxqrlmllUiDiGVt8XyafBerZjpMJouTYneh6tovF7E/O+tlAH1+0xomiMJ
         Pro3A37eWB7TcwgBk/AQm7Zxi4osm5nr0T0wbcr0=
Date:   Mon, 06 Dec 2021 18:11:13 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, elver@google.com, keescook@chromium.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, peterz@infradead.org,
        ryabinin.a.a@gmail.com, sfr@canb.auug.org.au
Subject:  + ubsan-remove-config_ubsan_object_size.patch added to
 -mm tree
Message-ID: <20211207021113.bONE4-Nyo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: remove CONFIG_UBSAN_OBJECT_SIZE
has been added to the -mm tree.  Its filename is
     ubsan-remove-config_ubsan_object_size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ubsan-remove-config_ubsan_object_size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ubsan-remove-config_ubsan_object_size.patch

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

Patches currently in -mm which might be from keescook@chromium.org are

hugetlb-add-hugetlbnuma_stat-file-fix-2.patch
hfsplus-use-struct_group_attr-for-memcpy-region.patch
ubsan-remove-config_ubsan_object_size.patch

