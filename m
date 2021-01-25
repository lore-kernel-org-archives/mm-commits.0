Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185D5C433DB
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D274E207B7
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbhAYW2j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:28:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732970AbhAYVhZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 16:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90831225AB;
        Mon, 25 Jan 2021 21:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611610516;
        bh=IdYwSdNBH2Pr6b5j6OLnW262dEdGZJk7OKAL6CSok/I=;
        h=Date:From:To:Subject:From;
        b=Ekl1cba+qWbcVOks6YrIKL67RIzzYzvA6onQ2uRqzlP+xKIkyqccwKXNAAaYomgT6
         huyZOM9sSK3WtbIGFU9Ht0ejYupjOncosOreTLjdRPhWAggIxadp1UNNUAiDZ1arBY
         5v1EQH6LZHg7WhsqCozBVQZt6Eh/q37ehATiAj28=
Date:   Mon, 25 Jan 2021 13:35:16 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, elver@google.com, georgepope@android.com,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        sfr@canb.auug.org.au
Subject:  [merged]
 ubsan-disable-unsigned-overflow-check-for-i386.patch removed from -mm tree
Message-ID: <20210125213516.5KslXdQy0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: disable unsigned-overflow check for i386
has been removed from the -mm tree.  Its filename was
     ubsan-disable-unsigned-overflow-check-for-i386.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ubsan: disable unsigned-overflow check for i386

Building ubsan kernels even for compile-testing introduced these warnings
in my randconfig environment:

crypto/blake2b_generic.c:98:13: error: stack frame size of 9636 bytes in function 'blake2b_compress' [-Werror,-Wframe-larger-than=]
static void blake2b_compress(struct blake2b_state *S,
crypto/sha512_generic.c:151:13: error: stack frame size of 1292 bytes in function 'sha512_generic_block_fn' [-Werror,-Wframe-larger-than=]
static void sha512_generic_block_fn(struct sha512_state *sst, u8 const *src,
lib/crypto/curve25519-fiat32.c:312:22: error: stack frame size of 2180 bytes in function 'fe_mul_impl' [-Werror,-Wframe-larger-than=]
static noinline void fe_mul_impl(u32 out[10], const u32 in1[10], const u32 in2[10])
lib/crypto/curve25519-fiat32.c:444:22: error: stack frame size of 1588 bytes in function 'fe_sqr_impl' [-Werror,-Wframe-larger-than=]
static noinline void fe_sqr_impl(u32 out[10], const u32 in1[10])

Further testing showed that this is caused by
-fsanitize=unsigned-integer-overflow, but is isolated to the 32-bit x86
architecture.

The one in blake2b immediately overflows the 8KB stack area architectures,
so better ensure this never happens by disabling the option for 32-bit
x86.

Link: https://lkml.kernel.org/r/20210112202922.2454435-1-arnd@kernel.org
Link: https://lore.kernel.org/lkml/20201230154749.746641-1-arnd@kernel.org/
Fixes: d0a3ac549f38 ("ubsan: enable for all*config builds")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Marco Elver <elver@google.com>
Cc: George Popescu <georgepope@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.ubsan~ubsan-disable-unsigned-overflow-check-for-i386
+++ a/lib/Kconfig.ubsan
@@ -123,6 +123,7 @@ config UBSAN_SIGNED_OVERFLOW
 config UBSAN_UNSIGNED_OVERFLOW
 	bool "Perform checking for unsigned arithmetic overflow"
 	depends on $(cc-option,-fsanitize=unsigned-integer-overflow)
+	depends on !X86_32 # avoid excessive stack usage on x86-32/clang
 	help
 	  This option enables -fsanitize=unsigned-integer-overflow which checks
 	  for overflow of any arithmetic operations with unsigned integers. This
_

Patches currently in -mm which might be from arnd@arndb.de are


