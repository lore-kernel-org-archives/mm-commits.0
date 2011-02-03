From: akpm@linux-foundation.org
Subject: [merged] fs-make-block-fiemap-mapping-length-at-least-blocksize-long.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:46:34 -0800
Message-ID: <201102031946.p13JkYIS021024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756726Ab1BCTqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josef@redhat.com, hch@lst.de, swhiteho@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: make block fiemap mapping length at least blocksize long
has been removed from the -mm tree.  Its filename was
     fs-make-block-fiemap-mapping-length-at-least-blocksize-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: make block fiemap mapping length at least blocksize long
From: Josef Bacik <josef@redhat.com>

Some filesystems don't deal well with being asked to map less than
blocksize blocks (GFS2 for example).  Since we are always mapping at least
blocksize sections anyway, just make sure len is at least as big as a
blocksize so we don't trip up any filesystems.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/ioctl.c~fs-make-block-fiemap-mapping-length-at-least-blocksize-long fs/ioctl.c
--- a/fs/ioctl.c~fs-make-block-fiemap-mapping-length-at-least-blocksize-long
+++ a/fs/ioctl.c
@@ -273,6 +273,13 @@ int __generic_block_fiemap(struct inode 
 		len = isize;
 	}
 
+	/*
+	 * Some filesystems can't deal with being asked to map less than
+	 * blocksize, so make sure our len is at least block length.
+	 */
+	if (logical_to_blk(inode, len) == 0)
+		len = blk_to_logical(inode, 1);
+
 	start_blk = logical_to_blk(inode, start);
 	last_blk = logical_to_blk(inode, start + len - 1);
 
_

Patches currently in -mm which might be from josef@redhat.com are

origin.patch

