From: akpm@linux-foundation.org
Subject: + zram-rename-zram_decompress_page-with-__zram_bvec_read.patch
 added to -mm tree
Date: Wed, 19 Jul 2017 16:08:13 -0700
Message-ID: <596fe65d.QWASK8Snhx9B9Sf1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38974 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932096AbdGSXIO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 19:08:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, juno.choi@lge.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: rename zram_decompress_page to __zram_bvec_read
has been added to the -mm tree.  Its filename is
     zram-rename-zram_decompress_page-with-__zram_bvec_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-rename-zram_decompress_page-with-__zram_bvec_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-rename-zram_decompress_page-with-__zram_bvec_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: rename zram_decompress_page to __zram_bvec_read

zram_decompress_page naming is not proper because it doesn't decompress if
page was dedup hit or stored with compression.  Use more abstract term and
consistent with write path function __zram_bvec_write.

Link: http://lkml.kernel.org/r/1498459987-24562-4-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-rename-zram_decompress_page-with-__zram_bvec_read drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-rename-zram_decompress_page-with-__zram_bvec_read
+++ a/drivers/block/zram/zram_drv.c
@@ -518,7 +518,7 @@ static void zram_free_page(struct zram *
 	zram_set_obj_size(zram, index, 0);
 }
 
-static int zram_decompress_page(struct zram *zram, struct page *page, u32 index)
+static int __zram_bvec_read(struct zram *zram, struct page *page, u32 index)
 {
 	int ret;
 	unsigned long handle;
@@ -570,7 +570,7 @@ static int zram_bvec_read(struct zram *z
 			return -ENOMEM;
 	}
 
-	ret = zram_decompress_page(zram, page, index);
+	ret = __zram_bvec_read(zram, page, index);
 	if (unlikely(ret))
 		goto out;
 
@@ -717,7 +717,7 @@ static int zram_bvec_write(struct zram *
 		if (!page)
 			return -ENOMEM;
 
-		ret = zram_decompress_page(zram, page, index);
+		ret = __zram_bvec_read(zram, page, index);
 		if (ret)
 			goto out;
 
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch
zram-inlining-zram_compress.patch
zram-rename-zram_decompress_page-with-__zram_bvec_read.patch
zram-add-interface-to-specify-backing-device.patch
zram-add-free-space-management-in-backing-device.patch
zram-identify-asynchronous-ios-return-value.patch
zram-write-incompressible-pages-to-backing-device.patch
zram-read-page-from-backing-device.patch
zram-add-config-and-doc-file-for-writeback-feature.patch

