From: akpm@linux-foundation.org
Subject: + fs-inode-remove-8-bytes-of-padding-on-64bits-allowing-1-more-objects-slab-under-slub.patch added to -mm tree
Date: Tue, 16 Feb 2010 14:45:42 -0800
Message-ID: <201002162245.o1GMjgxe009526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933181Ab0BPWqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 17:46:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     fs: inode - remove 8 bytes of padding on 64bits allowing 1 more objects/slab under slub
has been added to the -mm tree.  Its filename is
     fs-inode-remove-8-bytes-of-padding-on-64bits-allowing-1-more-objects-slab-under-slub.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: inode - remove 8 bytes of padding on 64bits allowing 1 more objects/slab under slub
From: Richard Kennedy <richard@rsk.demon.co.uk>

This removes 8 bytes of padding from struct inode on 64bit builds, and so
allows 1 more object/slab in the inode_cache when using slub.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fs.h~fs-inode-remove-8-bytes-of-padding-on-64bits-allowing-1-more-objects-slab-under-slub include/linux/fs.h
--- a/include/linux/fs.h~fs-inode-remove-8-bytes-of-padding-on-64bits-allowing-1-more-objects-slab-under-slub
+++ a/include/linux/fs.h
@@ -729,6 +729,7 @@ struct inode {
 	uid_t			i_uid;
 	gid_t			i_gid;
 	dev_t			i_rdev;
+	unsigned int		i_blkbits;
 	u64			i_version;
 	loff_t			i_size;
 #ifdef __NEED_I_SIZE_ORDERED
@@ -738,7 +739,6 @@ struct inode {
 	struct timespec		i_mtime;
 	struct timespec		i_ctime;
 	blkcnt_t		i_blocks;
-	unsigned int		i_blkbits;
 	unsigned short          i_bytes;
 	umode_t			i_mode;
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
fs-buffer_head-remove-kmem_cache-constructor-to-reduce-memory-usage-under-slub.patch
cpuidle-menu-remove-8-bytes-of-padding-on-64-bit-builds.patch
fs-inode-remove-8-bytes-of-padding-on-64bits-allowing-1-more-objects-slab-under-slub.patch

