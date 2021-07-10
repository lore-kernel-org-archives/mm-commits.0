Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCA9C07E9B
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 21:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E6826135E
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 21:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhGJVeX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Jul 2021 17:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhGJVeX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Jul 2021 17:34:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B39146135F;
        Sat, 10 Jul 2021 21:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625952697;
        bh=fp2we8+q6nzRSp38FUusIFB1SJLg1LkyIMxcCE7hufI=;
        h=Date:From:To:Subject:From;
        b=rklHr+6mfwp4nNheYlIKbZSqTCdpIxPfCdezFidN2vZftfTbZZVygPU2HDtu/3uyR
         gkjyf0sxCjkNUCV+/0hpMf4BqiY7elhaxdUWntpNNwGddwnJWnPqsjxH/8NdNPeiDg
         iUSpZ/lQlOXZr4gqnXQA5qmYXocQdKZ+iEYlbOnw=
Date:   Sat, 10 Jul 2021 14:31:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, palmer@dabbelt.com,
        ndesaulniers@google.com, mick@ics.forth.gr, kernel@esmil.dk,
        hch@infradead.org, guoren@kernel.org, drew@beagleboard.org,
        David.Laight@aculab.com, mcroce@microsoft.com
Subject:  + lib-string-optimized-memset.patch added to -mm tree
Message-ID: <20210710213136.fWqu6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string: optimized memset
has been added to the -mm tree.  Its filename is
     lib-string-optimized-memset.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-string-optimized-memset.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-string-optimized-memset.patch

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
Subject: lib/string: optimized memset

The generic memset is defined as a byte at time write.  This is always
safe, but it's slower than a 4 byte or even 8 byte write.

Write a generic memset which fills the data one byte at time until the
destination is aligned, then fills using the largest size allowed, and
finally fills the remaining data one byte at time.

On a RISC-V machine the speed goes from 140 Mb/s to 241 Mb/s, and this the
binary size increase according to bloat-o-meter:

Function     old     new   delta
memset        32     148    +116

Link: https://lkml.kernel.org/r/20210702123153.14093-4-mcroce@linux.microsoft.com
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

 lib/string.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/lib/string.c~lib-string-optimized-memset
+++ a/lib/string.c
@@ -810,10 +810,38 @@ EXPORT_SYMBOL(__sysfs_match_string);
  */
 void *memset(void *s, int c, size_t count)
 {
-	char *xs = s;
+	union types dest = { .as_u8 = s };
 
+	if (count >= MIN_THRESHOLD) {
+		unsigned long cu = (unsigned long)c;
+
+		/* Compose an ulong with 'c' repeated 4/8 times */
+#ifdef CONFIG_ARCH_HAS_FAST_MULTIPLIER
+		cu *= 0x0101010101010101UL;
+#else
+		cu |= cu << 8;
+		cu |= cu << 16;
+		/* Suppress warning on 32 bit machines */
+		cu |= (cu << 16) << 16;
+#endif
+		if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
+			/*
+			 * Fill the buffer one byte at time until
+			 * the destination is word aligned.
+			 */
+			for (; count && dest.as_uptr & WORD_MASK; count--)
+				*dest.as_u8++ = c;
+		}
+
+		/* Copy using the largest size allowed */
+		for (; count >= BYTES_LONG; count -= BYTES_LONG)
+			*dest.as_ulong++ = cu;
+	}
+
+	/* copy the remainder */
 	while (count--)
-		*xs++ = c;
+		*dest.as_u8++ = c;
+
 	return s;
 }
 EXPORT_SYMBOL(memset);
_

Patches currently in -mm which might be from mcroce@microsoft.com are

revert-mm-page_alloc-make-should_fail_alloc_page-static.patch
lib-string-optimized-memcpy.patch
lib-string-optimized-memmove.patch
lib-string-optimized-memset.patch

