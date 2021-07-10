Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A44C07E9B
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 21:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B91366135E
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 21:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhGJVeU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Jul 2021 17:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhGJVeU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Jul 2021 17:34:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BED646135D;
        Sat, 10 Jul 2021 21:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625952695;
        bh=BFPwrMZMoLpf0iTOquzCPa+sqX64t3Gj5QJEz/NFCXE=;
        h=Date:From:To:Subject:From;
        b=J8Wl/C4cRuoX3hg5ownuFvAKGhblbFhmYfG7l1X4Aw8Awyy3JaamyjD0upolE1zcL
         /FkEFWhCzPnU67HCLSuj0f7VbAcNM17kB88Za45AbBmcnmsjbtnO7j8Yigm7sKDoef
         3z5gwuvlBwXo4UfKo/hB9wVmTN/IWeANyrd/gc+E=
Date:   Sat, 10 Jul 2021 14:31:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, palmer@dabbelt.com,
        ndesaulniers@google.com, mick@ics.forth.gr, kernel@esmil.dk,
        hch@infradead.org, guoren@kernel.org, drew@beagleboard.org,
        David.Laight@aculab.com, mcroce@microsoft.com
Subject:  + lib-string-optimized-memmove.patch added to -mm tree
Message-ID: <20210710213134.vPCnT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string: optimized memmove
has been added to the -mm tree.  Its filename is
     lib-string-optimized-memmove.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-string-optimized-memmove.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-string-optimized-memmove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matteo Croce <mcroce@microsoft.com>
Subject: lib/string: optimized memmove

When the destination buffer is before the source one, or when the buffers
doesn't overlap, it's safe to use memcpy() instead, which is optimized to
use a bigger data size possible.

This "optimization" only covers a common case.  In future, proper code
which does the same thing as memcpy() does but backwards can be done.

Link: https://lkml.kernel.org/r/20210702123153.14093-3-mcroce@linux.microsoft.com
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Laight <David.Laight@aculab.com>
Cc: Drew Fustini <drew@beagleboard.org>
Cc: Emil Renner Berthing <kernel@esmil.dk>
Cc: Guo Ren <guoren@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nick Kossifidis <mick@ics.forth.gr>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/lib/string.c~lib-string-optimized-memmove
+++ a/lib/string.c
@@ -975,19 +975,13 @@ EXPORT_SYMBOL(memcpy);
  */
 void *memmove(void *dest, const void *src, size_t count)
 {
-	char *tmp;
-	const char *s;
+	if (dest < src || src + count <= dest)
+		return memcpy(dest, src, count);
+
+	if (dest > src) {
+		const char *s = src + count;
+		char *tmp = dest + count;
 
-	if (dest <= src) {
-		tmp = dest;
-		s = src;
-		while (count--)
-			*tmp++ = *s++;
-	} else {
-		tmp = dest;
-		tmp += count;
-		s = src;
-		s += count;
 		while (count--)
 			*--tmp = *--s;
 	}
_

Patches currently in -mm which might be from mcroce@microsoft.com are

revert-mm-page_alloc-make-should_fail_alloc_page-static.patch
lib-string-optimized-memcpy.patch
lib-string-optimized-memmove.patch
lib-string-optimized-memset.patch

