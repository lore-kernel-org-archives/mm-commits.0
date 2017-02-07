From: akpm@linux-foundation.org
Subject: + zram-extend-zero-pages-to-same-element-pages-fix.patch added to -mm tree
Date: Tue, 07 Feb 2017 14:51:13 -0800
Message-ID: <589a4f61.j32K9oYxiB7i1fol%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35892 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752392AbdBGWvO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2017 17:51:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, iamjoonsoo.kim@lge.com, sergey.senozhatsky@gmail.com, zhouxianrong@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: do not free same element pages in zram_meta_free
has been added to the -mm tree.  Its filename is
     zram-extend-zero-pages-to-same-element-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-extend-zero-pages-to-same-element-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-extend-zero-pages-to-same-element-pages-fix.patch

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
