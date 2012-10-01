From: akpm@linux-foundation.org
Subject: + memstick-memory-leak-on-error-in-msb_ftl_scan.patch added to -mm tree
Date: Mon, 01 Oct 2012 15:06:23 -0700
Message-ID: <20121001220624.9F6CC5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:60146 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2JAWG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 18:06:27 -0400
Received: by wgbdt11 with SMTP id dt11so333619wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 15:06:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, axboe@kernel.dk, maximlevitsly@gmail.com


The patch titled
     Subject: memstick: memory leak on error in msb_ftl_scan()
has been added to the -mm tree.  Its filename is
     memstick-memory-leak-on-error-in-msb_ftl_scan.patch

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
Subject: memstick: memory leak on error in msb_ftl_scan()

We need to free "overwrite_flags" before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Maxim Levitsky <maximlevitsly@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/ms_block.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/memstick/core/ms_block.c~memstick-memory-leak-on-error-in-msb_ftl_scan drivers/memstick/core/ms_block.c
--- a/drivers/memstick/core/ms_block.c~memstick-memory-leak-on-error-in-msb_ftl_scan
+++ a/drivers/memstick/core/ms_block.c
@@ -1408,8 +1408,10 @@ static int msb_ftl_scan(struct msb_data 
 			msb_mark_block_used(msb, pba);
 			msb_erase_block(msb, pba);
 			continue;
-		} else if (error)
+		} else if (error) {
+			kfree(overwrite_flags);
 			return error;
+		}
 
 		lba = be16_to_cpu(extra.logical_address);
 		managment_flag = extra.management_flag;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix.patch
checkpatch-update-suggested-printk-conversions.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch
memstick-use-after-free-in-msb_disk_release.patch
memstick-memory-leak-on-error-in-msb_ftl_scan.patch

