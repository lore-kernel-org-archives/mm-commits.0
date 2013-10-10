From: akpm@linux-foundation.org
Subject: +
 fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io.patch added to -mm tree
Date: Thu, 10 Oct 2013 15:02:38 -0700
Message-ID: <525723fe.+a2C+brtxdiPHRMY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3JJWCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 18:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: + fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io.patch added to -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 15:02:38 -0700


The patch titled
     Subject: fat: fallback to buffered write in case of fallocatded region on direct IO
has been added to the -mm tree.  Its filename is
     fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io.patch

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

fat-add-i_disksize-to-represent-uninitialized-size.patch
fat-add-fat_fallocate-operation.patch
fat-zero-out-seek-range-on-_fat_get_block.patch
fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch

