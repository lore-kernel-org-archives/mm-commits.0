From: akpm@linux-foundation.org
Subject: + fs-dont-pass-stack-garbage-to-filesystems-get_block-in-map_bh-b_size.patch added to -mm tree
Date: Tue, 12 May 2009 14:55:04 -0700
Message-ID: <200905122155.n4CLt5Oj009436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbZELV5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 17:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tytso@mit.edu, shaggy@linux.vnet.ibm.com


The patch titled
     fs: Don't pass stack garbage to filesystem's get_block() in map_bh->b_size
has been added to the -mm tree.  Its filename is
     fs-dont-pass-stack-garbage-to-filesystems-get_block-in-map_bh-b_size.patch

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
Subject: fs: Don't pass stack garbage to filesystem's get_block() in map_bh->b_size
From: "Theodore Ts'o" <tytso@mit.edu>

The nobh_truncate_page() function is used by ext2, exofs, and jfs.  Of
these three, only ext2 and jfs's get_block() function pays attention to
bh->b_size --- which is normally always the filesystem blocksize except
when the get_block() function is called by either mpage_readpage(),
mpage_readpages(), or the direct I/O routines in fs/direct_io.c.

Unfortunately, nobh_truncate_page() does not initialize map_bh before
calling the filesystem-supplied get_block() function.  So ext2 and jfs
will try to calculate the number of blocks to map by taking stack garbage
and shifting it left by inode->i_blkbits.  This should be *mostly*
harmless (except the filesystem will do some unnneeded work) unless the
stack garbage is less than filesystem's blocksize, in which case maxblocks
will be zero, and the attempt to find out whether or not the filesystem
has a hole at a given logical block will fail, and the page cache entry
might not get zero'ed out.

Also if the stack garbage in in map_bh->state happens to have the
BH_Mapped bit set, there could be an attempt to call readpage() on a
non-existent page, which could cause nobh_truncate_page() to return an
error when it should not.

Fix this by initializing map_bh->state and map_bh->size.

Fortunately, it's probably fairly unlikely that ext2 and jfs users
mount with nobh these days.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/buffer.c~fs-dont-pass-stack-garbage-to-filesystems-get_block-in-map_bh-b_size fs/buffer.c
--- a/fs/buffer.c~fs-dont-pass-stack-garbage-to-filesystems-get_block-in-map_bh-b_size
+++ a/fs/buffer.c
@@ -2736,6 +2736,8 @@ has_buffers:
 		pos += blocksize;
 	}
 
+	map_bh.b_size = blocksize;
+	map_bh.b_state = 0;
 	err = get_block(inode, iblock, &map_bh, 0);
 	if (err)
 		goto unlock;
_

Patches currently in -mm which might be from tytso@mit.edu are

linux-next.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-dont-pass-stack-garbage-to-filesystems-get_block-in-map_bh-b_size.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch

