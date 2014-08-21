From: akpm@linux-foundation.org
Subject: + vfs-guard-end-of-device-for-mpage-interface.patch added to -mm
 tree
Date: Thu, 21 Aug 2014 14:44:18 -0700
Message-ID: <53f66832.UjZNsspKrMSI9JX+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:40573 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbaHUVoU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 17:44:20 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2685649pde.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 14:44:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, axboe@kernel.dk, jmoyer@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: guard end of device for mpage interface
has been added to the -mm tree.  Its filename is
     vfs-guard-end-of-device-for-mpage-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-guard-end-of-device-for-mpage-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-guard-end-of-device-for-mpage-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: vfs: guard end of device for mpage interface

Add guard_bio_eod() check for mpage code in order to allow us to do IO
even on the odd last sectors of a device, even if the block size is some
multiple of the physical sector size.

Using mpage_readpages() for block device requires this guard check.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c   |    2 +-
 fs/internal.h |    5 +++++
 fs/mpage.c    |    2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/buffer.c~vfs-guard-end-of-device-for-mpage-interface fs/buffer.c
--- a/fs/buffer.c~vfs-guard-end-of-device-for-mpage-interface
+++ a/fs/buffer.c
@@ -2964,7 +2964,7 @@ static void end_bio_bh_io_sync(struct bi
  * errors, this only handles the "we need to be able to
  * do IO at the final sector" case.
  */
-static void guard_bio_eod(int rw, struct bio *bio)
+void guard_bio_eod(int rw, struct bio *bio)
 {
 	sector_t maxsector;
 	struct bio_vec *bvec = &bio->bi_io_vec[bio->bi_vcnt - 1];
diff -puN fs/internal.h~vfs-guard-end-of-device-for-mpage-interface fs/internal.h
--- a/fs/internal.h~vfs-guard-end-of-device-for-mpage-interface
+++ a/fs/internal.h
@@ -35,6 +35,11 @@ static inline int __sync_blockdev(struct
 #endif
 
 /*
+ * buffer.c
+ */
+extern void guard_bio_eod(int rw, struct bio *bio);
+
+/*
  * char_dev.c
  */
 extern void __init chrdev_init(void);
diff -puN fs/mpage.c~vfs-guard-end-of-device-for-mpage-interface fs/mpage.c
--- a/fs/mpage.c~vfs-guard-end-of-device-for-mpage-interface
+++ a/fs/mpage.c
@@ -28,6 +28,7 @@
 #include <linux/backing-dev.h>
 #include <linux/pagevec.h>
 #include <linux/cleancache.h>
+#include "internal.h"
 
 /*
  * I/O completion handler for multipage BIOs.
@@ -57,6 +58,7 @@ static void mpage_end_io(struct bio *bio
 static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
 	bio->bi_end_io = mpage_end_io;
+	guard_bio_eod(rw, bio);
 	submit_bio(rw, bio);
 	return NULL;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

vfs-make-guard_bh_eod-more-generic.patch
vfs-guard-end-of-device-for-mpage-interface.patch
block_dev-implement-readpages-to-optimize-sequential-read.patch
linux-next.patch

