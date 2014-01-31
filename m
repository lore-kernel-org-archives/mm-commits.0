From: akpm@linux-foundation.org
Subject: [merged]
 zram-fix-race-between-reset-and-flushing-pending-work.patch removed from
 -mm tree
Date: Fri, 31 Jan 2014 11:16:21 -0800
Message-ID: <52ebf685.SVqd7M11NIM/mtQg%akpm__41139.180181972$1391195799$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, dan.carpenter@oracle.com, minchan@kernel.org

Subject: [merged] zram-fix-race-between-reset-and-flushing-pending-work.patch removed from -mm tree
To: minchan@kernel.org,dan.carpenter@oracle.com,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:21 -0800


The patch titled
     Subject: zram: fix race between reset and flushing pending work
has been removed from the -mm tree.  Its filename was
     zram-fix-race-between-reset-and-flushing-pending-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: fix race between reset and flushing pending work

Dan and Sergey reported that there is a racy between reset and flushing of
pending work so that it could make oops by freeing zram->meta in reset
while zram_slot_free can access zram->meta if new request is adding during
the race window.

This patch moves flush after taking init_lock so it prevents new request
so that it closes the race.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-fix-race-between-reset-and-flushing-pending-work drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-fix-race-between-reset-and-flushing-pending-work
+++ a/drivers/block/zram/zram_drv.c
@@ -553,14 +553,14 @@ static void zram_reset_device(struct zra
 	size_t index;
 	struct zram_meta *meta;
 
-	flush_work(&zram->free_work);
