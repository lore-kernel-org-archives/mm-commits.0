From: akpm@linux-foundation.org
Subject: + fs-writeback-handle-errors-in-sync_sb_inodes.patch added to -mm tree
Date: Tue, 27 May 2008 22:38:48 -0700
Message-ID: <200805280538.m4S5cmoE031238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbYE1Fiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 01:38:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guichaz@gmail.com


The patch titled
     fs-writeback: handle errors in sync_sb_inodes()
has been added to the -mm tree.  Its filename is
     fs-writeback-handle-errors-in-sync_sb_inodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-writeback: handle errors in sync_sb_inodes()
From: Guillaume Chazarain <guichaz@gmail.com>

Currently it is possible for some errors to be detected at write-back
time but not reported to the program as shown by the following script
using the included make_file.c. Undetected ENOSPC or EIO can obviously lead to
data corruption.

================
#!/bin/bash

# We binary search the size of a file in a 40M filesystem that can cause
# the missed error.
MIN=5000000
MAX=50000000

rm fs.40M
dd if=/dev/zero of=fs.40M bs=40M count=0 seek=1 status=noxfer
#mkfs.ext2 -F fs.40M
mkfs.ext3 -F fs.40M
#mkfs.jfs -q fs.40M
#mkfs.reiserfs -fq fs.40M
#mkfs.xfs fs.40M # SIGBUS in memset() with patch
# XFS => OK for ENOSPC, but not for EIO

attempt()
{
	SIZE=$1
	RES=0

	mount fs.40M /mnt -o loop
	if ! ./make_file /mnt/not_enough_space $SIZE; then
		# We could not create the file as the requested size
		# was clearly too big
		echo "/mnt/not_enough_space: not enough space for $SIZE bytes"
		RES=1
	fi
	umount /mnt

	if [ $RES -eq 0 ]; then
		# We think we could create the file, let's see if that's true
		mount fs.40M /mnt -o loop
		cmp <(tr '\000' '\377' < /dev/zero | head -c$SIZE) \
		    /mnt/not_enough_space
		RES=$?
		umount /mnt

		if [ $RES -eq 0 ]; then
			# The file was small enough to fit in the filesystem
			RES=-1
		else
			echo "Undetected ENOSPC with SIZE=$SIZE"
			exit
		fi
	fi

	return $RES
}

while [ $((MAX - MIN)) -gt 1 ]; do
	SIZE=$(((MIN + MAX) / 2))
	attempt $SIZE
	RES=$?
	if [ $RES -eq 1 ]; then
		MAX=$SIZE
	else
		MIN=$SIZE
	fi
done

echo "Could not reproduce the problem"
==================
/* make_file.c */
#include <unistd.h>
#include <sys/fcntl.h>
#include <sys/mman.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	int size, fd;
	char *mapping;
	if (argc != 3) {
		fprintf(stderr, "Usage: %s FILE SIZE\n", argv[0]);
		return 1;
	}
	size = atoi(argv[2]);

	fd = open(argv[1], O_RDWR | O_CREAT, 0600);
	if (fd < 0) {
		perror(argv[1]);
		return 1;
	}
	if (ftruncate(fd, size) < 0) {
		perror("ftruncate");
		return 1;
	}
	mapping = mmap(NULL, size, PROT_WRITE, MAP_SHARED, fd, 0);
	if (mapping == MAP_FAILED) {
		perror("mmap");
		return 1;
	}
	memset(mapping, 0xFF, size);

	/* Force a write-back */
	sync();

	if (msync(mapping, size, MS_SYNC) < 0) {
		perror("msync");
		return 1;
	}
	if (close(fd) < 0) {
		perror("close");
		return 1;
	}
	printf("%s: successfully written %d bytes\n", argv[1], size);
	return 0;
}
==================

make_file.c mmaps a hole, performs some writeback (memset + sync) and then
expects to find some error code in msync().  The script mounts a 40M
loopback filesystem and does a binary search to find the size of a file
big enough to provoke a ENOSPC, but small enough to show the error not
being detected at msync() time.

The error window is large enough for such a size to be quickly found, but
with this patch, no such file size can be found.

All mmap capable filesystems I tested are affected (ext2, ext3, jfs,
reiserfs, xfs).  XFS is special in that it survives the test thanks to the
page_mkwrite() work, i.e.  it SIGBUS during memset.  Anyway, this XFS
behaviour solves ENOSPC but does nothing for EIO.

The offending code is in fs/fs-writeback.c:

sync_sb_inodes(...)
{
	...
	__writeback_single_inode(inode, wbc);
	...
}

__writeback_single_inode() gets the error from mapping->flags, clears it
and returns it.  But sync_sb_inodes() ignores this return value. 
sync_sb_inodes() should leave the error in each mapping instead of
propagating it through the call stack for the following reasons:

- the propagated error would combine the errors in all the synced
  inodes, so it would just tell that some inode in a specific fs got an
  error,

- nobody in the call stack would be interested by this error: certainly
  not pdflush, or 'void sync(2)'.

Signed-off-by: Guillaume Chazarain <guichaz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~fs-writeback-handle-errors-in-sync_sb_inodes fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-writeback-handle-errors-in-sync_sb_inodes
+++ a/fs/fs-writeback.c
@@ -454,6 +454,7 @@ void generic_sync_sb_inodes(struct super
 		struct address_space *mapping = inode->i_mapping;
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		long pages_skipped;
+		int err;
 
 		if (!bdi_cap_writeback_dirty(bdi)) {
 			redirty_tail(inode);
@@ -498,7 +499,8 @@ void generic_sync_sb_inodes(struct super
 		BUG_ON(inode->i_state & I_FREEING);
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
-		__writeback_single_inode(inode, wbc);
+		err = __writeback_single_inode(inode, wbc);
+		mapping_set_error(mapping, err);
 		if (wbc->sync_mode == WB_SYNC_HOLD) {
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &sb->s_dirty);
_

Patches currently in -mm which might be from guichaz@gmail.com are

fs-writeback-handle-errors-in-sync_sb_inodes.patch

