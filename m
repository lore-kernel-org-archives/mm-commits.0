From: akpm@linux-foundation.org
Subject: + fs-block_devc-fix-iov_shorten-criteria-in-blkdev_aio_read.patch added to -mm tree
Date: Mon, 22 Apr 2013 14:09:10 -0700
Message-ID: <20130422210910.771E431C034@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:44420 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3DVVJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 17:09:11 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so742605qcr.2
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 14:09:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guz.fnst@cn.fujitsu.com, axboe@kernel.dk, majianpeng@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/block_dev.c: fix iov_shorten() criteria in blkdev_aio_read()
has been added to the -mm tree.  Its filename is
     fs-block_devc-fix-iov_shorten-criteria-in-blkdev_aio_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: fs/block_dev.c: fix iov_shorten() criteria in blkdev_aio_read()

blkdev_aio_read() test 'size' to see if it is equal or greater than the
target count we request(iocb->ki_left).  If so there is no need to call
iov_shorten() to reduce number of segments and the iovec's length.  So the
judgement should be changed to 'if (size < iocb->ki_left)' instead.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/block_dev.c~fs-block_devc-fix-iov_shorten-criteria-in-blkdev_aio_read fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-fix-iov_shorten-criteria-in-blkdev_aio_read
+++ a/fs/block_dev.c
@@ -1559,7 +1559,7 @@ static ssize_t blkdev_aio_read(struct ki
 		return 0;
 
 	size -= pos;
-	if (size < INT_MAX)
+	if (size < iocb->ki_left)
 		nr_segs = iov_shorten((struct iovec *)iov, nr_segs, size);
 	return generic_file_aio_read(iocb, iov, nr_segs, pos);
 }
_

Patches currently in -mm which might be from guz.fnst@cn.fujitsu.com are

fs-block_devc-fix-iov_shorten-criteria-in-blkdev_aio_read.patch

