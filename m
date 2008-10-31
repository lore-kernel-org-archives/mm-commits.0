From: akpm@linux-foundation.org
Subject: - fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error.patch removed from -mm tree
Date: Thu, 30 Oct 2008 17:43:30 -0700
Message-ID: <200810310043.m9V0hUSr030660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731AbYJaAnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 20:43:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, jmoyer@redhat.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     fs: truncate blocks outside i_size after generic_file_direct_write error
has been removed from the -mm tree.  Its filename was
     fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: truncate blocks outside i_size after generic_file_direct_write error
From: Dmitri Monakhov <dmonakhov@openvz.org>

We need to remove block that was allocated in generic_file_direct_write()
if we fail.  We have to do it *regardless* to blocksize.  At least ext2,
ext3 and reiserfs interpret (i_size < biggest block) condition as error. 
Fsck will complain about wrong i_size.  Then fsck will fix the error by
changing i_size according to the biggest block.  This is bad because this
blocks contain gurbage from previous write attempt.  And result in data
corruption.

In order to call vmtruncate() we have to hold host->i_mutex.  This is true
for generic_file_aio_write().  In fact occasionally it is also true for
all generic_file_aio_write_nolock() callers except blockdev.  But this
situation may change someday.  This patch fix only
generic_write_aio_write() case.  BTW: update generic_file_direct_write's
comment with currently outdated.

testcase:

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


Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff -puN mm/filemap.c~fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error mm/filemap.c
--- a/mm/filemap.c~fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error
+++ a/mm/filemap.c
@@ -2121,8 +2121,10 @@ generic_file_direct_write(struct kiocb *
 	/*
 	 * Sync the fs metadata but not the minor inode changes and
 	 * of course not the data as we did direct DMA for the IO.
-	 * i_mutex is held, which protects generic_osync_inode() from
-	 * livelocking.  AIO O_DIRECT ops attempt to sync metadata here.
+	 * i_mutex is held in case of DIO_LOCKING, which protects
+	 * generic_osync_inode() from livelocking. If it is not held, then
+	 * the filesystem must prevent this livelock by its own meaner.
+	 * AIO O_DIRECT ops attempt to sync metadata here.
 	 */
 out:
 	if ((written >= 0 || written == -EIOCBQUEUED) &&
@@ -2293,7 +2295,8 @@ EXPORT_SYMBOL(generic_file_buffered_writ
 
 static ssize_t
 __generic_file_aio_write_nolock(struct kiocb *iocb, const struct iovec *iov,
-				unsigned long nr_segs, loff_t *ppos)
+				unsigned long nr_segs, loff_t *ppos,
+				int lock_type)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space * mapping = file->f_mapping;
@@ -2338,7 +2341,18 @@ __generic_file_aio_write_nolock(struct k
 
 		written = generic_file_direct_write(iocb, iov, &nr_segs, pos,
 							ppos, count, ocount);
-		if (written < 0 || written == count)
+		if (written < 0) {
+			if (lock_type == DIO_LOCKING) {
+				/*
+				 * direct write may have instantiated a few
+				 * blocks outside i_size. Trim these off again.
+				 */
+				if (pos + count > inode->i_size)
+					vmtruncate(inode, inode->i_size);
+			}
+			goto out;
+		}
+		if (written == count)
 			goto out;
 		/*
 		 * direct-io write to a hole: fall through to buffered I/O
@@ -2402,7 +2416,7 @@ ssize_t generic_file_aio_write_nolock(st
 	BUG_ON(iocb->ki_pos != pos);
 
 	ret = __generic_file_aio_write_nolock(iocb, iov, nr_segs,
-			&iocb->ki_pos);
+					&iocb->ki_pos, DIO_OWN_LOCKING);
 
 	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		ssize_t err;
@@ -2427,7 +2441,7 @@ ssize_t generic_file_aio_write(struct ki
 
 	mutex_lock(&inode->i_mutex);
 	ret = __generic_file_aio_write_nolock(iocb, iov, nr_segs,
-			&iocb->ki_pos);
+					&iocb->ki_pos, DIO_LOCKING);
 	mutex_unlock(&inode->i_mutex);
 
 	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

linux-next.patch
kill-suid-bit-only-for-regular-files.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch

