From: akpm@linux-foundation.org
Subject: + mg_disk-remove-prohibited-sleep-operation.patch added to -mm tree
Date: Mon, 27 Jul 2009 14:33:04 -0700
Message-ID: <200907272133.n6RLX4NE012506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796AbZG0Vm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 17:42:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: donari75@gmail.com, jens.axboe@oracle.com, tj@kernel.org


The patch titled
     mg_disk: remove prohibited sleep operation
has been added to the -mm tree.  Its filename is
     mg_disk-remove-prohibited-sleep-operation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mg_disk: remove prohibited sleep operation
From: unsik Kim <donari75@gmail.com>

mflash's polling driver operate in standard request_fn_proc's context,
sleep in this isn't permitted.

Signed-off-by: unsik Kim <donari75@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/mg_disk.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/block/mg_disk.c~mg_disk-remove-prohibited-sleep-operation drivers/block/mg_disk.c
--- a/drivers/block/mg_disk.c~mg_disk-remove-prohibited-sleep-operation
+++ a/drivers/block/mg_disk.c
@@ -245,8 +245,6 @@ static unsigned int mg_wait(struct mg_ho
 			mg_dump_status("not ready", status, host);
 			return MG_ERR_INV_STAT;
 		}
-		if (prv_data->use_polling)
-			msleep(1);
 
 		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
 	} while (time_before(cur_jiffies, expire));
_

Patches currently in -mm which might be from donari75@gmail.com are

mg_disk-remove-prohibited-sleep-operation.patch
mg_disk-fix-reading-invalid-status-when-use-polling-driver.patch

