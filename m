From: akpm@linux-foundation.org
Subject: + fat-kill-is_bad_inode-check.patch added to -mm tree
Date: Sun, 27 Apr 2008 12:07:40 -0700
Message-ID: <200804271907.m3RJ7etP020420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762971AbYD0THn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 15:07:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: kill is_bad_inode() check
has been added to the -mm tree.  Its filename is
     fat-kill-is_bad_inode-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: kill is_bad_inode() check
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

FAT doesn't need to check bad inode anymore.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN fs/fat/inode.c~fat-kill-is_bad_inode-check fs/fat/inode.c
--- a/fs/fat/inode.c~fat-kill-is_bad_inode-check
+++ a/fs/fat/inode.c
@@ -433,11 +433,8 @@ EXPORT_SYMBOL_GPL(fat_build_inode);
 static void fat_delete_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-
-	if (!is_bad_inode(inode)) {
-		inode->i_size = 0;
-		fat_truncate(inode);
-	}
+	inode->i_size = 0;
+	fat_truncate(inode);
 	clear_inode(inode);
 }
 
@@ -445,8 +442,6 @@ static void fat_clear_inode(struct inode
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 
-	if (is_bad_inode(inode))
-		return;
 	lock_kernel();
 	spin_lock(&sbi->inode_hash_lock);
 	fat_cache_inval_inode(inode);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-kill-is_bad_inode-check.patch
fat-fat_notify_change-and-check_mode-cleanup.patch
fat-fat_setattr-fix.patch
fat-add-allow_utime-option.patch
fat-update-free_clusters-even-if-it-is-untrusted.patch
fat-remove-fat_clusters_flush.patch
add-balance_dirty_pages_ratelimited-to-cont_expand_zero.patch
vfat-bug-fix-for-vfat-cannot-handle-filename-with-255.patch
fat-use-__getname.patch
fat_valid_media-remove-pointless-test.patch
fat-detect-media-without-partition-table-correctly.patch
fatfs-fix-build-warning-with-64k-page_size.patch
fat-use-get-put_unaligned_-helpers.patch

