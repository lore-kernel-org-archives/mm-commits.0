From: akpm@linux-foundation.org
Subject: + zram-count-same-page-write-as-page_stored.patch added to -mm
 tree
Date: Mon, 15 May 2017 14:56:20 -0700
Message-ID: <591a2404.wATO5gw4VwNYJN19%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49358 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdEOV40 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 17:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, iamjoonsoo.kim@lge.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: count same page write as page_stored
has been added to the -mm tree.  Its filename is
     zram-count-same-page-write-as-page_stored.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-count-same-page-write-as-page_stored.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-count-same-page-write-as-page_stored.patch

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
Subject: zram: count same page write as page_stored

Regardless of whether it is same page or not, it's surely write and stored
to zram so we should increase pages_stored stat.  Otherwise, user can see
zero value via mm_stats although he writes a lot of pages to zram.

Link: http://lkml.kernel.org/r/1494834068-27004-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-count-same-page-write-as-page_stored drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-count-same-page-write-as-page_stored
+++ a/drivers/block/zram/zram_drv.c
@@ -516,6 +516,7 @@ static bool zram_same_page_write(struct
 		zram_slot_unlock(zram, index);
 
 		atomic64_inc(&zram->stats.same_pages);
+		atomic64_inc(&zram->stats.pages_stored);
 		return true;
 	}
 	kunmap_atomic(mem);
@@ -619,6 +620,7 @@ static void zram_free_page(struct zram *
 		zram_clear_flag(zram, index, ZRAM_SAME);
 		zram_set_element(zram, index, 0);
 		atomic64_dec(&zram->stats.same_pages);
+		atomic64_dec(&zram->stats.pages_stored);
 		return;
 	}
 
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-count-same-page-write-as-page_stored.patch
zram-do-not-count-duplicated-pages-as-compressed.patch
mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page.patch
mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan.patch

