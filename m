From: akpm@linux-foundation.org
Subject: + floppy-scsi-fix-setting-of-bio-flags.patch added to -mm tree
Date: Wed, 29 Feb 2012 16:05:15 -0800
Message-ID: <20120301000515.A37CAA023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:49390 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2CAAFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Feb 2012 19:05:17 -0500
Received: by ghbz15 with SMTP id z15so2932ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 29 Feb 2012 16:05:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muthu.lkml@gmail.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, muthur@gmail.com


The patch titled
     Subject: floppy/scsi: fix setting of BIO flags
has been added to the -mm tree.  Its filename is
     floppy-scsi-fix-setting-of-bio-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 			kunmap_atomic(sdt);
 		}
 
-		bio->bi_flags |= BIO_MAPPED_INTEGRITY;
+		bio->bi_flags |= (1 << BIO_MAPPED_INTEGRITY);
 	}
 
 	return 0;
_
Subject: Subject: floppy/scsi: fix setting of BIO flags

Patches currently in -mm which might be from muthu.lkml@gmail.com are

floppy-scsi-fix-setting-of-bio-flags.patch
magich-move-some-fs-magic-numbers-into-magich.patch

