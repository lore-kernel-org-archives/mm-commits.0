From: akpm@linux-foundation.org
Subject: + fat-fix-fat_ent_update_ptr-for-fat12.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:07:30 -0700
Message-ID: <200810162207.m9GM7U1B028067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756252AbYJPWHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: Fix fat_ent_update_ptr() for FAT12
has been added to the -mm tree.  Its filename is
     fat-fix-fat_ent_update_ptr-for-fat12.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

origin.patch
fat-document-additional-vfat-mount-options.patch
fat-move-fs-vfat-and-fs-msdos-to-fs-fat.patch
fat-split-include-msdos_fsh.patch
fat-fix-and-cleanup-timestamp-conversion.patch
fat-use-generic_file_llseek-for-directory.patch
fat-cleanup-fat_parse_long-error-handling.patch
fat-improve-fat_hash.patch
fat-fix-fat_ent_update_ptr-for-fat12.patch
fat-use-fat_detach-in-fat_clear_inode.patch
vfat-fix-vfat_find-error-path-in-vfat_lookup.patch
fat-fix-cleanup-dcache-handling-for-vfat.patch
fat-kill-d_invalidate-in-vfat_lookup.patch
fat-cleanup-msdos_lookup.patch
fat-cleanup-fat-attribute-stuff.patch
fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch
fat-fix-attr_ro-for-directory.patch
fat-fix-_fat_bmap-race.patch
fat-add-printf-attribute-to-fat_fs_panic.patch
fat-mmu_private-race-fix.patch
fat-i_pos-race-fix.patch
fat-i_blocks-warning-fix.patch

