From: akpm@linux-foundation.org
Subject: [merged] ufs-sector_t-cannot-be-negative.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:45:04 -0700
Message-ID: <200906182245.n5IMj4np004115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477AbZFRWpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: sector_t cannot be negative
has been removed from the -mm tree.  Its filename was
     ufs-sector_t-cannot-be-negative.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: sector_t cannot be negative
From: Roel Kluin <roel.kluin@gmail.com>

unsigned i_block,fragment cannot be negative.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/inode.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN fs/ufs/inode.c~ufs-sector_t-cannot-be-negative fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs-sector_t-cannot-be-negative
+++ a/fs/ufs/inode.c
@@ -56,9 +56,7 @@ static int ufs_block_to_path(struct inod
 
 
 	UFSD("ptrs=uspi->s_apb = %d,double_blocks=%ld \n",ptrs,double_blocks);
-	if (i_block < 0) {
-		ufs_warning(inode->i_sb, "ufs_block_to_path", "block < 0");
-	} else if (i_block < direct_blocks) {
+	if (i_block < direct_blocks) {
 		offsets[n++] = i_block;
 	} else if ((i_block -= direct_blocks) < indirect_blocks) {
 		offsets[n++] = UFS_IND_BLOCK;
@@ -440,8 +438,6 @@ int ufs_getfrag_block(struct inode *inod
 	lock_kernel();
 
 	UFSD("ENTER, ino %lu, fragment %llu\n", inode->i_ino, (unsigned long long)fragment);
-	if (fragment < 0)
-		goto abort_negative;
 	if (fragment >
 	    ((UFS_NDADDR + uspi->s_apb + uspi->s_2apb + uspi->s_3apb)
 	     << uspi->s_fpbshift))
@@ -504,10 +500,6 @@ abort:
 	unlock_kernel();
 	return err;
 
-abort_negative:
-	ufs_warning(sb, "ufs_get_block", "block < 0");
-	goto abort;
