Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2B7C2D0E4
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 03:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC97320866
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 03:20:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fJc8COSC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgKXDUa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:20:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbgKXDUa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 22:20:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AB2520857;
        Tue, 24 Nov 2020 03:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606188029;
        bh=NMlHGeuS4lg6cC/GoanUnbF87zPtgNJFMRoOyL0CtqA=;
        h=Date:From:To:Subject:From;
        b=fJc8COSCg6EbHSlKkBw8utXE62BoQ89cqfYyDz2s0/nL3iHOcIBwrnhyRnBxXVDD0
         5zr0zZF8vHFEJSl6TYimteelnCyygKeRHyohnve0QZ8juPygCMXN9baTUgH+yd7HK6
         8d4yVdSUW2lbwfgTrwGnos2Smi4SlQ6dmo8rTYmM=
Date:   Mon, 23 Nov 2020 19:20:27 -0800
From:   akpm@linux-foundation.org
To:     bluce.liguifu@huawei.com, guoxuenan@huawei.com,
        hsiangkao@redhat.com, miaoxie@huawei.com,
        mm-commits@vger.kernel.org, terrelln@fb.com,
        yann.collet.73@gmail.com, yuchao0@huawei.com
Subject:  + lib-lz4-explicitly-support-in-place-decompression.patch
 added to -mm tree
Message-ID: <20201124032027.ADdKX4Njc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lz4: explicitly support in-place decompression
has been added to the -mm tree.  Its filename is
     lib-lz4-explicitly-support-in-place-decompression.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-lz4-explicitly-support-in-place-decompression.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-lz4-explicitly-support-in-place-decompression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
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

Patches currently in -mm which might be from hsiangkao@redhat.com are

lib-lz4-explicitly-support-in-place-decompression.patch

