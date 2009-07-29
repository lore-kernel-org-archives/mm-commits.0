From: akpm@linux-foundation.org
Subject: [merged] mg_disk-remove-prohibited-sleep-operation.patch removed from -mm tree
Date: Wed, 29 Jul 2009 12:35:23 -0700
Message-ID: <200907291935.n6TJZNww003487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbZG2TgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 15:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: donari75@gmail.com, jens.axboe@oracle.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mg_disk: remove prohibited sleep operation
has been removed from the -mm tree.  Its filename was
     mg_disk-remove-prohibited-sleep-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

