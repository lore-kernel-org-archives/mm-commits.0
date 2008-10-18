From: akpm@linux-foundation.org
Subject: - fs-partitions-acornc-remove-dead-code.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:04 -0700
Message-ID: <200810182319.m9INJ4J4029407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbYJRXTP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     fs/partitions/acorn.c: remove dead code
has been removed from the -mm tree.  Its filename was
     fs-partitions-acornc-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/partitions/acorn.c: remove dead code
From: Adrian Bunk <bunk@kernel.org>

I missed this when I did the arm26 removal.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/acorn.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN fs/partitions/acorn.c~fs-partitions-acornc-remove-dead-code fs/partitions/acorn.c
--- a/fs/partitions/acorn.c~fs-partitions-acornc-remove-dead-code
+++ a/fs/partitions/acorn.c
@@ -275,16 +275,6 @@ adfspart_check_ADFS(struct parsed_partit
 	id = data[0x1fc] & 15;
 	put_dev_sector(sect);
 
-#ifdef CONFIG_BLK_DEV_MFM
-	if (MAJOR(bdev->bd_dev) == MFM_ACORN_MAJOR) {
-		extern void xd_set_geometry(struct block_device *,
-			unsigned char, unsigned char, unsigned int);
-		xd_set_geometry(bdev, dr->secspertrack, heads, 1);
-		invalidate_bh_lrus();
-		truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
-	}
-#endif
