From: akpm@linux-foundation.org
Subject: + zram-read-page-from-backing-device-fix.patch added to -mm tree
Date: Mon, 14 Aug 2017 14:36:58 -0700
Message-ID: <599217fa.cbzgCwff/WuGKtRk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56980 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752373AbdHNVg7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2017 17:36:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, juno.choi@lge.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-read-page-from-backing-device-fix
has been added to the -mm tree.  Its filename is
     zram-read-page-from-backing-device-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-read-page-from-backing-device-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-read-page-from-backing-device-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: zram-read-page-from-backing-device-fix

* read_from_bdev_async() return 1 to avoid call page_endio() in zram_rw_page()

Link: http://lkml.kernel.org/r/1502707447-6944-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Juneho Choi <juno.choi@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-read-page-from-backing-device-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-read-page-from-backing-device-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -455,7 +455,7 @@ void zram_page_end_io(struct bio *bio)
 }
 
 /*
- * Returns 0 if the submission is successful.
+ * Returns 1 if the submission is successful.
  */
 static int read_from_bdev_async(struct zram *zram, struct bio_vec *bvec,
 			unsigned long entry, struct bio *parent)
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

zram-clean-up-duplicated-codes-in-__zram_bvec_write-fix.patch
zram-write-incompressible-pages-to-backing-device-fix.patch
zram-read-page-from-backing-device-fix.patch

