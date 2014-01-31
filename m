From: akpm@linux-foundation.org
Subject: [merged] zram-remove-unnecessary-free.patch removed from -mm tree
Date: Fri, 31 Jan 2014 11:16:25 -0800
Message-ID: <52ebf689.Hba4kBwrnC6cExS8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, minchan@kernel.org

Subject: [merged] zram-remove-unnecessary-free.patch removed from -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:25 -0800


The patch titled
     Subject: zram: remove unnecessary free
has been removed from the -mm tree.  Its filename was
     zram-remove-unnecessary-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: remove unnecessary free

a0c516cbfc ("zram: don't grab mutex in zram_slot_free_noity") introduced
pending zram slot free in zram's write path in case of missing slot free
by memory allocation failure in zram_slot_free_notify but it is not
necessary because we have already freed the slot right before overwriting.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-unnecessary-free drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-unnecessary-free
+++ a/drivers/block/zram/zram_drv.c
@@ -441,14 +441,6 @@ static int zram_bvec_write(struct zram *
 		goto out;
 	}
 
-	/*
-	 * zram_slot_free_notify could miss free so that let's
-	 * double check.
-	 */
-	if (unlikely(meta->table[index].handle ||
-			zram_test_flag(meta, index, ZRAM_ZERO)))
-		zram_free_page(zram, index);
