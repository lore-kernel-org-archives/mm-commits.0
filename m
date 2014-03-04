From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io.patch removed from -mm tree
Date: Tue, 04 Mar 2014 13:15:25 -0800
Message-ID: <5316426d.8UeEUBC/gbUr1O5h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900AbaCDVP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 16:15:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: [to-be-updated] fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io.patch removed from -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 13:15:25 -0800


The patch titled
     Subject: fat: fallback to buffered write in case of fallocated region on direct IO
has been removed from the -mm tree.  Its filename was
     fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: fallback to buffered write in case of fallocated region on direct IO

For normal cases of direct IO write, trying to seek to location greater
than file size, makes it fall back to buffered write to fill that region. 
Similarly, in case for write in Fallocated region, make it fall to
buffered write.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/fat/inode.c~fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io
+++ a/fs/fat/inode.c
@@ -229,6 +229,13 @@ static ssize_t fat_direct_IO(int rw, str
 		loff_t size = offset + iov_length(iov, nr_segs);
 		if (MSDOS_I(inode)->mmu_private < size)
 			return 0;
+
+		/*
+		 * In case of writing in fallocated region, return 0 and
+		 * fallback to buffered write.
+		 */
+		if (MSDOS_I(inode)->i_disksize > MSDOS_I(inode)->mmu_private)
+			return 0;
 	}
 
 	/*
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
fat-update-the-limitation-for-fat-fallocate.patch
linux-next.patch

