From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io.patch removed from -mm tree
Date: Mon, 18 Nov 2013 15:19:24 -0800
Message-ID: <528aa07c.PTe9ZjGcaGAxVTwp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3KRXTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 18:19:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: [to-be-updated] fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io.patch removed from -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 15:19:24 -0800


The patch titled
     Subject: fat: fallback to buffered write in case of fallocatded region on direct IO
has been removed from the -mm tree.  Its filename was
     fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: fallback to buffered write in case of fallocatded region on direct IO

For normal cases of direct IO write, trying to seek to location greater
than file size, makes it fall back to buffered write to fill that region. 
Similarly, in case for write in Fallocated region, make it fall to
buffered write.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/fat/inode.c~fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io
+++ a/fs/fat/inode.c
@@ -218,6 +218,14 @@ static ssize_t fat_direct_IO(int rw, str
 		loff_t size = offset + iov_length(iov, nr_segs);
 		if (MSDOS_I(inode)->mmu_private < size)
 			return 0;
+
+		/*
+		 * In case of writing in fallocated region, return 0 and
+		 * fallback to buffered write.
+		 */
+		if (MSDOS_I(inode)->i_disksize >
+		    round_up(i_size_read(inode), inode->i_sb->s_blocksize))
+			return 0;
 	}
 
 	/*
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch

