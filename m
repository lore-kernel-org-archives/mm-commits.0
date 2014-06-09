From: akpm@linux-foundation.org
Subject: [merged] fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:31:12 -0700
Message-ID: <53960b80.gIOurg9vCDvTj0/U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaFITbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: [merged] fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch removed from -mm tree
To: fabf@skynet.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:31:12 -0700


The patch titled
     Subject: fs/befs/linuxvfs.c: remove positive test on sector_t
has been removed from the -mm tree.  Its filename was
     fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/befs/linuxvfs.c: remove positive test on sector_t

sector_t is unsigned.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-remove-positive-test-on-sector_t fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-remove-positive-test-on-sector_t
+++ a/fs/befs/linuxvfs.c
@@ -133,14 +133,6 @@ befs_get_block(struct inode *inode, sect
 
 	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
 		   (unsigned long)inode->i_ino, (long)block);
-
-	if (block < 0) {
-		befs_error(sb, "befs_get_block() was asked for a block "
-			   "number less than zero: block %ld in inode %lu",
-			   (long)block, (unsigned long)inode->i_ino);
-		return -EIO;
-	}
