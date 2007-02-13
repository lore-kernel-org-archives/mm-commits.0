From: akpm@linux-foundation.org
Subject: + fat-dio-write-fallback-to-normal-buffered.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:27:06 -0800
Message-ID: <200702130527.l1D5R6uJ022581@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55010 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161029AbXBMF1J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:27:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     FAT: DIO-write fallback to normal buffered
has been added to the -mm tree.  Its filename is
     fat-dio-write-fallback-to-normal-buffered.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FAT: DIO-write fallback to normal buffered
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

If the DIO write on FAT is expanding the size, it will be fail by -EINVAL,
because FAT can't handle it now.

This patch fallback it to the normal buffered-write and would return
success.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-dio-write-fallback-to-normal-buffered fs/fat/inode.c
--- a/fs/fat/inode.c~fat-dio-write-fallback-to-normal-buffered
+++ a/fs/fat/inode.c
@@ -173,10 +173,12 @@ static ssize_t fat_direct_IO(int rw, str
 		 *
 		 * But we must fill the remaining area or hole by nul for
 		 * updating ->mmu_private.
+		 *
+		 * Return 0, and fallback to normal buffered write.
 		 */
 		loff_t size = offset + iov_length(iov, nr_segs);
 		if (MSDOS_I(inode)->mmu_private < size)
-			return -EINVAL;
+			return 0;
 	}
 
 	/*
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
fix-the-reproducible-oops-in-scsi.patch
fat-dio-write-fallback-to-normal-buffered.patch
