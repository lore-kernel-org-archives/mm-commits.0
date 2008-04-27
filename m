From: akpm@linux-foundation.org
Subject: + vfs-fix-unconditional-write_super-call-in-file_fsync.patch added to -mm tree
Date: Sun, 27 Apr 2008 13:46:42 -0700
Message-ID: <200804272046.m3RKkg0L024102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763378AbYD0UrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 16:47:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: fix unconditional write_super() call in file_fsync()
has been added to the -mm tree.  Its filename is
     vfs-fix-unconditional-write_super-call-in-file_fsync.patch

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
Subject: vfs: fix unconditional write_super() call in file_fsync()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

We need to check ->s_dirt before calling write_super().  It became the cause
of an unneeded write.

This bug was noticed by Sudhanshu Saxena.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sync.c~vfs-fix-unconditional-write_super-call-in-file_fsync fs/sync.c
--- a/fs/sync.c~vfs-fix-unconditional-write_super-call-in-file_fsync
+++ a/fs/sync.c
@@ -64,7 +64,7 @@ int file_fsync(struct file *filp, struct
 	/* sync the superblock to buffers */
 	sb = inode->i_sb;
 	lock_super(sb);
-	if (sb->s_op->write_super)
+	if (sb->s_dirt && sb->s_op->write_super)
 		sb->s_op->write_super(sb);
 	unlock_super(sb);
 
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

vfs-fix-unconditional-write_super-call-in-file_fsync.patch
fat-kill-is_bad_inode-check.patch
fat-fat_notify_change-and-check_mode-cleanup.patch
fat-fat_setattr-fix.patch
fat-add-allow_utime-option.patch
fat-update-free_clusters-even-if-it-is-untrusted.patch
fat-remove-fat_clusters_flush.patch
add-balance_dirty_pages_ratelimited-to-cont_expand_zero.patch
vfat-bug-fix-for-vfat-cannot-handle-filename-with-255.patch
fat-use-__getname.patch
fat_valid_media-remove-pointless-test.patch
fat-detect-media-without-partition-table-correctly.patch
fatfs-fix-build-warning-with-64k-page_size.patch
fat-use-get-put_unaligned_-helpers.patch

