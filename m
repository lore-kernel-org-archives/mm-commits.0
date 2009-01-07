From: akpm@linux-foundation.org
Subject: - fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:53 -0800
Message-ID: <200901072213.n07MDr8N013904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757250AbZAGWOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de, pbadari@us.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs: truncate blocks outside i_size after O_DIRECT write error
has been removed from the -mm tree.  Its filename was
     fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: truncate blocks outside i_size after O_DIRECT write error
From: Dmitri Monakhov <dmonakhov@openvz.org>

In case of error extending write may have instantiated a few blocks
outside i_size.  We need to trim these blocks.  We have to do it
*regardless* to blocksize.  At least ext2, ext3 and reiserfs interpret
(i_size < biggest block) condition as error.  Fsck will complain about
wrong i_size.  Then fsck will fix the error by changing i_size according
to the biggest block.  This is bad because this blocks contain garbage
from previous write attempt.  And result in data corruption.

####TESTCASE_BEGIN
$touch /mnt/test/BIG_FILE
## at this moment /mnt/test/BIG_FILE size and blocks equal to zero
open("/mnt/test/BIG_FILE", O_WRONLY|O_CREAT|O_DIRECT, 0666) = 3
write(3, "aaaaaaaaaaaa"..., 104857600) = -1 ENOSPC (No space left on device)
## size and block sould't be changed because write op failed.
$stat /mnt/test/BIG_FILE
File: `/mnt/test/BIG_FILE'
Size: 0 Blocks: 110896 IO Block: 1024 regular empty file
<<<<<<<<^^^^^^^^^^^^^^^^^^^^^^^^^^^^^file size is less than biggest block idx
Device: fe07h/65031d Inode: 14 Links: 1
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
Access: 2007-01-24 20:03:38.000000000 +0300
Modify: 2007-01-24 20:03:38.000000000 +0300
Change: 2007-01-24 20:03:39.000000000 +0300

#fsck.ext3 -f /dev/VG/test
e2fsck 1.39 (29-May-2006)
Pass 1: Checking inodes, blocks, and sizes
Inode 14, i_size is 0, should be 56556544. Fix<y>? yes
Pass 2: Checking directory structure
....
#####TESTCASE_ENDdiff --git a/fs/direct-io.c b/fs/direct-io.c
index af0558d..4e88bea 100644

[akpm@linux-foundation.org: use i_size_read()]
Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN fs/direct-io.c~fs-truncate-blocks-outside-i_size-after-o_direct-write-error fs/direct-io.c
--- a/fs/direct-io.c~fs-truncate-blocks-outside-i_size-after-o_direct-write-error
+++ a/fs/direct-io.c
@@ -1209,6 +1209,19 @@ __blockdev_direct_IO(int rw, struct kioc
 	retval = direct_io_worker(rw, iocb, inode, iov, offset,
 				nr_segs, blkbits, get_block, end_io, dio);
 
+	/*
+	 * In case of error extending write may have instantiated a few
+	 * blocks outside i_size. Trim these off again for DIO_LOCKING.
+	 * NOTE: DIO_NO_LOCK/DIO_OWN_LOCK callers have to handle this by
+	 * it's own meaner.
+	 */
+	if (unlikely(retval < 0 && (rw & WRITE))) {
+		loff_t isize = i_size_read(inode);
+
+		if (end > isize && dio_lock_type == DIO_LOCKING)
+			vmtruncate(inode, isize);
+	}
+
 	if (rw == READ && dio_lock_type == DIO_LOCKING)
 		release_i_mutex = 0;
 
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

origin.patch

