From: akpm@linux-foundation.org
Subject: [merged] direct-io-remove-some-left-over-checks.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:30:46 -0700
Message-ID: <533f0866./M5ctNXZiPtEDhh7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaDDTaq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com

Subject: [merged] direct-io-remove-some-left-over-checks.patch removed from -mm tree
To: dan.carpenter@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:46 -0700


The patch titled
     Subject: fs/direct-io.c: remove some left over checks
has been removed from the -mm tree.  Its filename was
     direct-io-remove-some-left-over-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: fs/direct-io.c: remove some left over checks

We know that "ret > 0" is true here.  These tests were left over from
02afc27faec9 ('direct-io: Handle O_(D)SYNC AIO') and aren't needed any
more.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c  |    2 +-
 fs/btrfs/file.c |    2 +-
 fs/ext4/file.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/block_dev.c~direct-io-remove-some-left-over-checks fs/block_dev.c
--- a/fs/block_dev.c~direct-io-remove-some-left-over-checks
+++ a/fs/block_dev.c
@@ -1523,7 +1523,7 @@ ssize_t blkdev_aio_write(struct kiocb *i
 		ssize_t err;
 
 		err = generic_write_sync(file, pos, ret);
-		if (err < 0 && ret > 0)
+		if (err < 0)
 			ret = err;
 	}
 	blk_finish_plug(&plug);
diff -puN fs/btrfs/file.c~direct-io-remove-some-left-over-checks fs/btrfs/file.c
--- a/fs/btrfs/file.c~direct-io-remove-some-left-over-checks
+++ a/fs/btrfs/file.c
@@ -1797,7 +1797,7 @@ static ssize_t btrfs_file_aio_write(stru
 	BTRFS_I(inode)->last_sub_trans = root->log_transid;
 	if (num_written > 0) {
 		err = generic_write_sync(file, pos, num_written);
-		if (err < 0 && num_written > 0)
+		if (err < 0)
 			num_written = err;
 	}
 
diff -puN fs/ext4/file.c~direct-io-remove-some-left-over-checks fs/ext4/file.c
--- a/fs/ext4/file.c~direct-io-remove-some-left-over-checks
+++ a/fs/ext4/file.c
@@ -153,7 +153,7 @@ ext4_file_dio_write(struct kiocb *iocb,
 		ssize_t err;
 
 		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
-		if (err < 0 && ret > 0)
+		if (err < 0)
 			ret = err;
 	}
 	blk_finish_plug(&plug);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
ncpfs-cleanup-indenting-in-ncp_lookup.patch
drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little.patch
linux-next.patch

