From: akpm@linux-foundation.org
Subject: +
 fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4.patch added to -mm tree
Date: Tue, 04 Mar 2014 13:20:03 -0800
Message-ID: <53164383.yEHjanGz1dT9Yi28%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933333AbaCDVUE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 16:20:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: + fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4.patch added to -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 13:20:03 -0800


The patch titled
     Subject: fat: fallback to buffered write in case of fallocated region on direct IO
has been added to the -mm tree.  Its filename is
     fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

diff -puN fs/fat/inode.c~fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4 fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4
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

fat-add-i_disksize-to-represent-uninitialized-size-v4.patch
fat-add-fat_fallocate-operation-v4.patch
fat-zero-out-seek-range-on-_fat_get_block-v4.patch
fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch
linux-next.patch

