Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FDCC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BBA161179
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237492AbhIIU6M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 16:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233573AbhIIU6L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 16:58:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A13EE6103E;
        Thu,  9 Sep 2021 20:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221022;
        bh=b6T0SvxyJbIk03xV7zv1mBHephpAyYKU4o3dLXBcfRY=;
        h=Date:From:To:Subject:From;
        b=nVsUjoFab8BTt3BSyKmRtxmM34/lHq69Qo3fm7MSCjF3EDuVsJtmsZzKsiBE1Q2LN
         uvdp7B46Tl9prnZ7MifPQI/hGKFuW576fqOkC+25PO/ArzIsjXcP2Tdl3y8Eb10oMR
         HTZHUvT0IRi5RdgR55ARjBOBYMxaSPKHhH23aEOE=
Date:   Thu, 09 Sep 2021 13:57:01 -0700
From:   akpm@linux-foundation.org
To:     David.Laight@aculab.com, drew@beagleboard.org, guoren@kernel.org,
        hch@infradead.org, kernel@esmil.dk, mcroce@microsoft.com,
        mick@ics.forth.gr, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, palmer@dabbelt.com
Subject:  [to-be-updated] lib-string-optimized-memset.patch removed
 from -mm tree
Message-ID: <20210909205701.ZN1HDRZCz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string: optimized memset
has been removed from the -mm tree.  Its filename was
     lib-string-optimized-memset.patch

This patch was dropped because an updated version will be merged

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


