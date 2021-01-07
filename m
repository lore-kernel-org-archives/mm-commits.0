Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E618C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 23:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E25E8235FC
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 23:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbhAGXGw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:06:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbhAGXGw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Jan 2021 18:06:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51749235FC;
        Thu,  7 Jan 2021 23:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610060771;
        bh=UU8lbxR3OC4OtqGru9nv9xIQclfJ+HGDggTsDGF+mS8=;
        h=Date:From:To:Subject:From;
        b=FVHhNoeqNEat6z6jKcTWuijxtCpZNRvFV5a1zoLH9xDfBmrGDWXq+CM1OGLL10bJL
         tCjplzgfEM1q5iweSDa1vRBOqI05E/1dMUn24fspNvyJb7w0AfFUH07Xwex1pNFmSO
         dqgHUckEh5ewwegpjW59iefxdhEeQmpc4zLUMHXI=
Date:   Thu, 07 Jan 2021 15:06:10 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, elver@google.com, georgepope@android.com,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        sfr@canb.auug.org.au
Subject:  [to-be-updated]
 ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang.patch removed
 from -mm tree
Message-ID: <20210107230610.AAqFR2oAk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: disable unsigned-integer-overflow sanitizer with clang
has been removed from the -mm tree.  Its filename was
     ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ubsan: disable unsigned-integer-overflow sanitizer with clang

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
-fsanitize=unsigned-integer-overflow.

The one in blake2b immediately overflows the 8KB stack area on 32-bit
architectures, so better ensure this never happens by making this option
gcc-only.

[akpm@linux-foundation.org: fix comment typo, per Nathan]
Link: https://lkml.kernel.org/r/20201230154749.746641-1-arnd@kernel.org
Fixes: d0a3ac549f38 ("ubsan: enable for all*config builds")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Marco Elver <elver@google.com>
Cc: George Popescu <georgepope@android.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/Kconfig.ubsan~ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang
+++ a/lib/Kconfig.ubsan
@@ -122,6 +122,8 @@ config UBSAN_SIGNED_OVERFLOW
 
 config UBSAN_UNSIGNED_OVERFLOW
 	bool "Perform checking for unsigned arithmetic overflow"
+	# clang hugely expands stack usage with -fsanitize=unsigned-integer-overflow
+	depends on !CC_IS_CLANG
 	depends on $(cc-option,-fsanitize=unsigned-integer-overflow)
 	help
 	  This option enables -fsanitize=unsigned-integer-overflow which checks
_

Patches currently in -mm which might be from arnd@arndb.de are


