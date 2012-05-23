From: akpm@linux-foundation.org
Subject: [merged] floppy-remove-floppy-specific-o_excl-handling.patch removed from -mm tree
Date: Wed, 23 May 2012 12:51:13 -0700
Message-ID: <20120523195113.7249EA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:54639 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab2EWTvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:51:15 -0400
Received: by wgbdt11 with SMTP id dt11so494314wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:51:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, axboe@kernel.dk, joe@perches.com, neilb@suse.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: floppy: remove floppy-specific O_EXCL handling
has been removed from the -mm tree.  Its filename was
     floppy-remove-floppy-specific-o_excl-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: floppy: remove floppy-specific O_EXCL handling

Block layer now handles O_EXCL in a generic way for block devices.

The semantics is however different for floppy and all other block devices,
as floppy driver contains its own O_EXCL handling.

The semantics for all-but-floppy bdevs is "there can be at most one O_EXCL
open of this file", while for floppy bdev the semantics is "if someone has
the bdev open with O_EXCL, noone else can open it".

There is actual userspace-observable change in behavior because of this
since commit e525fd89d380c ("block: make blkdev_get/put() handle exclusive
access") -- on kernels containing this commit, mount of /dev/fd0 causes
the fd0 block device be claimed with _EXCL, preventing subsequent
open(/dev/fd0).

Bring things back into shape, i.e.  make it possible, analogically to
other block devices, to mount the floppy and open() it afterwards --
remove the floppy-specific handling and let the generic bdev code O_EXCL
handling take over.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/block/floppy.c~floppy-remove-floppy-specific-o_excl-handling drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-remove-floppy-specific-o_excl-handling
+++ a/drivers/block/floppy.c
@@ -3650,13 +3650,7 @@ static int floppy_open(struct block_devi
 		set_bit(FD_VERIFY_BIT, &UDRS->flags);
 	}
 
-	if (UDRS->fd_ref == -1 || (UDRS->fd_ref && (mode & FMODE_EXCL)))
-		goto out2;
