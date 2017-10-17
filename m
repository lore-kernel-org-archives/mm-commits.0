From: akpm@linux-foundation.org
Subject: + zram-make-function-zram_page_end_io-static.patch added to -mm
 tree
Date: Tue, 17 Oct 2017 15:31:28 -0700
Message-ID: <59e684c0.6WCdsx6BXrLGOQp3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935130AbdJQWb3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:31:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/block/zram/zram_drv.c: make zram_page_end_io() static
has been added to the -mm tree.  Its filename is
     zram-make-function-zram_page_end_io-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-make-function-zram_page_end_io-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-make-function-zram_page_end_io-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: drivers/block/zram/zram_drv.c: make zram_page_end_io() static

zram_page_end_io() is local to the source and does not need to be in
global scope, so make it static.

Cleans up sparse warning:
symbol 'zram_page_end_io' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20171016173336.20320-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-make-function-zram_page_end_io-static drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-make-function-zram_page_end_io-static
+++ a/drivers/block/zram/zram_drv.c
@@ -428,7 +428,7 @@ static void put_entry_bdev(struct zram *
 	WARN_ON_ONCE(!was_set);
 }
 
-void zram_page_end_io(struct bio *bio)
+static void zram_page_end_io(struct bio *bio)
 {
 	struct page *page = bio->bi_io_vec[0].bv_page;
 
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-rmap-remove-redundant-variable-cend.patch
zram-make-function-zram_page_end_io-static.patch

