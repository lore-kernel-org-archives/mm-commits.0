From: akpm@linux-foundation.org
Subject: + ext2-le_add_cpu-conversion.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:24:39 -0800
Message-ID: <200802140024.m1E0Ods7021977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934317AbYBNAZI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:25:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com


The patch titled
     ext2: le*_add_cpu conversion
has been added to the -mm tree.  Its filename is
     ext2-le_add_cpu-conversion.patch

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
Subject: ext2: le*_add_cpu conversion
From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ialloc.c |   12 ++++--------
 fs/ext2/super.c  |    2 +-
 fs/ext2/xattr.c  |    9 +++------
 3 files changed, 8 insertions(+), 15 deletions(-)

diff -puN fs/ext2/ialloc.c~ext2-le_add_cpu-conversion fs/ext2/ialloc.c
--- a/fs/ext2/ialloc.c~ext2-le_add_cpu-conversion
+++ a/fs/ext2/ialloc.c
@@ -75,11 +75,9 @@ static void ext2_release_inode(struct su
 	}
 
 	spin_lock(sb_bgl_lock(EXT2_SB(sb), group));
-	desc->bg_free_inodes_count =
-		cpu_to_le16(le16_to_cpu(desc->bg_free_inodes_count) + 1);
+	le16_add_cpu(&desc->bg_free_inodes_count, 1);
 	if (dir)
-		desc->bg_used_dirs_count =
-			cpu_to_le16(le16_to_cpu(desc->bg_used_dirs_count) - 1);
+		le16_add_cpu(&desc->bg_used_dirs_count, -1);
 	spin_unlock(sb_bgl_lock(EXT2_SB(sb), group));
 	if (dir)
 		percpu_counter_dec(&EXT2_SB(sb)->s_dirs_counter);
@@ -539,13 +537,11 @@ got:
 		percpu_counter_inc(&sbi->s_dirs_counter);
 
 	spin_lock(sb_bgl_lock(sbi, group));
-	gdp->bg_free_inodes_count =
-                cpu_to_le16(le16_to_cpu(gdp->bg_free_inodes_count) - 1);
+	le16_add_cpu(&gdp->bg_free_inodes_count, -1);
 	if (S_ISDIR(mode)) {
 		if (sbi->s_debts[group] < 255)
 			sbi->s_debts[group]++;
-		gdp->bg_used_dirs_count =
-			cpu_to_le16(le16_to_cpu(gdp->bg_used_dirs_count) + 1);
+		le16_add_cpu(&gdp->bg_used_dirs_count, 1);
 	} else {
 		if (sbi->s_debts[group])
 			sbi->s_debts[group]--;
diff -puN fs/ext2/super.c~ext2-le_add_cpu-conversion fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-le_add_cpu-conversion
+++ a/fs/ext2/super.c
@@ -604,7 +604,7 @@ static int ext2_setup_super (struct supe
 			"running e2fsck is recommended\n");
 	if (!le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT2_DFL_MAX_MNT_COUNT);
-	es->s_mnt_count=cpu_to_le16(le16_to_cpu(es->s_mnt_count) + 1);
+	le16_add_cpu(&es->s_mnt_count, 1);
 	ext2_write_super(sb);
 	if (test_opt (sb, DEBUG))
 		printk ("[EXT II FS %s, %s, bs=%lu, fs=%lu, gc=%lu, "
diff -puN fs/ext2/xattr.c~ext2-le_add_cpu-conversion fs/ext2/xattr.c
--- a/fs/ext2/xattr.c~ext2-le_add_cpu-conversion
+++ a/fs/ext2/xattr.c
@@ -646,8 +646,7 @@ ext2_xattr_set2(struct inode *inode, str
 					unlock_buffer(new_bh);
 					goto cleanup;
 				}
-				HDR(new_bh)->h_refcount = cpu_to_le32(1 +
-					le32_to_cpu(HDR(new_bh)->h_refcount));
+				le32_add_cpu(&HDR(new_bh)->h_refcount, 1);
 				ea_bdebug(new_bh, "refcount now=%d",
 					le32_to_cpu(HDR(new_bh)->h_refcount));
 			}
@@ -731,8 +730,7 @@ ext2_xattr_set2(struct inode *inode, str
 			bforget(old_bh);
 		} else {
 			/* Decrement the refcount only. */
-			HDR(old_bh)->h_refcount = cpu_to_le32(
-				le32_to_cpu(HDR(old_bh)->h_refcount) - 1);
+			le32_add_cpu(&HDR(old_bh)->h_refcount, -1);
 			if (ce)
 				mb_cache_entry_release(ce);
 			DQUOT_FREE_BLOCK(inode, 1);
@@ -789,8 +787,7 @@ ext2_xattr_delete_inode(struct inode *in
 		bforget(bh);
 		unlock_buffer(bh);
 	} else {
-		HDR(bh)->h_refcount = cpu_to_le32(
-			le32_to_cpu(HDR(bh)->h_refcount) - 1);
+		le32_add_cpu(&HDR(bh)->h_refcount, -1);
 		if (ce)
 			mb_cache_entry_release(ce);
 		ea_bdebug(bh, "refcount now=%d",
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
udf-fix-directory-offset-handling.patch
udf-fix-udf_add_free_space.patch
git-gfs2-nmw.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
scsi-le_add_cpu-conversion.patch
ext2-le_add_cpu-conversion.patch
ext4-le_add_cpu-conversion.patch
jfs-le_add_cpu-conversion.patch
ntfs-le_add_cpu-conversion.patch
ocfs2-le_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
reiserfs-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion-in-return.patch
