From: akpm@linux-foundation.org
Subject: [merged] zram-revalidate-disk-under-init_lock.patch removed from
 -mm tree
Date: Wed, 11 Jan 2017 14:28:36 -0800
Message-ID: <5876b194.qLJ+CjMY3a0794GA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934099AbdAKW2r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 17:28:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, cheol.lee@lge.com, darrick.wong@oracle.com, hughd@google.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, tiwai@suse.de, yjay.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: revalidate disk under init_lock
has been removed from the -mm tree.  Its filename was
     zram-revalidate-disk-under-init_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: revalidate disk under init_lock

[1] moved revalidate_disk call out of init_lock to avoid lockdep
false-positive splat. However, [2] remove init_lock in IO path
so there is no worry about lockdep splat. So, let's restore it.
This patch need to set BDI_CAP_STABLE_WRITES atomically in
next patch.

[1] b4c5c60920e3: zram: avoid lockdep splat by revalidate_disk
[2] 08eee69fcf6b: zram: remove init_lock in zram_make_request

Fixes: da9556a2367c ("zram: user per-cpu compression streams")
Link: http://lkml.kernel.org/r/1482366980-3782-3-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>
Cc: <yjay.kim@lge.com>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: <stable@vger.kernel.org> [4.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-revalidate-disk-under-init_lock drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-revalidate-disk-under-init_lock
+++ a/drivers/block/zram/zram_drv.c
@@ -1095,14 +1095,8 @@ static ssize_t disksize_store(struct dev
 	zram->comp = comp;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	up_write(&zram->init_lock);
