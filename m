Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1949C43219
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9CB36127B
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345370AbhIXWpT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345236AbhIXWpS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A309B61250;
        Fri, 24 Sep 2021 22:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523425;
        bh=uNv4xnLVIZUJ/5ItL/wFdCYk4ilkW6Kp4YqRoqMTTNI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gLn0EsOMnyViv38LmBzD8fQ92lx/QTApgRbHls1MTZROiUGO4SQqvw3zkov8j1kCk
         ggXxQZ7+2jZq94wBYRNAwTDR3W14mM6M9fuU9omMbDy88qu5cas37Rl3ELBjM2QpS2
         eO1E6ENMW1PRhaioGNFCrPY/lBtVM4L8nel93HuU=
Date:   Fri, 24 Sep 2021 15:43:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        christophe.leroy@csgroup.eu, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, nathan@kernel.org,
        ndesaulniers@google.com, paulus@samba.org, pmenzel@molgen.mpg.de,
        thunder.leizhen@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 09/16] lib/zlib_inflate/inffast: check config in C
 to avoid unused function warning
Message-ID: <20210924224344.udphYXih4%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: lib/zlib_inflate/inffast: check config in C to avoid unused function warning

Building Linux for ppc64le with Ubuntu clang version
12.0.0-3ubuntu1~21.04.1 shows the warning below.

    arch/powerpc/boot/inffast.c:20:1: warning: unused function 'get_unaligned16' [-Wunused-function]
    get_unaligned16(const unsigned short *p)
    ^
    1 warning generated.

Fix it, by moving the check from the preprocessor to C, so the compiler
sees the use.

Link: https://lkml.kernel.org/r/20210920084332.5752-1-pmenzel@molgen.mpg.de
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_inflate/inffast.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/lib/zlib_inflate/inffast.c~lib-zlib_inflate-inffast-check-config-in-c-to-avoid-unused-function-warning
+++ a/lib/zlib_inflate/inffast.c
@@ -253,13 +253,12 @@ void inflate_fast(z_streamp strm, unsign
 
 			sfrom = (unsigned short *)(from);
 			loops = len >> 1;
-			do
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-			    *sout++ = *sfrom++;
-#else
-			    *sout++ = get_unaligned16(sfrom++);
-#endif
-			while (--loops);
+			do {
+			    if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
+				*sout++ = *sfrom++;
+			    else
+				*sout++ = get_unaligned16(sfrom++);
+			} while (--loops);
 			out = (unsigned char *)sout;
 			from = (unsigned char *)sfrom;
 		    } else { /* dist == 1 or dist == 2 */
_
