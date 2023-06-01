Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61DFC77B7A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 04:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjFAEMy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 00:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjFAEMv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 00:12:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAC9107
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 21:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E655063A8D
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 04:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45562C433EF;
        Thu,  1 Jun 2023 04:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685592769;
        bh=s6++0UruGUvCiSFT6MSky93Q9lKmKa/XvoMOpjTQ15o=;
        h=Date:To:From:Subject:From;
        b=SaYngzKG+LoVkX0wOYBt8lrmoOwWxfYRcOlXe4JwpOuvOZRQCab34v67zpHXr65FQ
         x2LL0uy3xB0l69/e5Qm93H8Vg17XRgNu9bOcmAlWeoMGtQRbPUVSwU9n2AdzKvbae1
         ghRG63yWR8UKOlAcCxpcrHw6j9Af+xX5VTN3oqMM=
Date:   Wed, 31 May 2023 21:12:48 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, keescook@chromium.org, elver@google.com,
        dvyukov@google.com, andy@kernel.org, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] string-use-__builtin_memcpy-in-strlcpy-strlcat.patch removed from -mm tree
Message-Id: <20230601041249.45562C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: string: use __builtin_memcpy() in strlcpy/strlcat
has been removed from the -mm tree.  Its filename was
     string-use-__builtin_memcpy-in-strlcpy-strlcat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: string: use __builtin_memcpy() in strlcpy/strlcat
Date: Tue, 30 May 2023 10:39:11 +0200

lib/string.c is built with -ffreestanding, which prevents the compiler
from replacing certain functions with calls to their library versions.

On the other hand, this also prevents Clang and GCC from instrumenting
calls to memcpy() when building with KASAN, KCSAN or KMSAN:
 - KASAN normally replaces memcpy() with __asan_memcpy() with the
   additional cc-param,asan-kernel-mem-intrinsic-prefix=1;
 - KCSAN and KMSAN replace memcpy() with __tsan_memcpy() and
   __msan_memcpy() by default.

To let the tools catch memory accesses from strlcpy/strlcat, replace the
calls to memcpy() with __builtin_memcpy(), which KASAN, KCSAN and KMSAN
are able to replace even in -ffreestanding mode.

This preserves the behavior in normal builds (__builtin_memcpy() ends up
being replaced with memcpy()), and does not introduce new instrumentation
in unwanted places, as strlcpy/strlcat are already instrumented.

Link: https://lkml.kernel.org/r/20230530083911.1104336-1-glider@google.com
Link: https://lore.kernel.org/all/20230224085942.1791837-1-elver@google.com/
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/string.c~string-use-__builtin_memcpy-in-strlcpy-strlcat
+++ a/lib/string.c
@@ -110,7 +110,7 @@ size_t strlcpy(char *dest, const char *s
 
 	if (size) {
 		size_t len = (ret >= size) ? size - 1 : ret;
-		memcpy(dest, src, len);
+		__builtin_memcpy(dest, src, len);
 		dest[len] = '\0';
 	}
 	return ret;
@@ -260,7 +260,7 @@ size_t strlcat(char *dest, const char *s
 	count -= dsize;
 	if (len >= count)
 		len = count-1;
-	memcpy(dest, src, len);
+	__builtin_memcpy(dest, src, len);
 	dest[len] = 0;
 	return res;
 }
_

Patches currently in -mm which might be from glider@google.com are


