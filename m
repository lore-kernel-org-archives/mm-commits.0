From: akpm@linux-foundation.org
Subject: - fat-fix-fat_ent_update_ptr-for-fat12.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:21 -0800
Message-ID: <200811102033.mAAKXLgx024458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310AbYKJUdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:33:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: Fix fat_ent_update_ptr() for FAT12
has been removed from the -mm tree.  Its filename was
     fat-fix-fat_ent_update_ptr-for-fat12.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: Fix fat_ent_update_ptr() for FAT12
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This fixes the missing update for bhs/nr_bhs in case the caller
accessed from block boundary to first block of boundary.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN fs/fat/fatent.c~fat-fix-fat_ent_update_ptr-for-fat12 fs/fat/fatent.c
--- a/fs/fat/fatent.c~fat-fix-fat_ent_update_ptr-for-fat12
+++ a/fs/fat/fatent.c
@@ -317,10 +317,20 @@ static inline int fat_ent_update_ptr(str
 	/* Is this fatent's blocks including this entry? */
 	if (!fatent->nr_bhs || bhs[0]->b_blocknr != blocknr)
 		return 0;
-	/* Does this entry need the next block? */
-	if (sbi->fat_bits == 12 && (offset + 1) >= sb->s_blocksize) {
-		if (fatent->nr_bhs != 2 || bhs[1]->b_blocknr != (blocknr + 1))
-			return 0;
+	if (sbi->fat_bits == 12) {
+		if ((offset + 1) < sb->s_blocksize) {
+			/* This entry is on bhs[0]. */
+			if (fatent->nr_bhs == 2) {
+				brelse(bhs[1]);
+				fatent->nr_bhs = 1;
+			}
+		} else {
+			/* This entry needs the next block. */
+			if (fatent->nr_bhs != 2)
+				return 0;
+			if (bhs[1]->b_blocknr != (blocknr + 1))
+				return 0;
+		}
 	}
 	ops->ent_set_ptr(fatent, offset);
 	return 1;
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch

