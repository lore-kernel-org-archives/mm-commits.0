From: akpm@linux-foundation.org
Subject: [merged]
 fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:09:42 -0800
Message-ID: <548d0d86.EtyJsHLgOTy1cWDt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaLNEJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/amigaffs.c: use va_format instead of buffer/vnsprintf
has been removed from the -mm tree.  Its filename was
     fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/amigaffs.c: use va_format instead of buffer/vnsprintf

-Remove ErrorBuffer and use %pV

-Add __printf to enable argument mistmatch warnings

Original patch by Joe Perches.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h     |    2 ++
 fs/affs/amigaffs.c |   28 +++++++++++++---------------
 fs/affs/file.c     |   16 ++++++++++------
 3 files changed, 25 insertions(+), 21 deletions(-)

diff -puN fs/affs/affs.h~fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf fs/affs/affs.h
--- a/fs/affs/affs.h~fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf
+++ a/fs/affs/affs.h
@@ -135,8 +135,10 @@ extern void	affs_fix_checksum(struct sup
 extern void	secs_to_datestamp(time_t secs, struct affs_date *ds);
 extern umode_t	prot_to_mode(u32 prot);
 extern void	mode_to_prot(struct inode *inode);
+__printf(3, 4)
 extern void	affs_error(struct super_block *sb, const char *function,
 			   const char *fmt, ...);
+__printf(3, 4)
 extern void	affs_warning(struct super_block *sb, const char *function,
 			     const char *fmt, ...);
 extern bool	affs_nofilenametruncate(const struct dentry *dentry);
diff -puN fs/affs/amigaffs.c~fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf
+++ a/fs/affs/amigaffs.c
@@ -10,8 +10,6 @@
 
 #include "affs.h"
 
-static char ErrorBuffer[256];
-
 /*
  * Functions for accessing Amiga-FFS structures.
  */
@@ -444,30 +442,30 @@ mode_to_prot(struct inode *inode)
 void
 affs_error(struct super_block *sb, const char *function, const char *fmt, ...)
 {
-	va_list	 args;
-
-	va_start(args,fmt);
-	vsnprintf(ErrorBuffer,sizeof(ErrorBuffer),fmt,args);
-	va_end(args);
+	struct va_format vaf;
+	va_list args;
 
-	pr_crit("error (device %s): %s(): %s\n", sb->s_id,
-		function,ErrorBuffer);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_crit("error (device %s): %s(): %pV\n", sb->s_id, function, &vaf);
 	if (!(sb->s_flags & MS_RDONLY))
 		pr_warn("Remounting filesystem read-only\n");
 	sb->s_flags |= MS_RDONLY;
+	va_end(args);
 }
 
 void
 affs_warning(struct super_block *sb, const char *function, const char *fmt, ...)
 {
-	va_list	 args;
+	struct va_format vaf;
+	va_list args;
 
-	va_start(args,fmt);
-	vsnprintf(ErrorBuffer,sizeof(ErrorBuffer),fmt,args);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_warn("(device %s): %s(): %pV\n", sb->s_id, function, &vaf);
 	va_end(args);
-
-	pr_warn("(device %s): %s(): %s\n", sb->s_id,
-		function,ErrorBuffer);
 }
 
 bool
diff -puN fs/affs/file.c~fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf
+++ a/fs/affs/file.c
@@ -333,7 +333,8 @@ affs_get_block(struct inode *inode, sect
 
 		/* store new block */
 		if (bh_result->b_blocknr)
-			affs_warning(sb, "get_block", "block already set (%x)", bh_result->b_blocknr);
+			affs_warning(sb, "get_block", "block already set (%lx)",
+				     (unsigned long)bh_result->b_blocknr);
 		AFFS_BLOCK(sb, ext_bh, block) = cpu_to_be32(blocknr);
 		AFFS_HEAD(ext_bh)->block_count = cpu_to_be32(block + 1);
 		affs_adjust_checksum(ext_bh, blocknr - bh_result->b_blocknr + 1);
@@ -355,7 +356,8 @@ affs_get_block(struct inode *inode, sect
 	return 0;
 
 err_big:
-	affs_error(inode->i_sb,"get_block","strange block request %d", block);
+	affs_error(inode->i_sb, "get_block", "strange block request %d",
+		   (int)block);
 	return -EIO;
 err_ext:
 	// unlock cache
@@ -845,8 +847,9 @@ affs_truncate(struct inode *inode)
 	// lock cache
 	ext_bh = affs_get_extblock(inode, ext);
 	if (IS_ERR(ext_bh)) {
-		affs_warning(sb, "truncate", "unexpected read error for ext block %u (%d)",
-			     ext, PTR_ERR(ext_bh));
+		affs_warning(sb, "truncate",
+			     "unexpected read error for ext block %u (%ld)",
+			     (unsigned int)ext, PTR_ERR(ext_bh));
 		return;
 	}
 	if (AFFS_I(inode)->i_lc) {
@@ -892,8 +895,9 @@ affs_truncate(struct inode *inode)
 			struct buffer_head *bh = affs_bread_ino(inode, last_blk, 0);
 			u32 tmp;
 			if (IS_ERR(bh)) {
-				affs_warning(sb, "truncate", "unexpected read error for last block %u (%d)",
-					     ext, PTR_ERR(bh));
+				affs_warning(sb, "truncate",
+					     "unexpected read error for last block %u (%ld)",
+					     (unsigned int)ext, PTR_ERR(bh));
 				return;
 			}
 			tmp = be32_to_cpu(AFFS_DATA_HEAD(bh)->next);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

