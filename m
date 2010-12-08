From: akpm@linux-foundation.org
Subject: + fs-make-block-fiemap-mapping-length-at-least-blocksize-long.patch added to -mm tree
Date: Wed, 08 Dec 2010 14:08:42 -0800
Message-ID: <201012082208.oB8M8gIF012512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676Ab0LHWJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2010 17:09:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josef@redhat.com, hch@lst.de, swhiteho@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     fs: make block fiemap mapping length at least blocksize long
has been added to the -mm tree.  Its filename is
     fs-make-block-fiemap-mapping-length-at-least-blocksize-long.patch

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

fs-make-block-fiemap-mapping-length-at-least-blocksize-long.patch

