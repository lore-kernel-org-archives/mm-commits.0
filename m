From: akpm@linux-foundation.org
Subject: + zram-remove-zlib-from-the-list-of-recommended-algorithms.patch
 added to -mm tree
Date: Thu, 28 Sep 2017 14:47:58 -0700
Message-ID: <59cd6e0e.QibheXQJ6Jt57p6I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750805AbdI1Vr7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2017 17:47:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove zlib from the list of recommended algorithms
has been added to the -mm tree.  Its filename is
     zram-remove-zlib-from-the-list-of-recommended-algorithms.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-remove-zlib-from-the-list-of-recommended-algorithms.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-remove-zlib-from-the-list-of-recommended-algorithms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: zram: remove zlib from the list of recommended algorithms

ZSTD tends to outperform deflate/inflate, thus we remove zlib from the
list of recommended algorithms and recommend zstd instead.

Link: http://lkml.kernel.org/r/20170912050005.3247-2-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-remove-zlib-from-the-list-of-recommended-algorithms drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-remove-zlib-from-the-list-of-recommended-algorithms
+++ a/drivers/block/zram/zcomp.c
@@ -23,9 +23,6 @@ static const char * const backends[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_LZ4)
 	"lz4",
 #endif
-#if IS_ENABLED(CONFIG_CRYPTO_DEFLATE)
-	"deflate",
-#endif
 #if IS_ENABLED(CONFIG_CRYPTO_LZ4HC)
 	"lz4hc",
 #endif
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

zram-add-zstd-to-the-supported-algorithms-list.patch
zram-remove-zlib-from-the-list-of-recommended-algorithms.patch

