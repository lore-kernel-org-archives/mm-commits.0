From: akpm@linux-foundation.org
Subject: - fat-use-get-put_unaligned_-helpers.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:36 -0700
Message-ID: <200804300549.m3U5naku030014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756338AbYD3GBc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:01:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, hirofumi@mail.parknet.co.jp, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fat: use get/put_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     fat-use-get-put_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/fat/inode.c~fat-use-get-put_unaligned_-helpers fs/fat/inode.c
--- a/fs/fat/inode.c~fat-use-get-put_unaligned_-helpers
+++ a/fs/fat/inode.c
@@ -1222,8 +1222,7 @@ int fat_fill_super(struct super_block *s
 		brelse(bh);
 		goto out_invalid;
 	}
-	logical_sector_size =
-		le16_to_cpu(get_unaligned((__le16 *)&b->sector_size));
+	logical_sector_size = get_unaligned_le16(&b->sector_size);
 	if (!is_power_of_2(logical_sector_size)
 	    || (logical_sector_size < 512)
 	    || (logical_sector_size > 4096)) {
@@ -1322,8 +1321,7 @@ int fat_fill_super(struct super_block *s
 	sbi->dir_per_block_bits = ffs(sbi->dir_per_block) - 1;
 
 	sbi->dir_start = sbi->fat_start + sbi->fats * sbi->fat_length;
-	sbi->dir_entries =
-		le16_to_cpu(get_unaligned((__le16 *)&b->dir_entries));
+	sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
 	if (sbi->dir_entries & (sbi->dir_per_block - 1)) {
 		if (!silent)
 			printk(KERN_ERR "FAT: bogus directroy-entries per block"
@@ -1335,7 +1333,7 @@ int fat_fill_super(struct super_block *s
 	rootdir_sectors = sbi->dir_entries
 		* sizeof(struct msdos_dir_entry) / sb->s_blocksize;
 	sbi->data_start = sbi->dir_start + rootdir_sectors;
-	total_sectors = le16_to_cpu(get_unaligned((__le16 *)&b->sectors));
+	total_sectors = get_unaligned_le16(&b->sectors);
 	if (total_sectors == 0)
 		total_sectors = le32_to_cpu(b->total_sect);
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

