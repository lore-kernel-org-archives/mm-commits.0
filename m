Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500BEC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D3523130
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgLPEop (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgLPEop (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:44:45 -0500
Date:   Tue, 15 Dec 2020 20:44:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093844;
        bh=j+KWtXlV5nYZX0IEZhYyabLWm/s3ROic54iVGsF0TPs=;
        h=From:To:Subject:In-Reply-To:From;
        b=KajwzrJnQfgQmvf8uCNnkzXQg+3ELn8sPMFS05appeO59nwZ47Eo0kazNqqba3BL0
         TnHLUjxiQg1jnUbnjM88jHCn7UMlIEBz4valYet2HEcoJhBUMc4134e7c320GlEfT9
         L6tPiRX0OF/JwJGOJcV59RnVyD4WoLi/3D/7+STY=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bluce.liguifu@huawei.com,
        guoxuenan@huawei.com, hsiangkao@redhat.com, linux-mm@kvack.org,
        miaoxie@huawei.com, mm-commits@vger.kernel.org, terrelln@fb.com,
        torvalds@linux-foundation.org, yann.collet.73@gmail.com,
        yuchao0@huawei.com
Subject:  [patch 32/95] lib/lz4: explicitly support in-place
 decompression
Message-ID: <20201216044403.YLaXtThZ8%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>
Subject: lib/lz4: explicitly support in-place decompression

LZ4 final literal copy could be overlapped when doing
in-place decompression, so it's unsafe to just use memcpy()
on an optimized memcpy approach but memmove() instead.

Upstream LZ4 has updated this years ago [1] (and the impact
is non-sensible [2] plus only a few bytes remain), this commit
just synchronizes LZ4 upstream code to the kernel side as well.

It can be observed as EROFS in-place decompression failure
on specific files when X86_FEATURE_ERMS is unsupported,
memcpy() optimization of commit 59daa706fbec ("x86, mem:
Optimize memcpy by avoiding memory false dependece") will
be enabled then.

Currently most modern x86-CPUs support ERMS, these CPUs just
use "rep movsb" approach so no problem at all. However, it can
still be verified with forcely disabling ERMS feature...

arch/x86/lib/memcpy_64.S:
        ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
-                     "jmp memcpy_erms", X86_FEATURE_ERMS
+                     "jmp memcpy_orig", X86_FEATURE_ERMS

We didn't observe any strange on arm64/arm/x86 platform before
since most memcpy() would behave in an increasing address order
("copy upwards" [3]) and it's the correct order of in-place
decompression but it really needs an update to memmove() for sure
considering it's an undefined behavior according to the standard
and some unique optimization already exists in the kernel.

[1] https://github.com/lz4/lz4/commit/33cb8518ac385835cc17be9a770b27b40cd0e15b
[2] https://github.com/lz4/lz4/pull/717#issuecomment-497818921
[3] https://sourceware.org/bugzilla/show_bug.cgi?id=12518
Link: https://lkml.kernel.org/r/20201122030749.2698994-1-hsiangkao@redhat.com
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Nick Terrell <terrelln@fb.com>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: Li Guifu <bluce.liguifu@huawei.com>
Cc: Guo Xuenan <guoxuenan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |    6 +++++-
 lib/lz4/lz4defs.h        |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/lib/lz4/lz4_decompress.c~lib-lz4-explicitly-support-in-place-decompression
+++ a/lib/lz4/lz4_decompress.c
@@ -263,7 +263,11 @@ static FORCE_INLINE int LZ4_decompress_g
 				}
 			}
 
-			LZ4_memcpy(op, ip, length);
+			/*
+			 * supports overlapping memory regions; only matters
+			 * for in-place decompression scenarios
+			 */
+			LZ4_memmove(op, ip, length);
 			ip += length;
 			op += length;
 
--- a/lib/lz4/lz4defs.h~lib-lz4-explicitly-support-in-place-decompression
+++ a/lib/lz4/lz4defs.h
@@ -146,6 +146,7 @@ static FORCE_INLINE void LZ4_writeLE16(v
  * environments. This is needed when decompressing the Linux Kernel, for example.
  */
 #define LZ4_memcpy(dst, src, size) __builtin_memcpy(dst, src, size)
+#define LZ4_memmove(dst, src, size) __builtin_memmove(dst, src, size)
 
 static FORCE_INLINE void LZ4_copy8(void *dst, const void *src)
 {
_
