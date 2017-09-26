From: akpm@linux-foundation.org
Subject: + zram-fix-null-dereference-of-handle-v2.patch added to -mm tree
Date: Tue, 26 Sep 2017 15:58:49 -0700
Message-ID: <59cadba9.fME+fOhTEaEHAZPX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37530 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031323AbdIZXA3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2017 19:00:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-fix-null-dereference-of-handle-v2
has been added to the -mm tree.  Its filename is
     zram-fix-null-dereference-of-handle-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-fix-null-dereference-of-handle-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-fix-null-dereference-of-handle-v2.patch

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
Subject: zram-fix-null-dereference-of-handle-v2

* From v1:
  * remove unlikely branch - Sergey
  * In !handle case, use 0 instead of zram_get_element - Sergey

Link: http://lkml.kernel.org/r/1505887347-10881-1-git-send-email-minchan@kernel.org
Fixes: 1f7319c74275 ("zram: partial IO refactoring")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-fix-null-dereference-of-handle-v2 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-fix-null-dereference-of-handle-v2
+++ a/drivers/block/zram/zram_drv.c
@@ -865,11 +865,13 @@ static int __zram_bvec_read(struct zram
 
 	zram_slot_lock(zram, index);
 	handle = zram_get_handle(zram, index);
-	if (unlikely(!handle || zram_test_flag(zram, index, ZRAM_SAME))) {
+	if (!handle || zram_test_flag(zram, index, ZRAM_SAME)) {
+		unsigned long value;
 		void *mem;
 
+		value = handle ? zram_get_element(zram, index) : 0;
 		mem = kmap_atomic(page);
-		zram_fill_page(mem, PAGE_SIZE, zram_get_element(zram, index));
+		zram_fill_page(mem, PAGE_SIZE, value);
 		kunmap_atomic(mem);
 		zram_slot_unlock(zram, index);
 		return 0;
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-fix-null-dereference-of-handle.patch
zram-fix-null-dereference-of-handle-v2.patch

