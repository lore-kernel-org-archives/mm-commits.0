From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-extend-zero-pages-to-same-element-pages-fix.patch removed from -mm
 tree
Date: Fri, 24 Feb 2017 14:42:09 -0800
Message-ID: <58b0b6c1.hUcch4wOB8UKBzku%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35868 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXWmK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:42:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, iamjoonsoo.kim@lge.com, sergey.senozhatsky@gmail.com, zhouxianrong@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: do not free same element pages in zram_meta_free
has been removed from the -mm tree.  Its filename was
     zram-extend-zero-pages-to-same-element-pages-fix.patch

This patch was dropped because it was folded into zram-extend-zero-pages-to-same-element-pages.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: do not free same element pages in zram_meta_free

zhouxianrong pointed out that we shouldn't free same element pages in
zram_meta_free.  Otherwise, it will encounter oops due to invalid handle
value.

Link: http://lkml.kernel.org/r/20170207065741.GA2567@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: zhouxianrong <zhouxianrong@huawei.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-extend-zero-pages-to-same-element-pages-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-extend-zero-pages-to-same-element-pages-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -425,8 +425,11 @@ static void zram_meta_free(struct zram_m
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++) {
 		unsigned long handle = meta->table[index].handle;
