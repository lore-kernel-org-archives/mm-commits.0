From: akpm@linux-foundation.org
Subject: [merged] zram-zcomp-do-not-zero-out-zcomp-private-pages.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:00:34 -0800
Message-ID: <569e95e2.6uKz/P5f4jeTGais%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533AbcASUAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram/zcomp: do not zero out zcomp private pages
has been removed from the -mm tree.  Its filename was
     zram-zcomp-do-not-zero-out-zcomp-private-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

printk-change-recursion_bug-type-to-bool.patch

