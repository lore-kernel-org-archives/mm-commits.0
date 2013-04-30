From: akpm@linux-foundation.org
Subject: [merged] fs-block_devc-fix-iov_shorten-criteria-in-blkdev_aio_read.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:03:14 -0700
Message-ID: <20130430190314.7E7015A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:44074 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab3D3TDQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:03:16 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so78262ves.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:03:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guz.fnst@cn.fujitsu.com, axboe@kernel.dk, majianpeng@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/block_dev.c: fix iov_shorten() criteria in blkdev_aio_read()
has been removed from the -mm tree.  Its filename was
     fs-block_devc-fix-iov_shorten-criteria-in-blkdev_aio_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

