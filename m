From: akpm@linux-foundation.org
Subject: + fat-fix-_fat_bmap-race.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:07:48 -0700
Message-ID: <200810162207.m9GM7mpO028115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756598AbYJPWHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:07:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: Fix _fat_bmap() race
has been added to the -mm tree.  Its filename is
     fat-fix-_fat_bmap-race.patch

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
Subject: fat: Fix _fat_bmap() race
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

fat_get_cluster() assumes the requested blocknr isn't truncated during
read. _fat_bmap() doesn't follow this rule.

This protects it by ->i_mutex.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-fix-_fat_bmap-race fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-_fat_bmap-race
+++ a/fs/fat/inode.c
@@ -199,7 +199,14 @@ static ssize_t fat_direct_IO(int rw, str
 
 static sector_t _fat_bmap(struct address_space *mapping, sector_t block)
 {
-	return generic_block_bmap(mapping, block, fat_get_block);
+	sector_t blocknr;
+
+	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
+	mutex_lock(&mapping->host->i_mutex);
+	blocknr = generic_block_bmap(mapping, block, fat_get_block);
+	mutex_unlock(&mapping->host->i_mutex);
+
+	return blocknr;
 }
 
 static const struct address_space_operations fat_aops = {
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

