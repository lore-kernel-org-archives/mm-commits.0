From: akpm@linux-foundation.org
Subject: [merged] floppy-scsi-fix-setting-of-bio-flags.patch removed from -mm tree
Date: Tue, 06 Mar 2012 11:35:12 -0800
Message-ID: <20120306193512.5F4E5A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:61832 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965176Ab2CFTfN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 14:35:13 -0500
Received: by yhgm50 with SMTP id m50so681770yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 11:35:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muthu.lkml@gmail.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, muthur@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: floppy/scsi: fix setting of BIO flags
has been removed from the -mm tree.  Its filename was
     floppy-scsi-fix-setting-of-bio-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: floppy/scsi: fix setting of BIO flags

Fix setting bio flags in drivers (sd_dif/floppy).

Signed-off-by: Muthukumar R <muthur@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    2 +-
 drivers/scsi/sd_dif.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/floppy.c~floppy-scsi-fix-setting-of-bio-flags drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-scsi-fix-setting-of-bio-flags
+++ a/drivers/block/floppy.c
@@ -3832,7 +3832,7 @@ static int __floppy_read_block_0(struct 
 	bio.bi_size = size;
 	bio.bi_bdev = bdev;
 	bio.bi_sector = 0;
-	bio.bi_flags = BIO_QUIET;
+	bio.bi_flags = (1 << BIO_QUIET);
 	init_completion(&complete);
 	bio.bi_private = &complete;
 	bio.bi_end_io = floppy_rb0_complete;
diff -puN drivers/scsi/sd_dif.c~floppy-scsi-fix-setting-of-bio-flags drivers/scsi/sd_dif.c
--- a/drivers/scsi/sd_dif.c~floppy-scsi-fix-setting-of-bio-flags
+++ a/drivers/scsi/sd_dif.c
@@ -408,7 +408,7 @@ int sd_dif_prepare(struct request *rq, s
 			kunmap_atomic(sdt, KM_USER0);
 		}
 
-		bio->bi_flags |= BIO_MAPPED_INTEGRITY;
+		bio->bi_flags |= (1 << BIO_MAPPED_INTEGRITY);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from muthu.lkml@gmail.com are

origin.patch
magich-move-some-fs-magic-numbers-into-magich.patch

