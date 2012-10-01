From: akpm@linux-foundation.org
Subject: + memstick-use-after-free-in-msb_disk_release.patch added to -mm tree
Date: Mon, 01 Oct 2012 15:06:19 -0700
Message-ID: <20121001220620.8C9851E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:35940 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2JAWGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 18:06:22 -0400
Received: by yenr11 with SMTP id r11so714357yen.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 15:06:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, axboe@kernel.dk, maximlevitsly@gmail.com


The patch titled
     Subject: memstick: use after free in msb_disk_release()
has been added to the -mm tree.  Its filename is
     memstick-use-after-free-in-msb_disk_release.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: memstick: use after free in msb_disk_release()

The original code dereferenced "msb" after freeing it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Maxim Levitsky <maximlevitsly@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/ms_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/ms_block.c~memstick-use-after-free-in-msb_disk_release drivers/memstick/core/ms_block.c
--- a/drivers/memstick/core/ms_block.c~memstick-use-after-free-in-msb_disk_release
+++ a/drivers/memstick/core/ms_block.c
@@ -1983,9 +1983,9 @@ static int msb_disk_release(struct gendi
 			msb->usage_count--;
 
 		if (!msb->usage_count) {
-			kfree(msb);
 			disk->private_data = NULL;
 			idr_remove(&msb_disk_idr, msb->disk_id);
+			kfree(msb);
 			put_disk(disk);
 		}
 	}
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix.patch
checkpatch-update-suggested-printk-conversions.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch
memstick-use-after-free-in-msb_disk_release.patch
memstick-memory-leak-on-error-in-msb_ftl_scan.patch

