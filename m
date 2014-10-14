From: akpm@linux-foundation.org
Subject: +
 fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch added to
 -mm tree
Date: Tue, 14 Oct 2014 13:18:09 -0700
Message-ID: <543d8501.n16BzpDQXCpKzdoU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611AbaJNUSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 16:18:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/amigaffs.c: use va_format instead of buffer/vnsprintf
has been added to the -mm tree.  Its filename is
     fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-affs-filec-forward-declaration-clean-up.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

