From: akpm@linux-foundation.org
Subject: [patch 23/27] zram: revalidate disk under init_lock
Date: Tue, 10 Jan 2017 16:58:18 -0800
Message-ID: <5875832a.zSA7gBNe6kOFJ+ZS%akpm__21250.4540839747$1484096364$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33528 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759973AbdAKA6T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2017 19:58:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, cheol.lee@lge.com, darrick.wong@oracle.com, hughd@google.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, tiwai@suse.de, yjay.kim@lge.com

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
