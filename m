Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D746C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C2E061167
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbhIIU6J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 16:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233573AbhIIU6I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 16:58:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CDD361026;
        Thu,  9 Sep 2021 20:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221019;
        bh=TDSyXSK8tm+xzfDpD0zj83KClwG3CS3uN/PtBfMBK8Y=;
        h=Date:From:To:Subject:From;
        b=qumfhclpmXiPzI9UFWVPz1T/aMO7Dd3Wku9EkA4ADtcS9sPa3UNYQvP9xJXDHhNcY
         nwWIuw3AlYdDzhwe4fjYDBDRipfL6w/Y+AWRR42p+ocGHmD0KoQf1I7q2IUouYB1Rf
         1Ik24xtu79DyC7ljwV1XbcNZiZ5THH03+qLfWx3M=
Date:   Thu, 09 Sep 2021 13:56:58 -0700
From:   akpm@linux-foundation.org
To:     David.Laight@aculab.com, drew@beagleboard.org, guoren@kernel.org,
        hch@infradead.org, kernel@esmil.dk, mcroce@microsoft.com,
        mick@ics.forth.gr, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, palmer@dabbelt.com
Subject:  [to-be-updated] lib-string-optimized-memmove.patch
 removed from -mm tree
Message-ID: <20210909205658.NfiHPg6wM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string: optimized memmove
has been removed from the -mm tree.  Its filename was
     lib-string-optimized-memmove.patch

This patch was dropped because an updated version will be merged

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

lib-string-optimized-memset.patch

