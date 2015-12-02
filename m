From: akpm@linux-foundation.org
Subject: + zram-zcomp-do-not-zero-out-zcomp-private-pages.patch added to
 -mm tree
Date: Tue, 01 Dec 2015 16:39:44 -0800
Message-ID: <565e3dd0.p5sHM+LVKLjd7Asv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbbLBAjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 19:39:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram/zcomp: do not zero out zcomp private pages
has been added to the -mm tree.  Its filename is
     zram-zcomp-do-not-zero-out-zcomp-private-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-zcomp-do-not-zero-out-zcomp-private-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-zcomp-do-not-zero-out-zcomp-private-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram/zcomp: do not zero out zcomp private pages

Do not __GFP_ZERO allocated zcomp ->private pages.  We keep allocated
streams around and use them for read/write requests, so we supply a zeroed
out ->private to compression algorithm as a scratch buffer only once --
the first time we use that stream.  For the rest of IO requests served by
this stream ->private usually contains some temporarily data from the
previous requests.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp_lz4.c |    4 ++--
 drivers/block/zram/zcomp_lzo.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/block/zram/zcomp_lz4.c~zram-zcomp-do-not-zero-out-zcomp-private-pages drivers/block/zram/zcomp_lz4.c
--- a/drivers/block/zram/zcomp_lz4.c~zram-zcomp-do-not-zero-out-zcomp-private-pages
+++ a/drivers/block/zram/zcomp_lz4.c
@@ -19,10 +19,10 @@ static void *zcomp_lz4_create(gfp_t flag
 {
 	void *ret;
 
-	ret = kzalloc(LZ4_MEM_COMPRESS, flags);
+	ret = kmalloc(LZ4_MEM_COMPRESS, flags);
 	if (!ret)
 		ret = __vmalloc(LZ4_MEM_COMPRESS,
-				flags | __GFP_ZERO | __GFP_HIGHMEM,
+				flags | __GFP_HIGHMEM,
 				PAGE_KERNEL);
 	return ret;
 }
diff -puN drivers/block/zram/zcomp_lzo.c~zram-zcomp-do-not-zero-out-zcomp-private-pages drivers/block/zram/zcomp_lzo.c
--- a/drivers/block/zram/zcomp_lzo.c~zram-zcomp-do-not-zero-out-zcomp-private-pages
+++ a/drivers/block/zram/zcomp_lzo.c
@@ -19,10 +19,10 @@ static void *lzo_create(gfp_t flags)
 {
 	void *ret;
 
-	ret = kzalloc(LZO1X_MEM_COMPRESS, flags);
+	ret = kmalloc(LZO1X_MEM_COMPRESS, flags);
 	if (!ret)
 		ret = __vmalloc(LZO1X_MEM_COMPRESS,
-				flags | __GFP_ZERO | __GFP_HIGHMEM,
+				flags | __GFP_HIGHMEM,
 				PAGE_KERNEL);
 	return ret;
 }
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-zcomp-use-gfp_noio-to-allocate-streams.patch
zram-zcomp-do-not-zero-out-zcomp-private-pages.patch

