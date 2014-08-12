From: akpm@linux-foundation.org
Subject: [merged]
 adfs-add-__printf-verification-fix-format-argument-mismatches.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:46 -0700
Message-ID: <53ea6dbe.3Z3xrdQQA68ZkhS4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:58537 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbaHLTkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:47 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so1312664vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: adfs: add __printf verification, fix format/argument mismatches
has been removed from the -mm tree.  Its filename was
     adfs-add-__printf-verification-fix-format-argument-mismatches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: adfs: add __printf verification, fix format/argument mismatches

Might as well do the right thing.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/adfs.h      |    1 +
 fs/adfs/dir.c       |    2 +-
 fs/adfs/dir_fplus.c |    5 ++---
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/adfs/adfs.h~adfs-add-__printf-verification-fix-format-argument-mismatches fs/adfs/adfs.h
--- a/fs/adfs/adfs.h~adfs-add-__printf-verification-fix-format-argument-mismatches
+++ a/fs/adfs/adfs.h
@@ -153,6 +153,7 @@ extern int adfs_map_lookup(struct super_
 extern unsigned int adfs_map_free(struct super_block *sb);
 
 /* Misc */
+__printf(3, 4)
 void __adfs_error(struct super_block *sb, const char *function,
 		  const char *fmt, ...);
 #define adfs_error(sb, fmt...) __adfs_error(sb, __func__, fmt)
diff -puN fs/adfs/dir.c~adfs-add-__printf-verification-fix-format-argument-mismatches fs/adfs/dir.c
--- a/fs/adfs/dir.c~adfs-add-__printf-verification-fix-format-argument-mismatches
+++ a/fs/adfs/dir.c
@@ -138,7 +138,7 @@ adfs_dir_lookup_byname(struct inode *ino
 		goto out;
 
 	if (ADFS_I(inode)->parent_id != dir.parent_id) {
-		adfs_error(sb, "parent directory changed under me! (%lx but got %lx)\n",
+		adfs_error(sb, "parent directory changed under me! (%lx but got %x)\n",
 			   ADFS_I(inode)->parent_id, dir.parent_id);
 		ret = -EIO;
 		goto free_out;
diff -puN fs/adfs/dir_fplus.c~adfs-add-__printf-verification-fix-format-argument-mismatches fs/adfs/dir_fplus.c
--- a/fs/adfs/dir_fplus.c~adfs-add-__printf-verification-fix-format-argument-mismatches
+++ a/fs/adfs/dir_fplus.c
@@ -79,9 +79,8 @@ adfs_fplus_read(struct super_block *sb,
 
 		dir->bh_fplus[blk] = sb_bread(sb, block);
 		if (!dir->bh_fplus[blk]) {
-			adfs_error(sb,	"dir object %X failed read for"
-					" offset %d, mapped block %X",
-					id, blk, block);
+			adfs_error(sb,	"dir object %x failed read for offset %d, mapped block %lX",
+				   id, blk, block);
 			goto out;
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

