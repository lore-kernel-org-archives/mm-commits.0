From: akpm@linux-foundation.org
Subject: [merged] zram-delay-pending-free-request-in-read-path.patch
 removed from -mm tree
Date: Fri, 31 Jan 2014 11:16:23 -0800
Message-ID: <52ebf687.WSuP35wsrpAhfZ4O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, minchan@kernel.org

Subject: [merged] zram-delay-pending-free-request-in-read-path.patch removed from -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:23 -0800


The patch titled
     Subject: zram: delay pending free request in read path
has been removed from the -mm tree.  Its filename was
     zram-delay-pending-free-request-in-read-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: delay pending free request in read path

Sergey reported we don't need to handle pending free request every I/O so
that this patch removes it in read path while we remain it in write path.

Let's consider below example.

Swap subsystem ask to zram "A" block free by swap_slot_free_notify but
zram had been pended it without real freeing.  Swap subsystem allocates
"A" block for new data but request pended for a long time just handled and
zram blindly free new data on the "A" block.  :(

That's why we couldn't remove handle pending free request right before
zram-write.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-delay-pending-free-request-in-read-path drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-delay-pending-free-request-in-read-path
+++ a/drivers/block/zram/zram_drv.c
@@ -535,7 +535,6 @@ static int zram_bvec_rw(struct zram *zra
 
 	if (rw == READ) {
 		down_read(&zram->lock);
-		handle_pending_slot_free(zram);
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
 		up_read(&zram->lock);
 	} else {
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
debugging-keep-track-of-page-owners.patch

