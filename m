From: akpm@linux-foundation.org
Subject: + zram-try-harder-to-store-user-data-on-compression-error.patch
 added to -mm tree
Date: Thu, 18 May 2017 13:30:13 -0700
Message-ID: <591e0455.86O/Cx+PqQVa79iN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44308 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752483AbdERUaO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2017 16:30:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: try harder to store user data on compression error
has been added to the -mm tree.  Its filename is
     zram-try-harder-to-store-user-data-on-compression-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-try-harder-to-store-user-data-on-compression-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-try-harder-to-store-user-data-on-compression-error.patch

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
Subject: zram: try harder to store user data on compression error

__zram_bvec_write() overwrites the existing compressed object only when it
successfully compresses a new one.  When zram_compress() fails, we
propagate the error, but never touch the old object, so we keep the old
data for that particular page and all reads that could hit that index
later will read stale data.  This can cause problems.  For example,

- Overwriting a file

     over-write block 1 aaa->xxx OK
     over-write block 2 bbb->yyy OK
     over-write block 3 ccc->zzz error << the block still has 'ccc' data.

- Now, reading the file

     read block 1 xxx OK
     read block 2 yyy OK
     read block 3 ccc OK   << we should not return OK here. Because
                              "xxxyyyccc" is not correct file.

As a solution, when we fail to compress a new page (S/W or H/W compressor
error, depending on particular setup) try to store the page uncompressed
(PAGE_SIZE-ed zs_pool object).  This, at least, allows us to return valid
and correct data:

     read block 1  xxx - OK, compressed
     read block 2  yyy - OK, compressed
     read block 3  zzz - OK, uncompressed (because compressing back-end
                                           returned an error)

Link: http://lkml.kernel.org/r/20170518021714.3229-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-try-harder-to-store-user-data-on-compression-error drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-try-harder-to-store-user-data-on-compression-error
+++ a/drivers/block/zram/zram_drv.c
@@ -732,10 +732,12 @@ compress_again:
 	kunmap_atomic(src);
 
 	if (unlikely(ret)) {
+		/*
+		 * We failed to compress the page, try to store it
+		 * uncompressed (if there is enough memory).
+		 */
 		pr_err("Compression failed! err=%d\n", ret);
-		if (entry)
-			zram_entry_free(zram, entry);
-		return ret;
+		comp_len = PAGE_SIZE;
 	}
 
 	if (unlikely(comp_len > max_zpage_size))
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

zram-try-harder-to-store-user-data-on-compression-error.patch

