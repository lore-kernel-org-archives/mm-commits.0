Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA85C43219
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7990D6115A
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347361AbhIHC7v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347323AbhIHC7u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:59:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D2DA61100;
        Wed,  8 Sep 2021 02:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069923;
        bh=pBQuwNP9n7gthVjUhIw63U0Kuz1Q8VJWLYAckiZW1aI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wZZJHzRjkCsEVxLyz7cr0v+cTlmLMzAQDoU33A59kBp+szIfyH6b9kEoyBqZ75+h+
         VLwZ3XrdHsXCQ/3NPrtGC/Wxs91FMczYgWXKyTFc2v3ZsFWfeKumnkO64fXZQrISdU
         hOkkWAnjBq5wRkZjJntfi6mBg8oCky+sqtzJLus4=
Date:   Tue, 07 Sep 2021 19:58:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, David.Laight@aculab.com,
        drew@beagleboard.org, guoren@kernel.org, hch@infradead.org,
        kernel@esmil.dk, linux-mm@kvack.org, mcroce@microsoft.com,
        mick@ics.forth.gr, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, palmer@dabbelt.com,
        torvalds@linux-foundation.org
Subject:  [patch 102/147] lib/string: optimized memmove
Message-ID: <20210908025842.MCdSIuFM5%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
